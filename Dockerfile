FROM espressif/idf:latest

ARG DEBIAN_FRONTEND=nointeractive

RUN apt-get update \
  && apt-get install -y -q \
     jq

# QEMU

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV IDF_PYTHON_ENV_PATH=/opt/esp/python_env/idf4.4_py3.8_env

RUN export Q=`curl -s https://api.github.com/repos/espressif/qemu/releases/latest | \
               jq --raw-output '.assets | .[] | .name' | grep xtensa | \
               grep x86_64-linux-gnu | head -n 1`; echo "\n\n" https://github.com/espressif/qemu/releases/latest/download/$Q "\n\n"	

RUN export QEMU_DIST=`curl -s https://api.github.com/repos/espressif/qemu/releases/latest | \
               jq --raw-output '.assets | .[] | .name' | grep xtensa | \
               grep x86_64-linux-gnu | head -n 1`; \
               wget --no-verbose https://github.com/espressif/qemu/releases/latest/download/$QEMU_DIST \
               && tar -xf $QEMU_DIST -C /opt \
               && rm ${QEMU_DIST}

ENV PATH=/opt/qemu/bin:${PATH}

RUN echo $($IDF_PATH/tools/idf_tools.py export) >> $HOME/.bashrc

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
