## Android

Android está dividido en varios subproyectos, cada uno de los cuales tiene su propio repositorio y se gestiona de manera independiente al resto. El servidor principal donde se almacenan todos los repositorios se encuentra en https://android.googlesource.com/. Cada uno de los proyectos que aparecen es un repositorio Git independiente y alberga el código de una parte de todo el SO Android (por ejemplo, la aplicación de correo). Aunque cada uno de estos repositorios se gestiona de manera independiente (cada repositorio tiene sus propios commits, branches, etc.), para poder compilar y ejecutar el SO Android necesitamos descargar todos los repositorios, ponerlos en un mismo directorio y compilarlos todos a la vez, ya que los diferentes sub-proyectos tienen dependencias entre sí.

## Descargar y compilar fuentes de Android

Tenemos nuestro propio fork de Android llamado Cibernoid. Sin embargo, dado el gran tamaño de Android, no tiene sentido hacer un fork de todo el código fuente de Android. Solamente clonaremos los sub-proyectos de Android relevantes, como por ejemplo, `sdcard`. Todos los demás sub-proyectos, irrelevantes en el contexto de Cibernoid, pero necesarios para compilar Android, los descargaremos desde los repositorios oficiales de Android.

Para descargar las fuentes de todos los sub-proyectos a la vez (ya que de lo contrario no podremos compilar Android) utilizaremos la herramienta repo. Como decía, no todos los sub-proyectos se descargarán del mismo sitio: algunos habrá que obtenerlos de nuestros repositorios en GitHub, y otros (la mayoría) desde los repositorios oficiales. Para esto necesitamos un manifest de repo. Un manifest es básicamente un fichero XML que le indica a repo de dónde tiene que descargar cada uno de los sub-proyectos. Nuestro manifest se encuentra en el repositorio [cibernoid-manifest](https://github.com/Cibernoid/cibernoid-manifest), en el branch android-7.1.2_r33.

### Preparar entorno

Es aconsejable meter las fuentes de Android en un directorio nuevo, asi que lo primero que haremos será crearlo:

```
~$ mkdir android-7-source; cd android-7-source
```

Esta carpeta será nuestro directorio de trabajo, y a partir de ahora nos referiremos a ella así. Este será el directorio “base” o raíz, donde estará todo el proyecto Android organizado en sus diferentes sub-proyectos.

Cuando compilemos Android, más adelante, los binarios se guardarán en una subcarpeta de nuestro directorio de trabajo llamada out. Si queremos que se guarden en otro sitio, tenemos que exportar la variable `OUT_DIR_COMMON_BASE`, asignándole la ruta donde queremos que los binarios de Android se generen.

#### Descargar `repo`

Para descargar todas las fuentes de Android utilizaremos la herramienta `repo`. Tenemos que descargarla de la siguiente manera:

```
wget https://storage.googleapis.com/git-repo-downloads/repo
```

Y le damos permisos de ejecución:

```
chmod u+x ./repo
```

### Descargar fuentes

Ahora toca descargar las fuentes. Tenemos que indicarle a `repo` la ubicación de nuestro manifest para que sepa de dónde descargar los diferentes sub-proyectos. Para ello utilizaremos dos comandos, primero `repo init`, que descargará el manifest y creará una carpeta oculta llamada `.repo` con información interna. Luego utilizaremos `repo sync` para comenzar la descarga de las fuentes. Para más información sobre los comandos de `repo` id a la documentación. Todo el proceso explicado aquí asume que se está utilizando Linux. Aunque para hacer aplicaciones de Android se puede usar cualquier SO, para trabajar con el SO Android propiamente dicho es requisito imprescindible disponer de un sistema Linux o Mac OSX con las herramientas habituales para programadores (gcc, git, etc.). Es la única manera de compilar Android. Google no da ningún tipo de soporte para compilar Android en sistemas que no sean Linux o Mac. Antes de seguir adelante, conviene comprobar que tenemos los [requisitos mínimos para compilar Android](https://source.android.com/setup/build/requirements), y todo el [software necesario](https://source.android.com/setup/build/initializing). Cabe destacar que se necesitan grandes cantidades de disco duro y memoria RAM.

Ejecutamos `repo init` indicándole la ubicación de nuestro manifest.

```
~/android-7-source $ ../repo init \
        -u https://github.com/Cibernoid/cibernoid-manifest.git \
        -b android-7.1.2_r33
```

Con la opción `-u` le estamos diciendo que descargue nuestro propio manifest, desde nuestro repositorio GitHub, y con `-b` le decimos que estamos partiendo del branch `android-7.1.2_r33`, o sea que en vez de descargar las fuentes del branch master, las descargará de android-7.1.2_r33, que es la última versión estable. Nótese que en la consola, estamos ubicados en nuestro directorio de trabajo. Todos los comandos ejecutados a partir de ahora se ejecutarán desde nuestro directorio de trabajo, salvo que se indique lo contrario.

Una vez `repo` haya descargado el manifest, es el momento de descargar las fuentes.

```
../repo sync
```

## Compilar y ejecutar en QEMU

En primer lugar ejecutamos el script `envsetup.sh`, que viene incluido con el código fuente de Android, y ejecutamos la función `set_stuff_for_environment`.

```
. build/envsetup.sh
set_stuff_for_environment
```

Seleccionamos una arquitectura. En este caso x86 con símbolos de depuración incluídos (`eng`). Esto lo hacemos con la función `lunch`.

```
lunch aosp_x86-eng
```

Si ejecutamos `lunch` sin argumentos nos muestra un listado de todas las arquitecturas.

En este punto ya podemos compilar.

```
make -j16
```

Cuando finalize podemos lanzar el Android que acabamos de compilar en QEMU. La función `emulator` configura y lanza QEMU de forma automática.

```
emulator
```

