docker run -p 8081:80 kennethreitz/httpbin


docker run -ti -p 8080:8080 -v $PWD/nginx.conf:/etc/nginx/nginx.conf:z nginxinc/nginx-unprivileged