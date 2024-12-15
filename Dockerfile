#ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
#ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
#ARG IMAGE=containers.intersystems.com/intersystems/iris:2021.1.0.215.0
#ARG IMAGE=intersystemsdc/irishealth-community
ARG IMAGE=intersystemsdc/iris-community
#ARG IMAGE=intersystemsdc/iris-community:preview
FROM $IMAGE AS final

WORKDIR /home/irisowner/dev

ARG TESTS=0
ARG MODULE="doxygenerate"
ARG NAMESPACE="USER"

ENV IRISUSERNAME="_SYSTEM"
ENV IRISPASSWORD="SYS"
ENV IRISNAMESPACE=$NAMESPACE
ENV PATH="/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

## install doxygen and graphviz
USER root
RUN apt update > /dev/null && \
    apt-get -y install doxygen graphviz > /dev/null
USER ${ISC_PACKAGE_MGRUSER}

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
