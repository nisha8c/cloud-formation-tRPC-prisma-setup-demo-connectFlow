"use client";

import { configureStore } from "@reduxjs/toolkit";
import composerReducer from "./composerSlice";

// The root Redux store
export const store = configureStore({
    reducer: {
        composer: composerReducer,
    },
});

// Infer types for use throughout the app
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
