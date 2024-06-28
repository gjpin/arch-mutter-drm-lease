# Use the official Arch Linux base image
FROM quay.io/archlinux/archlinux:base-devel

# Sync repos and update packages
RUN pacman -Syu --noconfirm

# Install mutter makedepends
RUN pacman -Syu --noconfirm egl-wayland gi-docgen git glib2-devel \
    gobject-introspection meson sysprof wayland-protocols

# Install mutter depends
RUN pacman -Syu --noconfirm at-spi2-core cairo colord dconf \
    fontconfig fribidi gcc-libs gdk-pixbuf2 glib2 glibc \
    gnome-desktop-4 gnome-settings-daemon graphene gsettings-desktop-schemas \
    gtk4 harfbuzz iio-sensor-proxy lcms2 libcanberra libcolord libdisplay-info \
    libdrm libei libglvnd libgudev libice libinput libpipewire libsm \
    libsysprof-capture libwacom libx11 libxau libxcb libxcomposite libxcursor \
    libxdamage libxext libxfixes libxi libxinerama libxkbcommon libxkbcommon-x11 \
    libxkbfile libxrandr libxtst mesa pango pipewire pixman python \
    startup-notification systemd-libs wayland xorg-xwayland

# Create new user and make it sudoer
RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

# Continue execution as builder
USER builder

# Set work dir
WORKDIR /home/builder

# Create package destination and set the environment variables for makepkg
RUN mkdir -p /home/builder/packages
ENV PKGDEST=/home/builder/packages
ENV SRCDEST=/home/builder/mutter-drm-lease

# Build package
ENTRYPOINT ["makepkg"]
CMD ["--syncdeps", "--noconfirm"]