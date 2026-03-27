# Chaos Skills

用于本地智能体(agent)工作流的私有 AI 技能 monorepo。

## 目标

- 保持上游技能的 vendor 化并易于同步
- 保持自定义技能易于修改
- 通过 `npx skills` 保持安装的标准化

## 仓库结构

```text
.
├─ skills/              可编辑的源技能，按领域分类（安装区域）
│  ├─ core/             引导和元过程技能
│  ├─ planning/         规划、编排和执行
│  ├─ coding/           工程规范和代码审查
│  └─ writing/          写作和文档
├─ vendors/             只读的上游快照
│  └─ superpowers/      https://github.com/obra/superpowers
├─ tooling/             验证和安装脚本
├─ PROVENANCE.md        上游 → 本地的映射表
└─ AGENTS.md            智能体编辑规则
```

### 职责分配

- `**vendors/**` — 仅供读取(read-only)的上游源代码快照，不可直接编辑
- `**skills/**` — 可编辑的源技能文件及直接安装区域，按工作流领域组织
- `**tooling/**` — 轻量级本地脚本（验证、同步安装）

## 安装与卸载

### 安装全部技能到所有默认智能体

```bash
tooling/sync-local.sh
```

默认目标：`amp`、`claude-code`、`codex`、`cursor`、`kiro-cli`。

### 安装全部技能到指定智能体

```bash
tooling/sync-local.sh claude-code codex
```

### 安装某一个分类

```bash
npx skills add ./skills/planning -g -a claude-code -y
```

### 安装某一个技能

```bash
npx skills add ./skills/coding/systematic-debugging -g -a claude-code -y
```

### 卸载技能

```bash
npx skills remove <skill-name> -a claude-code
```

### 卸载指定智能体的全部技能

```bash
npx skills remove --all -y -g -a codex
```

- `--all`：删除该智能体下的全部已安装技能
- `-y`：自动确认，无需交互式确认
- `-g`：操作全局技能目录
- `-a codex`：目标智能体为 `codex`

### 查看已安装的技能

```bash
npx skills list -a claude-code
```

## 编辑工作流

1. 在 `skills/<category>/<skill>/` 下编辑技能
2. 运行 `tooling/validate-skills.sh` 验证（检查 `name` 唯一性和 `SKILL.md` 完整性）
3. 运行 `tooling/sync-local.sh` 安装到本地智能体
4. 启动新的智能体会话以加载更新后的技能内容

> **永远不要直接编辑 `vendors/`**。需要的内容请复制到 `skills/` 后再修改。

### 仅验证（不安装）

```bash
tooling/validate-skills.sh
```

## 上游管理

### 同步已有上游的更新

当前 vendor 的引入是作为 git subtree 添加的。使用以下命令拉取上游更新：

```bash
git subtree pull --prefix=vendors/superpowers https://github.com/obra/superpowers.git main --squash
```

拉取后，对比 `vendors/superpowers/skills/` 与 `skills/` 的差异，选择性地将变更移植到本地技能中。映射关系见 `[PROVENANCE.md](PROVENANCE.md)`。

### 增加新的上游源

1. 以 subtree 方式引入新的上游仓库：
  ```bash
   git subtree add --prefix=vendors/<name> <repo-url> <branch> --squash
  ```
2. 将需要的技能从 `vendors/<name>/` 复制到 `skills/<category>/` 下并进行本地适配
3. 在 `[PROVENANCE.md](PROVENANCE.md)` 中新增一个章节，记录该上游的映射关系
4. 运行验证和同步：
  ```bash
   tooling/validate-skills.sh
   tooling/sync-local.sh
  ```

### 更新机制

`npx skills` 可以让智能体直接指向此仓库的源代码树。更新流程如下：

```text
skills/ → npx skills add → 本地智能体技能目录
```

修改本地技能后，运行 `tooling/sync-local.sh` 即可更新，然后启动新的智能体会话以重新加载。

## 来源追踪

所有技能的上游对应关系维护在 `[PROVENANCE.md](PROVENANCE.md)` 中，按上游仓库分章节、以表格集中管理。

