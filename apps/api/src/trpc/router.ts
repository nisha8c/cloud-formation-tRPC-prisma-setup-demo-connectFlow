// apps/api/src/trpc/router.ts
import { initTRPC } from "@trpc/server";
import { z } from "zod";
import { prisma } from "../prisma.js"; // include .js for ESM

// -------------------------------------------------------------
// Initialize tRPC
// -------------------------------------------------------------
const t = initTRPC.create();

// -------------------------------------------------------------
// Message router
// -------------------------------------------------------------
const messageRouter = t.router({
    // Get all messages
    list: t.procedure.query(async () => {
        return prisma.message.findMany({
            orderBy: { timeStamp: "desc" },
            include: {
                richMessage: {
                    include: { textContent: true },
                },
            },
        });
    }),

    // Create a new message
    create: t.procedure
        .input(
            z.object({
                channel: z.enum(["RCS", "SMS", "WHATSAPP", "TELEGRAM", "MESSENGER"]),
                direction: z.enum(["SENT", "RECEIVED"]).default("SENT"),
                address: z.string(),
                contactName: z.string().optional(),
                text: z.string().optional(),
            })
        )
        .mutation(async ({ input }) => {
            const msg = await prisma.message.create({
                data: {
                    channel: input.channel,
                    direction: input.direction,
                    address: input.address,
                    contactName: input.contactName,
                    richMessage: input.text
                        ? {
                            create: {
                                type: "TEXT",
                                textContent: { create: { text: input.text } },
                            },
                        }
                        : undefined,
                },
                include: { richMessage: { include: { textContent: true } } },
            });

            return msg;
        }),

    // Delete a message
    delete: t.procedure
        .input(z.string())
        .mutation(async ({ input }) => {
            await prisma.message.delete({ where: { id: input } });
            return { success: true };
        }),
});

// -------------------------------------------------------------
// Contact router
// -------------------------------------------------------------
const contactRouter = t.router({
    list: t.procedure.query(() => prisma.contact.findMany()),

    create: t.procedure
        .input(
            z.object({
                name: z.string(),
                phone: z.string(),
                email: z.string().optional(),
            })
        )
        .mutation(({ input }) => prisma.contact.create({ data: input })),

    delete: t.procedure
        .input(z.string())
        .mutation(({ input }) =>
            prisma.contact.delete({ where: { id: input } })
        ),
});

// -------------------------------------------------------------
// Campaign router
// -------------------------------------------------------------
const campaignRouter = t.router({
    list: t.procedure.query(() =>
        prisma.campaign.findMany({
            include: {
                messageTemplate: true,
                contacts: { include: { contact: true } },
            },
        })
    ),

    create: t.procedure
        .input(
            z.object({
                name: z.string(),
                scheduleTime: z.date(),
                messageTemplateId: z.string(),
            })
        )
        .mutation(({ input }) => prisma.campaign.create({ data: input })),
});

// -------------------------------------------------------------
// Combine into one app router
// -------------------------------------------------------------
export const appRouter = t.router({
    message: messageRouter,
    contact: contactRouter,
    campaign: campaignRouter,

    // Simple health-check route
    health: t.procedure.query(() => "OK ✅"),
});

// -------------------------------------------------------------
// Export type for frontend inference
// -------------------------------------------------------------
export type AppRouter = typeof appRouter;
