FROM alpine:3.7 as base
RUN apk add --no-cache curl bash dash loksh mksh tree zsh build-base

# Compile `oksh` from source
RUN cd /tmp && \
  curl -LfsS https://github.com/ibara/oksh/archive/master.tar.gz | tar xzvf - && \
  cd oksh* && \
  ./configure && make && make install && \
  cd .. && \
  rm -rf oksh*

WORKDIR /usr/src
COPY . .

FROM base
RUN sh ./test.sh

FROM base
# Really `loksh`
RUN ksh ./test.sh

FROM base
RUN oksh ./test.sh

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
