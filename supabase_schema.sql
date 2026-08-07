-- Hidden Chat App Tables (isolated from RawBank)
-- Run these in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS hidden_chat_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sender TEXT NOT NULL,
  content TEXT,
  msg_type TEXT DEFAULT 'text', -- text, voice, image, file, location
  file_url TEXT,
  location_lat DOUBLE PRECISION,
  location_lng DOUBLE PRECISION,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS hidden_chat_status (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  message_id UUID REFERENCES hidden_chat_messages(id) ON DELETE CASCADE,
  reader TEXT NOT NULL,
  read_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(message_id, reader)
);

-- Enable RLS
ALTER TABLE hidden_chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE hidden_chat_status ENABLE ROW LEVEL SECURITY;

-- Allow all (simple app, no auth needed - the secret code IS the auth)
CREATE POLICY "allow_all_messages" ON hidden_chat_messages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_status" ON hidden_chat_status FOR ALL USING (true) WITH CHECK (true);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE hidden_chat_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE hidden_chat_status;
