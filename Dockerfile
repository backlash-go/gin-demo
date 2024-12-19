FROM registry-vpc.cn-shenzhen.aliyuncs.com/kuaifu-test/generic:golang-1-21-5 AS build-env

MAINTAINER xxb

ENV WORKSPACE=/workspace
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
RUN mkdir $WORKSPACE

WORKDIR $WORKSPACE
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o opssentry  ./main.go

FROM registry-vpc.cn-shenzhen.aliyuncs.com/kuaifu-test/generic:alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache libc6-compat tzdata curl \
&& echo "Asia/Shanghai" > /etc/timezone \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir -p /app/configs

COPY --from=build-env ./opssentry /app/

RUN ls /app/

WORKDIR /app

ENTRYPOINT ["./opssentry"]
