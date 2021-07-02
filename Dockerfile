FROM alpine:3.7 as base
RUN apk add --no-cache curl bash dash loksh mksh tree zsh build-base nginx

# Compile `oksh` from source
RUN cd /tmp && \
  curl -LfsS https://github.com/ibara/oksh/archive/main.tar.gz | tar xzvf - && \
  cd oksh* && \
  ./configure && make && make install && \
  cd .. && \
  rm -rf oksh*

WORKDIR /usr/src
RUN mkdir -p test/logs /run/nginx
COPY . .

FROM base
RUN sh ./test/test.sh

FROM base
# Really `loksh`
RUN ksh ./test/test.sh

FROM base
RUN oksh ./test/test.sh

FROM base
RUN mksh ./test/test.sh

FROM base
RUN zsh ./test/test.sh

FROM base
RUN dash ./test/test.sh

FROM base
RUN bash ./test/test.sh
