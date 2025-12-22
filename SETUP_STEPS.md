# 🚀 Quick Setup Guide - Get Your Database Working!

## Step 1: Open Supabase SQL Editor

Click this link: **https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn/sql/new**

## Step 2: Copy the SQL

Open the file `supabase-setup.sql` in this project folder, copy ALL the SQL.

## Step 3: Paste and Run

1. Paste the SQL into the Supabase SQL Editor
2. Click the **RUN** button (green play button)
3. Wait for "Success" message

## Step 4: Verify Tables Created

Go to: **https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn/editor**

You should see these 6 tables:
- ✅ `users`
- ✅ `saved_locations`
- ✅ `weather_history`
- ✅ `ai_insights`
- ✅ `testimonials`
- ✅ `reviews`

## Step 5: Restart Your App

```bash
# Press Ctrl+C in your terminal
# Then run:
npm run dev
```

## 🎉 Done! Test It Out

1. **Search for a city** (e.g., "New York")
2. **Check Supabase**: Go to your `weather_history` table
3. **You should see your search!**

---

## 📊 What Gets Saved Where

| You Do This | Data Goes To | Table |
|-------------|--------------|-------|
| Search "London" | Weather data | `weather_history` |
| Click "Save Current" | Location saved | `saved_locations` |
| Generate AI Insight | Insight text | `ai_insights` |
| Leave a review | Your review | `reviews` |

---

## ⚠️ If You See Errors

**Error: "Could not find table"**
- Solution: Run the SQL again in Supabase

**Error: "Could not find column"**
- Solution: Delete the table and run SQL again

**No data showing up?**
- Check: Did you restart the app? (`npm run dev`)
- Check: Is Supabase configured in `.env.local`?

---

## 🔗 Quick Links

- SQL Editor: https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn/sql/new
- Table Editor: https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn/editor
- Your Project: https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn

