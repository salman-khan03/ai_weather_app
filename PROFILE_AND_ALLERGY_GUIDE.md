# User Profile & Personalized Allergy Alert System

This guide covers the new features added to the Weather App, including user profile management and AI-powered personalized allergy alerts using Google Gemini.

## 🎯 New Features Overview

### 1. **User Profile Management** 👤
- Complete profile editing interface
- Personal information management
- Allergy tracking and severity settings
- Temperature unit preferences
- Notification preferences

### 2. **Personalized Allergy Alerts** ⚠️
- AI-powered allergy risk analysis using Google Gemini
- Real-time weather-based allergy predictions
- Personalized alerts based on your specific allergies
- Actionable recommendations to manage allergy symptoms

### 3. **Enhanced AI Insights** 🤖
- Context-aware weather analysis
- Health-focused recommendations
- Allergy-specific advice for sensitive users

---

## 📋 Table of Contents

1. [Database Setup](#database-setup)
2. [User Profile Features](#user-profile-features)
3. [Allergy Tracking System](#allergy-tracking-system)
4. [How Personalized Allergy Alerts Work](#how-personalized-allergy-alerts-work)
5. [Using the Profile Page](#using-the-profile-page)
6. [API Endpoints](#api-endpoints)
7. [Troubleshooting](#troubleshooting)

---

## 🗄️ Database Setup

### Run the Profile Schema Migration

Execute the following SQL file to add profile and allergy features to your database:

```bash
# If using Supabase
# Go to SQL Editor in your Supabase dashboard and run:
Weather-app-main/database-profile.sql
```

### New Database Columns

The `users` table now includes:

| Column | Type | Description |
|--------|------|-------------|
| `allergies` | TEXT[] | Array of user's allergies (e.g., pollen, mold, dust) |
| `allergy_severity` | TEXT | Severity level: `mild`, `moderate`, or `severe` |
| `temperature_preference` | TEXT | Preferred unit: `celsius` or `fahrenheit` |
| `notification_preferences` | JSONB | User notification settings |
| `bio` | TEXT | User biography/description |
| `location` | TEXT | User's default location |

---

## 👤 User Profile Features

### Accessing Your Profile

1. **Sign in** to your account
2. Click **"Profile"** in the header navigation
3. Or navigate to `/profile`

### Profile Sections

#### 1. **Basic Information**
- Full Name
- Email (read-only)
- Bio/Description
- Location

#### 2. **Allergy Information**
Select from 8 common allergen types:
- 🌼 **Pollen** - Tree, grass, and flower pollen
- 🌾 **Grass** - Grass pollen allergies
- 🌳 **Tree Pollen** - Tree pollen allergies
- 🌿 **Ragweed** - Ragweed pollen
- 🍄 **Mold** - Mold and fungus spores
- 💨 **Dust** - Dust and dust mites
- 🏭 **Pollution** - Air pollution sensitivity
- 💧 **Humidity** - High humidity sensitivity

Set your **Allergy Severity**:
- **Mild** - Minor symptoms, manageable
- **Moderate** - Noticeable symptoms, may need medication
- **Severe** - Significant symptoms, requires careful monitoring

#### 3. **Preferences**
- **Temperature Unit**: Choose between Celsius (°C) or Fahrenheit (°F)
- **Notification Preferences**:
  - Email Notifications
  - Allergy Alerts
  - Weather Updates

---

## 🌡️ Allergy Tracking System

### How Weather Affects Allergies

The system analyzes multiple weather factors:

#### Pollen Allergies
- **High Risk**: Warm temps (15-25°C), low humidity, high wind, clear skies
- **Low Risk**: Cold temps, high humidity, rain, calm winds

#### Mold Allergies
- **High Risk**: High humidity (>70%), recent rain, damp conditions
- **Low Risk**: Dry weather, low humidity

#### Dust Allergies
- **High Risk**: Dry, windy conditions, low humidity
- **Low Risk**: Humid conditions, calm weather

#### Pollution Sensitivity
- **High Risk**: Low visibility, stagnant air, high temperature inversions
- **Low Risk**: Good visibility, windy conditions clearing air

---

## 🤖 How Personalized Allergy Alerts Work

### The AI Analysis Process

1. **Weather Data Collection**
   - Current temperature, humidity, wind speed
   - Visibility, precipitation, UV index
   - Forecast for next 24 hours

2. **User Profile Integration**
   - Loads your specific allergies from database
   - Considers your allergy severity setting
   - Factors in your location preferences

3. **Gemini AI Analysis**
   - Sends weather + allergy data to Google Gemini
   - AI analyzes correlations between weather and allergen activity
   - Generates personalized recommendations

4. **Alert Display**
   - **Priority Alert**: Red, pulsing card for personalized warnings
   - **General Alert**: Yellow card for general allergy conditions
   - **Actionable Advice**: Specific steps to manage symptoms

### Example Alert Scenarios

#### Scenario 1: Pollen Allergy on Sunny Day
```
⚠️ Personalized Allergy Alert
High pollen risk today! Warm temperature (22°C), low humidity (45%), 
and moderate winds (18 km/h) create ideal conditions for pollen spread.

Recommendations:
• Take antihistamines before going outside
• Keep windows closed during peak pollen hours (10am-4pm)
• Shower and change clothes after being outdoors
• Consider wearing wraparound sunglasses
```

#### Scenario 2: Mold Allergy After Rain
```
⚠️ Personalized Allergy Alert
Elevated mold risk due to recent rainfall and 75% humidity. 
Mold spores thrive in these damp conditions.

Recommendations:
• Use a dehumidifier indoors
• Avoid areas with standing water
• Monitor indoor humidity levels
• Consider staying indoors during peak spore release
```

---

## 💻 Using the Profile Page

### Editing Your Profile

1. Click **"Edit Profile"** button
2. Update any fields you want to change
3. Select/deselect allergies by clicking the cards
4. Adjust allergy severity if needed
5. Toggle notification preferences
6. Click **"Save Changes"**

### Profile Features

#### Visual Feedback
- ✅ Green success message after saving
- ❌ Red error message if something fails
- 🎨 Color-coded severity indicators
- 🔄 Auto-save indicators

#### Mobile Responsive
- Fully optimized for mobile devices
- Touch-friendly allergy selection
- Collapsible sections for easy navigation

---

## 🔌 API Endpoints

### Get User Profile
```typescript
GET /api/profile
Authorization: Bearer <token>

Response:
{
  "profile": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "allergies": ["pollen", "dust"],
    "allergy_severity": "moderate",
    "temperature_preference": "celsius",
    "notification_preferences": { ... },
    ...
  }
}
```

### Update User Profile
```typescript
PUT /api/profile
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
  "name": "John Doe",
  "bio": "Weather enthusiast",
  "location": "New York, USA",
  "allergies": ["pollen", "mold"],
  "allergy_severity": "moderate",
  "temperature_preference": "fahrenheit",
  "notification_preferences": {
    "email": true,
    "allergy_alerts": true,
    "weather_updates": false
  }
}
```

### Generate Weather Insight with Allergies
```typescript
POST /api/weather/insight
Content-Type: application/json

Body:
{
  "weatherData": { ... },
  "location": "New York",
  "userId": "user-uuid"
}

Response:
{
  "success": true,
  "data": {
    "insight": "Current weather analysis...",
    "suggestions": ["...", "..."],
    "allergyAlert": "General allergy risk...",
    "personalizedAllergyAlert": "⚠️ Your specific allergy alert..."
  }
}
```

---

## 🎨 UI Components

### Allergy Alert Display

The AI Insight component shows allergy alerts prominently:

#### Personalized Alert (Red Pulsing Card)
- Shown when user has allergies + weather is risky
- Contains specific advice for user's allergies
- Animated border to draw attention
- Priority display above general alerts

#### General Alert (Yellow Card)
- Shown when no personal allergies set
- General allergy risk for area
- Informational, not personalized

---

## 🧪 Testing the Features

### Test Scenario 1: Setup Profile
1. Sign in to your account
2. Go to Profile page
3. Add 2-3 allergies (e.g., Pollen, Mold, Dust)
4. Set severity to "Moderate"
5. Save changes

### Test Scenario 2: View Personalized Alerts
1. Return to home page
2. Wait for weather to load
3. Scroll to "AI Weather Insight" section
4. Click "Generate AI Weather Insight"
5. Look for personalized allergy alert

### Test Scenario 3: Different Weather Conditions
1. Search for different locations
2. Observe how allergy alerts change
3. Compare alerts between:
   - Sunny, dry, windy days (high pollen risk)
   - Rainy, humid days (high mold risk)
   - Cold days (low allergy risk)

---

## 🔧 Troubleshooting

### No Personalized Alerts Showing

**Check:**
1. ✅ Have you added allergies to your profile?
2. ✅ Is Gemini API key configured in `.env.local`?
3. ✅ Are you signed in?
4. ✅ Did you wait for insight to fully generate?

**Solution:**
- Verify allergies are saved in profile
- Check browser console for errors
- Try regenerating insight
- Check Gemini API quota

### Profile Changes Not Saving

**Check:**
1. ✅ Are you signed in with valid session?
2. ✅ Network connection active?
3. ✅ Database connection working?

**Solution:**
- Refresh page and try again
- Check browser console for errors
- Verify Supabase connection
- Check terminal for API errors

### Allergy Alerts Too Generic

**Possible Causes:**
- Gemini API key not configured
- API rate limit exceeded
- Fallback system activated

**Solution:**
- Configure Gemini API key properly
- Check API usage in Google Cloud Console
- With valid API key, alerts become specific and personalized

---

## 🌟 Best Practices

### For Allergy Sufferers

1. **Keep Profile Updated**
   - Update allergies seasonally
   - Adjust severity as needed
   - Enable allergy alert notifications

2. **Check Alerts Daily**
   - Morning check before planning activities
   - Review personalized recommendations
   - Plan indoor alternatives for high-risk days

3. **Use Insights Proactively**
   - Take medication before symptoms start
   - Adjust outdoor activities based on alerts
   - Share insights with family members

### For Developers

1. **Extend Allergy Types**
   - Add more specific allergens
   - Include regional allergen data
   - Integrate pollen count APIs

2. **Enhance AI Prompts**
   - Add seasonal context
   - Include historical allergy data
   - Factor in air quality indices

3. **Improve Notifications**
   - Push notifications for severe alerts
   - Daily digest emails
   - SMS alerts for critical conditions

---

## 📊 Feature Statistics

### Profile Features
- ✅ 8 common allergen types
- ✅ 3 severity levels
- ✅ 2 temperature units
- ✅ 3 notification preferences
- ✅ Full CRUD operations

### AI Integration
- ✅ Gemini Pro model
- ✅ Context-aware analysis
- ✅ Personalized recommendations
- ✅ Fallback system for reliability
- ✅ Real-time weather correlation

---

## 🚀 Future Enhancements

### Planned Features
- [ ] Pollen count API integration
- [ ] Historical allergy tracking
- [ ] Medication reminders
- [ ] Symptom logging
- [ ] Multi-location allergy alerts
- [ ] Weekly allergy forecast
- [ ] Community allergy reports
- [ ] Medical professional integration

---

## 📚 Additional Resources

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [Allergy Weather Correlation Studies](https://www.aaaai.org/)
- [Supabase Documentation](https://supabase.com/docs)
- [Weather API Documentation](https://open-meteo.com/)

---

## 🤝 Support

If you encounter issues:
1. Check this guide first
2. Review terminal and browser console logs
3. Verify database schema is updated
4. Ensure Gemini API key is configured
5. Test with fallback system (no API key)

---

## 🎉 Enjoy Your Personalized Weather Experience!

With these new features, you can:
- ✅ Manage your complete weather profile
- ✅ Track your specific allergies
- ✅ Receive AI-powered personalized alerts
- ✅ Get actionable health recommendations
- ✅ Plan your day around allergy risks

**Stay informed, stay healthy, and enjoy the weather on your terms!** 🌤️💚

