#include <cmath>
#include <cstdio>
#include <memory>

#ifdef _MSC_VER
#define M_PI 3.14159265358979323846
#endif

int main(int argc, char *argv[]) {
    const int SAMPLE_RATE = 48000;
    const float FMIN = 20.f;
    const float FMAX = 20000.f;

    if (argc < 2) {
        fprintf(stderr,  "missing duration\n");
    }

    int duration = atoi(argv[1]);
    int len = SAMPLE_RATE * duration;

    auto data = std::make_unique<float[]>(len);
    for (int i = 0; i < len; ++i) {
        double t = i / (double)SAMPLE_RATE;
        data[i] = 0.5f * std::cos(2.0f * (float)M_PI * FMIN * duration * (std::pow((double)FMAX / FMIN, t / duration) - 1) / std::log((double)FMAX / FMIN));
    }

    FILE *outfile = fopen("chirp.pcm", "wb");
    size_t size = 0;
    do {
        size += fwrite(data.get(), sizeof(float), len - size, outfile);
    } while (size < len);
    fclose(outfile);

    return 0;
}
