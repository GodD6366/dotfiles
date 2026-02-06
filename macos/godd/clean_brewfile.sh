#!/bin/bash

# 交互式清理 Homebrew 脚本
# 检测并清理已通过其他方式卸载的软件在 Homebrew 中的残留信息

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

# 临时文件
TEMP_DIR=$(mktemp -d)
BREWFILE_CASKS="$TEMP_DIR/brewfile_casks.txt"
BREW_LIST_CASKS="$TEMP_DIR/brew_list.txt"
INSTALLED_APPS="$TEMP_DIR/installed.txt"
MISSING_APPS="$TEMP_DIR/missing.txt"
SELECTED_FILE="$TEMP_DIR/selected.txt"

# 清理函数
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 打印标题
print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}Homebrew 残留信息清理工具${NC}                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 检查依赖
check_dependencies() {
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}错误: 未找到 Homebrew${NC}"
        exit 1
    fi

    if ! command -v gum &> /dev/null; then
        echo -e "${YELLOW}提示: 未安装 gum (交互式工具)${NC}"
        echo -e "${YELLOW}正在安装 gum...${NC}"
        brew install gum
        echo ""
    fi
}

# 从 Brewfile 提取所有 cask 应用
extract_brewfile_casks() {
    echo -e "${BLUE}📋 正在从 Brewfile 提取应用列表...${NC}"

    grep "^cask" "$BREWFILE" | \
        grep -v "^cask \"font-" | \
        sed 's/cask "\([^"]*\)".*/\1/' > "$BREWFILE_CASKS"

    local count=$(wc -l < "$BREWFILE_CASKS" | tr -d ' ')
    echo -e "${GREEN}✓ 找到 $count 个应用定义${NC}"
    echo ""
}

# 获取 brew 中记录的已安装 cask
get_brew_casks() {
    echo -e "${BLUE}🍺 正在获取 Homebrew 记录的应用...${NC}"
    brew list --cask 2>/dev/null > "$BREW_LIST_CASKS" || touch "$BREW_LIST_CASKS"

    local count=$(wc -l < "$BREW_LIST_CASKS" | tr -d ' ')
    echo -e "${GREEN}✓ Homebrew 记录了 $count 个应用${NC}"
    echo ""
}

# 获取应用程序目录中实际安装的应用
get_installed_apps() {
    echo -e "${BLUE}🔍 正在扫描应用程序目录...${NC}"
    ls -1 /Applications 2>/dev/null | grep -E "\.app$" | sed 's/\.app$//' > "$INSTALLED_APPS"

    local count=$(wc -l < "$INSTALLED_APPS" | tr -d ' ')
    echo -e "${GREEN}✓ 找到 $count 个已安装应用${NC}"
    echo ""
}

# cask 名称转应用名称的映射
cask_to_app_name() {
    local cask_name="$1"
    local app_name=""

    case "$cask_name" in
        "1password") app_name="1Password" ;;
        "1password-cli") return 1 ;; # CLI 工具，跳过
        "account-switcher") app_name="Account Switcher" ;;
        "aldente") app_name="AlDente" ;;
        "alt-tab") app_name="Alt-Tab" ;;
        "android-file-transfer") app_name="Android File Transfer" ;;
        "android-platform-tools") return 1 ;; # CLI 工具
        "antigravity-tools") app_name="Antigravity Tools" ;;
        "apipost") app_name="ApiPost" ;;
        "appcleaner") app_name="AppCleaner" ;;
        "applite") app_name="Applite" ;;
        "arc") app_name="Arc" ;;
        "backuploupe") app_name="BackupLoupe" ;;
        "bartender") app_name="Bartender 6" ;;
        "cc-switch") app_name="CC Switch" ;;
        "clashx-pro") app_name="ClashX Pro" ;;
        "claude") app_name="Claude" ;;
        "claude-code") app_name="Claude Code" ;;
        "codex") app_name="Codex" ;;
        "codexbar") app_name="CodexBar" ;;
        "conductor") app_name="Conductor" ;;
        "db-browser-for-sqlite") app_name="DB Browser for SQLite" ;;
        "discord") app_name="Discord" ;;
        "firefox") app_name="Firefox" ;;
        "fork") app_name="Fork" ;;
        "gitbutler") app_name="GitButler" ;;
        "google-chrome") app_name="Google Chrome" ;;
        "google-chrome-beta") app_name="Google Chrome Beta" ;;
        "gray") app_name="Gray" ;;
        "hyper") app_name="Hyper" ;;
        "iina") app_name="IINA" ;;
        "input-source-pro") app_name="Input Source Pro" ;;
        "ice") app_name="Ice" ;;
        "keka") app_name="Keka" ;;
        "kekaexternalhelper") app_name="KekaExternalHelper" ;;
        "keycastr") app_name="KeyCastr" ;;
        "latest") app_name="Latest" ;;
        "launchos") app_name="LaunchOS" ;;
        "logoer") app_name="Logoer" ;;
        "loop") app_name="Loop" ;;
        "macupdater") app_name="MacUpdater" ;;
        "menuwhere") app_name="Menuwhere" ;;
        "microsoft-remote-desktop") app_name="Remote Desktop" ;;
        "monitorcontrol") app_name="MonitorControl" ;;
        "moonlight") app_name="Moonlight" ;;
        "mos") app_name="Mos" ;;
        "neteasemusic") app_name="NeteaseMusic" ;;
        "ngrok") app_name="ngrok" ;;
        "notion") app_name="Notion" ;;
        "obsidian") app_name="Obsidian" ;;
        "only-switch") app_name="Only Switch" ;;
        "opencode-desktop") app_name="OpenCode" ;;
        "orbstack") app_name="OrbStack" ;;
        "pearcleaner") app_name="Pearcleaner" ;;
        "qlcolorcode"|"qlimagesize"|"qlstephen") return 1 ;; # QuickLook 插件
        "qlmarkdown") app_name="QLMarkdown" ;;
        "qlvideo") app_name="QuickLook Video" ;;
        "qqmusic") app_name="QQMusic" ;;
        "quicklook-json"|"quicklookase"|"webpquicklook") return 1 ;; # QuickLook 插件
        "quickrecorder") app_name="QuickRecorder" ;;
        "raycast") app_name="Raycast" ;;
        "reminders-menubar") app_name="Reminders MenuBar" ;;
        "snipaste") app_name="Snipaste" ;;
        "stats") app_name="Stats" ;;
        "switchhosts") app_name="SwitchHosts" ;;
        "tabby") app_name="Tabby" ;;
        "telegram") app_name="Telegram" ;;
        "termhere") app_name="TermHere" ;;
        "todesk") app_name="ToDesk" ;;
        "topnotch") app_name="TopNotch" ;;
        "visual-studio-code") app_name="Visual Studio Code" ;;
        "visual-studio-code-insiders") app_name="Visual Studio Code - Insiders" ;;
        "warp") app_name="Warp" ;;
        "wechat") app_name="WeChat" ;;
        "whisky") app_name="Whisky" ;;
        "wireshark") app_name="Wireshark" ;;
        "wpsoffice-cn") app_name="wpsoffice" ;;
        *) return 1 ;;
    esac

    echo "$app_name"
    return 0
}

