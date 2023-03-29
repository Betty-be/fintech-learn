FROM continuumio/miniconda3:4.3.27

RUN rm /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian/ jessie main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian/ jessie main" | tee -a /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until false;" | tee -a /etc/apt/apt.conf.d/10-nocheckvalid
RUN echo 'Package: *\nPin: origin "archive.debian.org"\nPin-Priority: 500' | tee -a /etc/apt/preferences.d/10-archive-pin
RUN apt-get update

RUN mkdir /FinMindProject
COPY . /FinMindProject/
WORKDIR /FinMindProject/

# install package
RUN pip install --upgrade pip
# RUN pip install pipenv && pipenv sync

RUN pip install pipenv
RUN pipenv install

# genenv
RUN VERSION=RELEASE python genenv.py

# 預設執行的指令
CMD ["pipenv", "run", "uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8888"]