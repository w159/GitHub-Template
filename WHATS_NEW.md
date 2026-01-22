# What's New in This Template

## 🎉 Major Enhancements (January 2026)

### 🚀 Automated Publishing Pipeline
- **Tag-driven releases** - Just push a tag, CI/CD handles everything
- **PowerShell Gallery** - Auto-publish on tag
- **GitHub Releases** - Auto-created with release notes
- **Prerelease support** - Beta, RC, Alpha versions

### ⚡ Local Pre-Push Validation
- **`test-local.ps1`** - Catch issues in 30 seconds, not 5 minutes
- **Same checks as CI** - Build, Test, Analyze
- **Save time & CI minutes**

### 📋 Production-Ready Configuration
- **PSScriptAnalyzer** - Refined rules from real module development
- **Sampler/ModuleBuilder** - Modern build system option
- **Comprehensive tests** - Pester + PSScriptAnalyzer

### 📖 Complete Documentation
- **[PUBLISHING.md](PUBLISHING.md)** - Step-by-step publishing guide ⭐ START HERE
- **[TEMPLATE_IMPROVEMENTS.md](TEMPLATE_IMPROVEMENTS.md)** - What changed and why
- **Clear troubleshooting** - Common issues and solutions

## Quick Links

| Document | Purpose |
|----------|---------|
| **[PUBLISHING.md](PUBLISHING.md)** | **📖 Complete guide to publishing modules** |
| [TEMPLATE_IMPROVEMENTS.md](TEMPLATE_IMPROVEMENTS.md) | What's new and migration guide |
| [TEMPLATE_USAGE.md](TEMPLATE_USAGE.md) | Original template documentation |
| [test-local.ps1](test-local.ps1) | Pre-push validation script |
| [PSScriptAnalyzerSettings.psd1](PSScriptAnalyzerSettings.psd1) | Code style rules |

## New Files

### Must-Have
- ✅ `.github/workflows/ci.yml` - Main CI/CD pipeline
- ✅ `.github/workflows/pr-validation.yml` - PR checks
- ✅ `test-local.ps1` - Local validation (USE THIS!)
- ✅ `PSScriptAnalyzerSettings.psd1` - Code quality rules
- ✅ `PUBLISHING.md` - Your guide to publishing

### Modern Build System (Optional)
- `build-sampler.ps1` - Sampler build script
- `build.yaml` - Build configuration
- `RequiredModules.psd1` - Build dependencies
- `Resolve-Dependency.ps1` - Dependency bootstrap

## Quick Start

### For New Modules

```powershell
# 1. Copy template to your module directory
cp -r GitHub-Template/* MyNewModule/

# 2. Update module name in ci.yml
# Change: MODULE_NAME: UnifiAPI
# To: MODULE_NAME: MyNewModule

# 3. Read the publishing guide
# Open: PUBLISHING.md

# 4. Follow the setup steps
# - Configure GitHub secret (PSGallery API key)
# - Update module manifest
# - Update CHANGELOG.md

# 5. Before every commit
./test-local.ps1
```

### For Existing Modules

```powershell
# Copy just the essentials
cp GitHub-Template/.github/workflows/ci.yml .github/workflows/
cp GitHub-Template/.github/workflows/pr-validation.yml .github/workflows/
cp GitHub-Template/test-local.ps1 .
cp GitHub-Template/PSScriptAnalyzerSettings.psd1 .
cp GitHub-Template/PUBLISHING.md .

# Update MODULE_NAME in ci.yml
# Then read PUBLISHING.md for setup
```

## Key Improvements

### Before
```powershell
# Manual process
1. Update version in module manifest
2. Update CHANGELOG.md
3. Build locally
4. Run tests
5. Run PSScriptAnalyzer
6. Commit and push
7. Create GitHub release manually
8. Publish to PSGallery manually
9. Hope everything worked
```

### After
```powershell
# Automated workflow
./test-local.ps1              # Validate locally
git tag -a v1.0.0 -m "Desc"  # Create tag
git push origin v1.0.0        # Push tag
# CI/CD does everything else! ✨
```

## Common Commands

```powershell
# Local validation (before every push!)
./test-local.ps1

# Quick PSScriptAnalyzer check
./test-local.ps1 -SkipBuild -SkipTests

# Release stable version
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Release prerelease
git tag -a v1.1.0-beta1 -m "Beta release"
git push origin v1.1.0-beta1
```

## Why These Changes?

**Based on real-world experience publishing UnifiAPI:**
- ❌ Hit PSScriptAnalyzer errors after pushing (5 times!)
- ❌ Forgot to update CHANGELOG.md
- ❌ GitHub release permissions were wrong
- ❌ Re-publishing same version failed pipeline
- ❌ No good way to do prerelease testing

**Now all fixed!** ✅
- ✅ `test-local.ps1` catches 95% of issues before push
- ✅ PR validation reminds about CHANGELOG
- ✅ Workflow has correct permissions
- ✅ Gracefully handles already-published versions
- ✅ Built-in prerelease support

## Next Steps

1. **📖 Read [PUBLISHING.md](PUBLISHING.md)** - Complete setup guide
2. **🧪 Try `./test-local.ps1`** - See local validation in action
3. **🏷️ Practice with tags** - Create test releases
4. **📝 Update your CHANGELOG** - Follow Keep a Changelog format
5. **🚀 Publish!** - Push a tag and watch CI/CD work

---

**Updated:** January 2026
**Battle-tested** on UnifiAPI module
**Ready for production** ✅
