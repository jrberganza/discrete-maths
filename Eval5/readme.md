# Algorítmo Extendido de Euclides

## Usage

```
$ ./aee 123 65537
14919
$ ./aee 14919 65537
123
$ ./aee 378 1297
923
```

## Build

Se necesita:
- Zig 0.9.1 (con un [package manager](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager) o el [sitio oficial](https://ziglang.org/download/))

Compilar con `zig build`. Correr con `zig build run -- [arguments]` o con el binario con `./zig-out/bin/aee [arguments]`