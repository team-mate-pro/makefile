/**
 * @team-mate-pro/make
 *
 * Modular Makefile snippets for Symfony 7 and Nuxt 3 projects
 * with Docker Compose integration.
 *
 * This package provides standardized development workflows including:
 * - Git operations (rebase, push with --force-with-lease)
 * - Docker Compose commands
 * - Symfony 7 operations (cache, migrations, testing, QA)
 * - Nuxt 3 operations (dev, build, testing, QA)
 * - PHP tools (PHPStan, PHPCS, PHPUnit)
 * - Frontend tools (Vitest, Playwright, ESLint)
 *
 * @see https://github.com/team-mate-pro/make
 */

const path = require('path');

module.exports = {
  /**
   * Get the absolute path to a Makefile module
   * @param {string} modulePath - Path relative to package root (e.g., 'git/MAKE_GIT_v1')
   * @returns {string} Absolute path to the module
   */
  getModulePath: function(modulePath) {
    return path.join(__dirname, modulePath);
  },

  /**
   * Available module paths
   */
  modules: {
    git: 'git/MAKE_GIT_v1',
    docker: 'docker/MAKE_DOCKER_v1',
    symfony: 'sf-7/MAKE_SYMFONY_v1',
    phpcs: 'phpcs/MAKE_PHPCS_v1',
    phpstan: 'phpstan/MAKE_PHPSTAN_v1',
    phpunit: 'phpunit/MAKE_PHPUNIT_v1',
    nuxt: 'nuxt-3/MAKE_NUXT_v1',
    nuxtTests: 'nuxt-3/MAKE_NUXT_TESTS_v1',
    nuxtQA: 'nuxt-3/MAKE_NUXT_QA_v1',
    claude: 'claude/MAKE_CLAUDE_v1'
  },

  /**
   * Package version
   */
  version: require('./package.json').version
};
