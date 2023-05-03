FROM public.ecr.aws/lambda/python:3.10

# Needed to install dlib.
RUN yum install -y gcc g++ gcc gcc-c++ cmake3 make && \
    yum clean all && \
    pip3 install wheel && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake

COPY requirements.txt  .
RUN  pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
