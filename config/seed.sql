CREATE TABLE public.users
(
    id serial PRIMARY KEY NOT NULL,
    username varchar(255) NOT NULL,
    encrypted_pw varchar(255) NOT NULL
);
CREATE UNIQUE INDEX users_id_uindex ON public.users (id);

