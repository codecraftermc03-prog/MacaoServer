FROM barichello/godot-ci:4.2.1

WORKDIR /app
COPY . /app

EXPOSE 8080
CMD ["godot", "--headless", "--script", "server.gd"]