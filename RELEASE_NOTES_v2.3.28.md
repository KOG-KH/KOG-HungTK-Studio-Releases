# 🚀 KOG HungTK Studio Pro v2.3.28 - Sửa Lỗi Khởi Chạy Video Downloader & Tối Ưu Hóa Nhịp Độ Pacing Thông Minh

Bản phát hành chính thức **v2.3.28** tập trung giải quyết triệt để sự cố khởi chạy Video Downloader, nâng cấp độ tin cậy của bộ bóc tách link đa nền tảng, hoàn thiện cơ chế tự động nhảy khung giờ so sánh Pacing Hub và tự động nhận diện danh tính Marketer đồng bộ Google Sheets.

---

### 📥 1. Khắc Phục Triệt Để Lỗi Khởi Chạy Video Downloader
- **Sửa lỗi "Chưa nhập danh sách đường link cần tải"**:
  - Chuẩn hóa hoàn toàn schema payload giữa Frontend và Backend Router (`urls` $\leftrightarrow$ `links`), giải quyết sự cố bị từ chối lệnh tải dù người dùng đã nhập link đầy đủ.
  - Bộ phân tích link thông minh: Tự động chuẩn hóa danh sách link dán trực tiếp, hỗ trợ nhiều dòng, khoảng trắng hoặc dấu phẩy phân tách mà không làm ảnh hưởng đến query parameters phức tạp.
  - Tối ưu hóa tải luồng CDN Direct: Nhận diện chính xác và tải mượt mà các link video trực tiếp từ **SocialPeta / Zingfront CDN**, Facebook Ads Library, TikTok và YouTube.
- **Khôi phục Realtime Task Logging & Console Stream (SSE)**:
  - Khôi phục bộ chuyển luồng `TASK_STDOUT_PROXY.set_thread_logger` trong worker của cả All-in-One Downloader và Bulk Channel Downloader, đảm bảo toàn bộ tiến trình tải (tốc độ tải, dung lượng, % hoàn thành) được đẩy trực tiếp về giao diện theo thời gian thực.
  - Bổ sung hàm alias tương thích ngược `download_all_in_one` trong `tool_all_in_one_downloader.py`.

---

### ⏱️ 2. Tối Ưu Hóa Pacing Hub & So Sánh Khung Giờ Thông Minh
- **Tự động nhảy khung liền kề trước**:
  - Ô *"So Sánh Với"* (`pacingFramePrev`) tự động nhảy sang khung liền kề trước của *"Khung Hiện Tại"* (`pacingFrameCurr`):
    - *Khung 1* $\rightarrow$ `(Không so sánh)` (để trống).
    - *Khung 2* $\rightarrow$ So sánh với `Khung 1`.
    - *Khung 3* $\rightarrow$ So sánh với `Khung 2`... Khung N $\rightarrow$ Khung N-1.
  - Tự động kích hoạt khi chọn Khung hiện tại hoặc ngay sau khi nạp tệp Excel dữ liệu.
- **Cơ chế 4 tầng nhận diện Tên Marketer / Máy đồng bộ Google Sheets**:
  - Xóa bỏ triệt để mọi chuỗi fallback tĩnh (`HungTK Home`, `HungTK Work`), nhận diện linh hoạt:
    1. *Tên tùy chỉnh*: Marketer nhập và lưu trong cấu hình.
    2. *Tên bản quyền*: Lấy tự động theo thiết bị được cấp phép từ Cloud Gateway.
    3. *Tên máy hệ điều hành*: Computer Name / Hostname máy tính.
    4. *Fallback*: Trả về `'Marketer'` an toàn.

---

### 🛡️ 3. Nâng Cấp Sentinel Diagnostic & Auto-Updater
- **Sentinel Diagnostic thông minh hơn**:
  - Mở rộng regex phát hiện lỗi sang các tiền tố `[LỖI]`, `❌`, `error`, `fail`, `lỗi`.
  - Khi phát sinh lỗi khởi chạy, giao diện lập tức cập nhật thanh tiến trình về 0%, hiển thị chi tiết nguyên nhân và chuyển badge sang trạng thái `Thất bại`.
- **Auto-Updater êm ái**:
  - Bổ sung cờ `--no-browser` (`-nb`) trong `main.py` và `web_app.py`, ngăn chặn việc mở tab trình duyệt thừa khi ứng dụng tự khởi động lại sau khi cập nhật.

---

### 📦 4. Đóng Gói & Cài Đặt
- **Bản Windows (`KOG_Studio.exe`)**: Biên dịch hybrid C-Extension bảo mật mã nguồn, tích hợp sẵn FFmpeg/FFprobe đầy đủ, chạy trực tiếp không cần cài đặt Python.
- **Bản macOS (`KOG_Studio_macOS.zip`)**: Hỗ trợ Native macOS Application Bundle (`.app`) và launcher `.command`, tương thích mượt mà macOS Ventura, Sonoma, Sequoia.
