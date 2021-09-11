# Set the base image to the latest LTS version of Ubuntu
FROM ubuntu:latest

# Set the working directory to /home
WORKDIR /home

# Create an apt configuration file to fix erroneous "hash sum mismatch" errors
RUN printf "Acquire::http::Pipeline-Depth 0;\nAcquire::http::No-Cache true;\nAcquire::BrokenProxy true;" \
	>> /etc/apt/apt.conf.d/99fixbadproxy

# Prevent prompt to include timezone
ENV DEBIAN_FRONTEND="noninteractive"

# Add the necessary packages to compile Elmer/Ice
RUN apt update -o Acquire::CompressionTypes::Order::=gz && apt upgrade -y && apt install -y \
	build-essential cmake git \
	libblas-dev liblapack-dev libmumps-dev libparmetis-dev \
	libnetcdf-dev libnetcdff-dev \
	mpich sudo less vim gmsh \
	python3-numpy python3-scipy  python3-matplotlib  ipython3  \
	python3-virtualenv  python3-dev  python3-pip  python3-sip

# export these paths before a new user is created otherwise, the users .bashrc
# will overwrite these and render this useless. See:
#          (https://stackoverflow.com/questions/28722548/)
ENV PATH=$PATH:/usr/local/Elmer-devel/bin
ENV PATH=$PATH:/usr/local/Elmer-devel/share/elmersolver/lib

# Add a user "glacier" with sudo privileges
ENV USER=glacier
RUN adduser --disabled-password --gecos '' ${USER} \
	&& adduser ${USER} sudo \
	&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER}
ENV HOME=/home/${USER}
WORKDIR ${HOME}

# Add vim syntax highlighting
COPY .vim /home/${USER}/.vim/

# Clone the ElmerIce source code and make directories needed for compilation
RUN git clone git://www.github.com/ElmerCSC/elmerfem -b elmerice elmerice \
	&& mkdir elmerice/builddir \
	&& cd elmerice/builddir

# Run cmake with proper flags
RUN	cmake /home/glacier/elmerice \
		-DCMAKE_INSTALL_PREFIX=/usr/local/Elmer-devel \
		-DCMAKE_C_COMPILER=/usr/bin/gcc \
		-DCMAKE_Fortran_COMPILER=/usr/bin/gfortran \
		-DWITH_OpenMP:BOOLEAN=TRUE -DWITH_MPI:BOOL=TRUE \
		-DWITH_Mumps:BOOL=TRUE -DWITH_LUA:BOOL=TRUE \
		-DWITH_Hypre:BOOL=FALSE -DWITH_Trilinos:BOOL=FALSE \
		-DWITH_ELMERGUI:BOOL=FALSE -DWITH_ElmerIce:BOOL=TRUE

# compile the source code
RUN make && sudo make install
