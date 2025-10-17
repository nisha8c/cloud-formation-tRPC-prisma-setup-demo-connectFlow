"use client";

import { trpc } from "../utils/trpc";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Provider as ReduxProvider } from "react-redux";
import { store } from "../store";
import "./globals.css";
import { ReactNode } from "react";
import { httpBatchLink } from "@trpc/client";

// Initialize clients once
const queryClient = new QueryClient();
const trpcClient = trpc.createClient({
    links: [
        httpBatchLink({
            url: "http://localhost:4000/trpc",
        }),
    ],
});

export default function RootLayout({ children }: { children: ReactNode }) {
    return (
        <html lang="en">
        <body className="bg-gray-50 text-gray-900">
        <trpc.Provider client={trpcClient} queryClient={queryClient}>
            <QueryClientProvider client={queryClient}>
                <ReduxProvider store={store}>{children}</ReduxProvider>
            </QueryClientProvider>
        </trpc.Provider>
        </body>
        </html>
    );
}
