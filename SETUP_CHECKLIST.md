# Setup Checklist for New PowerShell Module

Use this checklist when creating a new PowerShell module for publishing to PowerShell Gallery.

## Prerequisites

- [ ] PowerShell 7.0+  installed
- [ ] Git installed
- [ ] GitHub account created
- [ ] PowerShell Gallery account created

## PowerShell Gallery Setup

- [ ] Login to [PowerShell Gallery](https://www.powershellgallery.com)
- [ ] Navigate to Account → API Keys
- [ ] Create new API key with "Push" permission
- [ ] **Save API key securely** (you can't view it again!)

## GitHub Repository Setup

- [ ] Create new repository on GitHub: `https://github.com/new`
  - Repository name: Your module name
  - Description: Short module description
  - Public or Private (Public recommended for open source)
  - Initialize with README: No (using template)
  - License: Choose appropriate license

- [ ] Clone repository locally:
  ```powershell
  git clone https://github.com/username/ModuleName.git
  cd ModuleName
  ```

## Copy Template Files

- [ ] Copy all template files to your new module directory
  ```powershell
  cp -r C:\_Code\GitHub-Template/* ./
  # Or manually copy files
  ```

## Configure GitHub Secret

### Repository Level (Easiest)

- [ ] Go to: `https://github.com/username/ModuleName/settings/secrets/actions`
- [ ] Click "New repository secret"
- [ ] Name: `PSGALLERY_API_KEY`
- [ ] Value: Paste your API key from PowerShell Gallery
- [ ] Click "Add secret"

### Organization Level (Reusable - Optional)

- [ ] Convert personal account to organization (if desired)
- [ ] Go to: `https://github.com/organizations/orgname/settings/secrets/actions`
- [ ] Add `PSGALLERY_API_KEY` once
- [ ] All org repos automatically inherit it

## Update Module Files

### 1. Module Manifest (`source/ModuleName.psd1`)

- [ ] Rename file to match your module name
- [ ] Update these fields:
  ```powershell
  @{
      ModuleVersion = '1.0.0'
      GUID = '<generate new GUID>'  # Use: [guid]::NewGuid()
      Author = 'Your Name'
      CompanyName = 'Your Company'
      Description = 'Clear, concise description'

      Tags = @('Tag1', 'Tag2', 'Tag3')  # For PSGallery search
      ProjectUri = 'https://github.com/username/ModuleName'
      LicenseUri = 'https://github.com/username/ModuleName/blob/main/LICENSE'

      ReleaseNotes = @'
  ## Version 1.0.0
  - Initial release
  - Feature 1
  - Feature 2
  '@
  }
  ```

### 2. CI/CD Workflow (`.github/workflows/ci.yml`)

- [ ] Update module name:
  ```yaml
  env:
    MODULE_NAME: YourModuleName  # Change this!
  ```

### 3. Build Configuration (`build.yaml`)

- [ ] Update Git config:
  ```yaml
  GitHubConfig:
    GitHubConfigUserName: yourusername
    GitHubConfigUserEmail: you@example.com
  ```

### 4. CHANGELOG.md

- [ ] Update with initial release:
  ```markdown
  # Changelog

  ## [Unreleased]

  ## [1.0.0] - YYYY-MM-DD

  ### Initial Release
  - Feature 1
  - Feature 2
  - Feature 3
  ```

### 5. README.md

- [ ] Update with your module information:
  - Module description
  - Installation instructions
  - Usage examples
  - Contributing guidelines

### 6. LICENSE

- [ ] Review and update if needed
- [ ] Ensure it matches your LicenseUri

## Write Your Module

- [ ] Create functions in `source/Public/`
- [ ] Create helper functions in `source/Private/`
- [ ] Add comment-based help to all functions
- [ ] Follow PowerShell best practices

## Test Locally

- [ ] Install build dependencies:
  ```powershell
  ./build.ps1 -ResolveDependency -Tasks noop
  ```

- [ ] Run local validation:
  ```powershell
  ./test-local.ps1
  ```

- [ ] Fix any issues found
- [ ] Re-run until all checks pass

## Write Tests

- [ ] Create Pester tests in `tests/Unit/`
- [ ] Test all public functions
- [ ] Aim for >80% code coverage
- [ ] Run tests: `./build.ps1 -Tasks test`

## Commit and Push

- [ ] Add files to git:
  ```powershell
  git add .
  ```

- [ ] Create initial commit:
  ```powershell
  git commit -m "Initial commit - ModuleName v1.0.0"
  ```

- [ ] Push to GitHub:
  ```powershell
  git push -u origin main
  ```

- [ ] Verify CI workflow runs (it won't publish without a tag)

## Create Release

- [ ] Verify all checks passed on main branch
- [ ] Create release tag:
  ```powershell
  git tag -a v1.0.0 -m "Release v1.0.0 - Initial public release"
  ```

- [ ] Push tag:
  ```powershell
  git push origin v1.0.0
  ```

- [ ] Watch CI/CD pipeline: `https://github.com/username/ModuleName/actions`

## Verify Release

- [ ] Check GitHub Actions completed successfully
- [ ] Verify module on PowerShell Gallery:
  ```
  https://www.powershellgallery.com/packages/ModuleName
  ```

- [ ] Check GitHub Release created:
  ```
  https://github.com/username/ModuleName/releases/tag/v1.0.0
  ```

- [ ] Test installation:
  ```powershell
  Install-Module -Name ModuleName
  Import-Module ModuleName
  Get-Command -Module ModuleName
  ```

## Setup Prerelease Branch (Optional)

- [ ] Create prerelease branch:
  ```powershell
  git checkout -b prerelease
  git push -u origin prerelease
  ```

- [ ] Document branching strategy in README

## Post-Release

- [ ] Announce release (Twitter, Reddit, blog, etc.)
- [ ] Monitor for issues/feedback
- [ ] Plan next release features
- [ ] Update documentation as needed

## Common Issues Checklist

If something goes wrong, check:

- [ ] GitHub secret `PSGALLERY_API_KEY` is set correctly
- [ ] Module name in `ci.yml` matches actual module name
- [ ] All tests pass locally (`./test-local.ps1`)
- [ ] CHANGELOG.md is updated
- [ ] Tag format is correct (`v1.0.0` not `1.0.0`)
- [ ] CI workflow has `contents: write` permission

## Resources

- [ ] Bookmark [PUBLISHING.md](PUBLISHING.md) - Your reference guide
- [ ] Join PowerShell Slack/Discord for help
- [ ] Read [PowerShell Gallery Best Practices](https://learn.microsoft.com/powershell/gallery)
- [ ] Check [Keep a Changelog](https://keepachangelog.com/)
- [ ] Review [Semantic Versioning](https://semver.org/)

---

## Quick Command Reference

```powershell
# Validate before pushing
./test-local.ps1

# Build
./build.ps1 -Tasks build

# Test
./build.ps1 -Tasks test

# Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Tag prerelease
git tag -a v1.1.0-beta1 -m "Beta release"
git push origin v1.1.0-beta1
```

---

**✅ Checklist complete?** You're ready to publish! 🚀
