# Use the oneAPI HPC toolkit as the base image
FROM intel/oneapi-hpckit:latest


SHELL ["/bin/bash", "-c"]

# Install the necessary prerequisites
RUN apt-get update && \
    apt-get install -y cmake gfortran gcc python3

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


# Set the default working directory for the container to access host files
WORKDIR /workspace

COPY run.sh /usr/local/bin/run.sh

# Set the entry point for the Docker container to the run_milady.sh script
ENTRYPOINT ["/usr/local/bin/run.sh"]

# Set the default value for the -np option
CMD ["-np", "4"]
