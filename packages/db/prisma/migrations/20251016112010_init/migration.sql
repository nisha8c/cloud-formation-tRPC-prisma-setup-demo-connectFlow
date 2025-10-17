-- CreateEnum
CREATE TYPE "Channel" AS ENUM ('RCS', 'SMS', 'WHATSAPP', 'TELEGRAM', 'MESSENGER');

-- CreateEnum
CREATE TYPE "MessageDirection" AS ENUM ('SENT', 'RECEIVED');

-- CreateEnum
CREATE TYPE "RichMessageType" AS ENUM ('TEXT', 'RICH_CARD', 'CONTENT_INFO', 'FILE_CONTENT');

-- CreateEnum
CREATE TYPE "RichCardType" AS ENUM ('STANDALONE', 'CAROUSEL');

-- CreateEnum
CREATE TYPE "MediaHeight" AS ENUM ('SMALL', 'MEDIUM', 'TALL');

-- CreateEnum
CREATE TYPE "SuggestionType" AS ENUM ('OPEN_URL', 'VIEW_LOCATION', 'SHARE_LOCATION', 'CREATE_CALENDAR_EVENT', 'DIAL');

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "timeStamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "direction" "MessageDirection" NOT NULL,
    "channel" "Channel" NOT NULL,
    "address" TEXT,
    "contactName" TEXT,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RichMessage" (
    "id" TEXT NOT NULL,
    "type" "RichMessageType" NOT NULL,
    "messageId" TEXT NOT NULL,

    CONSTRAINT "RichMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TextContent" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "richMessageId" TEXT NOT NULL,

    CONSTRAINT "TextContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContentInfo" (
    "id" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "thumbnailUrl" TEXT,
    "richMessageId" TEXT,

    CONSTRAINT "ContentInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FileContent" (
    "id" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileUrl" TEXT,
    "thumbnailName" TEXT,
    "richMessageId" TEXT NOT NULL,

    CONSTRAINT "FileContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RichCard" (
    "id" TEXT NOT NULL,
    "type" "RichCardType" NOT NULL,
    "richMessageId" TEXT NOT NULL,

    CONSTRAINT "RichCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StandaloneCard" (
    "id" TEXT NOT NULL,
    "contentId" TEXT NOT NULL,
    "richCardId" TEXT NOT NULL,

    CONSTRAINT "StandaloneCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Carousel" (
    "id" TEXT NOT NULL,
    "richCardId" TEXT NOT NULL,

    CONSTRAINT "Carousel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CardContent" (
    "id" TEXT NOT NULL,
    "title" TEXT,
    "description" TEXT,
    "mediaId" TEXT,
    "carouselId" TEXT,

    CONSTRAINT "CardContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Media" (
    "id" TEXT NOT NULL,
    "height" "MediaHeight" NOT NULL DEFAULT 'MEDIUM',
    "contentInfoId" TEXT,

    CONSTRAINT "Media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Suggestion" (
    "id" TEXT NOT NULL,
    "type" "SuggestionType" NOT NULL,
    "text" TEXT NOT NULL,
    "url" TEXT,
    "label" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "eventTitle" TEXT,
    "eventDescription" TEXT,
    "startTime" TIMESTAMP(3),
    "endTime" TIMESTAMP(3),
    "phoneNumber" TEXT,
    "richMessageId" TEXT,
    "cardContentId" TEXT,

    CONSTRAINT "Suggestion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Message_timeStamp_idx" ON "Message"("timeStamp");

-- CreateIndex
CREATE INDEX "Message_direction_channel_idx" ON "Message"("direction", "channel");

-- CreateIndex
CREATE UNIQUE INDEX "RichMessage_messageId_key" ON "RichMessage"("messageId");

-- CreateIndex
CREATE UNIQUE INDEX "TextContent_richMessageId_key" ON "TextContent"("richMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "ContentInfo_richMessageId_key" ON "ContentInfo"("richMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "FileContent_richMessageId_key" ON "FileContent"("richMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "RichCard_richMessageId_key" ON "RichCard"("richMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "StandaloneCard_contentId_key" ON "StandaloneCard"("contentId");

-- CreateIndex
CREATE UNIQUE INDEX "StandaloneCard_richCardId_key" ON "StandaloneCard"("richCardId");

-- CreateIndex
CREATE UNIQUE INDEX "Carousel_richCardId_key" ON "Carousel"("richCardId");

-- CreateIndex
CREATE UNIQUE INDEX "CardContent_mediaId_key" ON "CardContent"("mediaId");

-- CreateIndex
CREATE UNIQUE INDEX "Media_contentInfoId_key" ON "Media"("contentInfoId");

-- CreateIndex
CREATE INDEX "Suggestion_type_idx" ON "Suggestion"("type");

-- CreateIndex
CREATE INDEX "Suggestion_richMessageId_idx" ON "Suggestion"("richMessageId");

-- CreateIndex
CREATE INDEX "Suggestion_cardContentId_idx" ON "Suggestion"("cardContentId");

-- AddForeignKey
ALTER TABLE "RichMessage" ADD CONSTRAINT "RichMessage_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_richMessageId_fkey" FOREIGN KEY ("richMessageId") REFERENCES "RichMessage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContentInfo" ADD CONSTRAINT "ContentInfo_richMessageId_fkey" FOREIGN KEY ("richMessageId") REFERENCES "RichMessage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FileContent" ADD CONSTRAINT "FileContent_richMessageId_fkey" FOREIGN KEY ("richMessageId") REFERENCES "RichMessage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RichCard" ADD CONSTRAINT "RichCard_richMessageId_fkey" FOREIGN KEY ("richMessageId") REFERENCES "RichMessage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StandaloneCard" ADD CONSTRAINT "StandaloneCard_contentId_fkey" FOREIGN KEY ("contentId") REFERENCES "CardContent"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StandaloneCard" ADD CONSTRAINT "StandaloneCard_richCardId_fkey" FOREIGN KEY ("richCardId") REFERENCES "RichCard"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carousel" ADD CONSTRAINT "Carousel_richCardId_fkey" FOREIGN KEY ("richCardId") REFERENCES "RichCard"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CardContent" ADD CONSTRAINT "CardContent_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "Media"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CardContent" ADD CONSTRAINT "CardContent_carouselId_fkey" FOREIGN KEY ("carouselId") REFERENCES "Carousel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Media" ADD CONSTRAINT "Media_contentInfoId_fkey" FOREIGN KEY ("contentInfoId") REFERENCES "ContentInfo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Suggestion" ADD CONSTRAINT "Suggestion_richMessageId_fkey" FOREIGN KEY ("richMessageId") REFERENCES "RichMessage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Suggestion" ADD CONSTRAINT "Suggestion_cardContentId_fkey" FOREIGN KEY ("cardContentId") REFERENCES "CardContent"("id") ON DELETE CASCADE ON UPDATE CASCADE;
