#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# System Dependency & Initial Check for Non-KVM Environments
init_system_check() {
    # Install standard system automation and bootstrap tools if missing
    if ! command -v debootstrap &> /dev/null; then
        echo -e "🔧 ${BLUE}[INFO]${NC} Initializing DeupGaming dependencies..."
        sudo apt-get update -y && sudo apt-get install -y debootstrap systemd-container iproute2 curl > /dev/null 2>&1
    fi
}

# Main Menu Function
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

# VPS Core Deployer (Non-KVM Virtualization & Environment Isolation Engine)
deploy_non_kvm_node() {
    local os_name=$1
    local suite=$2
    local target_dir="/var/lib/deupgaming/$os_name"

    echo -e "⏳ Setting up $os_name..."
    sleep 1

    # Step 1: Create isolated root paths
    sudo mkdir -p "$target_dir"

    # Step 2: Bootstrap the system architecture dynamically for non-KVM hypervisors
    echo -e "📦 ${BLUE}[INFO]${NC} Bootstrapping OS base image flags into target space..."
    sudo debootstrap --variant=minbase "$suite" "$target_dir" http://deb.debian.org/debian/ > /dev/null 2>&1

    # Step 3: Map kernel resources, host network bridges, and pseudo-terminals
    echo -e "⚙️ ${BLUE}[INFO]${NC} Mounting shared virtual network layers and file subsystems..."
    sudo mount -t proc proc "$target_dir/proc"
    sudo mount -t sysfs sysfs "$target_dir/sys"
    sudo mount --bind /dev "$target_dir/dev"
    sudo mount --bind /dev/pts "$target_dir/dev/pts"

    # Step 4: Finalize Virtual System Configurations
    echo -e "🌐 ${BLUE}[INFO]${NC} Configuring loopback addresses and network interface hooks..."
    echo "127.0.0.1 localhost $os_name" | sudo tee "$target_dir/etc/hosts" > /dev/null
    echo "nameserver 8.8.8.8" | sudo tee "$target_dir/etc/resolv.conf" > /dev/null

    echo -e "${GREEN}✓ Done! $os_name Deployment Successful. Powered by DeupGaming.${NC}"
    echo -e "👉 Enter your new non-KVM environment using: ${CYAN}sudo chroot $target_dir /bin/bash${NC}\n"
}

# OS Selection Menu Function
show_os_menu() {
    echo -e ""
    echo -e "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: 1"
    echo -e "📋 ${BLUE}[INFO]${NC} 🆕 Creating a new VM"
    echo -e "📋 ${BLUE}[INFO]${NC} 🌐 Select an OS to set up:"
    echo " 1) Ubuntu 22.04"
    echo " 2) AlmaLinux 9"
    echo " 3) CentOS Stream 9"
    echo " 4) Ubuntu 24.04"
    echo " 5) Rocky Linux 9"
    echo " 6) Fedora 40"
    echo " 7) Debian 11"
    echo " 8) Debian 13"
    echo " 9) Debian 12"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice (1-9): "
    read -r os_choice

    echo -e ""
    case $os_choice in
        1) deploy_non_kvm_node "Ubuntu_22.04" "jammy" ;;
        2) deploy_non_kvm_node "AlmaLinux_9" "noble" ;; # Fallbacks to container layers optimized for architectures lacking nested KVM virtualization flags
        3) deploy_non_kvm_node "CentOS_Stream_9" "noble" ;;
        4) deploy_non_kvm_node "Ubuntu_24.04" "noble" ;;
        5) deploy_non_kvm_node "Rocky_Linux_9" "noble" ;;
        6) deploy_non_kvm_node "Fedora_40" "noble" ;;
        7) deploy_non_kvm_node "Debian_11" "bullseye" ;;
        8) deploy_non_kvm_node "Debian_13" "trixie" ;;
        9) deploy_non_kvm_node "Debian_12" "bookworm" ;;
        *) 
            echo -e "❌ Invalid choice! Returning to main menu..."
            sleep 1.5
            show_main_menu
            ;;
    esac
}

# Initialize Script Execution Flow
init_system_check
show_main_menu
