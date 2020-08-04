FROM ubuntu:18.04 as build

COPY ton-node /tonlabs/ton-node/

# install deps
ENV TZ=Europe/Moscow
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN apt-get update && apt-get install -y curl gnupg2 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    gpg \
    tar \
    cmake \
    build-essential \
    pkg-config \
    libssl-dev \
    libtool \
    m4 \
    automake \
    clang \
    git

# rdkafka from confluent's repo
RUN curl https://packages.confluent.io/deb/5.5/archive.key | apt-key add;\
    echo "deb [arch=amd64] https://packages.confluent.io/deb/5.5 stable main" >> /etc/apt/sources.list;\
    apt-get update;\
    apt-get install -y librdkafka-dev;

# Get Rust
COPY rust_install.sh /tmp/rust_install.sh
RUN bash -c "/tmp/rust_install.sh 1.43.1"

WORKDIR /tonlabs/ton-node
RUN cargo build --release --features "external_db,metrics"

FROM ubuntu:18.04 as build2

RUN apt-get update && apt-get install -y curl gnupg2
RUN curl https://packages.confluent.io/deb/5.5/archive.key | apt-key add
RUN echo "deb [arch=amd64] https://packages.confluent.io/deb/5.5 stable main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    librdkafka1 \
    build-essential \
    cmake \
    git \
    gdb \
    gpg \
    tar \
    vim \
    tcpdump \
    netcat \
    python3 \
    python3-pip

# Get Rust
COPY rust_install.sh /tmp/rust_install.sh
RUN bash -c "/tmp/rust_install.sh 1.43.1"

COPY --from=build /tonlabs/ton-node/target/release/ton_node /ton-node/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
