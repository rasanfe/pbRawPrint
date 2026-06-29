# pbRawPrint — Imprimir en bruto (RAW) desde PowerBuilder 🖨️

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-2D6CDF?style=flat-square)
![.NET](https://img.shields.io/badge/.NET-10-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![RawPrint](https://img.shields.io/badge/Spooler-RawPrint-00A98F?style=flat-square)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

## 📋 ¿Qué es esto?

Un ejemplo PowerBuilder para **mandar un fichero TAL CUAL a la impresora**: sin diálogos, sin
que el driver lo repinte, sin GDI por medio. Le decís el nombre de la impresora y la ruta del
fichero, y los bytes salen directos por el **spooler de Windows**. Es justo lo que necesitáis para
etiquetas (ZPL/EPL de Zebra), tickets (ESC/POS), o un PDF/PCL ya listo para imprimir.

¿Y cómo lo hace? Aquí está la gracia: PowerBuilder **no sabe** hablar con el spooler a tan bajo
nivel, así que nos apoyamos en .NET. Cargamos una pequeña librería .NET (`RawPrint`) como
`dotnetobject` con el **.NET DLL Importer** de PB. Eso nos genera un objeto proxy,
**`nvo_rawprint`**, que desde PowerScript se instancia y se usa como si fuera nativo. Fijaos en
lo limpio que queda:

```powerscript
nvo_rawprint lnv_print
lnv_print = create nvo_rawprint
// impresora, fichero, ¿entra pausado en la cola?
lnv_print.of_printrawfile("Zebra ZD220", "C:\etiqueta.zpl", false)
```

- **`of_printrawfile(impresora, ruta, pausado)`** → envía el fichero usando su propio nombre en
  la cola.
- **`of_printrawfile(impresora, ruta, nombreDoc, pausado)`** → igual, pero eligiendo el nombre
  que se ve en la cola de impresión.
- **`of_printrawstream(...)`** → la misma idea pero a partir de un *stream* de bytes.

El parámetro `pausado` es muy útil: si lo pones a `true`, el trabajo entra **detenido** en la cola
para que el operario lo revise antes de que salga por la impresora. Y ojo al detalle fino: si el
driver es de tipo **XPS**, la librería cambia sola el *datatype* de `RAW` a `XPS_PASS`, así que
no os tenéis que preocupar de eso.

## 🔗 Motor .NET

El "motor" que hace el trabajo es la librería .NET **`RawPrint`** (clase `RawPrint`), un port a
.NET moderno que habla directamente con la API del spooler de Windows (`OpenPrinter`,
`StartDocPrinter`, `WritePrinter`...):

- Se **despliega** ya compilada en la carpeta `DotNet\RawPrint\` de este propio ejemplo, para que
  clones, compiles y funcione sin tocar nada.
- Se **consume** desde PowerBuilder como `dotnetobject` (el proxy `nvo_rawprint`).
- El **código fuente** vive en `Blog\Net10\RawPrint` (antes estaba en `Net8`) y se
  recompila/despliega con el script **`desplegar_dotnet.bat`** (hace `dotnet publish` y espeja las
  DLLs a la carpeta `DotNet` de cada ejemplo).
- Repo del proyecto .NET (Visual Studio 2022): <https://github.com/rasanfe/RawPrint>

## 🛠️ Requisitos

- **PowerBuilder 2025** para abrir y compilar la solución.
- **.NET 10 Runtime** instalado en la máquina → <https://dotnet.microsoft.com/en-us/download/dotnet/10.0>
- La carpeta `DotNet\RawPrint\` con las DLLs desplegadas (ya viene en el repo).
- Una impresora instalada en Windows (física o virtual) y un fichero acorde a su lenguaje.

## ▶️ Cómo probarlo

1. Clona el repo y abre `pbrawpdf.pbsln` con PowerBuilder 2025.
2. Compila (Full Build) y ejecuta.
3. Elige una impresora, selecciona el fichero a imprimir y lánzalo.
4. Comprueba en la cola de impresión de Windows cómo aparece el trabajo (y prueba la opción de
   enviarlo **pausado** para verlo retenido antes de imprimir).

## 🔗 Repo PowerBuilder

<https://github.com/rasanfe/pbRawPrint>

## 🙌 Créditos

Gracias a **Frogmore Computer Services Ltd**, autor original del proyecto **RawPrint**, sobre el
que se apoya esta librería: <https://github.com/frogmorecs/RawPrint>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
