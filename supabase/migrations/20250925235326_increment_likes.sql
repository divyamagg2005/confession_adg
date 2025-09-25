/*
  # RPC: increment_likes

  Creates an atomic like incrementer for confessions to avoid race conditions.

  Usage from client:
    const { data, error } = await supabase.rpc('increment_likes', { confession_id: <id> });
    // data is an array with one updated row (the confession)
*/

-- Create or replace function to atomically increment likes
create or replace function public.increment_likes(confession_id bigint)
returns setof public.confessions
language sql
-- Use SECURITY INVOKER to respect RLS policies defined on the table
security invoker
set search_path = public
as $$
  update public.confessions
  set likes = coalesce(likes, 0) + 1
  where id = confession_id
  returning *;
$$;

-- Permissions: allow anon and authenticated to execute the function
revoke all on function public.increment_likes(bigint) from public;
grant execute on function public.increment_likes(bigint) to anon, authenticated;
