# 构建APK指南

## 方法：使用GitHub Actions自动构建

### 步骤1：创建GitHub仓库
1. 访问 https://github.com/new
2. 仓库名称：`RestReminder`
3. 设置为公开或私有都可以
4. 点击"Create repository"

### 步骤2：上传项目文件
**选项A：使用Git命令行**
```powershell
cd C:\Users\roro\Desktop\RestReminder
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/你的用户名/RestReminder.git
git push -u origin main
```

**选项B：直接在GitHub网页上传**
1. 在新建的仓库页面，点击"uploading an existing file"
2. 将所有文件拖拽上传
3. 点击"Commit changes"

### 步骤3：触发构建
1. 进入仓库页面
2. 点击"Actions"标签
3. 选择"Build Android APK"工作流
4. 点击"Run workflow"按钮
5. 选择分支（main），点击"Run workflow"

### 步骤4：下载APK
1. 等待构建完成（约3-5分钟）
2. 在Actions页面找到完成的工作流
3. 滚动到"Artifacts"部分
4. 点击"rest-reminder-apk"下载
5. 解压后得到 `app-debug.apk`

### 步骤5：安装到手机
1. 将APK文件传到手机（微信、QQ等）
2. 在手机上安装（需开启"允许未知来源"）
3. 享受休息提醒！

---

## 快速提示
- 每次修改代码后，只需推送到GitHub就会自动构建
- 构建历史会保存在Actions页面
- 可以随时下载任何历史版本的APK
