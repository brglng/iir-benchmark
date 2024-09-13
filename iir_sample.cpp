#include <cmath>
#include <cstdio>
#include <memory>
#ifdef _WIN32
#include <intrin.h>
#else
#include <x86intrin.h>
#endif

#define INLINE __attribute__((always_inline))
#define NOINLINE __attribute__((noinline))

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

    INLINE float process(float x) {
        float y =  b[0] * x + b[1] * xd[0] + b[2] * xd[1] - a[0] * yd[0] - a[1] * yd[1];
        xd[1] = xd[0];
        xd[0] = x;
        yd[1] = yd[0];
        yd[0] = y;
        return y;
    }
};

template<int N, int I = 0> struct Process {
    static INLINE float process(Iir2nd *sections, float x) {
        float y = sections[I].process(x);
        return Process<N, I + 1>::process(sections, y);
    }
};

template<int N> struct Process<N, N - 1> {
    static INLINE float process(Iir2nd *sections, float x) {
        float y = sections[N - 1].process(x);
        return y;
    }
};

template<int SECTIONS>
class Iir2ndCascaded {
    Iir2nd m_sections[SECTIONS];

public:
    Iir2ndCascaded() {}
    Iir2ndCascaded(const Iir2ndCascaded&) = default;
    Iir2ndCascaded& operator=(const Iir2ndCascaded&) = default;
    Iir2ndCascaded(Iir2ndCascaded&&) = default;
    Iir2ndCascaded& operator=(Iir2ndCascaded&&) = default;

    NOINLINE void process(float* xy, int block_size) {
        for (int i = 0; i < block_size; i++) {
            float x = xy[i];
            float y = Process<SECTIONS>::process(m_sections, x);
            xy[i] = y;
        }
    }

    Iir2nd& sections(int i) { return m_sections[i]; }
};

int main(int argc, const char* argv[]) {
    const int SECTIONS = 20;
    const int SAMPLE_RATE = 48000;
    const int DURATION = 600;
    const int LEN = SAMPLE_RATE * DURATION;
    const float FMIN = 20.f;
    const float FMAX = 20000.f;

    if (argc < 2) {
        fprintf(stderr, "missing block size\n");
        return 1;
    }

    int block_size = atoi(argv[1]);

    auto iir = Iir2ndCascaded<SECTIONS>{};

    for (int i = 0; i < SECTIONS; ++i) {
        // design a 2nd order peaking filter
        float freq = FMIN * std::pow(FMAX / FMIN, (float)(i + 1) / (SECTIONS + 1));
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

    auto xy = std::make_unique<float[]>(LEN);
    for (int i = 0; i < LEN; ++i) {
        double t = i / (double)SAMPLE_RATE;
        xy[i] = 0.5f * std::cos(2.0f * (float)M_PI * FMIN * DURATION * (std::pow((double)FMAX / FMIN, t / DURATION) - 1) / std::log((double)FMAX / FMIN));
    }

    uint64_t start = __rdtsc();
    for (volatile int i = 0; i < LEN; i += block_size) {
        iir.process(&xy[i], std::min(block_size, LEN - i));
    }
    uint64_t end = __rdtsc();
    printf("%s: block_size: %d, cycles: %lu, MCPS: %f\n", argv[0], block_size, end - start, (double)(end - start) / DURATION / 1e6);

    FILE *outfile = fopen("iir-sample-out.pcm", "wb");
    fwrite(xy.get(), sizeof(float), LEN, outfile);
    fclose(outfile);

    return 0;
}
