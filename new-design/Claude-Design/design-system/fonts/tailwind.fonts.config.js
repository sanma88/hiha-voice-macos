/** hi-ha.be — Tailwind font configuration fragment
 * Merge into tailwind.config.js or tailwind.config.ts
 */

export default {
  theme: {
    extend: {
      fontFamily: {
        heading: ["Manrope", "Inter", "system-ui", "sans-serif"],
        body: ["Inter", "system-ui", "sans-serif"],
        mono: ["IBM Plex Mono", "SFMono-Regular", "Consolas", "monospace"],
      },
      fontWeight: {
        regular: "400",
        medium: "500",
        semibold: "600",
        bold: "700",
        extrabold: "800",
      },
      letterSpacing: {
        brandTight: "-0.01em",
        brandNormal: "0",
      },
    },
  },
};
