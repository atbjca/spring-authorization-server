.PHONY: clean test install deploy build build-thin stop projects tree help setup-gradle

# 统一使用 Gradle Wrapper，依赖 setup-gradle 预热本地缓存。
# 如需指定本地安装的 Gradle（绕过 wrapper），可覆盖 GRADLE，例如：
#   make build-thin GRADLE=~/dev/gradle-8.14.5/bin/gradle
# 如系统盘紧张，可将 Gradle 缓存指向临时目录，例如：
#   make build-thin GRADLE_USER_HOME=$(HOME)/Downloads/DELETE/tmp/gradle-home
# 注意：自定义 GRADLE_USER_HOME 时，须将 ~/.gradle/gradle.properties（含 Nexus 配置）复制到该目录。
GRADLE ?= ./gradlew
SETUP_GRADLE := ./scripts/setup-gradle-local.sh

help: ## 显示帮助信息
	@echo ""
	@echo "可用命令:"
	@echo "  make setup-gradle - 将本地 Gradle zip 注入 wrapper 缓存（默认扫描 ~/dev）；缺包则回退联网下载"
	@echo "  make clean      - 清理构建产物"
	@echo "  make test       - 运行单元测试（跳过文档生成）"
	@echo "  make build-thin - 编译打包（不测试、无文档、不安装、不发布）"
	@echo "  make install    - 编译并安装到本地 Maven 仓库"
	@echo "  make deploy     - 发布到 Nexus 私服"
	@echo "  make build      - 编译打包（全量）"
	@echo "  make stop       - 停止所有 Gradle Daemon"
	@echo "  make projects   - 查看有效的项目"
	@echo "  make tree       - 查看依赖树"
	@echo ""
	@echo "环境变量:"
	@echo "  GRADLE          - Gradle 可执行文件路径（默认: ./gradlew）"
	@echo "  GRADLE_USER_HOME - Gradle 用户目录（可选，用于大体积缓存）"
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
setup-gradle: ## 将本地 Gradle zip 注入 wrapper 缓存
	LOCAL_GRADLE_DIR="$(LOCAL_GRADLE_DIR)" UNPACK=1 "$(SETUP_GRADLE)"

clean: setup-gradle ## 清理构建产物
	./gradlew clean

test: setup-gradle ## 运行全项目单元测试（不清理、不生成文档）
	./gradlew test -x asciidoctor -x javadoc

build: setup-gradle clean ## 编译打包（全量）
	./gradlew build

build-thin: setup-gradle clean ## 编译打包（精简版，跳过测试和文档）
	./gradlew build -x test -x asciidoctor -x javadoc

install: setup-gradle clean ## 编译并安装到本地 Maven 仓库
	./gradlew publishToMavenLocal -x test -x asciidoctor -x javadoc

deploy: setup-gradle clean ## 发布到 Nexus 私服（不发布到 OSSRH）
	./gradlew publishAllPublicationsToNexusRepository -x test -x asciidoctor -x javadoc

stop: ## 停止所有 Gradle Daemon
	./gradlew --stop

projects: setup-gradle ## 查看有效的项目
	./gradlew projects

tree: setup-gradle ## 查看依赖树
	./gradlew :bjca-footstone-bpring-security-oauth2-authorization-server:dependencies --configuration compileClasspath
