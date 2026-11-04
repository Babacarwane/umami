# Fork whosells d'Umami

Fork de `umami-software/umami`, figé sur le tag **v3.4.1** (`master` = ce tag + les ajouts ci-dessous). Déployé sur Vercel
(projet `umami`, domaine `stats.whosells.xyz`), base : projet Supabase `umami_whosells` (intégration Supabase ↔ Vercel).

## Ajouts au fork (rien d'autre n'est modifié)

- `scripts/vercel-build.sh` et `buildCommand` dans `vercel.json` : construit `DATABASE_URL` et `DIRECT_DATABASE_URL` à
  partir des variables `POSTGRES_URL` et `POSTGRES_URL_NON_POOLING` de l'intégration Supabase (variables sensibles,
  illisibles) avant `npm run build`.
- `src/instrumentation.ts` : même pont `DATABASE_URL` au démarrage du serveur.

À chaque mise à jour d'Umami : synchroniser `master` sur le nouveau tag **en gardant ces fichiers** (ils n'existent pas
dans le dépôt d'origine, donc pas de conflit sauf si `vercel.json` ou `src/instrumentation.ts` apparaissent chez eux).
Procédure complète : `workflows/umami.md` du dépôt Whosells-app.

## Réglages du projet Vercel (hors dépôt)

Node 24.x, région des fonctions `dub1` (Dublin, près de la base en eu-west-1), variables de production : `APP_SECRET`
(sensible), `DISABLE_TELEMETRY=1`, plus celles de l'intégration Supabase (`POSTGRES_*`, `SUPABASE_*`). Protection par
authentification Vercel active sur les adresses `*.vercel.app` ; le domaine `stats.whosells.xyz` est public (il doit
l'être : le script de mesure y est chargé par les visiteurs).
