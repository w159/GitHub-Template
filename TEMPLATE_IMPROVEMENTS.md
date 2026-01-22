# Template Improvements - January 2026

This document describes improvements added to the template based on real-world PowerShell Gallery publishing experience.

## New Files Added

### CI/CD Configuration

#### `.github/workflows/ci.yml` ✨ NEW
**Comprehensive CI/CD pipeline** for automated publishing to PowerShell Gallery and GitHub Releases.

**Features:**
- Automatic version detection from git tags
- Matrix testing (Ubuntu + Windows)
- PSScriptAnalyzer validation
- Automatic publishing to PowerShell Gallery
- GitHub Release creation with release notes
- Handles both stable and prerelease versions
- Graceful handling of already-published versions

**Replaces:** The older separate `test.yml`, `publish.yml`, `analyze.yml` workflows with a unified, tag-driven pipeline.

#### `.github/workflows/pr-validation.yml` ✨ NEW
**Pull request validation** that checks:
- CHANGELOG.md has been updated
- CHANGELOG.md format (Keep a Changelog)
- Version changes (informational only)

**Why:** Ensures contributors update documentation and follow conventions.

### Build System (Sampler/ModuleBuilder)

#### `build-sampler.ps1` ✨ NEW
Modern build script using Sampler/ModuleBuilder framework.

**Advantages over old build system:**
- Industry-standard approach used by DSC and major PS modules
- Better handling of complex module structures
- Automatic CHANGELOG.md integration
- Built-in support for versioned output directories
- PlatyPS documentation generation

#### `build.yaml` ✨ NEW
Configuration file for Sampler build system.

**Defines:**
- Build workflows and task dependencies
- Pester test configuration
- PSScriptAnalyzer settings reference
- PlatyPS documentation settings
- GitHub integration for CHANGELOG

#### `RequiredModules.psd1` ✨ NEW
PSDepend configuration for build dependencies.

**Manages:**
- ModuleBuilder
- Sampler
- Pester
- PSScriptAnalyzer
- PlatyPS

#### `Resolve-Dependency.ps1` & `Resolve-Dependency.psd1` ✨ NEW
Bootstrap scripts for installing build dependencies.

**Usage:**
```powershell
./build-sampler.ps1 -ResolveDependency -Tasks build
```

### Quality & Testing

#### `PSScriptAnalyzerSettings.psd1` ✨ NEW
**Refined PSScriptAnalyzer rules** based on real module development.

