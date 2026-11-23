# 🛡️ KOG HungTK Studio Pro v2.3.30 - Bản Vá Bảo Mật Khẩn Cấp, Khóa Chặt Bản Quyền & Xác Thực SHA-256 Toàn Vẹn

Bản phát hành chính thức **v2.3.30** tập trung giải quyết toàn diện các phát hiện kiểm toán an ninh bảo mật cấp độ cao (P1 & P2), khóa chặt cơ chế bản quyền phần cứng, bảo vệ phân quyền Quản trị viên (RBAC) và tích hợp cơ chế bảo vệ chuỗi cung ứng bằng chữ ký số SHA-256 trên cả Windows và macOS.

---

### 🔒 1. Khóa Chặt Cơ Chế Bản Quyền & Triệt Tiêu Lỗ Hổng Bypass (P1)
- **Vô hiệu hóa can thiệp biến môi trường `OVERRIDE_UUID`:**
  - Tích hợp lớp kiểm tra nghiêm ngặt `is_test_environment()`: Khi chạy trên bản phát hành chính thức (`frozen binary`), hệ thống **tuyệt đối không đọc `OVERRIDE_UUID`**, ngăn chặn 100% các hành vi giả mạo UUID phần cứng.
  * Cập nhật các tệp launcher (`KOG Studio Windows.bat` và `KOG Studio MacOS.command`): Chỉ cho phép nhận diện UUID tùy chỉnh khi có cờ `CI == "true"`, bình thường luôn truy vấn Hardware UUID thực tế từ bo mạch chủ.
- **Loại bỏ hoàn toàn Backdoor `ADMIN_SECRET_KEY` & Chuẩn hóa RBAC:**
  - Xóa bỏ hằng số bảo mật tĩnh `ADMIN_SECRET_KEY = "kog_admin_2026"`.
  - Vô hiệu hóa việc nâng quyền Admin qua Query parameter `?admin_key=...`, Header `X-Admin-Key` hoặc Cookie `kog_admin_key`.
  - Phân quyền Quản trị viên (Admin HungTK) được bảo vệ tuyệt đối: Chỉ công nhận khi Hardware UUID nằm trong danh sách `ADMIN_UUIDS` hoặc Cổng Cloud Gateway cấp quyền `role: "ADMIN"`.
- **Bổ sung thời hạn hiệu lực 48 Giờ (TTL) cho Cache Offline (`.auth_cache.json`):**
  - Giới hạn thời gian sử dụng offline tối đa 48 giờ (`MAX_OFFLINE_SECONDS = 48 * 3600`).
  - Tích hợp cơ chế phát hiện và ngăn chặn người dùng cố tình tua lùi đồng hồ hệ thống. Khi quá hạn, ứng dụng bắt buộc kết nối lại Cloud Gateway để làm mới giấy phép.

---

### 🛡️ 2. Bảo Vệ Chuỗi Cung Ứng & Toàn Vẹn Cập Nhật SHA-256 (P2)
- **Tích hợp xác thực mã băm SHA-256 vào Silent Auto-Updater (`auto_updater.py`):**
  - Hàm `check_for_updates()` tự động đọc tệp `checksums.sha256` hoặc metadata trên GitHub Releases.
  - Hàm `verify_binary()` bắt buộc kiểm tra mã băm SHA-256 trước khi tiến hành hot-swap hoặc lưu vào bộ nhớ đệm tải ngầm (Pre-download).
  - Tự động hủy cập nhật và dọn dẹp file tạm nếu phát hiện sai lệch mã băm hoặc file bị lỗi trong quá trình truyền tải.
- **Tự động sinh và đính kèm `checksums.sha256` khi phát hành:**
  - Script phát hành Windows (`publish_windows_local.py`): Tự động tính toán SHA-256 của `KOG_Studio.exe` và upload file `checksums.sha256` lên cả 2 repository.
  - Pipeline GitHub Actions macOS (`build-binaries.yml`): Tự động tạo `checksums.sha256` cho `KOG_Studio_macOS.zip` trước khi phát hành.
- **Nâng cấp trình cài đặt macOS (`install_macos.sh`):**
  - Tự động đồng bộ số phiên bản động `${LATEST_TAG#v}` vào `Info.plist` của file `.app`.
  - Xác thực mã băm SHA-256 của file zip trước khi giải nén ở cả bước cài mới và bước tự động cập nhật ngầm.

---

### 📁 3. Vệ Sinh & Bảo Vệ Repository Publish (`releases_repo`)
- Tạo lại file `.gitignore` nghiêm ngặt cho repository phát hành công khai (`KOG-HungTK-Studio-Releases`).
- Chống rò rỉ tuyệt đối các tệp nhạy cảm, cache, token, mã nguồn và tệp tạm lên môi trường public.

---

### 🧪 4. Kết Quả Nghiệm Thu & Kiểm Thử
- **100% PASS** toàn bộ 72/72 Test Cases trên cả 3 bộ công cụ (Scripts, Downloader, Video Editor Studio, Localize).
- **100% PASS** kiểm thử thực tế trên trình duyệt Playwright Chromium đối với cơ chế phân quyền RBAC và Admin Analytics.
