# 1️⃣ Base image
FROM node:20-alpine

# 2️⃣ Set working directory
WORKDIR /usr/src/app

# 3️⃣ Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# 4️⃣ Copy the API source code
COPY . .

# 5️⃣ Copy the Prisma schema from the shared db package
COPY ../../packages/db/prisma ./prisma

# 6️⃣ Generate Prisma client inside the image
RUN npx prisma generate --schema=./prisma/schema.prisma

# 7️⃣ Expose the API port
EXPOSE 4000

# 8️⃣ Start the server
CMD ["npm", "run", "dev"]
