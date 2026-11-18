# 摩旅 · 川藏线

> 这是**玩法原型**（单线 318 · 侧视卷轴），用来验证手感。
>
> - 玩法方案：**[docs/design.md](docs/design.md)**（全国路网、选车选装备、季节路况、景点打卡）
> - 视觉方向：**[docs/art-direction.md](docs/art-direction.md)**（「纸图」风格 + 色板 + 字体 + 符号）
> - 可视化样张：**[docs/style-tile.html](docs/style-tile.html)**（双击打开看）

一个单文件网页小游戏：沿着 G318 从成都骑到拉萨（1200 km），
管理**油量**、**体力**和**时间**，在随机事件和地标之间做取舍。

## 运行

双击 `index.html` 即可，无需安装、无需联网、不依赖任何图片或第三方库。
（想全屏也可以直接拖进浏览器窗口。）

视觉样张：双击 `docs/style-tile.html`。

## 项目结构

```
.
├─ index.html              玩法原型（单文件，可直接跑）
├─ docs/
│  ├─ design.md            玩法方案 v0.2（路网 / 时间 / 车辆 / 装备 / 景点）
│  ├─ art-direction.md     视觉方向 v1.0（纸图风格：色板 / 字体 / 符号 / 纹理）
│  └─ style-tile.html      视觉样张（地图层 + 路段层 + UI + 符号）
├─ scripts/
│  └─ push.bat             一键提交并推送到 GitHub
├─ .gitignore
└─ README.md
```

文档顺序建议：`design.md`（做什么）→ `art-direction.md`（长什么样）→ `style-tile.html`（看效果）。

## 操作

| 操作 | 按键 |
| --- | --- |
| 加速 | `↑` / `W` / 右下「油门」按钮 |
| 刹车 | `↓` / `S` / 右下「刹车」按钮 |
| 选择选项 | `1` `2` `3` 或直接点击 |
| 开始 / 重开 | `Enter` / `空格` |
| 引擎音开关 | `M` |

## 玩法要点

- **速度是双刃剑**：骑得快省时间，但每公里更费油、更耗体力，而且更容易遇到麻烦。
- **体力归零**会在路边昏睡 3 小时；**油量归零**只能推车，等路过的货车给点油。
- **地标**（雅安、康定、折多山、理塘……）会停下来给你一次选择：拍照、歇脚、还是睡到天亮。
- **昼夜与天气**实时变化：夜里视野差、限速低；雨雾天更耗体力。时间跨过两天是正常的。
- 目标是**活着、有油、到拉萨**，照片数量是这一趟的纪念分。

## 想改数值？

全在 `index.html` 的 `<script>` 顶部：

```js
const TOTAL   = 1200;   // 总里程 km
const TSCALE  = 2;      // 现实 1 秒 = 游戏 2 分钟（调大会更快到终点）
const START_MIN = 6*60; // 出发时间
```

以及：

- `LANDMARKS` — 途经地标与里程
- `EVENTS` — 随机事件表，`w` 是权重（可以是函数，用来做动态概率）
- `maxSpeed()` — 速度上限（体力 / 天气 / 夜路 / 缺油的影响）
- 油耗 `0.0043 * speed^1.25`，体力 `0.30*(0.62 + speed/100)` —— 平衡手感主要调这两个。

---

## 提交到 GitHub

仓库：`https://github.com/Yitiaoyu686/MOTO-around`

### 方式 A：双击脚本（推荐）

双击 **`scripts/push.bat`**。首次推送会弹出浏览器窗口登录 GitHub，之后就不用再登。

### 方式 B：手动命令

在仓库目录打开 PowerShell：

```powershell
cd D:\code\youxi
git init
git branch -M main
git remote add origin https://github.com/Yitiaoyu686/MOTO-around.git
git add -A
git commit -m "docs: 设计文档 + 玩法原型 + 视觉方向"
git push -u origin main
```

> 如果远端已经有 README（GitHub 建仓时勾了初始化），先执行：
> ```powershell
git pull --rebase --allow-unrelated-histories origin main
```
> 再 `git push`。

### 方式 C：GitHub Desktop

打开 GitHub Desktop → File → Add local repository → 选 `D:\code\youxi` → 填提交信息 → Push。
不会用命令行的话这个最省事。

### 部署在线版（可选）

推送后到仓库 **Settings → Pages → Source 选 `main` / `root`**，等一分钟，然后：

- 原型：`https://yitiaoyu686.github.io/MOTO-around/`
- 视觉样张：`https://yitiaoyu686.github.io/MOTO-around/docs/style-tile.html`

这样在手机上也能直接打开看。
