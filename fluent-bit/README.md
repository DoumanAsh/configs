# fluent-bit

## InitRC

[fluent-bit.initd](./fluent-bit.initd) can be placed in `/etc/init.d` to be used as service:

```
sudo cp ./fluent-bit.initd /etc/init.d/fluent-bit
sudo chmod +x /etc/init.d/fluent-bit
sudo rc-update add fluent-bit default
sudo rc-service fluent-bit start
```

## Lua functions

[fluent-bit.lua](./fluent-bit.lua) contains useful functions:

- `pri_extractor` - extracts `severity` and `facility` from within syslog's prio field

## Build instruction

[patch](./patch.txt) should be applied to fix build with below cmake configuration

Trim off unnecessary features related to various cloud services
```
cmake .. -D FLB_OUT_KAFKA_REST=off -D FLB_OUT_KAFKA=off -D FLB_EXAMPLES=off -D FLB_SHARED_LIB=off -D FLB_SIGNV4=off -DFLB_SIGNV4=Off -DFLB_AWS=Off -DFLB_FILTER_AWS=Off -DFLB_OUT_S3=Off -DFLB_OUT_KINESIS_FIREHOSE=Off -DFLB_OUT_KINESIS_STREAMS=Off -DFLB_OUT_CLOUDWATCH_LOGS=Off -DFLB_OUT_BIGQUERY=Off -DFLB_KAFKA=off -DCMAKE_BUILD_TYPE=Release -DFLB_DEBUG=off -DFLB_RELEASE=on -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib -DFLB_WITHOUT_flb-it-pack=Yes -DFLB_WITHOUT_flb-it-utils=Yes -DFLB_WITHOUT_flb-it-aws_util=Yes -DFLB_WITHOUT_flb-it-aws_credentials_process=Yes -DFLB_TLS=Yes -DFLB_HTTP_SERVER=Yes  -G Ninja -DFLB_CORO_STACK_SIZE=24576 -DFLB_LUAJIT=on -DFLB_OUT_DATADOG=off -DFLB_OUT_AZURE=off -DFLB_OUT_AZURE_KUSTO=off -DFLB_OUT_PGSQL=off -DFLB_OUT_SLACK=off -DFLB_OUT_STACKDRIVER=off -DFLB_OUT_SPLUNK=off -DFLB_OUT_TD=off
```
