import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};
const respond = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status, headers: { ...corsHeaders, 'Content-Type': 'application/json' },
});

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (request.method !== 'POST') return respond({ error: 'Method not allowed' }, 405);

  const url = Deno.env.get('SUPABASE_URL')!;
  const anonKey = Deno.env.get('SUPABASE_PUBLISHABLE_KEY') ?? Deno.env.get('SUPABASE_ANON_KEY')!;
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const authHeader = request.headers.get('Authorization') ?? '';
  const callerClient = createClient(url, anonKey, { global: { headers: { Authorization: authHeader } } });
  const { data: { user }, error: authError } = await callerClient.auth.getUser();
  if (authError || !user) return respond({ error: 'Authentication required' }, 401);

  const admin = createClient(url, serviceKey, { auth: { persistSession: false } });
  const { data: profile } = await admin.from('profiles').select('role').eq('id', user.id).maybeSingle();
  if (profile?.role !== 'admin') return respond({ error: 'Administrator role required' }, 403);

  try {
    const body = await request.json();
    if (body.action !== 'create') return respond({ error: 'Unsupported action' }, 400);
    const email = String(body.email ?? '').trim().toLowerCase();
    const password = String(body.password ?? '');
    const role = body.role === 'admin' ? 'admin' : 'operativo';
    if (!email.includes('@') || password.length < 8) return respond({ error: 'Valid email and password of at least 8 characters are required' }, 400);
    const { data, error } = await admin.auth.admin.createUser({ email, password, email_confirm: true });
    if (error) return respond({ error: error.message }, 400);
    const { error: profileError } = await admin.from('profiles').update({ role }).eq('id', data.user.id);
    if (profileError) {
      await admin.auth.admin.deleteUser(data.user.id);
      return respond({ error: profileError.message }, 500);
    }
    return respond({ id: data.user.id, email: data.user.email, role }, 201);
  } catch (error) {
    return respond({ error: error instanceof Error ? error.message : 'Unexpected error' }, 500);
  }
});
