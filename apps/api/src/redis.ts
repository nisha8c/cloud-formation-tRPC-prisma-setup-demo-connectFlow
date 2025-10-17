import RedisPkg from "ioredis";

const Redis = RedisPkg.default ?? RedisPkg;

export const redis = new Redis({
    host: "localhost",
    port: 6379,
});
