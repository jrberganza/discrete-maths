# Algorítmo de Exponenciación Rápida

## Usage

```
$ ./aer 123 11 65537
44456
$ ./aer 800 25 65537
7464
$ ./aer 45 65 1297
511
```

## Build

Se necesita:
- Zig 0.9.1 (con un [package manager](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager) o el [sitio oficial](https://ziglang.org/download/))

Compilar con `zig build`. Correr con `zig build run -- [arguments]` o con el binario con `./zig-out/bin/aer [arguments]`