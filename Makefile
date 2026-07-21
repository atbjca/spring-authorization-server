.PHONY: setup-gradle clean install deploy build build-thin stop projects tree help

# 默认使用 Gradle Wrapper；可覆盖为本地安装，例如：
#   make clean GRADLE=~/dev/gradle-7.6.3/bin/gradle
GRADLE ?= ./gradlew
LOCAL_GRADLE_DIR ?= $(HOME)/dev
SETUP_GRADLE := ./scripts/setup-gradle-local.sh

help: ## 显示帮助信息
	@echo ""
	@echo "可用命令:"
	@echo "  make setup-gradle - 将 LOCAL_GRADLE_DIR 下的 gradle-*-zip 安装到 wrapper 缓存；缺包则回退联网下载"
	@echo "  make clean        - 清理构建产物"
	@echo "  make build-thin   - 编译打包（不测试、无文档、不安装、不发布）"
	@echo "  make install      - 编译并安装到本地 Maven 仓库"
	@echo "  make deploy       - 发布到 Nexus 私服"
	@echo "  make build        - 编译打包（全量）"
	@echo "  make stop         - 停止所有 Gradle Daemon"
	@echo "  make projects     - 查看有效的项目"
	@echo "  make tree         - 查看依赖树"
	@echo ""
	@echo "setup-gradle 说明：将 $(LOCAL_GRADLE_DIR)/gradle-*-{bin,all}.zip"
	@echo "  复制并解压到 ~/.gradle/wrapper/dists/，避免每次联网下载。"
	@echo "  可设置 LOCAL_GRADLE_DIR=path 指向其他目录。"
	@echo ""

# -----------------------------------------------------------------------------
# setup-gradle：构建前预热 Gradle 发行包（几乎所有 target 的前置依赖）
#
# 为什么这么做：
#   Gradle Wrapper 首次运行会按 gradle-wrapper.properties 里的 distributionUrl
#   联网从 services.gradle.org 下载发行包。在内网/离线/弱网环境下这一步很慢或
#   直接失败。本 target 调用 scripts/setup-gradle-local.sh，把本地已备好的
#   gradle-*-{bin,all}.zip 按 Wrapper 的缓存命名规则（MD5(url)->base36）直接
#   复制解压到 ~/.gradle/wrapper/dists/，模拟“首次下载已完成”，从而免联网。
#   因为用的是官方 URL 算 hash，gradle-wrapper.properties 无需改成 file://。
#
# 从哪里找包：
#   默认扫描 LOCAL_GRADLE_DIR（缺省 ~/dev）下的 gradle-*-{bin,all}.zip。
#   可覆盖：LOCAL_GRADLE_DIR=/path/to/zips make <target>
#
# 会产生什么效果：
#   - 找到本地包：免网络注入 Wrapper 缓存，构建直接用本地发行包（幂等，已就绪则跳过）。
#   - 找不到本地包：不再中断构建，仅打印提示并以退出码 0 继续，交回 Gradle Wrapper
#     按官方 distributionUrl 联网下载。（旧行为是 exit 1 直接让 make 失败。）
#
# 注意：
#   “缺包回退联网下载”依赖能访问 services.gradle.org。若既无本地包又完全离线，
#   下载会在 Gradle 自身阶段失败——此时请补齐本地包或设置 LOCAL_GRADLE_DIR。
# -----------------------------------------------------------------------------
setup-gradle: ## 将本地 Gradle zip 安装到 wrapper 缓存（默认 ~/dev）
	LOCAL_GRADLE_DIR="$(LOCAL_GRADLE_DIR)" UNPACK=1 "$(SETUP_GRADLE)"

clean: setup-gradle ## 清理构建产物
	$(GRADLE) clean

build: setup-gradle clean ## 编译打包（全量）
	$(GRADLE) build

build-thin: setup-gradle clean ## 编译打包（精简版，跳过测试和文档）
	$(GRADLE) build -x test -x asciidoctor -x javadoc -x checkstyleNohttp

install: setup-gradle clean ## 编译并安装到本地 Maven 仓库
	$(GRADLE) publishToMavenLocal -x test -x asciidoctor -x javadoc

deploy: setup-gradle clean ## 发布到 Nexus 私服
	$(GRADLE) publish -x test -x asciidoctor -x javadoc

stop: ## 停止所有 Gradle Daemon
	$(GRADLE) --stop

projects: setup-gradle ## 查看有效的项目
	$(GRADLE) projects

tree: setup-gradle ## 查看依赖树
	$(GRADLE) dependencies --configuration compileClasspath
