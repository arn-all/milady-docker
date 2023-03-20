# Use the oneAPI HPC toolkit as the base image
FROM intel/oneapi-hpckit:latest


SHELL ["/bin/bash", "-c"]

# Install the necessary prerequisites
RUN apt-get update && \
    apt-get install -y cmake gfortran gcc python3

RUN ln -s /usr/bin/python3 /usr/bin/python

# RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2 && \
#     mkdir -p ${HOME}/software/openmpi/src && \
#     tar -xf openmpi-4.1.4.tar.bz2 --directory=${HOME}/software/openmpi/src --strip-components 1 && \
#     cd ${HOME}/software/openmpi/src && \

#     # 3. build openmpi
#     # source /opt/intel/oneapi/setvars.sh && \

#     #which ifort && \
#     # if not available :
#     export PATH=/opt/intel/oneapi/compiler/2022.1.0/linux/bin/intel64:/opt/intel/oneapi/compiler/2022.1.0/linux/bin:${PATH} && \

#     ./configure --prefix=${HOME}/software/openmpi/install CC=gcc CXX=g++ F77=ifort FC=ifort --enable-mpi-cxx

# RUN cd ${HOME}/software/openmpi/src && \ 
#     make all install -j8

# ENV PATH=$PATH:$HOME/.local/bin:$HOME/software/openmpi-4.1.4/install/bin \
#     LD_LIBRARY_PATH=$HOME/software/openmpi-4.1.4/install/lib/:/opt/intel/oneapi/compiler/2022.1.0/linux/compiler/lib/intel64_lin/:/opt/intel/oneapi/mkl/2022.1.0/lib/intel64:${LD_LIBRARY_PATH}


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


# Set the default working directory for the container to access host files
WORKDIR /workspace

COPY run.sh /usr/local/bin/run.sh

# Set the entry point for the Docker container to the run_milady.sh script
ENTRYPOINT ["/usr/local/bin/run.sh"]

# Set the default value for the -np option
CMD ["-np", "4"]