# Runtime configuration mapping (documentation only)

No GCP commands executed and no cloud resources needed.

| Local input | Cloud Run equivalent |
| --- | --- |
| Nonsecret DATABASE_URL placeholder and LOG_LEVEL via --env-file .env | --set-env-vars DATABASE_URL=postgres://classroom.invalid:5432/demo,LOG_LEVEL=info |
| API_KEY passed by name from exported shell variable with -e API_KEY | --set-secrets API_KEY=classroom-api-key:1 referencing Secret Manager |

These are flag fragments, not commands to run. A real database URL containing credentials is a secret, not ordinary configuration. Never copy credentials into --set-env-vars. Cloud Run service identity (runtime service account) needs roles/secretmanager.secretAccessor on the referenced secret, ideally scoped to that secret only. Deployer needs permission to configure the service and act as its runtime service account; deployer identity is not runtime identity. Do not create or commit service-account key files. Prefer workload identity with short-lived credentials for automation, not long-lived JSON keys. Inbound invoker permissions are separate from the workload's secret-access permission.

Docker reads --env-file and shell values when a container is created. Editing .env or restarting an existing container does not replace its configured environment: remove/recreate with the same image for configuration-only changes. Changing the Dockerfile requires a rebuild and then recreation. Cloud Run config changes produce a new revision; changing configuration alone does not require an image rebuild. Secret env variables are resolved at instance startup. With pinned version :1, select a new version and deploy a new revision for rotation; do not promise a running process automatically receives changed values.

## Safety and evidence limits

The starter's super-secret-key is a planted dummy, not a real credential. This solution uses only classroom placeholders. Runtime environment injection avoids baking a value into the image, but is not a secret vault: Docker administrators can inspect container environments. Do not dump full printenv, full container environment inspection, or image history into evidence. Use targeted nonsecret checks and boolean presence checks instead. Exporting a value from a shell avoids embedding its literal in the Docker command, but is not a complete security boundary. Never enable shell tracing with real secrets.

An ignored .env is not encrypted, and ignore rules do not untrack already committed files. A real leaked credential must be revoked/rotated; deleting a line does not erase Git history or previously distributed images. No real credential is needed for this exercise.

The app checks only that DATABASE_URL is nonempty. It does not connect to a database and does not use or validate API_KEY. A healthy response proves local HTTP startup, not database connectivity or key validity. App source is unchanged. Node 18 is end-of-life and retained only to keep this exercise focused; this is not a production image recommendation.

References: https://cloud.google.com/run/docs/configuring/services/environment-variables and https://cloud.google.com/run/docs/configuring/services/secrets
