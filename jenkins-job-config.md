# Jenkins Pipeline Job Configuration

## Create New Pipeline Job

1. **Go to Jenkins Dashboard**
2. **Click "New Item"**
3. **Enter job name:** `devops-project-1-pipeline`
4. **Select "Pipeline"**
5. **Click "OK"**

## Pipeline Configuration

### General Settings
- ✅ **GitHub project:** `https://github.com/DeshmukhRuturaj/devops-project-1/`

### Build Triggers (Optional)
- ✅ **GitHub hook trigger for GITScm polling** (if you want auto-builds)
- ✅ **Poll SCM:** `H/5 * * * *` (checks every 5 minutes for changes)

### Pipeline Settings
- **Definition:** `Pipeline script from SCM`
- **SCM:** `Git`
- **Repository URL:** `https://github.com/DeshmukhRuturaj/devops-project-1.git`
- **Credentials:** Select your GitHub credentials (if private repo)
- **Branches to build:** `*/main` ⚠️ **IMPORTANT: Use main, not master**
- **Script Path:** `Jenkinsfile`

### Advanced Settings (Optional)
- **Lightweight checkout:** ✅ Checked (for faster checkouts)

## Save and Test
1. Click "Save"
2. Click "Build Now"
3. Check console output for success

---

## Troubleshooting

If you still get master/main branch errors:

### Verify Repository Default Branch
```bash
git branch -a
git symbolic-ref refs/remotes/origin/HEAD
```

### Force Update Remote References (if needed)
```bash
git remote set-head origin main
git remote show origin
```