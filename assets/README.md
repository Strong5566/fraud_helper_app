# 圖片資源架構說明

## 資料夾結構

```
assets/
├── images/
│   ├── icons/          # 小圖示 (16x16 到 48x48)
│   │   ├── chat.png
│   │   ├── history.png
│   │   ├── achievement.png
│   │   └── settings.png
│   ├── logos/          # 應用程式 Logo
│   │   ├── app_logo.png
│   │   └── app_logo_white.png
│   ├── illustrations/  # 插圖、圖解
│   │   ├── fraud_warning.png
│   │   └── success_check.png
│   ├── backgrounds/    # 背景圖片
│   │   ├── chat_bg.png
│   │   └── splash_bg.png
│   └── avatars/        # 頭像圖片
│       ├── bot_avatar.png
│       └── user_avatar.png
└── fonts/             # 自定義字體 (如需要)
```

## 使用建議

### 1. 圖片命名規則
- 使用小寫字母和底線：`app_logo.png`
- 描述性命名：`fraud_warning_icon.png`
- 避免空格和特殊字符

### 2. 解析度支援
- 基礎圖片放在 `images/` 根目錄
- 高解析度版本放在對應的 `1.5x/`, `2.0x/`, `3.0x/` 資料夾
- Flutter 會自動選擇適合的解析度

### 3. 圖片格式建議
- **PNG**: 透明背景、圖示、Logo
- **JPG**: 照片、複雜背景圖
- **SVG**: 向量圖示 (需要 flutter_svg 套件)

### 4. 檔案大小建議
- 圖示: < 10KB
- Logo: < 50KB  
- 背景圖: < 200KB
- 插圖: < 100KB