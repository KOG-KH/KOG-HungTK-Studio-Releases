# 🚀 KOG HungTK Studio Pro v2.3.26 - Kiến Trúc AI 4 Tầng & Tăng Tốc GPU Cloud (Google Colab T4)

Bản phát hành chính thức **v2.3.26** mang đến bước nhảy vọt về hiệu năng nhận diện và phân loại video thông minh, giải phóng 100% tài nguyên CPU của máy người dùng thông qua việc kết hợp Google Gemini Flash API và cụm GPU Tesla T4 miễn phí trên Google Colab.

---

### ⚡ 1. Nâng Cấp Nút Điều Hướng Topbar: `⚡ Cấu Hình AI & GPU`
- Thay thế 2 nút `Setup` và `Hướng Dẫn` trên thanh menu ngang bằng một nút bấm duy nhất **`⚡ Cấu Hình AI & GPU`**.
- Mở modal cấu hình trung tâm cho toàn bộ ứng dụng, cho phép người dùng:
  - Nhập **Google Gemini API Key** (Tầng 1).
  - Nhập **Google Colab GPU URL** (Tầng 2).
  - Bấm nút **"Kiểm Tra Kết Nối"** để kiểm tra ngay trạng thái GPU Worker (hiển thị model GPU như NVIDIA Tesla T4, trạng thái CUDA, độ trễ).
  - Truy cập trực tiếp link Colab Notebook được chuẩn hóa cho team.

---

### 🧠 2. Hệ Thống Nhận Diện Ngôn Ngữ Video 4 Tầng Thông Minh (4-Tier Fallback)
Tính năng **Sort Video By Language** trong 2 tab *Video Downloader* và *Video Editor* nay hoạt động theo cơ chế chịu lỗi tối đa:
- **Tầng 0 (Nhãn file - 0s, 0 token)**: Nhận diện mã ngôn ngữ trực tiếp từ tên file (`[ES]`, `_VI`, `EN`,...).
- **Tầng 1 (Google Gemini Audio API - ~0.8s, 0% CPU)**: Cắt nhanh 4 giây âm thanh cực nhẹ để Gemini Flash nhận diện ngôn ngữ audio. Tốc độ vượt trội, độ chính xác cao.
- **Tầng 2 (Google Colab Tesla T4 GPU Worker)**: Khi Gemini chạm giới hạn token hoặc có nhu cầu xử lý hàng loạt, hệ thống tự động đẩy audio qua Cloudflare Tunnel lên GPU T4 trên Google Colab để Whisper Small GPU xử lý song song.
- **Tầng 3 (Local Whisper AI)**: Dự phòng xử lý ngoại tuyến ngay trên máy tính của người dùng khi không có kết nối internet/API.
- **Tầng 4 (Metadata & Phân Tích Tiêu Đề)**: Quét metadata audio stream qua FFprobe kết hợp phân tích tiêu đề ngữ nghĩa.
- **Cơ chế Circuit Breaker (Ngắt mạch thông minh)**: Tự động ghi nhớ lỗi 429 quá tải hoặc Colab offline trong phiên làm việc, tự động chuyển tầng dự phòng tức thì mà không gây nghẽn tiến trình.

---

### ☁️ 3. Google Colab GPU Worker Template
- Cung cấp script backend Colab chuẩn hóa FastAPI + Uvicorn + Whisper GPU + PyCloudflare.
- Giao diện Colab thân thiện: Hướng dẫn rõ ràng, hiển thị URL Cloudflare Tunnel trong box riêng kèm nút **Copy 1-Click**.
- Hỗ trợ auto-kill tiến trình cũ trên port 8000, chống xung đột khi chạy lại cell.

---

### 📦 4. Cải Tiến Đóng Gói & Tự Động Cập Nhật
- Bản Windows `KOG_Studio.exe` tích hợp sẵn bộ binary FFmpeg/FFprobe chuẩn 60MB, chạy độc lập không phụ thuộc môi trường ngoài.
- Bản macOS hỗ trợ Universal/Native App Bundle và shell script cài đặt 1 dòng lệnh.
- Ứng dụng tự động thông báo cập nhật phiên bản mới khi khởi động.
