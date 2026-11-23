# 🚀 KOG HungTK Studio Pro v2.3.29 - Phân Quyền Admin Analytics Console, Tối Ưu GPU Toàn Diện & Tái Cấu Trúc Frontend Modular SPA

Bản phát hành chính thức **v2.3.29** đánh dấu bước chuyển mình lớn của KOG Studio Pro với việc ra mắt **Bảng điều khiển Admin Analytics Console**, kích hoạt **GPU Hardware Acceleration toàn diện**, bảo mật chống **Path Traversal**, dọn dẹp bộ nhớ tự động, và **tái cấu trúc toàn bộ Frontend SPA** sang kiến trúc mô-đun siêu gọn nhẹ.

---

### 👑 1. Nâng Cấp Độc Quyền: Phân Quyền Quản Trị & Admin Analytics Console
- **Phân quyền truy cập Backend tuyệt đối**:
  - Cơ chế nhận diện Quản trị viên tối cao: Tự động kiểm tra Hardware UUID (`E8753FA2-E5C5-4EB3-BDCF-C85309BA9559`), tên license chứa `hungtk`, hoặc khóa bảo mật Admin Key.
  - Marketer thông thường khi gọi API `/api/system/usage-stats` sẽ bị **chặn đứng với mã HTTP 403 Forbidden**.
- **Giao diện Dashboard Admin Analytics riêng biệt**:
  - Trên giao diện của Marketer thường: Hoàn toàn không hiển thị nút hay menu Admin Analytics.
  - Trên giao diện của Admin (HungTK): Xuất hiện nút nổi bật **"👑 Admin Analytics"** trên thanh Header.
  - Modal Dashboard trực quan hiện đại:
    - **4 Thẻ KPI**: Tổng lượt thực thi, Số Marketer hoạt động, Số tính năng đã theo dõi, Thời gian cập nhật gần nhất.
    - **Tab 1: Xếp hạng Tính Năng (Top Features)**: Bảng thống kê tần suất sử dụng kèm thanh tỷ lệ % progress bar màu gradient và danh sách Marketers đang sử dụng.
    - **Tab 2: Xếp hạng Marketers (Top Users)**: Thống kê chi tiết từng Marketer trong team đã thao tác bao nhiêu lần, lần hoạt động cuối và top tính năng yêu thích.
    - Nút *"🔄 Làm mới dữ liệu"* và *"🗑️ Đặt lại bộ đếm"*.

---

### ⚡ 2. Phase 1: Hiệu Năng GPU Toàn Diện, Bền Vững Bộ Nhớ & KOG AI Brain v2.5
- **Khắc phục triệt để lỗi Cache Unity Performance Engine (`unity_performance_engine.py`)**:
  - Tích hợp `_get_persistent_base_dir()` và `set_storage_dir(custom_dir)`.
  - Khử triệt để rủi ro ghi cache vào thư mục tạm `%TEMP%/_MEIxxxxxx` của PyInstaller, tự động bind vào thư mục gốc `BASE_DIR`.
- **Kích hoạt GPU Hardware Acceleration toàn diện (`core_ffmpeg.py`)**:
  - Live-probe và tự động kích hoạt `h264_nvenc` (NVIDIA), `h264_videotoolbox` (Apple Silicon), `h264_qsv` (Intel) và `h264_amf` (AMD).
  - Bổ sung cấu hình tối ưu tham số codec và CQ cho AMD AMF (`-quality speed`).
- **Nâng cấp KOG AI Assistant Brain v2.5 (`ai_assistant.py`)**:
  - Cập nhật trọn vẹn tri thức của toàn bộ 8 Tab và 14 công cụ Video Editor.
  - Bổ sung chuyên sâu Tab 7 (Template Check Ver - Rollout Analytics T+1) và Tab 8 (Unity Realtime Performance Hub).
  - Tích hợp tri thức Pacing Khung $N-1$ và nhận diện Marketer 4 tầng.

---

### 🛡️ 3. Phase 2: An Ninh Bảo Mật, Tự Dọn Rác & KOG Feature Usage Analytics
- **Bảo mật Path Traversal & Whitelist tải tệp Zip (`routers/editor.py`)**:
  - Chặn đứng 100% các cuộc tấn công truy cập file tùy ý qua Path Traversal (`../..`).
  - Thiết lập Whitelist nghiêm ngặt `ALLOWED_ZIP_FOLDERS` chỉ cho phép xuất zip từ các thư mục hợp lệ: `FinalVideos`, `Subtitles`, `Voiceovers`, `Covers`.
- **Tự động dọn dẹp bộ nhớ & tệp tạm Zip (`routers/editor.py`)**:
  - Tích hợp `BackgroundTasks` của FastAPI xóa sạch file `.zip` phát sinh trong `Temp/` ngay sau khi client hoàn tất tải về, chống phình ổ đĩa người dùng.
- **Triệt tiêu Zombie Process khi Hủy tác vụ (`core/common.py`)**:
  - Nâng cấp `cancel_task` diệt sạch toàn bộ Process Tree (`taskkill /F /T` trên Windows, `os.killpg` trên macOS/POSIX).
  - Loại bỏ hoàn toàn sự cố tiến trình ffmpeg/yt-dlp chạy ngầm tiêu tốn CPU/RAM khi bấm Hủy.
- **Hệ thống Telemetry Thread-Safe (`core/telemetry.py`)**:
  - Quản lý bền vững dữ liệu `.feature_usage_stats.json` với `threading.RLock()`.
  - Theo dõi lượt dùng tính năng trên 8 Routers và chuyển Tab thời gian thực (`POST /api/system/track-action`), hoàn toàn ẩn danh (Zero-PII).

---

### 🎨 4. Phase 3: Tái Cấu Trúc Frontend Modular SPA & Tối Ưu Caching
- **Thu gọn `index.html` từ 12.941 dòng xuống còn 925 dòng**:
  - Tách toàn bộ 8 Tab nghiệp vụ thành sub-templates Jinja2 tại thư mục `templates/tabs/`:
    - `tab_scripts.html`, `tab_downloader.html`, `tab_editor.html`, `tab_localize.html`
    - `tab_ai.html`, `tab_pacing.html`, `tab_checker.html`, `tab_unity.html`
  - Tách hệ thống modal hội thoại vào `templates/modals/modals.html`.
- **Tách mã nguồn JavaScript mô-đun**:
  - Logic cốt lõi và các tính năng phân tích chuyển sang `static/js/app_core.js` và `static/js/app_analytics.js`.
  - Giảm thiểu độ trễ tải trang ban đầu và tận dụng tối đa Browser Caching.

---

### 🧪 5. Nghiệm Thu & Kiểm Thử
- **Toàn bộ 36/36 Test Cases đạt 100% PASS** trên binary live thông qua kịch bản kiểm thử tự động Playwright (`tests/test_demo_full_comprehensive.py`).

---

### 📦 6. Đóng Gói & Cài Đặt
- **Bản Windows (`KOG_Studio.exe`)**: Biên dịch Standalone Single-File Executable trực tiếp trên máy chủ Windows, tích hợp sẵn FFmpeg/FFprobe và tự động ép PE Subsystem = 2 (Windowed GUI - triệt tiêu cửa sổ CMD).
- **Bản macOS (`KOG_Studio_macOS.zip`)**: Đóng gói tự động qua GitHub Actions CI/CD runner macOS mới nhất, hỗ trợ Native `.app` bundle và launcher `.command`.
