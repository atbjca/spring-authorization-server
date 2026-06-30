.PHONY: clean test install deploy build build-thin stop projects tree help

# 默认使用本地 Gradle 安装，避免 Wrapper 远程下载；可覆盖，例如：
#   make build-thin GRADLE=./gradlew
GRADLE ?= $(HOME)/dev/gradle-8.14.5/bin/gradle

# 系统盘空间紧张时，可将 Gradle 缓存指向临时目录，例如：
#   make build-thin GRADLE_USER_HOME=$(HOME)/Downloads/DELETE/tmp/gradle-home
# 注意：自定义 GRADLE_USER_HOME 时，须将 ~/.gradle/gradle.properties（含 Nexus 配置）复制到该目录。

help: ## 显示帮助信息
	@echo ""
	@echo "可用命令:"
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
	@echo "  GRADLE          - Gradle 可执行文件路径（默认: ~/dev/gradle-8.14.5/bin/gradle）"
	@echo "  GRADLE_USER_HOME - Gradle 用户目录（可选，用于大体积缓存）"
	@echo ""

clean: ## 清理构建产物
	$(GRADLE) clean

test: ## 运行全项目单元测试（不清理、不生成文档）
	$(GRADLE) test -x asciidoctor -x javadoc

build: clean ## 编译打包（全量）
	$(GRADLE) build

build-thin: clean ## 编译打包（精简版，跳过测试和文档）
	$(GRADLE) build -x test -x asciidoctor -x javadoc

install: clean ## 编译并安装到本地 Maven 仓库
	$(GRADLE) publishToMavenLocal -x test -x asciidoctor -x javadoc

deploy: clean ## 发布到 Nexus 私服（不发布到 OSSRH）
	$(GRADLE) publishAllPublicationsToNexusRepository -x test -x asciidoctor -x javadoc

stop: ## 停止所有 Gradle Daemon
	$(GRADLE) --stop

projects: ## 查看有效的项目
	$(GRADLE) projects

tree: ## 查看依赖树
	$(GRADLE) :bjca-footstone-bpring-security-oauth2-authorization-server:dependencies --configuration compileClasspath
