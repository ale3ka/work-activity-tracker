#!/bin/bash

# Setup automation for work activity tracking

ACTIVITY_REPO_PATH="/Users/akar/Documents/GitHub/work-activity-tracker"

echo "🔧 Setting up work activity automation..."

# Create a simple command you can run anytime
cat > /usr/local/bin/sync-work-activity << 'EOF'
#!/bin/bash
cd /Users/akar/Documents/GitHub/work-activity-tracker
./auto-sync.sh
EOF

chmod +x /usr/local/bin/sync-work-activity

echo "✅ Created command: sync-work-activity"
echo ""
echo "🚀 Usage:"
echo "  sync-work-activity    # Run anytime to sync your work activity"
echo ""
echo "📅 To run automatically every day at 6 PM, add this to your crontab:"
echo "  0 18 * * * /Users/akar/Documents/GitHub/work-activity-tracker/auto-sync.sh"
echo ""
echo "💡 Or just run 'sync-work-activity' whenever you want to update your profile!"
