# https://shaneutt.com/blog/rust-fast-small-docker-image-builds/

# --------------------------------------------------------------
# Cargo Build Stage
# --------------------------------------------------------------
FROM rust:latest AS cargo-build

RUN apt update

RUN apt install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/rust-with-docker

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

# RUN cargo build --release

# RUN cargo install --path .

# --------------------------------------------------------------
# Final Stage
# --------------------------------------------------------------
FROM alpine:latest

COPY --from=cargo-build /usr/src/rust-with-docker/target/x86_64-unknown-linux-musl/release/rust-with-docker /usr/local/bin/rust-with-docker

CMD ["rust-with-docker"]
