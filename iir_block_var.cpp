#include <algorithm>
#include <cinttypes>
#include <cmath>
#include <cstdio>
#include <memory>
#ifdef _WIN32
#include <intrin.h>
#else
#include <x86intrin.h>
#endif

#ifdef _MSC_VER
#define INLINE __forceinline
#define NOINLINE __declspec(noinline)
#define M_PI 3.14159265358979323846
#else
#define INLINE __attribute__((always_inline))
#define NOINLINE __attribute__((noinline))
#endif

class Iir2nd {
    float xd[2];
    float yd[2];

public:
    float b[3];
    float a[2];

    Iir2nd() {
        xd[0] = xd[1] = yd[0] = yd[1] = 0;
    }

    Iir2nd(const Iir2nd&) = default;
    Iir2nd& operator=(const Iir2nd&) = default;
    Iir2nd(Iir2nd&&) = default;
    Iir2nd& operator=(Iir2nd&&) = default;

    NOINLINE void process(float* xy, int block_size) {
        for (int i = 0; i < block_size; ++i) {
            float x = xy[i];
            float y =  b[0] * x + b[1] * xd[0] + b[2] * xd[1] - a[0] * yd[0] - a[1] * yd[1];
            xd[1] = xd[0];
            xd[0] = x;
            yd[1] = yd[0];
            yd[0] = y;
            xy[i] = y;
        }
    }
};

class Iir2ndCascaded {
    Iir2nd *m_sections;
    int m_num_sections;

public:
    Iir2ndCascaded(int num_sections) {
        m_sections = new Iir2nd[num_sections];
        m_num_sections = num_sections;
    }

    Iir2ndCascaded(const Iir2ndCascaded&) = delete;
    Iir2ndCascaded& operator=(const Iir2ndCascaded&) = delete;

    Iir2ndCascaded(Iir2ndCascaded&& that) :
        m_sections{that.m_sections},
        m_num_sections{that.m_num_sections}
    {
        that.m_sections = nullptr;
    }

    Iir2ndCascaded& operator=(Iir2ndCascaded&& that) {
        new (this) Iir2ndCascaded(std::move(that));
        return *this;
    }

    ~Iir2ndCascaded() {
        delete[] m_sections;
    }

    NOINLINE void process(float* xy, int block_size) {
        for (int i = 0; i < m_num_sections; ++i) {
            m_sections[i].process(xy, block_size);
        }
    }

    Iir2nd& sections(int i) const { return m_sections[i]; }
};

int main(int argc, char* argv[]) {
    const int SAMPLE_RATE = 48000;
    const float FMIN = 20.f;
    const float FMAX = 20000.f;

    if (argc < 3) {
        fprintf(stderr, "missing block_size or num_sections\n");
        return 1;
    }

#ifdef _WIN32
    char* prog = strrchr(argv[0], '\\');
#else
    char* prog = strrchr(argv[0], '/');
#endif
    prog = prog ? prog + 1 : argv[0];
    if (strlen(prog) >= 4 && strcmp(&prog[strlen(prog) - 4], ".exe") == 0) {
        prog[strlen(prog) - 4] = '\0';
    }

    int block_size = atoi(argv[1]);
    int sections = atoi(argv[2]);

    auto iir = Iir2ndCascaded{sections};

    for (int i = 0; i < sections; ++i) {
        // design a 2nd order peaking filter
        float freq = FMIN * std::pow(FMAX / FMIN, (float)(i + 1) / (sections + 1));
        float q = 4.f;
        float gain = std::pow(0.5f, (i % 2) * 2 - 1);
        float w0 = 2 * (float)M_PI * freq / static_cast<float>(SAMPLE_RATE);
        float alpha = std::sin(w0) / (2 * q);
        float A = std::sqrt(gain);
        float a0 = 1 + alpha / A;
        iir.sections(i).b[0] = (1 + alpha * A) / a0;
        iir.sections(i).b[1] = -2 * std::cos(w0) / a0;
        iir.sections(i).b[2] = (1 - alpha * A) / a0;
        iir.sections(i).a[0] = -2 * std::cos(w0) / a0;
        iir.sections(i).a[1] = (1 - alpha / A) / a0;
    }

    FILE* infile = fopen("chirp.pcm", "rb");
    fseek(infile, 0, SEEK_END);
    long size = ftell(infile);
    int len = size / sizeof(float);
    auto xy = std::make_unique<float[]>(len);
    fseek(infile, 0, SEEK_SET);
    size_t read_count = 0;
    do {
        read_count += fread(xy.get(), sizeof(float), len - read_count, infile);
    } while (read_count < len);
    fclose(infile);
    float duration = (float)len / SAMPLE_RATE;

    uint64_t start = __rdtsc();
    for (int i = 0; i < len; i += block_size) {
        iir.process(&xy[i], std::min(block_size, len - i));
    }
    uint64_t end = __rdtsc();
    printf("%-26s: duration: %6.2f, block_size: %4d, sections: %3d, cycles: %12" PRIu64 ", MCPS: %8.4f\n", prog, duration, block_size, sections, end - start, (double)(end - start) / duration / 1e6);

    FILE *outfile = fopen("iir-block-var-out.pcm", "wb");
    fwrite(xy.get(), sizeof(float), len, outfile);
    fclose(outfile);

    return 0;
}
