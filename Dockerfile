FROM archlinux:latest
RUN pacman -Syu --needed --noconfirm base-devel git
COPY entrypoint.sh /entrypoint.sh
COPY build_f3kdb.sh /build_f3kdb.sh
ENTRYPOINT ["/entrypoint.sh"]
