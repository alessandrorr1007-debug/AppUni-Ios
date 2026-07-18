# AgendaPx iOS Application

Este directorio contiene el proyecto para la versión nativa de iOS de la aplicación **AgendaPx**, que consume la API del backend de UPAO PX.

## Tecnologías Utilizadas
- **Swift 5.10+**
- **SwiftUI** (Framework declarativo de UI)
- **Swift Concurrency** (async/await)
- **URLSession** (Networking nativo)
- **Keychain Services API** (Almacenamiento seguro del token JWT)

## Estructura del Proyecto Propuesta
```
AgendaPx/
├── AgendaPxApp.swift         # Punto de entrada
├── Assets.xcassets           # Paletas de colores e iconos
├── Core/
│   ├── Network/              # Cliente API y peticiones HTTP
│   └── Storage/              # Almacenamiento seguro (Keychain)
├── Models/
│   ├── Course.swift          # Modelos de Notas y Cursos
│   ├── Attendance.swift      # Modelos de Asistencia
│   └── Alert.swift           # Modelos de Alertas
├── ViewModels/
│   ├── LoginViewModel.swift
│   ├── SummaryViewModel.swift
│   └── CourseDetailViewModel.swift
└── Views/
    ├── Login/
    │   └── LoginView.swift
    ├── Main/
    │   └── MainTabView.swift
    ├── Summary/
    │   └── SummaryView.swift
    ├── Courses/
    │   ├── CourseListView.swift
    │   └── CourseDetailModal.swift
    └── Attendance/
        └── AttendanceView.swift
```

## Configuración de Conexión
La aplicación lee la URL base del backend desde un archivo de configuración o variables de entorno. 
Por defecto se conecta al backend local en `http://localhost:3000` o al servidor en producción `https://upao-px-backend.onrender.com`.

## Autenticación
El flujo utiliza autenticación JWT mediante la cabecera:
`Authorization: Bearer <token>`
obtenido tras el inicio de sesión exitoso en `/auth/login`.
