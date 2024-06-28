Note: Not working, but kept for reference

# How to
1. Check if there's any update to [Arch's original mutter PKGBUILD](https://gitlab.archlinux.org/archlinux/packaging/packages/mutter/-/blob/main/PKGBUILD?ref_type=heads) and adapt accordingly
2. If there's a new MR [example](https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3746), click on 'Code' and download patch
3. Add patch reference to PKGBUILD and calculate the new checksum with `b2sum mr0123.patch`
4. Build container image: `docker buildx build --platform=linux/amd64 --tag=archlinux-mutter-drm-lease-builder .`
5. Build the package:
```
docker run -ti --platform=linux/amd64 --rm \
    -v $PWD/.SRCINFO:/home/builder/.SRCINFO \
    -v $PWD/Dockerfile:/home/builder/Dockerfile \
    -v $PWD/mr3746.patch:/home/builder/mr3746.patch \
    -v $PWD/PKGBUILD:/home/builder/PKGBUILD \
    -v $PWD/packages:/home/builder/packages \
    archlinux-mutter-drm-lease-builder
```
6. Install the package: `sudo pacman -U your-package-1.0.0-1-x86_64.pkg.tar.zst`

# References
- Based on [https://aur.archlinux.org/packages/mutter-dynamic-buffering](mutter-dynamic-buffering) and [mutter](https://gitlab.archlinux.org/archlinux/packaging/packages/mutter) packages

# Patch fix example
```
Patch contains:
@@ -58,3 +58,4 @@
 #define META_MUTTER_X11_INTEROP_VERSION 1
 #define META_WP_FRACTIONAL_SCALE_VERSION 1
 #define META_XDG_DIALOG_VERSION 1
+#define META_WP_DRM_LEASE_DEVICE_V1_VERSION 1

In Gnome 46, there's no reference to [META_XDG_DIALOG_VERSION](https://gitlab.gnome.org/GNOME/mutter/-/blob/gnome-46/src/wayland/meta-wayland-versions.h?ref_type=heads):
@@ -59,1 +60,2 @@
 #define META_WP_FRACTIONAL_SCALE_VERSION 1
+#define META_WP_DRM_LEASE_DEVICE_V1_VERSION 1
```