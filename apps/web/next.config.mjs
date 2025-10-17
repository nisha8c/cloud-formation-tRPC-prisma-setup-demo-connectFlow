/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    experimental: {
        turbopack: {
            rules: {
                "*.svg": ["@svgr/webpack"],
            },
        },
    },
    outputFileTracingRoot: "../../", // silence that workspace warning
};

export default nextConfig;
