#!/bin/bash

# Script to sync work activity to personal GitHub profile
# This creates empty commits with the same dates as your work commits

WORK_REPO_PATH="/Users/akar/Documents/GitHub/matviews-community"
ACTIVITY_REPO_PATH="/Users/akar/Documents/GitHub/work-activity-tracker"

echo "Syncing work activity from $WORK_REPO_PATH to $ACTIVITY_REPO_PATH"

cd "$WORK_REPO_PATH"

# Get commits from the last 30 days with your personal email
git log --since="30 days ago" --author="ale3karath@gmail.com" --pretty=format:"%H|%ad|%s" --date=iso > /tmp/work_commits.txt

cd "$ACTIVITY_REPO_PATH"

# Process each commit
while IFS='|' read -r commit_hash commit_date commit_message; do
    if [ ! -z "$commit_hash" ]; then
        # Extract just the date part (YYYY-MM-DD)
        date_only=$(echo "$commit_date" | cut -d' ' -f1)
        
        # Create an empty commit with the same date and message
        echo "Syncing commit from $date_only: $commit_message"
        
        # Create a simple activity log entry
        echo "- $date_only: $commit_message" >> activity-log.md
        
        # Add and commit with the original date
        git add activity-log.md
        GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
        git commit -m "Work activity: $commit_message" --allow-empty
    fi
done < /tmp/work_commits.txt

echo "Activity sync complete!"
echo "Run 'git push origin main' to push to your personal GitHub repository"
