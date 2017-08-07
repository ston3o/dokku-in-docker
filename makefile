.PHONY: build

build:
	@ docker build -t dokku .

run:
	@ docker run -d --name dokku --privileged -it -p 80 -p 22 dokku
	@ docker start dokku > /dev/null 2>&1 || docker run -d --name dokku --privileged -it -p 80 -p 22 dokku

rm:
	@ docker rm -f dokku

enter:
	@ docker exec -it dokku bash

url:
	@ docker inspect --format 'http://0.0.0.0:{{ (index (index .NetworkSettings.Ports "80/tcp") 0).HostPort }}' dokku

logs:
	@ docker logs -f dokku
