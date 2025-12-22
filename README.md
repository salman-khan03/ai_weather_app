# WeatherApp - AI-Powered Weather Application

A modern, full-stack weather application built with Next.js 14, featuring real-time weather data, AI-powered insights, and comprehensive user authentication.

![WeatherApp](https://img.shields.io/badge/Next.js-14-black?style=flat-square&logo=next.js)
![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue?style=flat-square&logo=typescript)
![WeatherAPI](https://img.shields.io/badge/WeatherAPI-Integrated-orange?style=flat-square)
![Claude AI](https://img.shields.io/badge/Claude_AI-Powered-purple?style=flat-square)

## 🌟 Features

### Weather Features
- 🌤️ **Real-time Weather Data** - Accurate 7-day forecasts using WeatherAPI.com
- 📊 **24-Hour Hourly Forecast** - Detailed hour-by-hour predictions
- 🗺️ **Global Location Search** - Search any city worldwide
- 💾 **Saved Locations** - Save and manage multiple favorite locations
- ⚠️ **Weather Alerts** - Severe weather warnings and notifications
- 📍 **Auto-Location Detection** - Automatically fetch weather for your location

### AI Features
- 🤖 **AI-Powered Insights** - Claude AI generates personalized weather analysis
- 💡 **Smart Recommendations** - Activity suggestions based on conditions
- 🎯 **Contextual Advice** - What to wear, when to go out, and more

### User Features
- 🔐 **User Authentication** - Sign up and sign in functionality
- 👤 **User Profiles** - Personalized experience with saved preferences
- 📱 **Responsive Design** - Beautiful UI on all devices
- 🎨 **Modern UI** - Glassmorphism design with smooth animations

### Additional Pages
- 🏠 **Home/Dashboard** - Main weather interface
- 📖 **About Page** - Learn about the app and technology
- 🔑 **Sign In/Sign Up** - User authentication pages
- 🚫 **Custom 404** - Friendly error page

## 🛠️ Tech Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript 5.3
- **Styling**: Tailwind CSS
- **State Management**: Zustand
- **Icons**: Lucide React
- **HTTP Client**: Axios

### Backend & APIs
- **Weather API**: WeatherAPI.com (7-day forecast)
- **AI Service**: Google Gemini AI (gemini-pro model)
- **Database**: Supabase (PostgreSQL)
- **Places API**: Google Places (optional)
- **Deployment**: Vercel-ready

## 📋 Prerequisites

- Node.js 18+ and npm
- WeatherAPI account and API key
- Supabase account (for database)
- Google API key (for Gemini AI and Places API)
- Google Places API enabled (for enhanced search - optional)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd Weather-app-main
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Setup

Create a `.env.local` file in the root directory:

```env
# Weather API (Required)
NEXT_PUBLIC_WEATHERAPI_KEY=your_weatherapi_key_here

# Google API Key (for both Gemini AI and Places API)
# Note: If both GEMINI_API_KEY and GOOGLE_API_KEY are set, GOOGLE_API_KEY takes precedence
GOOGLE_API_KEY=your_google_api_key_here

# Or use separate keys (optional)
# GEMINI_API_KEY=your_gemini_api_key_here
# NEXT_PUBLIC_GOOGLE_PLACES_API_KEY=your_google_places_api_key_here

# Supabase Configuration (Required for database features)
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

# App URL
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Database Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. In the SQL Editor, run the following schema:

```sql
-- Create saved_locations table
CREATE TABLE IF NOT EXISTS saved_locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  country TEXT,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  is_favorite BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, lat, lon)
);

-- Create weather_history table
CREATE TABLE IF NOT EXISTS weather_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  location_id UUID REFERENCES saved_locations(id) ON DELETE CASCADE,
  temperature DECIMAL(5, 2) NOT NULL,
  condition TEXT NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ai_insights table
CREATE TABLE IF NOT EXISTS ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  location_id UUID NOT NULL,
  insight TEXT NOT NULL,
  suggestions TEXT[] DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_saved_locations_user_id ON saved_locations(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_locations_is_favorite ON saved_locations(is_favorite);
CREATE INDEX IF NOT EXISTS idx_weather_history_user_id ON weather_history(user_id);
CREATE INDEX IF NOT EXISTS idx_weather_history_location_id ON weather_history(location_id);
CREATE INDEX IF NOT EXISTS idx_ai_insights_user_id ON ai_insights(user_id);
```

### 5. Run the Application

**Development Mode:**
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) (or port shown in terminal)

**Production Build:**
```bash
npm run build
npm start
```

## 📁 Project Structure

```
Weather-app-main/
├── src/
│   ├── app/
│   │   ├── api/              # API routes
│   │   │   ├── history/      # Weather history endpoints
│   │   │   ├── locations/    # Location CRUD endpoints
│   │   │   └── weather/      # Weather & AI insight endpoints
│   │   ├── about/            # About page
│   │   ├── signin/           # Sign in page
│   │   ├── signup/           # Sign up page
│   │   ├── layout.tsx        # Root layout with metadata
│   │   ├── page.tsx          # Main dashboard
│   │   ├── not-found.tsx     # Custom 404 page
│   │   └── globals.css       # Global styles
│   ├── components/           # React components
│   │   ├── Header.tsx        # Navigation header
│   │   ├── CurrentWeather.tsx
│   │   ├── WeatherDetails.tsx
│   │   ├── ForecastCard.tsx
│   │   ├── SearchBar.tsx
│   │   ├── SavedLocations.tsx
│   │   └── AIInsight.tsx
│   ├── lib/
│   │   ├── api.ts           # WeatherAPI client
│   │   ├── supabase.ts      # Database operations
│   │   └── ai.ts            # Claude AI service
│   ├── store/
│   │   └── weatherStore.ts  # Zustand state management
│   └── types/
│       └── index.ts         # TypeScript definitions
├── database.sql             # Database schema
├── package.json
├── tailwind.config.ts
├── next.config.js
└── tsconfig.json
```

## 🔑 API Keys Setup

### WeatherAPI (Required)
1. Sign up at [weatherapi.com](https://www.weatherapi.com/)
2. Get your free API key from the dashboard
3. Add to `.env.local` as `NEXT_PUBLIC_WEATHERAPI_KEY`

### Google API Key (Required for AI Insights)

**Option 1: Using GOOGLE_API_KEY (Recommended)**
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create or select a project
3. Generate an API key
4. Enable **Generative Language API** (for Gemini)
5. Optionally enable **Places API** (for location search)
6. Add to `.env.local` as `GOOGLE_API_KEY`

**Option 2: Using GEMINI_API_KEY**
1. Same steps as above
2. Add to `.env.local` as `GEMINI_API_KEY`

**Note**: If both `GEMINI_API_KEY` and `GOOGLE_API_KEY` are set, `GOOGLE_API_KEY` takes precedence.

The same API key can be used for both Gemini AI insights and Google Places autocomplete if both APIs are enabled in your Google Cloud project.

## 💡 Usage Guide

### Basic Usage
1. **Auto-Location**: App automatically detects your location and shows weather
2. **Search**: Use the search bar to find any city worldwide
3. **View Details**: See current weather, 7-day forecast, and hourly predictions
4. **Save Locations**: Add frequently checked locations to favorites

### Authentication
1. **Sign Up**: Create an account at `/signup`
2. **Sign In**: Log in at `/signin`
3. **Profile**: View your name in the header when logged in

### AI Insights
1. Click "Generate AI Insight" button
2. Wait for Claude AI to analyze current conditions
3. Receive personalized weather insights and suggestions
4. Regenerate for updated recommendations

## 🎨 Features Breakdown

### Weather Data Display
- Current temperature with "feels like"
- Weather condition with emoji icons
- High/Low temperatures for the day
- Wind speed, direction, and gusts
- Humidity percentage
- Visibility distance
- UV index
- Cloud coverage
- Atmospheric pressure

### Forecast Views
- **7-Day Forecast**: Daily weather cards with highs/lows
- **24-Hour Forecast**: Hourly temperature and conditions
- **Weather Alerts**: Severe weather warnings when available

### Smart Features
- **Quick Stats Widget**: Key metrics at a glance
- **Saved Locations Panel**: Manage favorite places
- **Weather History**: Track past conditions (with database)
- **AI Recommendations**: Activity suggestions based on weather

## 🚀 Deployment

### Deploy to Vercel (Recommended)

1. Push to GitHub:
```bash
git init
git add .
git commit -m "Initial commit"
git push origin main
```

2. Import to Vercel:
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Add environment variables
   - Deploy!

3. Configure Environment Variables in Vercel:
   - Add all variables from `.env.local`
   - Update `NEXT_PUBLIC_APP_URL` to your Vercel domain

## 🔧 Configuration

### Tailwind CSS Classes
Custom utility classes available:
- `.card` - Glassmorphic card with backdrop blur
- `.btn-primary` - Primary button styling
- `.btn-secondary` - Secondary button styling
- `.input-field` - Styled input field
- `.bg-gradient-primary` - App gradient background

### Weather Icons
Weather conditions are mapped to emoji icons:
- ☀️ Clear/Sunny
- ☁️ Cloudy/Overcast
- 🌧️ Rain
- ⛈️ Thunderstorm
- ❄️ Snow
- 🌫️ Fog/Mist
- 🌤️ Default/Partly Cloudy

## 🐛 Troubleshooting

### Weather not loading
- Check `NEXT_PUBLIC_WEATHERAPI_KEY` is correct
- Verify API key is active at weatherapi.com
- Check browser console for error messages

### AI Insights not working
- Verify `ANTHROPIC_API_KEY` is set
- Check API quota at console.anthropic.com
- Review server logs for detailed errors

### Database issues
- Confirm Supabase credentials are correct
- Verify database tables exist (run `database.sql`)
- Check Supabase dashboard for connection issues

### Search not finding cities
- Ensure WeatherAPI key has search permissions
- Try searching with country code (e.g., "London, UK")

## 📈 Performance

- ⚡ Next.js 14 App Router for optimal performance
- 🎯 Code splitting and lazy loading
- 🗄️ Efficient state management with Zustand
- 📦 Optimized production builds
- 🔄 Automatic hot reloading in development

## 🔒 Security

- Environment variables for sensitive data
- Server-side API key storage (Anthropic)
- Client-side keys scoped with NEXT_PUBLIC prefix
- HTTPS enforced in production
- Input validation on all forms
- SQL injection protection with Supabase

## 📝 License

MIT License - Free to use for personal and commercial projects.

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📧 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Email: contact@weatherapp.com
- Check the About page in the app

## 🎉 Acknowledgments

- **WeatherAPI.com** for weather data
- **Anthropic** for Claude AI
- **Supabase** for database hosting
- **Vercel** for deployment platform
- **Next.js** team for the amazing framework

---

**Built with ❤️ using Next.js, TypeScript, WeatherAPI, and Claude AI**

Version 2.0 - December 2025
