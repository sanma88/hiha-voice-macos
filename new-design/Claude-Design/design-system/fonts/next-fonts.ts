// hi-ha.be — Next.js App Router font setup
// File suggestion: app/fonts.ts

import { Manrope, Inter, IBM_Plex_Mono } from "next/font/google";

export const manrope = Manrope({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
  variable: "--font-manrope",
  display: "swap",
});

export const inter = Inter({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-inter",
  display: "swap",
});

export const ibmPlexMono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-ibm-plex-mono",
  display: "swap",
});

/*
In app/layout.tsx:

import { manrope, inter, ibmPlexMono } from "./fonts";
import "./globals.css";

export default function RootLayout({ children }) {
  return (
    <html lang="fr" className={`${manrope.variable} ${inter.variable} ${ibmPlexMono.variable}`}>
      <body>{children}</body>
    </html>
  );
}

In globals.css:

:root {
  --font-brand-heading: var(--font-manrope);
  --font-brand-body: var(--font-inter);
  --font-brand-mono: var(--font-ibm-plex-mono);
}
*/
