#!/bin/bash

# Makefile Alias Checker
#
# This script validates Makefile alias integrity across modular Makefile components.
# It ensures that all shorthand aliases (e.g., 'gs' for 'git_status') are:
# - Uniquely defined without duplicates across all files
# - Properly documented in function comments with (alias: xyz) notation
# - Correctly implemented in the # Aliases section
#
# Purpose: Prevent alias conflicts when combining multiple Makefile modules,
# maintain consistency between documentation and implementation, and ensure
# a reliable developer experience when using shorthand commands.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Temporary files to store alias data
TEMP_ALIASES=$(mktemp)
TEMP_DEFINED=$(mktemp)

# Cleanup on exit
trap "rm -f $TEMP_ALIASES $TEMP_DEFINED" EXIT

# Main script
main() {
    local search_dir="${1:-.}"
    local errors=0
    local total_files=0
    local total_aliases=0
    local total_defined=0

    echo "Searching for Makefile files in: $search_dir"
    echo ""

    # Find all Makefile-like files
    mapfile -t makefile_list < <(find "$search_dir" -type f \( -name "Makefile" -o -name "*.mk" -o -name "MAKE_*" \) 2>/dev/null | grep -v "/\.git/")

    if [[ ${#makefile_list[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No Makefile files found${NC}"
        exit 0
    fi

    # Process all files and collect aliases from comments
    for file in "${makefile_list[@]}"; do
        ((total_files++))

        # Extract aliases using grep
        while IFS=: read -r line_num line_content; do
            # Extract the alias name from (alias: xyz) format
            if [[ "$line_content" =~ \(alias:\ ([a-zA-Z0-9_]+)\) ]]; then
                alias="${BASH_REMATCH[1]}"
                echo "$alias|$file|$line_num" >> "$TEMP_ALIASES"
            fi
        done < <(grep -n "(alias:" "$file" 2>/dev/null)
    done

    # Process all files and collect defined aliases
    for file in "${makefile_list[@]}"; do
        # Check if file has an "# Aliases" section
        if grep -q "^# Aliases" "$file" 2>/dev/null; then
            # Get the line number where "# Aliases" starts
            aliases_start=$(grep -n "^# Aliases" "$file" | head -1 | cut -d: -f1)

            # Extract alias definitions after the "# Aliases" line
            while IFS=: read -r rel_line alias_def; do
                # Extract just the alias name before the colon
                alias=$(echo "$alias_def" | sed 's/:.*$//' | tr -d ' ')

                # Skip empty lines
                [[ -z "$alias" ]] && continue

                # Calculate actual line number
                line_num=$((aliases_start + rel_line))

                echo "$alias|$file|$line_num" >> "$TEMP_DEFINED"
            done < <(tail -n +$((aliases_start + 1)) "$file" | grep -n "^[a-zA-Z0-9_]*:")
        fi
    done

    # Check for duplicate aliases in comments
    if [[ -f "$TEMP_ALIASES" && -s "$TEMP_ALIASES" ]]; then
        total_aliases=$(wc -l < "$TEMP_ALIASES")

        # Sort and check for duplicates
        sort "$TEMP_ALIASES" | awk -F'|' '{
            if (seen[$1]) {
                printf "'"${RED}"'ERROR: Duplicate alias '\''%s'\'' found!'"${NC}"'\n", $1
                printf "  First: %s\n", seen[$1]
                printf "  Second: %s:%s\n", $2, $3
                errors++
            } else {
                seen[$1] = $2":"$3
            }
        } END { exit errors }' || ((errors+=$?))
    fi

    # Check for duplicate alias definitions
    if [[ -f "$TEMP_DEFINED" && -s "$TEMP_DEFINED" ]]; then
        total_defined=$(wc -l < "$TEMP_DEFINED")

        # Sort and check for duplicates
        sort "$TEMP_DEFINED" | awk -F'|' '{
            if (seen[$1]) {
                printf "'"${RED}"'ERROR: Duplicate alias definition '\''%s'\''!'"${NC}"'\n", $1
                printf "  First: %s\n", seen[$1]
                printf "  Second: %s:%s\n", $2, $3
                errors++
            } else {
                seen[$1] = $2":"$3
            }
        } END { exit errors }' || ((errors+=$?))
    fi

    # Verify consistency - check if declared aliases are defined
    if [[ -f "$TEMP_ALIASES" && -s "$TEMP_ALIASES" ]]; then
        echo "Verifying alias consistency across all files..."
        echo ""

        while IFS='|' read -r alias file line; do
            if ! grep -q "^${alias}|" "$TEMP_DEFINED" 2>/dev/null; then
                echo -e "${RED}ERROR: Alias '$alias' declared but not defined!${NC}"
                echo -e "  Declared: $file:$line"
                ((errors++))
            fi
        done < <(sort -u "$TEMP_ALIASES")

        # Check if defined aliases are documented
        if [[ -f "$TEMP_DEFINED" && -s "$TEMP_DEFINED" ]]; then
            while IFS='|' read -r alias file line; do
                if ! grep -q "^${alias}|" "$TEMP_ALIASES" 2>/dev/null; then
                    echo -e "${YELLOW}WARNING: Alias '$alias' defined but not documented${NC}"
                    echo -e "  Defined: $file:$line"
                fi
            done < <(sort -u "$TEMP_DEFINED")
        fi
    fi

    # Count unique aliases
    unique_aliases=0
    unique_defined=0
    [[ -f "$TEMP_ALIASES" && -s "$TEMP_ALIASES" ]] && unique_aliases=$(cut -d'|' -f1 "$TEMP_ALIASES" | sort -u | wc -l)
    [[ -f "$TEMP_DEFINED" && -s "$TEMP_DEFINED" ]] && unique_defined=$(cut -d'|' -f1 "$TEMP_DEFINED" | sort -u | wc -l)

    # Final summary
    echo ""
    echo "========================================"
    echo "Summary:"
    echo "  Files checked: $total_files"
    echo "  Unique aliases: $unique_aliases"
    echo "  Defined aliases: $unique_defined"
    echo "  Errors: $errors"
    echo "========================================"
    echo ""

    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✓ All checks passed!${NC}"
        exit 0
    else
        echo -e "${RED}✗ Found $errors error(s)!${NC}"
        exit 1
    fi
}

main "$@"
