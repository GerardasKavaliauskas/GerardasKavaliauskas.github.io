# Vercel Deployment Guide

This guide will help you deploy your Flutter web app to Vercel through GitHub.

## Prerequisites

- GitHub account
- Vercel account (free tier available)
- Flutter SDK installed locally (for testing)

## Step-by-Step Deployment

### 1. Prepare Your Repository

1. **Initialize Git** (if not already done):
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **Create GitHub Repository**:
   - Go to [GitHub](https://github.com)
   - Click "New repository"
   - Name it (e.g., "energy-bill-predictor")
   - Make it public or private
   - Don't initialize with README (since you already have files)

3. **Push to GitHub**:
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git branch -M main
   git push -u origin main
   ```

### 2. Deploy to Vercel

#### Option A: Automatic Deployment (Recommended)

1. **Go to Vercel**:
   - Visit [vercel.com](https://vercel.com)
   - Sign in with your GitHub account

2. **Import Project**:
   - Click "New Project"
   - Find your repository in the list
   - Click "Import"

3. **Configure Build Settings**:
   - **Framework Preset**: Other
   - **Root Directory**: `./` (leave as default)
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

4. **Deploy**:
   - Click "Deploy"
   - Wait for the build to complete (this may take 5-10 minutes)

#### Option B: Manual Deployment

1. **Build Locally**:
   ```bash
   flutter build web --release
   ```

2. **Install Vercel CLI**:
   ```bash
   npm i -g vercel
   ```

3. **Deploy**:
   ```bash
   vercel --prod
   ```

### 3. Configure Custom Domain (Optional)

1. In your Vercel dashboard, go to your project
2. Click "Settings" → "Domains"
3. Add your custom domain
4. Follow the DNS configuration instructions

## Automatic Deployments

Once connected, Vercel will automatically deploy your app whenever you push to the main branch:

```bash
git add .
git commit -m "Update app"
git push origin main
```

## Environment Variables

If your app needs environment variables:

1. Go to your Vercel project dashboard
2. Click "Settings" → "Environment Variables"
3. Add your variables (e.g., API keys)

## Troubleshooting

### Build Fails

1. **Check Flutter Version**: Ensure you're using Flutter 3.24.0+
2. **Check Dependencies**: Run `flutter pub get` locally first
3. **Check Build Logs**: Look at the Vercel build logs for specific errors

### App Doesn't Load

1. **Check Output Directory**: Ensure it's set to `build/web`
2. **Check Routes**: The `vercel.json` should handle routing correctly
3. **Check Console**: Look for JavaScript errors in browser console

### API Calls Fail

1. **CORS Issues**: Some APIs may not allow cross-origin requests
2. **HTTPS**: Ensure your APIs support HTTPS
3. **Environment Variables**: Check if API keys are properly set

## Performance Optimization

1. **Enable Compression**: Vercel automatically compresses assets
2. **CDN**: Vercel uses a global CDN for fast loading
3. **Caching**: Static assets are cached automatically

## Monitoring

1. **Analytics**: Enable Vercel Analytics in your dashboard
2. **Logs**: Check function logs in the Vercel dashboard
3. **Performance**: Monitor Core Web Vitals

## Cost

- **Free Tier**: 100GB bandwidth, unlimited deployments
- **Pro Tier**: $20/month for more bandwidth and features
- **Enterprise**: Custom pricing for large teams

## Support

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [GitHub Issues](https://github.com/vercel/vercel/issues)

## Example URLs

After deployment, your app will be available at:
- `https://your-project-name.vercel.app`
- `https://your-custom-domain.com` (if configured)
