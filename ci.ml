name: Flask Docker CI/CD

on:
  push:
    branches:
      - main

jobs:
  build-test-push:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"

      - name: Install Dependencies
        run: |
          pip install -r requirements.txt

      - name: Test Flask Application
        run: |
          python -m py_compile app.py

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build Docker Image
        run: |
          docker build -t ${{ secrets.DOCKERHUB_USERNAME }}/ex24-flask-app:latest .

      - name: Push Docker Image
        run: |
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/ex24-flask-app:latest
