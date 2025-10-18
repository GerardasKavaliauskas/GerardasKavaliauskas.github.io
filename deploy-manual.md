# Manual Deployment to Vercel

Since Vercel doesn't have Flutter installed by default, here's how to deploy manually:

## Step 1: Build Locally

1. Make sure you have Flutter installed locally
2. Run the build command:
   ```bash
   flutter build web --release
   ```

## Step 2: Deploy to Vercel

### Option A: Using Vercel CLI

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Navigate to your project directory:
   ```bash
   cd load_schedule-main
   ```

3. Deploy:
   ```bash
   vercel --prod
   ```

### Option B: Using Vercel Dashboard

1. Go to [vercel.com](https://vercel.com)
2. Create a new project
3. Choose "Other" as framework
4. Upload the `build/web` folder directly
5. Deploy

### Option C: Drag and Drop

1. Build your app: `flutter build web --release`
2. Go to [vercel.com](https://vercel.com)
3. Drag and drop the `build/web` folder
4. Deploy

## Step 3: Set Up Git Integration (Optional)

Once you have the basic deployment working:

1. Connect your GitHub repository to Vercel
2. Use the GitHub Actions workflow I created
3. Add the required secrets to your GitHub repository

## Required GitHub Secrets

If using GitHub Actions, add these to your repository settings:

- `VERCEL_TOKEN`: Get from Vercel dashboard → Settings → Tokens
- `ORG_ID`: Get from Vercel dashboard → Settings → General
- `PROJECT_ID`: Get from your project settings in Vercel

## Troubleshooting

- Make sure `build/web` folder exists after running `flutter build web --release`
- Check that all files in `build/web` are properly generated
- Ensure your `vercel.json` is configured correctly
