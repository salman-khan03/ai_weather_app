-- ============================================
-- WEATHER APP DATABASE SETUP FOR SUPABASE
-- Copy this entire script and run it in your Supabase SQL Editor
-- URL: https://supabase.com/dashboard/project/ghjjekjppmznsihxirgn/sql/new
-- ============================================

-- Drop existing tables if they exist (CAREFUL: This deletes all data!)
DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.ai_insights CASCADE;
DROP TABLE IF EXISTS public.weather_history CASCADE;
DROP TABLE IF EXISTS public.saved_locations CASCADE;
DROP TABLE IF EXISTS public.testimonials CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- 1. CREATE USERS TABLE
CREATE TABLE public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT,
  avatar_url TEXT,
  bio TEXT,
  location TEXT,
  allergies TEXT[] DEFAULT '{}',
  allergy_severity TEXT DEFAULT 'moderate',
  temperature_preference TEXT DEFAULT 'celsius',
  notification_preferences JSONB DEFAULT '{"email": true, "allergy_alerts": true, "weather_updates": false}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login TIMESTAMP WITH TIME ZONE
);

-- 2. CREATE SAVED_LOCATIONS TABLE
CREATE TABLE public.saved_locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  region TEXT,
  country TEXT,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  is_favorite BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. CREATE WEATHER_HISTORY TABLE
CREATE TABLE public.weather_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  location_id UUID,
  location_name TEXT NOT NULL,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  temperature DECIMAL(5, 2) NOT NULL,
  condition TEXT NOT NULL,
  humidity INTEGER,
  wind_speed DECIMAL(5, 2),
  searched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. CREATE AI_INSIGHTS TABLE (includes allergy_alert column!)
CREATE TABLE public.ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  location_name TEXT NOT NULL,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  insight TEXT NOT NULL,
  suggestions TEXT[] DEFAULT '{}',
  rain_probability INTEGER,
  allergy_alert TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. CREATE TESTIMONIALS TABLE
CREATE TABLE public.testimonials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  user_name TEXT NOT NULL,
  user_email TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  content TEXT NOT NULL,
  is_approved BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. CREATE REVIEWS TABLE
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  user_name TEXT NOT NULL,
  user_email TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_saved_locations_user_id ON public.saved_locations(user_id);
CREATE INDEX idx_saved_locations_favorite ON public.saved_locations(is_favorite);
CREATE INDEX idx_weather_history_user_id ON public.weather_history(user_id);
CREATE INDEX idx_weather_history_searched_at ON public.weather_history(searched_at DESC);
CREATE INDEX idx_ai_insights_user_id ON public.ai_insights(user_id);
CREATE INDEX idx_ai_insights_created_at ON public.ai_insights(created_at DESC);
CREATE INDEX idx_testimonials_user_id ON public.testimonials(user_id);
CREATE INDEX idx_testimonials_approved ON public.testimonials(is_approved);
CREATE INDEX idx_reviews_user_id ON public.reviews(user_id);

-- ============================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weather_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- ============================================
-- CREATE PERMISSIVE POLICIES (Development Mode)
-- Allow all operations for now
-- ============================================

-- Users policies
DROP POLICY IF EXISTS "Allow all for users" ON public.users;
CREATE POLICY "Allow all for users" 
  ON public.users 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- Saved locations policies
DROP POLICY IF EXISTS "Allow all for saved_locations" ON public.saved_locations;
CREATE POLICY "Allow all for saved_locations" 
  ON public.saved_locations 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- Weather history policies
DROP POLICY IF EXISTS "Allow all for weather_history" ON public.weather_history;
CREATE POLICY "Allow all for weather_history" 
  ON public.weather_history 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- AI insights policies
DROP POLICY IF EXISTS "Allow all for ai_insights" ON public.ai_insights;
CREATE POLICY "Allow all for ai_insights" 
  ON public.ai_insights 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- Testimonials policies
DROP POLICY IF EXISTS "Allow all for testimonials" ON public.testimonials;
CREATE POLICY "Allow all for testimonials" 
  ON public.testimonials 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- Reviews policies
DROP POLICY IF EXISTS "Allow all for reviews" ON public.reviews;
CREATE POLICY "Allow all for reviews" 
  ON public.reviews 
  FOR ALL 
  USING (true) 
  WITH CHECK (true);

-- ============================================
-- GRANT PERMISSIONS TO ROLES
-- ============================================

GRANT ALL ON public.users TO anon, authenticated;
GRANT ALL ON public.saved_locations TO anon, authenticated;
GRANT ALL ON public.weather_history TO anon, authenticated;
GRANT ALL ON public.ai_insights TO anon, authenticated;
GRANT ALL ON public.testimonials TO anon, authenticated;
GRANT ALL ON public.reviews TO anon, authenticated;

-- ============================================
-- VERIFY SETUP
-- ============================================

SELECT 'Setup Complete! All tables created successfully.' as status;

SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name AND table_schema = 'public') as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_name IN ('users', 'saved_locations', 'weather_history', 'ai_insights', 'testimonials', 'reviews')
ORDER BY table_name;
