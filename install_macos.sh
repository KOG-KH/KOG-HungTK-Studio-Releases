#!/usr/bin/env bash
# ====================================================================
#         KOG HUNGTK STUDIO PRO - 1-CLICK INSTALLER FOR MACOS
#   Tự động cài đặt, cấp quyền, vượt Gatekeeper, Auto-Update & Native macOS App (.app)
# ====================================================================

set -e

echo ""
echo "=========================================================="
echo "   🚀 ĐANG CÀI ĐẶT KOG HUNGTK STUDIO PRO CHO MACOS..."
echo "=========================================================="
echo ""

INSTALL_DIR="$HOME/KOG_HungTK_Studio"
LATEST_TAG=$(curl -s --max-time 10 "https://api.github.com/repos/KOG-KH/KOG-HungTK-Studio-Releases/releases/latest" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v2.2.15"
fi
RELEASE_URL="https://github.com/KOG-KH/KOG-HungTK-Studio-Releases/releases/download/${LATEST_TAG}/KOG_Studio_macOS.zip"
MIRROR_URL="https://ghfast.top/$RELEASE_URL"
ZIP_FILE="$INSTALL_DIR/KOG_Studio_macOS.zip"
DESKTOP_DIR="$HOME/Desktop"
DESKTOP_OLD_COMMAND="$DESKTOP_DIR/KOG HungTK Studio.command"
DESKTOP_APP="$DESKTOP_DIR/KOG HungTK Studio.app"

# 0. Đảm bảo tắt tiến trình cũ nếu đang chạy ngầm
killall -9 KOG_Studio 2>/dev/null || true

# 1. Tạo thư mục làm việc riêng biệt
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# 2. Tải bản phát hành độc lập từ CDN Mirror hoặc GitHub Release
echo "[1/4] 📥 Đang tải KOG HungTK Studio ($LATEST_TAG ~18 MB)..."
if ! curl -fSL --connect-timeout 8 --progress-bar "$MIRROR_URL" -o "$ZIP_FILE"; then
    echo "[!] CDN Mirror bận, chuyển sang tải trực tiếp từ GitHub Releases..."
    curl -fSL --progress-bar "$RELEASE_URL" -o "$ZIP_FILE"
fi

# 3. Tự động giải nén & lưu phiên bản
echo "[2/4] 📦 Đang giải nén bộ cài đặt..."
unzip -q -o "$ZIP_FILE" -d "$INSTALL_DIR"
rm -f "$ZIP_FILE"
echo "$LATEST_TAG" > "$INSTALL_DIR/version.txt"

# 4. Kiểm tra & tự động tích hợp FFmpeg độc lập (Zero-Dependency - Không cần Homebrew)
BIN_DIR="$INSTALL_DIR/bin"
mkdir -p "$BIN_DIR"
if ! command -v ffmpeg &> /dev/null && [ ! -f "$INSTALL_DIR/ffmpeg" ] && [ ! -f "$BIN_DIR/ffmpeg" ] && [ ! -f "/opt/homebrew/bin/ffmpeg" ] && [ ! -f "/usr/local/bin/ffmpeg" ]; then
    echo "[3/5] 🎥 Đang thiết lập FFmpeg độc lập cho macOS (Không cần cài Homebrew)..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        FFMPEG_URL="https://github.com/Tyrrrz/FFmpegBin/releases/download/9.0.2/ffmpeg-osx-arm64.zip"
    else
        FFMPEG_URL="https://github.com/Tyrrrz/FFmpegBin/releases/download/9.0.2/ffmpeg-osx-x64.zip"
    fi
    FFMPEG_ZIP="$INSTALL_DIR/ffmpeg_temp.zip"
    if curl -fSL --progress-bar "$FFMPEG_URL" -o "$FFMPEG_ZIP"; then
        unzip -q -o "$FFMPEG_ZIP" -d "$BIN_DIR" 2>/dev/null || unzip -q -o "$FFMPEG_ZIP" -d "$INSTALL_DIR" 2>/dev/null
        rm -f "$FFMPEG_ZIP"
        chmod +x "$BIN_DIR/ffmpeg" "$BIN_DIR/ffprobe" 2>/dev/null || true
        chmod +x "$INSTALL_DIR/ffmpeg" "$INSTALL_DIR/ffprobe" 2>/dev/null || true
        xattr -cr "$BIN_DIR" 2>/dev/null || true
        echo "      ✅ Đã tích hợp FFmpeg & FFprobe độc lập thành công!"
    else
        echo "      ⚠️ Không thể tải tự động FFmpeg. Bạn có thể cài qua: brew install ffmpeg"
        rm -f "$FFMPEG_ZIP"
    fi
else
    echo "[3/5] 🎥 FFmpeg đã sẵn sàng trên hệ thống."
fi

# 5. Cấp quyền thực thi và gỡ bỏ kiểm duyệt macOS Gatekeeper (Quarantine)
echo "[4/5] 🔑 Đang cấp quyền thực thi & vượt bảo mật macOS Gatekeeper..."
chmod +x "$INSTALL_DIR/KOG_Studio"
xattr -cr "$INSTALL_DIR/KOG_Studio" 2>/dev/null || true

# 6. Đóng gói Native macOS App Bundle (.app) & Đè lên file .command cũ
echo "[5/5] 🍏 Đang đóng gói ứng dụng Native 'KOG HungTK Studio.app' ngoài Desktop..."
HAD_OLD_COMMAND=false
if [ -f "$DESKTOP_OLD_COMMAND" ]; then
    HAD_OLD_COMMAND=true
    rm -f "$DESKTOP_OLD_COMMAND" 2>/dev/null || true
    echo "      🔄 Đã phát hiện và dọn dẹp file cũ: KOG HungTK Studio.command"
fi

if [ -d "$DESKTOP_DIR" ]; then
    rm -rf "$DESKTOP_APP" 2>/dev/null || true
    mkdir -p "$DESKTOP_APP/Contents/MacOS"
    mkdir -p "$DESKTOP_APP/Contents/Resources"

    # Tạo Info.plist chuẩn macOS Application
    cat << 'EOF' > "$DESKTOP_APP/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launcher</string>
    <key>CFBundleIdentifier</key>
    <string>com.kog.hungtkstudio</string>
    <key>CFBundleName</key>
    <string>KOG HungTK Studio</string>
    <key>CFBundleDisplayName</key>
    <string>KOG HungTK Studio</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.2.11</string>
    <key>CFBundleVersion</key>
    <string>2.2.11</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

    # Tạo launcher thực thi ngầm 100% No-Console kèm Auto-Update
    cat << 'EOF' > "$DESKTOP_APP/Contents/MacOS/launcher"
#!/usr/bin/env bash
# ====================================================================
#     KOG HUNGTK STUDIO PRO - NATIVE MACOS APP LAUNCHER (AUTO-UPDATE)
# ====================================================================

INSTALL_DIR="$HOME/KOG_HungTK_Studio"
VERSION_FILE="$INSTALL_DIR/version.txt"
export PATH="$INSTALL_DIR/bin:$INSTALL_DIR:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

cd "$INSTALL_DIR" || exit 1

# Tự động dọn dẹp file .command cũ nếu còn sót lại ngoài Desktop
rm -f "$HOME/Desktop/KOG HungTK Studio.command" 2>/dev/null || true

# Kiểm tra cập nhật ngầm từ GitHub Release (timeout 3 giây tránh treo nếu mạng lag)
LATEST_TAG=$(curl -s --max-time 3 "https://api.github.com/repos/KOG-KH/KOG-HungTK-Studio-Releases/releases/latest" 2>/dev/null | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
CURRENT_TAG=""
[ -f "$VERSION_FILE" ] && CURRENT_TAG=$(cat "$VERSION_FILE" 2>/dev/null | tr -d '[:space:]')

if [ -n "$LATEST_TAG" ] && [ "$LATEST_TAG" != "$CURRENT_TAG" ]; then
    osascript -e "display notification \"Đang tự động nâng cấp lên $LATEST_TAG...\" with title \"KOG HungTK Studio\" subtitle \"Tự động cập nhật ngầm\"" 2>/dev/null || true
    
    ZIP_URL="https://github.com/KOG-KH/KOG-HungTK-Studio-Releases/releases/download/${LATEST_TAG}/KOG_Studio_macOS.zip"
    ZIP_FILE="$INSTALL_DIR/update_temp.zip"
    
    if curl -fSL "$ZIP_URL" -o "$ZIP_FILE" 2>/dev/null; then
        killall -9 KOG_Studio 2>/dev/null || true
        unzip -q -o "$ZIP_FILE" -d "$INSTALL_DIR"
        rm -f "$ZIP_FILE"
        chmod +x "$INSTALL_DIR/KOG_Studio"
        xattr -cr "$INSTALL_DIR/KOG_Studio" 2>/dev/null || true
        echo "$LATEST_TAG" > "$VERSION_FILE"
        osascript -e "display notification \"Đã cập nhật thành công lên $LATEST_TAG!\" with title \"KOG HungTK Studio\"" 2>/dev/null || true
    else
        rm -f "$ZIP_FILE"
    fi
fi

exec "$INSTALL_DIR/KOG_Studio"
EOF

    chmod +x "$DESKTOP_APP/Contents/MacOS/launcher"
    xattr -cr "$DESKTOP_APP" 2>/dev/null || true
fi

echo ""
echo "=========================================================="
echo "   🎉 CÀI ĐẶT THÀNH CÔNG KOG HUNGTK STUDIO PRO!"
echo "   📁 Thư mục cài đặt: $INSTALL_DIR"
if [ -d "$DESKTOP_DIR" ]; then
    echo "   🍏 Đã tạo ứng dụng: $DESKTOP_APP"
    echo "   ✨ 100% Native App: Double click mở ngay, không còn cửa sổ Terminal đen!"
    echo "   🔄 Đã tích hợp Silent Auto-Update mỗi khi khởi chạy!"
fi
echo "   💡 XÁC THỰC THIẾT BỊ: Liên hệ HungTK qua Discord, cung cấp"
echo "      User Name và Device ID để được cấp quyền sử dụng."
echo "=========================================================="
echo ""

# Hiển thị thông báo Toast / Dialog macOS cho người dùng
if [ "$HAD_OLD_COMMAND" = true ]; then
    osascript -e 'display dialog "🎉 KOG HungTK Studio đã được nâng cấp thành công sang file .app ngoài Desktop!\n\nFile cũ (.command) đã được gỡ bỏ. Từ bây giờ bạn chỉ cần Double Click vào biểu tượng .app để mở Studio mà không còn bị hiện cửa sổ Terminal đen." with title "KOG HungTK Studio Pro" buttons {"Bắt đầu sử dụng"} default button "Bắt đầu sử dụng"' 2>/dev/null || true
fi

echo "👉 Đang khởi động KOG HungTK Studio ngay bây giờ..."
echo ""

exec "$INSTALL_DIR/KOG_Studio"
