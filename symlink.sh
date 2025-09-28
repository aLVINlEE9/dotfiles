#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
fi

log_info "Starting dotfiles installation..."
log_info "Dotfiles path: $DOTFILES_DIR"

mkdir -p "$BACKUP_DIR"
log_info "Created backup directory: $BACKUP_DIR"

create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir=$(dirname "$target")

    # Create target directory
    mkdir -p "$target_dir"

    # Handle existing files/links
    if [ -L "$target" ]; then
        log_warning "Removing existing symlink: $target"
        rm "$target"
    elif [ -e "$target" ]; then
        log_warning "Backing up existing file: $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Create symlink
    ln -s "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

log_info "Linking configuration files..."

# Neovim
if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# Tmux
if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
elif [ -d "$DOTFILES_DIR/tmux" ]; then
    create_symlink "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
fi

# Zsh
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

if [ -f "$DOTFILES_DIR/.zshenv" ]; then
    create_symlink "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
fi

if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
    create_symlink "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# Git
if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

if [ -f "$DOTFILES_DIR/.gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
fi

if [ -d "$DOTFILES_DIR/bin" ]; then
    log_info "Linking executable files..."

    # Create ~/bin directory
    mkdir -p "$HOME/bin"

    for file in "$DOTFILES_DIR/bin"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            target="$HOME/bin/$filename"

            if [ -L "$target" ]; then
                log_warning "$target already exists as a symlink."
            elif [ -e "$target" ]; then
                log_warning "Backing up existing file: $target -> $BACKUP_DIR/"
                mv "$target" "$BACKUP_DIR/"
                ln -s "$file" "$target"
                log_success "Created symlink: $target -> $file"
            else
                ln -s "$file" "$target"
                log_success "Created symlink: $target -> $file"
            fi
        fi
    done
fi

log_success "Dotfiles installation completed!"
log_info "Backed up files location: $BACKUP_DIR"

if [ -z "$(ls -A $BACKUP_DIR)" ]; then
    rmdir "$BACKUP_DIR"
    log_info "Removed empty backup directory."
fi

echo ""
log_info "Next steps:"
echo "  1. Open a new terminal or run 'source ~/.zshrc' (or your shell config)"
echo "  2. Set permissions if needed: chmod +x ~/bin/*"
echo "  3. Ensure ~/bin is in your PATH"
echo ""

log_success "Done!!!"
