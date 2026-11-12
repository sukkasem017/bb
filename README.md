# ระบบลงทะเบียน (Supabase + HTML)

เว็บลงทะเบียนแบบ static (ไม่ต้องมี backend) ใช้ Supabase เป็นฐานข้อมูล deploy ได้ฟรีบน GitHub Pages

## ฟีเจอร์
- **`index.html`** – ฟอร์มลงทะเบียน: ชื่อ, นามสกุล, อายุ, แผนก, สาขา, เลขนักศึกษา, ระดับชั้น, คติประจำใจ
- **`admin.html`** – หน้าผู้ดูแล: เข้าสู่ระบบด้วย Supabase Auth, ดูรายชื่อ, ค้นหา, ลบ, ดาวน์โหลด CSV
- ความปลอดภัยด้วย Row Level Security: บุคคลทั่วไป *เพิ่มข้อมูลได้อย่างเดียว* ส่วนการดู/ลบ ทำได้เฉพาะ admin

## โครงสร้างไฟล์
```
├── index.html     # หน้าลงทะเบียน
├── admin.html     # หน้า admin
├── style.css
├── config.js      # ใส่ Supabase URL + anon key
├── schema.sql     # สร้างตาราง + นโยบายสิทธิ์
└── README.md
```

## วิธีตั้งค่า

### 1. สร้างโปรเจกต์ Supabase
สมัครที่ https://supabase.com แล้วสร้าง Project ใหม่

### 2. สร้างตาราง
เปิด **SQL Editor** → วางเนื้อหาไฟล์ `schema.sql` → กด **Run**

### 3. สร้างบัญชี admin
1. ไปที่ **Authentication → Users → Add user** ใส่อีเมล/รหัสผ่านของ admin (ติ๊ก Auto Confirm User)
2. กลับไป **SQL Editor** แล้วรัน (แก้อีเมลให้ตรง):
   ```sql
   insert into public.admins (user_id)
   select id from auth.users where email = 'admin@example.com';
   ```
3. (แนะนำ) ปิดการสมัครเอง: **Authentication → Sign In / Providers → ปิด "Allow new users to sign up"**

### 4. ใส่ค่า config
เปิด **Project Settings → API** คัดลอก `Project URL` และ `anon public key` ไปใส่ใน `config.js`

> ใช้เฉพาะ anon key เท่านั้น **ห้ามใส่ `service_role` key** ลง GitHub

### 5. Deploy ขึ้น GitHub Pages
1. Push โค้ดขึ้น GitHub
2. **Settings → Pages → Branch: main / root → Save**
3. เปิดเว็บที่ `https://<username>.github.io/<repo>/` (หน้า admin อยู่ที่ `/admin.html`)

## ปรับแต่ง
- เปลี่ยนตัวเลือก "ระดับชั้น" ได้ที่ `<select id="grade_level">` ใน `index.html`
- เพิ่ม/ลดฟิลด์: แก้ `schema.sql`, ฟอร์มใน `index.html` และตารางใน `admin.html`
