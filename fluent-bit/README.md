# fluent-bit

## PC

Personal PC setup is available [here](./pc/)

### Lua functions

[fluent-bit.lua](./pc/fluent-bit.lua) contains useful functions:

- `systemd_extractor` - Extracts and maps well known attributes close to opentelemetry semantics, while unknown fields are prefixed with `field.`

### Build instruction

[patch](./patch.txt) should be applied to fix build with follow cmake configuration:

```
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
-G Ninja

```

## VPS

Alpine VPS setup is available [here](./vps/)

### InitRC

[fluent-bit.initd](./vps/fluent-bit.initd) can be placed in `/etc/init.d` to be used as service:

```
sudo cp ./vps/fluent-bit.initd /etc/init.d/fluent-bit
sudo chmod +x /etc/init.d/fluent-bit
sudo rc-update add fluent-bit default
sudo rc-service fluent-bit start
```

### Lua functions

[fluent-bit.lua](./vps/fluent-bit.lua) contains useful functions:

- `pri_extractor` - extracts `severity` and `facility` from within syslog's prio field

### Build instruction

[patch](./alpine-patch.txt) should be applied to fix build with following cmake configuration

Trim off unnecessary features related to various cloud services
```
cmake .. -D FLB_OUT_KAFKA_REST=off -D FLB_OUT_KAFKA=off -D FLB_EXAMPLES=off -D FLB_SHARED_LIB=off -D FLB_SIGNV4=off -DFLB_SIGNV4=Off -DFLB_AWS=Off -DFLB_FILTER_AWS=Off -DFLB_OUT_S3=Off -DFLB_OUT_KINESIS_FIREHOSE=Off -DFLB_OUT_KINESIS_STREAMS=Off -DFLB_OUT_CLOUDWATCH_LOGS=Off -DFLB_OUT_BIGQUERY=Off -DFLB_KAFKA=off -DCMAKE_BUILD_TYPE=Release -DFLB_DEBUG=off -DFLB_RELEASE=on -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib -DFLB_WITHOUT_flb-it-pack=Yes -DFLB_WITHOUT_flb-it-utils=Yes -DFLB_WITHOUT_flb-it-aws_util=Yes -DFLB_WITHOUT_flb-it-aws_credentials_process=Yes -DFLB_TLS=Yes -DFLB_HTTP_SERVER=Yes  -G Ninja -DFLB_CORO_STACK_SIZE=24576 -DFLB_LUAJIT=on -DFLB_OUT_DATADOG=off -DFLB_OUT_AZURE=off -DFLB_OUT_AZURE_KUSTO=off -DFLB_OUT_PGSQL=off -DFLB_OUT_SLACK=off -DFLB_OUT_STACKDRIVER=off -DFLB_OUT_SPLUNK=off -DFLB_OUT_TD=off
```
