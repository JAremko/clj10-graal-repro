FROM clojure:openjdk-11-lein as clojure

COPY ./ /usr/src/app/

RUN cd /usr/src/app && lein uberjar


FROM ubuntu as graalvm

ENV GRAALVM_V=1.0.0-rc12

WORKDIR /tmp

COPY --from=clojure /usr/src/app/target/uberjar/uber.jar ./

RUN apt-get update && apt-get install -y wget gcc libz-dev

RUN wget --quiet https://github.com/oracle/graal/releases/download/vm-${GRAALVM_V}/graalvm-ce-${GRAALVM_V}-linux-amd64.tar.gz \
    && tar -xzf graalvm-ce-${GRAALVM_V}-linux-amd64.tar.gz

RUN graalvm-ce-${GRAALVM_V}/bin/native-image \
    --no-server \
    -H:+ReportUnsupportedElementsAtRuntime \
    -jar /tmp/uber.jar


FROM ubuntu

COPY --from=graalvm /tmp/uber /usr/local/bin

RUN chmod 775 /usr/local/bin/uber

ENTRYPOINT ["/usr/local/bin/uber"]
