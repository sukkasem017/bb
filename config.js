// ใส่ค่าจาก Supabase Dashboard > Project Settings > API
// ใช้เฉพาะ "anon / publishable key" เท่านั้น (ปลอดภัยต่อการเปิดเผย เพราะมี RLS คุมสิทธิ์)
// ห้ามใส่ service_role key ลงในไฟล์นี้เด็ดขาด
window.APP_CONFIG = {
  SUPABASE_URL: "https://YOUR-PROJECT-ID.supabase.co",
  SUPABASE_ANON_KEY: "YOUR-ANON-PUBLIC-KEY",
};
