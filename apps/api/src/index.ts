import express from "express";
import cors from "cors";
import { createExpressMiddleware } from "@trpc/server/adapters/express";
import { appRouter } from "./trpc/router.js";
import { prisma } from "./prisma.js";
import { redis } from "./redis.js";
import dotenv from "dotenv";

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.use("/trpc", createExpressMiddleware({ router: appRouter }));

app.get("/", (_, res) => res.send("RCS API running ✅"));

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`API running on ${PORT}`));
