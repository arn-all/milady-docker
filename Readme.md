# MILADY Docker

This guide provides a summary of the steps to create, share, and use a custom pre-built Docker image for the MILADY code.

## Build the Docker Image
1. Clone the git repository 

```bash 
./clone_milady.sh
```

2. Build the Docker image using the following command:

```bash
docker build -t milady .
```

This command will compile the MILADY code during the image build process.

3. Run the container with the current directory mounted as a volume:

```bash
docker run --rm -v "$(pwd):/workspace" milady
```


## Push the Docker Image to Docker Hub

1. Create a free account on Docker Hub (https://hub.docker.com/) if you don't have one already.
2. Log in to your Docker Hub account on your machine using the following command:

```bash
docker login
```

3. Tag your local image with your Docker Hub username and a custom name for the image:

```bash
docker tag milady YOUR_DOCKERHUB_USERNAME/milady:latest
```

Replace `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username.

4. Push the tagged image to Docker Hub:

```bash
docker push YOUR_DOCKERHUB_USERNAME/milady:latest
```

## Pull and Run the Docker Image

Other people can now pull and run your custom pre-built image using the following commands:

1. Pull the image from Docker Hub:

```bash
docker pull YOUR_DOCKERHUB_USERNAME/milady:latest
```

2. Run the container with the current directory mounted as a volume without compiling the code:

```bash
docker run --rm -v "$(pwd):/workspace" milady
```

This will allow them to run `milady_main.exe` inside the container with the current directory on the host system mounted as the `/workspace` directory.

## Debugging MILADY in Docker

Interactive mode in Docker allows you to run a container and attach to it, so you can interact with the container's running processes and execute commands inside the container. This is useful for debugging, testing, and exploring the container environment.

To run a Docker container in interactive mode, you use the -it flag along with the docker run command. The -i flag stands for "interactive" and the -t flag stands for "pseudo-tty," which allocates a pseudo-TTY session to the container.

Here's an example of running the MILADY Docker container in interactive mode:

```
docker run -it --rm -v "$(pwd):/workspace" YOUR_DOCKERHUB_USERNAME/milady:latest /bin/bash
```

In this command:

    -it: Enables interactive mode with a pseudo-TTY session.

    --rm: Removes the container automatically when it exits.

    -v "$(pwd):/workspace": Mounts the current directory on the host system as the /workspace directory inside the container.
    YOUR_DOCKERHUB_USERNAME/milady:latest: The Docker image to run.

    /bin/bash: The command to run inside the container, in this case, it starts a new bash shell.

Once you run this command, you will be attached to the container's bash shell, and you can interact with the container by executing commands inside it. To exit the interactive session, simply type exit or press Ctrl + D.
