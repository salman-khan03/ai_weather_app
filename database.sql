-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP
);

-- Create saved_locations table
CREATE TABLE IF NOT EXISTS saved_locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  region TEXT,
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
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  location_name TEXT NOT NULL,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  temperature DECIMAL(5, 2) NOT NULL,
  condition TEXT NOT NULL,
  humidity INTEGER,
  wind_speed DECIMAL(5, 2),
  searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ai_insights table
CREATE TABLE IF NOT EXISTS ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  location_name TEXT NOT NULL,
  lat DECIMAL(10, 8) NOT NULL,
  lon DECIMAL(11, 8) NOT NULL,
  insight TEXT NOT NULL,
  suggestions TEXT[] DEFAULT '{}',
  rain_probability INTEGER,
  allergy_alert TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create testimonials table
CREATE TABLE IF NOT EXISTS testimonials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  user_email TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  content TEXT NOT NULL,
  is_approved BOOLEAN DEFAULT FALSE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_saved_locations_user_id ON saved_locations(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_locations_is_favorite ON saved_locations(is_favorite);
CREATE INDEX IF NOT EXISTS idx_weather_history_user_id ON weather_history(user_id);
CREATE INDEX IF NOT EXISTS idx_weather_history_searched_at ON weather_history(searched_at DESC);
CREATE INDEX IF NOT EXISTS idx_ai_insights_user_id ON ai_insights(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_insights_created_at ON ai_insights(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_testimonials_user_id ON testimonials(user_id);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_approved ON testimonials(is_approved);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_featured ON testimonials(is_featured);

-- Disable Row Level Security for easier testing (Enable in production with proper policies)
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE saved_locations DISABLE ROW LEVEL SECURITY;
ALTER TABLE weather_history DISABLE ROW LEVEL SECURITY;
ALTER TABLE ai_insights DISABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials DISABLE ROW LEVEL SECURITY;

-- Create policies for users table
CREATE POLICY "Users can view their own data"
  ON users FOR SELECT
  USING (id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can update their own data"
  ON users FOR UPDATE
  USING (id::text = current_setting('app.user_id', true));

-- Create policies for saved_locations
CREATE POLICY "Users can view their own saved locations"
  ON saved_locations FOR SELECT
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can insert their own saved locations"
  ON saved_locations FOR INSERT
  WITH CHECK (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can update their own saved locations"
  ON saved_locations FOR UPDATE
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can delete their own saved locations"
  ON saved_locations FOR DELETE
  USING (user_id::text = current_setting('app.user_id', true));

-- Create policies for weather_history
CREATE POLICY "Users can view their own weather history"
  ON weather_history FOR SELECT
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can insert their own weather history"
  ON weather_history FOR INSERT
  WITH CHECK (user_id::text = current_setting('app.user_id', true));

-- Create policies for ai_insights
CREATE POLICY "Users can view their own AI insights"
  ON ai_insights FOR SELECT
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can insert their own AI insights"
  ON ai_insights FOR INSERT
  WITH CHECK (user_id::text = current_setting('app.user_id', true));

-- Create policies for testimonials
CREATE POLICY "Anyone can view approved testimonials"
  ON testimonials FOR SELECT
  USING (is_approved = true);

CREATE POLICY "Users can view their own testimonials"
  ON testimonials FOR SELECT
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can insert their own testimonials"
  ON testimonials FOR INSERT
  WITH CHECK (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can update their own testimonials"
  ON testimonials FOR UPDATE
  USING (user_id::text = current_setting('app.user_id', true));

CREATE POLICY "Users can delete their own testimonials"
  ON testimonials FOR DELETE
  USING (user_id::text = current_setting('app.user_id', true));
