# Deploy to GitHub Pages

GitHub Pages is a free hosting service that works great with Flutter web apps.

## Method 1: Automatic Deployment (Recommended)

### Step 1: Push to GitHub

1. **Initialize Git** (if not already done):
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **Create GitHub Repository**:
   - Go to [GitHub](https://github.com)
   - Click "New repository"
   - Name it `energy-bill-predictor` (or any name you prefer)
   - Make it public
   - Don't initialize with README

3. **Push to GitHub**:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/energy-bill-predictor.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Enable GitHub Pages

1. **Go to Repository Settings**:
   - In your GitHub repository, click "Settings"
   - Scroll down to "Pages" section

2. **Configure Pages**:
   - Source: "GitHub Actions"
   - This will use the workflow I created

3. **Deploy**:
   - The workflow will automatically run when you push to main
   - Your app will be available at: `https://YOUR_USERNAME.github.io/energy-bill-predictor/`

## Method 2: Manual Deployment

### Step 1: Build Locally

1. **Build with correct base href**:
   ```bash
   flutter build web --release --base-href "/energy-bill-predictor/"
   ```

2. **Create gh-pages branch**:
   ```bash
   git checkout --orphan gh-pages
   git rm -rf .
   cp -r build/web/* .
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

### Step 2: Enable Pages

1. **Go to Repository Settings**:
   - Click "Settings" → "Pages"
   - Source: "Deploy from a branch"
   - Branch: "gh-pages"
   - Folder: "/ (root)"

## Method 3: Using GitHub CLI (Advanced)

1. **Install GitHub CLI**:
   ```bash
   # macOS
   brew install gh
   
   # Windows
   winget install GitHub.cli
   ```

2. **Deploy**:
   ```bash
   flutter build web --release --base-href "/energy-bill-predictor/"
   gh-pages -d build/web
   ```

## Important Notes

### Base Href
- Always use `--base-href "/YOUR_REPO_NAME/"` when building
- Replace `YOUR_REPO_NAME` with your actual repository name
- This ensures all assets load correctly

### Repository Name
- If your repo is named `energy-bill-predictor`, your app will be at:
  `https://YOUR_USERNAME.github.io/energy-bill-predictor/`
- If your repo is named `my-app`, your app will be at:
  `https://YOUR_USERNAME.github.io/my-app/`

### Custom Domain (Optional)
- You can add a custom domain in GitHub Pages settings
- Add a `CNAME` file to your repository root

## Troubleshooting

### 404 Errors
- Make sure you're using the correct base href
- Check that your repository name matches the base href

### Assets Not Loading
- Ensure all files in `build/web` are committed
- Check browser console for specific errors

### Workflow Not Running
- Make sure GitHub Actions are enabled in repository settings
- Check the "Actions" tab for workflow status

## Benefits of GitHub Pages

- ✅ **Free hosting**
- ✅ **Automatic HTTPS**
- ✅ **Custom domains**
- ✅ **Automatic deployments**
- ✅ **No build limits**
- ✅ **Global CDN**

## Example URLs

After deployment, your app will be available at:
- `https://YOUR_USERNAME.github.io/energy-bill-predictor/`
- `https://your-custom-domain.com` (if configured)
