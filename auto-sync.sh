#!/bin/bash

# Automated work activity sync script
# This script automatically finds your work commits and creates corresponding activity commits

WORK_REPO_PATH="/Users/akar/Documents/GitHub/matviews-community"
ACTIVITY_REPO_PATH="/Users/akar/Documents/GitHub/work-activity-tracker"
YOUR_EMAIL="ale3karath@gmail.com"

echo "🔄 Auto-syncing work activity..."

cd "$WORK_REPO_PATH"

# Get all commits from the last 90 days with your email
echo "📊 Finding commits from the last 90 days..."
git log --since="90 days ago" --author="$YOUR_EMAIL" --pretty=format:"%H|%ad|%s" --date=iso > /tmp/work_commits.txt

# Also check other work repositories
for repo in "/Users/akar/Documents/GitHub"/*; do
    if [ -d "$repo/.git" ] && [ "$repo" != "$WORK_REPO_PATH" ] && [ "$repo" != "$ACTIVITY_REPO_PATH" ]; then
        echo "📁 Checking repository: $(basename "$repo")"
        cd "$repo"
        git log --since="90 days ago" --author="$YOUR_EMAIL" --pretty=format:"%H|%ad|%s" --date=iso >> /tmp/work_commits.txt 2>/dev/null
    fi
done

cd "$ACTIVITY_REPO_PATH"

# Remove duplicates and sort by date
sort -u /tmp/work_commits.txt | sort -t'|' -k2 > /tmp/work_commits_sorted.txt

echo "📝 Processing commits..."

# Process each commit
while IFS='|' read -r commit_hash commit_date commit_message; do
    if [ ! -z "$commit_hash" ] && [ ! -z "$commit_date" ]; then
        # Check if we already have this commit
        if ! git log --grep="$commit_message" --oneline | grep -q .; then
            echo "  ✅ Adding: $commit_message"
            
            # Create empty commit with original date
            GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
            git commit --allow-empty -m "Work activity: $commit_message" >/dev/null 2>&1
        else
            echo "  ⏭️  Skipping (already exists): $commit_message"
        fi
    fi
done < /tmp/work_commits_sorted.txt

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin master >/dev/null 2>&1

echo "✅ Auto-sync complete!"
echo "📈 Your work activity is now visible in your GitHub profile"

# Cleanup
rm -f /tmp/work_commits.txt /tmp/work_commits_sorted.txt
