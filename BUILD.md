docker buildx build . -t wokalek/nginx-brotli:1.27.1 --progress=plain &> build.log

docker tag wokalek/nginx-brotli:1.27.1 wokalek/nginx-brotli:1.27.1
docker tag wokalek/nginx-brotli:1.27.1 wokalek/nginx-brotli:latest

docker push wokalek/nginx-brotli:1.27.1
docker push wokalek/nginx-brotli:latest

docker tag wokalek/nginx-brotli:1.27.1 ghcr.io/wokalek/nginx-brotli:1.27.1
docker tag wokalek/nginx-brotli:latest ghcr.io/wokalek/nginx-brotli:latest

docker login ghcr.io

docker push ghcr.io/wokalek/nginx-brotli:1.27.1
docker push ghcr.io/wokalek/nginx-brotli:latest
