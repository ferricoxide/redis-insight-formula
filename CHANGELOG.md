## CHANGELOG.md

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 0.0.1

**Released**: 2026.05.14

**Summary**:

*   Cloned project from https://github.com/plus3it/repo-template
*   Created redis-insight directory-tree contents by:
    1.   Cloning https://github.com/saltstack-formulas/template-formula.git
    2.   Executing `bin/convert-formula.sh redis-insight` in the new repo-copy
    3.   Moving the resulting `redis-insight` directory into this project's space
    4.   Updating all imports from "`redis__insight`" to "`redis_insight`"
*   Update [LICENSE](LICENSE), CHANGELOG.md (this file), [README.md](README.md) and [.bumpversion.cfg](.bumpversion.cfg) per the P3 repo-template guidance
*   Update the `.github` and `tests` directories' contents  per the P3 repo-template guidance
