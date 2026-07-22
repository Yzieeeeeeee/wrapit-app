// liquid_glass.frag
// Wrap It — Liquid Glass Fragment Shader (WWDC25 style)
//
// Renders the specular highlights, animated shimmer, inner glow,
// and subtle touch-ripple that give the nav bar its "living liquid" feel.
// This runs on TOP of a BackdropFilter blur which provides the frosted base.
//
// Uniforms:
//   uTime       — seconds since start (drives shimmer animation)
//   uSize       — pixel size of the nav bar widget
//   uBlobPos    — normalized X position [0..1] of the selected tab's blob center
//   uPressure   — touch pressure [0..1] (drives ripple + intensity)

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2  uSize;
uniform float uBlobPos;   // 0.0 = leftmost tab, 1.0 = rightmost tab
uniform float uPressure;  // 0.0 = idle, 1.0 = fully pressed

out vec4 fragColor;

// Smooth noise helper — returns [0,1] pseudo-random value
float hash(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

// Organic rounded-rect SDF — returns signed distance from pill
float pillSDF(vec2 uv, vec2 center, vec2 halfSize, float radius) {
    vec2 d = abs(uv - center) - halfSize + vec2(radius);
    return length(max(d, 0.0)) - radius;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;          // normalized [0..1] x [0..1]
    float aspect = uSize.x / uSize.y;

    vec4 result = vec4(0.0);

    // ── 1. Top specular band ────────────────────────────────────────
    // A curved bright band along the very top edge, like light
    // hitting the upper rim of a glass bowl.
    float specY = 1.0 - uv.y;            // 0=bottom, 1=top
    float specBand = smoothstep(0.72, 1.0, specY);
    // Fade toward the left/right edges for a natural arc
    float specEdgeFade = smoothstep(0.0, 0.15, uv.x) * smoothstep(1.0, 0.85, uv.x);
    float specShimmer = 0.85 + 0.15 * sin(uTime * 1.8 + uv.x * 6.0);
    result += vec4(1.0, 1.0, 1.0, specBand * specEdgeFade * specShimmer * 0.40);

    // ── 2. Bottom thin highlight ────────────────────────────────────
    // A thin bright line along the very bottom — light internally
    // reflecting back up, making it feel like a filled liquid.
    float bottomGlow = smoothstep(0.08, 0.0, uv.y) * 0.22;
    result += vec4(1.0, 1.0, 1.0, bottomGlow);

    // ── 3. Selected-tab liquid blob glow ───────────────────────────
    // A warm pink "puddle" of light under the active icon.
    // Follows uBlobPos with a falloff that makes it look like
    // poured liquid settling into a well.
    vec2 blobCenter = vec2(uBlobPos, 0.52);
    vec2 blobUV = vec2((uv.x - blobCenter.x) * aspect, uv.y - blobCenter.y);
    float blobDist = length(blobUV * vec2(2.5, 1.0)); // wider than tall
    float blobCore = exp(-blobDist * blobDist * 7.0);
    float blobRing = exp(-blobDist * blobDist * 2.5) * 0.35;
    // Animate a subtle inner shimmer so it never looks static
    float blobShimmer = 1.0 + 0.12 * sin(uTime * 2.5 - blobDist * 8.0);
    result += vec4(0.96, 0.45, 0.61, (blobCore * 0.55 + blobRing) * blobShimmer);

    // ── 4. Touch ripple ─────────────────────────────────────────────
    // Concentric rings that emanate from the blob center when pressed,
    // fading out with distance and decaying as pressure releases.
    if (uPressure > 0.01) {
        float rippleDist = length(blobUV * vec2(2.0, 1.0));
        float ripple = sin(rippleDist * 28.0 - uTime * 12.0)
                     * exp(-rippleDist * 5.0)
                     * uPressure
                     * 0.18;
        result += vec4(1.0, 1.0, 1.0, max(ripple, 0.0));
    }

    // ── 5. Edge soft glow ──────────────────────────────────────────
    // A very subtle inner border highlight on all rounded edges,
    // simulating light refracting around the pill geometry.
    float edgeDist = min(
        min(uv.x, 1.0 - uv.x) * aspect,
        min(uv.y, 1.0 - uv.y)
    );
    float edgeHighlight = smoothstep(0.18, 0.0, edgeDist) * 0.12;
    result += vec4(1.0, 1.0, 1.0, edgeHighlight);

    // ── Final: clamp alpha so we don't overblow ─────────────────────
    result.a = clamp(result.a, 0.0, 0.92);
    fragColor = result;
}
