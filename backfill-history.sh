#!/bin/bash

# One-time script to backfill work activity from previous years
# This will scan ALL your work repositories for historical commits

WORK_REPO_PATH="/Users/akar/Documents/GitHub/matviews-community"
ACTIVITY_REPO_PATH="/Users/akar/Documents/GitHub/work-activity-tracker"
YOUR_EMAIL="ale3karath@gmail.com"

echo "🔄 Backfilling work activity from previous years..."
echo "⚠️  This is a one-time operation to capture historical commits"
echo ""

cd "$WORK_REPO_PATH"

# Get ALL commits with your email (no date limit)
echo "📊 Scanning ALL commits from matviews-community..."
git log --all --author="$YOUR_EMAIL" --pretty=format:"%H|%ad|%s" --date=iso > /tmp/work_commits_all.txt

# Also check other work repositories
echo "📁 Scanning other work repositories..."
for repo in "/Users/akar/Documents/GitHub"/*; do
    if [ -d "$repo/.git" ] && [ "$repo" != "$WORK_REPO_PATH" ] && [ "$repo" != "$ACTIVITY_REPO_PATH" ]; then
        echo "  📁 Checking: $(basename "$repo")"
        cd "$repo"
        git log --all --author="$YOUR_EMAIL" --pretty=format:"%H|%ad|%s" --date=iso >> /tmp/work_commits_all.txt 2>/dev/null
    fi
done

cd "$ACTIVITY_REPO_PATH"

# Remove duplicates and sort by date
sort -u /tmp/work_commits_all.txt | sort -t'|' -k2 > /tmp/work_commits_all_sorted.txt

echo ""
echo "📊 Found $(wc -l < /tmp/work_commits_all_sorted.txt) total commits"
echo ""

# Show date range
if [ -s /tmp/work_commits_all_sorted.txt ]; then
    first_date=$(head -1 /tmp/work_commits_all_sorted.txt | cut -d'|' -f2 | cut -d' ' -f1)
    last_date=$(tail -1 /tmp/work_commits_all_sorted.txt | cut -d'|' -f2 | cut -d' ' -f1)
    echo "📅 Date range: $first_date to $last_date"
    echo ""
fi

echo "📝 Processing commits..."

# Process each commit
processed=0
skipped=0

while IFS='|' read -r commit_hash commit_date commit_message; do
    if [ ! -z "$commit_hash" ] && [ ! -z "$commit_date" ]; then
        # Check if we already have this commit
        if ! git log --grep="$commit_message" --oneline | grep -q .; then
            echo "  ✅ Adding: $commit_message"
            
            # Create empty commit with original date
            GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
            git commit --allow-empty -m "Work activity: $commit_message" >/dev/null 2>&1
            
            ((processed++))
        else
            echo "  ⏭️  Skipping (already exists): $commit_message"
            ((skipped++))
        fi
    fi
done < /tmp/work_commits_all_sorted.txt

echo ""
echo "📊 Summary:"
echo "  ✅ Processed: $processed new commits"
echo "  ⏭️  Skipped: $skipped existing commits"
echo ""

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin master

echo ""
echo "✅ Backfill complete!"
echo "📈 Your historical work activity is now visible in your GitHub profile"
echo ""
echo "💡 For future runs, use: ./auto-sync.sh (90-day incremental sync)"

# Cleanup
rm -f /tmp/work_commits_all.txt /tmp/work_commits_all_sorted.txt
