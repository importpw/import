FROM alpine:3.5
RUN apk add --no-cache curl bash zsh tree
WORKDIR /public
COPY . .
RUN sh --help 2>&1 | head -n1 && sh ./test.sh
RUN zsh --version && zsh ./test.sh
RUN bash --version && bash ./test.sh
RUN echo "All tests passed!" > index.txt
