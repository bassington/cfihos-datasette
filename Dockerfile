FROM python:3.11-slim
RUN pip install datasette datasette-cluster-map

WORKDIR /app
COPY cfihos.db.xz /app/cfihos.db.xz
RUN python3 -c "import lzma, shutil; f=lzma.open('/app/cfihos.db.xz'); out=open('/app/cfihos.db','wb'); shutil.copyfileobj(f,out); f.close(); out.close()"
COPY metadata.json /app/metadata.json

EXPOSE 8080
CMD ["datasette", "serve", "cfihos.db", "--metadata", "metadata.json", "--host", "0.0.0.0", "--port", "8080", "--cors", "--setting", "sql_time_limit_ms", "5000", "--setting", "max_returned_rows", "2000", "--setting", "default_page_size", "50"]
