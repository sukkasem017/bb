-- =====================================================
-- Supabase schema: ระบบลงทะเบียน
-- วิธีใช้: Supabase Dashboard > SQL Editor > วางทั้งไฟล์ > Run
-- =====================================================

-- 1) ตารางข้อมูลผู้ลงทะเบียน
create table if not exists public.registrations (
  id          uuid primary key default gen_random_uuid(),
  first_name  text not null check (char_length(first_name) between 1 and 100),
  last_name   text not null check (char_length(last_name)  between 1 and 100),
  age         int  not null check (age between 1 and 120),
  department  text not null check (char_length(department) between 1 and 100), -- แผนก
  branch      text not null check (char_length(branch)     between 1 and 100), -- สาขา
  student_id  text not null unique check (char_length(student_id) between 1 and 30),
  grade_level text not null check (char_length(grade_level) between 1 and 50),  -- ระดับชั้น
  motto       text check (char_length(motto) <= 300),                           -- คติประจำใจ
  created_at  timestamptz not null default now()
);

-- 2) ตารางรายชื่อ admin (อ้างอิงผู้ใช้จาก Supabase Auth)
create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

-- 3) เปิด Row Level Security
alter table public.registrations enable row level security;
alter table public.admins        enable row level security;

-- 4) นโยบายสิทธิ์: ใครก็ลงทะเบียนได้ (เพิ่มข้อมูลอย่างเดียว)
drop policy if exists "anyone can register" on public.registrations;
create policy "anyone can register"
  on public.registrations for insert
  to anon, authenticated
  with check (true);

-- 5) เฉพาะ admin เท่านั้นที่ดู/แก้/ลบได้
drop policy if exists "admin can read"   on public.registrations;
drop policy if exists "admin can update" on public.registrations;
drop policy if exists "admin can delete" on public.registrations;

create policy "admin can read"
  on public.registrations for select
  to authenticated
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()));

create policy "admin can update"
  on public.registrations for update
  to authenticated
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()));

create policy "admin can delete"
  on public.registrations for delete
  to authenticated
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- 6) ผู้ใช้เห็นได้เฉพาะแถวของตัวเองในตาราง admins (ใช้เช็กว่าเป็น admin หรือไม่)
drop policy if exists "read own admin row" on public.admins;
create policy "read own admin row"
  on public.admins for select
  to authenticated
  using (user_id = auth.uid());

-- =====================================================
-- 7) เพิ่ม admin (ทำหลังสร้างผู้ใช้ใน Authentication > Users แล้ว)
--    แก้อีเมลให้ตรงกับผู้ใช้ที่สร้าง แล้วรันบรรทัดนี้
-- =====================================================
-- insert into public.admins (user_id)
-- select id from auth.users where email = 'admin@example.com';
