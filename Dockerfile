FROM public.ecr.aws/nginx/nginx:latest
WORKDIR /usr/share/nginx/html
COPY dist/ .
EXPOSE 80