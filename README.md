# Work Activity Tracker

This repository automatically tracks my work contributions for GitHub profile visibility.

## Purpose
This repository contains commit activity from my work projects to ensure they appear in my personal GitHub contribution graph, while keeping the actual work code in the appropriate work repositories.

## Work Projects
- HelloFresh Data Engineering projects
- Materialized Views and Data Pipelines
- Analytics and Business Intelligence work

## Automation Options

### Option 1: One-Time Historical Backfill
```bash
# Run once to capture ALL your historical work commits
./backfill-history.sh
```

### Option 2: Ongoing Sync (90 days)
```bash
# For regular ongoing sync of recent commits
./auto-sync.sh
```

### Option 3: Command Line Tool
```bash
# Setup once
./setup-automation.sh

# Then use anytime
sync-work-activity
```

### Option 4: Automatic Git Hooks (Fully Automated)
```bash
# Setup once - automatically syncs after every work commit
./git-hook-setup.sh
```

### Option 5: Daily Cron Job
Add to crontab for daily sync at 6 PM:
```bash
0 18 * * * /Users/akar/Documents/GitHub/work-activity-tracker/auto-sync.sh
```

## Note
This repository contains only activity logs and metadata - the actual work code remains in the respective work repositories.
