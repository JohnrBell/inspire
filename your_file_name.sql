--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    descrip text,
    score integer
);


ALTER TABLE public.categories OWNER TO john;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO john;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    parent_category_id integer,
    title character varying(255),
    msg text,
    author character varying(255),
    score integer,
    birth character varying(255),
    death character varying(255),
    url text
);


ALTER TABLE public.posts OWNER TO john;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO john;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: replies; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE replies (
    id integer NOT NULL,
    parent_post_id integer,
    author character varying(255),
    msg text,
    score integer,
    birth character varying(255)
);


ALTER TABLE public.replies OWNER TO john;

--
-- Name: replies_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.replies_id_seq OWNER TO john;

--
-- Name: replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE replies_id_seq OWNED BY replies.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE reservations (
    id integer NOT NULL,
    cust_name character varying(100),
    cust_email character varying(50),
    booked_dates character varying(255),
    room_id integer
);


ALTER TABLE public.reservations OWNER TO john;

--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservations_id_seq OWNER TO john;

--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE reservations_id_seq OWNED BY reservations.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE rooms (
    id integer NOT NULL,
    num character varying(50),
    capacity integer,
    beds integer,
    hbo boolean,
    img text
);


ALTER TABLE public.rooms OWNER TO john;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_id_seq OWNER TO john;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: john; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    parent_post_id integer,
    parent_category_id integer,
    contact_info character varying(255)
);


