# Dockerfile for Rails

## Build

```
docker build -t marcbachmann/rails:0.1 .
```

## Run
```
docker run -v /Users/marcbachmann/Development/suitart/tailorart.com:/app -v $GEM_HOME:/gems -m 1000m -i -t suitart-rails:0.1 foreman start
```
