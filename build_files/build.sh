#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux
dnf5 install -y --setopt=install_weak_deps=False niri
dnf5 install -y khal

dnf5 copr enable scottames/ghostty
dnf5 install -y ghostty
dnf5 copr disable scottames/ghostty

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable avengemedia/dms
dnf5 -y install --setopt=install_weak_deps=True greetd dms dms-greeter
dnf5 -y copr disable avengemedia/dms

# DMS needs greetd to be enabled and pointed at the DMS greeter. Without this,
# the system starts on a VT with no login manager and you end up at a black screen.
mkdir -p /etc/greetd
cat > /etc/greetd/config.toml <<'EOF'
[terminal]
vt = 1

[default_session]
command = "dms-greeter --command niri"
user = "greeter"
EOF

# greetd requires a list of valid session commands for the login flow. Without
# an entry for Niri, the greeter can authenticate the user but then immediately
# exit because no valid session is available.
NIRI_SESSION_PATH="/usr/bin/niri"
if [ -d /usr/local ]; then
    mkdir -p /usr/local/bin
    NIRI_SESSION_PATH="/usr/local/bin/niri"
fi

# Niri must start in session mode when it is the actual compositor instance for a
# logged-in display manager session. This wrapper keeps the greeter working while
# ensuring the main compositor imports the user session environment instead of
# exiting to a blank screen.
mkdir -p "$(dirname "$NIRI_SESSION_PATH")"
cat > "$NIRI_SESSION_PATH" <<'EOF'
#!/bin/bash
exec /usr/bin/niri --session "$@"
EOF
chmod 755 "$NIRI_SESSION_PATH"

# Keep the command name as `niri` so greetd can resolve it from PATH while still
# using a valid wrapper location when /usr/local is not a real directory.
cat > /etc/greetd/environments <<'EOF'
niri
EOF

# The base image already enables GDM as the display-manager alias. Greetd uses
# the same alias, so disable GDM first and then enable greetd to avoid the
# systemd conflict that appears as "File '/etc/systemd/system/display-manager.service' already exists".
systemctl disable gdm.service || true
systemctl enable greetd.service

#### Example for enabling a System Unit File

systemctl enable podman.socket