ALTER TABLE public.subscriptions OWNER TO john;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: john
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO john;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: john
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY replies ALTER COLUMN id SET DEFAULT nextval('replies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY reservations ALTER COLUMN id SET DEFAULT nextval('reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: john
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: john
--

COPY categories (id, name, descrip, score) FROM stdin;
2	Battlestations	[b]Fancy[/b] Computer Setups, pc or mac, home or work.	5
7	Space	photos pertaining to outer space...	1
1	Automotive	Cars, Trucks, Bikes, anything automotive. 	13
3	EDC	Everyday Carry...What you never leave home without...	3
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('categories_id_seq', 12, true);


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: john
--

COPY posts (id, parent_category_id, title, msg, author, score, birth, death, url) FROM stdin;
11	7	Sun	First Image of the Sun from [b]NASA's NuSTAR[/b]	Hector	9	2014-12-25T01:27:30+00:00		http://i.imgur.com/lFqJlPr.jpg
4	1	Mac Roarer	Most gorgeous bike of the last 10 years...	Mr Awesome	5	2014-12-18T07:15:00+00:00		http://i.imgur.com/j2WPOJ6.jpg
14	7	Hurricane Bob	As seen from the [b]ISS[/b]	Angelo	2	2014-12-25T01:55:53+00:00		http://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Hurricane_Bob_19_aug_1991_1226Z.jpg/985px-Hurricane_Bob_19_aug_1991_1226Z.jpg
1	1	Koenigsegg Agera R	The [b]Koenigsegg Agera R[/b] in all it's glory...	John	15	2014-11-18T07:15:00+00:00		http://i.imgur.com/yJvonM2.jpg
6	1	2015 Toyota 4Runner TRD Pro	She looks like a storm trooper...	John	12	2014-12-18T07:15:00+00:00	2014-12-20T07:15:00+00:00	http://i.imgur.com/FTClVHc.jpg
3	2	My new home...	Just moved in, ya dig?	StuTheHacker	4	2014-12-18T07:15:00+00:00		http://i.imgur.com/8fp9W0N.jpg
2	3	My updated EDC...	Never leave home without these..	StuTheHacker	4	2014-12-18T07:15:00+00:00		http://i.imgur.com/fUpX99x.jpg
5	2	Quick snap...	New Poster to fill the blank spot on the wall...	The Stig	3	2014-12-19T07:15:00+00:00		http://i.imgur.com/Gzrw232.jpg
10	1	My new project car.	Just picked up this old Porsche, new moneypit.	Hans	0	2014-12-24T20:18:48+00:00		http://i.imgur.com/o02Phxp.jpg
8	1	Lingenfelter Z06...	When you just want MORE	Chris	1	2014-12-23T17:50:45+00:00	2014-12-24T18:00:00+00:00	http://i.imgur.com/Cjy5eD1.jpg
9	3	New Keychain	I like technology. Can you tell?	Markus	11	2014-12-24T19:30:20+00:00	2015-01-01T01:00:00+00:00	http://i.imgur.com/t9NjA0E.jpg
\.


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('posts_id_seq', 18, true);


--
-- Data for Name: replies; Type: TABLE DATA; Schema: public; Owner: john
--

COPY replies (id, parent_post_id, author, msg, score, birth) FROM stdin;
18	1	Max	Is that a bunker in the background?	2	2014-12-26 18:25:43.543508
15	1	Marcus	I will own one of these one day...	0	2014-12-26 13:11:43.900667
6	1	Mike	Seriously, uni-wiper?	-3	2014-12-23T16:59:34.427810
19	1	Jack	Uni-wiper is [b]AWESOME[/b]	-2	2014-12-26 18:28:34.456252
20	14	Jack	What is this over?	0	2014-12-26 18:33:31.059189
23	3	James	That's a hell of a chair, who makes it?	1	2014-12-27 20:01:32.300045
3	3	Alan Smith	What screensaver is that on the large screen?	3	2014-12-18T09:35:00+00:00
24	3	The Stig	Simplicity is nice	0	2014-12-27 20:01:53.267769
25	4	Walter	I wish all bikes were still this simplistic.	0	2014-12-27 20:02:22.406229
2	2	Alan Smith	Who makes that watch?	2	2014-12-18T09:35:00+00:00
4	1	John	My Goodness...	11	2014-12-19T10:50:00+00:00
26	10	Obin	What year and trim?	8	2014-12-27 20:02:51.205439
8	8	Hank	Thaaaat's alot of tire on those wheels. 	1	2014-12-24 16:13:30.611017
9	9	John	What processor was that?	0	2014-12-24 19:31:17.803515
10	5	Walter	What are the dates on the poster representing?	0	2014-12-24 19:31:52.701205
7	5	Malcom	Is that Ken Block's new mustang as your background?	2	2014-12-23 17:58:09.126557
14	14	The Stig	That's amazing, thanks for sharing!	2	2014-12-25 01:56:13.656986
5	4	Dakota	Love the all black theme	0	2014-12-23T02:33:31.963427
27	10	ivan	Is that the Exxon off the 405?	2	2014-12-27 20:03:12.907359
11	2	Marcus	That's a hefty flask...	1	2014-12-24 21:05:38.897665
28	2	Paul	That zippo looks like it's seen some things....	0	2014-12-27 20:03:40.044166
1	1	Joseph	[b]Best. Car. Ever....[/b] No seriously though, have you looked at the 1:1 model? [b]Crazzzzy[/b]	13	2014-12-19T09:35:00+00:00
16	1	Craig	Thanks for the new wallpaper	3	2014-12-26 17:48:37.461062
17	1	Austin	Are those carbon fiber wheels?	0	2014-12-26 18:25:04.948070
29	14	Walter	Wow, that shadow on the lower edge is amazing	1	2014-12-27 20:04:22.673916
30	11	John	We're so tiny!	0	2014-12-27 20:04:44.953555
13	11	Mike	Looks [b]lovely...[/b]	1	2014-12-25 01:27:51.036893
31	5	John	What model monitors do you have there?	0	2014-12-27 20:05:19.858844
21	9	Mike	Intel?	2	2014-12-26 18:48:47.770238
32	9	Larry	Looks like an intel to me!	1	2014-12-27 20:05:39.362360
33	9	Larry	Tell me that was dead before you put the hole in it!	-1	2014-12-27 20:06:07.267328
\.


--
-- Name: replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('replies_id_seq', 33, true);


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: john
--

COPY reservations (id, cust_name, cust_email, booked_dates, room_id) FROM stdin;
\.


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('reservations_id_seq', 1, false);


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: john
--

COPY rooms (id, num, capacity, beds, hbo, img) FROM stdin;
\.


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('rooms_id_seq', 1, false);


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: john
--

COPY subscriptions (id, parent_post_id, parent_category_id, contact_info) FROM stdin;
1	\N	1	johnrbell@gmail.com
2	1	\N	+18484591420
4	\N	2	+18484591420
3	10	\N	johnrbell@gmail.com
6	0	0	johnrbell@gmail.com
5	0	0	blah@blah.com
\.


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: john
--

SELECT pg_catalog.setval('subscriptions_id_seq', 6, true);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: replies_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY replies
    ADD CONSTRAINT replies_pkey PRIMARY KEY (id);


--
-- Name: reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: john; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: john
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM john;
GRANT ALL ON SCHEMA public TO john;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

