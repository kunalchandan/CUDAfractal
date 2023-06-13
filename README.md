# Optics Simulation

Simulation using CUDA and C++.

I hate C++ with a passion, but we all need to do things that we hate some times.

## Results

First render using a single threaded GPU:

[render the first](imgs/render-edges-bad-zoom.png)

Profiling results for a `640px` width and height:

```plain
==42584== Profiling application: ./build/optiks
==42584== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:  100.00%  20.5107s         1  20.5107s  20.5107s  20.5107s  mandelbrot_single_thread_gpu(int, int*)
      API calls:   97.91%  20.5108s         1  20.5108s  20.5108s  20.5108s  cudaDeviceSynchronize
                    2.08%  436.40ms         1  436.40ms  436.40ms  436.40ms  cudaMallocManaged
                    0.01%  1.5044ms         1  1.5044ms  1.5044ms  1.5044ms  cuDeviceGetPCIBusId
                    0.00%  38.410us         1  38.410us  38.410us  38.410us  cudaLaunchKernel
                    0.00%  19.570us       101     193ns     140ns  1.2000us  cuDeviceGetAttribute
                    0.00%  1.0700us         3     356ns     180ns     580ns  cuDeviceGetCount
                    0.00%  1.0200us         2     510ns     200ns     820ns  cuDeviceGet
                    0.00%     970ns         1     970ns     970ns     970ns  cuDeviceGetName
                    0.00%     330ns         1     330ns     330ns     330ns  cuDeviceTotalMem
                    0.00%     240ns         1     240ns     240ns     240ns  cuDeviceGetUuid
```

Similarly for a `2048px` width and height:

[render larger](imgs/render-2048-2048.png)

```plain
==42795== Profiling application: ./build/optiks
==42795== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:  100.00%  208.700s         1  208.700s  208.700s  208.700s  mandelbrot_single_thread_gpu(int, int*)
      API calls:   99.75%  208.701s         1  208.701s  208.701s  208.701s  cudaDeviceSynchronize
                    0.25%  519.95ms         1  519.95ms  519.95ms  519.95ms  cudaMallocManaged
                    0.00%  1.8726ms         1  1.8726ms  1.8726ms  1.8726ms  cuDeviceGetPCIBusId
                    0.00%  81.049us         1  81.049us  81.049us  81.049us  cudaLaunchKernel
                    0.00%  16.750us       101     165ns     120ns     860ns  cuDeviceGetAttribute
                    0.00%  1.3600us         1  1.3600us  1.3600us  1.3600us  cuDeviceGetName
                    0.00%     950ns         3     316ns     180ns     510ns  cuDeviceGetCount
                    0.00%     830ns         2     415ns     190ns     640ns  cuDeviceGet
                    0.00%     310ns         1     310ns     310ns     310ns  cuDeviceTotalMem
                    0.00%     230ns         1     230ns     230ns     230ns  cuDeviceGetUuid
```

Now for the multithreaded version with 4 thread blocks and 256 threads.

[render larger](imgs/render-2048-2048-gpu.png)

```plain
==43499== Profiling application: ./build/optiks
==43499== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:  100.00%  371.59ms         1  371.59ms  371.59ms  371.59ms  mandelbrot_multi_thread_gpu(int, int*, unsigned short, unsigned short)
      API calls:   56.89%  493.62ms         1  493.62ms  493.62ms  493.62ms  cudaMallocManaged
                   42.84%  371.70ms         1  371.70ms  371.70ms  371.70ms  cudaDeviceSynchronize
                    0.26%  2.2424ms         1  2.2424ms  2.2424ms  2.2424ms  cuDeviceGetPCIBusId
                    0.01%  91.230us         1  91.230us  91.230us  91.230us  cudaLaunchKernel
                    0.00%  18.720us       101     185ns     120ns  1.5300us  cuDeviceGetAttribute
                    0.00%  1.4400us         3     480ns     140ns  1.0700us  cuDeviceGetCount
                    0.00%  1.4000us         1  1.4000us  1.4000us  1.4000us  cuDeviceGetName
                    0.00%     880ns         2     440ns     170ns     710ns  cuDeviceGet
                    0.00%     470ns         1     470ns     470ns     470ns  cuDeviceTotalMem
                    0.00%     190ns         1     190ns     190ns     190ns  cuDeviceGetUuid
```

The speedup is wild. I get a `56 160%` speedup!!

## Installation

```bash
# C++ 
sudo apt install build-essential gdb
sudo apt install clang-format
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev
sudo apt install libx11-dev libx11-xcb-dev libfontenc-dev libice-dev libsm-dev libxau-dev libxaw7-dev
sudo apt install libxcomposite-dev libxdamage-dev libxkbfile-dev libxmuu-dev libxres-dev libxss-dev libxtst-dev 
sudo apt install libxv-dev libxvmc-dev libxxf86vm-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-xkb-dev 
sudo apt install libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev 
sudo apt install libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-dri3-dev uuid-dev libxcb-cursor-dev
sudo apt install libxcb-util-dev libxcb-util0-dev
sudo apt install pkg-config
sudo apt install libx11-dev libfontconfig1-dev libfreetype6-dev libxcursor-dev libxfixes-dev libxft-dev libxi-dev libxrandr-dev libxrender-dev
```

Updated CMake.

```bash
sudo apt remove cmake
wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-x86_64.sh
sudo cp cmake-3.26.4-linux-x86_64.sh /opt/
sudo chmod +x /opt/cmake-3.26.4-linux-x86_64.sh
cd /opt/
sudo bash /opt/cmake-3.26.4-linux-x86_64.sh
sudo ln -s /opt/cmake-3.26.4-linux-x86_64/bin/* /usr/local/bin/

```

## Running

```bash
cmake .
make
./build/optiks
```

or

```bash
cmake . && make clear && ./build/optiks
```
