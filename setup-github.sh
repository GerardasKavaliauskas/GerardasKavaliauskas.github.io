#!/bin/bash

echo "🚀 Setting up GitHub Pages deployment for Energy Bill Predictor"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Add all files
echo "📝 Adding files to Git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Initial commit with GitHub Pages setup"

echo ""
echo "🎯 Next steps:"
echo "1. Create a new repository on GitHub (name it 'energy-bill-predictor' or your preferred name)"
echo "2. Copy the repository URL"
echo "3. Run these commands:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. Enable GitHub Pages:"
echo "   - Go to your repository settings"
echo "   - Click 'Pages' in the sidebar"
echo "   - Source: 'GitHub Actions'"
echo "   - Your app will be deployed automatically!"
echo ""
echo "🌐 Your app will be available at:"
echo "   https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/"
echo ""
echo "📚 For detailed instructions, see: github-pages-deploy.md"
