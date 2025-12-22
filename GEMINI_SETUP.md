# Google Gemini AI Setup Guide

This guide will help you set up Google Gemini AI for weather insights in the WeatherApp.

## Prerequisites

- A Google account
- Access to Google AI Studio

## Step-by-Step Setup

### 1. Get Your Google API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click **"Get API Key"** or **"Create API Key"**
4. Select or create a Google Cloud project
5. Copy your API key

### 2. Enable Required APIs

Your API key needs access to the Generative Language API (Gemini):

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** > **Library**
4. Search for and enable:
   - **Generative Language API** (Required for Gemini)
   - **Places API** (Optional - for location autocomplete)

### 3. Configure Environment Variables

Add your API key to `.env.local`:

```env
# Option 1: Use GOOGLE_API_KEY (Recommended)
GOOGLE_API_KEY=your_google_api_key_here

# Option 2: Use GEMINI_API_KEY
GEMINI_API_KEY=your_google_api_key_here
```

**Important Notes:**
- If both `GEMINI_API_KEY` and `GOOGLE_API_KEY` are set, `GOOGLE_API_KEY` takes precedence
- The same API key can be used for both Gemini AI and Google Places API if both are enabled
- Server restart required after adding/changing environment variables

### 4. Verify Setup

1. Restart your development server:
   ```bash
   npm run dev
   ```

2. Open the app at `http://localhost:3000`

3. The AI Weather Insight section should automatically generate when weather loads

4. Look for the beautiful Gemini-style cards with:
   - Weather Summary
   - Smart Recommendations (numbered cards)
   - Quick Stats (Temperature, Wind, Humidity, Visibility)

## How It Works

### Environment Variable Priority

The app checks for API keys in this order:
1. `GOOGLE_API_KEY` (highest priority)
2. `GEMINI_API_KEY` (fallback)

From `src/lib/ai.ts`:
```typescript
const getGeminiClient = () => {
  const apiKey = process.env.GEMINI_API_KEY || process.env.GOOGLE_API_KEY
  if (!apiKey) {
    throw new Error('GEMINI_API_KEY or GOOGLE_API_KEY not found')
  }
  return new GoogleGenerativeAI(apiKey)
}
```

### AI Model Used

- **Model**: `gemini-pro`
- **Provider**: Google Generative AI
- **Features**:
  - Natural language weather analysis
  - Context-aware recommendations
  - Personalized suggestions based on conditions

### Fallback System

If Gemini AI fails (invalid key, API error, etc.), the app automatically falls back to:
- Intelligent rule-based weather analysis
- Condition-specific recommendations
- Temperature, UV, wind, and humidity-based suggestions

**You still get great insights even without AI!**

## API Key Security

### Best Practices

1. **Never commit `.env.local`** to version control (already in `.gitignore`)
2. **Use separate keys** for development and production
3. **Restrict API key usage** in Google Cloud Console:
   - Set application restrictions
   - Set API restrictions (limit to Generative Language API)
   - Set usage quotas

### Key Restrictions

In Google Cloud Console:
1. Go to **APIs & Services** > **Credentials**
2. Click on your API key
3. Under **API restrictions**, select:
   - Generative Language API
   - Places API (if using location search)
4. Under **Application restrictions**, you can:
   - Restrict to specific IPs (for server)
   - Restrict to specific websites (for client-side)

## Pricing & Quotas

### Google Gemini API (Free Tier)

- **60 requests per minute**
- **1,500 requests per day**
- **1 million tokens per month**

For current pricing, visit: [Google AI Pricing](https://ai.google.dev/pricing)

### Managing Usage

- The app automatically generates insights when weather loads
- Users can click "Regenerate Insight" for updated recommendations
- Each insight generation = 1 API call
- Fallback system activates if quota exceeded

## Troubleshooting

### "GEMINI_API_KEY or GOOGLE_API_KEY not found"

**Solution:**
1. Check `.env.local` exists in project root
2. Verify the key name is exactly `GOOGLE_API_KEY` or `GEMINI_API_KEY`
3. Restart the development server after changes

### "Error generating weather insight with Gemini"

**Possible causes:**
1. **Invalid API key**: Verify the key is correct
2. **API not enabled**: Enable Generative Language API in Google Cloud
3. **Quota exceeded**: Check usage in Google Cloud Console
4. **Network issues**: Check internet connection

**Solution:**
- The app will automatically use fallback insights
- Check browser console for detailed error messages
- Verify API key has proper permissions

### Insights Not Generating

1. **Check terminal output** for error messages
2. **Verify environment variables**:
   ```bash
   # On Windows PowerShell
   $env:GOOGLE_API_KEY
   ```
3. **Check API is enabled** in Google Cloud Console
4. **Look at browser console** (F12) for client-side errors

### Fallback Insights Always Showing

If you're always seeing fallback insights instead of AI-generated ones:
1. API key may be invalid
2. Generative Language API not enabled
3. Quota may be exceeded
4. Check server logs for specific error messages

## Testing Your Setup

### Quick Test

1. Start the app: `npm run dev`
2. Open browser at `http://localhost:3000`
3. Wait for weather to load
4. Look for the **AI Weather Insight** section
5. Check if suggestions are contextual and natural (AI) or rule-based (fallback)

### Verify Gemini Connection

Check the terminal output when insight generates:
- ✅ **Success**: No error messages, insights appear
- ❌ **Error**: "Error generating weather insight with Gemini" → Using fallback
- ⚠️ **Warning**: Check for API key or permission issues

## Features Using Gemini AI

### 1. Weather Summary
- Natural language description of current conditions
- Context about what it means for your day
- Temperature analysis with feels-like comparison

### 2. Smart Recommendations (4-6 suggestions)
- Clothing advice based on temperature
- UV protection recommendations
- Activity suggestions
- Weather-specific preparations
- Wind and visibility warnings
- Humidity comfort tips

### 3. Activity Recommendations (Future)
- Indoor/outdoor activity suggestions
- Best times for specific activities
- Weather-appropriate recommendations

## Benefits of Gemini AI

### Over Rule-Based System:
- ✅ More natural, conversational insights
- ✅ Better context understanding
- ✅ Personalized recommendations
- ✅ Considers multiple weather factors together
- ✅ Can explain "why" not just "what"

### Gemini-Specific Advantages:
- 🚀 Fast response times
- 💰 Generous free tier
- 🔄 Continually improving model
- 🌐 Multi-language support (future)
- 📊 Good at structured data analysis

## Additional Resources

- [Google AI Studio](https://makersuite.google.com/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Pricing Information](https://ai.google.dev/pricing)

## Support

If you encounter issues:
1. Check this guide first
2. Review terminal and browser console logs
3. Verify API key and permissions
4. Check Google Cloud Console for quota/usage
5. Open an issue on GitHub with error details

---

**Note**: The app works perfectly with or without Gemini AI. The intelligent fallback system ensures you always get valuable weather insights!
