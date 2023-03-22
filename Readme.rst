MILADY Docker
=============

Using Milady
************

Locally, using Docker
---------------------

You can pull and run the pre-built image using the following commands:

1. Pull the image from Docker Hub:

.. code:: bash

   docker pull aallera/milady:latest 

2. Run the container with the current directory mounted as a volume (of
   course without compiling the code):

.. code:: bash

   docker run -it --rm -v "$(pwd):/workspace" aallera/milady

The option ``-it`` enables the interactive mode with a pseudo-TTY
session, allowing to kill the process before it ends (ctrl-C).

Pass extra parameters to mpirun
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Optionally, additional options to ``mpirun`` such as the number of
processors (default is ``-np 4``) can be passed as:

.. code:: bash

   docker run -it --rm -v "$(pwd):/workspace" aallera/milady -np 8

Run an interactive shell in the container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   docker run -it --rm -v "$(pwd):/workspace" aallera/milady shell

On Irene Joliot-Curie (CEA-TGCC) using pcocc
--------------------------------------------

Locally (takes a long time):

.. code:: bash
    
   docker save milady:<tag> | gzip > milady_<tag>.tar.gz

On Irene:

.. code:: bash

   gzip -d milady_latest.tar.gz
   pcocc image import docker-archive:milady_latest.tar milady

Interactive use:

.. code:: bash
   
   # (optional) ccc_mprun  -p skylake -m scratch,work -s
   pcocc run --mount "$(pwd):/workspace" -s -I milady -- -np 16

Submit as a job:

.. code:: bash


   #!/bin/bash
   #MSUB -n 4
   #MSUB -c 8
   #MSUB -q skylake
   #MSUB -T 600
   #MSUB -A <your submission group>
   pcocc run -n ${BRIDGE_MSUB_NPROC}  -I my_docker_image [arg1, ...]

On Jean-Zay (IDRIS) using Singularity
-------------------------------------

1. Start a pre/post session to access a large RAM node (singularity build takes more ram than the standard 5 Go).

.. code:: bash

   srun --pty --nodes=1 -A yxs@cpu --ntasks-per-node=1 --cpus-per-task=10 --partition=prepost --hint=nomultithread --time=01:00:00 bash

2. Build singularity image (.sif)

.. code:: bash

   singularity build milady.sif docker://aallera/milady:1.0.1

3. Add to allowed directory

.. code:: bash

   idrcontmgr cp milady.sif

4. Start a shell, with access to $WORK. Other directories are read-only.

.. code:: bash

   singularity shell $SINGULARITY_ALLOWED_DIR/milady.sif --bind $WORK/:/MLD/work
   
   
Build the Docker Image and push to Docker hub
*********************************************

Build the image
---------------

1. Clone the current repository


2. Clone the milady repository inside it

.. code:: bash

   ./clone_milady.sh

3. Build the Docker image using the following command:

.. code:: bash

   docker build -t milady .

This command will compile the MILADY code during the image build
process.

Push the Docker Image to Docker Hub
-----------------------------------

1. Create a free account on Docker Hub (https://hub.docker.com/) if you
   don’t have one already.
2. Log in to your Docker Hub account on your machine using the following
   command:

.. code:: bash

   docker login

3. Tag your local image with your Docker Hub username and a custom name
   for the image:

.. code:: bash

   docker tag milady YOUR_DOCKERHUB_USERNAME/milady:<tag>

Replace ``YOUR_DOCKERHUB_USERNAME`` with your actual Docker Hub username
and ``<tag>`` with a version.

4. Push the tagged image to Docker Hub:

.. code:: bash

   docker push YOUR_DOCKERHUB_USERNAME/milady:<tag>
