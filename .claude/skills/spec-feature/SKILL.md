---
name: spec-feature
description: Genera el ciclo spec/plan/tasks de Spec-Driven Development (specs/features/<nombre>/spec.md, plan.md, tasks.md) para una feature del proyecto serverless-order-pipeline-aws. Usar cuando se arranca una feature nueva del roadmap (ej. "spec-feature core-pipeline").
---

# spec-feature

Genera los tres artefactos del ciclo SDD (`spec.md`, `plan.md`, `tasks.md`)
para una feature, en `specs/features/<nombre>/`. Este proyecto sigue SDD
estricto: **no se escribe código de infraestructura hasta que el arquitecto
(el usuario) aprueba explícitamente cada uno de estos tres archivos.**

## Cómo invocarla

`args` es el nombre de la feature en kebab-case (ej. `core-pipeline`,
`api-ingestion`, `diagrams`). Si no se pasa nombre, preguntar al usuario
cuál feature del roadmap corresponde.

## Procedimiento

1. **Cargar contexto del proyecto** antes de escribir nada:
   - Leer `specs/constitution.md` (misión, stack, convenciones) si existe.
   - Leer `specs/roadmap.md` si existe, para ubicar la entrada de esta
     feature y su descripción de alto nivel.
   - Si `specs/features/<nombre>/` ya existe con archivos no vacíos, avisar
     al usuario y confirmar antes de sobrescribir (no pisar trabajo
     existente sin permiso).

2. **Reunir los requisitos de la feature.** La descripción de alto nivel
   suele venir del roadmap o de instrucciones del usuario en la
   conversación actual. Si falta información necesaria para escribir
   criterios de aceptación verificables o decisiones de arquitectura
   (ej. no está claro qué recursos AWS toca, o hay una ambigüedad de
   diseño no trivial) — **STOP y preguntar al usuario**, en línea con la
   regla no negociable #8 del proyecto ("si una instrucción es ambigua,
   STOP y preguntás"). No improvisar decisiones de arquitectura.

3. **Generar `spec.md`** a partir de
   `.claude/skills/spec-feature/templates/spec.md.template`: qué y por qué,
   alcance (incluye/no incluye), requisitos funcionales, criterios de
   aceptación verificables (evitar criterios vagos — deben poder
   chequearse con `terraform plan`, inspección de un archivo, etc.).

4. **Generar `plan.md`** a partir de
   `.claude/skills/spec-feature/templates/plan.md.template`: enfoque
   técnico, tabla de recursos Terraform con el archivo donde vivirán, ADRs
   (obligatorio documentar como ADR cualquier decisión de IAM
   least-privilege, ver regla #4), variables/configuración nueva, cómo se
   valida (siempre `fmt` + `validate` + `plan`, nunca `apply`), riesgos.

5. **Generar `tasks.md`** a partir de
   `.claude/skills/spec-feature/templates/tasks.md.template`: checklist de
   tareas atómicas (una por commit), cada una con su Definition of Done,
   más una sección final de validación de la feature completa.

6. **Reportar y STOP.** Al terminar, resumir en 3-5 líneas qué se generó y
   pedir explícitamente la aprobación del arquitecto antes de que cualquier
   agente empiece a escribir Terraform o código Python para esta feature.
   No pasar a la fase `implement` sin ese OK explícito.

## Convenciones a respetar en el contenido generado

- Español para prosa de specs/plans (coherente con el resto de `specs/`);
  conventional commits en inglés (regla #7 del proyecto — solo aplica a
  mensajes de commit, no a estos documentos).
- IAM: nunca proponer `Resource: "*"`; siempre ARNs scoped a los recursos
  de la feature (regla #4).
- `terraform apply` nunca aparece como tarea a ejecutar por el agente
  (regla #2) — como mucho, una tarea de "dejar comandos preparados para
  que el arquitecto aplique manualmente".
- Nombres de archivos y estructura: `envs/dev/` para el stack, `modules/`
  solo si hay reutilización real y clara — si el plan propone un módulo,
  debe justificar por qué no alcanza con recursos inline en `envs/dev/`.
