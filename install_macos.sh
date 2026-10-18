#!/usr/bin/env bash
# ====================================================================
#         KOG HUNGTK STUDIO PRO - 1-CLICK INSTALLER FOR MACOS
#   Tự động cài đặt, cấp quyền, vượt Gatekeeper & tạo icon Desktop
# ====================================================================

set -e

echo ""
echo "=========================================================="
echo "   🚀 ĐANG CÀI ĐẶT KOG HUNGTK STUDIO PRO CHO MACOS..."
echo "=========================================================="
echo ""

INSTALL_DIR="$HOME/KOG_HungTK_Studio"
LATEST_TAG=$(curl -s "https://api.github.com/repos/KOG-KH/KOG-HungTK-Studio-Releases/releases/latest" | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v2.0.0"
fi
RELEASE_URL="https://github.com/KOG-KH/KOG-HungTK-Studio-Releases/releases/download/${LATEST_TAG}/KOG_Studio_macOS.zip"
ZIP_FILE="$INSTALL_DIR/KOG_Studio_macOS.zip"
DESKTOP_DIR="$HOME/Desktop"
DESKTOP_LAUNCHER="$DESKTOP_DIR/KOG HungTK Studio.command"

# 1. Tạo thư mục làm việc riêng biệt
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# 2. Tải bản phát hành độc lập từ GitHub Release
echo "[1/4] 📥 Đang tải KOG HungTK Studio (~18 MB) từ GitHub..."
curl -fSL --progress-bar "$RELEASE_URL" -o "$ZIP_FILE"

# 3. Tự động giải nén
echo "[2/4] 📦 Đang giải nén bộ cài đặt..."
unzip -q -o "$ZIP_FILE" -d "$INSTALL_DIR"
rm -f "$ZIP_FILE"

# 4. Cấp quyền thực thi và gỡ bỏ kiểm duyệt macOS Gatekeeper (Quarantine)
echo "[3/4] 🔑 Đang cấp quyền thực thi & vượt bảo mật macOS Gatekeeper..."
chmod +x "$INSTALL_DIR/KOG_Studio"
xattr -cr "$INSTALL_DIR/KOG_Studio" 2>/dev/null || true

# 5. Tạo biểu tượng khởi động nhanh ngoài Desktop
echo "[4/4] 🖥️  Đang tạo shortcut 'KOG HungTK Studio' ngoài Desktop..."
if [ -d "$DESKTOP_DIR" ]; then
cat << 'EOF' > "$DESKTOP_LAUNCHER"
#!/usr/bin/env bash
cd "$HOME/KOG_HungTK_Studio"
./KOG_Studio
EOF
chmod +x "$DESKTOP_LAUNCHER"
xattr -cr "$DESKTOP_LAUNCHER" 2>/dev/null || true
fi

echo ""
echo "=========================================================="
echo "   🎉 CÀI ĐẶT THÀNH CÔNG KOG HUNGTK STUDIO PRO!"
echo "   📁 Thư mục cài đặt: $INSTALL_DIR"
if [ -d "$DESKTOP_DIR" ]; then
echo "   🖥️  Đã tạo icon 'KOG HungTK Studio' ngoài Desktop!"
fi
echo "   💡 XÁC THỰC THIẾT BỊ: Liên hệ HungTK qua Discord, cung cấp"
echo "      User Name và Device ID để được cấp quyền sử dụng."
echo "=========================================================="
echo ""
echo "👉 Đang khởi động KOG HungTK Studio ngay bây giờ..."
echo ""

exec "$INSTALL_DIR/KOG_Studio"
