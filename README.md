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

### Deployment Options

This project supports multiple deployment options:

#### Option 1: GitHub Pages (Recommended - Free)

1. **Push to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/energy-bill-predictor.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository settings
   - Click "Pages" in the sidebar
   - Source: "GitHub Actions"
   - The workflow will automatically deploy your app

3. **Your app will be live at**:
   `https://YOUR_USERNAME.github.io/energy-bill-predictor/`

#### Option 2: Vercel

1. **Build locally**:
   ```bash
   flutter build web --release
   ```

2. **Deploy to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Upload the `build/web` folder directly
   - Deploy

#### Option 3: Netlify

1. **Build locally**:
   ```bash
   flutter build web --release
   ```

2. **Deploy to Netlify**:
   - Go to [netlify.com](https://netlify.com)
   - Drag and drop the `build/web` folder
   - Deploy

#### Manual Deployment:

For any platform, build first:
```bash
flutter build web --release
```

Then deploy the `build/web` folder to your chosen platform.

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
