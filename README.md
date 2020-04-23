# vcuda-controller

This is a fork from https://github.com/tkestack/vcuda-controller to simplify the build process

It creates `libcuda-controller.so`, a wrapper of `libcuda.so` and `libnvidia-ml.so` that limits memory and GPU usage. On startup, it calls [`gpu-client`](https://github.com/olli-ai/gpu-manager) in order to get the config files.

Logs can be displayed by setting the environment variable `LOGGER_LEVEL` (`"0"` to `"4"`).

It also creates a `nvml-monitor` binary, no idea what it does.
