#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <complex>
#include <cuComplex.h>

#include <X11/Xlib.h>
#include <X11/Xos.h>
#include <X11/Xutil.h>

#include <cstdint>
#include <iomanip>
#include <iostream>
#include <tuple>
#include <vector>

const uint32_t WIDTH = 2048, HEIGHT = 2048;
const uint32_t ITER_MAX = 512;

void mandelbrot_single_thread(int n, int* mbr) {
    for(int i = 0; i < n; i++) {
        // Index from the top left, using row-major order/x-major order
        uint32_t x_index = (i % WIDTH);
        uint32_t y_index = (i / WIDTH);

        float calculated_position_x = (x_index / (1.0 * WIDTH)) - 0.5;
        float calculated_position_y = (y_index / (1.0 * WIDTH)) - 0.5;

        auto z_0 = std::complex(calculated_position_x, calculated_position_y);
        auto z_n = std::complex(calculated_position_x, calculated_position_y);

        int m_i = 0;
        for(m_i = 0; m_i < ITER_MAX; m_i++) {
            z_n = std::pow(z_n, std::complex(2.0f, 0.0f)) + z_0;
            if(std::norm(z_n) > 2) {
                break;
            }
        }
        mbr[i] = m_i;
    }
}

__global__ void mandelbrot_single_thread_gpu(int n, int* mbr) {
    for(int i = 0; i < n; i++) {
        // Index from the top left, using row-major order/x-major order
        uint32_t x_index = (i % WIDTH);
        uint32_t y_index = (i / WIDTH);

        float calculated_position_x = (x_index / (1.0 * WIDTH)) - 0.5;
        float calculated_position_y = (y_index / (1.0 * HEIGHT)) - 0.5;

        cuFloatComplex z_0 = make_cuFloatComplex(calculated_position_x, calculated_position_y);
        cuFloatComplex z_n = make_cuFloatComplex(calculated_position_x, calculated_position_y);

        int m_i = 0;
        for(m_i = 0; m_i < ITER_MAX; m_i++) {
            z_n = cuCaddf(cuCmulf(z_n, z_n), z_0);
            if(cuCabsf(z_n) > 2.0) {
                break;
            }
        }
        mbr[i] = m_i;
    }
}

__global__ void
mandelbrot_multi_thread_gpu(int n, int* mbr, uint16_t thread_blocks, uint16_t threads) {
    int tid          = blockIdx.x * blockDim.x + threadIdx.x;
    int section_size = (n) / (thread_blocks * threads);
    for(int i = tid * section_size; i < (tid + 1) * section_size; i++) {
        // Index from the top left, using row-major order/x-major order
        uint32_t x_index = (i % WIDTH);
        uint32_t y_index = (i / WIDTH);

        float calculated_position_x = (x_index / (1.0 * WIDTH)) - 0.5;
        float calculated_position_y = (y_index / (1.0 * HEIGHT)) - 0.5;

        cuFloatComplex z_0 = make_cuFloatComplex(calculated_position_x, calculated_position_y);
        cuFloatComplex z_n = make_cuFloatComplex(calculated_position_x, calculated_position_y);

        int m_i = 0;
        for(m_i = 0; m_i < ITER_MAX; m_i++) {
            z_n = cuCaddf(cuCmulf(z_n, z_n), z_0);
            if(cuCabsf(z_n) > 2.0) {
                break;
            }
        }
        mbr[i] = m_i;
    }
}

void drawCalculation(Display* di, Window wi, GC gc, int* mbr, std::vector<uint32_t> color_lookup) {
    for(int x = 0; x < WIDTH; x++) {
        for(int y = 0; y < HEIGHT; y++) {
            XSetForeground(di, gc, color_lookup[mbr[(y * WIDTH) + x]]);
            XDrawPoint(di, wi, gc, x, y);
        }
    }
}

std::vector<uint32_t> generate_color_lookup() {
    std::vector<uint32_t> table = std::vector<uint32_t>(ITER_MAX);
    for(int x = 0; x < ITER_MAX; x++) {
        // uint32_t l2 = (std::log2(x));
        uint32_t l2 = (x * 255.0) / ITER_MAX;
        // std::printf("%i", l2);
        table[x] = (l2) | (l2 << 8) | (l2 << 16);
    }
    return table;
}

std::tuple<Display*, Window, GC> OpenDisplay() {
    //Open Display
    Display* di = XOpenDisplay(getenv("DISPLAY"));
    if(di == NULL) {
        printf("Couldn't open display.\n");
        exit(-1);
    }

    //Create Window
    int const x = 0, y = 0, border_width = 1;
    int       sc = DefaultScreen(di);
    Window    ro = DefaultRootWindow(di);
    Window    wi = XCreateSimpleWindow(
        di, ro, x, y, WIDTH, HEIGHT, border_width, BlackPixel(di, sc), WhitePixel(di, sc));
    XMapWindow(di, wi); //Make window visible
    XStoreName(di, wi, "Mandelbrot Fractal"); // Set window title

    //Prepare the window for drawing
    GC gc = XCreateGC(di, ro, 0, NULL);

    return std::make_tuple(di, wi, gc);
}

void userInput(Display* di, Window wi, GC gc, int* mbr, std::vector<uint32_t> color_lookup) {
    //Select what events the window will listen to
    XSelectInput(di, wi, KeyPressMask | ExposureMask);
    XEvent ev;
    int    quit = 0;
    while(!quit) {
        int a = XNextEvent(di, &ev);
    }
    XFreeGC(di, gc);
    XDestroyWindow(di, wi);
    XCloseDisplay(di);
}

int main(void) {
    auto display_open_result = OpenDisplay();
    auto di                  = std::get<0>(display_open_result);
    auto wi                  = std::get<1>(display_open_result);
    auto gc                  = std::get<2>(display_open_result);

    int N = WIDTH * HEIGHT;

    int* mbr;

    // Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&mbr, N * sizeof(float));
    // mandelbrot_single_thread_gpu<<<1, 1>>>(N, mbr);
    uint16_t thread_blocks = 4;
    uint16_t threads       = 256;

    mandelbrot_multi_thread_gpu<<<thread_blocks, threads>>>(N, mbr, thread_blocks, threads);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Display calculated mandelbrot set:
    std::vector<uint32_t> color_lookup_table = generate_color_lookup();

    drawCalculation(di, wi, gc, mbr, color_lookup_table);

    userInput(di, wi, gc, mbr, color_lookup_table);
    // Free memory
    cudaFree(mbr);
}