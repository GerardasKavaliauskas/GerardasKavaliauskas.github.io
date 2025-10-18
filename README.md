# Energy Bill Predictor

A Flutter web application that helps users predict their electricity bills and compare their consumption with Lithuanian averages.

## Features

- **Bill Prediction**: Predict monthly electricity costs based on home size and appliance usage
- **Custom Appliances**: Add custom devices with specific power consumption
- **Visual Analytics**: Interactive pie charts showing device usage breakdown
- **Lithuanian Comparison**: Compare your consumption with national averages
- **AI Insights**: Get personalized energy-saving recommendations
- **Educational Content**: Learn about electricity costs and energy efficiency

## Getting Started

### Local Development

1. Make sure you have Flutter installed (version 3.24.0 or higher)
2. Clone the repository
3. Navigate to the project directory
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run -d chrome
   ```

### Deployment to Vercel

This project is configured for automatic deployment to Vercel through GitHub.

#### Setup Instructions:

1. **Push to GitHub**:
   - Create a new repository on GitHub
   - Push your code to the repository

2. **Connect to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Sign in with your GitHub account
   - Click "New Project"
   - Import your GitHub repository
   - Vercel will automatically detect it's a Flutter project

3. **Configure Build Settings**:
   - **Framework Preset**: Other
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

4. **Environment Variables** (if needed):
   - Add any required environment variables in Vercel dashboard

5. **Deploy**:
   - Click "Deploy"
   - Vercel will build and deploy your app automatically

#### Manual Deployment:

If you prefer manual deployment:

1. Build the web app:
   ```bash
   flutter build web --release
   ```

2. Deploy the `build/web` folder to Vercel

#### GitHub Actions (Optional):

The project includes a GitHub Actions workflow for automated deployment. To use it:

1. Add these secrets to your GitHub repository:
   - `VERCEL_TOKEN`: Your Vercel API token
   - `ORG_ID`: Your Vercel organization ID
   - `PROJECT_ID`: Your Vercel project ID

2. Push to the main branch to trigger automatic deployment

## Project Structure

- `lib/pages/bill_predictor/`: Main application pages
- `lib/services/`: API services and data processing
- `lib/core/`: Core models and utilities
- `web/`: Web-specific configurations

## Dependencies

- `fl_chart`: For interactive charts and graphs
- `http`: For API calls to Lithuanian electricity data
- `intl`: For internationalization and formatting

## API Integration

The app integrates with Lithuanian electricity data sources:
- Lithuanian Open Data Portal (data.gov.lt)
- ESO (Electricity System Operator)
- Statistics Lithuania

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is for educational and personal use.
