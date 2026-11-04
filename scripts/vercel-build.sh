#!/bin/sh
# Fork whosells : pont entre les variables de l'intégration Supabase ↔ Vercel (POSTGRES_URL, POSTGRES_URL_NON_POOLING,
# variables « sensibles » que personne ne peut relire) et celles d'Umami (DATABASE_URL, DIRECT_DATABASE_URL).
# DATABASE_URL = pooler Supabase (transaction, port 6543), sans le paramètre « supa » et avec uselibpqcompat=true :
# sans lui, node-postgres vérifie la chaîne de certificats complète et refuse le certificat du pooler Supabase.
# DIRECT_DATABASE_URL = connexion pour les migrations Prisma (lancées par scripts/check-db.js pendant le build).
# Le même pont existe au démarrage du serveur : src/instrumentation.ts. Une variable déjà définie à la main l'emporte.
set -e

if [ -z "$DATABASE_URL" ] && [ -n "$POSTGRES_URL" ]; then
  DATABASE_URL="$(node -e "const u=new URL(process.env.POSTGRES_URL);u.searchParams.delete('supa');if(!u.searchParams.has('uselibpqcompat'))u.searchParams.set('uselibpqcompat','true');process.stdout.write(u.toString())")"
  export DATABASE_URL
fi

if [ -z "$DIRECT_DATABASE_URL" ] && [ -n "$POSTGRES_URL_NON_POOLING" ]; then
  DIRECT_DATABASE_URL="$POSTGRES_URL_NON_POOLING"
  export DIRECT_DATABASE_URL
fi

exec npm run build
