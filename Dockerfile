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
	build-essential \
	cmake \
	git \
	libblas-dev \
	liblapack-dev \
	libmumps-dev \
	libparmetis-dev \
	mpich \
	sudo \
	less \
	vim \
	gmsh

# Set the path, while the elmer has yet to be installed
# we need to export these paths before a new user is created
# otherwise, the users .bashrc will overwrite these and render
# this useless. See: (https://stackoverflow.com/questions/28722548/)
ENV PATH=$PATH:/usr/local/Elmer-devel/bin
ENV PATH=$PATH:/usr/local/Elmer-devel/share/elmersolver/lib

# Add user
ENV USER=glacier
RUN adduser --disabled-password --gecos '' ${USER} \
	&& adduser ${USER} sudo \
	&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${USER}
ENV HOME=/home/${USER}
WORKDIR ${HOME}

# Clone the ElmerIce source code and compile Elmer/Ice
RUN git clone git://www.github.com/ElmerCSC/elmerfem -b elmerice elmerice \
	&& mkdir elmerice/builddir \
	&& cd elmerice/builddir \
	&& cmake /home/glacier/elmerice \
		-DCMAKE_INSTALL_PREFIX=/usr/local/Elmer-devel \
		-DCMAKE_C_COMPILER=/usr/bin/gcc \
		-DCMAKE_Fortran_COMPILER=/usr/bin/gfortran \
		-DWITH_MPI:BOOL=TRUE -DWITH_Mumps:BOOL=TRUE \
		-DWITH_LUA:BOOL=TRUE \
		-DWITH_Hypre:BOOL=FALSE -DWITH_Trilinos:BOOL=FALSE \
		-DWITH_ELMERGUI:BOOL=FALSE -DWITH_ElmerIce:BOOL=TRUE \
	&& make \
	&& sudo make install #\
	#&& rm -R /home/elmerice
