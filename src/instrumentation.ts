// Fork whosells : au démarrage du serveur, construit DATABASE_URL à partir de POSTGRES_URL (intégration Supabase ↔ Vercel)
// quand elle n'est pas définie. Voir scripts/vercel-build.sh pour le même pont pendant le build et pour l'explication.
export function register() {
  if (process.env.NEXT_RUNTIME !== 'nodejs') return;
  if (process.env.DATABASE_URL || !process.env.POSTGRES_URL) return;

  const url = new URL(process.env.POSTGRES_URL);
  url.searchParams.delete('supa');
  if (!url.searchParams.has('uselibpqcompat')) url.searchParams.set('uselibpqcompat', 'true');
  process.env.DATABASE_URL = url.toString();
}
