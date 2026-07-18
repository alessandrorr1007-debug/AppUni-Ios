# Manual de Distribución iOS - AgendaPx

Este manual detalla los pasos para compilar, firmar y distribuir la aplicación AgendaPx en dispositivos iOS utilizando **TestFlight** de Apple.

---

## 1. Requisitos Previos
- Cuenta de desarrollador de Apple activa (Apple Developer Program).
- Mac con Xcode 15.0 o superior instalado.
- Acceso de Administrador o Gestor de App a App Store Connect.

---

## 2. Compilación y Archivo (Xcode)
1. Abre el proyecto en Xcode.
2. Asegúrate de configurar el **Bundle Identifier** como `com.example.agendapx` y verificar que el perfil de firmas (Provisioning Profile) esté configurado correctamente (se recomienda "Automatically manage signing" durante pruebas).
3. Selecciona el destino de compilación como **Any iOS Device (arm64)**.
4. Ve al menú superior: **Product** > **Archive**.
5. Espera a que termine de compilar. Al finalizar, se abrirá la ventana del **Organizer**.

---

## 3. Envío a App Store Connect
1. En la ventana **Organizer**, selecciona el Archive generado y haz clic en **Distribute App**.
2. Selecciona **TestFlight & App Store** como método de distribución y haz clic en **Next**.
3. Selecciona **Upload** para enviar la compilación a los servidores de Apple.
4. Xcode procesará la app y validará la firma de seguridad. Confirma el envío haciendo clic en **Upload**.
5. Al completarse la subida, la compilación estará disponible para procesamiento en App Store Connect.

---

## 4. Configuración en TestFlight
1. Inicia sesión en [App Store Connect](https://appstoreconnect.apple.com).
2. Ve a **Mis Apps** y selecciona **AgendaPx**.
3. Haz clic en la pestaña **TestFlight** en el menú superior.
4. En el menú de la izquierda, bajo **Grupos Externos**, haz clic en el botón **+** para crear un nuevo grupo de pruebas externo (ej. "Beta General").
5. Una vez creado el grupo:
   - Ve a la sección **Compilaciones** dentro del grupo y añade la compilación que subiste desde Xcode.
   - Ve a la sección **Enlace Público** y haz clic en **Habilitar enlace público**.
   - Opcionalmente, configura el límite de evaluadores (hasta 10,000 usuarios).
6. Copia el enlace público de TestFlight generado (tendrá el formato `https://testflight.apple.com/join/...`).
7. Pega este enlace en el marcador `[LINK_TESTFLIGHT]` del archivo `README.md` principal.

---

## 5. Instalación por parte de los Usuarios
1. Los usuarios deben instalar la app **TestFlight** desde la App Store en sus dispositivos iOS.
2. Hacer clic en el enlace público compartido de la aplicación.
3. Aceptar la invitación y presionar **Instalar** dentro de TestFlight.
