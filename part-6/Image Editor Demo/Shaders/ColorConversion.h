#ifndef ColorConversion_h
#define ColorConversion_h

#include <metal_stdlib>
using namespace metal;

#import <simd/simd.h>

// MARK: - LAB & RGB

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC xyz2lab(vec<T, 3> c) {
    float3 n = float3(c) / float3(95.047f, 100.0f, 108.883f);
    float3 v;
    v.x = (n.x > 0.008856f)
        ? pow(n.x, 1.0f / 3.0f)
        : (7.787f * n.x ) + ( 16.0f / 116.0f);
    v.y = (n.y > 0.008856f)
        ? pow(n.y, 1.0f / 3.0f)
        : (7.787f * n.y ) + ( 16.0f / 116.0f);
    v.z = (n.z > 0.008856f)
        ? pow(n.z, 1.0f / 3.0f)
        : (7.787f * n.z ) + ( 16.0f / 116.0f);
    return vec<T, 3>((116.0f * v.y) - 16.0f, 500.0f * (v.x - v.y), 200.0f * (v.y - v.z));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC rgb2xyz(vec<T, 3> c) {
    float3 tmp;
    tmp.x = (float(c.r) > 0.04045f)
          ? pow((float(c.r) + 0.055f) / 1.055f, 2.4f)
          : float(c.r) / 12.92f;
    tmp.y = (float(c.g) > 0.04045f)
          ? pow((float(c.g) + 0.055f) / 1.055f, 2.4f)
          : float(c.g) / 12.92f,
    tmp.z = (float(c.b) > 0.04045f)
          ? pow((float(c.b) + 0.055f) / 1.055f, 2.4f)
          : float(c.b) / 12.92f;
    const float3x3 mat = float3x3(float3(0.4124f, 0.3576f, 0.1805f),
                                  float3(0.2126f, 0.7152f, 0.0722f),
                                  float3(0.0193f, 0.1192f, 0.9505f));
    return vec<T, 3>(100.0f * (tmp * mat));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC rgb2lab( vec<T, 3> c ) {
    const float3 lab = xyz2lab(rgb2xyz(float3(c)));
    return vec<T, 3>(lab.x / 100.0f,
                     0.5f + 0.5f * (lab.y / 127.0f),
                     0.5f + 0.5f * (lab.z / 127.0f));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC lab2xyz(vec<T, 3> c) {
    const auto fy = ( float(c.x) + 16.0f ) / 116.0f;
    const auto fx = float(c.y) / 500.0f + fy;
    const auto fz = fy - float(c.z) / 200.0f;
    return vec<T, 3>(95.047f * ((fx > 0.206897f) ? fx * fx * fx : (fx - 16.0f / 116.0f) / 7.787f),
                     100.000f * ((fy > 0.206897f) ? fy * fy * fy : (fy - 16.0f / 116.0f) / 7.787f),
                     108.883f * ((fz > 0.206897f) ? fz * fz * fz : (fz - 16.0f / 116.0f) / 7.787f));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC xyz2rgb(vec<T, 3> c) {
    const float3x3 mat = float3x3(float3(3.2406f, -1.5372f, -0.4986f),
                                  float3(-0.9689f, 1.8758f, 0.0415f),
                                  float3(0.0557f, -0.2040f, 1.0570f));
    const auto v = (float3(c) / 100.0f) * mat;
    float3 r;
    r.x = (v.r > 0.0031308f)
        ? ((1.055f * pow( v.r, ( 1.0f / 2.4f))) - 0.055f)
        : 12.92f * v.r;
    r.y = (v.g > 0.0031308f)
        ? ((1.055f * pow( v.g, ( 1.0f / 2.4f))) - 0.055f)
        : 12.92f * v.g;
    r.z = (v.b > 0.0031308f)
        ? ((1.055f * pow( v.b, ( 1.0f / 2.4f))) - 0.055f)
        : 12.92f * v.b;
    return vec<T, 3>(r);
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC lab2rgb( vec<T, 3> c ) {
    return vec<T, 3>(xyz2rgb(lab2xyz(float3(100.0f * float(c.x),
                                            2.0f * 127.0f * (float(c.y) - 0.5f),
                                            2.0f * 127.0f * (float(c.z) - 0.5f)))));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
inline clipLab(vec<T, 3> color) {
    return vec<T, 3>(clamp(color.r, T(0.0f), T(1.0f)),
                     clamp(color.g, T(-127.0f), T(127.0f)),
                     clamp(color.b, T(-127.0f), T(127.0f)));
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC denormalizeLab(vec<T, 3> labColor) {
    vec<T, 3> result = labColor;
    result.g = (result.g - T(0.5f)) * T(255.0f);
    result.b = (result.b - T(0.5f)) * T(255.0f);
    return result;
}

template <typename T>
enable_if_t<is_floating_point_v<T>, vec<T, 3>>
METAL_FUNC normalizeLab(vec<T, 3> labColor) {
    vec<T, 3> result = labColor;
    result.g = result.g / T(255.0f) + T(0.5f);
    result.b = result.b / T(255.0f) + T(0.5f);
    return result;
}


#endif /* ColorConversion_h */
