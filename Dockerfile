FROM alpine:3 as builder

ENV URL_TSHOCK="https://github.com/Pryaxis/TShock/releases/download/v5.2.0/TShock-5.2-for-Terraria-1.4.4.9-linux-x64-Release.zip"

WORKDIR /app

#RUN apk add --no-cache <pkg>

RUN wget ${URL_TSHOCK} && unzip *.zip && mkdir -p TSHOCK && tar -xvf *.tar -C TSHOCK && ls -la TSHOCK


FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine

LABEL authors="Text-ADI"
LABEL homepage="https://github.com/text-adi"
LABEL repository="https://github.com/text-adi/terraria-tshoks"

WORKDIR /app
EXPOSE 7777

COPY docker-entrypoint.sh .

COPY --from=builder /app/TSHOCK/ .

RUN chmod +x /app/docker-entrypoint.sh

ENV SERVER_PORT=7777
ENV MAX_PLAYERS=8
ENV WORLD_NAME='My server world'
ENV WORLD_SIZE=1

ENTRYPOINT  ["/app/docker-entrypoint.sh"]