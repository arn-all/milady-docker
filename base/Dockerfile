########### USAGE ##########
# Run milady in current directory
#
# with 4 cpus (default)
#docker run -it --rm -v "$(pwd):/workspace" milady 
#
# with 8 cpus (-np 8)
#docker run -it --rm -v "$(pwd):/workspace" milady -np 8

# Run jupyter in the container:
#
# docker run -it -p 8888:8888  milady shell
#
# (or, to expose the current directory):
# docker run -it -p 8888:8888  -v "$(pwd):/workspace" milady shell 
#
# To start jupyter:
# notebook
############################

# Use the oneAPI HPC toolkit as the base image
FROM intel/oneapi-hpckit:2023.0.0-devel-ubuntu22.04

SHELL ["/bin/bash", "-c"]

# Install the necessary prerequisites
RUN apt-get update && \
    apt-get install -y cmake gcc gfortran python3 python3-pip 

RUN ln -s /usr/bin/python3 /usr/bin/python

# Set the working directory for the MILADY repository
WORKDIR /MLD

# Copy the MILADY repository
COPY MLD/MILADY /MLD/MILADY

# Set environment variables
ENV MLD_ROODIR=/MLD \
    MLD_SRCDIR=/MLD/MILADY \
    MLD_BUIDIR=/MLD/mld_build \
    MLD_INSDIR=/MLD/mld_install \
    MLD_TESDIR=/MLD/mld_testdir \
    MLD_SETENV=ON \
    MKL_ROOT=/opt/intel/oneapi/mkl/latest \
    I_MPI_ROOT=/opt/intel/oneapi/mpi/latest \
    PATH=/MLD/MILADY/scripts:/opt/intel/oneapi/mpi/latest/bin:$PATH \
    OMP_INSDIR=/opt/intel/oneapi/mpi/latest \
    OMP_ROOT=/opt/intel/oneapi/mpi/latest \
    LD_LIBRARY_PATH=/opt/intel/oneapi/mpi/latest/lib:$LD_LIBRARY_PATH\
    LD_LIBRARY_PATH=/opt/intel/oneapi/mpi/latest/include:$LD_LIBRARY_PATH \
    LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin/:$LD_LIBRARY_PATH \
    LD_LIBRARY_PATH=/opt/intel/oneapi/mkl/latest/lib/intel64:$LD_LIBRARY_PATH

# Compile the code using the MILADY-MIX mode
RUN source ${MLD_SRCDIR}/scripts/compile_milady.bash && \
    f_setenv_milady && \
    cd ${MLD_SRCDIR} && \
    f_compile_milady_intel && \
    f_compile_milady && \
    make -j 4 

# Install python dependencies
COPY requirements.txt /MLD/requirements.txt
RUN pip install -r /MLD/requirements.txt --no-cache-dir

# Set the default working directory for the container to access host files
WORKDIR /workspace

# Expose port 8888 for jupyter
EXPOSE 8888

# Provide executables
COPY run.sh     /usr/local/bin/run.sh
COPY milady.sh  /usr/local/bin/milady
COPY jupyter.sh /usr/local/bin/notebook

# Set the entry point for the Docker container to the run.sh script
# Default : start milady here
# possible argument(s): 
#         shell : start a shell in the container
ENTRYPOINT ["/usr/local/bin/run.sh"]

# Set the default value for the -np option
CMD ["-np", "4"]
