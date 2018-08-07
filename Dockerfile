FROM alpine:3.5
RUN apk add --no-cache curl tree
WORKDIR /public
COPY . .
RUN ls
RUN ./test.sh
RUN echo "All tests passed!" > index.txt
