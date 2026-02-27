FROM quay.io/fedora/fedora:43 as builder

ARG FLUENT_BIT_VERSION=4.2.3

RUN set -eux && dnf update && dnf install -y file diffutils pkgconfig make git cmake ca-certificates systemd-devel ninja-build gcc gcc-c++ flex bison graphviz zlib-devel gnutls-devel openssl-devel cyrus-sasl-devel libyaml-devel libzstd-devel openssl openssl-devel-engine netcat && dnf clean all

RUN git clone --depth 1 --branch v${FLUENT_BIT_VERSION} https://github.com/fluent/fluent-bit.git
COPY patch.txt fluent-bit/patch.txt

RUN cd fluent-bit &&           \
git apply patch.txt &&         \
cd build &&                    \
cmake ..                       \
-DFLB_JEMALLOC=On              \
-DFLB_OUT_KAFKA_REST=Off       \
-DFLB_OUT_KAFKA=Off            \
-DFLB_EXAMPLES=Off             \
-DFLB_SIGNV4=Off               \
-DFLB_AWS=Off                  \
-DFLB_FILTER_AWS=Off           \
-DFLB_OUT_S3=Off               \
-DFLB_OUT_KINESIS_FIREHOSE=Off \
-DFLB_OUT_KINESIS_STREAMS=Off  \
-DFLB_OUT_CLOUDWATCH_LOGS=Off  \
-DFLB_OUT_BIGQUERY=Off         \
-DFLB_KAFKA=Off                \
-DFLB_ZIG=Off                  \
-DFLB_TLS=Yes                  \
-DFLB_HTTP_SERVER=Yes          \
-DCMAKE_C_STANDARD=17          \
-DCMAKE_BUILD_TYPE=Release     \
-DFLB_LUAJIT=on                \
-DFLB_IN_PODMAN_METRICS=On     \
-DFLB_IN_SYSTEMD=On            \
-DFLB_OUT_DATADOG=Off          \
-DFLB_OUT_AZURE=Off            \
-DFLB_OUT_AZURE_KUSTO=Off      \
-DFLB_OUT_PGSQL=Off            \
-DFLB_OUT_SLACK=Off            \
-DFLB_OUT_STACKDRIVER=Off      \
-DFLB_OUT_SPLUNK=Off           \
-DFLB_OUT_TD=Off               \
-DFLB_SHARED_LIB=Off           \
-DFLB_DEBUG=Off                \
-DFLB_RELEASE=on               \
-DYAML_DECLARE_STATIC=on       \
-DFLB_PREFER_SYSTEM_LIB_ZSTD=on\
-DFLB_TESTS_INTERNAL=Off       \
-DFLB_TESTS_RUNTIME=Off        \
-DCMAKE_INSTALL_PREFIX=/usr    \
-DCMAKE_INSTALL_LIBDIR=lib     \
-DFLB_WITHOUT_flb-it-pack=Yes  \
-DFLB_WITHOUT_flb-it-utils=Yes \
-DFLB_WITHOUT_flb-it-aws_util=Yes \
-DFLB_WITHOUT_flb-it-aws_credentials_process=Yes \
-G Ninja \
&& cmake --build . \
&& ninja install

FROM quay.io/fedora/fedora:43 as runner

COPY --from=builder /usr/bin/fluent-bit /usr/bin/fluent-bit
COPY --from=builder /lib/systemd/system/fluent-bit.service /lib/systemd/system/fluent-bit.service
COPY --from=builder /usr/etc/fluent-bit/parsers.conf /etc/fluent-bit/parsers.conf
COPY --from=builder /usr/etc/fluent-bit/plugins.conf /etc/fluent-bit/plugins.conf
COPY --from=builder /usr/etc/fluent-bit/fluent-bit.conf /etc/fluent-bit/fluent-bit.conf
COPY --from=builder /usr/bin/luajit /usr/bin/luajit
