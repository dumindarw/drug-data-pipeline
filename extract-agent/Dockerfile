FROM python:3

WORKDIR /usr/src/app

CMD mkdir /usr/src/app/files

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./main.py" ]