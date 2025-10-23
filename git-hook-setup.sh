#!/bin/bash

# Setup Git hooks to automatically sync work activity

echo "🔗 Setting up automatic Git hooks..."

# Create a post-commit hook for the work repository
WORK_REPO="/Users/akar/Documents/GitHub/matviews-community"
ACTIVITY_REPO="/Users/akar/Documents/GitHub/work-activity-tracker"

if [ -d "$WORK_REPO/.git" ]; then
    cat > "$WORK_REPO/.git/hooks/post-commit" << EOF
#!/bin/bash
# Auto-sync work activity after each commit
cd "$ACTIVITY_REPO"
./auto-sync.sh >/dev/null 2>&1 &
EOF
    
    chmod +x "$WORK_REPO/.git/hooks/post-commit"
    echo "✅ Added post-commit hook to matviews-community"
else
    echo "⚠️  Work repository not found at $WORK_REPO"
fi

# Create a global Git hook template
mkdir -p ~/.git-templates/hooks

cat > ~/.git-templates/hooks/post-commit << EOF
#!/bin/bash
# Auto-sync work activity (only for work repositories)
if [[ "\$(pwd)" == *"matviews-community"* ]] || [[ "\$(pwd)" == *"work"* ]]; then
    cd "$ACTIVITY_REPO"
    ./auto-sync.sh >/dev/null 2>&1 &
fi
EOF

chmod +x ~/.git-templates/hooks/post-commit

# Set Git to use the template
git config --global init.templatedir ~/.git-templates

echo "✅ Set up global Git hooks"
echo ""
echo "🎉 Automation complete!"
echo "Now every time you commit in work repositories, it will automatically sync to your GitHub profile!"
