#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Ensure dependencies work inside non-KVM / container environments
init_system_check() {
    if ! command -v proot &> /dev/null; then
        echo -e "🔧 ${BLUE}[INFO]${NC} Installing user-space virtualization dependencies..."
        sudo apt-get update -y && sudo apt-get install -y proot wget curl tar > /dev/null 2>&1
    fi
}

show_main_menu() {
    clear
    echo -e "📋 ${YELLOW}Main Menu:${NC}"
    echo -e " 1) 🆕 Create a new VM"
    echo -e " 0) 👋 Exit"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: "
    read -r main_choice

    if [ "$main_choice" = "1" ]; then
        show_os_menu
    elif [ "$main_choice" = "0" ]; then
        echo -e "\n👋 Exiting... Thank you for using DeupGaming!"
        exit 0
    else
        echo -e "\n❌ Invalid option. Please try again."
        sleep 1
        show_main_menu
    fi
}

deploy_non_kvm_node() {
    local os_title=$1
    local rootfs_url=$2
    local target_dir="/var/lib/deupgaming/$os_title"

    echo -e "⏳ Setting up $os_title..."
    
    # Create target deployment directory securely
    sudo mkdir -p "$target_dir"
    cd "$target_dir" || exit

    # Download pre-built lightweight production rootfs image
    echo -e "📦 ${BLUE}[INFO]${NC} Downloading system rootfs image..."
    sudo wget -q --show-progress "$rootfs_url" -O rootfs.tar.xz

    # Extracting file-system structures safely without root device node violations
    echo -e "⚙️ ${BLUE}[INFO]${NC} Unpacking and isolating filesystem structures..."
    sudo tar -xJf rootfs.tar.xz --no-same-owner > /dev/null 2>&1
    sudo rm -f rootfs.tar.xz

    # Set up basic nameserver fallback resolution configurations
    echo "nameserver 8.8.8.8" | sudo tee "$target_dir/etc/resolv.conf" > /dev/null

    echo -e "${GREEN}✓ Done! $os_title Deployment Successful. Powered by DeupGaming.${NC}\n"
    echo -e "👉 Entering your environment now..."
    sleep 2

    # Launch user-space container console isolation engine
    sudo proot -r "$target_dir" -0 -b /dev -b /proc -b /sys /bin/bash
}

show_os_menu() {
    echo -e ""
    echo -e "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: 1"
    echo -e "📋 ${BLUE}[INFO]${NC} 🆕 Creating a new VM"
    echo -e "📋 ${BLUE}[INFO]${NC} 🌐 Select an OS to set up:"
    echo " 1) Ubuntu 22.04"
    echo " 2) Debian 12"
    echo " 3) Ubuntu 24.04"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice (1-3): "
    read -r os_choice

    echo -e ""
    case $os_choice in
        1) 
            # Ubuntu 22.04 official minimized container layers
            deploy_non_kvm_node "Ubuntu_22.04" "https://github.com/termux/proot-distro/releases/download/v4.8.0/ubuntu-jammy.tar.xz"
            ;;
        2) 
            # Debian 12 official minimized container layers
            deploy_non_kvm_node "Debian_12" "https://github.com/termux/proot-distro/releases/download/v4.8.0/debian-bookworm.tar.xz"
            ;;
        3) 
            # Ubuntu 24.04 official minimized container layers
            deploy_non_kvm_node "Ubuntu_24.04" "https://github.com/termux/proot-distro/releases/download/v4.8.0/ubuntu-noble.tar.xz"
            ;;
        *) 
            echo -e "❌ Invalid choice! Returning to main menu..."
            sleep 1.5
            show_main_menu
            ;;
    esac
}

# Run setup workflow
init_system_check
show_main_menu
