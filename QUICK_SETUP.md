# Quick Setup Checklist for New Features

Follow these steps to enable the new profile and allergy alert features:

## ✅ Step 1: Update Database Schema

Run the SQL migration to add new columns to your users table:

```bash
# In Supabase SQL Editor, execute:
Weather-app-main/database-profile.sql
```

**What this adds:**
- `allergies` (array field)
- `allergy_severity` (text field)
- `temperature_preference` (text field)
- `notification_preferences` (JSON field)
- `bio` and `location` (text fields)

## ✅ Step 2: Verify Gemini API Key

Make sure your `.env.local` has the Gemini API key:

```env
GOOGLE_API_KEY=your_google_api_key_here
# OR
GEMINI_API_KEY=your_google_api_key_here
```

**Get your API key:**
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in and create/copy your API key
3. Add it to `.env.local`
4. Restart your dev server

## ✅ Step 3: Restart Development Server

```bash
# Stop the current server (Ctrl+C)
# Then restart:
npm run dev
```

## ✅ Step 4: Test the Features

### A. Test Profile Page
1. Sign in to your account
2. Click **"Profile"** in the header navigation
3. Click **"Edit Profile"**
4. Add your name, bio, location
5. Select 2-3 allergies (e.g., Pollen, Dust, Mold)
6. Set severity to "Moderate"
7. Click **"Save Changes"**
8. ✅ Success message should appear

### B. Test Personalized Allergy Alerts
1. Go to home page
2. Let weather load for your location
3. Scroll to **"AI Weather Insight"** section
4. Click **"Generate AI Weather Insight"**
5. Wait for AI to analyze (5-10 seconds)
6. Look for:
   - 📊 Weather stats cards
   - ⚠️ **Personalized Allergy Alert** (red pulsing card)
   - 💡 Smart recommendations
   
### C. Test Different Weather Scenarios
1. Search for different cities
2. Compare allergy alerts between:
   - Sunny, dry locations (high pollen risk)
   - Rainy, humid locations (high mold risk)
   - Cold locations (low allergy risk)

## ✅ Step 5: Verify Everything Works

**Profile Features:**
- ✅ Can edit profile
- ✅ Can select/deselect allergies
- ✅ Can set allergy severity
- ✅ Changes save successfully
- ✅ Profile link appears in header

**Allergy Alerts:**
- ✅ AI insights generate
- ✅ Personalized alerts show (red card)
- ✅ Alerts are specific to your allergies
- ✅ Recommendations are actionable
- ✅ General alerts still show if no personal allergies

## 🎯 Quick Commands

```bash
# Restart dev server
npm run dev

# Check for TypeScript errors
npm run build

# View database (if using Supabase locally)
npx supabase db push
```

## 🔍 Troubleshooting

### Problem: Profile page doesn't load
**Solution:**
- Check if database migration ran successfully
- Verify you're signed in
- Check browser console for errors

### Problem: No personalized allergy alerts
**Solution:**
- Make sure you've added allergies to your profile
- Verify Gemini API key is set
- Check terminal for API errors
- Try regenerating the insight

### Problem: "Failed to update profile"
**Solution:**
- Check database connection
- Verify you're signed in with valid session
- Look at terminal for detailed error
- Try refreshing page and saving again

## 📱 What You Should See

### Profile Page
![Profile features include: basic info, allergy selection grid, severity selector, preferences]

### Allergy Alert Example
```
⚠️ Personalized Allergy Alert
High pollen risk today! Warm temperature (22°C), low humidity (45%), 
and moderate winds create ideal conditions for pollen spread.

Recommendations:
• Take antihistamines before going outside
• Keep windows closed during peak hours
• Shower after outdoor activities
```

## 🎉 You're All Set!

Once you see:
- ✅ Profile page loads and saves
- ✅ Personalized allergy alerts appear
- ✅ Recommendations are specific to your allergies

You're ready to use the full power of personalized weather insights!

## 📚 More Information

- Full documentation: `PROFILE_AND_ALLERGY_GUIDE.md`
- Gemini setup: `GEMINI_SETUP.md`
- Database schema: `database-profile.sql`

---

**Need Help?** Check the detailed guide in `PROFILE_AND_ALLERGY_GUIDE.md`

