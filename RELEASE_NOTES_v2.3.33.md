# 🚀 KOG HungTK Studio Pro v2.3.33 - Khắc Phục Triệt Để macOS Read-Only, Tối Ưu Pacing Hub & Chống Sập Bộ Nhớ FFmpeg

Bản phát hành chính thức **v2.3.33** mang đến các nâng cấp toàn diện về độ ổn định đa nền tảng (đặc biệt là Apple macOS), khả năng chịu lỗi của luồng tải/hậu kỳ, triệt tiêu lỗi nạp nhầm khung trên Tab File Xuất Số và tối ưu hóa hệ thống xử lý video:

---

### 🍏 1. Khắc Phục Triệt Để Lỗi Quyền Ghi & AppTranslocation Trên Apple macOS
- **Chuẩn hóa thư mục làm việc an toàn (`~/KOG_HungTK_Studio`):**
  - Đồng bộ hóa logic `get_base_dir()` trên cả 3 module lõi (`core_ffmpeg.py`, `core_runtime_manager.py`, `core/common.py`).
  - Khi ứng dụng chạy dạng đóng gói (`sys.frozen == True`), chạy từ bundle `.app`, hoặc bị cơ chế bảo mật Gatekeeper cách ly trong phân vùng ảo **AppTranslocation** (`/private/var/folders/.../AppTranslocation/...`), hệ thống **luôn luôn sử dụng thư mục người dùng bền vững:** `~/KOG_HungTK_Studio`.
  - Triệt tiêu 100% lỗi crash `OSError: [Errno 30] Read-only file system` khi chạy công cụ Whisper AI Sorter và các tool xử lý video.
- **Cơ chế phòng vệ tự động (Defensive Fallback & Smart Output):**
  - Bổ sung hàm tiện ích `ensure_dir()` tự động bắt lỗi `OSError` và chuyển hướng lưu trữ sang thư mục an toàn.
  - Thêm cơ chế thông minh cho công cụ Phân loại ngôn ngữ: Tự động ưu tiên lưu kết quả cùng cấp với thư mục video nguồn nếu người dùng chọn thư mục riêng.

---

### 📊 2. Tối Ưu Hóa & Sửa Lỗi Tab File Xuất Số (Pacing Hub)
- **Khắc phục lỗi tự động nhảy cóc sang Khung 2 khi Khung 1 chưa có dữ liệu:**
  - Chuẩn hóa logic chọn khung nạp: Khi mở popup nạp file CSV, hệ thống kiểm tra `active_frames`. Nếu khung hiện tại chưa có dữ liệu (ví dụ sáng sớm `Khung 1` đang rỗng), **bắt buộc giữ nguyên Khung 1**, triệt tiêu hoàn toàn rủi ro Marketer bị nạp nhầm file đầu ngày sang Khung 2.
  - Chỉ gợi ý chuyển sang khung kế tiếp sau khi đã nạp thành công dữ liệu cho khung trước đó trong cùng phiên.
- **Triệt tiêu lỗi Stale Date hiển thị dữ liệu hôm trước:**
  - Luôn đánh giá ngày thực tế `datetime.date.today()` tại thời điểm gọi API thay vì phụ thuộc vào biến toàn cục tĩnh khi app mở qua đêm.
  - Frontend chủ động khởi tạo ngày hôm nay theo giờ máy khách ngay khi nạp trang.

---

### ⚙️ 3. Cơ Chế Auto-Sanitize File Ảnh Khổng Lồ (Chống Tràn Bộ Nhớ FFmpeg)
- **Tự động tối ưu hóa kích thước ảnh Logo / Frame / Icon:**
  - Bổ sung hàm `sanitize_image_asset()` tự động downscale ảnh có độ phân giải siêu lớn (> 2560px hoặc > 16M pixels) trước khi nạp vào FFmpeg.
  - Vô hiệu hóa cảnh báo `DecompressionBomb` của thư viện PIL, chuẩn hóa kích thước chẵn (divisible by 2) cho video encoder, bảo toàn 100% kênh trong suốt RGBA/Alpha.
  - Khắc phục lỗi crash bộ nhớ `[IMGUTILS] Picture size ... is invalid / INT_MAX/8 limit` trong `tool_intro_outro.py` và luồng upload asset, sửa filter scale FFmpeg từ `-1` sang `-2`.

---

### 🔄 4. Khắc Phục Lỗi Hậu Kỳ Pipeline & Chống Mất Video Gốc (Fault Tolerance)
- **Sửa lỗi `FileNotFoundError` trong bước Quét trùng lặp (Dedup):**
  - Tích hợp cơ chế tráo đổi file nguyên tử (atomic replace) và kiểm tra tính tồn tại của file trước khi can thiệp.
  - Nếu bất kỳ bước hậu kỳ nào (nén, tăng độ nét, gắn watermark) gặp sự cố đĩa cứng, hệ thống tự động bảo lưu file video gốc an toàn thay vì làm mất dữ liệu.
  - Bổ sung khả năng chịu lỗi (fault-tolerance): Tiếp tục xử lý các video còn lại trong batch tải nếu một file đơn lẻ bị lỗi.

---

### 📁 5. Cấu Hình Đóng Gói Standalone
- **Bổ sung Hidden Imports PyInstaller (`build_standalone.py`):**
  - Đảm bảo bản build standalone EXE/macOS tích hợp đầy đủ route của **Tab 9 (AdMob Matrix)** và **Tab 10 (MASR Funnel Studio)**.

---

### 📦 6. Đóng Gói & Triển Khai
- **Bản Windows (`KOG_Studio.exe`)**: Biên dịch Standalone Single-File Executable trực tiếp trên máy chủ Windows, tích hợp sẵn FFmpeg/FFprobe và tự động ép PE Subsystem = 2 (Windowed GUI - triệt tiêu hoàn toàn cửa sổ CMD).
- **Bản macOS (`KOG_Studio_macOS.zip`)**: Đóng gói tự động qua GitHub Actions CI/CD runner macOS mới nhất, hỗ trợ Native `.app` bundle và launcher `.command`.
