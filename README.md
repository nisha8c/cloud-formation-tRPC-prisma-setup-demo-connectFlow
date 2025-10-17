# 🚀 ConnectFlow — Rich Communication Services Platform

**ConnectFlow** is a modular, full-stack application for creating and managing RCS (Rich Communication Services) message campaigns.

It includes:
- 📦 Monorepo structure (Apps + Packages)
- ⚙️ Type-safe backend with **Express + tRPC + Prisma**
- 💾 Database via **PostgreSQL (RDS)**
- ⚡ Real-time caching via **Redis (ElastiCache)**
- 🎨 Frontend with **Next.js + tRPC + TailwindCSS + Redux**
- ☁️ Deployment with **AWS CloudFormation + ECS + RDS + ElastiCache**

---

## 🧩 Monorepo Structure
connect-flow/
│
├── apps/
│ ├── api/ # Express + tRPC backend
│ └── web/ # Next.js 15 frontend
│
├── packages/
│ └── db/ # Shared Prisma client + schema
│
└── infra/
└── cloudformation/
├── rds.yml # PostgreSQL stack
├── redis.yml # ElastiCache Redis stack
└── ecs.yml # ECS + Fargate API deployment



---

## 🧱 Tech Stack

| Layer | Tech |
|-------|------|
| **Frontend** | Next.js 15, React 19, TailwindCSS, Redux Toolkit, Radix UI |
| **Backend** | Express, tRPC, Prisma ORM |
| **Database** | PostgreSQL (via Prisma + AWS RDS) |
| **Cache** | Redis (ioredis + AWS ElastiCache) |
| **Infra** | AWS ECS, CloudFormation, Docker |
| **Package Management** | npm workspaces |

---

## 🧰 Prerequisites

Before setting up locally or deploying:

