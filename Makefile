.PHONY: setup-gradle clean install deploy build build-thin stop projects tree help

# 默认使用 Gradle Wrapper；可覆盖为本地安装，例如：
#   make clean GRADLE=~/dev/gradle-7.6.3/bin/gradle
GRADLE ?= ./gradlew
LOCAL_GRADLE_DIR ?= $(HOME)/dev
SETUP_GRADLE := ./scripts/setup-gradle-local.sh

help: ## 显示帮助信息
	@echo ""
	@echo "可用命令:"
	@echo "  make setup-gradle - 将 LOCAL_GRADLE_DIR 下的 gradle-*-zip 安装到 wrapper 缓存"
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
