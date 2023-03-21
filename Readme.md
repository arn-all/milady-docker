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
docker run -it --rm -v "$(pwd):/workspace" aallera/milady
```

The option `-it` enables the interactive mode with a pseudo-TTY session, allowing to kill the process before it ends (ctrl-C).
Optionally, additional options to `mpirun` such as the number of processors (default is `-np 4`) can be passed as:

```bash
docker run -it --rm -v "$(pwd):/workspace" aallera/milady -np 8
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
docker pull aallera/milady:latest 
```

2. Run the container with the current directory mounted as a volume without compiling the code:

```bash
docker run --rm -v "$(pwd):/workspace" aallera/milady
```

This will allow them to run `milady_main.exe` inside the container with the current directory on the host system mounted as the `/workspace` directory.
