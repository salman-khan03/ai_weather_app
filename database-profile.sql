-- Add allergy and preference columns to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS allergies TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS allergy_severity TEXT DEFAULT 'moderate' CHECK (allergy_severity IN ('mild', 'moderate', 'severe')),
ADD COLUMN IF NOT EXISTS temperature_preference TEXT DEFAULT 'celsius' CHECK (temperature_preference IN ('celsius', 'fahrenheit')),
ADD COLUMN IF NOT EXISTS notification_preferences JSONB DEFAULT '{"email": true, "allergy_alerts": true, "weather_updates": false}'::jsonb,
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS location TEXT;

-- Common allergen types that users can select:
-- 'pollen', 'grass', 'tree_pollen', 'ragweed', 'mold', 'dust', 'pollution', 'humidity'

-- Create index for faster allergy queries
CREATE INDEX IF NOT EXISTS idx_users_allergies ON users USING GIN(allergies);

-- Update the updated_at timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

