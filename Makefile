.PHONY: clean install deploy build build-thin stop projects tree help

# 默认使用 Gradle Wrapper；可覆盖为本地安装，例如：
#   make clean GRADLE=~/dev/gradle-7.6.3/bin/gradle
GRADLE ?= ./gradlew

help: ## 显示帮助信息
	@echo ""
	@echo "可用命令:"
	@echo "  make clean      - 清理构建产物"
	@echo "  make build-thin - 编译打包（不测试、无文档、不安装、不发布）"
	@echo "  make install    - 编译并安装到本地 Maven 仓库"
	@echo "  make deploy     - 发布到 Nexus 私服"
	@echo "  make build      - 编译打包（全量）"
	@echo "  make stop       - 停止所有 Gradle Daemon"
	@echo "  make projects   - 查看有效的项目"
	@echo "  make tree       - 查看依赖树"
	@echo ""

clean: ## 清理构建产物
	$(GRADLE) clean

build: clean ## 编译打包（全量）
	$(GRADLE) build

build-thin: clean ## 编译打包（精简版，跳过测试和文档）
	$(GRADLE) build -x test -x asciidoctor -x javadoc

install: clean ## 编译并安装到本地 Maven 仓库
	$(GRADLE) publishToMavenLocal -x test -x asciidoctor -x javadoc

deploy: clean ## 发布到 Nexus 私服
	$(GRADLE) publish -x test -x asciidoctor -x javadoc

stop: ## 停止所有 Gradle Daemon
	$(GRADLE) --stop

projects: ## 查看有效的项目
	$(GRADLE) projects

tree: ## 查看依赖树
	$(GRADLE) dependencies --configuration compileClasspath