**Key configurations:**
- Consistent brace placement (opening on same line, closing on new line)
- 4-space indentation
- Consistent whitespace rules
- Comment-based help requirements
- Exclusions for reasonable design decisions:
  - `PSUseSingularNouns` (e.g., `Get-Devices` is clearer than `Get-Device`)
  - Password rules (for WiFi passphrases and API keys where SecureString isn't appropriate)

#### `test-local.ps1` ✨ NEW ⭐ **IMPORTANT**
**Pre-push validation script** - Run this before every push!

**What it does:**
1. Builds the module
2. Runs PSScriptAnalyzer (catches errors in seconds)
3. Runs Pester tests

**Why:**
- Catch issues in ~30 seconds locally vs 5+ minutes in CI/CD
- Save GitHub Actions minutes
- Faster development feedback loop
- **Prevents embarrassing failed builds**

**Usage:**
```powershell
# Full validation
./test-local.ps1

# Quick check (skip tests)
./test-local.ps1 -SkipTests

# Only PSScriptAnalyzer
./test-local.ps1 -SkipBuild -SkipTests
```

### Documentation

#### `PUBLISHING.md` ✨ NEW ⭐ **START HERE**
**Complete guide for publishing PowerShell modules** to PowerShell Gallery.

**Covers:**
- Prerequisites and setup
- GitHub secrets configuration
- CI/CD pipeline explanation
- Branch strategies
- Release process (stable & prerelease)
- Troubleshooting common issues
- Quick reference commands

## Migration Path

### Option 1: Start Fresh with New Template
Recommended for new modules.

1. Copy all new files to your project
2. Update `.github/workflows/ci.yml` with your module name
3. Update `build.yaml` with your info
4. Follow [PUBLISHING.md](PUBLISHING.md) for setup

### Option 2: Upgrade Existing Module
For modules already using this template.

#### Keep Your Current Build System
If you're happy with your current build:

1. ✅ Copy CI/CD workflows:
   ```powershell
   cp .github/workflows/ci.yml <your-module>/.github/workflows/
   cp .github/workflows/pr-validation.yml <your-module>/.github/workflows/
   ```

2. ✅ Copy quality tools:
   ```powershell
   cp PSScriptAnalyzerSettings.psd1 <your-module>/
   cp test-local.ps1 <your-module>/
   ```

3. ✅ Update workflows:
   - Change `MODULE_NAME` in `ci.yml`
   - Keep your existing `build.ps1` calls

#### Switch to Sampler/ModuleBuilder
If you want to modernize your build:

1. ✅ Copy all Sampler files:
   ```powershell
   cp build-sampler.ps1 <your-module>/build.ps1
   cp build.yaml <your-module>/
   cp RequiredModules.psd1 <your-module>/
   cp Resolve-Dependency.* <your-module>/
   ```

2. ✅ Restructure source:
   ```
   Old:              New:
   src/              source/
   ├─ Public/        ├─ Public/
   ├─ Private/       ├─ Private/
   └─ Module.psd1    └─ Module.psd1
   ```

3. ✅ Update `build.yaml` configuration

4. ✅ First build:
   ```powershell
   ./build.ps1 -ResolveDependency -Tasks build
   ```

## Key Improvements Summary

### 1. Tag-Driven Publishing ⭐
**Before:** Manual version updates in multiple files
**After:** Version from git tag, one source of truth

```powershell
# Old way
# 1. Update Module.psd1: ModuleVersion = '1.0.0'
# 2. Update CHANGELOG.md
# 3. Commit and push
# 4. Manually create release

# New way
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
# CI/CD does everything automatically!
```

### 2. Local Pre-Push Validation ⭐
**Before:** Push code, wait 5 minutes for CI to fail
**After:** Validate in 30 seconds locally

```powershell
./test-local.ps1  # Catches issues before pushing
```

### 3. Prerelease Support ⭐
**Before:** No good way to do beta releases
**After:** Built-in prerelease support

```powershell
# Publish beta
git tag -a v2.0.0-beta1 -m "Beta release"
git push origin v2.0.0-beta1

# Users install with
Install-Module ModuleName -AllowPrerelease
```

### 4. Automatic GitHub Releases ⭐
**Before:** Manually create releases
**After:** Auto-created with release notes

### 5. Better Error Handling
**Before:** Cryptic CI failures
**After:** Clear messages, graceful handling

- Already-published versions don't fail the pipeline
- Permission issues have clear error messages
- Build failures point to specific issues

### 6. PSScriptAnalyzer Best Practices
**Before:** Default rules, many false positives
**After:** Refined rules based on real development

- Reasonable exclusions documented
- Consistent code style enforced
- Clear formatting rules

## Lessons Learned

### 1. Always Test Locally First
- Running `test-local.ps1` before every push saves time
- Catches 95% of issues in seconds
- GitHub Actions should be for final validation

### 2. Use Git Tags for Versions
- Single source of truth
- No version mismatch between manifest and tags
- Clear release history

### 3. Prerelease Branch Strategy
- `main` for stable releases only
- `prerelease` for active development
- Tag format determines if it's prerelease

### 4. PSScriptAnalyzer Configuration
- Some rules need exclusions for real-world code
- Document why rules are excluded
- WiFi passphrases and API keys can't always be SecureString

### 5. Workflow Permissions
- GitHub Actions needs explicit `contents: write` for releases
- Don't assume default GITHUB_TOKEN has all permissions

### 6. Handle Re-Publishing Gracefully
- Already-published versions shouldn't fail pipeline
- Allow re-running builds without errors
- Still create GitHub release even if PSGallery publish skipped

## Best Practices

### Development Workflow

```powershell
# 1. Make changes
# 2. Test locally (catch issues early)
./test-local.ps1

# 3. Commit and push
git add .
git commit -m "Add feature"
git push

# 4. Create release tag
git tag -a v1.0.0 -m "Release v1.0.0 - Added feature X"
git push origin v1.0.0

# 5. CI/CD does the rest automatically
```

### Versioning Strategy

**Semantic Versioning (SemVer):**
- `v1.0.0` - Major.Minor.Patch
- `v1.1.0` - Added features (non-breaking)
- `v1.0.1` - Bug fixes
- `v2.0.0` - Breaking changes

**Prerelease Labels:**
- `v1.1.0-alpha1` - Very early, expect breaking changes
- `v1.1.0-beta1` - Feature complete, testing needed
- `v1.1.0-rc1` - Release candidate, near stable

### CHANGELOG.md

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
## [Unreleased]
### Added
- New feature in progress

## [1.1.0] - 2026-01-22
### Added
- New feature X
### Fixed
- Bug Y

## [1.0.0] - 2026-01-21
### Initial Release
- Feature A
- Feature B
```

## Next Steps

1. **Read [PUBLISHING.md](PUBLISHING.md)** - Complete setup guide
2. **Run `test-local.ps1`** - Familiarize yourself with local testing
3. **Review `PSScriptAnalyzerSettings.psd1`** - Understand code style rules
4. **Check `.github/workflows/ci.yml`** - Understand the pipeline
5. **Practice tagging** - Try creating test releases

## Questions?

- 📖 Read [PUBLISHING.md](PUBLISHING.md) for detailed instructions
- 🐛 Found an issue? Check the Troubleshooting section
- 💡 Have suggestions? Update this template!

---

**Version:** January 2026
**Based on:** Real-world UnifiAPI module publishing experience
**Status:** Production-ready, battle-tested
