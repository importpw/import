FROM alpine:3.7 as base
RUN apk add --no-cache curl bash dash loksh mksh tree zsh
WORKDIR /usr/src
COPY . .

FROM base
RUN sh ./test.sh

FROM base
RUN ksh ./test.sh

FROM base
RUN mksh ./test.sh

FROM base
RUN zsh ./test.sh

FROM base
RUN dash ./test.sh

FROM base
RUN bash ./test.sh

FROM base
WORKDIR /public
RUN echo "All tests passed!" > index.txt
