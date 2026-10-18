# 🚀 KOG Studio Pro - Cổng Cài Đặt Chính Thức (Public Release)

KOG Studio Pro là hệ sinh thái công cụ tổng hợp tự động hóa, tải video đa nền tảng và dựng video chuyên nghiệp dành cho đội ngũ KOG, hỗ trợ toàn diện cả **Windows** và **Apple macOS**.

---

## 🍎 DÀNH CHO NGƯỜI DÙNG MACOS (APPLE SILICON & INTEL)

### ⭐ Cách 1: Cài đặt tự động bằng 1 dòng lệnh duy nhất (Khuyên dùng)
1. Mở ứng dụng **Terminal** trên máy Mac (Nhấn tổ hợp phím `Cmd + Space` -> gõ `Terminal` -> nhấn `Enter`).
2. Copy toàn bộ dòng lệnh bên dưới, dán vào cửa sổ Terminal và ấn `Enter`:

``bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KOG-KH/KOG-Studio-Releases/main/install_macos.sh)"
``

✨ **Lệnh trên sẽ tự động:**
* Tải bản macOS chuẩn mới nhất về thư mục riêng `~/KOG_Studio`.
* Tự động giải nén bộ cài đặt.
* Tự động cấp quyền thực thi (`chmod +x`).
* Tự động gỡ bỏ cờ kiểm duyệt bảo mật của Apple Gatekeeper (`xattr -cr`) để tránh triệt để lỗi *"Ứng dụng bị hỏng hoặc không rõ nguồn gốc"*.
* **Tự động tạo biểu tượng `KOG Studio.command` ngoài màn hình Desktop**.
* Khởi chạy Web App và tự mở giao diện trên trình duyệt web ngay lập tức!

> 💡 **Khởi động những lần tiếp theo:** Chỉ cần ra màn hình Desktop, nhấp đúp chuột vào biểu tượng **`KOG Studio.command`** là ứng dụng tự mở.

---

### ⭐ Cách 2: Tải file thủ công từ Release
1. Tải file **[KOG_Studio_macOS.zip](https://github.com/KOG-KH/KOG-Studio-Releases/releases/latest/download/KOG_Studio_macOS.zip)** về thư mục `Downloads`.
2. Mở **Terminal** và dán dòng lệnh sau:
``bash
cd ~/Downloads && unzip -o KOG_Studio_macOS.zip && chmod +x KOG_Studio && xattr -cr KOG_Studio && ./KOG_Studio
``

---

## 🪟 DÀNH CHO NGƯỜI DÙNG WINDOWS (WINDOWS 10, 11 64-BIT)

1. Tải trực tiếp file: **[KOG_Studio.exe](https://github.com/KOG-KH/KOG-Studio-Releases/releases/latest/download/KOG_Studio.exe)** *(hoặc bản nén [KOG_Studio_Windows_x64.zip](https://github.com/KOG-KH/KOG-Studio-Releases/releases/latest/download/KOG_Studio_Windows_x64.zip))*.
2. Nhấp đúp chuột vào file **`KOG_Studio.exe`** để bắt đầu sử dụng ngay.
3. Trình duyệt web sẽ tự động mở giao diện tại: `http://127.0.0.1:8000`.

---

## 🔒 BẢN QUYỀN & XÁC THỰC THIẾT BỊ (DEVICE ID)
* Mỗi máy tính (Windows / macOS) khi khởi chạy lần đầu tiên sẽ có một mã nhận diện phần cứng duy nhất (**Hardware UUID / Device ID**).
* Phần mềm tự động kết nối qua Cổng bảo mật Google Apps Script Gateway của Admin để xác thực quyền sử dụng.
* Thiết bị chỉ hoạt động khi đã được Admin phê duyệt mã UUID vào danh sách cấp phép.