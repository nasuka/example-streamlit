FROM python:3.12

RUN apt-get update

RUN python -m pip install --upgrade pip setuptools wheel --no-warn-script-location
RUN curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash \
    && export PATH="/root/.rye/shims:$PATH" \
    && rye config --set-bool behavior.global-python=true

ENV PATH="/root/.rye/shims:${PATH}"
WORKDIR /app
COPY ./pyproject.toml /app/pyproject.toml
COPY ./requirements.lock ./requirements-dev.lock /app/
COPY . .
RUN rye sync --no-dev

ENV PYTHONPATH=/app
CMD rye run streamlit run src/main.py --server.port 8550

RUN mkdir -p /root/.streamlit
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN mkdir -p /root/.streamlit
RUN bash -c 'echo -e "\
[general]\n\
email = \"\"\n\
" > /root/.streamlit/credentials.toml'

RUN bash -c 'echo -e "\
[server]\n\
enableCORS = false\n\
" > /root/.streamlit/config.toml'
