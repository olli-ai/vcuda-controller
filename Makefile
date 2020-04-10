.PHONY: all
all: build

.PHONY: build
build: libcuda-control.so nvml-monitor

.PHONY: install
install: libcuda-control.so nvml-monitor
	cp libcuda-control.so /usr/local/lib/
	cp nvml-monitor /usr/local/bin/

obj:
	mkdir obj

obj/cuda_originals.o: obj src/cuda_originals.c $(include *.h)
	gcc -c src/cuda_originals.c -o obj/cuda_originals.o -fPIC -I./

obj/hijack_call.o: obj src/hijack_call.c $(include *.h)
	gcc -c src/hijack_call.c -o obj/hijack_call.o -fPIC -I./

obj/loader.o: obj src/loader.c $(include *.h)
	gcc -c src/loader.c -o obj/loader.o -fPIC -I./

obj/nvml_entry.o: obj src/nvml_entry.c $(include *.h)
	gcc -c src/nvml_entry.c -o obj/nvml_entry.o -fPIC -I./

obj/register.o: obj src/register.c $(include *.h)
	gcc -c src/register.c -o obj/register.o -fPIC -I./

obj/monitor_dockernized.o: obj tools/monitor_dockernized.c $(include *.h)
	gcc -c tools/monitor_dockernized.c -o obj/monitor_dockernized.o -I./

libcuda-control.so: obj/cuda_originals.o obj/hijack_call.o obj/loader.o obj/nvml_entry.o obj/register.o
	gcc -o libcuda-control.so \
		obj/cuda_originals.o \
		obj/hijack_call.o \
		obj/loader.o \
		obj/nvml_entry.o \
		obj/register.o \
		-shared -ldl -pthread

nvml-monitor: obj/monitor_dockernized.o obj/loader.o obj/register.o
	gcc -o nvml-monitor \
		obj/monitor_dockernized.o \
		obj/loader.o \
		obj/register.o \
		-ldl -pthread

clean:
	rm -rf obj libcuda-control.so nvml-monitor
