FROM  tarantool/tarantool:2

RUN apk update && apk add gcc musl-dev git
RUN tarantoolctl rocks install http

RUN mkdir -p /var/log/tarantool

WORKDIR /opt/tarantool

ADD . /opt/tarantool

CMD ["/usr/local/bin/tarantool", "app.lua"]
