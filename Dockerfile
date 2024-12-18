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

## install doxygen and graphviz for core functionality
## install texlive-latex-base and texlive-latex-extra for pdf generation
USER root
RUN apt update > /dev/null && \
    apt-get -y install doxygen graphviz > /dev/null
RUN apt-get -y install texlive-latex-base texlive-latex-extra > /dev/null
USER ${ISC_PACKAGE_MGRUSER}

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
