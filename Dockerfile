FROM alpine:3.7
RUN apk add --no-cache curl bash dash loksh mksh tree zsh
WORKDIR /public
COPY . .
RUN sh ./test.sh
RUN ksh ./test.sh
RUN mksh ./test.sh
RUN zsh ./test.sh
RUN dash ./test.sh
RUN bash ./test.sh
RUN echo "All tests passed!" > index.txt
