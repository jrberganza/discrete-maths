# Cifrado con Aritmética Modular 1

## Usage

```
$ ./cifrado
Texto a cifrar: Hola
Clave: 5
Cifrado: iuba
$ ./cifrado
Texto a cifrar: Un texto mas complejo!
Clave: 12
Cifrado: ju xurxr jam xrjdxuar!
```

## Build

Se necesita:
- Zig ≥ 0.9.0 (con un [package manager](https://github.com/ziglang/zig/wiki/Install-Zig-from-a-Package-Manager) o el [sitio oficial](https://ziglang.org/download/))

Compilar con `zig build` y correr con `zig build run` o el binario en `zig-out/bin/`