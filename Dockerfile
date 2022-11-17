FROM golang:1.19.1-buster as go-target
RUN apt-get update && apt-get install -y wget
ADD . /mp3cat
WORKDIR /mp3cat
RUN go build
RUN mkdir ./corpus
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/icy_sfx.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/id3_png_test.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/id3_test.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/midstream_config_change.mp3
RUN mv *.mp3 ./corpus/

FROM golang:1.19.1-buster
COPY --from=go-target /mp3cat/mp3cat /
COPY --from=go-target /mp3cat/corpus/*.mp3 /testsuite/

ENTRYPOINT []
CMD ["/mp3cat", "@@"]