# 检测 brew 中已记录但实际已删除的应用
detect_missing_apps() {
    echo -e "${BLUE}🔎 正在检测已删除但 Homebrew 仍有记录的应用...${NC}"

    > "$MISSING_APPS"

    while IFS= read -r cask_name; do
        app_name=$(cask_to_app_name "$cask_name")
        if [ $? -eq 0 ]; then
            if [ ! -d "/Applications/${app_name}.app" ]; then
                echo "${cask_name}|${app_name}" >> "$MISSING_APPS"
            fi
        fi
    done < "$BREW_LIST_CASKS"

    local count=$(wc -l < "$MISSING_APPS" | tr -d ' ')
    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}✓ 所有 Homebrew 记录的应用都已正确安装，无需清理${NC}"
        echo ""
        exit 0
    fi

    echo -e "${YELLOW}⚠ 发现 $count 个已删除但 Homebrew 仍有记录的应用${NC}"
    echo ""
}

# 显示已删除应用列表并让用户选择
select_apps_to_clean() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}以下应用已从系统删除，但 Homebrew 仍有记录：${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    # 准备选项列表
    local options=()
    while IFS='|' read -r cask_name app_name; do
        options+=("$cask_name  [$app_name]")
    done < "$MISSING_APPS"

    # 使用 gum 进行多选
    echo -e "${BLUE}请选择要清理的应用（空格选择，回车确认）：${NC}"
    echo ""

    gum choose --no-limit --height=20 "${options[@]}" > "$SELECTED_FILE" || {
        echo -e "${YELLOW}已取消操作${NC}"
        exit 0
    }

    if [ ! -s "$SELECTED_FILE" ]; then
        echo -e "${YELLOW}未选择任何应用，退出${NC}"
        exit 0
    fi

    echo ""
}

# 确认操作
confirm_action() {
    local count=$(wc -l < "$SELECTED_FILE" | tr -d ' ')
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}将要执行以下操作：${NC}"
    echo -e "  ${RED}• 从 Homebrew 数据库清理 $count 个应用的记录${NC}"
    echo -e "  ${GREEN}• 不会修改 Brewfile${NC}"
    echo -e "  ${GREEN}• 不会删除任何文件${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    if gum confirm "确认继续？"; then
        return 0
    else
        echo -e "${YELLOW}已取消操作${NC}"
        exit 0
    fi
}

# 清理选中的应用
clean_brew_info() {
    echo -e "${BLUE}🧹 正在清理 Homebrew 记录...${NC}"
    echo ""

    local success_count=0
    local failed_apps=()

    while IFS= read -r line; do
        # 从 "cask_name  [app_name]" 提取 cask_name
        local cask_name=$(echo "$line" | sed 's/  \[.*$//')

        echo -e "${CYAN}清理: $cask_name${NC}"

        # 使用 brew uninstall --force 清理记录
        if brew uninstall --cask --force "$cask_name" 2>&1; then
            echo -e "${GREEN}  ✓ 已清理 Homebrew 记录${NC}"
            ((success_count++))
        else
            echo -e "${YELLOW}  ⚠ 清理失败${NC}"
            failed_apps+=("$cask_name")
        fi
        echo ""
    done < "$SELECTED_FILE"

    echo -e "${GREEN}✓ 成功清理 $success_count 个应用的 Homebrew 记录${NC}"

    if [ ${#failed_apps[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}以下应用清理失败：${NC}"
        printf '  • %s\n' "${failed_apps[@]}"
    fi
}

# 显示完成摘要
show_summary() {
    local count=$(wc -l < "$SELECTED_FILE" | tr -d ' ')

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ 清理完成！${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "  • 已清理 ${GREEN}$count${NC} 个应用的 Homebrew 记录"
    echo -e "  • Brewfile 未修改"
    echo -e "  • 你可以运行 ${CYAN}brew list --cask${NC} 查看当前状态"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}提示: 如果需要重新安装这些应用，运行 'brew bundle' 即可${NC}"
}

# 主函数
main() {
    print_header
    check_dependencies
    extract_brewfile_casks
    get_brew_casks
    get_installed_apps
    detect_missing_apps
    select_apps_to_clean
    confirm_action
    clean_brew_info
    show_summary
}

# 运行主函数
main
