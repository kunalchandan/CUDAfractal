# Optics Simulation
Installation?
```bash
# C++ 
sudo apt install build-essential gdb
sudo apt install cmake
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev
sudo apt install libx11-dev libx11-xcb-dev libfontenc-dev libice-dev libsm-dev libxau-dev libxaw7-dev
sudo apt install libxcomposite-dev libxdamage-dev libxkbfile-dev libxmuu-dev libxres-dev libxss-dev libxtst-dev 
sudo apt install libxv-dev libxvmc-dev libxxf86vm-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-xkb-dev 
sudo apt install libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev 
sudo apt install libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-dri3-dev uuid-dev libxcb-cursor-dev
sudo apt install libxcb-util-dev libxcb-util0-dev
sudo apt install pkg-config
sudo apt install libx11-dev libfontconfig1-dev libfreetype6-dev libxcursor-dev libxfixes-dev libxft-dev libxi-dev libxrandr-dev libxrender-dev


# Package management
sudo apt install python3-pip python3
pip install conan

git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
make PLATFORM=PLATFORM_DESKTOP # To make the static version.
sudo make install # Static version.

mv src/libraylib.a ../
```

Running:

Per session:
```bash
sudo ln -s ~/.local/bin/conan /usr/bin/conan
```

Command:
```bash
conan install . --output-folder=build --build=missing -c tools.system.package_manager:mode=install
nvcc hello_x11.cpp --std=c++17 -lX11 -o main.x
./main.x
```
