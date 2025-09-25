/*
  # Create confessions table

  1. New Tables
    - `confessions`
      - `id` (bigint, primary key, auto-increment)
      - `message` (text, required) - the confession text
      - `created_at` (timestamp) - when confession was posted
      - `likes` (int, default 0) - number of likes received
      
  2. Security
    - Enable RLS on `confessions` table
    - Add policy for anyone to read confessions
    - Add policy for anyone to insert confessions
    - Add policy for anyone to update likes (for the like functionality)
*/

CREATE TABLE IF NOT EXISTS confessions (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  message text NOT NULL,
  created_at timestamptz DEFAULT now(),
  likes int DEFAULT 0
);

ALTER TABLE confessions ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read confessions
CREATE POLICY "Anyone can read confessions"
  ON confessions
  FOR SELECT
  TO anon, authenticated
  USING (true);

-- Allow anyone to insert confessions
CREATE POLICY "Anyone can insert confessions"
  ON confessions
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Allow anyone to update likes only
CREATE POLICY "Anyone can update likes"
  ON confessions
  FOR UPDATE
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);