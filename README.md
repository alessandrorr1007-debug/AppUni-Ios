# AgendaPx iOS

## Descripción
Esta es la versión nativa para **iOS** de la aplicación **AgendaPx**, diseñada con Swift y SwiftUI bajo la arquitectura MVVM. La app consume el mismo backend que provee servicios a las plataformas Web y Android, permitiendo a los estudiantes de UPAO realizar un seguimiento en tiempo real de sus calificaciones, promedios ponderados, alertas de notas y asistencia académica desde dispositivos Apple de forma rápida y eficiente.

---

## Descargar AgendaPx

🍎 **iOS (TestFlight Beta):**
Actualmente la distribución para dispositivos iOS está habilitada mediante Apple TestFlight para pruebas de desarrollo cerradas y abiertas. Puedes unirte al canal de pruebas usando el siguiente enlace:

Enlace TestFlight disponible próximamente.

*Nota: Se requiere tener instalada la aplicación TestFlight de Apple en tu dispositivo antes de acceder al enlace.*

---

## Requisitos
- **Sistema Operativo:** iOS 16.0 o superior.
- **Dispositivos Compatibles:** iPhone (iPhone 8 o superior), iPad, y Macs con procesador Apple Silicon (M1/M2/M3).
- **Conexión de Red:** Conexión a Internet activa para sincronización.

---

## Instalación
1. Descarga e instala la aplicación oficial **TestFlight** desde la App Store en tu dispositivo iOS.
2. Abre el enlace de descarga provisto en la sección superior ([LINK_TESTFLIGHT]) desde tu dispositivo móvil.
3. Se abrirá TestFlight mostrando la invitación para unirse a la beta de **AgendaPx**. Presiona el botón **Aceptar**.
4. Haz clic en **Instalar** para iniciar la descarga y configuración en tu pantalla de inicio.
5. Inicia sesión con tus credenciales institucionales normales.

---

## Documentación de Despliegue
Para más información técnica sobre cómo compilar, firmar la aplicación y habilitar el enlace de TestFlight en App Store Connect, consulta la guía interna:
* [Guía de Distribución iOS](docs/distribucion.md)

---

## Versiones (Release History)

### v1.0.0 (Versión Inicial)
* Configuración base de la arquitectura MVVM con SwiftUI.
* Cliente HTTP asíncrono nativo (`URLSession`) con inyección de JWT Bearer Token.
* Almacenamiento seguro del token de sesión en el Keychain de iOS.
* Pantallas de Login, Resumen (Dashboard), Lista de Cursos, Detalle de Notas (con calculadora de examen final necesario) y control de asistencia.
