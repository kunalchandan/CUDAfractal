# Optics Simulation

Simulation using CUDA and C++.

I hate C++ with a passion, but we all need to do things that we hate some times.
I trued using Conan to use it as a package manager, but I just couldn't get things working.

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
