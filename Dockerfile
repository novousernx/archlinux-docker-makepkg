FROM archlinux:latest

# Copy new pacman.conf.
COPY pacman.conf /etc/pacman.conf

# Run some commands.
RUN pacman -Syu --noconfirm && \
		pacman-key --init && \
		pacman-key --populate archlinux && \
		yes | pacman -Scc

# Copy build script.
COPY run.sh /run.sh

# makepkg cannot (and should not) be run as root:
RUN useradd -m build

# Generally, refreshing without sync'ing is discouraged, but we've a clean environment here.
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Sy --noconfirm base-devel git && \
    pacman -Syu --noconfirm

# Allow notroot to run stuff as root (to install dependencies):
RUN echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build

# Continue execution (and CMD) as build:
USER build
WORKDIR /home/build

# Auto-fetch GPG keys (for checking signatures):
RUN mkdir .gnupg && \
    touch .gnupg/gpg.conf && \
    echo "keyserver-options auto-key-retrieve" > .gnupg/gpg.conf

# Install yay (for building AUR dependencies):
RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg --noconfirm --syncdeps --rmdeps --install --clean

# Build the package
WORKDIR /pkg
CMD /bin/sh /run.sh
