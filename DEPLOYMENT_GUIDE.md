# 用户端平台部署指南

## 📦 已完成的工作

### 1. 数据库层 ✅
- ✅ 创建了5个新数据表（banner, activity, user_browse_history, hot_recommendation, user_activity_participant）
- ✅ 提供了完整的SQL文件和初始数据
- ✅ 文档：`travel-server/sql/README_USER_PLATFORM.md`

### 2. 后端API层 ✅
- ✅ 实体类（Banner, Activity, UserBrowseHistory, HotRecommendation）
- ✅ Mapper接口和XML配置
- ✅ Service层（接口和实现类）
- ✅ Controller层（管理端和用户端）

### 3. 前端用户端页面 ✅
- ✅ 用户首页（轮播图、活动、热门推荐）- `src/views/user/dashboard/index.vue`
- ✅ 我的攻略页面 - `src/views/user/plans/index.vue`
- ✅ 收藏景点页面 - `src/views/user/attractions/index.vue`
- ⏳ AI生成页面（需完善）
- ⏳ 个性标签页面（需完善）
- ⏳ 文旅对接页面（需完善）

### 4. 前端管理端页面
- ⏳ 轮播图管理
- ⏳ 活动管理
- ⏳ 热门推荐管理

## 🚀 快速部署步骤

### 第一步：执行SQL创建表

**Windows PowerShell:**
```powershell
cd travel-server
Get-Content sql\create_user_platform_tables.sql | mysql -u root -p travel_db
```

**或者使用MySQL客户端:**
```bash
# 1. 连接MySQL
mysql -u root -p

# 2. 使用数据库
use travel_db;

# 3. 复制 travel-server/sql/create_user_platform_tables.sql 的内容并执行
```

**或者使用Navicat/DBeaver等工具:**
1. 打开 `travel-server/sql/create_user_platform_tables.sql`
2. 复制全部内容
3. 在SQL编辑器中执行

### 第二步：重启后端服务

```bash
cd travel-server
mvn clean install
mvn spring-boot:run
```

### 第三步：刷新前端

强制刷新浏览器（Ctrl + Shift + R）或清除缓存后访问

## 📊 验证部署

### 1. 检查数据表
```sql
SHOW TABLES;
-- 应该看到: banner, activity, user_browse_history, hot_recommendation, user_activity_participant

SELECT * FROM banner;
-- 应该有5条初始数据

SELECT * FROM activity;
-- 应该有3条初始数据

SELECT * FROM hot_recommendation;
-- 应该有6条初始数据
```

### 2. 测试后端API
访问 Swagger 文档：http://localhost:8080/doc.html

应该看到以下新增接口：
- 管理端-轮播图管理
- 管理端-活动管理
- 管理端-热门推荐管理
- 用户端-首页
- 用户端-浏览历史

### 3. 测试前端页面
登录管理端后，访问用户端：
1. 用户首页 - 应该看到轮播图、活动、热门景点等
2. 我的攻略 - 应该看到美化后的网格布局
3. 我的收藏 - 应该看到美化后的收藏列表

## 🎨 页面特色

### 用户首页
- 🎬 大图轮播（5秒自动切换）
- 🚀 6个快捷导航卡片
- ⭐ 精彩活动展示
- 📍 热门景点推荐
- 📝 热门攻略推荐
- ✨ 编辑精选推荐

### 我的攻略
- 📊 4个统计卡片（总攻略、浏览量、点赞数、收藏数）
- 🎴 卡片式网格布局
- 🔍 筛选和搜索功能
- 📄 分页展示
- 🎯 状态标识（草稿/已发布/待审核）

### 我的收藏
- 📊 3个统计卡片（总收藏、景点收藏、攻略收藏）
- 🏷️ 分类标签切换（全部/景点/攻略）
- ☑️ 批量删除功能
- 🎴 卡片式展示
- 📄 分页展示

## 🔧 管理端对接

管理端可以管理以下内容（需要创建管理端页面）：

### 1. 轮播图管理
- 路径：`/home/admin/banner`
- 功能：增删改查、状态控制、显示顺序调整
- 效果：修改后用户端首页立即生效

### 2. 活动管理
- 路径：`/home/admin/activity`
- 功能：创建活动、编辑活动、状态控制
- 效果：活动在用户端首页展示

### 3. 热门推荐管理
- 路径：`/home/admin/recommendation`
- 功能：添加推荐、设置推荐类型、调整顺序
- 效果：推荐内容在用户端首页展示

## 📝 下一步工作

### 优先级1：完善用户端剩余页面
1. ✅ AI生成页面 - 美化表单和结果展示
2. ✅ 个性标签页面 - 优化标签选择界面
3. ✅ 文旅对接页面 - 完善商业对接展示

### 优先级2：创建管理端页面
1. ⭐ 轮播图管理页面 - 表格+表单
2. ⭐ 活动管理页面 - 表格+富文本编辑器
3. ⭐ 热门推荐管理页面 - 表格+关联选择

### 优先级3：功能增强
1. 用户浏览历史记录和展示
2. 基于浏览历史的个性化推荐
3. 活动参与统计
4. 数据看板和可视化

## 🐛 常见问题

### Q1: SQL执行失败？
**A:** 检查是否已经存在同名表，如果存在需要先删除或修改SQL中的DROP TABLE语句。

### Q2: 后端启动报错找不到Mapper？
**A:** 检查mapper XML文件路径是否正确，确保在 `src/main/resources/mapper/` 目录下。

### Q3: 前端页面空白或报错？
**A:** 
1. 检查浏览器控制台错误信息
2. 确认后端API是否正常运行
3. 清除浏览器缓存后重试

### Q4: 图片无法显示？
**A:** 示例数据使用的是 Unsplash 图片链接，需要网络连接。可以替换为本地图片或其他图床。

## 📞 技术支持

如遇问题，请检查：
1. 数据库表是否创建成功
2. 后端服务是否正常运行
3. 前端路由配置是否正确
4. API接口是否可访问

## 🎉 完成标志

当你看到：
1. ✅ 用户首页展示轮播图、活动、推荐内容
2. ✅ 我的攻略页面展示卡片式网格布局
3. ✅ 我的收藏页面可以筛选和管理收藏

说明部署成功！