- [Node.js](https://nodejs.org/) ≥ 20.x
- [npm](https://www.npmjs.com/) ≥ 9.x
- [Docker](https://www.docker.com/) (for local database/Redis)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- AWS account with permissions for ECS, RDS, IAM, CloudFormation

---

## ⚙️ Local Development Setup

### 1️⃣ Clone the repo
```bash

git clone https://github.com/<your-username>/connect-flow.git
cd connect-flow


# Install dependencies
npm install
This installs shared dependencies across all workspaces (apps/*, packages/*).

🗃️ Database (Prisma + Postgres)
3️ Create local database with Docker
docker run --name connectflow-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

4️ Set up .env for the API

In apps/api/.env:

DATABASE_URL="postgresql://postgres:postgres@localhost:5432/connectflow"
REDIS_HOST="localhost"
PORT=4000

5️ Generate Prisma client + migrate schema
cd packages/db
npx prisma migrate dev --name init_schema


You should see:

Your database is now in sync with your schema.
✔ Generated Prisma Client

🧠 Backend (tRPC + Express)
6️ Run the API server
cd apps/api
npm run dev


It should print:

API running on 4000


Visit → http://localhost:4000

💻 Frontend (Next.js + tRPC + Redux)
7️ Configure frontend

In apps/web/src/app/layout.tsx, make sure your API URL points to the local backend:

httpBatchLink({ url: "http://localhost:4000/trpc" })

8️ Start the web app
npm run dev --workspace=web


Visit → http://localhost:3000

You’ll see:

🚀 ConnectFlow Dashboard
Your frontend is now connected and running on Next.js!

🧩 Shared Database Package

packages/db includes the Prisma schema and generates a shared Prisma Client:

cd packages/db
npx prisma generate


It’s used in the API as:

import { prisma } from "@repo/db";

☁️ AWS Infrastructure (CloudFormation)

All infra templates live in infra/cloudformation.

Stack	Template	Description
RDS	rds.yml	PostgreSQL database
Redis	redis.yml	ElastiCache Redis cluster
ECS	ecs.yml	Fargate task running the API
Deploy each stack:
1️⃣ Create RDS (PostgreSQL)
aws cloudformation deploy \
  --template-file infra/cloudformation/rds.yml \
  --stack-name rcs-db-stack \
  --parameter-overrides DBUsername=postgres DBPassword='MyS3cureRDS_P@ssw0rd!' \
  --region eu-north-1 \
  --capabilities CAPABILITY_NAMED_IAM

2️⃣ Create Redis (ElastiCache)
aws cloudformation deploy \
  --template-file infra/cloudformation/redis.yml \
  --stack-name rcs-redis-stack \
  --region eu-north-1

3️⃣ Deploy API to ECS (after pushing image to ECR)
aws cloudformation deploy \
  --template-file infra/cloudformation/ecs.yml \
  --stack-name rcs-ecs-stack \
  --parameter-overrides \
    EcrImage=123456789012.dkr.ecr.eu-north-1.amazonaws.com/connect-flow-api:latest \
    DatabaseUrl='postgresql://postgres:MyS3cureRDS_P@ssw0rd!@rcs-db-stack.xxxxxx.eu-north-1.rds.amazonaws.com:5432/connectflow' \
    RedisHost='rcs-redis-stack.xxxxxx.eu-north-1.cache.amazonaws.com' \
    VpcId=vpc-xxxxxxx \
    SubnetIds='subnet-xxxxxx,subnet-yyyyyy' \
    SecurityGroupId=sg-xxxxxxx \
  --region eu-north-1 \
  --capabilities CAPABILITY_NAMED_IAM

🧹 Teardown (to avoid AWS charges)

To delete all resources:

aws cloudformation delete-stack --stack-name rcs-ecs-stack --region eu-north-1
aws cloudformation delete-stack --stack-name rcs-redis-stack --region eu-north-1
aws cloudformation delete-stack --stack-name rcs-db-stack --region eu-north-1







# Turborepo starter

This Turborepo starter is maintained by the Turborepo core team.

## Using this example

Run the following command:

```sh
npx create-turbo@latest
```




# How to RUN
🧩 Run ConnectFlow — Full Local Setup Guide

You’ll run three main parts:
1️⃣ Database (Postgres)
2️⃣ Backend API (Express + tRPC)
3️⃣ Frontend (Next.js 15)

Everything below assumes you’re in your monorepo root:

/Users/nishachavan/connect-flow

🧱 1️⃣ Start PostgreSQL (Database)

📍 Run this from the root folder (connect-flow):

docker run --name connectflow-db \
-e POSTGRES_PASSWORD=postgres \
-p 5432:5432 \
-d postgres


✅ This runs Postgres in Docker:

User: postgres

Password: postgres

Port: 5432

You can verify it’s running with:

docker ps

⚙️ 2️⃣ Set up Environment Variables

📍 Go to the API folder:

cd apps/api


📝 Create a file named .env inside apps/api/:

apps/api/.env


Add this content:

DATABASE_URL="postgresql://postgres:postgres@localhost:5432/connectflow"
REDIS_HOST="localhost"
PORT=4000

🧩 3️⃣ Generate Prisma Client & Apply Schema

📍 Go to the shared db package:

cd packages/db


Run:

npx prisma migrate dev --name init_schema
npx prisma generate


✅ You should see:

Your database is now in sync with your schema.
✔ Generated Prisma Client

🚀 4️⃣ Start the API (Backend)

📍 From the root folder, run:

npm run dev --workspace=api


or manually:

cd apps/api
npm run dev


✅ Expected output:

API running on 4000


Your backend is now live at
👉 http://localhost:4000

and the tRPC endpoint is at
👉 http://localhost:4000/trpc

💻 5️⃣ Start the Frontend (Next.js)

📍 In another terminal window, from the root folder:

npm run dev --workspace=web


✅ Expected output:

▲ Next.js 15.5.5
- Local: http://localhost:3000


Then open your browser to
👉 http://localhost:3000

You’ll see your frontend dashboard connecting to the backend API.

🔍 6️⃣ Verify the System
Component	URL	Expected Result
API Server	http://localhost:4000
✅ “API running” in console
tRPC Endpoint	http://localhost:4000/trpc
✅ JSON response
Frontend	http://localhost:3000
✅ Dashboard loads
Database	localhost:5432	✅ Prisma connected
🧹 7️⃣ Stop Everything

To stop services:

docker stop connectflow-db
docker rm connectflow-db

⚡ Quick Summary (for reuse)
Step	Folder	Command
1️⃣ Start DB	Root	docker run --name connectflow-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
2️⃣ Migrate DB	packages/db	npx prisma migrate dev --name init_schema
3️⃣ Start API	apps/api	npm run dev
4️⃣ Start Frontend	apps/web	npm run dev
5️⃣ Open in Browser	—	http://localhost:3000



## What's inside?

This Turborepo includes the following packages/apps:

### Apps and Packages

- `docs`: a [Next.js](https://nextjs.org/) app
- `web`: another [Next.js](https://nextjs.org/) app
- `@repo/ui`: a stub React component library shared by both `web` and `docs` applications
- `@repo/eslint-config`: `eslint` configurations (includes `eslint-config-next` and `eslint-config-prettier`)
- `@repo/typescript-config`: `tsconfig.json`s used throughout the monorepo

Each package/app is 100% [TypeScript](https://www.typescriptlang.org/).

### Utilities

This Turborepo has some additional tools already setup for you:

- [TypeScript](https://www.typescriptlang.org/) for static type checking
- [ESLint](https://eslint.org/) for code linting
- [Prettier](https://prettier.io) for code formatting

### Build

To build all apps and packages, run the following command:

```
cd my-turborepo

# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo build

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo build
yarn dlx turbo build
pnpm exec turbo build
```

You can build a specific package by using a [filter](https://turborepo.com/docs/crafting-your-repository/running-tasks#using-filters):

```
# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo build --filter=docs

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo build --filter=docs
yarn exec turbo build --filter=docs
pnpm exec turbo build --filter=docs
```

### Develop

To develop all apps and packages, run the following command:

```
cd my-turborepo

# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo dev

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo dev
yarn exec turbo dev
pnpm exec turbo dev
```

You can develop a specific package by using a [filter](https://turborepo.com/docs/crafting-your-repository/running-tasks#using-filters):

```
# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo dev --filter=web

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo dev --filter=web
yarn exec turbo dev --filter=web
pnpm exec turbo dev --filter=web
```

### Remote Caching

> [!TIP]
> Vercel Remote Cache is free for all plans. Get started today at [vercel.com](https://vercel.com/signup?/signup?utm_source=remote-cache-sdk&utm_campaign=free_remote_cache).

Turborepo can use a technique known as [Remote Caching](https://turborepo.com/docs/core-concepts/remote-caching) to share cache artifacts across machines, enabling you to share build caches with your team and CI/CD pipelines.

By default, Turborepo will cache locally. To enable Remote Caching you will need an account with Vercel. If you don't have an account you can [create one](https://vercel.com/signup?utm_source=turborepo-examples), then enter the following commands:

```
cd my-turborepo

# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo login

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo login
yarn exec turbo login
pnpm exec turbo login
```

This will authenticate the Turborepo CLI with your [Vercel account](https://vercel.com/docs/concepts/personal-accounts/overview).

Next, you can link your Turborepo to your Remote Cache by running the following command from the root of your Turborepo:

```
# With [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation) installed (recommended)
turbo link

# Without [global `turbo`](https://turborepo.com/docs/getting-started/installation#global-installation), use your package manager
npx turbo link
yarn exec turbo link
pnpm exec turbo link
```

## Useful Links

Learn more about the power of Turborepo:

- [Tasks](https://turborepo.com/docs/crafting-your-repository/running-tasks)
- [Caching](https://turborepo.com/docs/crafting-your-repository/caching)
- [Remote Caching](https://turborepo.com/docs/core-concepts/remote-caching)
- [Filtering](https://turborepo.com/docs/crafting-your-repository/running-tasks#using-filters)
- [Configuration Options](https://turborepo.com/docs/reference/configuration)
- [CLI Usage](https://turborepo.com/docs/reference/command-line-reference)
