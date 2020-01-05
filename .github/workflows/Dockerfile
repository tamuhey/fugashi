FROM quay.io/pypa/manylinux1_x86_64

COPY build-manylinux.sh /build-manylinux.sh
RUN chmod +x /build-manylinux.sh

ENTRYPOINT ["/build-manylinux.sh"]
