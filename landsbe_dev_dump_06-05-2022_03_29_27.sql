--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE landsbe;




--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0 (Debian 12.0-2.pgdg100+1)
-- Dumped by pg_dump version 12.0 (Debian 12.0-2.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "landsbe" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0 (Debian 12.0-2.pgdg100+1)
-- Dumped by pg_dump version 12.0 (Debian 12.0-2.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: landsbe; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE landsbe WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE landsbe OWNER TO postgres;

\connect landsbe

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: approved_stat; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.approved_stat AS ENUM (
    'approved',
    'rejected',
    'pending'
);


ALTER TYPE public.approved_stat OWNER TO postgres;

--
-- Name: source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.source AS ENUM (
    'internally',
    'outsourced'
);


ALTER TYPE public.source OWNER TO postgres;

--
-- Name: massive_document_inserted(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.massive_document_inserted() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ BEGIN NEW.search = to_tsvector(NEW.body::text); RETURN NEW; END; $$;


ALTER FUNCTION public.massive_document_inserted() OWNER TO postgres;

--
-- Name: massive_document_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.massive_document_updated() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ BEGIN NEW.updated_at = now(); NEW.search = to_tsvector(NEW.body::text); RETURN NEW; END; $$;


ALTER FUNCTION public.massive_document_updated() OWNER TO postgres;

--
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      NEW.datetime_modified = NOW();
      RETURN NEW;
    END;
    $$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    announcement_id integer NOT NULL,
    message character varying,
    redirect character varying,
    status boolean DEFAULT false
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.announcements_announcement_id_seq OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_announcement_id_seq OWNED BY public.announcements.announcement_id;


--
-- Name: bidders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bidders (
    bid_id uuid,
    bidder_id uuid,
    bid_price double precision,
    bid_stock integer,
    bid_status public.approved_stat DEFAULT 'pending'::public.approved_stat,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    bid_description character varying,
    fulfillment_days integer,
    bid_in_stock boolean DEFAULT true,
    bid_size_chart character varying,
    bid_size_variants text[],
    bid_delivery_timeframe character varying
);


ALTER TABLE public.bidders OWNER TO postgres;

--
-- Name: bidding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bidding (
    bid_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product uuid,
    active_status boolean DEFAULT true,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    bid_deadline timestamp without time zone,
    group_id uuid,
    temp_price double precision,
    preferred_seller character varying,
    preferred_seller_email character varying
);


ALTER TABLE public.bidding OWNER TO postgres;

--
-- Name: blogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blogs (
    blog_uuid uuid DEFAULT public.uuid_generate_v4(),
    title character varying,
    image character varying,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    read_time character varying,
    author_name character varying,
    author_image character varying,
    "position" integer,
    content character varying,
    summary character varying
);


ALTER TABLE public.blogs OWNER TO postgres;

--
-- Name: crawler_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crawler_queue (
    crawler_id integer NOT NULL,
    status character varying,
    product_id uuid,
    results character varying
);


ALTER TABLE public.crawler_queue OWNER TO postgres;

--
-- Name: crawler_queue_crawler_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crawler_queue_crawler_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crawler_queue_crawler_id_seq OWNER TO postgres;

--
-- Name: crawler_queue_crawler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crawler_queue_crawler_id_seq OWNED BY public.crawler_queue.crawler_id;


--
-- Name: email_management; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_management (
    id integer NOT NULL,
    name character varying,
    template_id integer
);


ALTER TABLE public.email_management OWNER TO postgres;

--
-- Name: email_management_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_management_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_management_id_seq OWNER TO postgres;

--
-- Name: email_management_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_management_id_seq OWNED BY public.email_management.id;


--
-- Name: email_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_template (
    id integer NOT NULL,
    template_name character varying,
    template_json character varying,
    template_html character varying
);


ALTER TABLE public.email_template OWNER TO postgres;

--
-- Name: email_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_template_id_seq OWNER TO postgres;

--
-- Name: email_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_template_id_seq OWNED BY public.email_template.id;


--
-- Name: faq_editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faq_editor (
    faq_id integer NOT NULL,
    question character varying,
    description character varying,
    type character varying
);


ALTER TABLE public.faq_editor OWNER TO postgres;

--
-- Name: faq_editor_faq_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faq_editor_faq_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faq_editor_faq_id_seq OWNER TO postgres;

--
-- Name: faq_editor_faq_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faq_editor_faq_id_seq OWNED BY public.faq_editor.faq_id;


--
-- Name: feature_group_editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_group_editor (
    feat_id integer NOT NULL,
    group_id character varying
);


ALTER TABLE public.feature_group_editor OWNER TO postgres;

--
-- Name: feature_group_editor_feat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feature_group_editor_feat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_group_editor_feat_id_seq OWNER TO postgres;

--
-- Name: feature_group_editor_feat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feature_group_editor_feat_id_seq OWNED BY public.feature_group_editor.feat_id;


--
-- Name: form_group_tutorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.form_group_tutorial (
    id integer NOT NULL,
    step integer,
    text character varying
);


ALTER TABLE public.form_group_tutorial OWNER TO postgres;

--
-- Name: form_group_tutorial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.form_group_tutorial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_group_tutorial_id_seq OWNER TO postgres;

--
-- Name: form_group_tutorial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.form_group_tutorial_id_seq OWNED BY public.form_group_tutorial.id;


--
-- Name: group_insights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_insights (
    insight_uuid uuid DEFAULT public.uuid_generate_v4(),
    group_id uuid,
    user_id uuid,
    insight character varying,
    rating integer DEFAULT 0,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now()
);


ALTER TABLE public.group_insights OWNER TO postgres;

--
-- Name: group_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_members (
    group_id uuid,
    user_id uuid,
    update_only boolean,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    qty integer DEFAULT 0,
    size_variant character varying
);


ALTER TABLE public.group_members OWNER TO postgres;

--
-- Name: group_notification_counter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_notification_counter (
    group_id uuid,
    sevendaysleft integer DEFAULT 0,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE public.group_notification_counter OWNER TO postgres;

--
-- Name: group_suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_suggestions (
    suggestion_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    proposer_id uuid,
    status public.approved_stat DEFAULT 'pending'::public.approved_stat,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    suggested_price character varying,
    srp double precision,
    product uuid,
    group_size integer DEFAULT 50,
    price_deadline integer DEFAULT 30,
    anonymous boolean DEFAULT false,
    preferred_seller character varying,
    preferred_seller_email character varying
);


ALTER TABLE public.group_suggestions OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    group_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    group_name character varying NOT NULL,
    supplier_id uuid,
    active boolean DEFAULT true,
    ready_for_checkout boolean DEFAULT false,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    price double precision,
    group_deadline timestamp without time zone,
    product_id uuid,
    slots integer DEFAULT 50,
    formed_by character varying,
    proposer_id character varying,
    anonymous boolean DEFAULT false,
    margin_pct double precision,
    ended boolean DEFAULT false,
    private boolean DEFAULT false,
    size_variants text[],
    date_closed timestamp without time zone,
    closed boolean DEFAULT false,
    delivery_timeframe character varying,
    in_stock boolean DEFAULT true
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: homepage_edit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.homepage_edit (
    id integer NOT NULL,
    place character varying,
    text character varying,
    image character varying
);


ALTER TABLE public.homepage_edit OWNER TO postgres;

--
-- Name: homepage_edit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.homepage_edit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.homepage_edit_id_seq OWNER TO postgres;

--
-- Name: homepage_edit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.homepage_edit_id_seq OWNED BY public.homepage_edit.id;


--
-- Name: how_it_works; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.how_it_works (
    id integer NOT NULL,
    place character varying,
    text character varying,
    image character varying,
    type character varying
);


ALTER TABLE public.how_it_works OWNER TO postgres;

--
-- Name: how_it_works_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.how_it_works_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.how_it_works_id_seq OWNER TO postgres;

--
-- Name: how_it_works_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.how_it_works_id_seq OWNED BY public.how_it_works.id;


--
-- Name: invited_sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invited_sellers (
    id integer NOT NULL,
    invited_site_url character varying,
    invited_site_email character varying,
    status boolean,
    tags character varying[]
);


ALTER TABLE public.invited_sellers OWNER TO postgres;

--
-- Name: invited_sellers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invited_sellers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invited_sellers_id_seq OWNER TO postgres;

--
-- Name: invited_sellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invited_sellers_id_seq OWNED BY public.invited_sellers.id;


--
-- Name: legalities_editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.legalities_editor (
    l_id integer NOT NULL,
    place character varying,
    text character varying,
    type character varying
);


ALTER TABLE public.legalities_editor OWNER TO postgres;

--
-- Name: legalities_editor_l_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.legalities_editor_l_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.legalities_editor_l_id_seq OWNER TO postgres;

--
-- Name: legalities_editor_l_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.legalities_editor_l_id_seq OWNED BY public.legalities_editor.l_id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    notification_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    action character varying,
    message character varying,
    read boolean DEFAULT false,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    redirect character varying DEFAULT '#'::character varying,
    group_uuid character varying,
    user_uuid uuid,
    notif_type character varying,
    triggered_by uuid
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_template (
    id integer NOT NULL,
    notif_name character varying,
    notif_message character varying,
    notif_image character varying,
    notif_subject character varying,
    notif_receiver character varying
);


ALTER TABLE public.notification_template OWNER TO postgres;

--
-- Name: notification_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_template_id_seq OWNER TO postgres;

--
-- Name: notification_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_template_id_seq OWNED BY public.notification_template.id;


--
-- Name: payouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payouts (
    payout_uuid uuid DEFAULT public.uuid_generate_v4(),
    group_id uuid,
    status character varying,
    date_created timestamp without time zone,
    date_completed timestamp without time zone,
    reference_number character varying,
    payout_amount character varying,
    payout_notes character varying,
    third_party_fees character varying[]
);


ALTER TABLE public.payouts OWNER TO postgres;

--
-- Name: popup_editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.popup_editor (
    pop_id integer NOT NULL,
    text character varying,
    type character varying,
    title character varying
);


ALTER TABLE public.popup_editor OWNER TO postgres;

--
-- Name: popup_editor_pop_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.popup_editor_pop_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.popup_editor_pop_id_seq OWNER TO postgres;

--
-- Name: popup_editor_pop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.popup_editor_pop_id_seq OWNED BY public.popup_editor.pop_id;


--
-- Name: private_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.private_groups (
    id integer NOT NULL,
    group_id uuid,
    user_id uuid,
    status character varying,
    invitation_code character varying
);


ALTER TABLE public.private_groups OWNER TO postgres;

--
-- Name: private_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.private_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.private_groups_id_seq OWNER TO postgres;

--
-- Name: private_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.private_groups_id_seq OWNED BY public.private_groups.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    category_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_name character varying NOT NULL,
    category_image character varying,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now()
);


ALTER TABLE public.product_categories OWNER TO postgres;

--
-- Name: product_suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_suggestions (
    prod_suggestion_uuid uuid DEFAULT public.uuid_generate_v4(),
    name character varying,
    brand character varying,
    model character varying,
    image character varying,
    proposer uuid,
    suggestion_type character varying,
    tags character varying[],
    description character varying,
    slots integer,
    price double precision,
    deadline timestamp without time zone,
    link character varying,
    retail_price double precision,
    preferred_seller character varying,
    preferred_seller_email character varying,
    fulfillment_details character varying,
    deadline_days integer,
    private boolean DEFAULT false,
    size_variants text[],
    created_at timestamp without time zone DEFAULT now(),
    size_chart character varying,
    in_stock boolean DEFAULT true,
    delivery_timeframe character varying
);


ALTER TABLE public.product_suggestions OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product_name character varying NOT NULL,
    product_image character varying,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    product_image1 character varying,
    product_image2 character varying,
    product_category uuid,
    seller_id uuid,
    product_description character varying,
    tags character varying[],
    brand character varying,
    model character varying,
    retail_price double precision,
    price character varying,
    active_product boolean DEFAULT true,
    size_variants text[],
    size_chart character varying
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: promo_editor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promo_editor (
    promo_id integer NOT NULL,
    text character varying,
    type character varying,
    title character varying
);


ALTER TABLE public.promo_editor OWNER TO postgres;

--
-- Name: promo_editor_promo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promo_editor_promo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promo_editor_promo_id_seq OWNER TO postgres;

--
-- Name: promo_editor_promo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promo_editor_promo_id_seq OWNED BY public.promo_editor.promo_id;


--
-- Name: rejected_sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rejected_sellers (
    rs_id integer NOT NULL,
    reason character varying,
    seller_obj character varying
);


ALTER TABLE public.rejected_sellers OWNER TO postgres;

--
-- Name: rejected_sellers_rs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rejected_sellers_rs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rejected_sellers_rs_id_seq OWNER TO postgres;

--
-- Name: rejected_sellers_rs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rejected_sellers_rs_id_seq OWNED BY public.rejected_sellers.rs_id;


--
-- Name: seller_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seller_details (
    seller_id uuid,
    entity_name character varying,
    ein character varying,
    business_experience character varying,
    product_to_sell character varying,
    platforms character varying,
    product_fulfillment public.source,
    status public.approved_stat DEFAULT 'pending'::public.approved_stat,
    margin_pct double precision,
    contact_name character varying,
    email character varying,
    phone_number character varying,
    seller_rating double precision,
    paypal_id character varying,
    stripe_id character varying,
    fulfillment_partner character varying,
    account_name character varying,
    account_number character varying,
    routing_number character varying,
    date_created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.seller_details OWNER TO postgres;

--
-- Name: seller_feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seller_feedback (
    seller_feedback_id integer NOT NULL,
    group_id uuid,
    fname character varying,
    lname character varying,
    email character varying,
    archived boolean DEFAULT false,
    description character varying
);


ALTER TABLE public.seller_feedback OWNER TO postgres;

--
-- Name: seller_feedback_seller_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seller_feedback_seller_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seller_feedback_seller_feedback_id_seq OWNER TO postgres;

--
-- Name: seller_feedback_seller_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seller_feedback_seller_feedback_id_seq OWNED BY public.seller_feedback.seller_feedback_id;


--
-- Name: shipping_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_address (
    shipping_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_uuid uuid,
    country character varying,
    reciever_name character varying,
    address character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    phonenumber character varying,
    primary_shipping_address boolean DEFAULT false,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now()
);


ALTER TABLE public.shipping_address OWNER TO postgres;

--
-- Name: site_feedbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_feedbacks (
    feedback_id integer NOT NULL,
    feedback_type character varying,
    description character varying,
    fname character varying,
    lname character varying,
    email character varying,
    archived boolean DEFAULT false,
    action_taken character varying
);


ALTER TABLE public.site_feedbacks OWNER TO postgres;

--
-- Name: site_feedbacks_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.site_feedbacks_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_feedbacks_feedback_id_seq OWNER TO postgres;

--
-- Name: site_feedbacks_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.site_feedbacks_feedback_id_seq OWNED BY public.site_feedbacks.feedback_id;


--
-- Name: tax; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax (
    tax_uuid uuid DEFAULT public.uuid_generate_v4(),
    state character varying,
    zip_code character varying NOT NULL,
    tax_rate double precision NOT NULL,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tax OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id uuid DEFAULT public.uuid_generate_v4(),
    user_id uuid,
    group_id uuid,
    payment_type character varying DEFAULT ''::character varying,
    status character varying,
    ref_id character varying,
    shipping_address_id uuid,
    tracking_number character varying,
    qty integer,
    tax_rate character varying,
    date_created timestamp without time zone DEFAULT now(),
    ship_date timestamp without time zone,
    shipping_method character varying,
    date_delivered timestamp without time zone,
    buyer_notes character varying,
    size_variant character varying,
    capture_status character varying
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: user_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_activity (
    id integer NOT NULL,
    group_id uuid,
    user_id uuid,
    action character varying,
    description character varying,
    date_and_time timestamp without time zone,
    reason character varying
);


ALTER TABLE public.user_activity OWNER TO postgres;

--
-- Name: user_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_activity_id_seq OWNER TO postgres;

--
-- Name: user_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_activity_id_seq OWNED BY public.user_activity.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id uuid,
    supplier boolean DEFAULT false,
    admin boolean DEFAULT false,
    super_user boolean DEFAULT false,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_subscription; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_subscription (
    user_id uuid,
    new_group boolean DEFAULT false,
    followed_group boolean DEFAULT false,
    related_group boolean DEFAULT false,
    request_group_updated boolean DEFAULT false,
    recommended_group boolean DEFAULT false,
    joined_group boolean DEFAULT false,
    group_requested boolean DEFAULT false,
    group_ending boolean DEFAULT false
);


ALTER TABLE public.user_subscription OWNER TO postgres;

--
-- Name: userpaymentinfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userpaymentinfo (
    paymentinfo_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    type character varying,
    details character varying,
    datetime_created timestamp without time zone,
    datetime_modified timestamp without time zone,
    stripe_customer_id character varying
);


ALTER TABLE public.userpaymentinfo OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    password character varying,
    email character varying NOT NULL,
    primary_address character varying,
    secondary_address character varying,
    google_id character varying,
    datetime_created timestamp without time zone DEFAULT now(),
    datetime_modified timestamp without time zone DEFAULT now(),
    user_image character varying,
    email_settings character varying,
    privacy_settings character varying,
    username character varying,
    temp_password character varying,
    acc_status boolean,
    facebook_id character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: website_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.website_settings (
    id integer NOT NULL,
    showwebsite boolean
);


ALTER TABLE public.website_settings OWNER TO postgres;

--
-- Name: website_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.website_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.website_settings_id_seq OWNER TO postgres;

--
-- Name: website_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.website_settings_id_seq OWNED BY public.website_settings.id;


--
-- Name: announcements announcement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN announcement_id SET DEFAULT nextval('public.announcements_announcement_id_seq'::regclass);


--
-- Name: crawler_queue crawler_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawler_queue ALTER COLUMN crawler_id SET DEFAULT nextval('public.crawler_queue_crawler_id_seq'::regclass);


--
-- Name: email_management id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_management ALTER COLUMN id SET DEFAULT nextval('public.email_management_id_seq'::regclass);


--
-- Name: email_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_template ALTER COLUMN id SET DEFAULT nextval('public.email_template_id_seq'::regclass);


--
-- Name: faq_editor faq_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq_editor ALTER COLUMN faq_id SET DEFAULT nextval('public.faq_editor_faq_id_seq'::regclass);


--
-- Name: feature_group_editor feat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_group_editor ALTER COLUMN feat_id SET DEFAULT nextval('public.feature_group_editor_feat_id_seq'::regclass);


--
-- Name: form_group_tutorial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_group_tutorial ALTER COLUMN id SET DEFAULT nextval('public.form_group_tutorial_id_seq'::regclass);


--
-- Name: homepage_edit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homepage_edit ALTER COLUMN id SET DEFAULT nextval('public.homepage_edit_id_seq'::regclass);


--
-- Name: how_it_works id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.how_it_works ALTER COLUMN id SET DEFAULT nextval('public.how_it_works_id_seq'::regclass);


--
-- Name: invited_sellers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invited_sellers ALTER COLUMN id SET DEFAULT nextval('public.invited_sellers_id_seq'::regclass);


--
-- Name: legalities_editor l_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legalities_editor ALTER COLUMN l_id SET DEFAULT nextval('public.legalities_editor_l_id_seq'::regclass);


--
-- Name: notification_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_template ALTER COLUMN id SET DEFAULT nextval('public.notification_template_id_seq'::regclass);


--
-- Name: popup_editor pop_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.popup_editor ALTER COLUMN pop_id SET DEFAULT nextval('public.popup_editor_pop_id_seq'::regclass);


--
-- Name: private_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_groups ALTER COLUMN id SET DEFAULT nextval('public.private_groups_id_seq'::regclass);


--
-- Name: promo_editor promo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_editor ALTER COLUMN promo_id SET DEFAULT nextval('public.promo_editor_promo_id_seq'::regclass);


--
-- Name: rejected_sellers rs_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rejected_sellers ALTER COLUMN rs_id SET DEFAULT nextval('public.rejected_sellers_rs_id_seq'::regclass);


--
-- Name: seller_feedback seller_feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_feedback ALTER COLUMN seller_feedback_id SET DEFAULT nextval('public.seller_feedback_seller_feedback_id_seq'::regclass);


--
-- Name: site_feedbacks feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_feedbacks ALTER COLUMN feedback_id SET DEFAULT nextval('public.site_feedbacks_feedback_id_seq'::regclass);


--
-- Name: user_activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity ALTER COLUMN id SET DEFAULT nextval('public.user_activity_id_seq'::regclass);


--
-- Name: website_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_settings ALTER COLUMN id SET DEFAULT nextval('public.website_settings_id_seq'::regclass);


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (announcement_id, message, redirect, status) FROM stdin;
1	Welcome to Landsbe!!!	/	t
\.


--
-- Data for Name: bidders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bidders (bid_id, bidder_id, bid_price, bid_stock, bid_status, datetime_created, datetime_modified, bid_description, fulfillment_days, bid_in_stock, bid_size_chart, bid_size_variants, bid_delivery_timeframe) FROM stdin;
\.


--
-- Data for Name: bidding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bidding (bid_uuid, product, active_status, datetime_created, datetime_modified, bid_deadline, group_id, temp_price, preferred_seller, preferred_seller_email) FROM stdin;
a4a226c7-7687-4b03-be36-8e548aa9c7ee	e5b625a1-058e-4ed7-9c17-9546ee953078	t	2021-11-25 02:14:28.178873	2021-11-25 02:14:28.178873	2021-12-10 08:59:59	39ed0dd2-5583-410b-ab87-f1b94ac7e864	100	\N	\N
b99ce5fa-0ae6-40f2-8a08-e2978d18aa9f	d090f8f1-89fe-49be-b1d8-d49ff5dedfd3	t	2021-11-26 02:26:59.736875	2021-11-26 02:26:59.736875	2021-12-25 19:26:58	ffeab45a-6598-4ea9-ab66-f8669e6789bc	1	\N	\N
d83c4613-002c-4dac-9c41-08e2f35dccd7	bcab40f4-f303-4d76-9081-c20ac241c6a2	t	2021-12-10 05:14:35.895885	2021-12-10 05:14:35.895885	2022-01-08 22:14:35	64d16f21-7709-4097-986f-43cc951b24e3	1	\N	\N
fef91719-5f54-4ee6-b756-fdb7a95f8705	eff8b235-ecd2-4123-8cad-317d7fcc2641	t	2021-12-10 05:21:17.588702	2021-12-10 05:21:17.588702	2022-01-08 22:21:16	c17ed577-61ee-4a89-a53d-aca696579c70	1	\N	\N
809df363-62b8-47af-abf2-bf96ae77e31c	fd9289f9-4e48-4dea-bb62-6863a556780c	t	2021-12-10 05:35:02.344139	2021-12-10 05:35:02.344139	2022-01-08 22:35:01	4edebef1-0e36-4562-8477-2d233b2c49aa	50	\N	\N
4c2d5839-2fa1-47ab-9b38-92547cc1dedb	6395b33e-0ea8-43f5-afae-a2939c20d1d5	t	2021-12-10 05:48:51.963852	2021-12-10 05:48:51.963852	2022-01-08 22:48:51	493964a2-3c01-49a9-8f06-7438eb8dd53f	1	\N	\N
53d8e2e8-21ba-4dc8-8f35-32fc70f57457	03bad356-71fc-4517-a907-542b06a0cac3	t	2021-12-17 06:37:59.952051	2021-12-17 06:37:59.952051	2022-01-16 08:59:59	1a8a6062-32ee-48d0-b122-24bc8a3dfda8	1	\N	\N
067a3ad4-4eff-413d-8657-5b40606674c0	e6852be3-522d-42a7-af78-d3a7c4899acc	t	2021-12-23 06:41:09.129456	2021-12-23 06:41:09.129456	2022-01-21 23:41:08	60873237-4c79-43bb-aa03-dd2dfb6ad55a	9	\N	\N
86a2df3c-85fe-4af5-b9e8-9c0b8ea43404	50cf79f5-e72f-45ad-9c6e-eb01080c343a	t	2021-12-23 06:50:39.302868	2021-12-23 06:50:39.302868	2022-01-22 08:59:59	786f3d4b-7c93-4c02-9627-6906cd4e53da	75	\N	\N
8daf7547-bb91-4370-a487-18af63eda26b	2bf7d30f-c2df-4ae0-9863-7f154e28b550	t	2021-12-23 06:51:54.447419	2021-12-23 06:51:54.447419	2022-01-22 08:59:59	a21ca74c-0f77-40b1-ba67-d086de641f73	1	\N	\N
f7f2d0de-81a9-44e6-b31f-91e1d327978b	ffb103c7-fd32-406e-bda8-5bfe0cc01919	t	2022-01-07 05:47:16.965696	2022-01-07 05:47:16.965696	2022-02-05 22:47:16	60181685-b4b7-4bab-b0a3-431648ea5fb9	368	\N	\N
c37ff91b-83f2-44bb-a807-40632c8d3850	66be9259-cea3-48f4-aeb9-2353cabf297c	t	2022-01-07 05:49:32.77393	2022-01-07 05:49:32.77393	2022-02-05 22:49:32	3949b32d-7c71-4f57-91f0-2ddf97e86007	1	\N	\N
a8fda54b-b3d8-483f-8282-51b50dfeb217	e04728f4-eebf-439d-9c4b-63b7fbf4e384	t	2022-03-01 08:55:31.288526	2022-03-01 08:55:31.288526	2022-03-31 09:59:59	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	10	\N	\N
af743a76-5a4d-4236-985e-b5aa40d5418a	72d2ada9-ad21-4fb8-b4e4-ad16f64dab5a	t	2022-03-03 06:08:49.771997	2022-03-03 06:08:49.771997	2022-04-02 09:59:59	ac93d3c3-3628-4014-b0c7-12a68629ce30	10	\N	\N
3beccdfa-df7b-46b7-9556-9b40a18f8289	d00dd8df-d033-4a04-a0f6-22521d73df7d	t	2022-03-03 08:49:48.097195	2022-03-03 08:49:48.097195	2022-04-02 09:59:59	58d841e3-cd1c-433a-a239-924ea22d0b7d	10	\N	\N
c52bc925-ff08-43e0-b5ec-81ff318146aa	e04728f4-eebf-439d-9c4b-63b7fbf4e384	t	2022-03-09 08:18:13.173393	2022-03-09 08:18:13.173393	2022-04-08 02:18:12	daeaf235-ad9f-4bcb-901f-15f6af6e1904	9	\N	\N
6d38e242-b3c4-4021-b28f-c0056c3d9ba3	61227adb-77ae-42e7-97c6-5419beac227f	t	2022-03-09 08:29:24.485602	2022-03-09 08:29:24.485602	2022-04-08 02:29:23	894a997f-eb11-4dec-982a-f0066c64323d	51.99	\N	\N
592a56a7-c130-4731-a42b-fd0b014a97d4	f40e8dce-7f7b-442b-b3cb-e450bef6e0fc	t	2022-03-17 05:11:05.838576	2022-03-17 05:11:05.838576	2022-04-16 09:59:59	f6a2c267-ec63-4acc-b6ab-22274c80ef21	16	\N	\N
\.


--
-- Data for Name: blogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blogs (blog_uuid, title, image, datetime_created, datetime_modified, read_time, author_name, author_image, "position", content, summary) FROM stdin;
fa976807-42a0-42f7-a6cc-9900b9adad74	TEST	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/Capture.PNG	2022-03-15 05:34:44.871875	2022-03-15 05:36:22.910732	< 1 min	\N	\N	1	<p></p>\n	TEST
a8dd7d63-0de2-4ff2-8d0e-4c578f8b0b1a	About landsbe	https://images.unsplash.com/photo-1483347756197-71ef80e95f73?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80	2021-06-29 09:53:55.189606	2021-10-04 02:16:13.293398	3 min	\N	\N	0	<h2><strong>What is Landsbe? </strong></h2>\n<p>We are all part of a global village. Each day this village becomes smaller. We have more information at our fingertips than at any point in history.&nbsp;</p>\n<p>We are as connected as we ever have been and more conscious of how our decisions impact the world around us.&nbsp;</p>\n<p>We are smart consumers, socially connected and aware of how our consumer habits form who we are and leave a footprint on the world around us.&nbsp;</p>\n<p>Landsbe is a community, a community of connected conscientious consumers that work together to deliver value for each other.&nbsp;</p>\n<p>Landsbe is an (online platform) website where members come together to organize their collective buying power.&nbsp;</p>\n<p>Landsbe is an app that enables members of the community to interact and create buying groups.&nbsp;</p>\n<p>Landsbe is the evolution of e-commerce. It connects large groups of consumers around a single product to leverage their collective buying power and drive down the cost to the consumer while increasing or maintaining the suppliers margins.&nbsp;</p>\n<p>Landsbe allows the consumers to tell companies what they want, how they want it and for what price. Landsbe pulls products into the market.&nbsp;</p>\n<p>Landsbe is the ultimate consumer advocate. It places the needs of the consumer first. It never sells out to a supplier at the cost of protecting the consumer.&nbsp;</p>\n<p>Landsbe delivers a compelling and convenient process for its members to make their purchases. Landsbe is a true marriage of e-commerce and s-commerce bringing socially connected consumers together in it’s next step of evolution, g-commerce (group commerce).</p>\n	Landsbe is a community where friends, neighbors and just about anyone can connect to find great deals on the products they love. Landsbe is here to help you organize, share and save money.
\.


--
-- Data for Name: crawler_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crawler_queue (crawler_id, status, product_id, results) FROM stdin;
2	true	12d1306a-02c4-46d1-a138-6a153f5fd1d6	[{"site_name":"www.larsonjewelers.com","email":"service@larsonjewelers.com"},{"site_name":"www.theclassycottage.com","email":"info@theclassycottage.com"},{"site_name":"www.discoverbooks.com","email":"customer_service@discoverbooks.com"},{"site_name":"www.shoppeapparel.com","email":"support@shoppeapparel.zendesk.com"},{"site_name":"www.bluefly.com","email":"flyrep@bluefly.com"},{"site_name":"kavesquare.com","email":"support@kavesquare.com"},{"site_name":"wikishirt.org","email":"contact@wikishirt.org"}]
3	true	5b040d23-a445-4697-9caa-5a36edc35f69	[{"site_name":"www.larsonjewelers.com","email":"service@larsonjewelers.com"},{"site_name":"www.theclassycottage.com","email":"info@theclassycottage.com"}]
8	true	39e7fb30-91e9-4b5a-a41d-64ec8d2cd81f	[]
142	true	8e36c653-ba38-47ef-ab10-2c17c25f925d	[{"site_name":"www.quietpc.com","email":"jannine@quietpc.com"},{"site_name":"tecisoft.com","email":"info@tecisoft.com"},{"site_name":"www.serversupply.com","email":"chaz@serversupply.com"},{"site_name":"www.officespecialties.com","email":"sales@officespecialties.com"},{"site_name":"serverevolution.com","email":"hi@serverevolution.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"www.allhdd.com","email":"support@allhdd.com"},{"site_name":"www.servers4less.com","email":"sales@servers4less.com"}]
144	true	babd52a4-e59e-428c-a294-c3787d5a21f0	[{"site_name":"www.ozziecollectables.com","email":"support@ozziecollectables.com.au"}]
145	true	5b040d23-a445-4697-9caa-5a36edc35f69	[]
150	true	0f85b11a-ed86-4140-ab76-b7e082814b61	[]
158	true	6395b33e-0ea8-43f5-afae-a2939c20d1d5	[{"site_name":"www.sears.com","email":"bitshopusa@gmail.com"}]
159	true	03bad356-71fc-4517-a907-542b06a0cac3	[]
11	true	eff8b235-ecd2-4123-8cad-317d7fcc2641	[{"site_name":"kol.deals","email":"support@kol.dealsPhone"},{"site_name":"www.sears.com","email":"support@kharidleonline.com"},{"site_name":"goodfindtoys.com","email":"support@goodfindtoys.com"},{"site_name":"www.massgenie.com","email":"customerservice@massgenie.com"},{"site_name":"bigboxoutletstore.ca","email":"ecommerce@bigboxoutletstore.ca"},{"site_name":"toy2000.com","email":"info@toy2000.com"},{"site_name":"www.tigerdirect.com","email":"customerservice@tigerdirect.com"},{"site_name":"memoryclearance.com","email":"support@memoryclearance.com"},{"site_name":"www.tamayatech.com","email":"Sales@TamayaTech.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
168	true	72d2ada9-ad21-4fb8-b4e4-ad16f64dab5a	[]
173	true	f40e8dce-7f7b-442b-b3cb-e450bef6e0fc	[null]
169	true	1ae3c3f4-fba8-4c13-8fd7-aaf847071d20	[]
162	true	50cf79f5-e72f-45ad-9c6e-eb01080c343a	[{"site_name":"optfly.com","email":"help@optfly.com"},{"site_name":"www.lyst.com","email":"press@lyst.com"},{"site_name":"boutiquetrip.com","email":"support@boutiquetrip.com"},{"site_name":"www.h-brands.com","email":"customer@h-brands.com"},{"site_name":"alabamaoutdoors.com","email":"CustomerService@aloutdoors.com"},{"site_name":"www.baltini.com","email":"returns@baltini.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.pro-distributing.com","email":"info@pro-distributing.com"},{"site_name":"www.playerschoicevideogames.com","email":"sales@playerschoicevideogames.com"},{"site_name":"www.curlyt.com","email":"curlyt.sale@outlook.com"},{"site_name":"enjify.com","email":"info@enjify.com"},{"site_name":"peacocky.us","email":"support@peacocky.us"},{"site_name":"www.adorama.com","email":"info@adorama.com"},{"site_name":"vltox.com","email":"Contact@vltox.com"},{"site_name":"www.eneba.com","email":"jobs@eneba.com"},{"site_name":"japan-figure.com","email":"info@japan-figure.com"},{"site_name":"nsteck.com","email":"hello@nsteck.com"},{"site_name":"detec.in","email":"sales@detec.in"},{"site_name":"www.luxskinsofficial.com","email":"sales@luxskinsofficial.com"},{"site_name":"boxwoodboards.com","email":"customerservice@boxwoodboards.com"},null]
4	true	f996d137-50bd-467a-bfd7-d68d8941d801	[{"site_name":"www.larsonjewelers.com","email":"service@larsonjewelers.com"},{"site_name":"www.theclassycottage.com","email":"info@theclassycottage.com"}]
5	true	f996d137-50bd-467a-bfd7-d68d8941d801	[{"site_name":"www.larsonjewelers.com","email":"service@larsonjewelers.com"},{"site_name":"www.theclassycottage.com","email":"info@theclassycottage.com"}]
10	true	fd9289f9-4e48-4dea-bb62-6863a556780c	[{"site_name":"goodfindtoys.com","email":"support@goodfindtoys.com"},{"site_name":"www.massgenie.com","email":"customerservice@massgenie.com"},{"site_name":"bigboxoutletstore.ca","email":"ecommerce@bigboxoutletstore.ca"},{"site_name":"toy2000.com","email":"info@toy2000.com"}]
9	true	e6852be3-522d-42a7-af78-d3a7c4899acc	[{"site_name":"www.shopbop.com","email":"service@shopbop.com"},{"site_name":"www.sunnysports.com","email":"custserv@sunnysports.com"},{"site_name":"www.zappos.com","email":"warranty@support.zappos.com"},{"site_name":"www.campsaver.com","email":"contact@campsaver.com"},{"site_name":"bonibi.com","email":"Support@Bonibi.com"},{"site_name":"varuste.net","email":"info@varuste.net"},{"site_name":"wooki.com","email":"atinfo@wooki.com"},{"site_name":"gotoverstock.com","email":"admin@gotoverstock.com"},{"site_name":"www.sportsridge.com","email":"mona@sportsridge.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
141	true	5b2b15cc-b3b4-4423-b672-f562c0fa65cb	[]
12	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"thestore.com","email":"support@thestore.com"}]
13	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"thestore.com","email":"support@thestore.com"}]
14	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
15	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
17	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
73	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"}]
16	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
1	true	8d928ab5-ab49-4673-9cb4-d3c5fa4a9ca5	[]
6	true	6395b33e-0ea8-43f5-afae-a2939c20d1d5	[]
18	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
19	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
20	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
24	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
23	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
25	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
22	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
21	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
27	true	\N	[{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
28	true	\N	[{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
26	true	\N	[{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
29	true	\N	[{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
31	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
30	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
32	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
33	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
39	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
41	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
38	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
42	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
37	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
36	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
44	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
43	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
35	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
40	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
34	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
46	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
45	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
47	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
48	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
50	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
49	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
52	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
51	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
56	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
55	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
54	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
53	true	\N	[{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
57	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
58	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
60	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.adorama.com","email":"info@adorama.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
61	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.adorama.com","email":"info@adorama.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
59	true	7f7fe93c-914b-42df-a455-4db0073a5a00	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.adorama.com","email":"info@adorama.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
63	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
62	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
65	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
64	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
68	true	\N	[{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"}]
67	true	\N	[{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"}]
66	true	\N	[{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"}]
69	true	\N	[{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"}]
70	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
71	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
72	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
75	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
76	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
74	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
77	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
79	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.tanga.com","email":"support@tanga.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
78	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.tanga.com","email":"support@tanga.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
81	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
80	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
82	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"}]
84	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
83	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
86	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
85	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
88	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
87	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
89	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
90	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
91	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
92	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
94	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
93	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
96	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
95	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
97	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
98	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
100	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
99	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
101	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
102	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
103	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
104	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
105	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
106	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
107	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
108	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
109	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
110	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
111	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
112	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
113	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"}]
115	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
114	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"}]
116	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"}]
117	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"}]
119	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"}]
118	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"}]
121	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
120	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
122	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
123	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"buy.smartphonesplus.com","email":"support@smartphonesplus.com"}]
125	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
124	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.worldwidevoltage.com","email":"info@WorldWideVoltage.com"},{"site_name":"www.phonedaddy.com","email":"support@phonedaddy.com"},{"site_name":"glyde.com","email":"service@glyde.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"}]
126	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"}]
127	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"the-hidden-mountains.com","email":"thehiddenmountains@yahoo.com"}]
140	true	12d1306a-02c4-46d1-a138-6a153f5fd1d6	[{"site_name":"www.deploydepot.ca","email":"info@deploydepot.ca"},{"site_name":"dealmatch.ca","email":"management@dealmatch.ca"},{"site_name":"www.electronicsflip.com","email":"support@electronicsflip.com"},{"site_name":"tecisoft.com","email":"info@tecisoft.com"},{"site_name":"www.tigerdirect.com","email":"customerservice@tigerdirect.com"},{"site_name":"store.hermanmiller.com","email":"hmstore@hermanmiller.com"},{"site_name":"www.harveycreations.com","email":"info@harveycreations.com"}]
128	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
129	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"}]
132	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"www.sears.com","email":"cssears@focuscamera.com"}]
130	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"www.sears.com","email":"cssears@focuscamera.com"}]
131	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"www.sears.com","email":"cssears@focuscamera.com"}]
133	true	\N	[{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"www.sears.com","email":"cssears@focuscamera.com"}]
134	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
135	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
136	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
139	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"}]
138	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"wamatek.com","email":"support@Wamatek.com"}]
143	true	d090f8f1-89fe-49be-b1d8-d49ff5dedfd3	[{"site_name":"www.allhdd.com","email":"support@allhdd.com"},{"site_name":"www.quietpc.com","email":"jannine@quietpc.com"},{"site_name":"tecisoft.com","email":"info@tecisoft.com"},{"site_name":"www.serversupply.com","email":"chaz@serversupply.com"},{"site_name":"www.officespecialties.com","email":"sales@officespecialties.com"},{"site_name":"serverevolution.com","email":"hi@serverevolution.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"www.servers4less.com","email":"sales@servers4less.com"},{"site_name":"www.govgroup.com","email":"sales@govgroup.com"},{"site_name":"www.mercadomagico.com","email":"sales@mercadomagico.com"}]
146	true	bcab40f4-f303-4d76-9081-c20ac241c6a2	[{"site_name":"techforgeek.com","email":"info@techforgeek.com"},{"site_name":"nextsolutionitalia.it","email":"contact@pec.nextsolutionitalia.it"},{"site_name":"www.tigerdirect.com","email":"support@intel.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"},{"site_name":"techinstrument.com","email":"info@techinstrument.com"},{"site_name":"magicmicro.com","email":"support@magicmicro.com"},{"site_name":"www.hdvisionworks.com","email":"hdvisionw@gmail.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.sears.com","email":"bitshopusa@gmail.com"},{"site_name":"www.onlogic.com","email":"info@onlogic.com"}]
147	true	eff8b235-ecd2-4123-8cad-317d7fcc2641	[{"site_name":"www.sears.com","email":"bitshopusa@gmail.com"},{"site_name":"www.tamayatech.com","email":"Sales@TamayaTech.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"},{"site_name":"techinstrument.com","email":"info@techinstrument.com"},{"site_name":"techforgeek.com","email":"info@techforgeek.com"},{"site_name":"nextsolutionitalia.it","email":"clienti@nextsolutionitalia.it"},{"site_name":"magicmicro.com","email":"support@magicmicro.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.dihuni.com","email":"support@dihuni.com"},{"site_name":"www.cpumedics.com","email":"rma@cpumedics.com"}]
148	true	fd9289f9-4e48-4dea-bb62-6863a556780c	[{"site_name":"bigbigmart.com","email":"cs@bigbigmart.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"},{"site_name":"techinstrument.com","email":"info@techinstrument.com"},{"site_name":"techforgeek.com","email":"info@techforgeek.com"},{"site_name":"nextsolutionitalia.it","email":"clienti@nextsolutionitalia.it"},{"site_name":"magicmicro.com","email":"support@magicmicro.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.dihuni.com","email":"support@dihuni.com"},{"site_name":"www.cpumedics.com","email":"rma@cpumedics.com"},{"site_name":"www.massgenie.com","email":"customerservice@massgenie.com"}]
149	true	5b2b15cc-b3b4-4423-b672-f562c0fa65cb	[{"site_name":"electroeshop.com","email":"support@electroeshop.com"},{"site_name":"foofster.com","email":"Support@Foofster.com"},{"site_name":"dreamcontroller.com","email":"customerservice@dreamcontroller.com"},{"site_name":"tradepostentertainment.com","email":"web@cdtradepost.com"},{"site_name":"www.controllerchaos.com","email":"info@controllerchaos.com"},{"site_name":"canadianbestseller.com","email":"customercare@canadianbestseller.com"},{"site_name":"www.myshopville.com","email":"hello@myshopville.com"},{"site_name":"grumpybobsonline.com","email":"62062618-288-3491support@grumpybobsonline.comOpen"},{"site_name":"cartnear.com","email":"support@cartnear.com"},{"site_name":"www.electronicsflip.com","email":"support@electronicsflip.com"}]
152	true	f6e7165f-f710-42b6-b3d0-86917f4fea59	[{"site_name":"hawkinswoodshop.com","email":"sales@hawkinswoodshop.com"},{"site_name":"www.healthwarehouse.com","email":"support@healthwarehouse.com"},{"site_name":"www.easy-dna.com","email":"info@easy-dna.com"},{"site_name":"shop.akc.org","email":"dna@akc.org"},{"site_name":"www.google.com","email":"guest.service@target.com"},{"site_name":"welovetec.com","email":"info@welovetec.com"},{"site_name":"venue.com","email":"customercare@venue.com"},{"site_name":"www.tigerdirect.com","email":"customerservice@tigerdirect.com"},{"site_name":"electroeshop.com","email":"support@electroeshop.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"}]
155	true	bcab40f4-f303-4d76-9081-c20ac241c6a2	[{"site_name":"foofster.com","email":"Support@Foofster.com"},{"site_name":"www.techinn.com","email":"support@tradeinn.com"},{"site_name":"www.memoryc.com","email":"support@memoryc.com"},{"site_name":"www.dihuni.com","email":"support@dihuni.com"},{"site_name":"starmicroinc.net","email":"rma@starmicroinc.net"},{"site_name":"canadianbestseller.com","email":"customercare@canadianbestseller.com"},{"site_name":"www.deals499.com","email":"sales@deals499.com"}]
156	true	eff8b235-ecd2-4123-8cad-317d7fcc2641	[{"site_name":"www.sears.com","email":"bitshopusa@gmail.com"},{"site_name":"www.google.com","email":"service@unbeatablesale.com"},{"site_name":"wisecomtech.com","email":"marketing@wisecomtech.com"},{"site_name":"www.colamco.com","email":"customerservice@colamco.com"},{"site_name":"trivoshop.com","email":"info@trivoshop.com"},{"site_name":"tecisoft.com","email":"info@tecisoft.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"},{"site_name":"venue.com","email":"customercare@venue.com"}]
157	true	fd9289f9-4e48-4dea-bb62-6863a556780c	[{"site_name":"www.sears.com","email":"Sears.Seller1@supportingbuyers.com"},{"site_name":"canadianbestseller.com","email":"customercare@canadianbestseller.com"}]
160	true	585c9180-9626-41be-b6a5-1deaa60a9bc7	[]
153	true	12d1306a-02c4-46d1-a138-6a153f5fd1d6	[]
154	true	d090f8f1-89fe-49be-b1d8-d49ff5dedfd3	[]
161	true	e6852be3-522d-42a7-af78-d3a7c4899acc	[{"site_name":"bonibi.com","email":"Support@Bonibi.com"},{"site_name":"www.h-brands.com","email":"customer@h-brands.com"},{"site_name":"www.campsaver.com","email":"contact@campsaver.com"},{"site_name":"www.tylerstx.com","email":"SUPPORT@TYLERSTX.COM"},{"site_name":"www.lyst.com","email":"press@lyst.com"},{"site_name":"boutiquetrip.com","email":"support@boutiquetrip.com"},{"site_name":"alabamaoutdoors.com","email":"CustomerService@aloutdoors.com"},{"site_name":"www.baltini.com","email":"returns@baltini.com"},{"site_name":"www.shopbop.com","email":"service@shopbop.com"},{"site_name":"www.google.com","email":"warranty@support.zappos.com"}]
167	true	a2bed0b3-c665-4e53-97d9-3a1c08a6ddb0	[{"site_name":"www.miersports.com","email":"info@miersports.com"},{"site_name":"www.quilltop.com","email":"support@quilltop.comPhone"},{"site_name":"outdooresprit.com","email":"support@outdooresprit.com"},{"site_name":"www.pariaoutdoorproducts.com","email":"support@pariaoutdoorproducts.com"},{"site_name":"www.mcguirearmynavy.com","email":"support@mcguirearmynavy.com"},{"site_name":"www.survivalgear.us","email":"SurvivalGearBSO@gmail.com"},{"site_name":"www.campsaver.com","email":"contact@campsaver.com"},{"site_name":"www.kelty.com","email":"WARRANTY@KELTY.COM"},{"site_name":"pawfecthouse.com","email":"contact@pawfecthouse.com"}]
165	true	66be9259-cea3-48f4-aeb9-2353cabf297c	[{"site_name":"www.allhdd.com","email":"support@allhdd.com"},{"site_name":"drivesolutions.com","email":"purchasing@drivesolutions.com"},{"site_name":"www.calhountech.com","email":"sales@calhountech.com"},{"site_name":"totalitysmarthome.net","email":"support@teamtotality.net"},{"site_name":"zntswholesale.com","email":"support@zntswholesale.com"},{"site_name":"www.sears.com","email":"wbj@fdsintl.com"},{"site_name":"homrest.com","email":"service@homrest.com"},{"site_name":"www.homedepot.com","email":"you@domain.com"},{"site_name":"canadianbestseller.com","email":"customercare@canadianbestseller.com"},{"site_name":"landscapeofdesigns.com","email":"hello@landscapeofdesigns.com"}]
164	true	ffb103c7-fd32-406e-bda8-5bfe0cc01919	[{"site_name":"www.allhdd.com","email":"support@allhdd.com"},{"site_name":"drivesolutions.com","email":"purchasing@drivesolutions.com"},{"site_name":"www.calhountech.com","email":"sales@calhountech.com"},{"site_name":"totalitysmarthome.net","email":"support@teamtotality.net"},{"site_name":"zntswholesale.com","email":"support@zntswholesale.com"},{"site_name":"www.sears.com","email":"wbj@fdsintl.com"},{"site_name":"homrest.com","email":"service@homrest.com"},{"site_name":"www.homedepot.com","email":"you@domain.com"},{"site_name":"canadianbestseller.com","email":"customercare@canadianbestseller.com"}]
170	true	d00dd8df-d033-4a04-a0f6-22521d73df7d	[{"site_name":"www.getroman.com","email":"care@ro.co"},{"site_name":"www.medicaldevicedepot.com","email":"info@MedicalDeviceDepot.com"},{"site_name":"medidentsupplies.com","email":"contact@medidentsupplies.com"}]
137	true	\N	[{"site_name":"www.electronicsforce.com","email":"info@electronicsforce.com"},{"site_name":"welectronics.com","email":"labbek@aol.com"},{"site_name":"www.kingcobraofflorida.com","email":"support@kingcobraofflorida.com"},{"site_name":"offermakers.com","email":"info@offermakers.com"},{"site_name":"swappa.com","email":"help@swappa.com"},{"site_name":"allthatcellular.net","email":"allthatcellular.net@gmail.com"},{"site_name":"bigamart.com","email":"contact@bigamart.com"},{"site_name":"fusionelectronix.com","email":"Support@fusionelectronix.com"},{"site_name":"www.cellularcountry.com","email":"support@cellularcountry.com"},{"site_name":"glyde.com","email":"service@glyde.com"}]
7	true	66be9259-cea3-48f4-aeb9-2353cabf297c	[{"site_name":"www.sears.com","email":"bitshopusa@gmail.com"},{"site_name":"primebuy.com","email":"info@PrimeBuy.com"},{"site_name":"www.macpalace.com","email":"sales@macpalace.com"},{"site_name":"www.server2hardware.com","email":"sales@server2hardware.com"},{"site_name":"www.serversupply.com","email":"chaz@serversupply.com"},{"site_name":"www.harveycreations.com","email":"info@harveycreations.com"},{"site_name":"www.macpartstore.com","email":"sales@macpartstore.com"}]
166	true	e04728f4-eebf-439d-9c4b-63b7fbf4e384	[{"site_name":"www.theyes.com","email":"press@theyes.com"},{"site_name":"www.runningwarehouse.com","email":"info@runningwarehouse.com"},{"site_name":"luxtiques.com","email":"hello@luxtiques.com"},{"site_name":"www.tactics.com","email":"help@tactics.com"},{"site_name":"sneakerstudio.com","email":"info@sneakerstudio.com"},{"site_name":"www.zappos.com","email":"pr@zappos.com"},{"site_name":"help.champssports.com","email":"customercare@champssports.com"},{"site_name":"help.footlocker.com","email":"customercare@footlocker.com"},{"site_name":"www.shopwss.com","email":"Help@shopwss.com"},{"site_name":"shopnicekicks.com","email":"customerservice@shopnicekicks.com"},{"site_name":"www.shoepalace.com","email":"CustomerService@ShoePalace.com"},{"site_name":"help.eastbay.com","email":"customercare@eastbay.com"},{"site_name":"simplifyshopping.com","email":"info@simplifyshopping.com"},{"site_name":"help.footaction.com","email":"customercare@footaction.com"},{"site_name":"www.shoesensation.com","email":"customerservice@shoesensation.com"},{"site_name":"www.jacobtime.com","email":"sales@jacobtime.com"},{"site_name":"www.bhfo.com","email":"CUSTOMERCARE@BHFO.COM"},{"site_name":"en.afew-store.com","email":"SERVICE@AFEW-STORE.COM"},{"site_name":"www.worldwideshoppingmall.com","email":"sales@wwsm.co.uk"},{"site_name":"www.vitkac.com","email":"customerservice@vitkac.com"}]
171	true	e04728f4-eebf-439d-9c4b-63b7fbf4e384	[{"site_name":"www.theyes.com","email":"press@theyes.com"},{"site_name":"bestfouryou.shop","email":"support@bestfouryou.shop"},{"site_name":"www.runningwarehouse.com","email":"info@runningwarehouse.com"},{"site_name":"luxtiques.com","email":"hello@luxtiques.com"},{"site_name":"www.kickscrew.com","email":"CS@KICKSCREW.COM"},{"site_name":"help.footlocker.com","email":"customercare@footlocker.com"},{"site_name":"help.champssports.com","email":"customercare@champssports.com"},{"site_name":"help.eastbay.com","email":"customercare@eastbay.com"},{"site_name":"www.shoesensation.com","email":"customerservice@shoesensation.com"},{"site_name":"www.kixify.com","email":"support@kixify.com"},null]
172	true	61227adb-77ae-42e7-97c6-5419beac227f	[{"site_name":"maintechconnect.com","email":"sales@maintechconnect.com"},{"site_name":"www.shopforgamers.com","email":"info@shopforgamers.com"},{"site_name":"rkgamingstore.com","email":"support@rkgaming.com"},{"site_name":"gamer-z-paradise.com","email":"info@gamer-z-paradise.com"},null]
163	true	2bf7d30f-c2df-4ae0-9863-7f154e28b550	[{"site_name":"siftway.com","email":"contact@siftway.com"}]
151	true	e5b625a1-058e-4ed7-9c17-9546ee953078	[{"site_name":"pwnage.com","email":"support@pwnage.com"},{"site_name":"electroeshop.com","email":"support@electroeshop.com"},{"site_name":"www.wbmason.com","email":"open.web@wbmason.com"},{"site_name":"welovetec.com","email":"info@welovetec.com"},{"site_name":"venue.com","email":"customercare@venue.com"},{"site_name":"www.tigerdirect.com","email":"customerservice@tigerdirect.com"},{"site_name":"www.provantage.com","email":"Subscriber@provantage.com"},{"site_name":"www.govgroup.com","email":"sales@govgroup.com"},{"site_name":"www.vyralteq.com","email":"support@vyralteq.com"},{"site_name":"www.deploydepot.ca","email":"info@deploydepot.ca"},{"site_name":"www.colamco.com","email":"customerservice@colamco.com"},{"site_name":"www.wbmason.com","email":"open.web@wbmason.com"},{"site_name":"techcitygear.com","email":"sales@techcitygear.com"},{"site_name":"pwnage.com","email":"support@pwnage.com"},{"site_name":"inexbuy.com","email":"info@inexbuy.com"},{"site_name":"wisecomtech.com","email":"marketing@wisecomtech.com"},{"site_name":"rehmie.com","email":"support@rehmie.com"},{"site_name":"www.adorama.com","email":"info@adorama.com"},{"site_name":"www.aziocorp.com","email":"orders@aziocorp.com"},{"site_name":"www.truegether.com","email":"support@truegether.com"},{"site_name":"www.geekbuying.com","email":"service_payment@geekbuying.com"},{"site_name":"www.tradeinn.com","email":"support@tradeinn.com"},{"site_name":"www.dihuni.com","email":"support@dihuni.com"},{"site_name":"pssav.com","email":"jeff@pssav.com"},{"site_name":"nextwavegamez.com","email":"nextwavegamez@gmail.com"},{"site_name":"vordeo.com","email":"info@vordeo.com"}]
\.


--
-- Data for Name: email_management; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_management (id, name, template_id) FROM stdin;
1	Feedback	3
3	New group formed	4
2	Update user that a group is soon to be full	5
\.


--
-- Data for Name: email_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_template (id, template_name, template_json, template_html) FROM stdin;
3	User Feedback	{"counters":{"u_row":18,"u_column":24,"u_content_menu":3,"u_content_text":20,"u_content_image":11,"u_content_button":4,"u_content_social":1,"u_content_divider":7,"u_content_heading":1},"body":{"id":"onj6Sq3Z95","rows":[{"id":"PeuR6yT3OT","cells":[1],"columns":[{"id":"779BznF2tc","contents":[{"id":"28U75pbVS0","type":"heading","values":{"containerPadding":"10px","anchor":"","headingType":"h1","fontFamily":{"label":"Arial","value":"arial,helvetica,sans-serif"},"fontSize":"22px","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_heading_1","htmlClassNames":"u_content_heading"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"Feedback"}},{"id":"cg0f-5_-kk","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_7","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"Uu1VZMWHak","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_17","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>"}},{"id":"YJH7keK8N1","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_18","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>"}},{"id":"1BsmzQiQkA","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_19","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#cccccc","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#cccccc","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#cccccc","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#cccccc"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"u9C8jD0gGA","cells":[1,1],"columns":[{"id":"Mn1qKNwISH","contents":[{"id":"9mPwAn-Xar","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_20","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em></span></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"7px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}},{"id":"I6EWB4eYcY","contents":[{"id":"iL4zX1Tdcc","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596220995-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_11","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px 0px 12px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_24","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"#ffffff","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_15","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #0000ee; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <h1 style=\\"margin: 0px; line-height: 140%; text-align: left; word-wrap: break-word; font-weight: normal; font-family: arial,helvetica,sans-serif; font-size: 22px;\\">\\n    Feedback\\n  </h1>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: #ffffff\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: #ffffff;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 7px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 7px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\">feedback@landsbe.com</a></span></em></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px 0px 12px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px 0px 12px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596220995-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
4	Landsbe Template	{"counters":{"u_row":14,"u_column":18,"u_content_menu":3,"u_content_text":16,"u_content_image":8,"u_content_button":4,"u_content_social":1,"u_content_divider":6},"body":{"id":"g1TQaNNUSn","rows":[{"id":"rYqL2I2F5A","cells":[1],"columns":[{"id":"BWmmcO2ART","contents":[{"id":"KhYpvq-Fxk","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"{{image}}","width":800,"height":200,"autoWidth":false,"maxWidth":"81%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_4","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"iRPkI5e6_3","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_13","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 16px; line-height: 22.4px;\\"><strong>{{header}}</strong></span></p>"}},{"id":"WQ4wG5QF9P","type":"text","values":{"containerPadding":"10px 10px 10px 20px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_14","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{message}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#CCC","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#CCC","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#CCC","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#CCC"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"HlzEdj53XB","cells":[1,1],"columns":[{"id":"eKbCJAoLXP","contents":[{"id":"1zBAaBBnel","type":"text","values":{"containerPadding":"10px 10px 9px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_16","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ecf0f1; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ecf0f1; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em></span></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"7px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_17","htmlClassNames":"u_column"}}},{"id":"6iFQ_3wVUU","contents":[{"id":"IrbnLI3aCb","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596504755-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_8","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px 0px 11px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_14","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"y35I0hW1zd","cells":[1],"columns":[{"id":"DJzvM63IWF","contents":[{"id":"TG8BuqFqE2","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"0px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_5","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false}}],"values":{"_meta":{"htmlID":"u_column_15","htmlClassNames":"u_column"},"border":{},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_12","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#000000","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true,"inherit":false},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #000000; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #CCC;border-left: 1px solid #CCC;border-right: 1px solid #CCC;border-bottom: 1px solid #CCC;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #CCC;border-left: 1px solid #CCC;border-right: 1px solid #CCC;border-bottom: 1px solid #CCC;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 81%;max-width: 469.8px;\\" width=\\"469.8\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 16px; line-height: 22.4px;\\"><strong>{{header}}</strong></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px 10px 10px 20px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{message}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 7px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 7px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px 10px 9px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ecf0f1; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ecf0f1; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\">feedback@landsbe.com</a></span></em></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596504755-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"600\\" style=\\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 0px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
6	Sample	{"counters":{"u_row":13,"u_column":16,"u_content_menu":3,"u_content_text":11,"u_content_image":3,"u_content_button":4,"u_content_social":1,"u_content_divider":6},"body":{"id":"GFo38mw52q","rows":[{"id":"CZ-D_POLBM","cells":[1],"columns":[{"id":"fPHW0CdUcq","contents":[],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"swGsdKFMF2","cells":[1],"columns":[{"id":"8xUdsmM32V","contents":[{"id":"2IB8xuOQKZ","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"0px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_5","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false}}],"values":{"_meta":{"htmlID":"u_column_15","htmlClassNames":"u_column"},"border":{},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_12","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#e7e7e7","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":7}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #e7e7e7;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #e7e7e7;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #e7e7e7;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"600\\" style=\\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\"><!--<![endif]-->\\n  \\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"600\\" style=\\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 0px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
7	User Product Feedback	{"counters":{"u_row":17,"u_column":22,"u_content_menu":3,"u_content_text":21,"u_content_image":11,"u_content_button":4,"u_content_social":1,"u_content_divider":7,"u_content_heading":1},"body":{"id":"9psg9ZdNiE","rows":[{"id":"mgVWLzF71h","cells":[1],"columns":[{"id":"tBYyoyUMh6","contents":[{"id":"wowtDhbO8d","type":"heading","values":{"containerPadding":"10px","anchor":"","headingType":"h1","fontFamily":{"label":"Arial","value":"arial,helvetica,sans-serif"},"fontSize":"22px","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_heading_1","htmlClassNames":"u_content_heading"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"User Feedback"}},{"id":"OnzIbIaq8R","type":"image","values":{"containerPadding":"0px 100px","anchor":"","src":{"url":"{{image}}","width":800,"height":200},"textAlign":"center","altText":"Image","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_9","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"fYznF5g-_i","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"center","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_20","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{group_name}}</strong></p>"}},{"id":"C5uXPGK_oW","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_7","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"5cx0zoy0Im","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_17","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>"}},{"id":"Rw72ZdykN-","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_18","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>"}},{"id":"RdbP88Bw_-","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_19","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#cccccc","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#cccccc","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#cccccc","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#cccccc"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"aiIMrRV6Tk","cells":[1,1],"columns":[{"id":"AJsR_KuxvG","contents":[{"id":"LFLXhkyC9x","type":"text","values":{"containerPadding":"10px 10px 11px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_21","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\"><em>feedback@landsbe.com</em></a></span></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"5px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}},{"id":"arHACFvAzD","contents":[{"id":"V28B-nYkXH","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596563383-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"58%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_11","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px 0px 11px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_22","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"#ffffff","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_15","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #0000ee; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <h1 style=\\"margin: 0px; line-height: 140%; text-align: left; word-wrap: break-word; font-weight: normal; font-family: arial,helvetica,sans-serif; font-size: 22px;\\">\\n    User Feedback\\n  </h1>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:0px 100px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"Image\\" title=\\"Image\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 100%;max-width: 400px;\\" width=\\"400\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: center; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{group_name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: #ffffff\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: #ffffff;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 5px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 5px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px 10px 11px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\"><em>feedback@landsbe.com</em></a></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596563383-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 58%;max-width: 162.4px;\\" width=\\"162.4\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
8	Product Suggestion	{"counters":{"u_row":14,"u_column":18,"u_content_menu":3,"u_content_text":17,"u_content_image":7,"u_content_button":4,"u_content_social":1,"u_content_divider":6},"body":{"id":"V-dHnNz_p9","rows":[{"id":"tAvED-TtNv","cells":[1],"columns":[{"id":"gSD2XsoMaY","contents":[{"id":"pJWfoODQqD","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"{{image}}","width":800,"height":200,"autoWidth":false,"maxWidth":"81%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_4","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"zytDstTVyN","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"{{image}}","width":800,"height":200},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_5","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"3CxLEJy9Bp","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_13","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 16px; line-height: 22.4px;\\"><strong>{{header}}</strong></span></p>"}},{"id":"CYpArlUdkV","type":"text","values":{"containerPadding":"10px 10px 10px 20px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_14","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{message}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#CCC","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#CCC","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#CCC","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#CCC"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"jA5M2Q5yqF","cells":[1,1],"columns":[{"id":"b26aJ7sfpJ","contents":[{"id":"AAO9hMQLO4","type":"text","values":{"containerPadding":"11px 10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_17","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"3px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_17","htmlClassNames":"u_column"}}},{"id":"hESzZlkWKQ","contents":[{"id":"cTiXGc56hT","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596624014-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_7","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_14","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"xZWprU2Zh6","cells":[1],"columns":[{"id":"vYjJXJRKzJ","contents":[{"id":"i5xt6e8NfP","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"0px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_5","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false}}],"values":{"_meta":{"htmlID":"u_column_15","htmlClassNames":"u_column"},"border":{},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_12","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#000000","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true,"inherit":false},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #000000; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #CCC;border-left: 1px solid #CCC;border-right: 1px solid #CCC;border-bottom: 1px solid #CCC;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #CCC;border-left: 1px solid #CCC;border-right: 1px solid #CCC;border-bottom: 1px solid #CCC;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 81%;max-width: 469.8px;\\" width=\\"469.8\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 100%;max-width: 580px;\\" width=\\"580\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 16px; line-height: 22.4px;\\"><strong>{{header}}</strong></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px 10px 10px 20px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{message}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 3px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 3px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:11px 10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\">feedback@landsbe.com</a></span></em></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596624014-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"600\\" style=\\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 0px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
9	Contact Landsbe	{"counters":{"u_row":18,"u_column":24,"u_content_menu":3,"u_content_text":20,"u_content_image":11,"u_content_button":4,"u_content_social":1,"u_content_divider":7,"u_content_heading":1},"body":{"id":"mIbbkbpvJb","rows":[{"id":"fNGntfbBg5","cells":[1],"columns":[{"id":"eNBKecDR4u","contents":[{"id":"bdAtEroueC","type":"heading","values":{"containerPadding":"10px","anchor":"","headingType":"h1","fontFamily":{"label":"Arial","value":"arial,helvetica,sans-serif"},"fontSize":"22px","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_heading_1","htmlClassNames":"u_content_heading"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"Contacted Landsbe"}},{"id":"sAMGAFhffp","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_7","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"Wi5uvsiKsV","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_17","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>"}},{"id":"xcDUtnDgdX","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_18","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>"}},{"id":"eA5EZhjh9B","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_19","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Message</strong>: {{message}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#cccccc","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#cccccc","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#cccccc","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#cccccc"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"_18asUVIr5","cells":[1,1],"columns":[{"id":"dcRLKv5zfM","contents":[{"id":"VUWRdxSUwd","type":"text","values":{"containerPadding":"11px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_20","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em></span></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"3px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}},{"id":"VZSQiLfjNQ","contents":[{"id":"hd0WcvomLm","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596220995-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_11","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_24","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"#ffffff","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_15","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #0000ee; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <h1 style=\\"margin: 0px; line-height: 140%; text-align: left; word-wrap: break-word; font-weight: normal; font-family: arial,helvetica,sans-serif; font-size: 22px;\\">\\n    Contacted Landsbe\\n  </h1>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Message</strong>: {{message}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: #ffffff\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: #ffffff;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 3px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 3px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:11px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\"><em><span style=\\"color: #ffffff; line-height: 16.8px; font-size: 12px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\">feedback@landsbe.com</a></span></em></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596220995-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
5	Seller Feedback	{"counters":{"u_row":17,"u_column":22,"u_content_menu":3,"u_content_text":21,"u_content_image":11,"u_content_button":4,"u_content_social":1,"u_content_divider":7,"u_content_heading":1},"body":{"id":"XQ6WdLYCqk","rows":[{"id":"Sw2HKi000h","cells":[1],"columns":[{"id":"suFWwV0Ij6","contents":[{"id":"X993-iVd5Z","type":"heading","values":{"containerPadding":"10px","anchor":"","headingType":"h1","fontFamily":{"label":"Arial","value":"arial,helvetica,sans-serif"},"fontSize":"22px","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_heading_1","htmlClassNames":"u_content_heading"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"Seller Feedback"}},{"id":"5rumYdgpMl","type":"image","values":{"containerPadding":"0px 100px","anchor":"","src":{"url":"{{image}}","width":800,"height":200,"autoWidth":false,"maxWidth":"50%"},"textAlign":"center","altText":"Image","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_9","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"ZcL31nH2lz","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"center","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_20","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{group_name}}</strong></p>"}},{"id":"EYgnYzFSek","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_7","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"C61DA5X400","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_17","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>"}},{"id":"3MTEMWK1ER","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_18","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>"}},{"id":"E3RabKUINJ","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_19","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>"}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#cccccc","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#cccccc","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#cccccc","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#cccccc"},"padding":"0px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"Nkp0AcVKJm","cells":[1,1],"columns":[{"id":"hdkuaZoYwV","contents":[{"id":"5PwvzZ1_4K","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"displayCondition":null,"_meta":{"htmlID":"u_content_text_21","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"4px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}},{"id":"ZhfDLDdEw6","contents":[{"id":"GrZSKq2e-k","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596433249-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"displayCondition":null,"_meta":{"htmlID":"u_content_image_11","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_22","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"#ffffff","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_15","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #0000ee; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 0px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <h1 style=\\"margin: 0px; line-height: 140%; text-align: left; word-wrap: break-word; font-weight: normal; font-family: arial,helvetica,sans-serif; font-size: 22px;\\">\\n    Seller Feedback\\n  </h1>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:0px 100px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"Image\\" title=\\"Image\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 50%;max-width: 200px;\\" width=\\"200\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: center; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{group_name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>{{name}}</strong></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\">{{email}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><strong>Desciption</strong>: {{Description}}</p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: #ffffff\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: #ffffff;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 4px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 4px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"font-size: 12px; line-height: 16.8px; color: #ffffff;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff;\\">feedback@landsbe.com</a></span></em></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596433249-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
10	Prospect Seller	{"counters":{"u_row":17,"u_column":22,"u_content_menu":3,"u_content_text":24,"u_content_image":12,"u_content_button":4,"u_content_social":1,"u_content_divider":7,"u_content_heading":1},"body":{"id":"yBZs96geHa","rows":[{"id":"bfvwZ_QM9K","cells":[1],"columns":[{"id":"jebehqprmq","contents":[{"id":"9560c_jRY9","type":"text","values":{"containerPadding":"15px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_21","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\">We&rsquo;d like to introduce you to Landsbe, a consumer driven group buying platform that may change the way you do business. &nbsp;Landsbe organizes consumer buying patterns and behavior through the formation of groups for specific products, which leads to a more favorable price point (better deal) for the buyer and a more streamlined and cost effective transaction for you.<br /><br />Here&rsquo;s a few of the advantages you&rsquo;ll see as part of the <strong>Landsbe </strong>seller community -&nbsp; &nbsp;</span></p>\\n<ul>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>No need to attract buyers one by one.</strong> &nbsp;We&rsquo;ll do the work for you to organize buyers into buying groups. &nbsp;You&rsquo;ll be able to transact with a group of consumers that are ready to buy.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Better inventory management.</strong> Because you can see which groups are forming around which products through our seller portal, you&rsquo;ll be able to anticipate how much of one product you could sell at a specific time.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Seller-formed groups.</strong> &nbsp;We will have a certain number of seller formed groups on the site. &nbsp;If you have a product you&rsquo;d like to promote, you can form a group on the site.&nbsp;</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Low risk additional distribution channel. </strong>&nbsp;During our launch, you can join the Landsbe seller community at no monthly cost. &nbsp;The only fee we collect will be when you transact with a group. The fee is put on top of the price you want to sell it at so what you list it for is what you will get.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Access to buyer groups.</strong> As buyer groups form you will have the opportunity to bid on those groups which can allow you to expand your product offering with almost no risk.</span></li>\\n</ul>\\n<p style=\\"font-size: 14px; line-height: 140%;\\">&nbsp;</p>\\n<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\">Here&rsquo;s one example of a group that&rsquo;s recently formed for a product you offer that you may be interested in -&nbsp;</span></p>"}},{"id":"s6giGnBI4e","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"{{image}}","width":800,"height":200,"autoWidth":false,"maxWidth":"45%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_12","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}},{"id":"GCh9ArqN1B","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_24","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%; text-align: center;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\"><strong>{{group_name}}</strong></span></p>"}},{"id":"T0xsJQU2Sb","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_23","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\">Our <a rel=\\"noopener\\" href=\\"https://www.landsbe.com/seller/login?redirect=%2Fseller%2Fseller-dashboard\\" target=\\"_blank\\" data-u-link-value=\\"eyJuYW1lIjoid2ViIiwiYXR0cnMiOnsiaHJlZiI6Int7aHJlZn19IiwidGFyZ2V0Ijoie3t0YXJnZXR9fSJ9LCJ2YWx1ZXMiOnsiaHJlZiI6Imh0dHBzOi8vd3d3LmxhbmRzYmUuY29tL3NlbGxlci9sb2dpbj9yZWRpcmVjdD0lMkZzZWxsZXIlMkZzZWxsZXItZGFzaGJvYXJkIiwidGFyZ2V0IjoiX2JsYW5rIn19\\"><span style=\\"color: #ad841f; font-size: 12px; line-height: 16.8px;\\"><strong>sign-up</strong></span></a> process is simple. &nbsp;If you&rsquo;d like to learn more about our seller community, feel free to reach out to me or visit <strong><span style=\\"color: #ad841f; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"https://www.landsbe.com/\\" target=\\"_blank\\" style=\\"color: #ad841f;\\" data-u-link-value=\\"eyJuYW1lIjoid2ViIiwiYXR0cnMiOnsiaHJlZiI6Int7aHJlZn19IiwidGFyZ2V0Ijoie3t0YXJnZXR9fSJ9LCJ2YWx1ZXMiOnsiaHJlZiI6Imh0dHBzOi8vd3d3LmxhbmRzYmUuY29tLyIsInRhcmdldCI6Il9ibGFuayJ9fQ==\\">Landsbe</a></span></strong>.</span></p>\\n<p style=\\"font-size: 14px; line-height: 140%;\\"><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\">Thanks,</span></p>"}},{"id":"sl0V5JeBa2","type":"divider","values":{"width":"100%","border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#BBBBBB"},"textAlign":"center","containerPadding":"10px","anchor":"","hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_divider_7","htmlClassNames":"u_content_divider"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"_meta":{"htmlID":"u_column_12","htmlClassNames":"u_column"},"border":{"borderTopWidth":"1px","borderTopStyle":"solid","borderTopColor":"#cccccc","borderLeftWidth":"1px","borderLeftStyle":"solid","borderLeftColor":"#cccccc","borderRightWidth":"1px","borderRightStyle":"solid","borderRightColor":"#cccccc","borderBottomWidth":"1px","borderBottomStyle":"solid","borderBottomColor":"#cccccc"},"padding":"20px","backgroundColor":""}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_9","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"hideMobile":false,"noStackMobile":false}},{"id":"iBg6qXz4VH","cells":[1,1],"columns":[{"id":"olTTN2Pq1o","contents":[{"id":"du56CRq3bJ","type":"text","values":{"containerPadding":"10px","anchor":"","textAlign":"left","lineHeight":"140%","linkStyle":{"inherit":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_text_22","htmlClassNames":"u_content_text"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true,"text":"<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"font-size: 14px; line-height: 19.6px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff; text-decoration: underline;\\" data-u-link-value=\\"eyJuYW1lIjoiZW1haWwiLCJhdHRycyI6eyJocmVmIjoibWFpbHRvOnt7ZW1haWx9fT9zdWJqZWN0PXt7c3ViamVjdH19JmJvZHk9e3tib2R5fX0ifSwidmFsdWVzIjp7ImVtYWlsIjoiZmVlZGJhY2tAbGFuZHNiZS5jb20iLCJzdWJqZWN0IjoiIiwiYm9keSI6IiJ9fQ==\\">feedback@landsbe.com</a></span></em><br /></span></p>"}}],"values":{"backgroundColor":"#ad841f","padding":"6px","border":{},"borderRadius":"0px","_meta":{"htmlID":"u_column_18","htmlClassNames":"u_column"}}},{"id":"LjetQ-Ob1z","contents":[{"id":"DJBxx7vRdq","type":"image","values":{"containerPadding":"10px","anchor":"","src":{"url":"https://images.unlayer.com/projects/0/1640596433249-logo_horizontal_black_crop.png","width":800,"height":239,"autoWidth":false,"maxWidth":"60%"},"textAlign":"center","altText":"","action":{"name":"web","values":{"href":"","target":"_blank"}},"hideDesktop":false,"displayCondition":null,"_meta":{"htmlID":"u_content_image_11","htmlClassNames":"u_content_image"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"backgroundColor":"#ad841f","padding":"10px 0px 11px","border":{"borderTopWidth":"0px","borderTopStyle":"solid","borderTopColor":"#CCC","borderLeftWidth":"0px","borderLeftStyle":"solid","borderLeftColor":"#CCC","borderRightWidth":"0px","borderRightStyle":"solid","borderRightColor":"#CCC","borderBottomWidth":"0px","borderBottomStyle":"solid","borderBottomColor":"#CCC"},"borderRadius":"0px","_meta":{"htmlID":"u_column_22","htmlClassNames":"u_column"}}}],"values":{"displayCondition":null,"columns":false,"backgroundColor":"#ffffff","columnsBackgroundColor":"","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"padding":"0px","anchor":"","hideDesktop":false,"_meta":{"htmlID":"u_row_15","htmlClassNames":"u_row"},"selectable":true,"draggable":true,"duplicatable":true,"deletable":true,"hideable":true}}],"values":{"popupPosition":"center","popupWidth":"600px","popupHeight":"auto","borderRadius":"10px","contentAlign":"center","contentVerticalAlign":"center","contentWidth":"600px","fontFamily":{"label":"Montserrat","value":"'Montserrat',sans-serif","url":"https://fonts.googleapis.com/css?family=Montserrat:400,700","defaultFont":true},"textColor":"#000000","popupBackgroundColor":"#FFFFFF","popupBackgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":true},"popupOverlay_backgroundColor":"rgba(0, 0, 0, 0.1)","popupCloseButton_position":"top-right","popupCloseButton_backgroundColor":"#DDDDDD","popupCloseButton_iconColor":"#000000","popupCloseButton_borderRadius":"0px","popupCloseButton_margin":"0px","popupCloseButton_action":{"name":"close_popup","attrs":{"onClick":"document.querySelector('.u-popup-container').style.display = 'none';"}},"backgroundColor":"#ffffff","backgroundImage":{"url":"","fullWidth":true,"repeat":false,"center":true,"cover":false},"preheaderText":"","linkStyle":{"body":true,"linkColor":"#0000ee","linkHoverColor":"#0000ee","linkUnderline":true,"linkHoverUnderline":true},"_meta":{"htmlID":"u_body","htmlClassNames":"u_body"}}},"schemaVersion":8}	"<!DOCTYPE HTML PUBLIC \\"-//W3C//DTD XHTML 1.0 Transitional //EN\\" \\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\\">\\n<html xmlns=\\"http://www.w3.org/1999/xhtml\\" xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\">\\n<head>\\n<!--[if gte mso 9]>\\n<xml>\\n  <o:OfficeDocumentSettings>\\n    <o:AllowPNG/>\\n    <o:PixelsPerInch>96</o:PixelsPerInch>\\n  </o:OfficeDocumentSettings>\\n</xml>\\n<![endif]-->\\n  <meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=UTF-8\\">\\n  <meta name=\\"viewport\\" content=\\"width=device-width, initial-scale=1.0\\">\\n  <meta name=\\"x-apple-disable-message-reformatting\\">\\n  <!--[if !mso]><!--><meta http-equiv=\\"X-UA-Compatible\\" content=\\"IE=edge\\"><!--<![endif]-->\\n  <title></title>\\n  \\n    <style type=\\"text/css\\">\\n      @media only screen and (min-width: 620px) {\\n  .u-row {\\n    width: 600px !important;\\n  }\\n  .u-row .u-col {\\n    vertical-align: top;\\n  }\\n\\n  .u-row .u-col-50 {\\n    width: 300px !important;\\n  }\\n\\n  .u-row .u-col-100 {\\n    width: 600px !important;\\n  }\\n\\n}\\n\\n@media (max-width: 620px) {\\n  .u-row-container {\\n    max-width: 100% !important;\\n    padding-left: 0px !important;\\n    padding-right: 0px !important;\\n  }\\n  .u-row .u-col {\\n    min-width: 320px !important;\\n    max-width: 100% !important;\\n    display: block !important;\\n  }\\n  .u-row {\\n    width: calc(100% - 40px) !important;\\n  }\\n  .u-col {\\n    width: 100% !important;\\n  }\\n  .u-col > div {\\n    margin: 0 auto;\\n  }\\n}\\nbody {\\n  margin: 0;\\n  padding: 0;\\n}\\n\\ntable,\\ntr,\\ntd {\\n  vertical-align: top;\\n  border-collapse: collapse;\\n}\\n\\np {\\n  margin: 0;\\n}\\n\\n.ie-container table,\\n.mso-container table {\\n  table-layout: fixed;\\n}\\n\\n* {\\n  line-height: inherit;\\n}\\n\\na[x-apple-data-detectors='true'] {\\n  color: inherit !important;\\n  text-decoration: none !important;\\n}\\n\\ntable, td { color: #000000; } a { color: #0000ee; text-decoration: underline; } </style>\\n  \\n  \\n\\n<!--[if !mso]><!--><link href=\\"https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap\\" rel=\\"stylesheet\\" type=\\"text/css\\"><!--<![endif]-->\\n\\n</head>\\n\\n<body class=\\"clean-body u_body\\" style=\\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ffffff;color: #000000\\">\\n  <!--[if IE]><div class=\\"ie-container\\"><![endif]-->\\n  <!--[if mso]><div class=\\"mso-container\\"><![endif]-->\\n  <table style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ffffff;width:100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\">\\n  <tbody>\\n  <tr style=\\"vertical-align: top\\">\\n    <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\\">\\n    <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td align=\\"center\\" style=\\"background-color: #ffffff;\\"><![endif]-->\\n    \\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: transparent\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: transparent;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"598\\" style=\\"width: 598px;padding: 20px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-100\\" style=\\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"width: 100% !important;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 20px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;border-right: 1px solid #cccccc;border-bottom: 1px solid #cccccc;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:15px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\">We&rsquo;d like to introduce you to Landsbe, a consumer driven group buying platform that may change the way you do business. &nbsp;Landsbe organizes consumer buying patterns and behavior through the formation of groups for specific products, which leads to a more favorable price point (better deal) for the buyer and a more streamlined and cost effective transaction for you.<br /><br />Here&rsquo;s a few of the advantages you&rsquo;ll see as part of the <strong>Landsbe </strong>seller community -&nbsp; &nbsp;</span></p>\\n<ul>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>No need to attract buyers one by one.</strong> &nbsp;We&rsquo;ll do the work for you to organize buyers into buying groups. &nbsp;You&rsquo;ll be able to transact with a group of consumers that are ready to buy.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Better inventory management.</strong> Because you can see which groups are forming around which products through our seller portal, you&rsquo;ll be able to anticipate how much of one product you could sell at a specific time.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Seller-formed groups.</strong> &nbsp;We will have a certain number of seller formed groups on the site. &nbsp;If you have a product you&rsquo;d like to promote, you can form a group on the site. </span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Low risk additional distribution channel. </strong>&nbsp;During our launch, you can join the Landsbe seller community at no monthly cost. &nbsp;The only fee we collect will be when you transact with a group. The fee is put on top of the price you want to sell it at so what you list it for is what you will get.</span></li>\\n<li style=\\"font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\"><strong>Access to buyer groups.</strong> As buyer groups form you will have the opportunity to bid on those groups which can allow you to expand your product offering with almost no risk.</span></li>\\n</ul>\\n<p style=\\"font-size: 14px; line-height: 140%;\\">&nbsp;</p>\\n<p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px; color: #000000;\\">Here&rsquo;s one example of a group that&rsquo;s recently formed for a product you offer that you may be interested in -&nbsp;</span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"{{image}}\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 45%;max-width: 261px;\\" width=\\"261\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%; text-align: center;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\"><strong>{{group_name}}</strong></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\">Our <a rel=\\"noopener\\" href=\\"https://www.landsbe.com/seller/login?redirect=%2Fseller%2Fseller-dashboard\\" target=\\"_blank\\"><span style=\\"color: #ad841f; font-size: 12px; line-height: 16.8px;\\"><strong>sign-up</strong></span></a> process is simple. &nbsp;If you&rsquo;d like to learn more about our seller community, feel free to reach out to me or visit <strong><span style=\\"color: #ad841f; font-size: 12px; line-height: 16.8px;\\"><a rel=\\"noopener\\" href=\\"https://www.landsbe.com/\\" target=\\"_blank\\" style=\\"color: #ad841f;\\">Landsbe</a></span></strong>.</span></p>\\n<p style=\\"font-size: 14px; line-height: 140%;\\"><br /><span style=\\"font-size: 12px; line-height: 16.8px;\\">Thanks,</span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <table height=\\"0px\\" align=\\"center\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" style=\\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n    <tbody>\\n      <tr style=\\"vertical-align: top\\">\\n        <td style=\\"word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%\\">\\n          <span>&#160;</span>\\n        </td>\\n      </tr>\\n    </tbody>\\n  </table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n\\n<div class=\\"u-row-container\\" style=\\"padding: 0px;background-color: #ffffff\\">\\n  <div class=\\"u-row\\" style=\\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;\\">\\n    <div style=\\"border-collapse: collapse;display: table;width: 100%;background-color: transparent;\\">\\n      <!--[if (mso)|(IE)]><table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\"><tr><td style=\\"padding: 0px;background-color: #ffffff;\\" align=\\"center\\"><table cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\" style=\\"width:600px;\\"><tr style=\\"background-color: transparent;\\"><![endif]-->\\n      \\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 6px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 6px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n  <div style=\\"line-height: 140%; text-align: left; word-wrap: break-word;\\">\\n    <p style=\\"font-size: 14px; line-height: 140%;\\"><span style=\\"color: #ffffff; font-size: 12px; line-height: 16.8px;\\">189 North Highway 89 Suite C-173,</span><br /><span style=\\"color: #ffffff; font-size: 14px; line-height: 19.6px;\\"><span style=\\"font-size: 12px; line-height: 16.8px;\\">North Salt Lake Utah, 84054</span><br /><em><span style=\\"font-size: 14px; line-height: 19.6px;\\"><a rel=\\"noopener\\" href=\\"mailto:feedback@landsbe.com?subject=&body=\\" target=\\"_blank\\" style=\\"color: #ffffff; text-decoration: underline;\\">feedback@landsbe.com</a></span></em><br /></span></p>\\n  </div>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n<!--[if (mso)|(IE)]><td align=\\"center\\" width=\\"300\\" style=\\"background-color: #ad841f;width: 300px;padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\" valign=\\"top\\"><![endif]-->\\n<div class=\\"u-col u-col-50\\" style=\\"max-width: 320px;min-width: 300px;display: table-cell;vertical-align: top;\\">\\n  <div style=\\"background-color: #ad841f;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\">\\n  <!--[if (!mso)&(!IE)]><!--><div style=\\"padding: 10px 0px 11px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;\\"><!--<![endif]-->\\n  \\n<table style=\\"font-family:'Montserrat',sans-serif;\\" role=\\"presentation\\" cellpadding=\\"0\\" cellspacing=\\"0\\" width=\\"100%\\" border=\\"0\\">\\n  <tbody>\\n    <tr>\\n      <td style=\\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Montserrat',sans-serif;\\" align=\\"left\\">\\n        \\n<table width=\\"100%\\" cellpadding=\\"0\\" cellspacing=\\"0\\" border=\\"0\\">\\n  <tr>\\n    <td style=\\"padding-right: 0px;padding-left: 0px;\\" align=\\"center\\">\\n      \\n      <img align=\\"center\\" border=\\"0\\" src=\\"https://images.unlayer.com/projects/0/1640596433249-logo_horizontal_black_crop.png\\" alt=\\"\\" title=\\"\\" style=\\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 60%;max-width: 168px;\\" width=\\"168\\"/>\\n      \\n    </td>\\n  </tr>\\n</table>\\n\\n      </td>\\n    </tr>\\n  </tbody>\\n</table>\\n\\n  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->\\n  </div>\\n</div>\\n<!--[if (mso)|(IE)]></td><![endif]-->\\n      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\\n    </div>\\n  </div>\\n</div>\\n\\n\\n    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\\n    </td>\\n  </tr>\\n  </tbody>\\n  </table>\\n  <!--[if mso]></div><![endif]-->\\n  <!--[if IE]></div><![endif]-->\\n</body>\\n\\n</html>\\n"
\.


--
-- Data for Name: faq_editor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faq_editor (faq_id, question, description, type) FROM stdin;
1	[Return Refund for Sellers] When will I receive returned Landsbe products after the refunds are approved by Landsbe?	Returned Landsbe products that have been checked by the Warehouse team and approved for refunds will be shipped back to sellers on a weekly basis. 	seller
2	[Return Refund for Sellers] What should I do if I have not received the return parcel from the buyer as expected?	If you have yet to receive the return parcel from the buyer as expected, you may contact the logistics provider handling the return parcel to check with them directly on the status of the return	seller
4	[Seller Basics] What happens when I reject the buyer’s cancellation request?	Understand that there may be various reasons on why a buyer would like to request for cancellation. If you have shipped out the order, it is best for you to reject the cancellation request and chat to inform the buyer about the delivery of their parcel. However, if you have not shipped the item, it may be best for you to accept their cancellation request if they would like to modify their address or change variation of the order.	seller
9	TEst	test only	seller
\.


--
-- Data for Name: feature_group_editor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feature_group_editor (feat_id, group_id) FROM stdin;
5	\N
6	\N
7	
8	
9	
10	
11	
12	
4	
2	ed353a2e-1254-4406-91ad-b921670ea183
3	ff3ec288-119f-4acc-8355-e55ada7e49f1
1	79ee2231-bdb5-4e63-bd03-0b8b09f8b53a
\.


--
-- Data for Name: form_group_tutorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.form_group_tutorial (id, step, text) FROM stdin;
5	6	You made it,now share this group out to as many people as possible!  We will share the group on the site along with you sharing it out to your network.  Bigger is definitely better when it comes to your buying group.
6	5	Congrats! Your group has been formed! The next step is for Landsbe to approve your group and they will start looking for a seller. Once approved, please help us fill the group by sharing this with everyone you know!
4	4	You are almost there! Fill in the number of items you want to purchase along with the seller you’d like to work with (totally optional). The group size will grow and change, but a seller will typically give you a better deal if the group size is larger.
3	3	Now, tell the seller what you want to pay for this product. You put in what you are willing to pay and we will work with the seller to get as close to that as we can. We also want to know when you’d like to receive this item. Groups can take minutes or weeks to fill up, so just let us know how long you are willing to wait for a great deal.
2	2	Looks like you didn’t find what you were looking for on the site. No problem, let’s get started on your own group! Below, you can list the specific product you want. It will be super helpful if you can provide a link from another site with the product information. Once we have it, we’ll reach out to the seller you suggested and our seller network on your behalf to start negotiating the best deal for you and everyone else in the group.
1	1	We have tons of great product groups on the site. Take a look at what we have and see if they match what you are looking for. If you can’t find what you are looking for, form a group to get the exact product you want.
\.


--
-- Data for Name: group_insights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_insights (insight_uuid, group_id, user_id, insight, rating, datetime_created, datetime_modified) FROM stdin;
b7d2bfa5-6f9b-4d2d-8afc-cf75eff126f9	72b8ee43-cf44-464a-ad5f-496a9396a3ab	3a661f4d-f630-437d-842c-ea9f9b9e7cca	Hey	4	2022-02-24 06:15:45.704635	2022-02-24 06:15:45.704635
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_members (group_id, user_id, update_only, datetime_created, datetime_modified, qty, size_variant) FROM stdin;
9130646e-92e8-4a5e-aaae-89f740856bc8	3a661f4d-f630-437d-842c-ea9f9b9e7cca	t	2022-02-15 07:40:20.79652	2022-02-15 07:40:20.79652	0	\N
8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	t	2022-02-17 07:51:16.469396	2022-02-17 07:51:16.469396	0	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	46056b5e-3e3f-40ce-8477-8d3dcc19f006	f	2022-03-01 01:27:17.197572	2022-03-01 01:27:17.197572	1	\N
ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-02-09 06:07:32.659356	2022-02-09 06:07:32.659356	1	\N
9a398999-4cb9-4f15-a411-1ebd5bc21eff	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-02-10 09:48:13.908924	2022-02-10 09:48:13.908924	1	\N
1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-01 08:55:30.389235	2022-03-01 08:55:30.389235	1	\N
6418c466-d98d-46de-a265-e198d654729f	3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	2022-02-18 09:51:07.114377	2022-02-18 09:51:07.114377	1	\N
6418c466-d98d-46de-a265-e198d654729f	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-02-21 09:44:39.319789	2022-02-21 09:44:39.319789	2	\N
7934d13e-087a-4831-85cb-c8a163a67bfb	46056b5e-3e3f-40ce-8477-8d3dcc19f006	f	2022-03-02 07:50:32.670093	2022-03-02 07:50:32.670093	1	\N
ac93d3c3-3628-4014-b0c7-12a68629ce30	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-03 06:08:49.12452	2022-03-03 06:08:49.12452	1	\N
58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-03 08:49:47.468004	2022-03-03 08:49:47.468004	1	\N
9a398999-4cb9-4f15-a411-1ebd5bc21eff	3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	2022-02-15 02:44:46.317377	2022-02-15 02:44:46.317377	1	\N
7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	f	2022-03-07 03:27:11.162382	2022-03-07 03:27:11.162382	1	\N
bb63e9ba-0156-46bf-84a6-d72e0d874503	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-02-23 06:15:06.475651	2022-02-23 06:15:06.475651	1	\N
606ed0f4-9106-49c4-9efb-b0a49e098bba	8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	f	2022-02-23 08:17:51.312656	2022-02-23 08:17:51.312656	1	\N
1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	2022-03-08 08:50:53.185817	2022-03-08 08:50:53.185817	1	\N
d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-09 03:14:00.957098	2022-03-09 03:14:00.957098	1	\N
daeaf235-ad9f-4bcb-901f-15f6af6e1904	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-09 08:18:13.411554	2022-03-09 08:18:13.411554	1	\N
894a997f-eb11-4dec-982a-f0066c64323d	bf9c540e-60b9-406c-a82a-c1859adf5d7d	f	2022-03-09 08:29:24.698872	2022-03-09 08:29:24.698872	1	\N
7aac7a92-5376-484d-8fe9-a786e477f6a9	bf9c540e-60b9-406c-a82a-c1859adf5d7d	f	2022-03-09 09:03:17.471936	2022-03-09 09:03:17.471936	1	\N
7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-02-24 04:27:46.121629	2022-02-24 04:27:46.121629	1	\N
7aac7a92-5376-484d-8fe9-a786e477f6a9	968f0310-c811-4737-93bc-895610a8a7e3	f	2022-02-24 06:45:20.19492	2022-02-24 06:45:20.19492	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	968f0310-c811-4737-93bc-895610a8a7e3	f	2022-02-24 07:08:55.062199	2022-02-24 07:08:55.062199	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	f	2022-02-28 02:30:52.818724	2022-02-28 02:30:52.818724	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-14 08:07:49.786417	2022-03-14 08:07:49.786417	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	6ef390e4-2fd3-4266-aaa6-54dca52a334a	f	2022-03-14 08:21:44.143332	2022-03-14 08:21:44.143332	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	2e09fd10-807f-4b82-8722-c27d2c280b0d	f	2022-03-15 02:34:17.167101	2022-03-15 02:34:17.167101	1	\N
1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	46056b5e-3e3f-40ce-8477-8d3dcc19f006	f	2022-03-15 05:38:17.54083	2022-03-15 05:38:17.54083	1	\N
f6a2c267-ec63-4acc-b6ab-22274c80ef21	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-17 05:11:05.339417	2022-03-17 05:11:05.339417	1	\N
72b8ee43-cf44-464a-ad5f-496a9396a3ab	3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	2022-03-17 08:47:54.194616	2022-03-17 08:47:54.194616	1	\N
894a997f-eb11-4dec-982a-f0066c64323d	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-17 08:55:06.084339	2022-03-17 08:55:06.084339	1	\N
1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-03-18 09:39:03.616834	2022-03-18 09:39:03.616834	1	\N
894a997f-eb11-4dec-982a-f0066c64323d	3a661f4d-f630-437d-842c-ea9f9b9e7cca	t	2022-03-30 09:27:45.9487	2022-03-30 09:27:45.9487	0	\N
79ee2231-bdb5-4e63-bd03-0b8b09f8b53a	79b69f8f-c2a8-45f0-aad7-7932b462a3af	f	2022-04-27 09:04:22.093841	2022-04-27 09:04:22.093841	1	\N
ff3ec288-119f-4acc-8355-e55ada7e49f1	e498f885-498f-4a95-afa0-9370f4a6a866	f	2022-05-02 08:23:16.299092	2022-05-02 08:23:16.299092	1	\N
\.


--
-- Data for Name: group_notification_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_notification_counter (group_id, sevendaysleft, id) FROM stdin;
72b8ee43-cf44-464a-ad5f-496a9396a3ab	0	bdfefde2-5be6-4c7b-994d-e1a6497ed039
ed353a2e-1254-4406-91ad-b921670ea183	0	867e0be1-ef8f-4f20-a5cd-d67bf47d5834
ff3ec288-119f-4acc-8355-e55ada7e49f1	1	969a7efd-7243-4db0-b257-191dc32a63b2
\.


--
-- Data for Name: group_suggestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_suggestions (suggestion_uuid, proposer_id, status, datetime_created, datetime_modified, suggested_price, srp, product, group_size, price_deadline, anonymous, preferred_seller, preferred_seller_email) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (group_uuid, group_name, supplier_id, active, ready_for_checkout, datetime_created, datetime_modified, price, group_deadline, product_id, slots, formed_by, proposer_id, anonymous, margin_pct, ended, private, size_variants, date_closed, closed, delivery_timeframe, in_stock) FROM stdin;
7f84baf0-db8d-42b9-a4f7-efd64a99223b	Heavy Blend 8 oz. 50/50 Hood (G185)	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-02-02 05:15:05.190691	2022-02-16 07:39:25.362902	11	2022-02-15 23:59:59	f6e7d864-150a-4698-82cb-57efecf373b9	20	seller	\N	\N	10	t	f	{"{\\"size\\":4,\\"quantity\\":\\"5\\",\\"group\\":2}","{\\"size\\":5,\\"quantity\\":\\"5\\",\\"group\\":1}","{\\"size\\":6,\\"quantity\\":\\"5\\",\\"group\\":1}","{\\"size\\":3,\\"quantity\\":\\"5\\",\\"group\\":1}"}	\N	f	\N	t
9130646e-92e8-4a5e-aaae-89f740856bc8	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-17 01:46:50.326041	2022-02-26 17:33:42.402768	2.2	2022-02-26 08:59:00	6805751f-265f-41f1-bc9b-8fc99f87e76d	10	seller	\N	\N	10	t	f	\N	\N	f	\N	t
addeca20-ab9f-4827-bfbc-1b9693ae8c16	Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed)	c1cfcbbf-2ec9-4966-8849-277852afa41a	f	f	2021-11-15 01:34:31.011049	2022-02-09 05:12:12.69716	10	2022-01-15 01:33:26	4dd718a3-5217-4762-9749-72e782921be5	100	seller	\N	\N	10	f	f	\N	\N	f	\N	t
4b510ca6-d72b-498c-849b-d2bad41d258e	Clear Glass Beer Cups – 6 Pack – All Purpose Drinking Tumblers, 16 oz – Elegant Design for Home and Kitchen – Great for Restaurants, Bars, Parties – by Kitchen Lux	c1cfcbbf-2ec9-4966-8849-277852afa41a	f	f	2021-11-16 08:04:04.502147	2022-02-09 08:18:49.955068	99	2021-11-20 06:12:25	6c936fce-8222-47b5-819d-504fc9207d44	100	seller	\N	\N	10	t	f	\N	\N	f	\N	t
1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	adidas	\N	f	f	2022-03-01 08:55:30.074008	2022-03-04 09:24:34.261207	10	2022-03-31 09:59:59	e04728f4-eebf-439d-9c4b-63b7fbf4e384	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	f	t	\N	\N	f	\N	t
ed353a2e-1254-4406-91ad-b921670ea183	adidas mens Release 2 Structured Stretch Fit Cap	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-04-04 01:53:33.205012	2022-04-04 01:53:33.205012	27.5	2022-06-04 09:59:59	25c1f995-258e-4c6e-a865-a22ed3f25cad	25	seller	\N	\N	10	f	f	\N	\N	f	\N	t
22851185-d78b-47b0-8ebb-eff9d2c81686	Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-26 02:25:52.872165	2022-02-09 08:21:45.316541	99	2021-12-25 19:25:52	12d1306a-02c4-46d1-a138-6a153f5fd1d6	55	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	10	t	f	\N	\N	f	\N	t
20083f02-7ea1-40f5-9770-c2ce95aa1f3f	PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-23 09:27:57.958887	2022-02-15 01:03:58.316159	1.1	2022-02-14 08:59:59	5b2b15cc-b3b4-4423-b672-f562c0fa65cb	111	user	e498f885-498f-4a95-afa0-9370f4a6a866	f	10	t	f	\N	\N	f	\N	t
983cbe4f-72f2-4b05-b951-0c13e9494089	London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	c1cfcbbf-2ec9-4966-8849-277852afa41a	f	f	2022-01-07 01:32:05.826983	2022-02-09 05:12:12.69716	1	2022-03-07 08:59:59	31e559de-7092-4127-b29b-77cc5c5ed39f	10	seller	\N	\N	10	f	f	\N	\N	f	\N	t
078ea51f-cc55-4045-a093-5caaf0eb24d2	Smart WiFi Light Bulbs, LED Color Changing Lights, Works with Alexa & Google Home, RGBW 2700K-6500K, 60 Watt Equivalent, Dimmable with App, A19 E26, No Hub Required, 2.4GHz WiFi (4 Pack)	3a661f4d-f630-437d-842c-ea9f9b9e7cca	t	f	2022-01-07 03:43:37.74304	2022-02-09 05:38:27.752989	1.1	2022-01-15 08:59:59	b1f6dcba-a7c9-4ad0-813e-fe7cd2d8c149	1	seller	\N	\N	10	t	f	\N	\N	f	\N	t
8f7c1af8-dcac-422e-b7ba-5ee6726e386d	Playstation DualSense Wireless Controller	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-12-22 05:51:50.825768	2022-02-23 01:53:15.837741	1	2022-02-22 08:59:59	8f4c491a-225b-4035-aed7-60838092a99e	100	seller	\N	\N	10	t	f	\N	\N	f	\N	t
39ed0dd2-5583-410b-ab87-f1b94ac7e864	gaming mouse	\N	t	f	2021-11-25 02:14:27.509084	2022-02-09 05:38:27.753149	100	2021-12-10 08:59:59	e5b625a1-058e-4ed7-9c17-9546ee953078	50	user	\N	\N	10	t	f	\N	\N	f	\N	t
0be98f39-861e-4d53-b118-3aa7c6517393	SAMSUNG 870 QVO SATA III 2.5" SSD 1TB (MZ-77Q1T0B)	\N	t	f	2021-12-10 05:06:33.638129	2022-02-09 05:38:27.753119	1	2022-01-08 22:06:33	8e36c653-ba38-47ef-ab10-2c17c25f925d	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	\N	t	f	\N	\N	f	\N	t
f1e04ca3-8f4f-4db7-9209-a1a27d2ee221	AMD Ryzen 7 5800X 8-core, 16-Thread Unlocked Desktop Processor	\N	t	f	2021-11-23 08:38:32.489354	2022-02-09 05:38:27.759779	1	2021-12-23 01:38:32	5b040d23-a445-4697-9caa-5a36edc35f69	50	user	a5c5171b-1331-474a-82f7-2876fb3843a1	f	10	t	f	\N	\N	f	\N	t
69eaf7c3-2fd7-4340-a1be-3b6e093e2182	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	e498f885-498f-4a95-afa0-9370f4a6a866	t	f	2021-11-17 01:45:33.431338	2022-02-09 05:38:27.758457	1	2021-11-22 02:16:13	4237530d-65fb-4bcb-b596-b37612f0d95b	1	seller	\N	\N	10	t	f	\N	\N	f	\N	t
ffeab45a-6598-4ea9-ab66-f8669e6789bc	SAMSUNG 870 EVO 1TB 2.5 Inch SATA III Internal SSD (MZ-77E1T0B/AM)	\N	t	f	2021-11-26 02:26:59.271745	2022-02-09 05:38:27.763338	1	2021-12-25 19:26:58	d090f8f1-89fe-49be-b1d8-d49ff5dedfd3	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	10	t	f	\N	\N	f	\N	t
fab27682-ebd6-4751-8dda-bc8ecf777047	Coffee++ Program 11oz Coffee Mug Nerd Engineer Idea for Men Science Mug Great Gag for Programmer Geeks Computer Science Developers Coders Ceramic Tea Mugs For Adults - By AW Fashions	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-09 05:35:21.399816	2022-02-09 05:58:27.835704	11	2022-01-09 05:34:32	c903f609-33b3-4aa7-98a7-03fa38358ab8	25	seller	\N	\N	10	t	f	\N	\N	f	\N	t
62cf23e6-8e09-4c8a-9e93-bf8c7ecc4280	Star Wars The Child Plush Toy, 8-in Small Yoda Baby Figure from The Mandalorian, Collectible Stuffed Character for Movie Fans of All Ages, 3 and Older	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-23 09:16:25.315076	2022-02-09 08:18:20.185299	11	2021-12-23 08:59:59	334fa9d7-0294-4f40-a86e-2263897599fd	100	seller	\N	\N	10	t	f	\N	\N	f	\N	t
1a8a6062-32ee-48d0-b122-24bc8a3dfda8	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	\N	t	f	2021-12-17 06:37:59.176456	2022-03-03 05:39:00.940513	1	2022-01-16 08:59:59	03bad356-71fc-4517-a907-542b06a0cac3	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	\N	t	t	\N	\N	f	\N	t
a21ca74c-0f77-40b1-ba67-d086de641f73	ps5	\N	f	f	2021-12-23 06:51:53.376831	2022-03-25 06:03:48.23123	1	2022-01-22 08:59:59	2bf7d30f-c2df-4ae0-9863-7f154e28b550	50	user	\N	\N	10	f	f	\N	\N	f	\N	t
24fa7a33-054d-45b1-8cdc-7bc8dc394921	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	\N	t	f	2021-11-11 09:06:39.079192	2022-03-03 05:39:00.947272	15	2022-01-11 02:06:38	0eaa4389-67ec-405f-b32f-d67596c5cac2	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	t	\N	\N	f	\N	t
786f3d4b-7c93-4c02-9627-6906cd4e53da	ps5	\N	f	f	2021-12-23 06:50:38.454341	2022-03-25 07:59:02.228621	75	2022-01-22 08:59:59	50cf79f5-e72f-45ad-9c6e-eb01080c343a	50	user	\N	\N	10	f	f	\N	\N	f	\N	t
493964a2-3c01-49a9-8f06-7438eb8dd53f	External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook	\N	f	f	2021-12-10 05:48:51.566178	2022-03-04 09:18:51.834802	1	2022-01-08 22:48:51	6395b33e-0ea8-43f5-afae-a2939c20d1d5	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	10	t	t	\N	\N	f	\N	t
bb63e9ba-0156-46bf-84a6-d72e0d874503	PlayStation DualSense Wireless Controller – Midnight Black 	46056b5e-3e3f-40ce-8477-8d3dcc19f006	t	f	2021-11-25 02:12:14.878249	2022-03-07 02:52:54.330455	1.1	2022-02-23 08:59:59	0f85b11a-ed86-4140-ab76-b7e082814b61	50	user	\N	\N	10	t	f	\N	\N	f	\N	t
894a997f-eb11-4dec-982a-f0066c64323d	RK ROYAL KLUDGE RK61  (Blue Switch, White)	\N	t	f	2022-03-09 08:29:24.19961	2022-04-08 08:37:27.418434	51.99	2022-04-08 02:29:23	61227adb-77ae-42e7-97c6-5419beac227f	50	user	bf9c540e-60b9-406c-a82a-c1859adf5d7d	f	10	t	f	\N	\N	f	\N	t
606ed0f4-9106-49c4-9efb-b0a49e098bba	ps5 with seller	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-12-23 07:38:33.480065	2022-03-14 00:47:36.529244	1	2022-03-12 08:59:00	15cb120a-3ec4-4468-b4ed-d06b11eb5960	100	seller	\N	\N	10	t	f	\N	\N	f	\N	t
ec5cd42f-0370-4cfb-8eb7-2206522415ac	DC DCSC Mens Jacket	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-01-27 03:00:23.207988	2022-02-09 06:08:11.073583	1.1	2022-02-15 23:59:59	6fa2804f-ee55-4f76-8551-26a468c3b546	2	seller	\N	\N	10	t	f	\N	2022-02-08 23:08:11.068	t	\N	t
6bafa6db-0824-4396-bad5-dfc2fc11821e	Amazon Basics XXL Gaming Computer Mouse Pad - Black	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-19 05:14:33.740127	2022-02-09 08:21:14.479268	5.5	2022-01-16 02:47:54	8508b215-d072-4dab-a526-4e6ecf00148a	100	seller	\N	\N	10	t	f	\N	\N	f	\N	t
79ee2231-bdb5-4e63-bd03-0b8b09f8b53a	Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-04-04 01:54:50.023323	2022-04-30 23:07:44.543068	9776.8	2022-04-30 09:59:59	94ef0319-2309-4e72-972e-0896e9709e1d	88	seller	\N	\N	10	t	f	\N	\N	f	\N	t
58d841e3-cd1c-433a-a239-924ea22d0b7d	this is a test	\N	f	f	2022-03-03 08:49:47.227583	2022-05-03 05:00:02.713963	10	2022-04-02 09:59:59	d00dd8df-d033-4a04-a0f6-22521d73df7d	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	t	\N	\N	f	\N	t
9a398999-4cb9-4f15-a411-1ebd5bc21eff	APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-12 08:19:32.010801	2022-02-17 00:58:55.119316	17.6	2022-02-16 08:59:00	91d8eb82-3946-4e0e-bfea-d07cd7575bb9	90	seller	\N	\N	10	t	f	\N	\N	f	\N	t
72b8ee43-cf44-464a-ad5f-496a9396a3ab	Timberland Short Watch Cap	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-01-07 08:21:20.828779	2022-04-05 08:16:05.7823	11	2022-05-28 09:59:00	537066b1-62e3-49b3-94d5-4dd8665ac39c	10	seller	\N	\N	10	f	f	\N	\N	f	\N	t
64d16f21-7709-4097-986f-43cc951b24e3	Intel Core i7-10700K Desktop Processor 8 Cores up to 5.1 GHz Unlocked LGA1200 (Intel 400 Series Chipset) 125W (BX8070110700K)	\N	t	f	2021-12-10 05:14:35.416697	2022-03-03 05:39:00.946004	1	2022-01-08 22:14:35	bcab40f4-f303-4d76-9081-c20ac241c6a2	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	\N	t	t	\N	\N	f	\N	t
a97032c6-a5e1-451d-af4e-7371123beb1d	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-12-17 06:49:01.857088	2022-03-03 05:39:00.946817	11	2022-01-16 08:59:59	585c9180-9626-41be-b6a5-1deaa60a9bc7	100	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	t	\N	\N	f	\N	t
6418c466-d98d-46de-a265-e198d654729f	Amazon Essentials Men's Heavyweight Hooded Puffer Coat	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-01-26 08:55:18.87052	2022-03-07 05:15:19.063025	22	2022-03-13 23:59:59	3f6b6b96-383e-4b71-bb5b-f493d0fe83e7	115	seller	\N	\N	10	t	f	\N	2022-03-06 22:15:19.058	t	\N	t
7cbe5585-30ae-48fd-ab85-1153fe51231b	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	c1cfcbbf-2ec9-4966-8849-277852afa41a	f	f	2021-11-16 05:13:12.362054	2022-02-09 05:12:12.69716	20	2022-01-16 05:11:58	2a26beba-9511-422f-8710-2dcbce344a8f	100	seller	\N	\N	10	f	f	\N	\N	f	\N	t
3949b32d-7c71-4f57-91f0-2ddf97e86007	Crucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	\N	t	f	2022-01-07 05:49:32.374896	2022-02-09 05:38:27.753117	11	2022-02-05 21:59:00	66be9259-cea3-48f4-aeb9-2353cabf297c	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	f	10	t	f	\N	\N	f	\N	t
60181685-b4b7-4bab-b0a3-431648ea5fb9	VERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	\N	t	f	2022-01-07 05:47:16.565443	2022-02-09 05:38:27.757688	440	2022-02-08 22:00:00	ffb103c7-fd32-406e-bda8-5bfe0cc01919	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	f	10	t	f	\N	\N	f	\N	t
d977f086-9d97-48df-a1c7-4de273da77bc	Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	t	2022-01-26 09:10:24.066708	2022-03-09 03:16:14.074263	1050.5	2022-03-15 23:59:59	b8fa70a4-d5ec-4523-9907-d5789b9f659a	25	seller	\N	\N	10	t	f	\N	2022-03-08 20:15:18.41	t	\N	t
7aac7a92-5376-484d-8fe9-a786e477f6a9	test	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-01-26 08:58:20.456262	2022-03-10 22:35:00.211539	1.1	2022-03-10 08:59:59	5a9f5de2-5850-4151-8896-18ea39794357	11	seller	\N	\N	10	t	f	\N	\N	f	\N	t
c17ed577-61ee-4a89-a53d-aca696579c70	WD 5TB My Passport Portable External Hard Drive HDD, USB 3.0, USB 2.0 Compatible, Black - WDBPKJ0050BBK-WESN	\N	t	f	2021-12-10 05:21:17.193174	2022-03-03 05:39:00.946466	1	2022-01-08 22:21:16	eff8b235-ecd2-4123-8cad-317d7fcc2641	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	\N	t	t	\N	\N	f	\N	t
4edebef1-0e36-4562-8477-2d233b2c49aa	L.O.L. Surprise Dolls Sparkle Series A, Multicolor	\N	t	f	2021-12-10 05:35:01.538223	2022-03-03 05:39:00.947534	50	2022-01-08 22:35:01	fd9289f9-4e48-4dea-bb62-6863a556780c	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	\N	t	t	\N	\N	f	\N	t
81173910-3995-4ae7-aacb-7f19330036c9	L.O.L. Surprise Dolls Sparkle Series A, Multicolor	\N	t	f	2021-12-10 05:31:19.019815	2022-03-03 05:39:00.947759	50	2022-01-08 22:31:18	fd9289f9-4e48-4dea-bb62-6863a556780c	50	user	826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	\N	t	t	\N	\N	f	\N	t
1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	46056b5e-3e3f-40ce-8477-8d3dcc19f006	t	f	2022-03-03 06:17:58.580764	2022-04-03 01:07:38.682861	15.62	2022-04-02 09:59:59	1ae3c3f4-fba8-4c13-8fd7-aaf847071d20	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	f	\N	\N	f	\N	t
184e978e-9c9f-4ef7-bc57-47022f7b2ece	BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2021-11-18 08:20:48.865114	2022-02-09 05:14:30.104316	25	2021-11-30 05:49:13	e53171fd-ddbc-44cc-955b-1c76e1a2eddb	5	seller	\N	\N	10	t	f	\N	\N	f	\N	t
7246040a-c6cd-4ade-9e66-1ab3862a41d7	test	46056b5e-3e3f-40ce-8477-8d3dcc19f006	t	f	2021-11-25 02:48:43.037969	2022-02-09 05:38:27.759233	1.1	2022-01-08 08:59:59	f6e7165f-f710-42b6-b3d0-86917f4fea59	50	user	\N	\N	10	t	f	\N	\N	f	\N	t
8e50bfc3-41ff-4055-adda-2da6ec29f3ea	Sheoolor Quiet Essential Oil Diffuser, 200ml Vintage Vase Aromatherapy Diffuser with Waterless Auto Shut-Off Function & 7-Color LED Changing Lights Diffuser for Essential Oils, for Home, Office, Yoga	46056b5e-3e3f-40ce-8477-8d3dcc19f006	t	f	2021-11-25 02:46:55.715492	2022-02-09 05:38:27.759413	25.99	2021-12-11 08:59:59	03a67472-2c18-416f-8344-9eed04b88e5a	10	seller	\N	\N	10	t	f	\N	\N	f	\N	t
60873237-4c79-43bb-aa03-dd2dfb6ad55a	Fjallraven, Kanken Classic Backpack for Everyday, Graphite	\N	t	f	2021-12-23 06:41:08.700308	2022-02-09 05:38:27.757946	11	2022-01-29 21:59:00	e6852be3-522d-42a7-af78-d3a7c4899acc	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	f	10	t	f	\N	\N	f	\N	t
7934d13e-087a-4831-85cb-c8a163a67bfb	Grassman Camping Tarp, Ultralight Waterproof	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-03-02 07:50:32.416852	2022-04-27 07:01:46.730991	26.4	2022-04-15 09:59:00	a2bed0b3-c665-4e53-97d9-3a1c08a6ddb0	50	user	46056b5e-3e3f-40ce-8477-8d3dcc19f006	\N	10	t	t	\N	\N	f	2-3 days	f
daeaf235-ad9f-4bcb-901f-15f6af6e1904	adidas	\N	t	f	2022-03-09 08:18:12.848996	2022-04-27 07:01:46.734378	9	2022-04-08 02:18:12	e04728f4-eebf-439d-9c4b-63b7fbf4e384	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	f	10	t	t	\N	\N	f	\N	t
f6a2c267-ec63-4acc-b6ab-22274c80ef21	this is a test	\N	t	f	2022-03-17 05:11:05.037185	2022-04-27 07:01:46.734276	14.4	2022-04-16 09:59:59	f40e8dce-7f7b-442b-b3cb-e450bef6e0fc	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	t	\N	\N	f	\N	t
ff3ec288-119f-4acc-8355-e55ada7e49f1	test shirt	c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	2022-03-21 08:59:18.548815	2022-05-02 09:32:12.573929	1.1	2022-05-06 09:59:00	9c93acf4-403e-4833-b6aa-a46073e589ea	22	seller	\N	\N	10	f	f	\N	\N	f	2-3 days	f
ac93d3c3-3628-4014-b0c7-12a68629ce30	jkghghgjg	\N	f	f	2022-03-03 06:08:48.824509	2022-05-03 05:00:06.74638	10	2022-04-02 09:59:59	72d2ada9-ad21-4fb8-b4e4-ad16f64dab5a	50	user	e498f885-498f-4a95-afa0-9370f4a6a866	\N	10	t	t	\N	\N	f	\N	t
\.


--
-- Data for Name: homepage_edit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.homepage_edit (id, place, text, image) FROM stdin;
2	2	Save Together	
3	3	Form a group and share it with your friends or Join an existing group. Either way, the more we work together, the more we save!	
1	\N	Buy Together ...	\N
\.


--
-- Data for Name: how_it_works; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.how_it_works (id, place, text, image, type) FROM stdin;
1	1	Landsbe is the place where you can tell product sellers what you want, how much you want to pay and how long you are willing to wait.  Not only that but you can also share your group with all your friends so that they can get a great deal too!  Landsbe lets you organize your demand first so that everyone gets a great deal. So here’s how you do it. TEST\n		form
17	lower	Know that we will never process your payment until we have confirmation from the seller that your product has shipped. If you missed a group don’t worry you can clone a past group in a couple easy steps and be off and running again!		join
18	upper	Joining a group is easy! Just follow the steps outlined below.		join
7	\N	Landsbe gives you the opportunity to join or monitor any of our buying groups. The bigger the group the bigger the potential savings!	\N	\N
8	\N	Know that we will never process your payment until we have confirmation from the seller that your product has shipped. If you missed a group don’t worry you can clone a past group in a couple easy steps and be off and running again!	\N	\N
45	\N	Got questions?	\N	bottom-section
46	\N	<p><span style="color: rgb(0,0,0);font-size: 16px;font-family: Titillium Web;">Send an email or give us a call, we will help you each step of the way.</span></p>\n<p></p>\n	\N	bottom-section
12	\N	Landsbe gives you the opportunity to join or monitor any of our buying groups. The bigger the group the bigger the potential savings!	\N	\N
13	\N	Know that we will never process your payment until we have confirmation from the seller that your product has shipped. If you missed a group don’t worry you can clone a past group in a couple easy steps and be off and running again!	\N	\N
43	3	Once you’re approved, you’ll be able to view and bid on buyer groups that have formed as well as form a seller group that will then be scheduled into one of our seller group spots.	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b6069325-ba93-4016-9592-2fff253ebc39/howitworksImg.png	sell
2	2	Your group is not limited to just your friends, anyone can join it just as you can join anyone else’s group.  The bigger the groups the higher the potential savings!  \nOnce your group has been approved we negotiate on your behalf with the seller. If we have multiple sellers they will bid on the group so that we can always get you the best price possible.		form
32	3	Pick your quantity, put in your payment information and that’s it!  Make sure you share the group out to your network just in case one of your friends wants to join as well. We will keep you posted as the group fills up and the seller gets ready to ship your product.	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2a076d48-90d5-41b6-b937-3c30609dae56/howitworksImg.png	join
34	1	Click on the join a group button and search our buying groups to see what we have on the site.	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/334a6bb1-450a-4fed-b3ab-611c8db380b7/howitworksImg.png	join
33	2	Once you have found a group, join it! Or, if you aren’t quite ready, click “Keep me posted” and we will, well, keep you posted.	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/59bd4dbc-88a4-4afd-a82a-09da085fd295/howitworksImg.png	join
29	2	Put in the name of the product you want and then provide a link to the specific product so we know which seller to start contacting on your group's behalf. We contact many different sellers to make sure we get the group the best price possible. 	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/906d68b6-e92a-4196-a4e2-6c44b7bb67f0/howitworksImg.png	form
39	2	Are you looking for a way to sell your products that allows you to build significant economies of scale while protecting the environment and delivering value to your customers? Well, look no further. Landsbe is the place that delivers all of this and more.  Here's how you join our seller community. 		sell
28	1	Click on the form a group button and search to see if we have what you are looking for. If we do, join that group, if we don’t then form a group of your own!	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b43b11b9-a052-441d-8239-fa765c3af006/howitworksImg.png	form
31	4	The last step is to set your quantity and, if you have it, you can provide the name of the seller (this is totally optional). Now you can finalize your group and share it with everyone you know. \n	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ea86bc28-867a-4da1-8660-836e43c0040e/howitworksImg.png	form
30	3	In this screen you put in the price you would be willing to pay and set the time frame for how long the group will be available.  	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/73a589f4-61b9-4194-a5d0-833df65c8044/howitworksImg.png	form
38	1	That's it, joining the Landsbe community as a seller is simple.  We can't wait to work with you!		sell
42	1	Click the Login button and select "seller" account	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/30cd8d9f-631b-4fc9-9cf0-28191c4c010a/howitworksImg.png	sell
44	2	Complete the form fill and submit your application to us. Once it's been reviewed, we'll send you an email with next steps.	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e9bfd259-26e9-4bc7-b972-19d6be9083c7/howitworksImg.png	sell
\.


--
-- Data for Name: invited_sellers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invited_sellers (id, invited_site_url, invited_site_email, status, tags) FROM stdin;
1	www.puetzgolf.com	customerservice@puetzgolf.com	f	\N
3	www.2ndswing.com	service@2ndswing.com	f	\N
6	www.titleist.com	salesmy@acushnetgolf.com	f	\N
71	harddiskdirect.com	support@harddiskdirect.com	f	\N
153	www.neqtiq.com	cs@neqtiq.com	f	\N
5	www.lostgolfballs.com	customerservice@lostgolfballs.com	f	\N
7	mycustomgolfball.com	contact@mycustomgolfball.com	f	\N
4	www.golfdiscount.com	sales@golfdiscount.com	f	\N
72	www.tigerdirect.com	customerservice@tigerdirect.com	f	\N
94	drivesolutions.com	purchasing@drivesolutions.com	f	\N
154	optimumdrives.com	sales@optimumdrives.com	f	\N
8	www.moderngenauto.com	sales@moderngenauto.com	f	\N
73	www.neobits.com	customercare@neobits.com	f	\N
95	www.sabrepc.com	sales@sabrepc.com	f	\N
155	www.quietpc.com	jannine@quietpc.com	f	\N
200	www.shopsaitech.com	sales@shopsaitech.com	f	\N
9	www.pgatoursuperstore.com	customerservice@pgatss.com	f	\N
74	www.elitewarehouse.com	sales@elitewarehouse.com	f	\N
10	www.globalgolf.com	questions@globalgolf.com	f	\N
29	www.4imprint.com	administrator@4imprint.com	f	\N
75	serverevolution.com	hi@serverevolution.com	f	\N
97	www.pcnation.com	pcnationcares@pcnation.com	f	\N
202	motherboardspares.com	info@motherboardspares.com	f	\N
76	www.allhdd.com	support@allhdd.com	f	\N
158	www.servers4less.com	sales@servers4less.com	f	\N
181	www.govgroup.com	sales@govgroup.com	f	\N
203	the-hidden-mountains.com	thehiddenmountains@yahoo.com	f	\N
12	www.titleist.com	mytitleist@titleist.com	f	\N
77	www.compbargains.com	sales@compbargains.com	f	\N
99	www.colamco.com	govsales@colamco.com	f	\N
204	directmacro.com	support@directmacro.com	f	\N
78	www.techinn.com	support@tradeinn.com	f	\N
100	www.provantage.com	Subscriber@provantage.com	f	\N
79	www.cpumedics.com	rma@cpumedics.com	f	\N
162	www.ideastage.com	artwork@ideastage.com	f	\N
206	www.visioncomputers.com	support@visioncomputers.com	f	\N
80	www.deals499.com	sales@deals499.com	f	\N
17	bigamart.com	contact@bigamart.com	f	\N
18	foofster.com	Support@Foofster.com	f	\N
122	www.golfballs.com	service@golfballs.com	f	\N
168	www.carlsgolfland.com	carlsservice@carlsgolfland.com	f	\N
26	www.grotonvalleytraders.com	phil@grotonvalleytraders.com	f	\N
91	www.sears.com	bitshopusa@gmail.com	f	\N
2	www.greatgolfmemories.com	info@greatgolfmemories.com	f	\N
92	transparent-uk.com	sales@transparent-uk.com	f	\N
\.


--
-- Data for Name: legalities_editor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.legalities_editor (l_id, place, text, type) FROM stdin;
1		<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>General</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Landsbe website and online applications that are available to you (together the “Site”) are available for use under these Terms and Conditions (“Terms”). As used in these Terms, “Landsbe,” “we,” or “us” shall include this website and any applications. Your use of the Site constitutes acceptance of these Terms. Please read these Terms carefully. If you do not accept these Terms, your use of this Site is not authorized. These Terms apply to your use of the Site in any manner, including on behalf of a buyer or a seller and in your business or personal capacity.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The collection and use of personal information on the Site are addressed in the Privacy Policy [insert link]</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>About Landsbe</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Landsbe is a cooperative marketplace that allows users to form buying groups to offer to purchase certain products from sellers or sellers to offer to sell to buyers or buying groups certain products with the intention of securing better pricing for buyers and quantities for seller. The actual contract for sale is directly between the seller and buyer. Landsbe is not a party to the transaction, but rather provides an electronic marketplace for the transactions to occur.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Fees and Taxes</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The seller is responsible for our fees, including merchant processing fees. The fees we charge are listed on our Landsbe seller fee chart (insert link here). We may change our seller fees from time to time by posting the changes on the Landsbe site 14 days in advance. If you are a seller, you are liable for transaction fees arising out of all sales made using our Site, even if sales terms are finalized or payment is made outside of Landsbe. In particular, if you offer or reference your contact information or ask a buyer for their contact information in the context of buying or selling outside of Landsbe, you may be liable to pay our fee given your usage of our Site for the introduction to a buyer.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You must have a payment method on file when buying or selling through our Site and pay all fees by the payment due date or offer acceptance date. If your payment method fails or your account is past due, we may collect amounts owed by charging other payment methods on file with us, retain collection agencies and legal counsel, and/or suspend or limit services. In addition, you will be subject to late fees. Landsbe, or the collection agencies we retain, may also report information about your account to credit bureaus, and as a result, late payments, missed payments, or other defaults on your account may be reflected in your credit report.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Payment and Returns</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Payment for products will be collected by Landsbe at the time an offer is extended and the offer is accepted. Thereafter, Landsbe will hold the funds and release them to the Seller upon verified notification that Seller has shipped the product to Buyers. Funds held by Landsbe will be in non-interest bearing accounts and may be comingled with other funds held for other buyers. Seller will be responsible for any discount fees for merchant services.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Returns option, if any, will be identified by Seller at the time of offer and acceptance. Returns will take place directly between Seller and Buyer and refunds will be paid to Buyer pursuant to terms agreed upon between the parties. It is the Buyer’s responsibility to read the terms of the offer between it and Seller.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Shipping</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Seller is responsible for all shipping and shipping costs. Shipping location shall be identified by the buyer or buyer group. Seller shall ship FOB as determined by buyer or buyer group or as agreed by the parties.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Use of Content; Submissions</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Site is copyright-protected. Unless otherwise stated, copyright or similar proprietary rights are reserved for all material presented on the Site, including but not limited to audio and video clips, graphics, and links. Unauthorized use of materials may violate copyright laws. All copyright and other proprietary notices in the original material must be retained on any copy you make of the original material. You may not sell, distribute, or publish any content you obtain from this Site other than permissible copying of your own account information or as may be otherwise authorized by Landsbe.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You shall not upload, enter, or submit any material or content to the Site that is subject to or may infringe the intellectual property or proprietary rights of any third party. You grant Landsbe a royalty-free, perpetual, irrevocable, non-exclusive right and license to use, copy, modify, display, archive, store, publish, transmit, distribute, and reproduce, and to create derivative works from, any and all content or information you post, upload, provide, or create using the Site for the limited purpose of providing Landsbe services. Permissible use shall include making information available to Landsbe buyers or potential buyers, information available from sellers or potential sellers, and/or selecting and ordering products through the Landsbe.</span></p>\n<p></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Rules of Conduct</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You agree to use the Site for lawful purposes only. You may not use this Site to transmit any content that Landsbe deems as abusive, vulgar, obscene, hateful, fraudulent, unlawful, threatening, harassing, or defamatory. Content includes, but is in no way limited to, content that is viewable by others on the Site, comments, and artwork. Any use of, or conduct relating to, this Site that is not authorized by these Terms is prohibited.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Links to External Websites</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Site may have links to external websites that are owned and operated by third parties. Landsbe makes no representation whatsoever regarding the content of any other websites that you may access from this Site. When linking to an external website, please understand that it is independent from Landsbe and we may have no control over the content on that website. A link to a non-Landsbe website does not mean that we endorse or accept any responsibility for its content or use. Landsbe does not guarantee the availability or accuracy of content on any website linking to our Site. It is the user’s responsibility to check each website for its own privacy statement and terms of use. Users rely on the data on such websites entirely at their own risk.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You may be allowed to establish a link from a website that is owned or controlled by you to our homepage, provided you do so in a way that is fair and legal and does not damage our reputation or take advantage of it, but you must not establish a link in such a way as to suggest any form of association, approval, or endorsement on our part without our prior written consent. You agree to cooperate with us in causing any unauthorized framing or linking immediately to stop. Landsbe reserves the right to withdraw linking permission without notice.</span></p>\n<h1><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Third-Party Information</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Site may contain information provided by third parties (e.g., Landsbe seller prices and product information). Landsbe is not responsible for information provided by third parties.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Availability and Services</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Landsbe’s goal is for continuous access, 24 hours per day, to our Site. However, there may be times when the Site is unavailable due to routine maintenance. Landsbe reserves the right at any time to modify or discontinue the Site or any features or components of the Site, temporarily or permanently, with or without notice, for any reason. Without limiting the foregoing, you agree that Landsbe, in its sole discretion, may terminate your access to the Site if Landsbe believes that you have violated the letter or spirit of these Terms. You agree that any termination of your access to the Site or any deletion of information may be effected without prior notice.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>IP Addresses</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We collect IP addresses (the internet address of a computer) and analyze this data for trends and statistics about page viewing frequency and sequence to improve our Site and the services we offer.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Cookies</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Landsbe uses cookies (text files placed on your hard drive by a web server) to monitor Site usage.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Copyright and Other Intellectual Property</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">All Landsbe trademarks, logos, or service marks displayed on this Site are the property of Landsbe. You must not use such marks without the prior written permission of Landsbe. All other names, logos, product and service names, designs, and slogans on the Site are the trademarks of their respective owners or licensors. Any unauthorized use or misuse of this intellectual property or unauthorized use of content on the Site will be subject to all appropriate remedies, including appropriate legal action.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Prohibited Conduct</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">In connection with your use of the Site you may NOT:</span><span style="font-family: Titillium Web;"> </span></p>\n<ul>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Sell or offer to sell any products which require a license;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Sell or offer to sell any products which are not legal or lawful to transport;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Deliver content that contains software viruses or any other code, files, or programs designed to damage or disrupt any software, hardware, or equipment;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Post, upload, or create any content that infringes the intellectual property rights, including copyrights, of others;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Upload any content containing an image, likeness, or audio or visual recording of an individual without permission to do so;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Post, upload, or create any content that violates any privacy rights of any individual;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Harm or harass any individual; or</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Do anything that gives rise to civil or criminal liability.</span></li>\n</ul>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">In addition, you may NOT:</span></p>\n<ul>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Attempt to modify or alter the Site;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Attempt to use the Site other than for its intended purposes;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Attempt (including through the use of any device, software, or routine) to interfere with the proper functioning of the Site;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Attempt to circumvent a technological measure that controls or impacts access to the Site;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Take any action that imposes, as determined within Landsbe’s sole discretion, an unreasonable or disproportionately large or otherwise overly burdensome load on the infrastructure or networks utilized by the Site;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Violate any applicable law or regulation in connection with the use of the Site; or</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Copy or distribute any content from the Site in any manner (including, but not limited to through the use of any manual process, device, or any robot, spider, or other automatic process), other than permissible copying from an account through the use of report or copying functionality provided by the Site and may not share, publish, or distribute any content from the Site other than permissible copying of your own account information or as otherwise authorized by Landsbe.</span><span style="font-family: Titillium Web;"> </span></li>\n</ul>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Limitations of Liability</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Landsbe does not guarantee that the Site or any services provided through the Site will be uninterrupted or error-free. Content and services are provided on an “as is,” as-available basis. Landsbe does not guarantee that any file available for downloading is free of viruses or similar contamination or destructive features.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">TO THE FULLEST EXTENT PERMITTED BY LAW:</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">(A) LANDSBE SHALL NOT BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, PUNITIVE, OR EXEMPLARY DAMAGES ARISING UNDER THESE TERMS OR ASSOCIATED WITH YOUR USE OF THE SITE OR WITH ANY LANDSBE CONTENT, INCLUDING BUT NOT LIMITED TO DAMAGES FOR LOSS OF PROFITS, GOODWILL, USE OF DATA, LACK OR LOSS OF DATA, OR OTHER INTANGIBLE LOSSES, WHETHER THE CLAIM FOR SUCH DAMAGES IS BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE OR STRICT LIABILITY), OR OTHERWISE (EVEN IF LANDSBE OR ITS APPLICABLE THIRD-PARTY PROVIDER HAS BEEN ADVISED OF OR SHOULD HAVE BEEN AWARE OF THE POSSIBILITY OF SUCH DAMAGES); AND</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">(B) THE MAXIMUM AGGREGATE LIABILITY OF ANY KIND ARISING UNDER OR RELATING TO THESE TERMS, THE PRODUCTS, SERVICES, OR LANDSBE CONTENT SHALL BE TEN UNITED STATES DOLLARS ($10.00). THE FOREGOING LIMITATIONS SHALL APPLY TO ALL CAUSES OF ACTION, WHETHER ARISING FROM BREACH OF CONTRACT, BREACH OF WARRANTY, NEGLIGENCE OR OTHER TORT, OR ANY OTHER LEGAL THEORY; MOREOVER, THESE LIMITATIONS WILL APPLY NOTWITHSTANDING A FAILURE OF ESSENTIAL PURPOSE OF ANY LIMITED REMEDY.</span><span style="font-family: Titillium Web;"> </span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>DMCA Compliance / Take Down Rights</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Consistent with our commitment to the protection of intellectual property rights, in connection with any content or material posted by users of or visitors to the Site (“User Material”), we comply with the protections and notice and take-down provisions of the Digital Millennium Copyright Act (“DMCA”). If you are a copyright owner or an agent thereof and believe that any User Material infringes upon your copyrights, you may submit a notification pursuant to the DMCA by providing our copyright agent with the following information in writing:</span></p>\n<ul>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Identification of the copyrighted work claimed to have been infringed or, if multiple copyrighted works on the Site are covered by a single notification, a representative list of such works;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Identification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled and information reasonably sufficient to permit Landsbe to locate the material;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Information reasonably sufficient to permit Landsbe to contact you, such as an address, telephone number, and, if available, an electronic mail address;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">A statement that you have a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law;</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">A statement that the information in the notification is accurate, and under penalty of perjury, that you are authorized to act on behalf of the owner of an exclusive right that is allegedly infringed; and</span></li>\n<li><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">A physical or electronic signature of a person authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.</span><span style="font-family: Titillium Web;"><br></span></li>\n</ul>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Notifications of claimed infringement should be sent to Landsbe’s designated copyright agent to receive notifications of claimed infringement at</span><span style="font-family: Titillium Web;"><br></span></p>\n<p><span style="font-family: Titillium Web;">Landsbe, LLC</span></p>\n<p><span style="font-family: Titillium Web;">Attn: James Cahoon</span></p>\n<p><span style="font-family: Titillium Web;">189 North Highway 89 Suite C-173,</span></p>\n<p><span style="font-family: Titillium Web;">North Salt Lake Utah, 84054</span></p>\n<p></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Applicable Law</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You agree that, except to the extent inconsistent with or preempted by federal law, the laws of the State of Utah, without regard to principles of conflict of laws, will govern any claim or dispute that has arisen or may arise between you and Landsbe.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You and Landsbe each agree that any and all disputes or claims that have arisen, or may arise, between you and Landsbe (or any related third parties) that relate in any way to or arise out of your use of or access to our Site, the actions of Landsbe or its agents, or any products or services sold, offered, or purchased through our Site shall be resolved exclusively through final and binding arbitration, rather than in court.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Prohibition of Class and Representative Actions and Non-Individualized Relief</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">YOU AND LANDSBE AGREE THAT EACH OF US MAY BRING CLAIMS AGAINST THE OTHER ONLY ON AN INDIVIDUAL BASIS AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS, OR REPRESENTATIVE OR PRIVATE ATTORNEY GENERAL ACTION OR PROCEEDING. UNLESS BOTH YOU AND LANDSBE AGREE OTHERWISE, THE ARBITRATOR MAY NOT CONSOLIDATE OR JOIN MORE THAN ONE PERSON'S OR PARTY'S CLAIMS, AND MAY NOT OTHERWISE PRESIDE OVER ANY FORM OF A CONSOLIDATED, REPRESENTATIVE, CLASS, OR PRIVATE ATTORNEY GENERAL ACTION OR PROCEEDING. ALSO, THE ARBITRATOR MAY AWARD RELIEF (INCLUDING MONETARY, INJUNCTIVE, AND DECLARATORY RELIEF) ONLY IN FAVOR OF THE INDIVIDUAL PARTY SEEKING RELIEF AND ONLY TO THE EXTENT NECESSARY TO PROVIDE RELIEF NECESSITATED BY THAT PARTY'S INDIVIDUAL CLAIM(S). ANY RELIEF AWARDED CANNOT AFFECT OTHER USERS.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">If you intend to seek arbitration against Landsbe, you must first send to Landsbe, by certified mail, a notice of dispute ("Notice") to Landsbe at 189 North Highway 89 Suite C-173, North Salt Lake Utah, 84054. Payment of all filing, administration and arbitrator fees will be governed by the AAA's rules. In the event the arbitrator determines the claim(s) you assert in the arbitration to be frivolous, you agree to reimburse Landsbe for all fees associated with the arbitration paid by Landsbe on your behalf that you otherwise would be obligated to pay under the AAA's rules.</span><span style="font-family: Titillium Web;"><br></span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Additional Rules for Users/Buying Groups</strong></span><span style="font-family: Titillium Web;"><br></span></h1>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 18px;font-family: Titillium Web;"><strong>Rules about the cooperative for Users and Buying Groups</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">By using this website and marketplace you agree that you will provide Landsbe, other members in the buying group, and any seller or potential seller accurate account information.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You agree that you will carefully consider the type of offer made to a prospective seller or proposed by a seller to a prospective buyer. An offer to purchase or an offer to sell is a binding contract that is active until a seller or buyer accepts the offer or rejects it. If you accept a binding offer, or if you make an offer for sale, you are committed to following through with your purchase or sale. A non-binding offer to purchase is a not a binding contract that can be proposed to a buyer or seller. You agree to carefully review the type of offer being made and to be responsible for the terms of the offer as agreed. Further, you agree that you will pay for any item(s) you commit to purchase (binding) when forming the cooperative and submitting a purchase proposal to a seller.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You agree that you will only form or join a cooperative if you intend to purchase the item.</span><span style="font-family: Titillium Web;"><br></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You agree that you will not make offers on products that you also sell. This applies to anyone connected to you. You agree to avoid anything that would increase a sales price or the desirability of any product.</span></p>\n<h1 style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 16px;font-family: Titillium Web;"><strong>Changes</strong></span></h1>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Please review the Terms periodically, as we may update them from time to time. All changes are effective immediately upon posting on the Site.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">BY USING THE SITE, YOU ACKNOWLEDGE THAT YOU HAVE READ THIS AGREEMENT AND AGREE TO BE BOUND BY ITS TERMS.</span><span style="font-family: Titillium Web;"> </span></p>\n<p><span style="font-family: Titillium Web;"> </span></p>\n<p></p>\n<p></p>\n<p></p>\n	terms
3	\N	<p><span style="font-family: Titillium Web;">I <strong>agree</strong> that a 10% price margin will go to Landsbe.</span></p>\n	agreement
2		<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><em>Last updated: June 10, 2021</em></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the</span> <a href="https://www.termsfeed.com/privacy-policy-generator/" target="_blank"><span style="color: inherit;background-color: transparent;font-size: medium;font-family: Titillium Web;">Privacy Policy Generator</span></a><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Interpretation and Definitions</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;"><strong>Interpretation</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;"><strong>Definitions</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">For the purposes of this Privacy Policy:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Account</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">means a unique account created for You to access our Service or parts of our Service.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Company</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">(referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Landsbe.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Cookies</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">are small files that are placed on Your computer, mobile device or any other device by a website, containing the details of Your browsing history on that website among its many uses.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Country</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">refers to the United States of America.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Device</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">means any device that can access the Service such as a computer, a cellphone or a digital tablet.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Personal Data</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">is any information that relates to an identified or identifiable individual.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Service</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">refers to the Website.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Service Provider</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Third-party Social Media Service</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">refers to any website or any social network website through which a User can log in or create an account to use the Service.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Usage Data</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Website</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">refers to Landsbe, accessible from</span> <a href="https://phdev.perfectpitchtech.com/landsbe.com" target="_blank"><span style="color: inherit;background-color: transparent;font-size: medium;font-family: Titillium Web;">landsbe.com</span></a></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>You</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Collecting and Using Your Personal Data</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;"><strong>Types of Data Collected</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;"><strong><em>Personal Data</em></strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Email address</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">First name and last name</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Phone number</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Address, State, Province, ZIP/Postal code, City</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Usage Data</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;"><strong><em>Usage Data</em></strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Usage Data is collected automatically when using the Service.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Tracking Technologies and Cookies</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We use Cookies and similar tracking technologies to track the activity on Our Service and store certain information. Tracking technologies used are beacons, tags, and scripts to collect and track information and to improve and analyze Our Service. The technologies We use may include:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Cookies or Browser Cookies.</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">A cookie is a small file placed on Your Device. You can instruct Your browser to refuse all Cookies or to indicate when a Cookie is being sent. However, if You do not accept Cookies, You may not be able to use some parts of our Service. Unless you have adjusted Your browser setting so that it will refuse Cookies, our Service may use Cookies.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Flash Cookies.</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Certain features of our Service may use local stored objects (or Flash Cookies) to collect and store information about Your preferences or Your activity on our Service. Flash Cookies are not managed by the same browser settings as those used for Browser Cookies. For more information on how You can delete Flash Cookies, please read "Where can I change the settings for disabling, or deleting local shared objects?"</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Web Beacons.</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Certain sections of our Service and our emails may contain small electronic files known as web beacons (also referred to as clear gifs, pixel tags, and single-pixel gifs) that permit the Company, for example, to count users who have visited those pages or opened an email and for other related website statistics (for example, recording the popularity of a certain section and verifying system and server integrity).</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Cookies can be "Persistent" or "Session" Cookies. Persistent Cookies remain on Your personal computer or mobile device when You go offline, while Session Cookies are deleted as soon as You close Your web browser. You can learn more about cookies here:</span> <a href="https://www.termsfeed.com/blog/cookies/" target="_blank"><span style="color: inherit;background-color: transparent;font-size: medium;font-family: Titillium Web;">All About Cookies by TermsFeed</span></a><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We use both Session and Persistent Cookies for the purposes set out below:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Necessary / Essential Cookies</strong></span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Type: Session Cookies</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Administered by: Us</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Purpose: These Cookies are essential to provide You with services available through the Website and to enable You to use some of its features. They help to authenticate users and prevent fraudulent use of user accounts. Without these Cookies, the services that You have asked for cannot be provided, and We only use these Cookies to provide You with those services.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Cookies Policy / Notice Acceptance Cookies</strong></span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Type: Persistent Cookies</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Administered by: Us</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Purpose: These Cookies identify if users have accepted the use of cookies on the Website.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Functionality Cookies</strong></span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Type: Persistent Cookies</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Administered by: Us</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Purpose: These Cookies allow us to remember choices You make when You use the Website, such as remembering your login details or language preference. The purpose of these Cookies is to provide You with </span><br><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     a more personal experience and to avoid You having to re-enter your preferences every time You use the Website.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">For more information about the cookies we use and your choices regarding cookies, please visit our Cookies Policy or the Cookies section of our Privacy Policy.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Use of Your Personal Data</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Company may use Personal Data for the following purposes:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>To provide and maintain our Service</strong>, including to monitor the usage of our Service.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>To manage Your Account:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>For the performance of a contract:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>To contact You:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>To provide You</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>To manage Your requests:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">To attend and manage Your requests to Us.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>For business transfers:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>For other purposes</strong>: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may share Your personal information in the following situations:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>With Service Providers:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>For business transfers:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>With Affiliates:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>With business partners:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may share Your information with Our business partners to offer You certain products, services or promotions.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>With other users:</strong></span> <span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>With Your consent</strong>: We may disclose Your personal information for any other purpose with Your consent.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Retention of Your Personal Data</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Transfer of Your Personal Data</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Disclosure of Your Personal Data</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Business Transactions</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Law enforcement</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Other legal requirements</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Comply with a legal obligation</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Protect and defend the rights or property of the Company</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Prevent or investigate possible wrongdoing in connection with the Service</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Protect the personal safety of Users of the Service or the public</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Protect against legal liability</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Security of Your Personal Data</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Detailed Information on the Processing of Your Personal Data</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">The Service Providers We use may have access to Your Personal Data. These third-party vendors collect, store, use, process and transfer information about Your activity on Our Service in accordance with their Privacy Policies.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: inherit;font-family: Titillium Web;">Usage, Performance and Miscellaneous</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may use third-party Service Providers to provide better improvement of our Service.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;"><strong>Google Places</strong></span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Google Places is a service that returns information about places using HTTP requests. It is operated by Google</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     Google Places service may collect information from You and from Your Device for security purposes.</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">     The information gathered by Google Places is held in accordance with the Privacy Policy of Google:</span> <a href="https://www.google.com/intl/en/policies/privacy/" target="_blank"><span style="color: inherit;background-color: transparent;font-size: medium;font-family: Titillium Web;">https://www.google.com/intl/en/policies/privacy/</span></a>&nbsp;</p>\n<p><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Children's Privacy</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Links to Other Websites</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 24px;font-family: Titillium Web;"><strong>Changes to this Privacy Policy</strong></span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: 1.875rem;font-family: Titillium Web;">Contact Us</span></p>\n<p style="text-align:start;"><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">If you have any questions about this Privacy Policy, You can contact us:</span></p>\n<p><span style="color: rgb(0,0,0);font-size: medium;font-family: Titillium Web;">By email: privacy@landsbe.com</span>&nbsp;</p>\n	privacy
6	\N	<p></p>\n<p style="text-align:center;"><span style="color: rgb(83,82,88);font-size: 24px;font-family: Titillium Web;"><strong>Refunds and Return Policy</strong></span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">1.          Application for Returns/Refunds</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Subject to the terms and conditions in this Refunds and Return Policy and the Terms of Service, Buyer may apply for return of the purchased items (“Item”) and/or refund prior to the expiry of the Landsbe Guarantee Period as stated in the Terms of Service.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">2.          Application for the Return of an Item</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Buyer may only apply for the refund and/or return of the Item in the following circumstances:</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">●        The Item has not been received by Buyer;</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">●        The Item was defective and/or damaged on delivery;</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">●        Seller has delivered an Item that does not match the agreed specification (e.g. wrong size, colour, etc.) to Buyer;</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">●        The Item delivered to Buyer is materially different from the description provided by Seller in the listing of the Item; or</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">●        By way of private agreement with Seller and Seller must send his/her confirmation to Landsbe confirming such agreement.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Buyer’s application must be submitted via the Landsbe mobile app.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">ten (10) calendar days after the return request is raised.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">In the event where Buyer has commenced legal action against Seller, Buyer may provide the formal notification from the appropriate authority to Landsbe to request Landsbe to continue to hold the purchase monies until a formal determination is available. Landsbe will, at its sole and absolute discretion, determine whether it is necessary to continue to hold such purchase monies.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">3.          Rights of Preferred Sellers</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">If you are a Preferred Seller, you should have received a separate written notification from Landsbe informing you of your selection to participate in the Landsbe Preferred Seller Program.  If you decide not to participate in the Landsbe Preferred Seller Program at any time, please inform Landsbe in writing; otherwise, you will be deemed to have elected to continue your participation in the Landsbe Preferred Seller Program and consented to the terms and conditions set out in this Refunds and Return Policy.  Landsbe may, at any time and at its sole discretion, suspend or remove any Preferred Seller from the Landsbe Preferred Seller Program.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Landsbe’s determination to approve a refund or return of an Item pursuant to Section 2 above is binding on the relevant Preferred Seller.  Preferred Sellers agree to comply and do all such things as necessary to give effect to a Buyer’s request for a refund or return approved by Landsbe.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">For any refund or return request approved by Landsbe, Landsbe will notify the Preferred Seller by email (“Email Notification”) and organize the delivery of the relevant returned Item to the address provided by the relevant Preferred Seller to Landsbe in writing for the completion of the refund and return process, so long as such address is in the country in which the relevant Item was listed for sale on the Site (a “Local Address”).  If Preferred Seller fails to provide a Local Address for return of the returned Item or otherwise fails to accept delivery of the returned Item within a reasonable period of time (as determined by Landsbe), Landsbe reserves the right to dispose of such Item in any manner it sees fit and Preferred Seller shall be deemed to have forfeited all rights to such Item.  Preferred Seller must notify Landsbe within seven (7) days of receiving the Email Notification (“Notification Period”) if Preferred Seller does not receive the returned Item.  Failure to notify Landsbe within the Notification Period shall be conclusive evidence of, and result in the Preferred Seller having accepted that, the delivery of the Item has occurred, and Preferred Seller agrees not to make any claims or raise any disputes regarding any such Item.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Notwithstanding the above, Landsbe may determine at its sole and absolute discretion that an Item approved for refund or return shall not be returned to Preferred Seller, and Preferred Seller shall be deemed to have forfeited all rights to such Item.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">For any refund or return rejected by Landsbe where the relevant Item was received by Landsbe, Landsbe will organize the delivery of such Item to the relevant Buyer’s address pursuant to Section 2 above.  </span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Where Landsbe approves any refund or return request, Preferred Seller may appeal such decision by contacting Landsbe and providing evidence in support of such appeal.  If Landsbe upholds Preferred Seller’s appeal, it will disburse all or part of the purchase monies to Preferred Seller.  Preferred Seller acknowledges and agrees that Landsbe’s decision is final, conclusive and binding, and covenants and agrees that it will not bring suit or otherwise assert any claim against Landsbe or its affiliates in relation to such decision.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">4.          Rights of Ordinary Sellers</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">For the purpose of this Refund and Return Policy, Ordinary Sellers are Sellers that are not Mall Sellers or Preferred Sellers.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">When Landsbe receives an application from Buyer for the return of the Item and/or refund, Landsbe will notify Seller in writing. Seller may respond to Buyer’s application according to the steps provided by Landsbe in the written notification. Seller must respond within the time-frame stipulated in the written notification (the “Stipulated Period”). Should Landsbe not hear from Seller within the Stipulated Period, Landsbe will assume that Seller has no response to Buyer’s application and will proceed to assess Buyer’s application without further notice to Seller. Landsbe will review each Seller’s response on a case-by-case basis and, in its sole discretion, determine whether Buyer’s application may be successful against the circumstances stated by Seller.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">5.          Condition of Returning Item</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">To enjoy a hassle-free experience when returning the Item, Buyer should ensure that the Item, including any complimentary items such as accessories that come with the Item, must be returned to Seller in the condition received by Buyer on delivery. We will recommend Buyer to take a photo of the Item upon receipt.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">6.          Liability of Product Forward Shipping Fee and Return Shipping Fee</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">i)       In the scenario of an unforeseen error from the seller's end (i.e - damaged, faulty or wrong product delivered to the buyer), the seller will bear buyer's forward shipping fee and return shipping fee.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">ii)     In the scenario of the buyer's change of mind, buyer shall get seller's consent prior to the return request and buyer will bear the return shipping fee.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">iii)    In the scenario where both seller-buyer</span> <span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">disputing the party liable for the forward shipping fee and return shipping fee, Landsbe at its sole discretion will determine the party liable for the forward shipping fee and return shipping fee.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">For the avoidance of doubt, should the seller be liable for the buyer’s forward shipping fee and return shipping fee in any of the above scenarios, the seller shall be liable for the buyer’s forward shipping fee even if the buyer used a Free Shipping Voucher for the delivery of the product.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">7.          Refunds</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Buyer will only be refunded after Landsbe has received the confirmation from Seller that Seller has received the returned Item. In the event where Landsbe does not hear from Seller within a specified time, Landsbe will be at liberty to refund the applicable sum to Buyer without further notice to Seller. For more information on Seller’s response time limits, please click this link. The refund will be made to Buyer’s credit/debit card or designated bank account, whichever is applicable.</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">8.          Communication Between Buyer and Seller</span></p>\n<p style="text-align:left;"><span style="color: rgb(83,82,88);font-size: 14px;font-family: Titillium Web;">Landsbe encourages Users to communicate with each other in the event where problem arises in a transaction. As Landsbe is a platform for Users to conduct trading, Buyer should contact Seller directly for any issue relating to the Item purchased.</span></p>\n<p></p>\n	return
5	\N	<p><span style="font-family: Titillium Web;">Please note that you are responsible for bidding in 10% of the margin and all shipping fulfillment costs.</span></p>\n	term_agreement
4	\N	<p><span style="font-family: Titillium Web;">I <strong>acknowledge </strong>that the price includes shipping.</span></p>\n	acknowledgement
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (notification_id, action, message, read, datetime_created, datetime_modified, redirect, group_uuid, user_uuid, notif_type, triggered_by) FROM stdin;
7c6b3c47-33bb-4e72-8899-9884d98a36ce	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	t	2021-11-11 09:37:18.039173	2021-11-11 19:56:54.749777	/product-page/${group_id}	24fa7a33-054d-45b1-8cdc-7bc8dc394921	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
b72e6df0-cfc5-4df8-929e-9364c3971e9f	new group	New group has been created for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	t	2021-11-11 09:06:39.095708	2021-11-11 21:37:19.029588	#	\N	\N	admin	\N
d7e302ce-fe98-4bab-a856-0029040a4bc5	new category	electronics category created, electronics	t	2022-01-17 09:36:05.209797	2022-01-17 09:36:05.209797	/admin/category	\N	\N	admin	\N
9680fb2c-b25f-4f19-8b4a-cb6f97ae6777	new group	New group has been created for Amazon Basics XXL Gaming Computer Mouse Pad - Black	t	2021-11-19 05:14:33.747073	2021-11-23 01:54:51.34976	#	\N	\N	admin	\N
5b9b6e00-4289-4f58-91d7-d33cbfdbda8a	Group Suggestion approved	Your product group for Amazon Basics XXL Gaming Computer Mouse Pad - Black has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-19 05:14:33.738422	2021-11-23 01:54:57.217481	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
bd1e30a1-1e41-42f4-bfc3-eb8060a81db8	GROUP DEADLINE CHANGED	Your group BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office deadline has been changed from 'Fri Oct 15 2021' to 'Sun Oct 31 2021' by the admin.	t	2021-11-18 08:26:25.537479	2021-11-26 01:54:31.495986	/seller/mygroups	184e978e-9c9f-4ef7-bc57-47022f7b2ece	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
edf5b339-3972-49ad-92ec-60882c74a21e	new group	New group has been created for BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office	t	2021-11-18 08:20:48.876247	2021-11-26 01:54:32.551915	#	\N	\N	admin	\N
563dca05-2dbe-41cb-96cb-929717cea0c2	Group Suggestion approved	Your product group for BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-18 08:20:48.859953	2021-11-26 01:54:33.785053	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
d30b247f-ef11-42d5-9c98-a4dc5b20735c	new group	New group has been created for Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	t	2021-11-17 01:46:50.33488	2021-11-26 01:54:34.991843	#	\N	\N	admin	\N
da7ebc1b-12f3-41bc-a0c4-dc9457b47ca5	Group Suggestion approved	Your product group for Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed) has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-17 01:46:50.311731	2021-11-26 01:54:35.768786	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
214bb62a-cf43-4bec-a27f-f10b758ba2a6	new group	New group has been created for Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	t	2021-11-17 01:45:33.438082	2021-11-26 01:54:36.88896	#	\N	\N	admin	\N
1c5c7d49-5f6f-4bf4-a924-7cdff1a3004f	new group	New group has been created for Clear Glass Beer Cups – 6 Pack – All Purpose Drinking Tumblers, 16 oz – Elegant Design for Home and Kitchen – Great for Restaurants, Bars, Parties – by Kitchen Lux	t	2021-11-16 08:04:04.511343	2021-11-26 01:54:40.137273	#	\N	\N	admin	\N
8628d847-8639-4d23-a742-dbf2371e40b1	Group Suggestion approved	Your product group for Clear Glass Beer Cups – 6 Pack – All Purpose Drinking Tumblers, 16 oz – Elegant Design for Home and Kitchen – Great for Restaurants, Bars, Parties – by Kitchen Lux has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-16 08:04:04.499741	2021-11-26 01:54:40.824928	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
4a00431a-c991-49f1-b796-2be008f43ed8	new group	New group has been created for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	t	2021-11-16 05:13:12.371695	2021-11-26 01:54:43.224845	#	\N	\N	admin	\N
74ceb227-8ba3-473e-a66b-176154e41f75	Group Suggestion approved	Your product group for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-16 05:13:12.360033	2021-11-26 01:54:43.66505	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
8aaaabb7-5c46-4327-aac3-f8b58577c8ea	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-16 05:11:58.692712	2021-11-26 01:54:44.489971	/admin/product-suggestions	\N	\N	admin	\N
122d7f87-54d5-4e26-97c9-f78d171fa6e1	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-16 02:47:55.888137	2021-11-26 01:54:45.530094	/admin/product-suggestions	\N	\N	admin	\N
ceea9be9-b538-464d-85cb-1b9605af0ebf	new group	New group has been created for Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed)	t	2021-11-15 01:34:31.033274	2021-11-26 01:54:46.842386	#	\N	\N	admin	\N
bd77849f-656d-49ed-8c8d-56583cc6a8f9	Group Suggestion approved	Your product group for Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed) has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-15 01:34:30.998899	2021-11-26 01:54:47.449942	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
757f51cb-ca05-4ddb-8964-359264409477	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-15 01:33:27.052139	2021-11-26 01:54:50.705901	/admin/product-suggestions	\N	\N	admin	\N
0148c78e-51cd-4448-902c-113ade3735ac	new group	New group has been created for APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers	t	2021-11-12 08:19:32.019396	2021-11-26 01:54:53.450961	#	\N	\N	admin	\N
47a50567-a967-453b-9702-39f1d13d833e	Group Suggestion approved	Your product group for APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-12 08:19:32.013914	2021-11-26 01:54:54.203263	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
a3cdb5a0-a080-41b5-9a65-1da39f148f95	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-12 08:18:51.436473	2021-11-26 01:54:55.347964	/admin/product-suggestions	\N	\N	admin	\N
773eeba9-edb1-4db1-bb0e-f79b985685f6	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-11 09:01:47.817611	2021-11-29 02:47:55.232222	/admin/product-suggestions	\N	\N	admin	\N
17d26542-9bcc-4ed1-b074-f8c11d2b8bf6	Group Suggestion approved	Your product group for Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed) has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-17 01:45:33.427253	2022-03-29 08:10:40.163553	/seller/mybids	\N	e498f885-498f-4a95-afa0-9370f4a6a866	seller	\N
137dbbfd-723d-48ca-bb19-25d5f7113d82	crawler done	Crawling for sellers is done for product "test". Found 10 results	t	2021-11-25 02:52:02.418286	2021-11-26 01:23:54.824615	/admin/managebids	\N	\N	admin	\N
f97c332e-2a92-4766-86ff-ac5fbabf19f3	new bidding	New bidding started for test group	t	2021-11-25 02:48:43.684636	2021-11-26 01:25:32.987783	/admin/managebids	\N	\N	admin	\N
41e6cf1b-7bea-45dc-94d5-b7fa534e3237	new group	New group has been created for test	t	2021-11-25 02:48:43.045505	2021-11-26 01:46:11.456623	#	\N	\N	admin	\N
3656de64-bbb1-46a4-8296-e8ace85b5d08	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-25 02:48:07.46252	2021-11-26 01:53:45.294102	/admin/product-suggestions	\N	\N	admin	\N
078a5dc7-1ffe-467c-aaef-2e0e6eb63c89	new group	New group has been created for Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black	t	2021-11-26 02:25:52.881376	2021-11-29 02:48:07.899326	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
3d34425d-6169-4e5a-b318-7b8f260eb2ab	new group	New group has been created for Sheoolor Quiet Essential Oil Diffuser, 200ml Vintage Vase Aromatherapy Diffuser with Waterless Auto Shut-Off Function & 7-Color LED Changing Lights Diffuser for Essential Oils, for Home, Office, Yoga	t	2021-11-25 02:46:55.723953	2021-11-26 01:53:47.69105	#	\N	\N	admin	\N
b5b2e056-b213-4fd1-95ac-d7b879b53401	crawler done	Crawling for sellers is done for product "gaming mouse". Found 10 results	t	2021-11-25 02:20:11.376969	2021-11-26 01:53:48.442105	/admin/managebids	\N	\N	admin	\N
4a2360f7-1a31-4666-84f4-f8212c0a8db2	crawler done	Crawling for sellers is done for product "PlayStation DualSense Wireless Controller – Midnight Black ". Found 0 results	t	2021-11-25 02:14:54.333983	2021-11-26 01:53:54.74768	/admin/managebids	\N	\N	admin	\N
6af498b5-2f82-45c4-89cf-cd87b5e9b6f9	new bidding	New bidding started for gaming mouse group	t	2021-11-25 02:14:28.184952	2021-11-26 01:53:57.131081	/admin/managebids	\N	\N	admin	\N
9a61dd28-46c4-47c9-8985-2a171573d7a3	new group	New group has been created for gaming mouse	t	2021-11-25 02:14:27.53899	2021-11-26 01:53:58.476831	#	\N	\N	admin	\N
0b3bf756-82c6-463b-bc77-1c5879fe3a84	new group	New group has been created for PlayStation DualSense Wireless Controller – Midnight Black 	t	2021-11-25 02:12:14.887101	2021-11-26 01:54:01.5343	#	\N	\N	admin	\N
ce0458d0-46ec-49c0-af74-5563a5ad18b9	new bidding	New bidding started for PlayStation DualSense Wireless Controller – Midnight Black  group	t	2021-11-25 02:12:15.593077	2021-11-26 01:54:02.358473	/admin/managebids	\N	\N	admin	\N
ddeda572-9a9e-457e-aed0-77584c0a6b12	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-25 01:55:33.444613	2021-11-26 01:54:04.203998	/admin/product-suggestions	\N	\N	admin	\N
51fdbddb-ec75-41cc-8ef0-6993612f666f	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-25 01:52:47.912135	2021-11-26 01:54:05.269511	/admin/product-suggestions	\N	\N	admin	\N
7caecbd4-f0b1-4f0f-9190-dffd7093f494	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-25 01:47:28.382298	2021-11-26 01:54:06.318033	/admin/product-suggestions	\N	\N	admin	\N
ce66128e-3741-468a-a914-4e36ad51cfb7	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-25 01:40:24.98038	2021-11-26 01:54:07.173114	/admin/product-suggestions	\N	\N	admin	\N
50cce90e-127f-4187-bf64-fc0c107aa293	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 08:17:01.621771	2021-11-26 01:54:09.192003	/admin/product-suggestions	\N	\N	admin	\N
d43c752e-ffd9-4436-ac42-8d54560ebbba	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 08:17:54.211114	2021-11-26 01:54:10.405526	/admin/product-suggestions	\N	\N	admin	\N
816f5bab-8063-4d21-b7fd-3129fc5c761b	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 07:55:51.348778	2021-11-26 01:54:14.029269	/admin/product-suggestions	\N	\N	admin	\N
ee9e0ad5-baa3-42b8-9750-402da3609342	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 07:46:29.916152	2021-11-26 01:54:14.742087	/admin/product-suggestions	\N	\N	admin	\N
ddae93da-0fdb-48b5-8b37-59d88fd367c0	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 07:43:10.487931	2021-11-26 01:54:15.983062	/admin/product-suggestions	\N	\N	admin	\N
8c04a45a-72c5-4a55-9423-caef83622505	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 07:38:56.529581	2021-11-26 01:54:16.837944	/admin/product-suggestions	\N	\N	admin	\N
89fca162-f2ab-4faf-bdfa-f9d5b127954d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 06:52:28.951822	2021-11-26 01:54:18.690203	/admin/product-suggestions	\N	\N	admin	\N
ebe71028-aa1b-4bf1-a511-1cd0bfe1bf7e	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-24 06:30:26.894312	2021-11-26 01:54:19.599983	/admin/product-suggestions	\N	\N	admin	\N
09f48c21-e76e-43cd-bd12-405b6833736d	crawler done	Crawling for sellers is done for product "PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S". Found 10 results	t	2021-11-23 09:35:22.893156	2021-11-26 01:54:21.262989	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
a6246201-ab29-4dc3-9619-fef5bf8c761d	new bidding	New bidding started for PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S group	t	2021-11-23 09:27:58.485301	2021-11-26 01:54:22.50193	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
f4d23e7f-59ea-45a3-beab-814bdcca7311	new group	New group has been created for PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S	t	2021-11-23 09:27:58.022754	2021-11-26 01:54:23.402421	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
1e2307ee-9a69-422f-a5a3-336417edef10	new group	New group has been created for Star Wars The Child Plush Toy, 8-in Small Yoda Baby Figure from The Mandalorian, Collectible Stuffed Character for Movie Fans of All Ages, 3 and Older	t	2021-11-23 09:16:25.323764	2021-11-26 01:54:24.230134	#	\N	\N	admin	\N
9121d179-6823-4259-80f6-32a5f3de945e	Group Suggestion approved	Your product group for Star Wars The Child Plush Toy, 8-in Small Yoda Baby Figure from The Mandalorian, Collectible Stuffed Character for Movie Fans of All Ages, 3 and Older has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-23 09:16:25.31031	2021-11-26 01:54:25.53539	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
5099a615-9d96-4297-b91b-496e1b1b0dec	new group	New group has been created for AMD Ryzen 7 5800X 8-core, 16-Thread Unlocked Desktop Processor	t	2021-11-23 08:38:32.507161	2021-11-26 01:54:28.376116	#	\N	\N	admin	a5c5171b-1331-474a-82f7-2876fb3843a1
58fc2837-2c4c-4cf8-82e0-a1cbe1310856	GROUP DEADLINE CHANGED	Your group BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office deadline has been changed from 'Sun Oct 31 2021' to 'Tue Nov 30 2021' by the admin.	t	2021-11-18 08:29:01.767519	2021-11-26 01:54:30.079733	/seller/mygroups	184e978e-9c9f-4ef7-bc57-47022f7b2ece	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
53be3d5b-a849-453d-a01c-a5cb269fda08	new bidding	New bidding started for Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black group	f	2021-11-26 02:25:53.317052	2021-11-26 02:25:53.317052	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
8cdca8a9-55f5-4388-8321-6a09aec474d2	new group	New group has been created for SAMSUNG 870 EVO 1TB 2.5 Inch SATA III Internal SSD (MZ-77E1T0B/AM)	f	2021-11-26 02:26:59.293529	2021-11-26 02:26:59.293529	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
d6c736a1-46a2-4d6c-b0f8-0fcdbe2c62e1	new bidding	New bidding started for SAMSUNG 870 EVO 1TB 2.5 Inch SATA III Internal SSD (MZ-77E1T0B/AM) group	f	2021-11-26 02:26:59.74461	2021-11-26 02:26:59.74461	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
7e25f6db-4a0f-4d2c-99f8-348a919f33e7	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 02:30:50.997127	2021-11-26 02:30:50.997127	/admin/product-suggestions	\N	\N	admin	\N
b9cf43a4-f804-4d3a-9b26-80bf662df09c	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 05:37:22.249347	2021-11-26 05:37:22.249347	/admin/product-suggestions	\N	\N	admin	\N
ddc12fec-6fee-4eea-b87a-109b8eb25ad4	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 05:39:12.045298	2021-11-26 05:39:12.045298	/admin/product-suggestions	\N	\N	admin	\N
294e1f7e-4ab3-4e45-999e-83d0226ab2bc	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 06:05:56.792332	2021-11-26 06:05:56.792332	/admin/product-suggestions	\N	\N	admin	\N
a5244ad0-c8b4-4ade-90d0-bcb4a86862a6	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 06:07:05.652201	2021-11-26 06:07:05.652201	/admin/product-suggestions	\N	\N	admin	\N
bc6ba7cb-4335-4c8a-b41b-784fff491978	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 06:35:38.359768	2021-11-26 06:35:38.359768	/admin/product-suggestions	\N	\N	admin	\N
12b28804-b7ae-41fb-a34e-1dd6bfc4192d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 06:37:09.627153	2021-11-26 06:37:09.627153	/admin/product-suggestions	\N	\N	admin	\N
93912780-ece8-4949-b8d1-1c88c6215613	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 06:47:03.234851	2021-11-26 06:47:03.234851	/admin/product-suggestions	\N	\N	admin	\N
b701c861-cdea-42dd-b0af-dafa6d35762b	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 08:12:23.665204	2021-11-26 08:12:23.665204	/admin/product-suggestions	\N	\N	admin	\N
bacde36a-6476-4bbb-8373-19af0ee97415	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 08:26:46.684439	2021-11-26 08:26:46.684439	/admin/product-suggestions	\N	\N	admin	\N
5168d3eb-7a2d-4fd9-95a1-4550d554b2ab	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 08:27:53.091191	2021-11-26 08:27:53.091191	/admin/product-suggestions	\N	\N	admin	\N
6956f7e2-0947-4332-bf1f-6cb31502bfa1	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 08:28:58.232608	2021-11-26 08:28:58.232608	/admin/product-suggestions	\N	\N	admin	\N
c9863ff1-e6f1-48da-b8ea-11a4c633fd58	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-11-26 08:29:16.003274	2021-11-26 08:29:16.003274	/admin/product-suggestions	\N	\N	admin	\N
957287e5-3ae8-4d4c-a0a0-bb6dcabcb076	crawler done	Crawling for sellers is done for product "WD 5TB My Passport Portable External Hard Drive HDD, USB 3.0, USB 2.0 Compatible, Black - WDBPKJ0050BBK-WESN". Found 8 results	t	2021-12-10 05:27:02.267262	2021-12-10 05:27:02.267262	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
cc3f5d73-613d-4144-945c-7d5f986fbb6f	SELLER ASSIGNMENT	Congrats, you are now the seller of this group, Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black.	f	2021-12-06 05:10:32.640849	2021-12-06 05:10:32.640849	/product-page/22851185-d78b-47b0-8ebb-eff9d2c81686	22851185-d78b-47b0-8ebb-eff9d2c81686	c1cfcbbf-2ec9-4966-8849-277852afa41a	admin	\N
b855ca9a-0ad6-41a1-a2e6-42b8ee4abce1	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 08:32:14.181185	2021-11-29 02:47:59.81014	/admin/product-suggestions	\N	\N	admin	\N
12a3dbac-2ff0-4c4c-9229-18fab697e89e	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 05:45:47.859375	2021-11-29 02:48:02.233369	/admin/product-suggestions	\N	\N	admin	\N
4a7c2627-109c-466a-9127-fd1e6bc1d7ee	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 05:44:10.236282	2021-11-29 02:48:14.456514	/admin/product-suggestions	\N	\N	admin	\N
4d3ed933-e74b-45d9-a6be-b2987fdcc4e7	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 05:41:47.359635	2021-11-29 02:48:17.581539	/admin/product-suggestions	\N	\N	admin	\N
4b956e4e-72df-4592-9bb0-8659a59e89f0	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 08:30:39.696653	2021-11-29 06:47:32.257091	/admin/product-suggestions	\N	\N	admin	\N
f70e8808-9e78-4791-b36e-d224a2e2ffc5	YOU ACCEPTED THIS REQUEST	Hey, the admin wants you to be the seller of this group, Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black.	t	2021-12-06 03:48:39.118712	2021-12-06 05:10:33.025276	#	22851185-d78b-47b0-8ebb-eff9d2c81686	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c49d245b-42e8-4126-a282-fa6b75e0bcb1	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2021-11-26 08:37:08.574888	2021-12-09 05:39:17.857894	/admin/product-suggestions	\N	\N	admin	\N
f20f6b6e-0870-43f4-b2f3-53c6e68a70dd	new group	New group has been created for SAMSUNG 870 QVO SATA III 2.5" SSD 1TB (MZ-77Q1T0B)	f	2021-12-10 05:06:33.651911	2021-12-10 05:06:33.651911	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
41c018da-c3b1-4aed-b1a7-474ae9467ca6	new group	New group has been created for Intel Core i7-10700K Desktop Processor 8 Cores up to 5.1 GHz Unlocked LGA1200 (Intel 400 Series Chipset) 125W (BX8070110700K)	f	2021-12-10 05:14:35.427758	2021-12-10 05:14:35.427758	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
c544058d-7a0a-4c3b-b997-abb1b888c69e	new bidding	New bidding started for Intel Core i7-10700K Desktop Processor 8 Cores up to 5.1 GHz Unlocked LGA1200 (Intel 400 Series Chipset) 125W (BX8070110700K) group	t	2021-12-10 05:14:35.902603	2021-12-10 05:14:35.902603	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
26d5b4cc-c51f-4e4a-b2ad-bcc1ff2a8fb8	crawler done	Crawling for sellers is done for product "Intel Core i7-10700K Desktop Processor 8 Cores up to 5.1 GHz Unlocked LGA1200 (Intel 400 Series Chipset) 125W (BX8070110700K)". Found 7 results	t	2021-12-10 05:18:21.373159	2021-12-10 05:18:21.373159	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
c3925ef6-52fb-4072-9d82-507946f35c67	new group	New group has been created for WD 5TB My Passport Portable External Hard Drive HDD, USB 3.0, USB 2.0 Compatible, Black - WDBPKJ0050BBK-WESN	f	2021-12-10 05:21:17.203442	2021-12-10 05:21:17.203442	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
5519aea1-b9d8-42b1-a6f6-216caf5131ee	new bidding	New bidding started for WD 5TB My Passport Portable External Hard Drive HDD, USB 3.0, USB 2.0 Compatible, Black - WDBPKJ0050BBK-WESN group	t	2021-12-10 05:21:17.595925	2021-12-10 05:21:17.595925	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
ccaad73f-6347-4d15-b10f-23635c11739d	new group	New group has been created for L.O.L. Surprise Dolls Sparkle Series A, Multicolor	f	2021-12-10 05:31:19.029877	2021-12-10 05:31:19.029877	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
09fd7614-8f6b-4c3b-97b0-7043c2f72806	new group	New group has been created for L.O.L. Surprise Dolls Sparkle Series A, Multicolor	f	2021-12-10 05:35:01.55381	2021-12-10 05:35:01.55381	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
98fe8379-4402-4d97-8aab-b1311c3c4cd2	new bidding	New bidding started for L.O.L. Surprise Dolls Sparkle Series A, Multicolor group	t	2021-12-10 05:35:02.349334	2021-12-10 05:35:02.349334	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
e3a21d58-6d13-4a49-b114-a924d9852160	crawler done	Crawling for sellers is done for product "L.O.L. Surprise Dolls Sparkle Series A, Multicolor". Found 2 results	t	2021-12-10 05:36:36.809587	2021-12-10 05:36:36.809587	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
c52a931e-befe-44d3-8264-ed448e043f8e	new group	New group has been created for External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook	f	2021-12-10 05:48:51.574544	2021-12-10 05:48:51.574544	#	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
cc5a9e88-ae3a-4fa1-8a54-f40545891833	new bidding	New bidding started for External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook group	t	2021-12-10 05:48:51.971556	2021-12-10 05:48:51.971556	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
4cb066e4-4fb7-494c-8cf4-31f03794e738	crawler done	Crawling for sellers is done for product "External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook". Found 1 results	t	2021-12-10 05:49:52.280197	2021-12-10 05:49:52.280197	/admin/managebids	\N	\N	admin	826be7c9-b01e-4690-8cc3-e1dc75aadf85
68d58021-8ebd-4ceb-a529-ff10961a29c3	new bidder	New bid posted on External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook group	t	2021-12-10 07:51:08.133353	2021-12-10 07:51:08.133353	/admin/managebids	\N	\N	admin	\N
08d3603c-529e-4d0c-9631-03e8bb740757	new bidder	New bid posted on PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S group	t	2021-12-17 05:23:24.665557	2021-12-17 05:23:24.665557	/admin/managebids	\N	\N	admin	\N
f427b536-872b-4c1d-b430-4272734035f6	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\nPowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S	f	2021-12-17 05:23:58.524316	2021-12-17 05:23:58.524316	/admin/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0c50b4da-2b20-44a0-bdef-ee7ad7a86e4e	BID WINNER	Congratulations! You have won the bidding for PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S! Please see your seller dashboard for more details.	f	2021-12-17 05:23:58.528006	2021-12-17 05:23:58.528006	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
a71ba4d5-df03-424b-b991-f778040ae173	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-17 06:04:30.277763	2021-12-17 06:04:30.277763	/admin/product-suggestions	\N	\N	admin	\N
2bb7a5e7-25ac-4eb0-9c69-00808df32aa8	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-17 06:09:13.288589	2021-12-17 06:09:13.288589	/admin/product-suggestions	\N	\N	admin	\N
7f08bb69-0b20-4cd1-9905-39ea13cae3c7	new group	New group has been created for 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	f	2021-12-17 06:37:59.186051	2021-12-17 06:37:59.186051	#	\N	\N	admin	\N
b653170f-dc93-43cf-9f67-6125fb4314fc	new bidding	New bidding started for 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock group	t	2021-12-17 06:37:59.959349	2021-12-17 06:37:59.959349	/admin/managebids	\N	\N	admin	\N
905b8686-6f6f-425a-b0e8-ff3fad4c4421	crawler done	Crawling for sellers is done for product "2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock". Found 0 results	t	2021-12-17 06:38:03.219243	2021-12-17 06:38:03.219243	/admin/managebids	\N	\N	admin	\N
b7085c8b-6405-4afc-8572-6a25728766ac	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-17 06:47:47.344465	2021-12-17 06:47:47.344465	/admin/product-suggestions	\N	\N	admin	\N
43dcc87c-9031-4053-9b4e-bd6a369b43e1	new group	New group has been created for 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	f	2021-12-17 06:49:01.864943	2021-12-17 06:49:01.864943	#	\N	\N	admin	\N
bfcf4ef1-4387-4c12-9ccb-f0a335c96344	new bidding	New bidding started for 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock group	t	2021-12-17 06:49:03.120487	2021-12-17 06:49:03.120487	/admin/managebids	\N	\N	admin	\N
a58191fb-92fb-42f6-833f-03d90cd1456a	crawler done	Crawling for sellers is done for product "2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock". Found 0 results	t	2021-12-17 06:49:04.891077	2021-12-20 01:40:05.480392	/admin/managebids	\N	\N	admin	\N
9aca69c1-1ebb-4b17-933e-47bf24259aec	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-22 05:51:22.102278	2021-12-22 05:51:22.102278	/admin/product-suggestions	\N	\N	admin	\N
45456d29-ff6c-4264-8ad1-c7f4564629a5	Group Suggestion approved	Your product group for Playstation DualSense Wireless Controller has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2021-12-22 05:51:50.812422	2021-12-22 05:51:50.812422	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c6445dac-4688-4e96-92f0-440853f9e6be	new group	New group has been created for Playstation DualSense Wireless Controller	f	2021-12-22 05:51:50.834331	2021-12-22 05:51:50.834331	#	\N	\N	admin	\N
e6864278-f42c-4fcd-a8fa-fabc63a3e5c3	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-22 06:09:30.277438	2021-12-22 06:09:30.277438	/admin/product-suggestions	\N	\N	admin	\N
509ab5cf-9079-4229-8204-abe2ba75bb49	new bidder	New bid posted on test group	t	2021-12-23 06:02:43.736145	2021-12-23 06:02:43.736145	/admin/managebids	\N	\N	admin	\N
960fae9c-fe90-45e1-aa2d-23af097dff83	BID WINNER	Congratulations! You have won the bidding for test! Please see your seller dashboard for more details.	f	2021-12-23 06:03:22.364798	2021-12-23 06:03:22.364798	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
5f8be33f-730e-41c2-8509-f21f97cec87e	new bidder	New bid posted on PlayStation DualSense Wireless Controller – Midnight Black  group	t	2021-12-23 06:04:48.353807	2021-12-23 06:04:48.353807	/admin/managebids	\N	\N	admin	\N
2bd3c0ff-b685-4b1e-a6c4-9bde966b9fc7	BID WINNER	Congratulations! You have won the bidding for PlayStation DualSense Wireless Controller – Midnight Black ! Please see your seller dashboard for more details.	f	2021-12-23 06:05:16.525391	2021-12-23 06:05:16.525391	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
734b4bd9-8107-4e07-80ce-ef500c7bef89	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-23 06:39:30.006604	2021-12-23 06:39:30.006604	/admin/product-suggestions	\N	\N	admin	\N
74f62f13-32c2-47ec-b6c4-32b48a916a38	new group	New group has been created for Fjallraven, Kanken Classic Backpack for Everyday, Graphite	f	2021-12-23 06:41:08.709986	2021-12-23 06:41:08.709986	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
5f445767-4b4f-45c2-8c03-0d52f8af00dc	new bidding	New bidding started for Fjallraven, Kanken Classic Backpack for Everyday, Graphite group	t	2021-12-23 06:41:09.139509	2021-12-23 06:41:09.139509	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
72cdcb31-f3e3-486e-9e68-2cca5f2fcee9	crawler done	Crawling for sellers is done for product "Fjallraven, Kanken Classic Backpack for Everyday, Graphite". Found 10 results	t	2021-12-23 06:47:09.563119	2021-12-23 06:47:09.563119	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
5050194b-5abe-488b-b4e0-c4432bd50e2a	new group	New group has been created for ps5	f	2021-12-23 06:50:38.461647	2021-12-23 06:50:38.461647	#	\N	\N	admin	\N
72e0e625-21ad-4b1e-a28b-acc9f08b3589	new bidding	New bidding started for ps5 group	t	2021-12-23 06:50:39.312065	2021-12-23 06:50:39.312065	/admin/managebids	\N	\N	admin	\N
ddb777ac-6e3d-4e1b-bcbd-57061299e06b	new group	New group has been created for ps5	f	2021-12-23 06:51:53.398257	2021-12-23 06:51:53.398257	#	\N	\N	admin	\N
24972ed2-14e7-4f3b-901e-fcc554c87d0d	new bidding	New bidding started for ps5 group	t	2021-12-23 06:51:54.454501	2021-12-23 06:51:54.454501	/admin/managebids	\N	\N	admin	\N
c53432b8-73f2-4ea0-a3a9-72206654390d	crawler done	Crawling for sellers is done for product "ps5". Found 10 results	t	2021-12-23 06:54:43.67139	2021-12-23 06:54:43.67139	/admin/managebids	\N	\N	admin	\N
1475df0c-9158-46da-a1e6-0ec7dd0d568e	crawler done	Crawling for sellers is done for product "ps5". Found 10 results	t	2021-12-23 06:54:47.387377	2021-12-23 06:54:47.387377	/admin/managebids	\N	\N	admin	\N
b7298d47-e1e0-4791-9c66-222ccd14d5d3	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2021-12-23 07:34:56.36915	2021-12-23 07:34:56.36915	/admin/product-suggestions	\N	\N	admin	\N
92b45f39-6275-4565-a3b5-3b4dfc462921	new group	New group has been created for ps5 with seller	t	2021-12-23 07:38:33.487462	2021-12-27 06:54:36.923664	#	\N	\N	admin	\N
d7292c5a-f7a3-440d-9027-72bf53a4fb53	Group Suggestion approved	Your product group for ps5 with seller has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-12-23 07:38:33.47214	2022-01-04 03:46:44.757079	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
84ae3aa6-2be0-497c-8a4d-e19c977494d1	new seller application approved	A seller application has been approved, check the manage sellers tab.	f	2022-01-06 07:51:08.305883	2022-01-06 07:51:08.305883	/admin/seller-applicant	\N	\N	admin	3a661f4d-f630-437d-842c-ea9f9b9e7cca
ce5cb432-11f2-4374-9ddf-095293e43d33	new seller application	Thank you for applying to join our seller community! We are excited to have you with us.  We are reviewing your application now and we will get back to you soon on your approval status.  	f	2022-01-06 09:14:28.580765	2022-01-06 09:14:28.580765	/admin/seller-applicant	\N	\N	admin	\N
d8a82146-763d-4735-982f-60d74b08ffcd	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-07 01:14:12.817237	2022-01-07 01:14:12.817237	/admin/product-suggestions	\N	\N	admin	\N
f6955f2b-aa44-43d4-a5e5-0fc94683fda1	Group Suggestion approved	Your product group for London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-07 01:32:05.794551	2022-01-07 01:32:05.794551	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
f05bef0a-0454-4aff-883f-208b893d2032	new group	New group has been created for London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	f	2022-01-07 01:32:05.837212	2022-01-07 01:32:05.837212	#	\N	\N	admin	\N
cdc5a827-0a8c-4a16-8ebd-6390fb43cde1	Group Suggestion approved	Your product group for Smart WiFi Light Bulbs, LED Color Changing Lights, Works with Alexa & Google Home, RGBW 2700K-6500K, 60 Watt Equivalent, Dimmable with App, A19 E26, No Hub Required, 2.4GHz WiFi (4 Pack) has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-07 03:43:37.739011	2022-01-07 03:43:37.739011	/seller/mybids	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	seller	\N
8b08f424-febc-4aec-b761-50fa1af36b92	new group	New group has been created for Smart WiFi Light Bulbs, LED Color Changing Lights, Works with Alexa & Google Home, RGBW 2700K-6500K, 60 Watt Equivalent, Dimmable with App, A19 E26, No Hub Required, 2.4GHz WiFi (4 Pack)	f	2022-01-07 03:43:37.756424	2022-01-07 03:43:37.756424	#	\N	\N	admin	\N
04f0c76b-b5bb-433b-a55e-fd1b5c350c3b	new bidder	New bid posted on 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock group	t	2022-01-07 05:16:29.074896	2022-01-07 05:16:29.074896	/admin/managebids	\N	\N	admin	\N
4047c013-e727-4e12-bfcb-3208f4c2793e	BID WINNER	Congratulations! You have won the bidding for 2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock! Please see your seller dashboard for more details.	f	2022-01-07 05:17:57.130438	2022-01-07 05:17:57.130438	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
d62bde5a-b635-4279-b387-6f7cfbd00f83	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\n2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	f	2022-01-07 05:17:57.133174	2022-01-07 05:17:57.133174	/admin/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
06eaac5e-69b1-42b9-b3f2-b498cd520578	new group	New group has been created for VERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	f	2022-01-07 05:47:16.575261	2022-01-07 05:47:16.575261	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
9fd641fc-d7cf-4b18-9887-a5a4ab80b9bf	new bidding	New bidding started for VERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon group	t	2022-01-07 05:47:16.980576	2022-01-07 05:47:16.980576	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
cc2eb9f2-6ce5-4754-b59a-04159ac27a4d	new group	New group has been created for Crucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	f	2022-01-07 05:49:32.388222	2022-01-07 05:49:32.388222	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
9e3d6e79-2f45-4e92-923d-fbfe3249b1b5	new bidding	New bidding started for Crucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1 group	t	2022-01-07 05:49:32.780646	2022-01-07 05:49:32.780646	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
40eae9f9-e7c1-4f35-a402-9bec86b59c9e	crawler done	Crawling for sellers is done for product "VERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon". Found 10 results	t	2022-01-07 05:52:32.516061	2022-01-07 05:52:32.516061	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
dcb8ddb9-4678-4a04-a6ec-ff361be9238c	crawler done	Crawling for sellers is done for product "Crucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1". Found 10 results	t	2022-01-07 05:52:33.873786	2022-01-07 05:52:33.873786	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
b06e7a0e-3bbe-4bf5-bb73-03bed11142ce	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-07 08:20:57.126439	2022-01-07 08:20:57.126439	/admin/product-suggestions	\N	\N	admin	\N
de3b1b76-7fbe-4b61-addf-344a63e2ecd7	seller application approved	Congratulations, your seller application has been approved! We are excited to have you join us! Please login and view your dashboard for further details.	t	2022-01-06 07:51:08.306473	2022-01-10 05:20:28.446482	/admin/dashboard	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
b5122996-b829-4657-b315-1a4ef485f034	change role	Your role has changed, you are now a seller. Please check your new seller dashboard in your account menu.	t	2022-01-06 07:51:08.905659	2022-01-10 05:20:30.336239	/admin/dashboard	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	3a661f4d-f630-437d-842c-ea9f9b9e7cca
b9b12c9e-b876-4749-ad48-684b402d9557	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-18 06:01:57.279173	2022-01-18 06:01:57.279173	/admin/product-suggestions	\N	\N	admin	\N
30c0bf02-1b87-44bc-8f60-8b864a33df14	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-25 09:31:08.22709	2022-01-25 09:31:08.22709	/admin/product-suggestions	\N	\N	admin	\N
9f640736-800e-40d1-9b1c-2d79b18996e8	crawler done	Crawling for sellers is done for product "this is a test". Found 10 results	t	2022-03-03 08:53:23.670454	2022-03-03 08:53:23.670454	/admin/managebids	\N	\N	admin	\N
a2d56b9c-f668-4d60-8fd4-93a18ef61a3e	Group Suggestion approved	Your product group for Timberland Short Watch Cap has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-07 08:21:20.82309	2022-01-07 08:21:20.82309	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6be0fb91-8519-4b79-afe5-74553de71c24	new group	New group has been created for Timberland Short Watch Cap	f	2022-01-07 08:21:20.836999	2022-01-07 08:21:20.836999	#	\N	\N	admin	\N
b6c9d169-51d6-4778-b5f8-9429a824c9cc	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 02:37:54.493437	2022-01-10 02:37:54.493437	/admin/product-suggestions	\N	\N	admin	\N
61524cab-758e-482a-ada0-31f9b450b454	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 02:38:38.841024	2022-01-10 02:38:38.841024	/admin/product-suggestions	\N	\N	admin	\N
9e22370e-d320-4cb6-9d59-07954647f01d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 02:53:30.703707	2022-01-10 02:53:30.703707	/admin/product-suggestions	\N	\N	admin	\N
e277d684-1a95-4045-b36a-8f0740ec9254	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 05:06:56.94294	2022-01-10 05:06:56.94294	/admin/product-suggestions	\N	\N	admin	\N
9d1e50d5-f701-4138-8e4b-c6f6244b6e8b	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 07:42:16.540963	2022-01-10 07:42:16.540963	/admin/product-suggestions	\N	\N	admin	\N
52be2827-b3da-4509-bba8-6f8824ea57db	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 07:51:44.768367	2022-01-10 07:51:44.768367	/admin/product-suggestions	\N	\N	admin	\N
9dbe76fc-e308-4555-a7fa-079472790eda	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 07:52:08.020041	2022-01-10 07:52:08.020041	/admin/product-suggestions	\N	\N	admin	\N
e51cb1f3-d1fd-4faf-ba20-5833457863fe	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-10 07:53:12.717448	2022-01-10 07:53:12.717448	/admin/product-suggestions	\N	\N	admin	\N
e5066b8a-8ffe-4c79-8ecf-105c8f173615	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-11 08:49:57.133696	2022-01-11 08:49:57.133696	/admin/product-suggestions	\N	\N	admin	\N
81246692-0008-46f7-96f5-e5c5ba4ed0a9	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-11 08:51:38.23718	2022-01-11 08:51:38.23718	/admin/product-suggestions	\N	\N	admin	\N
a7a7bcf4-4d26-47e8-b104-c8b1ca1ae080	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-11 08:52:25.658362	2022-01-11 08:52:25.658362	/admin/product-suggestions	\N	\N	admin	\N
896bb5a4-9a4f-499c-8a55-708d41d9d519	new seller application	Thank you for applying to join our seller community! We are excited to have you with us.  We are reviewing your application now and we will get back to you soon on your approval status.  	f	2022-01-11 08:59:09.556322	2022-01-11 08:59:09.556322	/admin/seller-applicant	\N	\N	admin	\N
b768b8ff-a5cc-43d0-bbae-e454c45b857c	new seller application declined	A seller application has been declined.	f	2022-01-11 09:03:06.90389	2022-01-11 09:03:06.90389	#	\N	\N	admin	3a661f4d-f630-437d-842c-ea9f9b9e7cca
aa850788-f98d-43ed-820e-bde459397992	new seller application declined	A seller application has been declined.	f	2022-01-11 09:03:15.474577	2022-01-11 09:03:15.474577	#	\N	\N	admin	3a661f4d-f630-437d-842c-ea9f9b9e7cca
d4f91971-e8d0-4dc0-88fa-079078381267	seller application declined	At this time your seller application has been declined.  We contact us for details.  Once we have resolved any outstanding questions please re-apply.	t	2022-01-11 09:03:15.474897	2022-01-12 01:32:54.337665	#	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	3a661f4d-f630-437d-842c-ea9f9b9e7cca
05aa4507-1d5b-40ea-9808-35f6a28f8981	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-12 01:44:33.125872	2022-01-12 01:44:33.125872	/admin/product-suggestions	\N	\N	admin	\N
c4019b44-67e8-4cad-879e-32072b4e62be	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-12 01:47:37.679289	2022-01-12 01:47:37.679289	/admin/product-suggestions	\N	\N	admin	\N
1386b58f-f977-4cc7-8fea-9a54c4b7d7ec	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-12 01:48:54.864788	2022-01-12 01:48:54.864788	/admin/product-suggestions	\N	\N	admin	\N
116273af-3852-4e54-ba55-13a52dab6073	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-12 02:37:07.309434	2022-01-12 02:37:07.309434	/admin/product-suggestions	\N	\N	admin	\N
2c7b53b2-b7d0-42db-a59e-511f6b2bee85	new category	electronics category created, electronics	t	2022-01-12 08:11:28.033898	2022-01-12 08:11:28.033898	/admin/category	\N	\N	admin	\N
628fe486-9195-4b54-aab3-b126a8312c15	new category	electronics category created, electronics	t	2022-01-12 08:36:24.948823	2022-01-12 08:36:24.948823	/admin/category	\N	\N	admin	\N
4d32bdd9-a026-44a9-a074-dada853a2fa7	seller application declined	At this time your seller application has been declined.  We contact us for details.  Once we have resolved any outstanding questions please re-apply.	t	2022-01-11 09:03:06.9043	2022-01-13 02:16:04.615175	#	\N	3fb53321-ff41-4a66-9bba-1b6bc3464c1c	user	3a661f4d-f630-437d-842c-ea9f9b9e7cca
27f9de61-e610-4c4d-82e2-39c757843750	change role	Your role has changed, you are now a seller. Please check your new seller dashboard in your account menu.	t	2022-01-11 08:38:25.279564	2022-01-13 02:16:10.324305	/admin/dashboard	\N	f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	user	e498f885-498f-4a95-afa0-9370f4a6a866
f20e60a7-349f-4ca0-b9ce-7ef52677e4bb	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-13 05:43:24.152653	2022-01-13 05:43:24.152653	/admin/product-suggestions	\N	\N	admin	\N
fa8678d1-85f5-431a-91bb-2c4ed057d152	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-13 05:47:06.032558	2022-01-13 05:47:06.032558	/admin/product-suggestions	\N	\N	admin	\N
d4a98fb2-c4cd-46be-8695-320d3966f4a6	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-13 05:57:10.985814	2022-01-13 05:57:10.985814	/admin/product-suggestions	\N	\N	admin	\N
a95faa59-b127-4fcd-ac4e-6fb882322b7e	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-13 09:00:17.5346	2022-01-13 09:00:17.5346	/admin/product-suggestions	\N	\N	admin	\N
cfb9b222-6eac-4cf2-9c05-6d6edd22c53f	new category	Accessories category created, Accessories	t	2022-01-17 09:25:43.144214	2022-01-17 09:25:43.144214	/admin/category	\N	\N	admin	\N
759979ef-8d21-4c53-b796-95c711381212	new category	electronics category created, electronics	t	2022-01-17 09:31:34.335488	2022-01-17 09:31:34.335488	/admin/category	\N	\N	admin	\N
8c5e50cf-b873-4b12-aa10-a11e9eab95fd	new category	electronics category created, electronics	t	2022-01-17 09:31:34.58652	2022-01-17 09:31:34.58652	/admin/category	\N	\N	admin	\N
30923cef-730c-4c5f-b45c-2f1d2310fb66	new category	Sports category created, Sports	t	2022-01-17 09:31:41.875336	2022-01-17 09:31:41.875336	/admin/category	\N	\N	admin	\N
9b2de4ac-427c-446c-9a09-b7825d4da099	new category	Tools category created, Tools	t	2022-01-17 09:32:09.911613	2022-01-17 09:32:09.911613	/admin/category	\N	\N	admin	\N
c35a69e7-88d6-4993-830a-f8b8acda9680	new category	Clothing category created, Clothing	t	2022-01-17 09:32:40.046419	2022-01-17 09:32:40.046419	/admin/category	\N	\N	admin	\N
8131c537-d02d-4d49-97e0-0c6ab1039d1d	new category	Furniture category created, Furniture	t	2022-01-17 09:33:11.011126	2022-01-17 09:33:11.011126	/admin/category	\N	\N	admin	\N
5a8225ca-82c5-4441-b2ea-f8eb5346e97b	new category	Home category created, Home	t	2022-01-17 09:33:53.584459	2022-01-17 09:33:53.584459	/admin/category	\N	\N	admin	\N
b7a3b270-9ae6-4907-bd51-b0f9a25b6582	new category	electronics category created, electronics	t	2022-01-17 09:34:04.22018	2022-01-17 09:34:04.22018	/admin/category	\N	\N	admin	\N
0ad5b353-da9a-43cb-8d72-2283e336e381	new category	electronics category created, electronics	t	2022-01-17 09:34:20.685097	2022-01-17 09:34:20.685097	/admin/category	\N	\N	admin	\N
08bb9154-ae0d-49c1-96fd-681be87ffad1	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nCrucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	f	2022-01-19 03:35:11.926888	2022-01-19 03:35:11.926888	#	\N	\N	admin	\N
0db56b5e-77cf-4952-8c3f-eec5d62896f8	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nCrucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	f	2022-01-19 03:40:03.39062	2022-01-19 03:40:03.39062	#	\N	\N	admin	\N
e976c04b-03f4-474e-ad9e-43803ae4565d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-26 03:49:28.913734	2022-01-26 03:49:28.913734	/admin/product-suggestions	\N	\N	admin	\N
c1a4c7af-4f48-4ae0-8918-a0d2b5de6247	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-28 02:53:15.467549	2022-01-28 02:53:15.467549	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
217d8449-f330-4d50-aa62-005514a69ffc	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 03:39:36.264204	2022-02-08 03:39:36.264204	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
399d8b5a-4a9d-4cef-a8dc-889b2523d5eb	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:59 AM to 2/16/2022, 8:59:00 AM.	f	2022-02-14 07:32:19.295708	2022-02-14 07:32:19.295708	#	\N	\N	admin	\N
4eba722b-37a6-457e-8506-c686591b561b	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 07:51:16.486238	2022-02-17 07:51:16.486238	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
9795bec2-92f3-46b5-9a7d-40ad4684049c	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:39:42.181869	2022-02-23 05:39:42.181869	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
84f03ec3-78f8-4b8e-8278-99dd01ee40d1	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-24 04:20:31.162439	2022-02-24 04:20:31.162439	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
a80edc86-9aa1-47ef-bc21-a19b96186809	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:49:48.112092	2022-03-01 01:49:48.112092	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
72214a3b-9367-448c-be82-4e3790489295	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 03:11:04.510322	2022-03-04 03:11:04.510322	/admin/product-suggestions	\N	\N	admin	\N
e9c8570f-6df0-4369-95bb-d9c7984b4fa8	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-08 06:00:44.546188	2022-03-08 06:00:44.546188	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
fd23aab6-bf20-44a2-9215-a2631508fab7	Price change	One of the groups that you've joined had a price change. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 02:42:22.258285	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
09d36910-cc81-4b8c-a729-1cea4e125870	Group removed	We are sorry to inform you that we removed the group this is a test.	t	2022-03-04 09:18:20.474382	2022-03-29 08:10:40.163553	#	58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
9ef5c302-f740-4ce8-b882-765e1ffe96c3	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-10 09:26:37.154131	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
faf072e8-e723-4a98-bee7-c882ff031f58	Join group	You successfully joined this group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	t	2022-03-18 09:39:03.627678	2022-03-29 08:10:40.163553	/product-page/1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
0aa2a7bc-8756-4678-8e89-81766a18af82	crawler done	Crawling for sellers is done for product "ps5". Found 1 results	t	2022-03-31 09:26:30.179222	2022-03-31 09:26:30.179222	/admin/managebids	\N	\N	admin	\N
99058c79-d033-430d-a8c8-c61b2b2009c5	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.261482	2022-04-04 15:20:32.261482	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
b7d6aa67-bcff-45bf-beeb-22a96eafde57	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-26 08:54:27.806532	2022-01-26 08:54:27.806532	/admin/product-suggestions	\N	\N	admin	\N
e6173feb-b1c5-4de2-b24e-efff0b71e313	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-28 03:19:55.588156	2022-01-28 03:19:55.588156	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
786c04ed-bd2c-4a97-902a-04dd16be5d8b	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 03:42:36.653952	2022-02-08 03:42:36.653952	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ee5fbdad-6ff5-4965-90ed-89e6b9d5c00d	group is full	Hooray! Your group 'APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers' is full! Click here for more details about payment status.	f	2022-02-15 02:44:46.333021	2022-02-15 02:44:46.333021	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c93cab0c-438f-4764-98e0-19d8efc4d1f6	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 09:44:55.573516	2022-02-17 09:44:55.573516	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
24710a17-2815-40d9-828d-616d3a088bb7	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:44:57.074429	2022-02-23 05:44:57.074429	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6266f7db-85e9-48c5-9823-1b5f2f171ddd	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 04:27:46.137796	2022-02-24 04:27:46.137796	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
dc2a64ea-f027-4c2d-ac43-4c207c82734a	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:51:20.158228	2022-03-01 01:51:20.158228	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
723d9318-c762-43f8-8858-664632acb646	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 03:12:18.601141	2022-03-04 03:12:18.601141	/admin/product-suggestions	\N	\N	admin	\N
14badea5-c64f-4ba9-ace2-2ed14a833de6	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-08 07:43:52.045683	2022-03-08 07:43:52.045683	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
751ca1a0-c8d1-4ac8-8e54-03a2bd87153d	GROUP DEADLINE CHANGED	Your group ps5 with seller deadline has been changed from 'Wed Feb 23 2022' to 'Sat Mar 12 2022' by the admin.	f	2022-03-09 02:49:39.059999	2022-03-09 02:49:39.059999	/seller/mygroups	606ed0f4-9106-49c4-9efb-b0a49e098bba	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
79855130-ac25-4e6e-aeeb-8a465fc27fc8	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	f	2022-03-09 02:49:40.162318	2022-03-09 02:49:40.162318	#	\N	\N	admin	\N
1a454dba-d751-4866-9cc9-43f99fc3fde4	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-10 09:26:37.177666	2022-03-10 09:26:37.177666	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
fe7a3743-9919-4198-a7b1-6cdbcc8bab9f	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-18 09:39:03.638853	2022-03-18 09:39:03.638853	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
49ae7fdf-0276-4f9f-b62a-a388bfa01ccd	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nCrucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	t	2022-01-19 03:40:03.394355	2022-03-29 08:10:40.163553	/product-page/3949b32d-7c71-4f57-91f0-2ddf97e86007	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
571ba8bb-0fea-4383-aada-3a1009478675	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:59 AM to 2/16/2022, 8:59:00 AM.	t	2022-02-14 07:32:19.300335	2022-03-29 08:10:40.163553	/product-page/9a398999-4cb9-4f15-a411-1ebd5bc21eff	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
4b56a540-2689-4591-860a-6323a44eff04	Group removed	We are sorry to inform you that we removed the group ADIDAS.	t	2022-03-04 09:24:34.257916	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
a3a43ca3-9bf9-4744-a628-d61c1745d8a4	crawler done	Crawling for sellers is done for product "ps5". Found 1 results	t	2022-03-31 09:28:59.007817	2022-03-31 09:28:59.007817	/admin/managebids	\N	\N	admin	\N
b37b08de-1739-4059-86fc-c452c2d501d4	GROUP DEADLINE CHANGED	Your group Grassman Camping Tarp, Ultralight Waterproof deadline has been changed from 'Fri Apr 01 2022' to 'Fri Apr 15 2022' by the admin.	f	2022-04-03 01:16:02.900371	2022-04-03 01:16:02.900371	/seller/mygroups	7934d13e-087a-4831-85cb-c8a163a67bfb	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0078221e-7b98-4d60-8da2-ec3b1108c215	group deadline changed	The group Grassman Camping Tarp, Ultralight Waterproof deadline has been changed from 4/1/2022, 9:59:59 AM to 4/15/2022, 9:59:00 AM.	f	2022-04-03 01:16:02.950114	2022-04-03 01:16:02.950114	#	\N	\N	admin	\N
1ad5fd36-a294-4f8f-9e96-fc521d903a83	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.262348	2022-04-04 15:20:32.262348	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
cf798aa6-a688-4b40-a000-341a79f49ff7	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	f	2022-01-19 03:43:04.213431	2022-01-19 03:43:04.213431	#	\N	\N	admin	\N
5bd4d3e5-d2fb-4721-929e-0ec817c2ef97	Group Suggestion approved	Your product group for Amazon Essentials Men's Heavyweight Hooded Puffer Coat has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-26 08:55:18.86611	2022-01-26 08:55:18.86611	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
34fb0b0c-904e-43f2-83cc-e89f120bf4ef	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-28 03:31:48.449184	2022-01-28 03:31:48.449184	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e77bda62-00e9-4b39-8e39-a0a3bd9e0fd5	GROUP DEADLINE CHANGED	Your group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 'Wed Feb 16 2022' to 'Wed Feb 16 2022' by the admin.	f	2022-02-14 07:41:09.73561	2022-02-14 07:41:09.73561	/seller/mygroups	9a398999-4cb9-4f15-a411-1ebd5bc21eff	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
7359c85c-c56b-4fe5-b400-7aa6ee22985a	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-15 02:48:30.207848	2022-02-15 02:48:30.207848	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c44af767-2604-4201-8c54-cbf0af80d36d	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 09:50:12.632051	2022-02-17 09:50:12.632051	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6a86bfb7-e10e-428f-8d28-40642ac23e56	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:45:26.143499	2022-02-23 05:45:26.143499	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
05eec20a-c8dc-4988-af54-374616df38a9	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 06:45:20.21791	2022-02-24 06:45:20.21791	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
5f3a6169-e94a-48d9-8d24-6bd5bb414910	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 02:04:43.108556	2022-03-01 02:04:43.108556	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0fc0e30d-ec56-4d7b-b9c8-24c91e9195dc	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 03:28:10.486189	2022-03-04 03:28:10.486189	/admin/product-suggestions	\N	\N	admin	\N
d7d4e583-5ee6-4d46-8540-3a86476c0acd	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2022-03-04 09:28:57.431763	2022-03-08 02:45:53.370893	/admin/product-suggestions	\N	\N	admin	\N
2e3776a2-d4fa-4b51-a510-f6c24ae7bb94	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-08 08:50:53.246454	2022-03-08 08:50:53.246454	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
bd3acb7e-738d-4a63-9a59-7ceeca83fc02	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group adidas.	f	2022-03-11 05:40:08.240739	2022-03-11 05:40:08.240739	/product-page/${group_id}	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e7a1d853-083c-44ca-939e-f5a6c663151e	user	\N
d1182387-ec10-423b-a64f-6077a4862455	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-21 08:02:47.604634	2022-03-21 08:02:47.604634	/admin/product-suggestions	\N	\N	admin	\N
750cfdcd-c40b-4acd-8051-fd3e7a7c6343	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 03:45:03.990381	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
45eba3f5-29e7-401f-a132-9cd5719df709	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	t	2022-03-09 02:49:40.165148	2022-03-29 08:10:40.163553	/product-page/606ed0f4-9106-49c4-9efb-b0a49e098bba	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
36fb79c5-b741-44dd-ae67-4a553a825560	group deadline changed	The group Grassman Camping Tarp, Ultralight Waterproof deadline has been changed from 4/1/2022, 9:59:59 AM to 4/15/2022, 9:59:00 AM.	f	2022-04-03 01:16:02.954226	2022-04-03 01:16:02.954226	/product-page/7934d13e-087a-4831-85cb-c8a163a67bfb	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
0ad7aab8-9e02-4965-b1f1-d8d71b85351f	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.262562	2022-04-04 15:20:32.262562	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
27318c10-db58-4214-9f6d-5d0d9d3e0a61	new group	New group has been created for Amazon Essentials Men's Heavyweight Hooded Puffer Coat	f	2022-01-26 08:55:18.882474	2022-01-26 08:55:18.882474	#	\N	\N	admin	\N
9fea0a2e-1b89-4fbe-b112-8232814cb8db	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 05:17:30.761397	2022-02-08 05:17:30.761397	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
1476d0e1-c107-4f43-a6b0-694ff8d0e8de	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	f	2022-02-14 07:41:09.750894	2022-02-14 07:41:09.750894	#	\N	\N	admin	\N
30af2f7f-f25f-4ea9-8859-b045325c5ed6	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-15 02:49:02.138425	2022-02-15 02:49:02.138425	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c60c6ca3-3c7d-423d-a396-adcc00f0d877	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-15 02:49:13.357442	2022-02-15 02:49:13.357442	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
8e1f0571-62b7-40ab-b6f2-758e40b15aa0	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 09:53:18.992613	2022-02-17 09:53:18.992613	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
4c7093b6-e7bb-4dc0-ba60-e53a7eaaccc5	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:46:50.224866	2022-02-23 05:46:50.224866	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
58f1827d-418a-424f-8d1b-659f3f79c26b	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-24 07:07:09.423963	2022-02-24 07:07:09.423963	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
1d3ba69e-b2d6-4e41-987e-945ded6bb92a	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-01 08:34:40.346776	2022-03-01 08:34:40.346776	/admin/product-suggestions	\N	\N	admin	\N
4e7b52ef-3e75-4ad6-8be1-9e520c497624	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 03:34:39.939943	2022-03-04 03:34:39.939943	/admin/product-suggestions	\N	\N	admin	\N
c0cc7b06-b218-48e9-90ff-b4905f7f48db	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:38:31.701403	2022-03-07 02:38:31.701403	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
40d15fae-246b-4081-b518-f876f5e69ad5	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-08 09:34:32.514424	2022-03-08 09:34:32.514424	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
64d90474-50f5-43a3-8fd4-3338d1b2750a	Join group	You successfully joined this group 1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d.	t	2022-03-09 02:09:54.241807	2022-03-29 08:10:40.163553	/product-page/1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
fedbe6a7-8c0e-497e-9e1b-6b4012ad4805	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	f	2022-03-09 02:49:40.165449	2022-03-09 02:49:40.165449	/product-page/606ed0f4-9106-49c4-9efb-b0a49e098bba	\N	8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	user	\N
25485c8d-641a-4d66-87e0-216ab3a05126	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group adidas.	f	2022-03-11 05:49:25.858852	2022-03-11 05:49:25.858852	/product-page/${group_id}	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	dba74431-a1c3-4baa-8b10-d050b8a6a90b	user	\N
a2151774-fff6-424b-ab86-96aef3c4010d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-21 08:09:34.990111	2022-03-21 08:09:34.990111	/admin/product-suggestions	\N	\N	admin	\N
6ebadb63-76e4-43b6-8f8f-a252c8dfe959	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	t	2022-01-19 03:43:04.216538	2022-03-29 08:10:40.163553	/product-page/60181685-b4b7-4bab-b0a3-431648ea5fb9	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
a119194c-8167-4bba-b222-5f7b91c248ce	complete	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Clicl this to complete your payment.	t	2022-01-28 06:32:59.464289	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
bf3783a8-04a7-43fe-ba9f-832e3a38b88e	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-04-04 01:51:49.997486	2022-04-04 01:51:49.997486	/admin/product-suggestions	\N	\N	admin	\N
a2abfa81-0465-4f3f-9f75-8cf31d84214b	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.262834	2022-04-04 15:20:32.262834	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	6ef390e4-2fd3-4266-aaa6-54dca52a334a	user	\N
7d6389b0-6263-49f3-9cd6-6ecaf2a79892	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	f	2022-01-19 05:00:16.661645	2022-01-19 05:00:16.661645	#	\N	\N	admin	\N
fcc0bc87-977f-4093-8abc-9ba40f36483b	Group Suggestion approved	Your product group for test has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-26 08:58:20.451082	2022-01-26 08:58:20.451082	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e88ced66-0a25-4809-aeb3-57ba528c9722	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 09:57:22.753024	2022-02-17 09:57:22.753024	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ba50a63e-b6c3-4a29-b34b-79f597dbe8a7	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:47:24.422998	2022-02-23 05:47:24.422998	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
39776f29-f484-4689-b8a3-0327a46356d6	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-24 07:08:55.079147	2022-02-24 07:08:55.079147	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c2e353ee-3223-4fe1-80b0-86f1ccf95568	new group	New group has been created for adidas	f	2022-03-01 08:55:30.079724	2022-03-01 08:55:30.079724	#	\N	\N	admin	\N
1e1c3549-a724-42b5-9945-910d6835dc7d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 03:52:54.265253	2022-03-04 03:52:54.265253	/admin/product-suggestions	\N	\N	admin	\N
6221f711-c8f8-4106-af81-a0bcf0160f4c	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:38:51.102163	2022-03-07 02:38:51.102163	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
bd41e896-e440-43f6-848a-0cb644d95ef1	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group adidas.	f	2022-03-14 02:27:25.310455	2022-03-14 02:27:25.310455	/product-page/${group_id}	daeaf235-ad9f-4bcb-901f-15f6af6e1904	2e09fd10-807f-4b82-8722-c27d2c280b0d	user	\N
2c63a0c1-5ab2-4986-83c3-e81cb434cd6f	Group Suggestion approved	Your product group for test shirt has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-03-21 08:59:18.546721	2022-03-21 08:59:18.546721	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
557d2f1d-0904-4feb-948c-3e39417f69e6	Form group	Your group suggestion test shirt is formed.	f	2022-03-21 08:59:18.562403	2022-03-21 08:59:18.562403	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	\N	user	\N
31d56de2-8c23-4e95-a3c8-f7b1a52c6488	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-01-28 06:53:44.54926	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
cd891e70-b8c1-4b26-ab75-515c5730af1a	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 05:18:15.888179	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
7e3d18df-4489-48a2-a611-c45fc8a036ff	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	t	2022-02-14 07:41:09.756086	2022-03-29 08:10:40.163553	/product-page/9a398999-4cb9-4f15-a411-1ebd5bc21eff	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
ee08f968-775c-4812-b821-ea9aaecbb60c	Price change	One of the groups that you've joined had a price change. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 02:54:04.489525	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
162443a0-076c-43de-b977-0c6a2a4ff210	Join group	You successfully joined this group 1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d.	t	2022-03-09 02:09:16.170275	2022-03-29 08:10:40.163553	/product-page/1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
38b9378d-c9af-42b2-ba89-b3170a70134c	Join group	You successfully joined this group d977f086-9d97-48df-a1c7-4de273da77bc.	t	2022-03-09 03:14:00.976387	2022-03-29 08:10:40.163553	/product-page/d977f086-9d97-48df-a1c7-4de273da77bc	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
17ced418-746f-4b9c-8955-e2650e967414	Group Suggestion approved	Your product group for adidas mens Release 2 Structured Stretch Fit Cap has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-04-04 01:53:33.191727	2022-04-04 01:53:33.191727	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
17b70204-19f1-4ced-bd25-53e864993853	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.263018	2022-04-04 15:20:32.263018	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	968f0310-c811-4737-93bc-895610a8a7e3	user	\N
d18cde63-e048-47ff-958c-18e7854c5675	new group	New group has been created for test	f	2022-01-26 08:58:20.464374	2022-01-26 08:58:20.464374	#	\N	\N	admin	\N
ecf355b0-51e1-40f5-8814-a657cb2dadf4	group is full	Hooray! Your group 'Amazon Essentials Men's Heavyweight Hooded Puffer Coat' is full! Click here for more details about payment status.	f	2022-01-28 08:51:35.011148	2022-01-28 08:51:35.011148	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ea91552c-256f-4b95-a2c7-4040cf7a705f	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 05:23:38.719157	2022-02-08 05:23:38.719157	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
889af5bf-51b8-4816-970f-7cce663855c1	GROUP DEADLINE CHANGED	Your group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 'Wed Feb 16 2022' to 'Wed Feb 16 2022' by the admin.	f	2022-02-15 01:38:16.120263	2022-02-15 01:38:16.120263	/seller/mygroups	9a398999-4cb9-4f15-a411-1ebd5bc21eff	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
13e7397d-c957-4b60-b48f-2d6e7c29cda4	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	f	2022-02-15 01:38:16.14515	2022-02-15 01:38:16.14515	#	\N	\N	admin	\N
5239deba-f14f-4a80-8e75-24898b74c3ea	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 09:57:36.992894	2022-02-17 09:57:36.992894	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
41ef01f8-c9b6-4c5d-b6c3-a63f21ce4995	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:56:54.383458	2022-02-23 05:56:54.383458	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b03c8ed6-bb62-4190-b339-dc81ad3c7d18	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-28 02:30:34.637326	2022-02-28 02:30:34.637326	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
cf6d4c8c-4c3e-4daf-a415-77c8ee940245	new bidding	New bidding started for adidas group	t	2022-03-01 08:55:31.294127	2022-03-01 08:55:31.294127	/admin/managebids	\N	\N	admin	\N
cae063fe-4192-4322-afea-05ee54dfe65b	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 05:00:48.446034	2022-03-04 05:00:48.446034	/admin/product-suggestions	\N	\N	admin	\N
c4bce940-5044-4d39-90f1-7dd7ea8bedec	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:42:19.814565	2022-03-07 02:42:19.814565	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3010de16-2726-40f2-8faf-e99985f3a1cb	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-09 02:09:16.197788	2022-03-09 02:09:16.197788	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
f387c83f-3d8d-464a-b4fd-d351ad5abe00	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-09 03:14:00.989341	2022-03-09 03:14:00.989341	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
fd98905d-0aac-4912-9556-2c751828502d	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-14 08:07:49.821081	2022-03-14 08:07:49.821081	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2eb80ab4-1138-41a4-8e7c-5b754dccd88c	new group	New group has been created for test shirt	f	2022-03-21 08:59:18.561714	2022-03-21 08:59:18.561714	#	\N	\N	admin	\N
c7e854da-362d-4890-ba5b-a1f5d5e0e370	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	t	2022-01-19 05:00:16.664993	2022-03-29 08:10:40.163553	/product-page/60181685-b4b7-4bab-b0a3-431648ea5fb9	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
e4d450a8-24b7-4ed8-8f23-ee39833aeea4	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 05:23:53.038142	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
43af2473-e1ab-4e54-88f1-461217d76575	Price change	One of the groups that you've joined had a price change from $0.00 to $1054.90. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 05:25:47.751233	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
2b7eb2c3-650c-43f0-9498-6fb7fa9412a1	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-14 08:07:49.794747	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
7fe3325b-f78a-412b-a0e1-20f156eaf003	new group	New group has been created for adidas mens Release 2 Structured Stretch Fit Cap	f	2022-04-04 01:53:33.212176	2022-04-04 01:53:33.212176	#	\N	\N	admin	\N
a9f4a947-cf7b-49e0-8f4d-ff30b0d493bb	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.263238	2022-04-04 15:20:32.263238	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	2e09fd10-807f-4b82-8722-c27d2c280b0d	user	\N
70343d07-47d6-4f3d-9214-54db67b70417	change role	Your role has changed, you are now a user.	t	2022-01-19 09:09:15.44937	2022-01-20 06:51:07.927379	/admin/dashboard	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	e498f885-498f-4a95-afa0-9370f4a6a866
2dec6419-ad4b-4c6a-b243-a54ae97ad0c5	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-26 09:07:50.491408	2022-01-26 09:07:50.491408	/admin/product-suggestions	\N	\N	admin	\N
b795e129-9840-41fe-96e3-46718914dd42	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-31 09:33:48.953237	2022-01-31 09:33:48.953237	/admin/product-suggestions	\N	\N	admin	\N
d9fd027a-b697-4821-a632-d55d131b497d	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 05:41:04.034159	2022-02-08 05:41:04.034159	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e84e8676-b25a-4275-8ce8-4f80bc92987e	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-17 10:00:43.754494	2022-02-17 10:00:43.754494	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b0ef1283-0bcf-4a08-a053-7e9a355aac3d	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 05:59:34.751823	2022-02-23 05:59:34.751823	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
32463667-4f00-4887-ac8d-ba1b33ad4034	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-28 02:30:52.83188	2022-02-28 02:30:52.83188	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
9e3edbc5-ab3e-4093-8f9c-20630917e328	crawler done	Crawling for sellers is done for product "adidas". Found 0 results	t	2022-03-01 08:55:34.966539	2022-03-01 08:55:34.966539	/admin/managebids	\N	\N	admin	\N
ebb98e29-dff1-400e-bcb3-19035e900937	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 05:04:22.141538	2022-03-04 05:04:22.141538	/admin/product-suggestions	\N	\N	admin	\N
3738bf5c-3ab6-45c5-a935-88d09c8e4666	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:43:24.420257	2022-03-07 02:43:24.420257	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
8dcca409-9949-467e-acc8-f27ba1a4f582	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-03-14 08:21:21.711447	2022-03-14 08:21:21.711447	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	6ef390e4-2fd3-4266-aaa6-54dca52a334a	user	\N
33e44cee-4af7-4d9b-8141-c2e94e964fcd	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-14 08:21:21.724107	2022-03-14 08:21:21.724107	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3e95d42f-b7e1-4e44-9ef3-1ba0ac5eba85	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-22 02:15:39.536167	2022-03-22 02:15:39.536167	/admin/product-suggestions	\N	\N	admin	\N
f3cbbeb3-63ef-4ed2-802a-c9e4f6097e77	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	t	2022-02-15 01:38:16.145204	2022-03-29 08:10:40.163553	/product-page/9a398999-4cb9-4f15-a411-1ebd5bc21eff	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
17716781-7314-4f80-82ea-a90357634d8e	Price change	One of the groups that you've joined had a price change from $1054.90 to $1053.80. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 05:27:51.336588	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
03a0f268-50f2-47ee-8bc9-dbcfddf2ddd9	complete_payment	Secure your spot! The seller of the group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 has closed the group and now accepting payments. Click this to complete your payment.	t	2022-03-09 03:15:18.413989	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
0b023443-ba20-493d-9d62-ebf06385d127	Form group	Your group suggestion adidas mens Release 2 Structured Stretch Fit Cap is formed.	f	2022-04-04 01:53:33.213231	2022-04-04 01:53:33.213231	/product-page/ed353a2e-1254-4406-91ad-b921670ea183	\N	\N	user	\N
d5fde732-737e-41d4-a046-8e88c9c1b917	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.263801	2022-04-04 15:20:32.263801	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	user	\N
fd6f2ae4-38dc-428e-aef0-cb61d278236e	GROUP DEADLINE CHANGED	Your group Timberland Short Watch Cap deadline has been changed from 'Thu Apr 28 2022' to 'Sat May 28 2022' by the admin.	f	2022-04-05 08:16:05.768369	2022-04-05 08:16:05.768369	/seller/mygroups	72b8ee43-cf44-464a-ad5f-496a9396a3ab	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
fd904da9-f86e-4c40-a58f-d80fc95b05bb	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.793661	2022-04-05 08:16:05.793661	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	968f0310-c811-4737-93bc-895610a8a7e3	user	\N
20ba8943-ae07-42e0-a25f-6c4159349793	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	t	2022-01-19 09:12:12.73929	2022-01-20 06:22:04.151218	/product-page/24fa7a33-054d-45b1-8cdc-7bc8dc394921	24fa7a33-054d-45b1-8cdc-7bc8dc394921	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
15c99805-86cb-4eba-8a39-ecd1d6cf2759	Group Suggestion approved	Your product group for Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-26 09:10:24.063857	2022-01-26 09:10:24.063857	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
af9fbf13-72b2-409c-a697-3e0cf163fa16	Group Suggestion approved	Your product group for Heavy Blend 8 oz. 50/50 Hood (G185) has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-02-02 05:15:05.187406	2022-02-02 05:15:05.187406	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
de76d7ca-1e17-4198-bd62-8221add6f421	GROUP DEADLINE CHANGED	Your group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 'Wed Feb 16 2022' to 'Wed Feb 16 2022' by the admin.	f	2022-02-15 01:53:38.604298	2022-02-15 01:53:38.604298	/seller/mygroups	9a398999-4cb9-4f15-a411-1ebd5bc21eff	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
cfcf1afe-744e-430d-8871-7506d9c81c21	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-15 05:56:10.189116	2022-02-15 05:56:10.189116	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
fb528977-0180-40cd-97e8-d10c18d8f3cf	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-18 03:58:31.576752	2022-02-18 03:58:31.576752	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
45db6ad3-9bcc-46d9-837d-a3b06dd280e0	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 06:01:45.720709	2022-02-23 06:01:45.720709	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ee227376-c650-48cb-8834-71f7679ac668	complete_payment	Secure your spot! The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	f	2022-02-28 02:41:23.293098	2022-02-28 02:41:23.293098	/mygroups	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
efc4d3bc-9861-4740-8979-88be216ba73c	new bidding	New bidding started for Grassman Camping Tarp, Ultralight Waterproof group	t	2022-03-02 07:50:33.621488	2022-03-02 07:50:33.621488	/admin/managebids	\N	\N	admin	\N
78201172-c412-4564-8afd-97158c836db9	new group	New group has been created for Grassman Camping Tarp, Ultralight Waterproof	t	2022-03-02 07:50:32.42584	2022-03-02 08:01:54.536865	#	\N	\N	admin	\N
87f4ff43-c990-499f-950f-542c8dd3bf55	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 05:09:02.900613	2022-03-04 05:09:02.900613	/admin/product-suggestions	\N	\N	admin	\N
fe5e7f52-eda2-4b38-8de5-11fbab4c8083	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:45:11.161088	2022-03-07 02:45:11.161088	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
347a20a4-fc1b-4031-9eb1-c758ae461335	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-09 02:09:54.248676	2022-03-09 02:09:54.248676	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
2a54fd09-206f-4534-abea-3299928e700e	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-09 05:42:58.161265	2022-03-09 05:42:58.161265	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6a2599f8-ebe3-4b12-9b03-2b6e21d8e9fe	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-14 08:21:44.165724	2022-03-14 08:21:44.165724	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
682a28b9-fdff-44f3-b065-b4b6c7ce1470	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-14 08:21:44.150129	2022-03-14 08:26:15.00698	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	6ef390e4-2fd3-4266-aaa6-54dca52a334a	user	\N
c5344be7-075f-4b7b-a319-e789681cd610	new bidder	New bid posted on Grassman Camping Tarp, Ultralight Waterproof group	t	2022-03-22 08:46:37.789464	2022-03-22 08:46:37.789464	/admin/managebids	\N	\N	admin	\N
72b4a00c-9e6f-4306-8502-4375cd382019	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 05:41:25.676938	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
cdfadead-6b91-4570-8e0e-f11d881a0ec4	Join group	You successfully joined this group 72b8ee43-cf44-464a-ad5f-496a9396a3ab.	t	2022-03-09 05:42:58.148409	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
6a681f14-bdee-425e-a217-dae652df8418	Group Suggestion approved	Your product group for Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-04-04 01:54:49.687543	2022-04-04 01:54:49.687543	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e69b8bf6-2f23-4314-b995-9133dc7e8090	Form group	Your group suggestion Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English is formed.	f	2022-04-04 01:54:50.031299	2022-04-04 01:54:50.031299	/product-page/79ee2231-bdb5-4e63-bd03-0b8b09f8b53a	\N	\N	user	\N
38ba986d-c0e8-4987-b651-573fd2321994	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	f	2022-01-20 02:48:12.489276	2022-01-20 02:48:12.489276	#	\N	\N	admin	\N
7c5dd5c7-16df-4804-9e9a-67b59566c590	new group	New group has been created for Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	f	2022-01-26 09:10:24.078725	2022-01-26 09:10:24.078725	#	\N	\N	admin	\N
7fe78ef0-43d5-49df-b9b2-ad64e8bd0941	new group	New group has been created for Heavy Blend 8 oz. 50/50 Hood (G185)	f	2022-02-02 05:15:05.202112	2022-02-02 05:15:05.202112	#	\N	\N	admin	\N
840eb6c5-7ff7-4bc9-adad-c9d2ad76cc26	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 05:43:27.404086	2022-02-08 05:43:27.404086	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
1e53a2b7-1cc6-426f-a766-5294bbe0525c	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	f	2022-02-15 01:53:38.609145	2022-02-15 01:53:38.609145	#	\N	\N	admin	\N
740cb159-89aa-47b3-aa71-bfbcb93e4423	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-15 05:56:31.978463	2022-02-15 05:56:31.978463	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
bf4ca026-fb4a-46d3-ab0a-f3d807293b0f	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-18 08:41:19.536908	2022-02-18 08:41:19.536908	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
39498f26-f776-4c91-b9e4-28989ba82a33	group is full	Hooray! Your group 'PlayStation DualSense Wireless Controller – Midnight Black ' is full! Click here for more details about payment status.	f	2022-02-23 06:15:06.491734	2022-02-23 06:15:06.491734	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
c05e3df9-31b5-48b5-aade-074b842960e3	crawler done	Crawling for sellers is done for product "Grassman Camping Tarp, Ultralight Waterproof". Found 10 results	t	2022-03-02 07:53:15.263618	2022-03-02 07:53:15.263618	/admin/managebids	\N	\N	admin	\N
3e7140ac-1be8-4648-a9a6-d03cd5594dbc	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 05:20:12.75278	2022-03-04 05:20:12.75278	/admin/product-suggestions	\N	\N	admin	\N
df2aa9bb-f218-41ce-b9ec-305ab75f5139	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:56:00.611556	2022-03-07 02:56:00.611556	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
92f53ce8-b9f1-4bd4-8fc8-53f8941f40c5	GROUP DEADLINE CHANGED	Your group Timberland Short Watch Cap deadline has been changed from 'Mon Mar 07 2022' to 'Wed Mar 30 2022' by the admin.	f	2022-03-09 02:48:10.082876	2022-03-09 02:48:10.082876	/seller/mygroups	72b8ee43-cf44-464a-ad5f-496a9396a3ab	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e306fac4-cfd9-47b6-ba98-dc70bc08fd81	new group	New group has been created for adidas	f	2022-03-09 08:18:12.861206	2022-03-09 08:18:12.861206	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
3b7f48f7-ddef-4b37-8c1e-d82fccb23f0f	new seller application	Thank you for applying to join our seller community! We are excited to have you with us.  We are reviewing your application now and we will get back to you soon on your approval status.  	f	2022-03-14 09:00:14.496891	2022-03-14 09:00:14.496891	/admin/seller-applicant	\N	\N	admin	\N
7371c03d-31b1-42b9-b24f-b45af03e92b6	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2022-03-22 08:57:22.943357	2022-03-22 09:22:11.845341	/admin/product-suggestions	\N	\N	admin	\N
b60569b7-477d-43c3-8846-d5f1be235857	complete_payment	Secure your spot! The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-28 02:41:23.297189	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
3b619583-0cfa-4454-8af6-8b9bd06b0379	Join group	You successfully joined this group daeaf235-ad9f-4bcb-901f-15f6af6e1904.	t	2022-03-09 08:18:13.416885	2022-03-29 08:10:40.163553	/product-page/daeaf235-ad9f-4bcb-901f-15f6af6e1904	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
6ea2d18d-6e17-435f-b1f6-e0306a4c6002	new group	New group has been created for Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English	f	2022-04-04 01:54:50.030991	2022-04-04 01:54:50.030991	#	\N	\N	admin	\N
0ba6e150-62d1-4771-84d2-0fc169999fdc	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.793603	2022-04-05 08:16:05.793603	#	\N	\N	admin	\N
47df5cf0-416b-4025-a64c-8643bb5b76e1	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-01-27 02:59:43.027273	2022-01-27 02:59:43.027273	/admin/product-suggestions	\N	\N	admin	\N
24b8612b-e5c9-46e4-a3e5-eee031ae7f43	group is full	Hooray! Your group 'Heavy Blend 8 oz. 50/50 Hood (G185)' is full! Click here for more details about payment status.	f	2022-02-03 06:53:16.062919	2022-02-03 06:53:16.062919	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
039a6af4-9dd4-4a71-8dd8-3b5d4d8b3e33	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-15 05:56:55.169056	2022-02-15 05:56:55.169056	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b4ca5c24-da6d-4ce6-904a-99b075b5572a	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-18 08:41:43.965242	2022-02-18 08:41:43.965242	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
990980cc-787b-4c40-9017-f150fce18f2a	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 08:17:51.328312	2022-02-23 08:17:51.328312	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2aaabef6-ea0e-4d33-b11b-a4c6e730f5ed	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-28 03:51:30.764986	2022-02-28 03:51:30.764986	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
47adbac4-ef4c-49e8-a319-00d47897c8ec	new bidder	New bid posted on Grassman Camping Tarp, Ultralight Waterproof group	t	2022-03-02 08:01:22.492705	2022-03-02 08:01:22.492705	/admin/managebids	\N	\N	admin	\N
284b4b4b-e1f5-4da5-9dff-e82bcde075b3	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-04 05:24:22.395827	2022-03-04 05:24:22.395827	/admin/product-suggestions	\N	\N	admin	\N
0a7d9c08-3762-4336-8d5f-0bc6f7b5d80a	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 02:58:22.066109	2022-03-07 02:58:22.066109	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3aa4709a-b8a2-4149-806a-030aeebc86c5	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/7/2022, 8:59:59 AM to 3/30/2022, 9:59:00 AM.	f	2022-03-09 02:48:10.155503	2022-03-09 02:48:10.155503	#	\N	\N	admin	\N
8020bce4-faec-48a0-8757-4dcbc5fdef88	new bidding	New bidding started for adidas group	t	2022-03-09 08:18:13.184631	2022-03-09 08:18:13.184631	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
2471240e-b56d-4e86-b61c-20bdbd5b2e06	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-03-15 02:34:17.176353	2022-03-15 02:34:17.176353	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	2e09fd10-807f-4b82-8722-c27d2c280b0d	user	\N
f02fa8fe-082c-4e27-9db4-524943d46d1b	new bidder	New bid posted on Grassman Camping Tarp, Ultralight Waterproof group	t	2022-03-23 02:50:37.509247	2022-03-23 02:50:37.509247	/admin/managebids	\N	\N	admin	\N
a96cc150-0209-4514-8d41-a55845c4b6d8	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	t	2022-01-20 02:48:12.492735	2022-03-29 08:10:40.163553	/product-page/60181685-b4b7-4bab-b0a3-431648ea5fb9	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
ca5cfdf0-f5fd-498b-a02d-684cd4b139fa	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 05:43:42.255174	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
8ee8ce4d-d8ee-45ca-9fd5-24b913060362	group deadline changed	The group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 2/16/2022, 8:59:00 AM to 2/16/2022, 8:59:00 AM.	t	2022-02-15 01:53:38.613262	2022-03-29 08:10:40.163553	/product-page/9a398999-4cb9-4f15-a411-1ebd5bc21eff	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
22fab0a7-7585-4776-b8b4-f5d9a32c7c09	Form group	Your group suggestion adidas is formed.	t	2022-03-09 08:18:12.864524	2022-03-29 08:10:40.163553	/product-page/daeaf235-ad9f-4bcb-901f-15f6af6e1904	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
f312fd5b-a4ba-460b-8263-6f63c3d09d4a	change role	Your role has changed, you are now a user.	f	2022-03-07 06:26:39.524052	2022-03-07 06:26:39.524052	/admin/dashboard	\N	c34c5ab9-1033-469b-9096-4ec9133a28f4	user	46056b5e-3e3f-40ce-8477-8d3dcc19f006
ec1bd288-b507-4626-b9d7-4494727da50e	GROUP DEADLINE CHANGED	Your group Timberland Short Watch Cap deadline has been changed from 'Wed Mar 30 2022' to 'Fri Apr 29 2022' by the admin.	f	2022-04-04 15:15:46.69376	2022-04-04 15:15:46.69376	/seller/mygroups	72b8ee43-cf44-464a-ad5f-496a9396a3ab	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
718be8c4-8f01-48ef-950c-dde67664b6e7	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.799536	2022-04-05 08:16:05.799536	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
fbc253f4-74bb-48fe-9ee4-03140e2f104a	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nVERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	t	2022-01-20 02:48:12.493124	2022-01-20 06:51:22.42742	/product-page/60181685-b4b7-4bab-b0a3-431648ea5fb9	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
732383d1-59be-45e8-96f3-227922a5cc3e	Group Suggestion approved	Your product group for DC DCSC Mens Jacket has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	f	2022-01-27 03:00:23.205792	2022-01-27 03:00:23.205792	/seller/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
9715c284-5761-492a-bab9-4aa2e7ca7e2f	group is full	Hooray! Your group 'Heavy Blend 8 oz. 50/50 Hood (G185)' is full! Click here for more details about payment status.	f	2022-02-03 06:54:13.157621	2022-02-03 06:54:13.157621	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
43fb0842-6a01-4635-a571-c1ef9c2cef5e	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-15 02:24:03.469047	2022-02-15 02:24:03.469047	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6c98e379-b4ff-4d31-b3b2-aa9da4d66dc5	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-15 06:05:35.416715	2022-02-15 06:05:35.416715	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
02c2b4fb-0fbe-44de-9aef-cb00fe8609fc	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-18 09:40:26.373404	2022-02-18 09:40:26.373404	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b4fad5f3-3959-48fb-84fd-d84dd3b8169f	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 09:55:23.48806	2022-02-23 09:55:23.48806	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
564ebdfe-666b-47e5-88e2-d0aef2d83a4c	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-28 09:12:31.34283	2022-02-28 09:12:31.34283	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ba89646c-3c97-4724-9bca-2bc18411d598	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-03 06:07:57.286364	2022-03-03 06:07:57.286364	/admin/product-suggestions	\N	\N	admin	\N
a3375219-875d-4770-a20f-464eb8f63bd5	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-07 03:27:11.17362	2022-03-07 03:27:11.17362	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
96572bad-aac4-4c4a-b7ef-a32426ee68ca	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/7/2022, 8:59:59 AM to 3/30/2022, 9:59:00 AM.	f	2022-03-09 02:48:10.160522	2022-03-09 02:48:10.160522	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
82643341-da99-4935-9229-8ef04403a756	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/7/2022, 8:59:59 AM to 3/30/2022, 9:59:00 AM.	f	2022-03-09 02:48:10.160317	2022-03-09 02:48:10.160317	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	968f0310-c811-4737-93bc-895610a8a7e3	user	\N
c7c55a07-214b-468f-a0d8-c586536fff05	crawler done	Crawling for sellers is done for product "adidas". Found 10 results	t	2022-03-09 08:24:07.024382	2022-03-09 08:24:07.024382	/admin/managebids	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
1be1ea52-a1ce-4446-95c9-bb1a7eb240f8	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-15 02:34:17.200073	2022-03-15 02:34:17.200073	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
5c6c27f3-8d06-45a7-945a-09c169261147	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\nGrassman Camping Tarp, Ultralight Waterproof	f	2022-03-23 03:05:56.67774	2022-03-23 03:05:56.67774	/admin/mybids	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
13547452-a927-4a14-8c3a-08dea5573ac0	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 08:34:59.889001	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
e2220ce4-144c-4659-b9ef-11df72cf30fd	Price change	One of the groups that you've joined had a price change from $10.00 to $10.00. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nadidas	t	2022-03-04 05:34:37.617991	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
7845b444-4118-43fd-8e59-1eadbd4e7fbf	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.703638	2022-04-04 15:15:46.703638	#	\N	\N	admin	\N
1365b603-90dc-4b17-b816-c47709185486	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.800233	2022-04-05 08:16:05.800233	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	2e09fd10-807f-4b82-8722-c27d2c280b0d	user	\N
dbf9c110-c265-42e4-8028-9e91ee460b3d	Group Suggestion approved	Your product group for Sheoolor Quiet Essential Oil Diffuser, 200ml Vintage Vase Aromatherapy Diffuser with Waterless Auto Shut-Off Function & 7-Color LED Changing Lights Diffuser for Essential Oils, for Home, Office, Yoga has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	t	2021-11-25 02:46:55.747575	2022-01-20 05:13:00.396294	/seller/mybids	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
6dc40a7e-19cf-446b-a25c-e87fa8fb304e	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\ntest	t	2021-12-23 06:03:22.364419	2022-01-20 05:13:00.396294	/admin/mybids	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
d8b57f53-3785-472f-9056-265be5a5f7f4	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\nPlayStation DualSense Wireless Controller – Midnight Black 	t	2021-12-23 06:05:16.521396	2022-01-20 05:13:00.396294	/admin/mybids	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
31983eda-2059-4662-b355-7367ad688c70	new group	New group has been created for DC DCSC Mens Jacket	f	2022-01-27 03:00:23.218198	2022-01-27 03:00:23.218198	#	\N	\N	admin	\N
df22fc5c-fd80-4ba7-8bbe-438775c9ed82	new product suggestion	A new product has been suggested. Check on the product suggestions tab	t	2022-02-04 06:39:19.562983	2022-02-07 08:38:13.984081	/admin/product-suggestions	\N	\N	admin	\N
1393ba88-6e27-43d2-9743-e942f23c7973	group is full	Hooray! Your group 'Heavy Blend 8 oz. 50/50 Hood (G185)' is full! Click here for more details about payment status.	f	2022-02-09 02:52:17.439624	2022-02-09 02:52:17.439624	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
09731884-024a-4a29-b111-0cca9b7cfe3d	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.703899	2022-04-04 15:15:46.703899	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	6ef390e4-2fd3-4266-aaa6-54dca52a334a	user	\N
c3470784-6bda-4b1e-9975-f1acede9f8e1	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 02:55:13.784645	2022-02-24 02:55:13.784645	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3c539c8e-af61-4c81-b56c-e55c6541ac57	GROUP DEADLINE CHANGED	Your group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 'Sat Mar 26 2022' to 'Sat Mar 26 2022' by the admin.	f	2022-02-15 02:24:38.690027	2022-02-15 02:24:38.690027	/seller/mygroups	d977f086-9d97-48df-a1c7-4de273da77bc	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2d2c2301-9c56-4997-b3de-a1381d0d728d	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-15 07:40:20.813039	2022-02-15 07:40:20.813039	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
cc70630c-30f6-4b55-be68-6d0b7de07db1	group is full	Hooray! Your group 'Amazon Essentials Men's Heavyweight Hooded Puffer Coat' is full! Click here for more details about payment status.	f	2022-02-18 09:50:40.338201	2022-02-18 09:50:40.338201	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ab19be9f-46ad-4084-90ae-16406e7e5aff	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-23 09:56:04.464805	2022-02-23 09:56:04.464805	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
d788a9e5-da18-4d2f-87c7-6d6bdbbf2e83	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-02-28 09:14:42.335981	2022-02-28 09:14:42.335981	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
a966ff99-c98a-4518-a34a-070b9b173346	new group	New group has been created for jkghghgjg	f	2022-03-03 06:08:48.83363	2022-03-03 06:08:48.83363	#	\N	\N	admin	\N
3a138f50-5586-4ff3-bce5-719f0c8eb4eb	new bidding	New bidding started for jkghghgjg group	t	2022-03-03 06:08:49.797007	2022-03-03 06:08:49.797007	/admin/managebids	\N	\N	admin	\N
48954b88-c029-4884-bc0d-a3ee5f46e655	complete_payment	Secure your spot! The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	t	2022-03-07 05:15:19.060995	2022-03-08 09:30:15.695791	/mygroups	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
5eac05d3-f957-4386-9a1b-90185cd5bc0a	new group	New group has been created for RK ROYAL KLUDGE RK61  (Blue Switch, White)	f	2022-03-09 08:29:24.269977	2022-03-09 08:29:24.269977	#	\N	\N	admin	bf9c540e-60b9-406c-a82a-c1859adf5d7d
79407a22-52a6-4b5e-ac79-f5fd49247155	Join group	You successfully joined this group 894a997f-eb11-4dec-982a-f0066c64323d.	t	2022-03-09 08:29:24.702703	2022-03-09 08:52:26.599461	/product-page/894a997f-eb11-4dec-982a-f0066c64323d	\N	bf9c540e-60b9-406c-a82a-c1859adf5d7d	user	\N
bb4cd5f9-f044-4e17-bee4-c30caf8aa4b1	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.80035	2022-04-05 08:16:05.80035	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
b47e798a-708b-410c-89fd-f69e3547d446	Join group	You successfully joined this group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	f	2022-03-15 05:38:02.093382	2022-03-15 05:38:02.093382	/product-page/1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
96298d39-117f-4d12-98b6-182f5b214dd7	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/7/2022, 8:59:59 AM to 3/30/2022, 9:59:00 AM.	t	2022-03-09 02:48:10.160836	2022-03-15 06:48:44.051132	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
793dd9da-2dd7-4b09-8a95-04eb855c5707	BID WINNER	Congratulations! You have won the bidding for Grassman Camping Tarp, Ultralight Waterproof! Please see your seller dashboard for more details.	f	2022-03-23 03:05:56.680895	2022-03-23 03:05:56.680895	#	\N	\N	admin	e498f885-498f-4a95-afa0-9370f4a6a866
1a86b2f6-1845-467a-a493-41ffbfb78fac	complete_payment	The seller of the group Heavy Blend 8 oz. 50/50 Hood (G185) has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-09 02:52:51.477856	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
ab593b1e-05ab-4bd2-8b39-1fdd0c0de0bc	Price change	One of the groups that you've joined had a price change from $10.00 to $10.00. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nadidas	t	2022-03-04 05:37:44.211907	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
8e01fe9f-8dbe-43dc-8339-c32645735fb5	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:02:23.465041	2022-01-27 06:02:23.465041	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2ff6d967-fe85-4e96-ab07-9c0dfffdbda3	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-09 06:07:32.677066	2022-02-09 06:07:32.677066	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
083fd68b-8fc1-4381-9611-da977817a887	group deadline changed	The group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 3/26/2022, 9:59:59 AM to 3/26/2022, 9:59:00 AM.	f	2022-02-15 02:24:38.700341	2022-02-15 02:24:38.700341	#	\N	\N	admin	\N
32cf130d-df39-4e7d-bc7f-3ff8f7bcef55	group is full	Hooray! Your group 'Amazon Essentials Men's Heavyweight Hooded Puffer Coat' is full! Click here for more details about payment status.	f	2022-02-18 09:51:07.126245	2022-02-18 09:51:07.126245	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
45c3bcd7-1b90-4be2-b2f2-4e72d15ef325	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 00:41:57.784316	2022-02-24 00:41:57.784316	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6d63a9de-3f18-4d76-b07e-f34c91c893f5	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:06:50.189468	2022-03-01 01:06:50.189468	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
d57f1b42-f08d-4472-9a64-03113169a819	crawler done	Crawling for sellers is done for product "jkghghgjg". Found 0 results	t	2022-03-03 06:08:51.620765	2022-03-03 06:08:51.620765	/admin/managebids	\N	\N	admin	\N
8a913939-7716-4782-9088-cc33c7972eae	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/7/2022, 8:59:59 AM to 3/30/2022, 9:59:00 AM.	f	2022-03-09 02:48:10.1623	2022-03-09 02:48:10.1623	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	user	\N
fd6f7987-1979-43bf-b3fc-d00b88127ce6	Form group	Your group suggestion RK ROYAL KLUDGE RK61  (Blue Switch, White) is formed.	f	2022-03-09 08:29:24.275365	2022-03-09 08:29:24.275365	/product-page/894a997f-eb11-4dec-982a-f0066c64323d	\N	bf9c540e-60b9-406c-a82a-c1859adf5d7d	user	\N
8b73e734-68d4-4024-a9b9-3f10a91c38cd	new bidding	New bidding started for RK ROYAL KLUDGE RK61  (Blue Switch, White) group	t	2022-03-09 08:29:24.494791	2022-03-09 08:29:24.494791	/admin/managebids	\N	\N	admin	bf9c540e-60b9-406c-a82a-c1859adf5d7d
e028501e-7280-4dc5-a461-51b7fdfe663e	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-15 05:38:02.099369	2022-03-15 05:38:02.099369	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
71c71642-c90c-4484-8aff-35959f59c9a6	Join group	You successfully joined this group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	f	2022-03-15 05:38:17.547301	2022-03-15 05:38:17.547301	/product-page/1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
a0124ccc-4ed6-4e0d-b8c1-2793ae49dcc0	crawler done	Crawling for sellers is done for product "this is a test". Found 0 results	t	2022-03-24 07:43:13.211542	2022-03-24 07:43:13.211542	/admin/managebids	\N	\N	admin	\N
ffe0d484-4f8c-45e9-9cdf-40e69231a946	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 01:47:32.711264	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
939e4409-6bac-468d-8968-d1aae0b3250c	Price change	One of the groups that you've joined had a price change from $1053.80 to $1050.50. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 08:55:13.049865	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
7e97058e-8e03-44d4-a58f-a63a46fd6d50	Price change	One of the groups that you've joined had a price change from $10.00 to $10.00. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nadidas	t	2022-03-04 05:40:49.946475	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
1b1c39ec-0654-4139-bb69-973062633301	complete_payment	Secure your spot! The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	t	2022-03-07 05:15:19.064217	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
a2074b30-6854-4ce0-8f7f-29134fc26604	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.708867	2022-04-04 15:15:46.708867	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	968f0310-c811-4737-93bc-895610a8a7e3	user	\N
d7d22dc6-7750-448a-92cb-ab91269deb16	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.800605	2022-04-05 08:16:05.800605	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	6ef390e4-2fd3-4266-aaa6-54dca52a334a	user	\N
970d96fc-5c1f-492a-bf18-e1d6e9cccc9a	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:03:40.077161	2022-01-27 06:03:40.077161	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b80f6c5d-d9c3-48f8-b1c3-44d5abb6ee8f	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 05:53:42.042211	2022-02-17 05:53:42.042211	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
4044222e-46a0-4e69-bb3b-f401e6981650	group is full	Hooray! Your group 'Amazon Essentials Men's Heavyweight Hooded Puffer Coat' is full! Click here for more details about payment status.	f	2022-02-21 09:44:39.344087	2022-02-21 09:44:39.344087	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ba60f28f-13ea-4759-81ad-873a474edacd	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 01:09:34.791839	2022-02-24 01:09:34.791839	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b41ee5fc-604d-4a21-b368-f52c388015f2	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:18:17.293056	2022-03-01 01:18:17.293056	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
62306546-21cb-4e2a-b93a-8ad2b2239c69	new group	New group has been created for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	f	2022-03-03 06:17:58.589033	2022-03-03 06:17:58.589033	#	\N	\N	admin	\N
a153a7be-d2d2-4af7-9683-086e1be4d3bb	change role	Your role has changed, you are now a super user. Please check your new super user dashboard in your account menu.	t	2022-03-07 06:26:16.222397	2022-03-07 06:26:52.412137	/admin/dashboard	\N	c2f2bfe5-cb5c-4418-a16a-7705a782b8d7	user	46056b5e-3e3f-40ce-8477-8d3dcc19f006
c5f0c568-1253-4dac-8b16-b0c3c3dd71cc	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	f	2022-03-09 02:48:33.883153	2022-03-09 02:48:33.883153	#	\N	\N	admin	\N
e9a3f030-ae07-4d4c-a972-aa89c765bb67	crawler done	Crawling for sellers is done for product "RK ROYAL KLUDGE RK61  (Blue Switch, White)". Found 10 results	t	2022-03-09 08:33:14.555126	2022-03-09 08:33:14.555126	/admin/managebids	\N	\N	admin	bf9c540e-60b9-406c-a82a-c1859adf5d7d
b5ebd71e-660d-499b-9011-0c3127d6e7c8	group is full	Hooray! Your group 'Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt' is full! Click here for more details about payment status.	f	2022-03-15 05:38:17.562324	2022-03-15 05:38:17.562324	/admin/seller-transaction	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
b49336f8-7e84-4dc4-aac7-63842b11f978	crawler done	Crawling for sellers is done for product "this is a test". Found 0 results	t	2022-03-24 07:51:25.984096	2022-03-24 07:51:25.984096	/admin/managebids	\N	\N	admin	\N
65008f42-61c1-4f9d-8447-6000cd5b4fc1	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 03:28:45.861258	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
c36ffeda-f139-4e40-9b9e-7a44906164df	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-09 06:08:11.071649	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
7b84dbf7-a59a-4491-adf2-26896bc8c24b	group deadline changed	The group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 3/26/2022, 9:59:59 AM to 3/26/2022, 9:59:00 AM.	t	2022-02-15 02:24:38.700406	2022-03-29 08:10:40.163553	/product-page/d977f086-9d97-48df-a1c7-4de273da77bc	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
21d1058a-6469-4542-a429-b89a0868acf8	Price change	One of the groups that you've joined had a price change from $10.00 to $10.00. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nadidas	t	2022-03-04 05:42:17.386983	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
439245b6-48ef-4c61-9003-08bdd50a5acc	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.709063	2022-04-04 15:15:46.709063	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
0d496d3b-fb37-4e03-86e1-059f7a0d0ed3	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	f	2022-04-05 08:16:05.801014	2022-04-05 08:16:05.801014	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	user	\N
0ba0d0eb-37a0-49e0-a3d3-f57ffd903ae4	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:06:22.16969	2022-01-27 06:06:22.16969	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
cda6ff6c-d183-4e3f-b7b1-ae3293e8e182	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:06:34.653444	2022-01-27 06:06:34.653444	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c8cba10a-6059-4f88-b30a-3670737da906	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-09 09:18:04.583251	2022-02-09 09:18:04.583251	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
281a49f6-3649-4a5a-aab2-d11cfa15f2e6	GROUP DEADLINE CHANGED	Your group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 'Sat Mar 26 2022' to 'Thu Mar 31 2022' by the admin.	f	2022-02-15 02:27:04.690274	2022-02-15 02:27:04.690274	/seller/mygroups	d977f086-9d97-48df-a1c7-4de273da77bc	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2d2649c7-35d0-457b-9374-59d9f517c725	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 06:42:50.874457	2022-02-17 06:42:50.874457	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3375e53e-20d2-4c0a-82f6-85888be92bdc	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 02:44:34.300207	2022-02-24 02:44:34.300207	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
7d3b897f-75dc-41f0-abb0-69a9c4c87d50	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:19:07.634352	2022-03-01 01:19:07.634352	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0ae84fab-b72e-45ee-931c-4c893d302eb1	new bidding	New bidding started for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt group	t	2022-03-03 06:17:59.118336	2022-03-03 06:17:59.118336	/admin/managebids	\N	\N	admin	\N
34a0dac9-d9a1-410b-9868-cda5ea15541c	complete_payment	The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-21 09:47:48.302143	2022-03-08 09:30:13.41187	/mygroups	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
0a596202-f5fa-44e9-9c52-256a27cfaa13	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	f	2022-03-09 02:48:33.885942	2022-03-09 02:48:33.885942	/product-page/606ed0f4-9106-49c4-9efb-b0a49e098bba	\N	8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	user	\N
a515d1d7-6fd1-4aea-8bba-5673b103c235	Join group	You successfully joined this group test.	f	2022-03-09 09:03:17.480293	2022-03-09 09:03:17.480293	/product-page/7aac7a92-5376-484d-8fe9-a786e477f6a9	\N	bf9c540e-60b9-406c-a82a-c1859adf5d7d	user	\N
cfee1ee8-dd1b-4f1e-939c-826f768cee0d	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-17 03:49:26.693433	2022-03-17 03:49:26.693433	/admin/product-suggestions	\N	\N	admin	\N
84441d1c-e2ad-4478-a770-6f189e3c7e3d	crawler done	Crawling for sellers is done for product "adidas". Found 20 results	t	2022-03-24 08:11:33.369585	2022-03-24 08:11:33.369585	/admin/managebids	\N	\N	admin	\N
be768049-5671-4b35-9e34-c99021690a08	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 03:48:16.834526	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
44ee09ca-09ba-45aa-b0be-fbce9fff1c2b	Price change	One of the groups that you've joined had a price change from $10.00 to $10.00. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nadidas	t	2022-03-04 05:44:55.538268	2022-03-29 08:10:40.163553	#	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
c0ef0e88-9ed6-492e-b42f-bd50053bda4b	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.709623	2022-04-04 15:15:46.709623	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	2e09fd10-807f-4b82-8722-c27d2c280b0d	user	\N
b3c8ffb3-9700-4097-848e-c8bef7a07e1c	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:12:15.481641	2022-01-27 06:12:15.481641	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
27727cf6-95b2-46b2-bf5a-d7bc64e7203b	group is full	Hooray! Your group 'APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers' is full! Click here for more details about payment status.	f	2022-02-10 09:48:13.930573	2022-02-10 09:48:13.930573	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e7b1767f-68b3-4f06-b4d9-0ab9ed8ca219	group deadline changed	The group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 3/26/2022, 9:59:00 AM to 3/31/2022, 9:59:00 AM.	f	2022-02-15 02:27:04.694632	2022-02-15 02:27:04.694632	#	\N	\N	admin	\N
151f2e25-e882-4301-a339-b18692acd344	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 06:45:06.815388	2022-02-17 06:45:06.815388	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
e3bdfe7c-26d1-471c-b990-d1c69d0eb27d	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-24 02:50:21.402393	2022-02-24 02:50:21.402393	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
78bed263-e983-4d99-8e10-171598edd60e	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:20:23.151136	2022-03-01 01:20:23.151136	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
391c9208-99c2-4bad-8e6f-041897a126e0	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-03 08:23:00.33414	2022-03-03 08:23:00.33414	/admin/product-suggestions	\N	\N	admin	\N
2c227988-73bd-4d70-90d6-6c63bea7ef2a	change role	Your role has changed, you are now a user.	f	2022-03-07 06:30:13.350102	2022-03-07 06:30:13.350102	/admin/dashboard	\N	c2f2bfe5-cb5c-4418-a16a-7705a782b8d7	user	46056b5e-3e3f-40ce-8477-8d3dcc19f006
cfcdc5fe-947e-4446-8bcb-caabf206f5ac	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-03-09 09:03:17.507319	2022-03-09 09:03:17.507319	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
7acdca2c-69c4-4b18-80dc-55ecb416b998	new group	New group has been created for this is a test	f	2022-03-17 05:11:05.044623	2022-03-17 05:11:05.044623	#	\N	\N	admin	\N
a4d3e921-1e02-45c6-8ee8-287e209657f2	new bidding	New bidding started for this is a test group	t	2022-03-17 05:11:05.845022	2022-03-17 05:11:05.845022	/admin/managebids	\N	\N	admin	\N
37b4f377-0760-4fa8-84e7-b13f0dd801b8	crawler done	Crawling for sellers is done for product "this is a test". Found 0 results	t	2022-03-17 05:11:08.488085	2022-03-17 05:11:08.488085	/admin/managebids	\N	\N	admin	\N
7bcfc905-91e3-485f-b2ee-2f9be85c3b9e	crawler done	Crawling for sellers is done for product "jkghghgjg". Found 0 results	t	2022-03-25 02:13:19.873387	2022-03-25 02:13:19.873387	/admin/managebids	\N	\N	admin	\N
63de2b29-dd9b-4367-8e94-4d0271f95276	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 03:54:25.223654	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
2f083374-bd57-4879-b975-30adebbd151d	complete_payment	The seller of the group Amazon Essentials Men's Heavyweight Hooded Puffer Coat has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-21 09:47:48.30603	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
35a8b4b9-24a8-4012-b2c0-65ee24c4bfb0	Group removed	We are sorry to inform you that we removed the group this is a test.	t	2022-03-04 09:17:06.765541	2022-03-29 08:10:40.163553	#	58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
fcf0fd16-54ed-4cdb-aabc-f5a80975bdf1	group deadline changed	The group ps5 with seller deadline has been changed from 2/23/2022, 8:59:59 AM to 3/12/2022, 8:59:00 AM.	t	2022-03-09 02:48:33.887674	2022-03-29 08:10:40.163553	/product-page/606ed0f4-9106-49c4-9efb-b0a49e098bba	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
75b8585a-86b6-40d3-9d37-1876791f2a44	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.709793	2022-04-04 15:15:46.709793	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	user	\N
bcc65323-22bd-48d9-ab04-f96ff67be702	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-04-11 18:45:38.837047	2022-04-11 18:45:38.837047	/admin/product-suggestions	\N	\N	admin	\N
3102b811-3877-4d8c-9b5e-63e23cb98105	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-01-27 06:28:53.601099	2022-01-27 06:28:53.601099	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
17d16fc1-3894-4643-ade1-cc9445284bb1	GROUP DEADLINE CHANGED	Your group Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed) deadline has been changed from 'Sat Feb 19 2022' to 'Sat Feb 26 2022' by the admin.	f	2022-02-14 06:56:21.849435	2022-02-14 06:56:21.849435	/seller/mygroups	9130646e-92e8-4a5e-aaae-89f740856bc8	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c937ff55-b070-4c25-ac65-b8c2dabd37b1	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 06:46:12.704425	2022-02-17 06:46:12.704425	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
da9133a8-21d8-462d-ad31-79440a02f7e2	group is full	Hooray! Your group 'ps5 with seller' is full! Click here for more details about payment status.	f	2022-02-22 09:20:26.081582	2022-02-22 09:20:26.081582	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
817f253a-1cd1-4b1c-9599-16373106a5e7	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:23:22.650177	2022-03-01 01:23:22.650177	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
d62ecea9-cdbb-411a-a464-1c9581c1bdc4	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-03 08:45:37.166207	2022-03-03 08:45:37.166207	/admin/product-suggestions	\N	\N	admin	\N
6c1f0e69-5cc5-4c08-bc52-64ae3cabc526	SELLER GROUP CONFIRMATION	Hey, the admin wants you to be the seller of this group, this is a test.	f	2022-03-07 06:31:39.569336	2022-03-07 06:31:39.569336	/product-page/58d841e3-cd1c-433a-a239-924ea22d0b7d	58d841e3-cd1c-433a-a239-924ea22d0b7d	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
95788e92-a2cf-47c5-9072-1a84490a5962	GROUP DEADLINE CHANGED	Your group ps5 with seller deadline has been changed from 'Wed Feb 23 2022' to 'Sat Mar 12 2022' by the admin.	f	2022-03-09 02:48:33.893668	2022-03-09 02:48:33.893668	/seller/mygroups	606ed0f4-9106-49c4-9efb-b0a49e098bba	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ece7dd78-3fad-4776-8c63-ea1657e088ea	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-10 01:35:11.760876	2022-03-10 01:35:11.760876	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3a5d5c75-00f4-4c28-b5a9-bff0c89c8a96	crawler done	Crawling for sellers is done for product "ps5". Found 16 results	t	2022-03-25 06:15:45.571576	2022-03-25 06:15:45.571576	/admin/managebids	\N	\N	admin	\N
b759cc14-1f0a-4950-91d1-08f84dcfd850	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 05:41:02.5275	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
8d6bec93-2a67-4f78-bd85-336637a8e594	group deadline changed	The group Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600 deadline has been changed from 3/26/2022, 9:59:00 AM to 3/31/2022, 9:59:00 AM.	t	2022-02-15 02:27:04.698485	2022-03-29 08:10:40.163553	/product-page/d977f086-9d97-48df-a1c7-4de273da77bc	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
2b8b256c-9555-44db-815e-07468fcbc7f4	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-10 01:35:11.737786	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
70d54b5b-481e-4f63-ba58-9137a59f81e9	Form group	Your group suggestion this is a test is formed.	t	2022-03-17 05:11:05.04956	2022-03-29 08:10:40.163553	/product-page/f6a2c267-ec63-4acc-b6ab-22274c80ef21	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
1a9f49e5-d0f2-4cfe-83e5-17984e7de274	Join group	You successfully joined this group this is a test.	t	2022-03-17 05:11:05.348254	2022-03-29 08:10:40.163553	/product-page/f6a2c267-ec63-4acc-b6ab-22274c80ef21	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
ee349284-88fc-42b1-9ab7-f1bf45f85ca3	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.711478	2022-04-04 15:15:46.711478	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
1e72fafe-35b9-4f9e-9c1c-8817cce23fa8	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-04-11 19:06:12.308242	2022-04-11 19:06:12.308242	/admin/product-suggestions	\N	\N	admin	\N
7f7920d0-4df5-495e-9044-53d9fe33892d	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-27 07:56:39.703254	2022-01-27 07:56:39.703254	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
cb3d7915-2640-498c-b4da-4194ba219716	group deadline changed	The group Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed) deadline has been changed from 2/19/2022, 8:59:59 AM to 2/26/2022, 8:59:00 AM.	f	2022-02-14 06:56:21.890167	2022-02-14 06:56:21.890167	#	\N	\N	admin	\N
a51221fd-c14f-4d7b-9ae0-9b7ffd69c210	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 06:46:45.821311	2022-02-17 06:46:45.821311	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
7b329c03-c254-48a8-9db7-26a764b87bf1	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-02-23 01:53:37.839776	2022-02-23 01:53:37.839776	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0596b29f-f1a5-47e9-b535-2afcff0e516b	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-24 04:18:06.947864	2022-02-24 04:18:06.947864	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
99c5ad75-41e3-4419-a1b2-48a3bf46ab1a	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-01 01:27:17.218439	2022-03-01 01:27:17.218439	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
44cacc0b-7ebd-4fc2-b88d-5b944f748181	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-03 08:48:44.476101	2022-03-03 08:48:44.476101	/admin/product-suggestions	\N	\N	admin	\N
941369f7-212c-4136-89ce-4cbaed076743	new bidder	New bid posted on Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt group	t	2022-03-07 06:33:03.691832	2022-03-07 06:37:01.484299	/admin/managebids	\N	\N	admin	\N
706c8b2a-5712-4046-a18f-2912f41fe3db	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	t	2022-01-20 07:39:42.331393	2022-03-08 02:44:25.127156	/product-page/24fa7a33-054d-45b1-8cdc-7bc8dc394921	24fa7a33-054d-45b1-8cdc-7bc8dc394921	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
ab5e8d52-5bcd-425c-98a8-6e03cdda1bb1	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-17 08:47:54.2307	2022-03-17 08:47:54.2307	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0f6938ca-1aec-44e5-95f1-c32b95b92f44	crawler done	Crawling for sellers is done for product "ps5". Found 11 results	t	2022-03-25 08:12:32.766584	2022-03-25 08:12:32.766584	/admin/managebids	\N	\N	admin	\N
9033930e-0b94-4cf0-8a03-96a1008c506a	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-17 08:47:54.203358	2022-03-29 05:05:14.065931	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
8a5e0c9e-1ccf-4f62-bdb3-13a05d1e49a0	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-07 07:37:44.493449	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
13141cd8-a545-4583-8283-dbe694cb7fb1	Price change	One of the groups that you've joined had a price change. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nGildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	t	2022-02-15 02:39:00.071831	2022-03-29 08:10:40.163553	#	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
0f9a46a9-ca75-4855-96fc-4757b29e7a16	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-10 01:35:38.062182	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
a6280fd2-7ca9-4e10-a12c-56399f121a4b	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 3/30/2022, 9:59:00 AM to 4/29/2022, 9:59:00 AM.	f	2022-04-04 15:15:46.712011	2022-04-04 15:15:46.712011	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
acc2cf29-3142-4a98-86e7-6f32207a30df	new category	Clothing category created, Clothing	t	2022-04-11 19:10:28.470028	2022-04-11 19:10:28.470028	/admin/category	\N	\N	admin	\N
eb92c3b9-7f33-47cd-aad2-9b768b8f7bd7	GROUP INVITATION ACCEPTED	You accepted the invitation to join the group Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt.	t	2022-01-20 07:40:05.483028	2022-01-20 07:42:23.338637	/product-page/${group_id}	24fa7a33-054d-45b1-8cdc-7bc8dc394921	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
34cc3039-2fc1-4fd5-8f16-d7fedd713226	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-27 08:01:23.973847	2022-01-27 08:01:23.973847	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
69d19a07-0e55-49c8-9bf7-258106f89cb9	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-02-08 02:43:31.89867	2022-02-08 02:43:31.89867	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ea6f0256-206a-4252-9665-c94f9f460342	group is full	Hooray! Your group 'APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers' is full! Click here for more details about payment status.	f	2022-02-15 02:40:19.683581	2022-02-15 02:40:19.683581	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
5f4c0404-a4e1-42ec-a92f-f52fc3f84c27	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 07:36:32.645716	2022-02-17 07:36:32.645716	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2f03e8ad-19ba-40da-b45f-1c361fc52104	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-23 02:48:59.199197	2022-02-23 02:48:59.199197	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
3f69fe72-9ece-4217-a1d3-de516da9d8c0	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-24 04:18:31.227289	2022-02-24 04:18:31.227289	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
c02e93a1-e24d-48be-9584-e9182875b9ce	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:29:51.168193	2022-03-01 01:29:51.168193	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6742b61d-4a6b-495b-80ad-3d44bb09c524	new group	New group has been created for this is a test	f	2022-03-03 08:49:47.236639	2022-03-03 08:49:47.236639	#	\N	\N	admin	\N
59b8259c-b16c-4a2b-aecc-e68ea0998c2e	BID WINNER	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\nHappy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	f	2022-03-07 06:43:14.077056	2022-03-07 06:43:14.077056	/admin/mybids	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	\N
879898e9-b906-4edd-9ad7-3c6bf900a47e	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-10 01:35:38.07558	2022-03-10 01:35:38.07558	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
b05ede8c-0d60-4744-93b8-6b204d841aa8	Price change	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\n2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	t	2022-01-07 05:17:57.127703	2022-03-29 08:10:40.163553	#	a97032c6-a5e1-451d-af4e-7371123beb1d	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
63d42845-a10d-415f-a0b9-487839ef70bd	group deadline changed	The group Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed) deadline has been changed from 2/19/2022, 8:59:59 AM to 2/26/2022, 8:59:00 AM.	t	2022-02-14 06:56:21.896291	2022-03-29 08:10:40.163553	/product-page/9130646e-92e8-4a5e-aaae-89f740856bc8	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
13b970d3-62ad-4fc0-a74e-5ea39c49fb17	Join group	You successfully joined this group RK ROYAL KLUDGE RK61  (Blue Switch, White).	t	2022-03-17 08:55:06.091805	2022-03-29 08:10:40.163553	/product-page/894a997f-eb11-4dec-982a-f0066c64323d	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
9e60ad24-beb6-4bee-a935-3dcce240bc9f	GROUP DEADLINE CHANGED	Your group Timberland Short Watch Cap deadline has been changed from 'Fri Apr 29 2022' to 'Thu Apr 28 2022' by the admin.	f	2022-04-04 15:20:32.031145	2022-04-04 15:20:32.031145	/seller/mygroups	72b8ee43-cf44-464a-ad5f-496a9396a3ab	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
7ce26e45-cfdf-4d78-a157-ec6b609b2de3	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-01-24 06:28:31.011602	2022-01-24 06:28:31.011602	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6c7d483e-df04-4596-9491-e115adfa776b	group is full	Hooray! Your group 'DC DCSC Mens Jacket' is full! Click here for more details about payment status.	f	2022-01-28 02:51:27.095801	2022-01-28 02:51:27.095801	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
868c99a0-3db9-4235-9f08-50ef82599670	GROUP DEADLINE CHANGED	Your group APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers deadline has been changed from 'Wed Feb 16 2022' to 'Wed Feb 16 2022' by the admin.	f	2022-02-14 07:32:19.292297	2022-02-14 07:32:19.292297	/seller/mygroups	9a398999-4cb9-4f15-a411-1ebd5bc21eff	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
ae20ba11-009d-49c7-b1d1-5e7dfa60ddfb	group is full	Hooray! Your group 'APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers' is full! Click here for more details about payment status.	f	2022-02-15 02:40:51.058377	2022-02-15 02:40:51.058377	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
da960149-a083-41c7-8b04-027e52d36af8	group is full	Hooray! Your group 'Playstation DualSense Wireless Controller' is full! Click here for more details about payment status.	f	2022-02-17 07:50:44.237656	2022-02-17 07:50:44.237656	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
dbb5d071-d3e8-4c6b-bca1-c748664a1795	group is full	Hooray! Your group 'test' is full! Click here for more details about payment status.	f	2022-02-23 02:53:20.301979	2022-02-23 02:53:20.301979	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
0168f0a9-51ba-4644-a846-99a56d09955f	group is full	Hooray! Your group 'Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)' is full! Click here for more details about payment status.	f	2022-02-24 04:19:09.824532	2022-02-24 04:19:09.824532	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
252009bd-c55c-4898-a17b-a48f6d63764c	group is full	Hooray! Your group 'Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600' is full! Click here for more details about payment status.	f	2022-03-01 01:48:31.82571	2022-03-01 01:48:31.82571	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2ab5f389-b135-468b-9d06-271205a16b8a	new bidding	New bidding started for this is a test group	t	2022-03-03 08:49:48.102286	2022-03-03 08:49:48.102286	/admin/managebids	\N	\N	admin	\N
87fa3407-5810-4d4f-b890-469bdb1331a3	BID WINNER	Congratulations! You have won the bidding for Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt! Please see your seller dashboard for more details.	f	2022-03-07 06:43:14.081688	2022-03-07 06:43:14.081688	#	\N	\N	admin	46056b5e-3e3f-40ce-8477-8d3dcc19f006
bfb81da8-a0df-4425-928e-b785eda1e1b1	group is full	Hooray! Your group 'Timberland Short Watch Cap' is full! Click here for more details about payment status.	f	2022-03-10 01:49:46.528955	2022-03-10 01:49:46.528955	/admin/seller-transaction	\N	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
4a5c382c-e6d3-4ec2-8ca1-5467a249bab6	new product suggestion	A new product has been suggested. Check on the product suggestions tab	f	2022-03-18 08:23:01.343617	2022-03-18 08:23:01.343617	/admin/product-suggestions	\N	\N	admin	\N
80913a3b-accf-4de1-889d-c3311b592b54	complete_payment	The seller of the group DC DCSC Mens Jacket has closed the group and now accepting payments. Click this to complete your payment.	t	2022-02-08 02:49:21.413833	2022-03-29 08:10:40.163553	/mygroups	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
c651cc27-b804-4b67-b789-dcd73c05a032	Join group	You successfully joined this group Timberland Short Watch Cap.	t	2022-03-10 01:49:46.52071	2022-03-29 08:10:40.163553	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
89874f53-3484-4299-bd7d-40148a8cd1a7	Join group	You successfully joined this group RK ROYAL KLUDGE RK61  (Blue Switch, White).	f	2022-03-30 09:27:45.960191	2022-03-30 09:27:45.960191	/product-page/894a997f-eb11-4dec-982a-f0066c64323d	\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N
05d26f39-5959-4926-9aab-d1714a2f4e94	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/29/2022, 9:59:00 AM to 4/28/2022, 9:59:00 AM.	f	2022-04-04 15:20:32.257497	2022-04-04 15:20:32.257497	#	\N	\N	admin	\N
f98618c3-7e07-4c8a-a534-4b5a009cdc0d	group deadline extended	One of the groups that you've joined now has a seller. However, the price went up. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\nCrucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	t	2022-01-19 03:35:11.926962	2022-03-29 08:10:40.163553	/product-page/3949b32d-7c71-4f57-91f0-2ddf97e86007	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
b02c317f-5381-4f9d-8b4b-3145d68ce1b9	Join group	You successfully joined this group Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English.	f	2022-04-27 09:04:22.105649	2022-04-27 09:04:22.105649	/product-page/79ee2231-bdb5-4e63-bd03-0b8b09f8b53a	\N	79b69f8f-c2a8-45f0-aad7-7932b462a3af	user	\N
c72ed6f9-798c-4674-8d32-c8a47ea8c555	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 01:30:24.328682	2022-04-28 01:30:24.328682	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
16f10053-1756-4f38-8944-77e66095ab8c	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 02:24:04.625193	2022-04-28 02:24:04.625193	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
55c729cb-a4dd-436d-9d34-54582b160675	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 03:21:50.900014	2022-04-28 03:21:50.900014	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
1e82d999-9fad-40e7-b3b7-a10408733bd3	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 03:29:46.721941	2022-04-28 03:29:46.721941	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
c03642f4-f537-4edc-bad2-736974a2c94e	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 03:35:25.440431	2022-04-28 03:35:25.440431	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
fef483c3-871e-4716-bbf9-123fd272aa84	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-28 03:40:43.123729	2022-04-28 03:40:43.123729	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
6b71cdba-19dc-4232-b04e-347c34e31c6a	group near full	One of the groups that you are following only has few spots left. Click below to join now!\n\n'Timberland Short Watch Cap'	f	2022-04-28 03:40:43.136171	2022-04-28 03:40:43.136171	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	user	\N
2361fdff-4e68-4a1c-a494-e3a0971ed1c1	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-29 01:34:55.381406	2022-04-29 01:34:55.381406	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
2e3e2536-473e-4f48-96eb-86635a737ba3	Join group	You successfully joined this group Timberland Short Watch Cap.	f	2022-04-29 01:35:47.348656	2022-04-29 01:35:47.348656	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
343a1e70-ba19-4b41-ac58-30b992a44e36	group near full	One of the groups that you are following only has few spots left. Click below to join now!\n\n'Timberland Short Watch Cap'	f	2022-04-29 01:35:47.362432	2022-04-29 01:35:47.362432	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	826be7c9-b01e-4690-8cc3-e1dc75aadf85	user	\N
3708f5b4-ae4c-4989-9138-aa56868376b7	crawler done	Crawling for sellers is done for product "gaming mouse". Found 16 results	t	2022-04-29 08:02:50.279351	2022-04-29 08:02:50.279351	/admin/managebids	\N	\N	admin	\N
f985c1bf-ca4e-4225-bc5e-82e156966277	Join group	You successfully joined this group test shirt.	f	2022-05-02 08:23:16.309914	2022-05-02 08:23:16.309914	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
b1ccc76f-7e8b-4fdb-9094-02e3e852ab52	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Sat May 21 2022' to 'Fri May 06 2022' by the admin.	f	2022-05-02 08:30:57.561724	2022-05-02 08:30:57.561724	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
2b4f8ca8-7b56-475d-9e9e-4394978dcc21	group deadline changed	The group test shirt deadline has been changed from 5/21/2022, 9:59:59 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 08:30:57.583907	2022-05-02 08:30:57.583907	#	\N	\N	admin	\N
310236fe-eb72-4755-a598-304c2bbb98a8	group deadline changed	The group test shirt deadline has been changed from 5/21/2022, 9:59:59 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 08:30:57.58852	2022-05-02 08:30:57.58852	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
53778434-95ac-4fdf-981a-d0090aaac7b9	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Sat May 21 2022' to 'Fri May 06 2022' by the admin.	f	2022-05-02 08:32:01.211372	2022-05-02 08:32:01.211372	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
5cadf713-6450-41af-a739-ff8b7c20cf07	group deadline changed	The group test shirt deadline has been changed from 5/21/2022, 9:59:59 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 08:32:01.219006	2022-05-02 08:32:01.219006	#	\N	\N	admin	\N
87002098-4988-4409-8c00-c8df48b5caa6	group deadline changed	The group test shirt deadline has been changed from 5/21/2022, 9:59:59 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 08:32:01.222181	2022-05-02 08:32:01.222181	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
c0b3ca43-9ff1-4758-9235-f1a7d6224f7d	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Fri May 06 2022' to 'Sun May 01 2022' by the admin.	f	2022-05-02 09:16:57.46411	2022-05-02 09:16:57.46411	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
8b5ffb91-2b86-4020-ac66-6317114dfff4	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 5/1/2022, 9:59:00 AM.	f	2022-05-02 09:16:57.48354	2022-05-02 09:16:57.48354	#	\N	\N	admin	\N
b8113971-ab3a-4a95-9495-7682997fb067	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 5/1/2022, 9:59:00 AM.	f	2022-05-02 09:16:57.487457	2022-05-02 09:16:57.487457	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
f7dfc3ca-2a28-4019-996b-a434a0c74a72	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Fri May 06 2022' to 'Sat Apr 30 2022' by the admin.	f	2022-05-02 09:17:52.345163	2022-05-02 09:17:52.345163	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
6a608e76-f8c8-4886-8388-3c9408f5e852	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 4/30/2022, 9:59:00 AM.	f	2022-05-02 09:17:52.356719	2022-05-02 09:17:52.356719	#	\N	\N	admin	\N
14b2a497-b51a-42e1-8db7-71bfca4de0ff	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 4/30/2022, 9:59:00 AM.	f	2022-05-02 09:17:52.360306	2022-05-02 09:17:52.360306	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
be833378-aa10-47db-b330-89b1a6ea7832	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Fri May 06 2022' to 'Tue May 31 2022' by the admin.	f	2022-05-02 09:22:37.569509	2022-05-02 09:22:37.569509	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
d0234bbc-0d6e-4597-be72-758015261f09	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 5/31/2022, 9:59:00 AM.	f	2022-05-02 09:22:37.583626	2022-05-02 09:22:37.583626	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
f97f1061-d7dc-47a2-bf2a-432deb3e9237	group deadline changed	The group test shirt deadline has been changed from 5/6/2022, 9:59:00 AM to 5/31/2022, 9:59:00 AM.	f	2022-05-02 09:22:37.58347	2022-05-02 09:22:37.58347	#	\N	\N	admin	\N
7f8322db-76a8-471c-aca7-053a14e3a7d1	GROUP DEADLINE CHANGED	Your group test shirt deadline has been changed from 'Tue May 31 2022' to 'Fri May 06 2022' by the admin.	f	2022-05-02 09:31:39.711934	2022-05-02 09:31:39.711934	/seller/mygroups	ff3ec288-119f-4acc-8355-e55ada7e49f1	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	\N
977e7dbf-e896-458e-a3a2-8a12d1422149	group deadline changed	The group test shirt deadline has been changed from 5/31/2022, 9:59:00 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 09:31:39.717882	2022-05-02 09:31:39.717882	/product-page/ff3ec288-119f-4acc-8355-e55ada7e49f1	\N	e498f885-498f-4a95-afa0-9370f4a6a866	user	\N
5f079483-c122-48ef-9f86-10c8df5919a7	group deadline changed	The group test shirt deadline has been changed from 5/31/2022, 9:59:00 AM to 5/6/2022, 9:59:00 AM.	f	2022-05-02 09:31:39.717828	2022-05-02 09:31:39.717828	#	\N	\N	admin	\N
5ba21857-7547-4670-9d62-d421f8ca8ddb	group deadline changed	The group Timberland Short Watch Cap deadline has been changed from 4/28/2022, 9:59:00 AM to 5/28/2022, 9:59:00 AM.	t	2022-04-05 08:16:05.801418	2022-05-03 02:41:47.018329	/product-page/72b8ee43-cf44-464a-ad5f-496a9396a3ab	\N	46056b5e-3e3f-40ce-8477-8d3dcc19f006	user	\N
\.


--
-- Data for Name: notification_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_template (id, notif_name, notif_message, notif_image, notif_subject, notif_receiver) FROM stdin;
2	Seller application approvedn	Congratulations, your seller application has been approved! We are excited to have you join us! Please login and view your dashboard for further details.	\N	\N	seller
3	New seller application approved	A seller application has been approved, check the manage sellers tab.	\N	\N	admin
4	New Product Suggestion	A new product has been suggested. Check on the product suggestions tab	\N	\N	admin
5	Group is Full	Hooray! Your group '{{group_name}}' is full! Click here for more details about payment status.	\N	\N	user
6	Group deadline extended	The deadline for the group '{{group_name}}' has been extended. Click here for more details.	\N	\N	user
7	New group suggestion	A group from {{group_name}} has been suggested to form, check the group suggestions tab	\N	\N	admin
19	New seller application declined - User	Your group suggestion from the product {{group_name}} has been rejected	\N	\N	user
9	New group	New group has been created for {{product_name}}	\N	\N	admin
21	Change role to admin	Your role has changed, you are now an admin. Please check your new admin dashboard in your account menu.	\N	\N	user
22	Change role to super user	Your role has changed, you are now a super user. Please check your new super user dashboard in your account menu.	\N	\N	admin
20	Change role to seller	Your role has changed, you are now a seller. Please check your new seller dashboard in your account menu.	\N	\N	seller
23	Change role to user	Your role has changed, you are now a user.	\N	\N	user
8	Group suggestion approved	Your product group for {{group_name}} has been approved! Please share this with your networks so that we can fill the group fast and get your product on its way!	\N	\N	user
13	Price change	One of the groups that you've joined had a price change from {{old_price}} to {{new_price}}. Click on the group below for the details and to indicate if you'd still like to retain your spot in the group.\n\n{{group_name}}	\N	\N	user
11	Bid winner	Congratulations! You have won the bidding for {{group_name}}! Please see your seller dashboard for more details.	\N	Bid Winner	seller
24	Form Group	Your group suggestion {{group_name}} is formed.	\N	\N	user
25	Join Group	You successfully joined this group {{group_name}}.	\N	\N	user
1	New Seller Application	Thank you for applying to join our seller community! We are excited to have you with us.  We are reviewing your application now and we will get back to you soon on your approval status.  	\N	\N	user
10	Group near full	One of the groups that you are following only has few spots left. Click below to join now!\n\n'{{group_name}}'	\N	\N	user
12	New bidding	Bidding has started for the group below.  Click on the link to submit you bid.\n\n{{group_name}}\n	\N	\N	seller
14	Seller bid winner	Congratulations! You have won the bidding for the group below.  Click on the link for more details and next steps.\n\n{{group_name}}	\N	\N	seller
15	Admin group deadline	Sorry for the delay but your group {{group_name}} deadline has been changed from {{original_date}} to {{new_date}} by the admin.. We will keep you posted as we get closer to completing this group purchase.	\N	Change Deadline	seller
16	Seller application declined	At this time your seller application has been declined.  We contact us for details.  Once we have resolved any outstanding questions please re-apply.	\N	\N	user
17	New seller application declined	A seller application has been declined.	\N	\N	admin
18	New seller application declined - Admin	A group suggestion from the product {{group_name}} has been rejected.	\N	\N	admin
\.


--
-- Data for Name: payouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payouts (payout_uuid, group_id, status, date_created, date_completed, reference_number, payout_amount, payout_notes, third_party_fees) FROM stdin;
8c660b94-cefb-4c5a-9e9b-f90ea0d4e63d	6bafa6db-0824-4396-bad5-dfc2fc11821e	pending	2021-12-01 00:00:00	2021-12-03 00:00:00	121211	3.5	\N	{"{\\"name\\":\\"fee 1\\",\\"value\\":\\"1\\"}"}
6b4a6432-5c21-4dbd-a51c-70563ff13c9c	606ed0f4-9106-49c4-9efb-b0a49e098bba	pending	2021-12-23 00:00:00	\N	\N	\N	\N	\N
b0eddbfe-1a0c-4454-9ebb-460ecf742cfd	d977f086-9d97-48df-a1c7-4de273da77bc	pending	2022-03-08 00:00:00	\N	\N	\N	\N	\N
\.


--
-- Data for Name: popup_editor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.popup_editor (pop_id, text, type, title) FROM stdin;
4		keep	\N
3	<p><em>Thank you so much for creating this group! At this time all groups will be private but we will make it public in the future and show on the website but for now please share it out to find seller.</em></p>\n	join	Private group created!
2	<p><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 14px;font-family: Titillium Web;">If, at any time, you'd like to join the group, go to your "My Groups", find the group and click join.</span></p>\n	keep	We'll keep you posted on any updates
5	123	private-group	title
1	<p style="text-align:start;"><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: medium;font-family: Titillium Web;">What happens next?</span></p>\n<p><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 0.875rem;font-family: Titillium Web;">• </span><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 14px;font-family: Titillium Web;">Please know that we won't ever charge your account until the seller ships the product.</span></p>\n<p><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 0.875rem;font-family: Titillium Web;">• </span><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 14px;font-family: Titillium Web;">As the group fills up, we will keep you posted. Once the group is full, we will send you a confirmation notice.</span></p>\n<p><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 0.875rem;font-family: Titillium Web;">• </span><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 14px;font-family: Titillium Web;">To secure your spot will send you a confirmation to complete the payment when group is about to end.</span></p>\n<p><span style="color: rgb(108,117,125);background-color: rgb(255,255,255);font-size: 0.875rem;font-family: Titillium Web;">• Keep shopping! You can join as many groups as you want and share with as many people as you want because when we buy together we save together!</span></p>\n	join	You are now part of the group!
\.


--
-- Data for Name: private_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.private_groups (id, group_id, user_id, status, invitation_code) FROM stdin;
101	4edebef1-0e36-4562-8477-2d233b2c49aa	826be7c9-b01e-4690-8cc3-e1dc75aadf85	approved	YBJOVQWT
102	493964a2-3c01-49a9-8f06-7438eb8dd53f	826be7c9-b01e-4690-8cc3-e1dc75aadf85	approved	zoPxG72Y
103	a97032c6-a5e1-451d-af4e-7371123beb1d	e498f885-498f-4a95-afa0-9370f4a6a866	approved	ZCbDL0aO
115	24fa7a33-054d-45b1-8cdc-7bc8dc394921	e498f885-498f-4a95-afa0-9370f4a6a866	approved	tVELBo6X
116	24fa7a33-054d-45b1-8cdc-7bc8dc394921	826be7c9-b01e-4690-8cc3-e1dc75aadf85	approved	tVELBo6X
117	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	approved	2GI1YSUS
118	7934d13e-087a-4831-85cb-c8a163a67bfb	46056b5e-3e3f-40ce-8477-8d3dcc19f006	approved	uBQ04mqD
119	ac93d3c3-3628-4014-b0c7-12a68629ce30	e498f885-498f-4a95-afa0-9370f4a6a866	approved	RmjDT88c
120	58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	approved	C1m2gAAq
123	ac93d3c3-3628-4014-b0c7-12a68629ce30	e498f885-498f-4a95-afa0-9370f4a6a866	approved	35REZGdb
124	58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	approved	CEVzmV4c
157	58d841e3-cd1c-433a-a239-924ea22d0b7d	e498f885-498f-4a95-afa0-9370f4a6a866	approved	1p6nVeoD
158	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e498f885-498f-4a95-afa0-9370f4a6a866	approved	TadR6zW3
160	daeaf235-ad9f-4bcb-901f-15f6af6e1904	e498f885-498f-4a95-afa0-9370f4a6a866	approved	MqoIAeLT
162	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	e7a1d853-083c-44ca-939e-f5a6c663151e	approved	\N
163	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48	dba74431-a1c3-4baa-8b10-d050b8a6a90b	approved	\N
164	daeaf235-ad9f-4bcb-901f-15f6af6e1904	2e09fd10-807f-4b82-8722-c27d2c280b0d	approved	\N
165	f6a2c267-ec63-4acc-b6ab-22274c80ef21	e498f885-498f-4a95-afa0-9370f4a6a866	approved	Hka01BFu
166	7934d13e-087a-4831-85cb-c8a163a67bfb	46056b5e-3e3f-40ce-8477-8d3dcc19f006	approved	vM6MJiqc
\.


--
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_categories (category_uuid, category_name, category_image, datetime_created, datetime_modified) FROM stdin;
56ced0d5-38e5-41b9-b93e-5e54c13c0d88	gadgets	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/56ced0d5-38e5-41b9-b93e-5e54c13c0d88/categoryImg.jpeg	2021-03-12 02:19:08.500953	2021-03-18 05:11:06.434706
f3822683-4630-4834-9a2f-effd2b591a5c	Accessories	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f3822683-4630-4834-9a2f-effd2b591a5c/categoryImg.jpeg	2021-04-12 05:27:53.563193	2022-01-17 09:25:43.134578
3bf8909a-e060-4e99-9eaa-a7859d2febe5	Sports	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/3bf8909a-e060-4e99-9eaa-a7859d2febe5/categoryImg.jpeg	2021-04-12 05:26:03.060415	2022-01-17 09:31:41.862361
814171c4-64fb-4c32-a78b-ae5bfbfa536e	Tools	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/814171c4-64fb-4c32-a78b-ae5bfbfa536e/categoryImg.jpeg	2021-02-24 09:46:05.745478	2022-01-17 09:32:09.904561
4fe9e697-47fd-4c21-9794-9a6908f13e0c	Furniture	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/4fe9e697-47fd-4c21-9794-9a6908f13e0c/categoryImg.jpeg	2021-02-22 09:42:19.883965	2022-01-17 09:33:11.00154
9ab3033b-1adf-40ca-a6b1-91a551ce789d	Home	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/9ab3033b-1adf-40ca-a6b1-91a551ce789d/categoryImg.jpeg	2021-01-28 08:28:40.411486	2022-01-17 09:33:53.57368
8f2815df-fd83-44c6-9586-24ed947acf6e	electronics	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/8f2815df-fd83-44c6-9586-24ed947acf6e/categoryImg.jpeg	2021-02-25 22:30:42.224276	2022-01-17 09:36:05.203543
3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	Clothing	https://s3.amazonaws.com/prod.landsbe.boom.ai/static/media/3d7cbbc5-69ea-452e-9de9-f2ecfbea305a/categoryImg.jpeg	2021-02-23 04:34:31.208255	2022-04-11 19:10:28.461475
\.


--
-- Data for Name: product_suggestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_suggestions (prod_suggestion_uuid, name, brand, model, image, proposer, suggestion_type, tags, description, slots, price, deadline, link, retail_price, preferred_seller, preferred_seller_email, fulfillment_details, deadline_days, private, size_variants, created_at, size_chart, in_stock, delivery_timeframe) FROM stdin;
27d71d47-2dda-4d75-88ac-399452252b86	adidas Men's Superlite Relaxed Fit Performance Hat	adidas		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f4fae9c6d2b14c2d26e6d6a7afaa35c5.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{adidas}	This adidas cap is your go-to for everyday running and training. made of lightweight stretch fabric, it has perforated side panels for added ventilation. the non-glare undervisor helps you see clearly. with reflective details.	25	22	2022-05-03 08:45:35	\N	33	\N	\N	UPS	\N	f	\N	2022-03-03 08:45:37.124888	\N	t	\N
ea8d102c-6d2b-4d07-9cd4-1d92cac080e9	Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed)	Canon	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ffb350e118a6f261b51ade70021e823a.jpeg	e498f885-498f-4a95-afa0-9370f4a6a866	seller	{Canon}	24p UHD 4K and 120p HD for slow motion Improved Dual Pixel CMOS AF and Eye Detection AF 24.1 MP (APS-C) CMOS sensor with ISO 100-25600 New DIGIC 8 image processor Improved auto lighting optimizer Built-in OLED EVF with touch and drag AF Vari-angle Touchscreen LCD Built-in Wi-Fi, NFC and Bluetooth technology Automatic image transfer to devices while shooting Silent mode for quiet operation	111	111	2022-03-10 07:52:07	\N	111	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
e8ed0959-1d00-4b78-b349-384c62816ec3	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	Happy		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ee6a66a520a809787ea4b83ebfec517f.jpeg	f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	seller	{Happy}	Pajama Family T-Shirt	77	77	2022-03-11 08:51:37	\N	77	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
5adba215-7a4a-4e88-b9c8-a5015016b905	ps5	ps5	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d3bddd434fc70cdb321c6a685a811705.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{ps5}	this is a test	100	100	2022-03-10 02:37:54	\N	100	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
f64f2566-5c26-43c6-8c0a-49df34062d94	Test 			\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N	\N	50	3	2022-04-16 03:49:25.9		\N	\N	\N	\N	30	t	\N	2022-03-17 03:49:26.685262	\N	t	\N
9c5a45e5-71ab-4b18-aa5e-c485e391af8e	Dell XPS 13 9310 Touchscreen 13.4 inch FHD Thin and Light Laptop - Intel Core i7-1185G7, 16GB LPDDR4x RAM, 512GB SSD, Intel Iris Xe Graphics, 2Yr OnSite, 6 months Dell Migrate, Windows 10 Pro - Silver	Dell		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/7021beaa31c467f2447621875051d787.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{Dell}	Dell XPS 13 9310 is engineered with: 11th Generation Intel® Core™ i7-1185G7 Processor (12MB Cache, up to 4.8 GHz), Windows 10 Pro 64-bit English, 13.4-inch FHD+ (Full HD+ ,1920 x 1200) InfinityEdge Touch Anti-Reflective 500-Nit Display, 16GB 4267MHz LPDDR4x , 512 GB M.2 PCIe NVMe SSD, Intel® Iris® Xe Graphics with shared graphics memory, Platinum Silver.	100	99	2022-03-25 09:31:06	\N	999	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
21d07b89-51d9-4cbb-9c6c-02f9c5c82fff	ps5	ps5	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/46bb70eecb519d424ba86c74cbd01d25.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{ps5}	this is a test	100	100	2022-03-10 02:38:38	\N	100	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
efbe6010-3a58-4cf7-aeef-a1117b5cd2d5	Super Mario Bros Black 8 Bit Mario Game Over Brim Baseball Hat- 8 Bit Mario Hat	super mario	8 Bit Mario Game Over Brim Baseball Hat	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f20bad352865c41596244119ca753242.jpeg	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	{"","super mario",Bit,Mario,Game,Over,Brim,Baseball,Hat}	Super Mario Bros Black 8 Bit Mario Game Over Brim Baseball Hat- 8 Bit Mario Hat	5	1.99	2022-01-12 01:47:25.37	\N	0.99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
3fe44dbc-f980-4b5d-9b7c-43c08adb5438	test item			\N	3a661f4d-f630-437d-842c-ea9f9b9e7cca	user	\N	\N	50	17	2022-04-17 08:22:59.378		\N	\N	\N	\N	30	t	\N	2022-03-18 08:23:01.334706	\N	t	\N
9db00380-4999-4d87-80db-3f6bacf4a3a2	adidas Women's Superlite Relaxed Fit Performance Hat Older Model	adidas		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c6e5e3db1914ff70909f07e3fc5b0eea.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{adidas}	The superlite is your everyday performance cap for lightweight protection, comfort and fit. its premium 3d weld logo with breathable mesh allows for maximum breathability and moisture-wicking. delivers UPF 50 for ultimate sun protection to inhibit harmful uv rays. made from recycled material.	25	11	2022-06-11 18:45:37	\N	22	\N	\N	UPS	\N	f	\N	2022-04-11 18:45:38.807532	\N	t	\N
ef8b3577-4e66-4c05-899d-536a05bf1bb0	adidas Women's Superlite Relaxed Fit Performance Hat Older Model	adidas		https://s3.amazonaws.com/prod.landsbe.boom.ai/static/media/43fa81e3826fc711b376c5b559561217.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{adidas}	The superlite is your everyday performance cap for lightweight protection, comfort and fit. its premium 3d weld logo with breathable mesh allows for maximum breathability and moisture-wicking. delivers UPF 50 for ultimate sun protection to inhibit harmful uv rays. made from recycled material.	25	1	2022-06-11 19:06:10	\N	1	\N	\N	UPS	\N	f	\N	2022-04-11 19:06:12.276683	\N	t	\N
e587bdef-0265-48f7-a7f5-3ef67f548a2f	ps5	ps5		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2010f290492d42c4b679f06f71dbdf1c.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{ps5}	this is a test	100	1	2022-03-26 03:49:28	\N	1	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
e8a7ac07-26b2-4b01-81bc-1b16a0d50bb2	London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	test	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d6205f18879df5c339dde634d14ba2b1.jpeg	e498f885-498f-4a95-afa0-9370f4a6a866	seller	{test}	test	111	22	2022-03-10 07:53:12	\N	22	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
f9694c1b-7469-487f-b444-96f7f5dfa103	test	test		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d0675cdc491a5aa5b6f3f8607976bddc.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{test}	test	55	77	2022-03-13 05:47:05	\N	777	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
aac92b79-78d5-49cf-bc4a-2074d183c4b3	Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed)	Canon	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/173fe5f8b026fb0c57eed4acb69f14c5.jpeg	f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	seller	{Canon}	24p UHD 4K and 120p HD for slow motion Improved Dual Pixel CMOS AF and Eye Detection AF 24.1 MP (APS-C) CMOS sensor with ISO 100-25600 New DIGIC 8 image processor Improved auto lighting optimizer Built-in OLED EVF with touch and drag AF Vari-angle Touchscreen LCD Built-in Wi-Fi, NFC and Bluetooth technology Automatic image transfer to devices while shooting Silent mode for quiet operation	10	11	2022-03-11 08:52:25	\N	11	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
0741776f-db66-4d62-a454-98e84952d7ef	London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	London	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d6205f18879df5c339dde634d14ba2b1.jpeg	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	{London,London}	London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	5	1.99	2022-01-12 01:48:42.666	\N	0.99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
71966db4-9b9f-4b63-a0d9-a55ded2979e3	Seagate Portable 2TB External Hard Drive Portable HDD – USB 3.0 for PC, Mac, PlayStation, & Xbox - 1-Year Rescue Service (STGX2000400)	Seagate		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/fce0bbbadd8538872620cc95eb8df735.jpeg	e498f885-498f-4a95-afa0-9370f4a6a866	seller	{Seagate}	Easily store and access 2TB of content on the go with the Seagate Portable Drive, a great laptop hard drive. Designed to work with Windows or Mac computers, this compact external hard drive makes backup a snap. Just drag and drop To get set up, connect the portable hard drive to a computer for automatic recognition—no software required—and enjoy plug and play simplicity with the included 18 inch USB 3.0 cable.	111	1	2022-03-10 07:51:44	\N	1	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
509c8dfc-7207-4e20-8ccf-cb9ce92cd961	TNELTUEB Small Cat Scratching Post	TNELTUEB		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/12e68579379f83946efe3515fd3bc66f.png	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	{"",TNELTUEB}	TNELTUEB Small Cat Scratching Post, Sisal Cat Scratching Post with 3 Different Height Poles and Hanging Ball Cat Interactive Toy for Tiny Kitten Cats Indoor Climbing Playing, Gift for Kitten 	15	23	2021-12-18 09:06:08	\N	24	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
6189deab-2988-49dc-b592-712b900e182d	Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English	Apple		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/6f307adb893a35eded40684c81aceae3.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{Apple}	1	11	1	2022-03-18 06:01:56	\N	1	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
230a58d6-92f5-433d-b60a-0df450521fe0	TP-Link AC1750 Smart WiFi Router (Archer A7) -Dual Band Gigabit Wireless Internet Router for Home, Works with Alexa, VPN Server, Parental Control, QoS	TP-Link		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f4698f4f1a49d3f695cfb56af4cc28f5.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{TP-Link}	AC1750 Wi-Fi router/wireless router. One of routers for wireless internet, wireless routers for home. Dual band router and gigabit router. Ideal as internet router also gaming router. Long range coverage with high speed. Compatible with all 802.11ac devices and below. 5ghz router/5g router Frequency Range: 2.4GHz and 5GHz; Interface Available: 4 x 10/100/1000Mbps LAN Ports, 1 10/100/1000Mbps WAN Port, 1 USB 2.0 Ports; Protocols Supported: Supports IPv4 and IPv6; System Requirement: Microsoft Windows 98SE NT 2000 XP Vista, or Windows 7 Windows 8/8.1/10, MAC OS NetWare UNIX or Linux; Wireless Standards: IEEE 802.11ac/n/a 5GHz, IEEE 802.11b/g/n 2.4GHz.	10	100	2022-01-25 01:40:24	\N	100	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
fd2dc085-a752-4a70-928f-9ca9f0d1faaa	TP-Link AC1750 Smart WiFi Router (Archer A7) -Dual Band Gigabit Wireless Internet Router for Home, Works with Alexa, VPN Server, Parental Control, QoS	TP-Link		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2552761c4c3a2d2aaa5d51fdfa850c5d.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{TP-Link}	AC1750 Wi-Fi router/wireless router. One of routers for wireless internet, wireless routers for home. Dual band router and gigabit router. Ideal as internet router also gaming router. Long range coverage with high speed. Compatible with all 802.11ac devices and below. 5ghz router/5g router Frequency Range: 2.4GHz and 5GHz; Interface Available: 4 x 10/100/1000Mbps LAN Ports, 1 10/100/1000Mbps WAN Port, 1 USB 2.0 Ports; Protocols Supported: Supports IPv4 and IPv6; System Requirement: Microsoft Windows 98SE NT 2000 XP Vista, or Windows 7 Windows 8/8.1/10, MAC OS NetWare UNIX or Linux; Wireless Standards: IEEE 802.11ac/n/a 5GHz, IEEE 802.11b/g/n 2.4GHz.	99	99	2022-01-25 01:52:47	\N	99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
73d5931d-416b-404a-8807-79608b38f512	TP-Link AC1750 Smart WiFi Router (Archer A7) -Dual Band Gigabit Wireless Internet Router for Home, Works with Alexa, VPN Server, Parental Control, QoS	TP-Link		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f361d8fa88d0688de61015ba47382105.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{TP-Link}	AC1750 Wi-Fi router/wireless router. One of routers for wireless internet, wireless routers for home. Dual band router and gigabit router. Ideal as internet router also gaming router. Long range coverage with high speed. Compatible with all 802.11ac devices and below. 5ghz router/5g router Frequency Range: 2.4GHz and 5GHz; Interface Available: 4 x 10/100/1000Mbps LAN Ports, 1 10/100/1000Mbps WAN Port, 1 USB 2.0 Ports; Protocols Supported: Supports IPv4 and IPv6; System Requirement: Microsoft Windows 98SE NT 2000 XP Vista, or Windows 7 Windows 8/8.1/10, MAC OS NetWare UNIX or Linux; Wireless Standards: IEEE 802.11ac/n/a 5GHz, IEEE 802.11b/g/n 2.4GHz.	99	99	2022-01-25 01:55:32	\N	99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
70b797c3-865b-476a-9caa-bde183f0e94d	Seagate Portable 2TB External Hard Drive Portable HDD – USB 3.0 for PC, Mac, PlayStation, & Xbox - 1-Year Rescue Service (STGX2000400)	Seagate		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/7da6d24cb83ff36fb5eb69c0fd54f2b6.jpeg	e498f885-498f-4a95-afa0-9370f4a6a866	seller	{Seagate}	Easily store and access 2TB of content on the go with the Seagate Portable Drive, a great laptop hard drive. Designed to work with Windows or Mac computers, this compact external hard drive makes backup a snap. Just drag and drop To get set up, connect the portable hard drive to a computer for automatic recognition—no software required—and enjoy plug and play simplicity with the included 18 inch USB 3.0 cable.	99	99	2022-03-10 02:53:29	\N	99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
69599421-c703-4abb-b9c1-8f3ec17b2b00	Apple Pencil	Apple		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/272950a7bb5d9f471857d9b6759f0f03.jpeg	f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	seller	{Apple}	Apple Pencil	44	22	2022-03-11 08:49:56	\N	22	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
c97ba3dc-7bdc-4b39-a28d-0bd352e4b404	tshirt	test		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2bd089ba234ab1d8c08f93e3c8226367.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{test}	test	25	1	2022-05-22 02:15:38	\N	1	\N	\N	UPS	\N	f	\N	2022-03-22 02:15:39.496235	\N	f	2-3 days
c725fe95-585e-4271-9048-2678de75bae8	Super Mario Video Game 8-Bit Black Snapback Hat	super	8-Bit Black Snapback Hat	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bab8d1c6bbbb66f85f8795763185e2fb.jpeg	46056b5e-3e3f-40ce-8477-8d3dcc19f006	seller	{"",8-Bit,Black,Snapback,Hat,super}	Get your retro gaming on with the classic to beat all classics with this Super Mario Video Game 8-Bit Black Snapback Hat! The Super Mario Retro Video Game Adjustable Hat is made of polyester material with a flat bill. The Super Mario Retro Video Game Fan Accessory features a bright, bold 8-Bit embroidered art of Mario on the front of the cap and a graphic design of the famous game on the bill. The Super Mario 8-Bit Video Game Snapback Hat measures 58cm and is able to easily adjust to fit most sizes. The Super Mario Video Game Hat is the perfect collectible merchandise to gift to any video game fan!	5	1.99	2022-01-12 01:44:15.948	\N	0.99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
cb173dbd-526c-4ee1-bb88-ba55a88c4aa2	test	test		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/abbd92cb04975637fbc873f356628cdb.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{test}	tests	55	1	2022-03-12 02:37:06	\N	1	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
3d4198d5-efc8-4c45-b226-a19c8dc1f4ce	Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English	Apple	\N	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ec5712d8eaa1e738a4467de622558a05.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{test}	test	55	99	2022-03-13 05:57:10	\N	99	\N	\N	UPS	\N	f	\N	2022-01-26 05:20:22.373055	\N	t	\N
a20c59a6-02e5-4057-8507-f4fda2fed845	cap	test		https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/4c40c6101c9fdb48deef40c02559e8b8.jpeg	c1cfcbbf-2ec9-4966-8849-277852afa41a	seller	{test}	test	50	1	2022-05-22 08:57:20	\N	1	\N	\N	UPS	\N	f	{"{\\"size\\":11,\\"quantity\\":\\"50\\",\\"group\\":4,\\"inStock\\":true}"}	2022-03-22 08:57:22.913631	\N	t	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_uuid, product_name, product_image, datetime_created, datetime_modified, product_image1, product_image2, product_category, seller_id, product_description, tags, brand, model, retail_price, price, active_product, size_variants, size_chart) FROM stdin;
f6e7d864-150a-4698-82cb-57efecf373b9	Heavy Blend 8 oz. 50/50 Hood (G185)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e41621584118ba53893ad8adc9d9f1c9.jpeg	2022-02-02 05:15:04.796326	2022-02-03 05:54:47.916866	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	50% cotton, 50% polyester; All Heather Sport colors are 60% cotton, 40% polyester; pill-resistant air jet yarn; double-needle stitching throughout; double-lined hood; pouch pocket; matching drawcord; 1x1 ribbed cuffs and waistband with spandex; Safety Orange is compliant with ANSI - ISEA 107 High Visibility Standards	{"Heavy Blend"}			17	\N	t	{"{\\"size\\":4,\\"quantity\\":\\"5\\",\\"group\\":2}","{\\"size\\":5,\\"quantity\\":\\"5\\",\\"group\\":1}","{\\"size\\":6,\\"quantity\\":\\"5\\",\\"group\\":1}","{\\"size\\":3,\\"quantity\\":\\"5\\",\\"group\\":1}"}	[{"Size":"2","Bust":""},{"Size":"4","Bust":""},{"Size":"6","Bust":""},{"Size":"8","Bust":""},{"Size":"10","Bust":""},{"Size":"12","Bust":""},{"Size":"14","Bust":""}]
12d1306a-02c4-46d1-a138-6a153f5fd1d6	Logitech G213 Prodigy Gaming Keyboard, LIGHTSYNC RGB Backlit Keys, Spill-Resistant, Customizable Keys, Dedicated Multi-Media Keys – Black	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5418ed8afd370769b1709ff5267615d5.jpeg	2021-07-01 03:14:22.504231	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	e498f885-498f-4a95-afa0-9370f4a6a866	G213 Prodigy slim body is durable, precise, and spill-resistant, G213 Prodigy is designed for the way you play. With performance tuned keys, G213 Prodigy brings together the best in tactile feel and gaming-grade performance. Keys on the G213 Prodigy are tuned to deliver ultra-quick, responsive feedback that is up to 4 times faster than the keys on standard keyboards, while the anti-ghosting gaming Matrix keeps you in control even when multiple keys are pressed simultaneously. Add a personal touch to your system with customizable RGB lighting Zones or play, pause, and mute music and videos instantly with media controls. G213 Prodigy is a full-sized keyboard designed for gaming and productivity.	{"Logitech G",Keyboard}	Logitech G		99	\N	t	\N	\N
25c1f995-258e-4c6e-a865-a22ed3f25cad	adidas mens Release 2 Structured Stretch Fit Cap	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/83a4f4bf98c286ed2c42273cf175f950.jpeg	2022-04-04 01:53:32.955194	2022-04-04 01:53:32.955194	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Go all-in on game day. the iconic adidas badge of sport sits offset on the front of this cap. the soft, stretch-fit build features breathable mesh and a low crown for a traditional fit.	{adidas}	adidas		30	\N	t	\N	\N
f40e8dce-7f7b-442b-b3cb-e450bef6e0fc	this is a test	https://s3.amazonaws.com/prod.landsbe.boom.ai/static/media/eca014651fd7c7bad6cd3fe6b264e4fa.jpeg	2022-03-17 05:11:04.811099	2022-04-11 18:40:13.716159	\N	\N	f3822683-4630-4834-9a2f-effd2b591a5c	\N	this is a test	{test}	test		0	\N	t	\N	\N
ffb103c7-fd32-406e-bda8-5bfe0cc01919	VERTAGEAR Racing Seat Home Office Ergonomic High Back Game Chairs, S-Line SL4000 Medium BIFMA Cert, Black/Carbon	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/92c53cb17df591163cd3a46bebf3009b.jpeg	2021-07-08 08:23:27.213541	2022-02-08 08:11:21.333318	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	Redefining gaming chairs, the Vertagear Racing Series SL-4000 brings unparalleled level of comfort and adjustability. Gamers spend hours each day in front of a computer, the new SL-4000's high density padding and contoured backrest allows for an extremely comfortable gaming experience. Designed to give wide range of adjustability that gives gamers the best comfort and support in every gaming position for extended period of time. High backrest is designed to provide neck, shoulder and lumbar support.	{VERTAGEAR,Racing}	VERTAGEAR	Racing	368	\N	t	\N	\N
9c93acf4-403e-4833-b6aa-a46073e589ea	test shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e391212503c7869fa6b5f7db0889b76c.jpeg	2022-03-21 08:59:17.805564	2022-03-21 08:59:17.805564	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	test	{test}	test		1	\N	t	\N	\N
94ef0319-2309-4e72-972e-0896e9709e1d	Apple Smart Keyboard Folio for iPad Pro 11-inch (3rd Generation and 2nd Generation) and iPad Air (4th Generation) - US English	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5bfaef26480a710dd1466acdac8447c9.jpeg	2022-04-04 01:54:49.467853	2022-04-04 01:54:49.467853	\N	\N	56ced0d5-38e5-41b9-b93e-5e54c13c0d88	c1cfcbbf-2ec9-4966-8849-277852afa41a	Apple	{Apple}	Apple		8888	\N	t	\N	\N
bcab40f4-f303-4d76-9081-c20ac241c6a2	Intel Core i7-10700K Desktop Processor 8 Cores up to 5.1 GHz Unlocked LGA1200 (Intel 400 Series Chipset) 125W (BX8070110700K)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/032906c9b8003de4cde425e978209be9.jpeg	2021-07-06 02:45:02.239608	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	10th Gen Intel Core i7-10700K unlocked desktop processor. Featuring Intel Turbo Boost Max Technology 3.0, unlocked 10th Gen Intel Core desktop processors are optimized for enthusiast gamers and serious creators and help deliver high performance overclocking for an added boost. Thermal solution NOT included in the box. ONLY compatible with 400 series chipset based motherboard. 125W.	{Intel}	Intel		1	\N	t	\N	\N
e04728f4-eebf-439d-9c4b-63b7fbf4e384	adidas	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d4e21740f24e079ac04b1b3519a34d37.jpeg	2022-03-01 08:55:29.795186	2022-03-01 08:56:22.174012	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	\N	adidas	{adidas}	adidas		9	\N	t	\N	\N
a2bed0b3-c665-4e53-97d9-3a1c08a6ddb0	Grassman Camping Tarp, Ultralight Waterproof	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/19da07ac7e2c2c26bf69ff94577d68c3.jpeg	2022-03-02 07:50:32.163015	2022-03-02 08:27:02.372305	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	\N	Grassman Camping Tarp, Ultralight Waterproof 10x10ft/10x12ft Rain Fly Shelter, Easy to Setup Camping Tarp Tent, Perfect for Backpacking, Hiking, Travel, Outdoor Adventures Survival Gears	{Grassman,"camping tarp"}	Grassman		22	\N	t	\N	\N
4a5a4128-0b2a-47f0-8b36-8b26051f1be5	Titleist Pro V1 Golf Balls	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b7be4d5b7d74d06ea093070867435607.webp	2021-07-26 22:06:53.490403	2022-01-31 09:00:15.877975			3bf8909a-e060-4e99-9eaa-a7859d2febe5	\N	The Titleist Pro V1 Mixture may contain but not limited to 2014 and older year model Pro V1 golf balls. These model golf balls feature the Tour-validated technology and performance with a spherically tiled dimple design. The Pro V1 is a three piece golf ball. The ProV1 has a softer feel, more spin, and a higher trajectory than that of the Pro V1x. Please Note: This mix will not contain a set percentage of each model.	{Titleist,Pro,V1,"Golf Balls"}	Titleist	Pro V1	\N	\N	t	\N	\N
72d2ada9-ad21-4fb8-b4e4-ad16f64dab5a	jkghghgjg	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e7a01e33ef903b9210d264f112c77534.jpeg	2022-03-03 06:08:48.52387	2022-03-03 06:08:48.544255			f3822683-4630-4834-9a2f-effd2b591a5c	\N	jkghghgjg	{test}	test		\N	\N	t	\N	\N
b2bf8c8c-b1cf-4090-9a75-c2513e6d0679	Gaming T-Shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5f820773e9cfdfbaff734562ce4a6f1a.jpeg	2021-08-27 03:14:47.623824	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	You can play computer games and show your passion by wearing clothes or accessories like this. Buy your gaming apparel now!	{Gaming}	Gaming		20	\N	t	\N	\N
61227adb-77ae-42e7-97c6-5419beac227f	RK ROYAL KLUDGE RK61  (Blue Switch, White)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/91a789e8579ba4e7b5f7df4ae5c00321.jpeg	2021-08-27 05:36:09.020276	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	Wireless 60% Mechanical Gaming Keyboard, Ultra-Compact 60 Keys Bluetooth Mechanical Keyboard with Programmable Software	{RK,RK61,"ROYAL KLUDGE","mechanical keyboard","gaming keyboard","wireless keyboard","60% keyboard"}	RK ROYAL KLUDGE	RK 61	49.99	\N	t	\N	\N
1ae3c3f4-fba8-4c13-8fd7-aaf847071d20	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c455537e5851169effceb985dd017156.jpeg	2022-03-03 06:17:58.320744	2022-04-06 16:33:51.958447	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/1_c455537e5851169effceb985dd017156.jpeg	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	\N	test	{test}	test		0	\N	t	\N	\N
d00dd8df-d033-4a04-a0f6-22521d73df7d	this is a test	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a7f4b612e5f3c840e8e6b749cb7064c6.jpeg	2022-03-03 08:49:46.92529	2022-03-03 08:49:46.95836			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	this is a test	{"this is a test"}	this is a test		\N	\N	t	\N	\N
66be9259-cea3-48f4-aeb9-2353cabf297c	Crucial BX500 1TB 3D NAND SATA 2.5-Inch Internal SSD, up to 540MB/s - CT1000BX500SSD1	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/218f6013536de4735494fdc0618adbf5.jpeg	2021-07-06 06:21:39.153519	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Ever wonder why your phone responds faster than your computer? It's because your phone runs on flash memory. Add flash to your laptop or desktop computer with the Crucial BX500 SSD, the easiest way to get all the speed of a new computer without the price. Accelerate everything.	{Crucial}	Crucial		1	\N	t	\N	\N
2bf7d30f-c2df-4ae0-9863-7f154e28b550	ps5	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d3bddd434fc70cdb321c6a685a811705.jpeg	2021-12-23 06:51:52.950426	2022-01-31 09:00:15.877975			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	this is a test	{ps5}	ps5		\N	\N	t	\N	\N
d090f8f1-89fe-49be-b1d8-d49ff5dedfd3	SAMSUNG 870 EVO 1TB 2.5 Inch SATA III Internal SSD (MZ-77E1T0B/AM)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bec9cfe307f82209a9f545ff92d0bb59.jpeg	2021-07-05 06:52:14.341847	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	The all-star of SSDs, the latest Samsung 870 EVO 1TB 2.5-Inch SATA III Internal SSD has indisputable performance, reliability and compatibility, built upon Samsung's pioneering technology. The perfect choice for IT professionals, creators and everyday users alike, the 870 EVO memory drive meets the demands of every task, from everyday computing to 8K video processing, with up to 600 TBW1 under a 5-year limited warranty2. Make your flash drive work smoothly with enhanced Samsung Magician 6 software3, which helps you easily manage your drive, keep up with the latest updates, and monitor the drive’s health and status. Using the 870 EVO Samsung SSD is as simple as plugging it into the standard 2.5-inch SATA form factor on your desktop PC or laptop. The renewed migration software takes care of the rest. Enjoy professional-level SSD performance with the 870 EVO, which maximizes the SATA interface limit to 560/530 MB/s sequential speeds4 , accelerates write speeds and maintains long-term high performance with a larger variable buffer. More compatible than ever, the 870 EVO SSD has been compatibilty tested3 for major host systems and applications including chipsets, MAS, and video recording devices⁴. 1Warrantied TBW (terabytes written) for 870 EVO: 150 TBW for 250 GB model, 300 TBW for 500 GB model, 600 TBW for 1 TB model, 1,200 TBW for 2 TB model and 2,400 TBW for 4 TB model. 25-years or TBW, whichever comes first. For more information on the warranty, please find the enclosed warranty statement in the package. 3 Compatibility tests conducted with Samsung internal, AMD, MSI, Gigabyte, Synology, QNAP, BlackMagicDesign and ATMOS. 4Performance may vary based on SSD’s firmware version and system hardware & configuration. Sequential write performance measurements are based on Intelligent TurboWrite technology. Test system configuration: Intel Core i7-7700K CPU @ 4.20GHz, DDR4 1200MHz 32GB, OS – Windows 10 Pro x64, Chipset: ASUS PRIME Z270-A. All performance data was measured with the SSD as a secondary.	{SAMSUNG}	SAMSUNG		1	\N	t	\N	\N
5b040d23-a445-4697-9caa-5a36edc35f69	AMD Ryzen 7 5800X 8-core, 16-Thread Unlocked Desktop Processor	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/0ab5f10ef2bfa02095856b1f0145d840.jpeg	2021-07-05 07:43:42.417126	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Be unstoppable with the unprecedented speed of the world’s best desktop processors. AMD Ryzen 5000 Series processors deliver the ultimate in high performance, whether you’re playing the latest games, designing the next skyscraper or crunching scientific data. With AMD Ryzen, you’re always in the lead.	{AMD}	AMD		1	\N	t	\N	\N
8e36c653-ba38-47ef-ab10-2c17c25f925d	SAMSUNG 870 QVO SATA III 2.5" SSD 1TB (MZ-77Q1T0B)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/8ce6999a7875ec32606ff23289cd9f2a.jpeg	2021-07-05 08:37:45.015719	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Sequential Read/Write performance reaching up to 560/530 MB/s provides best in class performance via the SATA interface. Accelerated read performance up to 13% faster than 860 QVO for added benefits for everyday computing. 870 QVO provides adequate amount of TBW for daily use, equivalent to 3 bit MLC SSDs and offers up to 1,440 TBW guaranteed endurance. Expanded capacity up to 4TB for client SSD in 2.5” 7mm form factor. Up To Three Year Limited Warranty. Warrantied TBW: 360 TBW for 1TB model, 720 TBW for 2TB model and 1,440 TBW for 4TB model. Limited warranty up to 3 years or up to the TBW for each capacity, whichever comes first. For more information on warranty, please find the enclosed warranty statement in the package.	{SAMSUNG}	SAMSUNG		1	\N	t	\N	\N
fd9289f9-4e48-4dea-bb62-6863a556780c	L.O.L. Surprise Dolls Sparkle Series A, Multicolor	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/be706b917de5192834285c7a6121c434.jpeg	2021-07-05 08:06:34.935222	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	Unbox 7 sparkly surprises with L.O.L. Surprise! sparkle series. Twelve fan favorite characters got a sparkly makeover, and you can find them with stunning glitter finishes and hairstyles! Look for punk Boi, boss Queen and other Five characters in all new outfits! Feed or bathe doll to discover water surprises! L.O.L. Surprise! sparkle series come packaged in a display case ball with a clear front and doll stand that can be hung up as a fabulous decoration for your room. Collect all 12 characters.	{elf}	L.O.L. Surprise!	sample1	4050	\N	t	\N	\N
5b2b15cc-b3b4-4423-b672-f562c0fa65cb	PowerA Spectra Enhanced Illuminated Wired Controller for Xbox One, gamepad, wired video game controller, gaming controller, Xbox One, works with Xbox Series X|S	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a0e613df0e03999e1a3a1e537da589b1.jpeg	2021-07-01 08:09:57.509989	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Spectra has all the great features of our popular enhanced wired Controller for Xbox One plus the addition of vibrant LED edge lighting in 7 colors and 3-way trigger Locks. This Officially Licensed Xbox Controller features 2 mappable advanced gaming Buttons on back, dual rumble motors, and 3.5mm stereo headset jack to enhance your gaming experience. Of course, you'll also find all the basics such as precision-tuned analog sticks, plus-shaped d-pad, and standard button/bumper/trigger layout. On the back of the controller, you'll find a 3-way Switch for left and right trigger to reduce trigger pull length along with a single button to change LED color, auto-cycle colors, or turn LEDs off. Finally, our 2-year limited warranty reinforces our commitment to quality ensuring you can trust POWER A products to perform.	{PowerA,Controller}	PowerA		99	\N	t	\N	\N
6395b33e-0ea8-43f5-afae-a2939c20d1d5	External CD Drive USB 3.0 Portable CD DVD +/-RW Drive DVD/CD ROM Rewriter Burner Writer Compatible with Laptop Desktop PC Windows Mac Pro MacBook	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d7c3e23d66da15c20d0bf9caae735ff7.jpeg	2021-07-06 03:51:33.71239	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	External CD Drive	{Rioddas}	Rioddas		1	\N	t	\N	\N
342a2c56-2ca2-441a-b526-8cf132a537dc	DIERYA DK61E 60% Mechanical Gaming Keyboard	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c8d4ece11eb9935993c1dfc596dbb0ad.jpeg	2021-09-06 05:09:41.312244	2022-01-31 09:00:15.877975	\N	\N	56ced0d5-38e5-41b9-b93e-5e54c13c0d88	1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	DIERYA DK61E 60% Mechanical Gaming Keyboard, RGB Backlit Wired PBT Keycap Waterproof Type-C Mini Compact 61 Keys Computer Keyboard with Full Keys Programmable (Gateron Optical Red Switch)	{DIERYA}	DIERYA		54.99	\N	t	\N	\N
eff8b235-ecd2-4123-8cad-317d7fcc2641	WD 5TB My Passport Portable External Hard Drive HDD, USB 3.0, USB 2.0 Compatible, Black - WDBPKJ0050BBK-WESN	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/73db92d9eeb4deb984b77339abda5379.jpeg	2021-07-06 06:57:24.743119	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Every journey needs a passport. The My Passport drive is trusted, portable storage that gives you the confidence and freedom to drive forward in life. With a new, stylish design that fits in the palm of your hand, there's space to store, organize, and share your photos, videos, music, and documents. Perfectly paired with Western Digital backup software and password protection, the My Passport drive helps keep your digital life's contents safe.	{"Western Digital"}	Western Digital		1	\N	t	\N	\N
39e7fb30-91e9-4b5a-a41d-64ec8d2cd81f	EVGA GeForce RTX 3080 Ti FTW3 Ultra Gaming, 12G-P5-3967-KR, 12GB GDDR6X, iCX3 Technology, ARGB LED, Metal Backplate	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ab353ffd0fe16d820c0211b0e0083f22.jpeg	2021-07-06 07:51:12.080928	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	EVGA GeForce RTX 3080 Ti FTW3 ULTRA GAMING, 12G-P5-3967-KR, 12GB GDDR6X, iCX3 Technology, ARGB LED, Metal Backplate	{EVGA}	EVGA		1	\N	t	\N	\N
e6852be3-522d-42a7-af78-d3a7c4899acc	Fjallraven, Kanken Classic Backpack for Everyday, Graphite	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/cafb5a7a4d482315dac940838c9e6ef1.jpeg	2021-07-07 05:57:14.790295	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Backpack	{Kanken}	Kanken		10	\N	t	\N	\N
43460423-2caa-4f66-b5c3-22c1ca5ba3a6	Fjällräven Kånken	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f5c1ad87cb9c2b8979d6573066b26e40.jpeg	2021-07-07 06:13:54.815537	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Fjallraven Unisex Adult Backpack Model - Kånken Reference 23510.	{Fjällräven}	Fjällräven		8	\N	t	\N	\N
7f7fe93c-914b-42df-a455-4db0073a5a00	Acer Swift 3 Thin & Light Laptop, 14" Full HD IPS, AMD Ryzen 7 4700U Octa-Core with Radeon Graphics, 8GB LPDDR4, 512GB NVMe SSD, Wi-Fi 6, Backlit KB, Fingerprint Reader, Alexa Built-in	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f36b8bf5ac3dfd5433f2ee19799b212b.jpeg	2021-07-07 08:56:04.609394	2022-01-31 09:00:15.877975	\N	\N	56ced0d5-38e5-41b9-b93e-5e54c13c0d88	c1cfcbbf-2ec9-4966-8849-277852afa41a	Acer Swift 3 SF314-42-R9YN comes with these high level specs: AMD Ryzen 7 4700U Octa-Core Mobile Processor 2. 0GHz with Precision Boost up to 4. 1GHz (Up to 8MB L3 Cache), Windows 10 Home, 14" Full HD Widescreen IPS LED-backlit Display 1920 x 1080 resolution; 16: 9 aspect ratio, AMD Radeon Graphics, 8GB LPDDR4 Onboard Memory, 512GB PCIe NVMe SSD, DTS Audio, featuring optimized bass response and micro-speaker distortion prevention, Two built-in front facing stereo speakers, Acer Purified. Voice technology with two built-in microphones, Intel Wireless Wi-Fi 6 AX200 802. 11ax Dual-Band 2. 4GHz and 5GHz featuring 2x2 MU-MIMO technology (Max Speed up to 2. 4Gbps), Bluetooth 5. 0, Back-lit Keyboard, Acer Bio-Protection Fingerprint Solution, featuring Computer Protection and Windows Hello Certification, HD Webcam (1280 x 720) supporting Super High Dynamic Range (SHDR), 1 - USB Type-C port USB 3. 2 Gen 2 (up to 10 Gbps) DisplayPort over USB Type-C & USB Charging, 1 - USB 3. 2 Gen 1 port (featuring power-off charging), 1 - USB 2. 0 port, 1 - HDMI port, Lithium-Ion Battery, Up to 11. 5-hours Battery Life, 2. 65 lbs. 1. 2 kg (system unit only) (NX. HSEAA. 003).	{Acer}	Acer		88	\N	t	\N	\N
f996d137-50bd-467a-bfd7-d68d8941d801	G Fuel Pewdiepie (40 Servings) Elite Energy and Endurance Powder 9.8 oz. Inspired by Pewds	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/3ed972c17ac82cb7662fe9e3bee35e32.jpeg	2021-07-09 06:24:25.170304	2022-01-31 09:00:15.877975	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	Fuel	{elf,"G Fuel"}	G Fuel		29	\N	t	\N	\N
e1446c51-1f95-4efd-9461-179aa8e6a028	Guilty Gear -Strive- - PlayStation 4	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/14116d071c16e6eb99d8412ed013a2a2.jpeg	2021-07-12 07:57:56.397627	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	A brand-new game in the Guilty Gear series, dedicated to all fighting game fans and all game players. Featuring 3D visuals that could be mistaken for hand-drawn anime (2.5D), achieved by further refining the animation technique of the highly praised Guilty Gear Xrd series. The series' charismatic characters have been completely renewed and many new characters join the cast. The play feel has been revamped from previous games. It remains an easy-to-understand system while achieving greater depth than ever before. It also features numerous rock songs composed by General Director Daisuke Ishiwatari, and a story mode boasting more volume and scenes than a movie, designed not only for Guilty Gear fans, but also for anime fans. Key Features: Charismatic characters. The designs of existing characters have been completely revamped. Also featuring new characters. Easy to understand, deeper fighting system than ever before. BGM and vocal songs by Daisuke Ishiwatari, making for breathtaking battles. Featuring songs that are completely new. Comfortable online play with "rollback netcode" Full features even in offline play. Featuring a story mode with greater volume than a movie. Plans to release DLC characters regularly	{elf,PS4}	PS4		69	\N	t	\N	\N
d7f7d991-a5a8-43ca-945c-b2d335d2c7db	UNO Family Card Game, with 112 Cards in a Sturdy Storage Tin, Travel-Friendly, Makes a Great Gift for 7 Year Olds and Up [Amazon Exclusive]	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/eeef50435f0c01d074a174855c51dbbf.jpeg	2021-07-14 01:20:55.310305	2022-01-31 09:00:15.877975	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	c1cfcbbf-2ec9-4966-8849-277852afa41a	UNO is the classic family card game that's easy to pick up and impossible to put down! Players take turns matching a card in their hand with the current card shown on top of the deck either by color or number. Special action cards, like Skips, Reverses, Draw Twos, color-changing Wild and Draw Four Wild cards, deliver game-changing moments as they each perform a function to help you defeat your opponents. If you can't make a match, you must draw from the center pile. And when you're down to one card, don't forget to shout "UNO!" The first player to get rid of all the cards in their hand wins. Now card game-lovers can get UNO in a sturdy tin that's great for travel and makes storage stress-free. Colors and decorations may vary.	{"Mattel Games"}	Mattel Games		10	\N	t	\N	\N
4a31477a-90ea-4c86-adf8-81121f4e94f6	Jurassic Park Hat Classic Logo Curved Snapback Cap Grey	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/6dc45e6e9ad48cab8b10757303b302c4.jpeg	2021-07-15 21:39:00.376064	2022-01-31 09:00:15.877975	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	c1cfcbbf-2ec9-4966-8849-277852afa41a	Officially Licensed Jurassic Park movie fan merchandise from Bioworld. The movie centers around the failed attempts to create a theme park where dinosaurs roam. As you can imagine, it doesn't go well. This cap features an embroidered classic Jurassic Park log on front, a precurved brim, and a snapback closure. One size fits most ages 14 and up. Crown and Visor made of 85% Acrylic, 15% Wool, and Upper visor made of 100% cotton. This snapback hat makes a great gift for birthdays, Christmas, Fathers Day, or any other special occasion.	{Hat}	Hat		1	\N	t	\N	\N
4cd0ef56-473f-4561-a69d-e6e70c5b21eb	Drop ALT	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e4c1cd9a2a750de8a01dd6d98d5e0973.jpeg	2021-08-20 06:50:14.218428	2022-01-31 09:00:15.877975	\N	\N	f3822683-4630-4834-9a2f-effd2b591a5c	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	High-Profile Mechanical Keyboard — 65% (67 Key) Gaming Keyboard, Hot-Swap Switches, Programmable Macros, Backlit RGB LED, USB-C, Doubleshot PBT, Aluminum Frame (Kaihua Speed Silver, Gray)	{ALT,Drop}	DROP	ALT	250	\N	t	\N	\N
80b232c8-647c-4bc9-9a38-0c3271a6e5cf	Little Tikes Easy Score Basketball Set, Blue, 3 Balls - Amazon Exclusive	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/39b59392eb733aa8393945c771a2c8a5.jpeg	2021-07-15 21:42:44.210245	2022-01-31 09:00:15.877975	\N	\N	3bf8909a-e060-4e99-9eaa-a7859d2febe5	c1cfcbbf-2ec9-4966-8849-277852afa41a	The Little Tikes easy score basketball set, designed for children 18 months to 5 years old, introduces kids of all abilities to the game of basketball and competitive play. The height can be adjusted to six settings between 2.5 and 4 feet to accommodate even the littlest hoop Star. The oversize rim and kid-size basketball ensure easy scoring and help kids develop hand-eye coordination while providing the right challenge level. Before play, add sand to the base for stability.	{Basketball}	Basketball		12	\N	t	\N	\N
90aee367-d6b7-4dcd-a55c-453c68b16079	Disney Buzz Lightyear Interactive Talking Action Figure - 12 Inches	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a1ff31b9aec556ee2acda2e3b51a1021.jpeg	2021-07-15 21:44:08.632425	2022-01-31 09:00:15.877975			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	Disney Buzz Lightyear Interactive Talking Action Figure - 12 Inches	{"Disney "}	Disney		\N	\N	t	\N	\N
2759d444-b0de-4fad-afbe-38e6db6ac3c1	Amazon Basics Reusable Silicone Baking Cups, Pack of 12, Multicolor	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/969b6af00419c9ac3658c38b0ee38c71.jpeg	2021-07-22 06:09:43.146449	2022-01-31 09:00:15.877975			3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	\N	Amazon Basics Reusable Silicone Baking Cups, Pack of 12, Multicolor	{"Amazon Basics"}	Amazon Basics		\N	\N	t	\N	\N
604f0b4b-6977-4b5d-a38b-e9e22983f1aa	Amazon Basics Lightweight Super Soft Easy Care Microfiber Sheet Set with 14" Deep Pockets, Queen, Dark Grey	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2787597fbeedaf6e8a387fe62a375400.jpeg	2021-07-22 06:10:14.111398	2022-01-31 09:00:15.877975			3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	\N	Amazon Basics Lightweight Super Soft Easy Care Microfiber Sheet Set with 14" Deep Pockets, Queen, Dark Grey	{"Amazon Basics"}	Amazon Basics		\N	\N	t	\N	\N
21f26f80-07c6-4190-a890-a5f194c7e1e5	Amazon Basics Legal Pads, Pink, Orchid & Blue Color Paper, 6-Pack	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e93917fe6ff255a59dda304d1e5835bb.jpeg	2021-07-22 07:42:10.460364	2022-01-31 09:00:15.877975			9ab3033b-1adf-40ca-a6b1-91a551ce789d	\N	Amazon Basics Legal Pads, Pink, Orchid & Blue Color Paper, 6-Pack	{"Amazon Basics"}	Amazon Basics		\N	\N	t	\N	\N
9ee50219-d046-4c19-90c6-eb5a75357cb4	Amazon Basics Quick-Dry Bath Towels - 100% Cotton, 2-Pack, White	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a28017e45bb08295a91dd49115046bae.jpeg	2021-07-22 07:42:35.994763	2022-01-31 09:00:15.877975			3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	\N	Amazon Basics Quick-Dry Bath Towels - 100% Cotton, 2-Pack, White	{"Amazon Basics"}	Amazon Basics		\N	\N	t	\N	\N
6c936fce-8222-47b5-819d-504fc9207d44	Clear Glass Beer Cups – 6 Pack – All Purpose Drinking Tumblers, 16 oz – Elegant Design for Home and Kitchen – Great for Restaurants, Bars, Parties – by Kitchen Lux	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/3346a19d71a38d83bf2f1dd15a961382.jpeg	2021-11-16 08:04:04.259815	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Perfectly constructed with clear glass to fit any interior aesthetic or party mood, these amazing drinking tumbler glasses will become a staple in any household for casual drinking of your favorite beverages!	{"Kitchen Lux"}	Kitchen Lux		99	\N	t	\N	\N
e53171fd-ddbc-44cc-955b-1c76e1a2eddb	BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c72abaaf3d5ced542e401de02fbb89bf.jpeg	2021-11-18 08:20:48.449745	2022-01-31 09:00:15.877975	\N	\N	814171c4-64fb-4c32-a78b-ae5bfbfa536e	c1cfcbbf-2ec9-4966-8849-277852afa41a	BAIESHIJI Essential Oil Diffuser, Metal Vintage Essential Oil Diffusers 100ML, Aromatherapy Diffuser with Waterless Auto Shut-Off Protection, Cool Mist Humidifier for Bedroom Home, Office	{Diffuser}	BAIESHIJI		23	\N	t	\N	\N
0f85b11a-ed86-4140-ab76-b7e082814b61	PlayStation DualSense Wireless Controller – Midnight Black 	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/97427a97cd532737ba288c82633d27cf.jpeg	2021-11-25 02:12:14.438067	2022-01-31 09:00:15.877975			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	Ignite your gaming nights on your PS5 console with the DualSense Midnight Black wireless controller. Part of a new line-up of galaxy-themed colors, this sleek design takes inspiration from how we view the wonders of space through the night sky, with subtle shades of black and light gray detailing. Discover a deeper, highly immersive gaming experience** that brings the action to life in the palms of your hands. The DualSense wireless controller offers immersive haptic feedback*, dynamic adaptive triggers* and a built-in microphone, all integrated into an iconic comfortable design. (*Available when feature is supported by game. **Compared to DUALSHOCK 4 wireless controller. †Internet and account for PlayStation Network required.)	{"ps5 ",PlayStation}	PlayStation		\N	\N	t	\N	\N
03a67472-2c18-416f-8344-9eed04b88e5a	Sheoolor Quiet Essential Oil Diffuser, 200ml Vintage Vase Aromatherapy Diffuser with Waterless Auto Shut-Off Function & 7-Color LED Changing Lights Diffuser for Essential Oils, for Home, Office, Yoga	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/03f01fc4f80da36a76b83f41bb4ba14e.jpeg	2021-11-25 02:46:55.043779	2022-01-31 09:00:15.877975	\N	\N	4fe9e697-47fd-4c21-9794-9a6908f13e0c	46056b5e-3e3f-40ce-8477-8d3dcc19f006	Sheoolor Quiet Essential Oil Diffuser, 200ml Vintage Vase Aromatherapy Diffuser with Waterless Auto Shut-Off Function & 7-Color LED Changing Lights Diffuser for Essential Oils, for Home, Office, Yoga	{Diffuser,"Changing Lights Diffuser"}	Sheoolor		27.99	\N	t	\N	\N
494798a6-b431-462b-aa81-adfd6fd82740	Acer Swift 3 Thin & Light Laptop, 14" Full HD IPS, AMD Ryzen 7 4700U Octa-Core with Radeon Graphics, 8GB LPDDR4, 512GB NVMe SSD, Wi-Fi 6, Backlit KB, Fingerprint Reader, Alexa Built-in	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f36b8bf5ac3dfd5433f2ee19799b212b.jpeg	2021-07-26 22:04:16.409991	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	38694216-a4d0-4dd1-868f-46f507e7596b	Acer Swift 3 SF314-42-R9YN comes with these high level specs: AMD Ryzen 7 4700U Octa-Core Mobile Processor 2. 0GHz with Precision Boost up to 4. 1GHz (Up to 8MB L3 Cache), Windows 10 Home, 14" Full HD Widescreen IPS LED-backlit Display 1920 x 1080 resolution; 16: 9 aspect ratio, AMD Radeon Graphics, 8GB LPDDR4 Onboard Memory, 512GB PCIe NVMe SSD, DTS Audio, featuring optimized bass response and micro-speaker distortion prevention, Two built-in front facing stereo speakers, Acer Purified. Voice technology with two built-in microphones, Intel Wireless Wi-Fi 6 AX200 802. 11ax Dual-Band 2. 4GHz and 5GHz featuring 2x2 MU-MIMO technology (Max Speed up to 2. 4Gbps), Bluetooth 5. 0, Back-lit Keyboard, Acer Bio-Protection Fingerprint Solution, featuring Computer Protection and Windows Hello Certification, HD Webcam (1280 x 720) supporting Super High Dynamic Range (SHDR), 1 - USB Type-C port USB 3. 2 Gen 2 (up to 10 Gbps) DisplayPort over USB Type-C & USB Charging, 1 - USB 3. 2 Gen 1 port (featuring power-off charging), 1 - USB 2. 0 port, 1 - HDMI port, Lithium-Ion Battery, Up to 11. 5-hours Battery Life, 2. 65 lbs. 1. 2 kg (system unit only) (NX. HSEAA. 003).	{}	Acer	\N	1200	\N	t	\N	\N
05092acd-a28f-414f-997b-a30267b46cfa	Puckator Game Controller Handle Mug Games Game Over Gaming Mug Console Remote	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/149a4b696cdefddaa5e825db890a04af.jpeg	2021-08-27 03:10:58.823463	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Fun Game Controller Shaped Handle Ceramic Mug	{Puckator}	Puckator		20	\N	t	\N	\N
2686362a-cfc1-4bc9-a7cc-ae6de5c7da9a	Acer R240HY bidx 23.8-Inch IPS HDMI DVI VGA (1920 x 1080) Widescreen Monitor, Black	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5579fa09fe5dd15b69cfe1935319b0ad.jpeg	2021-08-03 06:30:07.204176	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	The Acer R Series 23. 8" wide viewing IPS display shows every detail clearly and vivid without color difference from any viewing angle. Its zero frame design puts no boundary on your visual enjoyment while the brushed hairline finish stand matches any environment. With Full HD resolution and superior 100 Million: 1 contrast ratio you get detailed imagery for viewing photos, browsing the web and also makes viewing documents side by side easy. It also supports VGA, DVI & HDMI inputs so you can easily power and extend the enjoyment from your smartphone or tablet on Full HD display. What's more, this display features power-saving technologies to conserve cost and resources. (UM. QR0AA. 001). Environmental certification: MPR II.	{Acer}	Acer		1	\N	t	\N	\N
5fbf40a6-e494-49bb-a7e3-483b430e1d00	Atari Atari Logo in Circles T-shirt T-Shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/17bb385f40e05b3bc04f16dde0ad7ad6.jpeg	2021-08-04 02:43:53.118644	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	A true video game innovator founded in 1972, show the world your love for retro gaming in this officially licensed Atari t-shirt by Ripple Junction.	{Atari}	Atari		20	\N	t	\N	\N
8d928ab5-ab49-4673-9cb4-d3c5fa4a9ca5	Consola Xbox Series S	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/f6c37c02f7ad34d31e3b40dea0d33699.jpeg	2021-08-18 09:45:41.941576	2022-01-31 09:00:15.877975			3bf8909a-e060-4e99-9eaa-a7859d2febe5	\N	Experimenta la velocidad y el rendimiento de una consola totalmente digital de próxima generación a un precio accesible. Empieza con una biblioteca instantánea de más de 100 juegos de alta calidad, incluidos todos los títulos nuevos de Xbox Game Studios como Halo Infinite el día de su lanzamiento, cuando agregues Xbox Game Pass Ultimate (la membresía se vende por separado). * Alterna sin problemas entre varios juegos en un instante con Quick Resume. En el corazón de la Serie S se encuentra la Arquitectura Xbox Velocity, que combina un SSD personalizado con un software integrado para un juego más rápido y optimizado con tiempos de carga significativamente reducidos.	{Xbox,"Xbox Series S",Consola}	Consola	Xbox Series S	\N	\N	t	\N	\N
ee16ff49-53a5-4e36-92b6-29e41ce5a06a	SteelSeries Rival 3 Gaming Mouse - 8,500 CPI TrueMove Core Optical Sensor - 6 Programmable Buttons - Split Trigger Buttons - Brilliant Prism RGB Lighting	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/729925e19fbcb34712efa00fa3a51880.jpeg	2021-08-20 02:17:41.873876	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	The rival 3 gaming mouse has the best performance in its class thanks to a tournament-grade true move core optical gaming sensor which is custom-engineered in collaboration with industry-leading sensor manufacturer pixart hyper-durable materials the lifespan of the mouse which is rated for 60 million clicks in a lightweight build a redesigned RGB system provides the brightest dynamic lighting on any steel series mouse making the rival 3 a standout in both style and performance.	{"Rival 3",SteelSeries}	SteelSeries	Rival 3	45	\N	t	\N	\N
4237530d-65fb-4bcb-b596-b37612f0d95b	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bfaeabe0e9ffd017765329610375e9d4.jpeg	2021-11-17 01:45:32.770951	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	e498f885-498f-4a95-afa0-9370f4a6a866	Oil Resistant Doubleshot PBT Keycaps, Made of textured, high grade PBT for a more durable and textured finish less prone to long term grime buildup	{Razer}	Razer	\N	1	\N	t	\N	\N
e5b625a1-058e-4ed7-9c17-9546ee953078	gaming mouse	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/173fe5f8b026fb0c57eed4acb69f14c5.jpeg	2021-11-25 02:14:27.032	2022-01-31 09:00:15.877975			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	gaming mouse	{asus}	asus		\N	\N	t	\N	\N
f6e7165f-f710-42b6-b3d0-86917f4fea59	test	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b51ea37d667cdb688753a6576b95661c.jpeg	2021-11-25 02:48:42.563317	2022-01-31 09:00:15.877975			f3822683-4630-4834-9a2f-effd2b591a5c	\N	test	{test}	test		\N	\N	t	\N	\N
8508b215-d072-4dab-a526-4e6ecf00148a	Amazon Basics XXL Gaming Computer Mouse Pad - Black	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c203a7aa6d52565546f5b99d13524d7c.jpeg	2021-11-19 05:14:33.515158	2022-01-31 09:00:15.877975	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/1_c203a7aa6d52565546f5b99d13524d7c.jpeg	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Amazon Basics XXL Gaming Computer Mouse Pad - Black	{"Amazon Basics"}	Amazon Basics	Amazon Basics	1	\N	t	\N	\N
be4dc5a9-a111-442f-a661-ec2cf1aa671d	PICTEK Ergonomic Wired Gaming Mouse, 8 Programmable Buttons , 5 Levels Adjustable DPI up to 8000, Wired Computer Gaming Mice with 7 RGB Backlight Modes for PC, Laptop, MacBook	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/8e9b3c195bc31e0fc7b70e9e96d00815.jpeg	2021-07-01 08:01:40.083122	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Product DescriptionVicTsing ergonomic wired RGB mouse!You unchallenged choice to enjoy ultimate comfort and immersive gaming at the same time!Create Your Preferred RGB Lighting ModesThe bottom light button enables you to quickly switch among 7 lighting modes. Long press to turn off light. Moreover, you can customize light’s brightness and changing speed via the software. Match your desk setup style perfectly.Outstanding DurabilityTested over 10 million of clicks, VicTsing gaming mouse withstands fast and intense gaming. 1.56m cable is long and reliable enough for daily use.Universal CompatibilityWorks with Windows10, Windows8, Windows7.(Note: no programming function for Mac OS system).Note:Do not use the mouse on glass or mirror.The program function is only available on Windows system.Forward and backward buttons are not available on Mac OS system.Package IncludesMouse x 1User Manual x 1CD x 1VIP Card x 1	{PICTEK,Mouse}	PICTEK	123	13	\N	t	\N	\N
04eae946-5dbf-4ecc-8730-66bfc2870e24	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bfaeabe0e9ffd017765329610375e9d4.jpeg	2021-08-31 03:10:22.366626	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	Oil Resistant Doubleshot PBT Keycaps, Made of textured, high grade PBT for a more durable and textured finish less prone to long term grime buildup	{Huntsman,Razer}	Razer	Huntsman	83	\N	t	\N	\N
2325483c-0d81-4543-a9eb-a5035b18f64d	Amazon Basics Pre-Seasoned Cast Iron Skillet Pan, 10.25 Inch	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/19a6e81c7cd47de341e21217b33809b5.jpeg	2021-08-31 03:10:41.731909	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Amazon Basics Pre-Seasoned Cast Iron Skillet Pan, 10.25 Inch	{"Amazon Basics"}	Amazon Basics		1	\N	t	\N	\N
872b4b3c-2b39-4b89-8479-9b155cce09e1	G Fuel Pewdiepie (40 Servings) Elite Energy and Endurance Powder 9.8 oz. Inspired by Pewds	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/3ed972c17ac82cb7662fe9e3bee35e32.jpeg	2021-08-31 03:13:12.676784	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Fuel	{"G Fuel"}	G Fuel	\N	1.5	\N	t	\N	\N
babd52a4-e59e-428c-a294-c3787d5a21f0	McFarlane - DC Multiverse  Figures - Death Metal Batman	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/186720635b5606aea4b1af9c4082e852.jpeg	2021-09-17 08:45:39.83669	2022-01-31 09:00:15.877975			56ced0d5-38e5-41b9-b93e-5e54c13c0d88	\N	Following the universe-shattering events of Dark Nights: Metal, the Earth is enveloped by the Dark Multiverse and has transformed into a hellish landscape twisted beyond recognition. Willing to sacrifice his own humanity for the greater good, Batman wields an evil Black Lantern power ring, which grants him the power to resurrect the dead. Now, leading an army of zombies and riding a Batcycle made of bones, the Dark Knight wages war against The Batman Who Laughs and his omnipotent goddess, Perpetua, in his mission to save the DC Multiverse!	{batman,dc}	McFarlane Toys		0	\N	t	\N	\N
bd1918a0-95b0-4223-9ed3-f9ce6878c9d1	The Legend of Zelda Nintendo Zelda Grey & Black Snapback Baseball Hat	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/137b8ffb29464aae25cbcc0f101dd1db.jpeg	2021-09-21 22:42:15.506021	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Bioworld produces authentic and beautiful high-quality apparel and accessories based on some of the hottest and most popular properties. A must have for any Zelda enthusiast!	{Nintendo}	Nintendo		100	\N	t	\N	\N
6805751f-265f-41f1-bc9b-8fc99f87e76d	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bfaeabe0e9ffd017765329610375e9d4.jpeg	2021-11-17 01:46:49.874161	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Oil Resistant Doubleshot PBT Keycaps, Made of textured, high grade PBT for a more durable and textured finish less prone to long term grime buildup	{keyboard}	Razer	\N	2	\N	t	\N	\N
2ef0ad20-6597-418d-b682-1c8203f0a202	Dragon Ball Super Limit Breaker 12" Action Figure - Goku, Model Number: 36737	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/878210dac84cb2ba8300445aac9bc7c4.jpeg	2021-09-21 22:42:57.441006	2022-01-31 09:00:15.877975	\N	\N	f3822683-4630-4834-9a2f-effd2b591a5c	c1cfcbbf-2ec9-4966-8849-277852afa41a	Create your own Dragon Ball world with these awesome Limit Breaker figures. The realism of these 12-inch favorites transport you to the imaginative world of the show you love. You can recreate your favorite scenes in your home or your own backyard. Super durable to survive even the fiercest battles you put them through. Goku is earth’s greatest defender, possessing unrivaled power and a moral compass that surpasses all others. Born Kakorot, a Saiyan, he arrived as a defenseless infant with a mission to take over the planet. When he lost his memory, his good-hearted nature and sense of compassion and kindness emerged. Through fierce determination and intense training, he evolved into a disciplined warrior, pushing his limits against any opponent no matter how much stronger. With his superior level of character and strength, good always prevails over evil.	{"Dragon Ball Super"}	Dragon Ball Super		10	\N	t	\N	\N
518d0540-08df-4482-8be4-28c0bed226c7	Arteck 2.4G Wireless Keyboard Stainless Steel Ultra Slim Full Size Keyboard with Numeric Keypad for Computer/Desktop/PC/Laptop/Surface/Smart TV and Windows 10/8/ 7 Built in Rechargeable Battery	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/51f3d5ae0ef7c68481d18462134bdc4a.jpeg	2021-10-11 03:52:51.14083	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Industry Leading Ergonomic Design Stainless steel material gives heavy duty feeling and the low-profile keys offer quite and comfortable typing. Easy Setup and UseJust simply insert the nano USB receiver into your computer like desktop or laptop, then the keyboard can be used instantly. No need driver.The Keyboard will work up to 33 feet or 10 meters.It allow you to gain quick access to common functions, such as volume level, playback control, copy paste text, and more. It also provides arrow keys, number pad with slim and compact design. Comfortable, quiet typing The whisper-quiet, low-profile keys bring a whole new level of comfort to your fingertips. What's more, keep all your most-used functions and media controls closer than ever Windows-dedicated hot keys.The construction of this scissors-kick keys can be used more than 3 million times continuously. Rechargeable Battery Built-in industry-high rechargeable Li-polymer battery provides 6-month use on a single charge. (based on 2 hours non-stop use per day)	{Arteck}	Arteck		1	\N	t	\N	\N
54c9a141-d397-4d47-b712-40201a759dac	Razer Huntsman Tournament Edition TKL Tenkeyless Gaming Keyboard: Linear Optical Switches Instant Actuation - Customizable Chroma RGB Lighting, Programmable Macro Functionality - Matte Black (Renewed)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/bfaeabe0e9ffd017765329610375e9d4.jpeg	2021-10-14 21:22:35.776327	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	178bfbb8-9cc9-4728-8871-a7ee8a80ece1	Oil Resistant Doubleshot PBT Keycaps, Made of textured, high grade PBT for a more durable and textured finish less prone to long term grime buildup	{}	Razer	\N	0.01	\N	t	\N	\N
dc5c46b0-c9ca-4639-84c3-afd90f1bcff1	Razer DeathAdder Essential Gaming Mouse: 6400 DPI Optical Sensor - 5 Programmable Buttons - Mechanical Switches - Rubber Side Grips - Mercury White	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5558a5188bd5e3f0b78063eaf8fb1686.jpeg	2021-10-15 05:45:14.424946	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	e498f885-498f-4a95-afa0-9370f4a6a866	The Razer DeathAdder essential retains the classic ergonomic form that's been a hallmark of previous Razer DeathAdder generations. Its sleek and distinct body is designed for comfort, allowing you to maintain high levels of performance throughout long gaming marathons, so you'll never falter in the heat of battle.	{Razer}	Razer		1	\N	t	\N	\N
f5e9a314-a62e-4b4a-98f8-2e5aae6794d9	Lavender Essential Oils	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/640a4717849266672ce3be6702161e2c.png	2021-10-18 06:06:07.501128	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Pure Lavender Oil Essential Oil - Premium Therapeutic Grade Lavender Essential Oils for Diffuser Plus Healthy Hair Skin and Nails Support - Undiluted Lavender Aromatherapy Oils for Diffuser	{"Maple Hollistic","Diffuser Oil"}	Maple Hollistic		7	\N	t	\N	\N
a8c1d45f-a2a1-403b-bf3b-de26fd8fbdb1	KHOYIME Moon Dream Catcher Macrame Wall Hanging - Bohemian Home Decor Handmade Woven Decoration for Kids Room Home Wedding Ornament Craft Gift (moon-light)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/fbb22ecb620b8c9f829e269bd48da4ce.jpeg	2021-10-18 08:41:21.230691	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	46056b5e-3e3f-40ce-8477-8d3dcc19f006	KHOYIME Moon Dream Catcher Macrame Wall Hanging - Bohemian Home Decor Handmade Woven Decoration for Kids Room Home Wedding Ornament Craft Gift (moon-light)	{decor,bohemian}	KHOYIME		12.99	\N	t	\N	\N
75aa62b5-bb2e-4eae-ad8c-e104a055d863	Coffee++ Program 11oz Coffee Mug	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ad4ed826f87d017500d4c7666d8782c1.jpeg	2021-11-09 05:24:21.570072	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Nerd Engineer Idea for Men Science Mug Great Gag for Programmer Geeks Computer Science Developers Coders Ceramic Tea Mugs For Adults - By AW Fashions	{"AW Fashions",mug}	AW Fashions		10	\N	t	\N	\N
c903f609-33b3-4aa7-98a7-03fa38358ab8	Coffee++ Program 11oz Coffee Mug Nerd Engineer Idea for Men Science Mug Great Gag for Programmer Geeks Computer Science Developers Coders Ceramic Tea Mugs For Adults - By AW Fashions	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/81b7b8bda0efc644a48b06e5254f2778.jpeg	2021-11-09 05:35:21.002194	2022-01-31 09:00:15.877975	\N	\N	9ab3033b-1adf-40ca-a6b1-91a551ce789d	c1cfcbbf-2ec9-4966-8849-277852afa41a	Coffee++ Program 11oz Coffee Mug Nerd Engineer Idea for Men Science Mug Great Gag for Programmer Geeks Computer Science Developers Coders Ceramic Tea Mugs For Adults - By AW Fashions	{mug}	AW Fashions		10	\N	t	\N	\N
0eaa4389-67ec-405f-b32f-d67596c5cac2	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a98220c425dafae8100255c610c66431.jpeg	2021-11-11 09:06:38.755693	2022-01-31 09:00:15.877975			3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	\N	Pajama Family T-Shirt	{Happy}	Happy		\N	\N	t	\N	\N
91d8eb82-3946-4e0e-bfea-d07cd7575bb9	APL: Athletic Propulsion Labs Women's Techloom Pro Sneakers	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ee22e79a1a64a18925640cd0a876bbe0.jpeg	2021-11-12 08:19:31.780318	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Mixed-stitch patterns accent the fused knit upper of these APL: Athletic Propulsion Labs sneakers. The Propelium midsole lends a comfortable fit. Lace-up closure. Pull-tab in back. Textured rubber sole.	{Techloom}	Techloom		10	\N	t	\N	\N
4dd718a3-5217-4762-9749-72e782921be5	Canon EOS M50 Mirrorless Camera Kit w/EF-M15-45mm and 4K Video (Black) (Renewed)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ffb350e118a6f261b51ade70021e823a.jpeg	2021-11-15 01:34:30.582141	2022-01-31 09:00:15.877975	\N	\N	56ced0d5-38e5-41b9-b93e-5e54c13c0d88	c1cfcbbf-2ec9-4966-8849-277852afa41a	24p UHD 4K and 120p HD for slow motion Improved Dual Pixel CMOS AF and Eye Detection AF 24.1 MP (APS-C) CMOS sensor with ISO 100-25600 New DIGIC 8 image processor Improved auto lighting optimizer Built-in OLED EVF with touch and drag AF Vari-angle Touchscreen LCD Built-in Wi-Fi, NFC and Bluetooth technology Automatic image transfer to devices while shooting Silent mode for quiet operation	{Canon}	Canon		20	\N	t	\N	\N
2a26beba-9511-422f-8710-2dcbce344a8f	Happy New Year 2022 New Years Eve Goodbye 2021 Pajama Family T-Shirt	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a98220c425dafae8100255c610c66431.jpeg	2021-11-16 05:13:12.109055	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Pajama Family T-Shirt	{Happy}	Happy	\N	25	\N	t	\N	\N
03bad356-71fc-4517-a907-542b06a0cac3	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ec5712d8eaa1e738a4467de622558a05.jpeg	2021-12-17 06:37:58.776173	2022-01-31 09:00:15.877975			56ced0d5-38e5-41b9-b93e-5e54c13c0d88	\N	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	{ps5}	ps5		\N	\N	t	\N	\N
585c9180-9626-41be-b6a5-1deaa60a9bc7	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/196fa7eebafd27abfd14a3ec41fbb15f.jpeg	2021-12-17 06:49:01.468808	2022-01-31 09:00:15.877975			56ced0d5-38e5-41b9-b93e-5e54c13c0d88	\N	2021 Newest PS5_by_Playstation Console Disk Edition, x86-64-AMD Ryzen Zen 8 Cores, AMD Radeon RDNA 2, 16GB GDDR6 RAM, 825GB SSD + One Wireless Controller + Marxso1 Fast Dual Controller Charging Dock	{ps5}	ps5		\N	\N	t	\N	\N
8f4c491a-225b-4035-aed7-60838092a99e	Playstation DualSense Wireless Controller	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/46bb70eecb519d424ba86c74cbd01d25.jpeg	2021-12-22 05:51:50.598817	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	Discover a deeper, highly immersive gaming experience that brings the action to life in the palms of your hands. The DualSense wireless controller offers immersive haptic feedback, dynamic adaptive triggers and a built-in microphone, all integrated into an iconic comfortable design. Compared to DUALSHOCK 4 wireless controller. Available when feature is supported by game.	{ps5}	ps5		1	\N	t	\N	\N
15cb120a-3ec4-4468-b4ed-d06b11eb5960	ps5 with seller	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/5e31e40bc44cc57287a9098d89d3d6d3.jpeg	2021-12-23 07:38:32.860748	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	this is a test	{ps5}	ps5		1	\N	t	\N	\N
334fa9d7-0294-4f40-a86e-2263897599fd	Star Wars The Child Plush Toy, 8-in Small Yoda Baby Figure from The Mandalorian, Collectible Stuffed Character for Movie Fans of All Ages, 3 and Older	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/a8b3a89fc724f40ecebde0f5de69f3a7.jpeg	2021-11-23 09:16:24.629825	2022-01-31 09:00:15.877975	\N	\N	4fe9e697-47fd-4c21-9794-9a6908f13e0c	c1cfcbbf-2ec9-4966-8849-277852afa41a	Fully embrace the cuteness of the 50-year-old Yoda species with this adorable 8-inch plush toy. He may look like a Baby Yoda, but this lovable creature is referred to as "The Child." Inspired by the Disney+ live-action series, The Mandalorian, this sweet Star Wars plush toy makes a Force-sensitive addition to any fan's collection. Pictures shown are for illustration purposes only. Actual product may vary slightly.	{Mattel}	Mattel		10	\N	f	\N	\N
537066b1-62e3-49b3-94d5-4dd8665ac39c	Timberland Short Watch Cap	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/c592a88df1974a283bf31317d229be6b.jpeg	2022-01-07 08:21:20.611939	2022-01-31 09:00:15.877975	\N	\N	f3822683-4630-4834-9a2f-effd2b591a5c	c1cfcbbf-2ec9-4966-8849-277852afa41a	Designed for comfort and warmth, this cuffed watch cap is the perfect accessory to keep your head warm when the temperature drops.	{Timberland}	Timberland		9	\N	f	\N	\N
50cf79f5-e72f-45ad-9c6e-eb01080c343a	ps5	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/fd88411afdcaf1a36bc9190942fe0ac9.jpeg	2021-12-23 06:50:38.01021	2022-01-31 09:00:15.877975			8f2815df-fd83-44c6-9586-24ed947acf6e	\N	this is a test	{ps5}	ps5		\N	\N	f	\N	\N
5a9f5de2-5850-4151-8896-18ea39794357	test	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b51ea37d667cdb688753a6576b95661c.jpeg	2022-01-26 08:58:20.016318	2022-01-31 09:00:15.877975	\N	\N	8f2815df-fd83-44c6-9586-24ed947acf6e	c1cfcbbf-2ec9-4966-8849-277852afa41a	test	{test}	test	\N	1	\N	t	\N	\N
31e559de-7092-4127-b29b-77cc5c5ed39f	London Fog Women's Plus-Size Mid-Length Faux-Fur Collar Down Coat with Hood	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/d6205f18879df5c339dde634d14ba2b1.jpeg	2022-01-07 01:32:05.566624	2022-01-31 09:00:15.877975	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/1_d6205f18879df5c339dde634d14ba2b1.jpeg	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	London	{London}	London		1	\N	t	\N	\N
3f6b6b96-383e-4b71-bb5b-f493d0fe83e7	Amazon Essentials Men's Heavyweight Hooded Puffer Coat	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ff5bb1d40d76629132c1a4802a748e77.jpeg	2022-01-26 08:55:18.424653	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Amazon Essentials is focused on creating affordable, high-quality, and long-lasting everyday clothing you can rely on. Our line of men’s must-haves includes polo shirts, chino pants, classic-fit shorts, casual button-downs, and crew-neck tees. Our consistent sizing takes the guesswork out of shopping, and each piece is put to the test to maintain the highest standards in quality and comfort.	{Amazon}	Amazon		22	\N	t	\N	\N
b1f6dcba-a7c9-4ad0-813e-fe7cd2d8c149	Smart WiFi Light Bulbs, LED Color Changing Lights, Works with Alexa & Google Home, RGBW 2700K-6500K, 60 Watt Equivalent, Dimmable with App, A19 E26, No Hub Required, 2.4GHz WiFi (4 Pack)	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/7384d661d5f0a6b3462155909a59cde9.jpeg	2022-01-07 03:43:37.141314	2022-01-31 09:00:15.877975	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/1_7384d661d5f0a6b3462155909a59cde9.jpeg	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/2_7384d661d5f0a6b3462155909a59cde9.jpeg	8f2815df-fd83-44c6-9586-24ed947acf6e	3a661f4d-f630-437d-842c-ea9f9b9e7cca	1	{Bulb}	Firefly	Firefly	1.1	\N	t	\N	\N
b8fa70a4-d5ec-4523-9907-d5789b9f659a	Gildan Men's Fleece Zip Hooded Sweatshirt, Style G18600	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/b2e827505abd061b3726d376720b3c72.jpeg	2022-01-26 09:10:23.603174	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	Gildan is one of the world's largest vertically integrated manufacturers of apparel and socks. Gildan uses cotton grown in the USA, which represents the best combination of quality and value for Gildan cotton and cotton blended products. Since 2009, Gildan has proudly displayed the cotton USA mark, licensed by cotton council international, on consumer's product packaging and shipping materials. Gildan environmental program accomplishes two core objectives: reduce our environmental impact and preserve the natural Resources being used in our manufacturing process. At all operating levels, Gildan is aware of the fact that we operate as a part of a greater unit: the environment in which we live and work.	{Gildan}	Gildan		999	\N	t	\N	\N
6fa2804f-ee55-4f76-8551-26a468c3b546	DC DCSC Mens Jacket	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/9e49b3348381c4d41c13d099662e859a.jpeg	2022-01-27 03:00:22.768566	2022-01-31 09:00:15.877975	\N	\N	3d7cbbc5-69ea-452e-9de9-f2ecfbea305a	c1cfcbbf-2ec9-4966-8849-277852afa41a	dc	{dc}	dc		1	\N	t	\N	\N
\.


--
-- Data for Name: promo_editor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promo_editor (promo_id, text, type, title) FROM stdin;
20	BUY	promo1	\N
26	<p style="text-align:start;"><span style="color: rgb(173,132,31);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">Landsbe</span> <span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">is the place where you can tell sellers what you want, how much you want to pay and how long you are willing to wait.</span></p>\n<p style="text-align:start;"><span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">Not only that but you can also share your group with all your friends so that they can get a great deal too! Landsbe lets you organize your demand first so that everyone gets a great deal</span> <span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;"><strong>and pay nothing until your item ships.</strong></span></p>\n	promo1	\N
7	<p style="text-align:start;"><span style="color: rgb(173,132,31);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">Landsbe</span> <span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">is the place where you can tell sellers what you want, how much you want to pay and how long you are willing to wait.</span></p>\n<p style="text-align:start;"><span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;">Not only that but you can also share your group with all your friends so that they can get a great deal too! Landsbe lets you organize your demand first so that everyone gets a great deal</span> <span style="color: rgb(71,55,41);background-color: rgb(255,255,255);font-size: 1em;font-family: titillium web;"><strong>and pay nothing until your item ships.</strong></span></p>\n	promo	\N
4	MONEY	promo	\N
5	PLANET	promo	\N
6	COMMUNITY	promo	\N
3	SAVE	promo	\N
2	TOGETHER	promo	\N
1	BUY	promo	\N
8	Not only that but you can also share your group with all your friends so that they can get a great deal too! Landsbe lets you organize your demand first so that everyone gets a great deal.	promo	\N
9	HOW LANDSBE WORKS?	promo	\N
16	JUMP RIGHT IN!	promo	
17	Can't find group you want, then form a group of your own. Put in the name of the product you want and then provide a link to the specific product so we know which seller to start contacting on your group's behalf.	promo	
18	We contact many different sellers to make sure we get the group the best price possible. If you found a group with the product you want, join it! You can also follow the group and we will send you updates regarding that group.	promo	
19	TELL US WHAT YOU'RE INTERESTED IN	promo	
10	Enter product name	promo	\N
11	Set your price	promo	\N
12	 Landsbe will create the group for you!	promo	\N
13	Find group you like to join	promo	\N
14	Set your quantity	promo	
15	Wait until group fills up and complete the payment	promo	
21	TOGETHER	promo1	\N
22	SAVE	promo1	\N
23	MONEY	promo1	\N
24	PLANET	promo1	\N
25	COMMUNITY	promo1	\N
27	Not only that but you can also share your group with all your friends so that they can get a great deal too! Landsbe lets you organize your demand first so that everyone gets a great deal.	promo1	\N
28	HOW LANDSBE WORKS?	promo1	\N
32	Find group you like to join	promo1	\N
33	Set your quantity	promo1	\N
34	Wait until group fills up and complete the payment	promo1	\N
29	Enter product name	promo1	\N
30	Set your price	promo1	\N
31	Landsbe will create the group for you!	promo1	\N
35	JUMP RIGHT IN!	promo1	\N
\.


--
-- Data for Name: rejected_sellers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rejected_sellers (rs_id, reason, seller_obj) FROM stdin;
1		{"uuid":"826be7c9-b01e-4690-8cc3-e1dc75aadf85","first_name":"test","last_name":"user102","email":"user102@test.com","primary_address":null,"secondary_address":null,"google_id":null,"datetime_created":"2021-07-03T07:41:49.968Z","datetime_modified":"2021-09-20T07:56:33.409Z","user_image":null,"email_settings":"null","privacy_settings":"null","username":"user102","temp_password":null,"acc_status":true,"seller_id":"826be7c9-b01e-4690-8cc3-e1dc75aadf85","entity_name":"userample","ein":"2231232","business_experience":"2","product_to_sell":"any","platforms":"ama","product_fulfillment":"internally","status":"pending","margin_pct":null,"contact_name":"test user102","phone_number":"09843453423","seller_rating":null,"paypal_id":null,"stripe_id":null,"fulfillment_partner":null}
2	Fake seller	{"uuid":"3fb53321-ff41-4a66-9bba-1b6bc3464c1c","first_name":"seller2","last_name":"test","email":"sellertest2@gmail.com","primary_address":null,"secondary_address":null,"google_id":null,"datetime_created":"2022-01-06T16:12:46.000Z","datetime_modified":"2022-01-06T16:12:46.000Z","user_image":null,"email_settings":null,"privacy_settings":null,"username":"sellertest2","temp_password":null,"acc_status":true,"facebook_id":null,"seller_id":"3fb53321-ff41-4a66-9bba-1b6bc3464c1c","entity_name":"Deus ex machina","ein":"121231231","business_experience":"2 years","product_to_sell":"electronics","platforms":"amazon","product_fulfillment":"internally","status":"pending","margin_pct":null,"contact_name":"seller2 test","phone_number":"115655132514","seller_rating":null,"paypal_id":null,"stripe_id":null,"fulfillment_partner":null,"account_name":null,"account_number":null,"routing_number":null,"date_created":"2022-01-06T16:14:28.573Z"}
3	admin	{"uuid":"3a661f4d-f630-437d-842c-ea9f9b9e7cca","first_name":"Samuel","last_name":"Lopez","email":"samuel.lopez@boom.camp","primary_address":null,"secondary_address":null,"google_id":"105564339705509300138","datetime_created":"2021-02-03T09:00:02.885Z","datetime_modified":"2021-09-01T11:31:25.530Z","user_image":"https://lh3.googleusercontent.com/a-/AOh14GikYKGVog0bcRiqORnP_kbCIfZDrsFuKjIvj3pr=s96-c","email_settings":null,"privacy_settings":null,"username":"samuel.lopez","temp_password":null,"acc_status":true,"facebook_id":null,"seller_id":"3a661f4d-f630-437d-842c-ea9f9b9e7cca","entity_name":"asdasd","ein":"132-1312","business_experience":"0 to 5 years","product_to_sell":"asdasd","platforms":"asdasd","product_fulfillment":"internally","status":"pending","margin_pct":null,"contact_name":"Samuel Lopez","phone_number":"123123","seller_rating":null,"paypal_id":null,"stripe_id":null,"fulfillment_partner":null,"account_name":null,"account_number":null,"routing_number":null,"date_created":"2022-01-11T15:59:09.547Z"}
\.


--
-- Data for Name: seller_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seller_details (seller_id, entity_name, ein, business_experience, product_to_sell, platforms, product_fulfillment, status, margin_pct, contact_name, email, phone_number, seller_rating, paypal_id, stripe_id, fulfillment_partner, account_name, account_number, routing_number, date_created) FROM stdin;
c1cfcbbf-2ec9-4966-8849-277852afa41a	jomarstore	000000001	5 to 10 years	Electronics	Amazon	internally	approved	\N	Jomar Bandol	jomar2999@gmail.com	12519682957	\N	sb-o5erl4557610@personal.example.com	\N	Denver's Computer parts	test	11111	10000	2022-01-06 08:55:11.21071
46056b5e-3e3f-40ce-8477-8d3dcc19f006	mrsbee	1234565	1	etc	shopee	internally	approved	2	Wina Bernal	wina@boomsourcing.com	123456789	\N	\N	\N	\N	Test One	021000021	0258	2022-01-06 08:55:11.21071
4e42184e-d302-4f88-abcc-cdcb1ba1296a	Cheapid computer	2215464976	1 year	computer parts	ebay	outsourced	approved	\N	Pepe Sylvia	samuel15201818@gmail.com	51453456421	\N	\N	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
2e6dcdfa-1bdb-4783-a662-bdf988385fb8	Shoppee	1112323	2 years	electronics	amazon	outsourced	approved	\N	test er	tester@tester.com	445243216541	\N	\N	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
6d26f96b-3c4e-429a-a283-ac3ad5bdef15	ApeTotheMoon	156498653	2	Gaming Stuff	Amazon	internally	approved	\N	Jan Patrick Bañares	janpatrick.banares@boom.camp	3569985758	\N	sb-y47rbj6724445@personal.example.com	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
3a661f4d-f630-437d-842c-ea9f9b9e7cca	Test landsbe	11-2312323	0 to 5 years	Chips	Lazada	internally	pending	\N	Samuel Lopez	samuel.lopez@boom.camp	9454530184	\N	\N	\N	\N	\N	\N	\N	2022-03-14 09:00:14.487497
1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	Eric store	1213213313	2	Any	Lazada	outsourced	approved	\N	Sr Dev	test@gmail.com	12112121	\N	\N	acct_1JBEmy4K3PAjrThT	\N	\N	\N	\N	2022-01-06 08:55:11.21071
d6fd49ae-64ec-49e1-a077-f71ead6b954e	PC shop	0000000000	1 year	pc	amazon	internally	approved	\N	buyer 002	buyer002@test.com	0000000000	\N	\N	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
38694216-a4d0-4dd1-868f-46f507e7596b	scrumMX	21131	1	Scrum Stuff 	Amazon	internally	approved	\N	Rogelio Jimenez	rogelio@boomsourcing.com	3222921895	\N	\N	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
346f2048-dcd7-4c81-b22d-34326460f4ca	Jeff Christensen store	\N	\N	\N	\N	\N	approved	\N	Jeff Christensen	jeff@landsbe.com	\N	\N	\N	\N	\N	\N	\N	\N	2022-01-06 08:55:11.21071
f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	test buy store	\N	\N	\N	\N	\N	approved	\N	test buy	testbuy13@example.com	\N	\N	\N	\N	\N	\N	\N	\N	2022-01-11 08:38:25.275484
\.


--
-- Data for Name: seller_feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seller_feedback (seller_feedback_id, group_id, fname, lname, email, archived, description) FROM stdin;
\.


--
-- Data for Name: shipping_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_address (shipping_id, user_uuid, country, reciever_name, address, city, state, postal_code, phonenumber, primary_shipping_address, datetime_created, datetime_modified) FROM stdin;
a7d76f08-07d8-4656-95c3-e81da8ad5b9d	6d26f96b-3c4e-429a-a283-ac3ad5bdef15	US	asd	asd	asd	AL	456789	asd	f	2021-05-11 09:01:57.400928	2021-05-11 09:01:57.400928
b6c15972-6457-42c8-ae9b-bcb165580276	f25c3687-cc1e-4db7-8394-f5cbe29f6b8a	US	Test email	Lapu2x	legazpi	AS	4500	44753315451	f	2021-06-03 06:53:27.481371	2021-06-03 06:53:27.481371
a76b7227-4c47-4988-a505-beeed8f370b0	38694216-a4d0-4dd1-868f-46f507e7596b	MX	Amazon Basics Nylon Braided Lightning to USB A Cable, MFi Certified Apple iPhone Charger, Dark Gray, 6-Foot	heroes de la patria	puerto Vallarta	AK	48920	3222921895	f	2021-02-18 22:11:18.813837	2021-02-18 22:11:18.813837
75475e0d-d3a0-4ee9-8097-7657107b6f49	38694216-a4d0-4dd1-868f-46f507e7596b	US	Amazon Basics Nylon Braided Lightning to USB A Cable, MFi Certified Apple iPhone Charger, Dark Gray, 6-Foot	heroes de la patria	puerto Vallarta	ddd	48320	3222921895	f	2021-02-18 22:11:46.563182	2021-02-18 22:11:46.563182
1025199d-40c7-49a5-a0d3-d65d00c2ef49	c1cfcbbf-2ec9-4966-8849-277852afa41a	US	test	56 Marshall Street	Fayetteville	NC	4501	12519682957	t	2021-06-20 20:08:51.719	2021-06-17 09:35:13.267671
7987c3cd-144a-4b3f-af63-b19a1f308008	3a661f4d-f630-437d-842c-ea9f9b9e7cca	US	Samuel 	Lapu 2x	Legazpi	AL	48021	4521511154	f	2021-04-27 15:07:42.628	2021-06-10 09:11:14.899421
124fc3cf-5cea-4dce-8326-565a9a176b62	45fa681c-7e82-480e-ba3f-a44445beb2d8	US	Rogelio Jimenez	privada parota 101	Puerto Vallarta	Utah	84054	3222921895	f	2021-09-30 21:33:45.914462	2021-09-30 21:33:45.914462
1c60420a-4d3c-435c-b41d-e8da82d2c12a	38694216-a4d0-4dd1-868f-46f507e7596b	MX	Amazon Basics Nylon Braided Lightning to USB A Cable, MFi Certified Apple iPhone Charger, Dark Gray, 6-Foot	heroes de la patria	puerto Vallarta	UT	84054	3222921895	t	2021-05-28 09:35:44.501	2021-06-10 21:36:45.9274
cbea4c7c-9461-4ba5-ac4d-8650785bd8d8	1c1e07c5-5f6c-4d6d-b334-2034520618f6	US	gfg	fgfg	fgfg	NY	gf	5646	f	2021-04-12 08:04:35.081301	2021-04-12 08:04:35.081301
149ae05b-8844-47b9-b20b-f9fa173289cb	5dc4fab6-d7f6-43e3-b4e0-caafc3e0971c	US	asdkjakj	lapu2x	akjsdkajkdajk	IA	asdadasd	123uy1uihjsAJdka	f	2021-04-12 08:27:23.985645	2021-04-12 08:27:23.985645
a8a30bbb-0918-485a-b6eb-9cc0df2330b6	c1cfcbbf-2ec9-4966-8849-277852afa41a	US	Jomar Bandol	3054  Joyce Street	Gulf Shores	AL	36542	2519682957	f	2021-04-14 01:31:36.624065	2021-04-14 01:31:36.624065
7cabf475-7d3f-4217-b21b-7acda7c30b23	62998a0d-077b-41c2-acad-9aa5e301ab4f	US	test	200 Bell Pl Ste D 	Woodstock 	GA	30188	12345678901	f	2021-10-18 12:27:18.865	2021-10-18 06:28:09.903756
df50f2d8-9eae-4862-b37d-e2703be6c6de	c5ea053a-d64f-4f29-9c3f-626efa873eda	US	James Spencer Cahoon	548 Canyon View Circle	North Salt Lake	UT	84054	14254176862	f	2021-04-23 04:57:37.684029	2021-04-23 04:57:37.684029
087aefb1-63e5-4ae0-b4af-dae1f4a3151e	1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	US	Raymond Nasol	Lapu2x	Legazpi	AL	35004	09123456789	f	2021-06-21 18:28:15.668	2021-06-21 06:34:16.994068
ccef8517-8620-42ae-b25a-bbb9b0016d4a	5dc4fab6-d7f6-43e3-b4e0-caafc3e0971c	US	Christopher V Dickerson	3878  Elk Rd Little 	Tucson	AZ	85714	+639471939751	f	2021-04-12 14:29:24.095	2021-07-05 05:31:22.997357
a29eff58-8315-41b2-8e9e-495f89204021	6a22158b-1e05-44a1-a2ca-6c81da35a008	US	Sandra R Jacobs	2604 O Conner Street	POWNAL	ME	04069	313-769-5376	f	2021-07-08 14:29:39.98	2021-07-08 08:31:42.520251
9823a43f-2b6c-4925-9558-0aa706188fdc	78d9414c-edcb-4aab-873c-456ee606e859	US	Raymond Nasol	3902  Kenwood Place	Orlando	FL	32801	954-555-8609	t	2021-02-24 13:29:48.532	2021-07-12 03:37:16.177161
6001a740-ede0-4f14-896f-5d7ad574fa4c	78d9414c-edcb-4aab-873c-456ee606e859	PH	Eric Nasol	Lapu2x 23	Legazpi City	Albay	36691	+6399999921	f	2021-02-21 04:55:14.385	2021-07-12 03:37:21.246193
cf681ffb-8cfb-483e-ac82-bf563d66d0c9	2e6dcdfa-1bdb-4783-a662-bdf988385fb8	US	Raymond Nasol	4986  Hiddenview Drive	Warrensville Heights	OH	44128	216-215-8201	t	2021-07-05 12:08:51.813	2021-08-02 07:58:03.042476
328047e2-4a94-49e4-9f43-cfa881825325	cbae9bc0-b44f-4e49-8a0a-bff3c8bd159e	US	Utah	heroes de la patria	puerto Vallarta	UT	84070	3222921895	f	2021-08-20 03:35:28.039	2021-08-19 21:35:41.249081
b3f196be-1ad3-40d8-9ff8-00068ccad694	ce73e9ea-e4cd-47a4-a67e-f5a7f9eb11a4	US	Raftel	Grand Line	New World	IL	62914	123456	f	2021-04-29 15:18:57.374	2021-08-24 06:24:28.93174
e5d80992-46e8-4f91-8ec5-d9504d9fd80c	61b4e07d-9c97-4b0b-b4d7-f0e0c690083b	US	test	2381 Fort Street	Buxton	NC	27920	336-205-5590	f	2021-08-26 03:47:43.593257	2021-08-26 03:47:43.593257
02d692d9-2283-4ac8-bf6d-bfbbd679a1d3	304dc8e4-f277-425e-bec0-50430f85c662	US	Pauline I Sher	1061 Lonely Oak Drive	WAINSCOTT	NY	11975	917-884-8689	f	2021-08-27 05:37:44.614731	2021-08-27 05:37:44.614731
47d42692-1917-4d97-9d25-6948612322bd	826be7c9-b01e-4690-8cc3-e1dc75aadf85	US	test1	45 Wentworth Street	Bergenfield	NJ	07621	12519682957	f	2021-07-05 12:26:22.656	2021-09-16 06:38:59.190374
292d74ff-1e8f-4ac2-9ad9-50bb51eefcdc	a5c5171b-1331-474a-82f7-2876fb3843a1	US	test	3125 Don Jackson Lane	Buffalo	GU	30188	810-327-2659	f	2021-12-21 08:39:39.037205	2021-12-21 08:39:39.037205
788be66b-6ec8-47a5-a549-9313bee7b24a	46056b5e-3e3f-40ce-8477-8d3dcc19f006	US	Wina	288 Bell Place, Suite D	Woodstock	GA	30188	8887774444	f	2021-12-22 06:06:18.646513	2021-12-22 06:06:18.646513
32fb23c5-046a-43dd-84b1-6a45bd1f94aa	e498f885-498f-4a95-afa0-9370f4a6a866	US	test	45 Wentworth Street	Bergenfield	HI	71079	12519682957	f	2022-01-02 19:48:55.133	2022-03-09 03:15:51.141465
e933ef6b-bdca-4c19-b1ab-ecc1cdf9dd39	f25c3687-cc1e-4db7-8394-f5cbe29f6b8a	US	213213	123213	12312	AR	21201	3123123	t	2021-11-08 14:02:38.285478	2021-11-08 14:02:38.285478
02f4d637-e81e-42c3-84df-3fb7d8983193	3dec9e82-dda9-4ecf-9cd8-e8300aa7846d	US	Test	Test	Legazpi	FL	21201	4234234	t	2021-11-10 06:48:13.814	2021-11-09 16:48:51.836057
2ed6a796-8d5b-46de-b94e-b8e8b8d3b322	6ef390e4-2fd3-4266-aaa6-54dca52a334a	US	Alex Test	288 Bell Place, Suite D	Woodstock	GA	30000	8887774444	t	2022-03-03 09:49:51.511186	2022-03-03 09:49:51.511186
\.


--
-- Data for Name: site_feedbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_feedbacks (feedback_id, feedback_type, description, fname, lname, email, archived, action_taken) FROM stdin;
3	suggestion	Aliqua excepteur laboris enim labore minim aute Lorem\n                    occaecat. Deserunt culpa velit qui pariatur adipisicing laboris ullamco. Lorem\n                    duis consequat ullamco qui voluptate tempor adipisicing consectetur officia esse\n                    commodo in do. Do est veniam ut cillum magna fugiat adipisicing eiusmod\n                    reprehenderit qui duis. In commodo duis pariatur non aliqua cillum enim proident\n                    aliquip ex est mollit eu id. Velit qui anim ut ad ex ullamco ex eiusmod duis\n                    culpa do irure consequat Lorem. Fugiat sunt non labore quis eu adipisicing\n                    cupidatat qui est non nisi nostrud Lorem consectetur.	John Ely	Nayvz	john@ely.camp	t	\N
6	suggestion	Great	Sam	Sam	samuel152018@gmail.com	f	\N
7	comment	Thanks!	Test 	test	samuel152018@gmail.com	f	\N
8	comment	Awesome	jan	patrick	example@example.com	f	\N
9	comment	Hello pat test!	KEANU ELY GILBERT	MANLY	deve@zoom.com	t	\N
5	question	What is your name?	Jhooon	Doee	Jhooon@doe.com	t	\N
1	suggestion	Test	Test 	test	test@test.com	t	email
4	comment	Great comment	test	test	test@example.com	t	email
2	comment	Great	KEANU	MANLY	deve@zoom.com	t	\N
11	comment	test	Jomar	Bandol	jomar.bandol@boom.camp	f	\N
12	comment	Test test	KEANU ELY GILBERT	Matatag	bs538a@lab.icc.edu	f	\N
13	comment	sample	landsbe	devs	samuel.lopezx@asd.com	f	\N
14	suggestion	asdad	test	trest	deve112@zoom.com	f	\N
15	comment	asdasd	Samuel	asdasd	deve@zoom.com	f	\N
16	comment	asdasd	asd	asd	deve@zoom.com	f	\N
17	comment	asdasd	asd	asdasd	deve@zoom.com	f	\N
18	comment	asd	asdas	dsadasd	deve@zoom.com	f	\N
19	comment	asdasd	Samuel	test	deve@zoom.com	f	\N
20	comment	Great	test	test	test@example.com	f	\N
21	comment	test	test	test	deve@zoom.com	f	\N
22	suggestion	teste	Test 	Matatag	deve@zoom.com	f	\N
23	comment	test2	test2	test	deve@zoom.com	f	\N
24	suggestion	Test suggestion	Test	Test	deve@zoom.com	f	\N
25	comment	asdasd	asda	asdasd	bs538a@lab.icc.edu	f	\N
26	suggestion	asdasd	test	test	deve@zoom.com	f	\N
27	suggestion	asdad	asdasd	dasda	dasdasd	f	\N
28	question	asdasd	asd	dsadasd	asdas	f	\N
29	comment	asdsad	Samuel	asdasd	deve@zoom.com	f	\N
30	comment	asda	asd	asd	adsa	f	\N
31	comment	asdasd	asda	sdas	deve@zoom.com	f	\N
32	comment	asd	asd	asd	deve@zoom.com	f	\N
33	suggestion	asd	dsa	asdasd	deve@zoom.com	f	\N
34	comment	asda	sad	asdas	asd	f	\N
35	comment	asdasd	asdasd	asd	deve@zoom.com	f	\N
36	suggestion	asd	asd	asd	deve@zoom.com	f	\N
37	question	123test	asdasd	test	deve@zoom.com	f	\N
38	question	test123123test	asd	test	bs538a@lab.icc.edu	f	\N
39	suggestion	test456	sa	sa	bs538a@lab.icc.edu	f	\N
10	comment	good deals	wina	bernal	wina@boomsourcing.com	t	\N
\.


--
-- Data for Name: tax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax (tax_uuid, state, zip_code, tax_rate, datetime_created, datetime_modified) FROM stdin;
7f0c2965-a1a8-4763-9470-8d96e87d8956	NJ	07621	6.63	2021-06-14 08:20:57.986957	2021-06-14 08:20:57.986957
1c91c2a5-78ce-440d-a06c-b866cc9c758d	NY	10598	4	2021-06-14 08:22:01.014251	2021-06-14 08:22:01.014251
f40e78f0-aee6-4f10-8be7-8120f6a7a70e	AL	35209	4	2021-06-14 08:22:29.054678	2021-06-14 08:22:29.054678
ed1c6685-00ee-4fe2-9033-b621734851b5	PA	16101	6	2021-06-14 08:23:08.379432	2021-06-14 08:23:08.379432
00fccc30-259e-453c-9e6b-c0e8199865e8	WI	54701	5	2021-06-14 08:23:49.095801	2021-06-14 08:23:49.095801
bb77b55d-66ab-46c3-a20b-0e87186990ad	CT	06770	6.35	2021-06-14 08:24:18.438348	2021-06-14 08:24:18.438348
0bd7b1ce-a00a-4e5a-a415-74eacbfdb1a1	SC	29730	6	2021-06-14 08:25:02.729071	2021-06-14 08:25:02.729071
2eeeea06-7f7a-4b55-88ae-2b86c909f284	FL	32806	6	2021-06-14 08:25:29.176163	2021-06-14 08:25:29.176163
d9017d1f-d22c-4475-beda-15a185e74447	NC	27012	4.75	2021-06-14 08:26:14.767743	2021-06-14 08:26:14.767743
a853ad4a-4f26-46a3-b277-bbd7592e5f1d	NH	03060	0.1	2021-06-14 08:26:40.603109	2021-06-14 09:02:06.186125
14a55f4c-6608-4c62-b002-5872b9eb7c85	NC	28303	4.75	2021-06-14 08:10:23.34168	2021-06-14 09:09:28.416115
271e7616-e458-4a72-ab9c-27994926b290	AL	36542	4.1	2021-06-14 08:10:05.840755	2021-06-15 02:05:22.365047
a30d13d6-0128-4ef8-834c-9d554db54f6a	UT	84054	4.85	2021-06-17 18:05:25.824506	2021-06-17 18:05:25.824506
9987713c-0fd2-4ba5-a003-6f752b712a6f	Albay	36695	4	2021-06-21 02:04:12.95008	2021-06-21 02:04:12.95008
aeb84a90-ca4c-45c9-b64f-b1ac3ab4da42	NJ	49441	6	2021-06-21 08:36:14.458598	2021-06-21 08:36:14.458598
a8fb1a91-7458-4e6e-a796-05e6cbeec8df	AL	35004	4	2021-06-21 08:37:44.23124	2021-06-21 08:37:44.23124
0537ea2c-0df2-4c7a-8daa-140fa03dcb02	FL	32801	6	2021-06-25 01:51:26.679989	2021-06-25 01:51:26.679989
e67641e6-69c7-4f6e-8ca2-63401598e892	AZ	85714	5.6	2021-07-05 05:31:28.759641	2021-07-05 05:31:28.759641
fd3a23fc-4c42-4f45-8e61-5281fd170d54	OH	44128	5.75	2021-07-05 06:08:58.599679	2021-07-05 06:08:58.599679
7c569c9d-2cd2-42b9-901d-e0e689d46cde	ME	04069	5.5	2021-07-08 08:31:49.264375	2021-07-08 08:31:49.264375
7b5dbcd5-de80-49e3-bd8c-5b08f0afc811	UT	84070	4.85	2021-08-19 21:35:45.442409	2021-08-19 21:35:45.442409
d5f8fb2c-763a-4025-a33f-26264ad2844f	IL	62914	6.25	2021-08-24 06:24:33.124127	2021-08-24 06:24:33.124127
c7f17ded-e13b-4d50-917c-4f5024779714	NC	27920	4.75	2021-08-26 03:47:47.682351	2021-08-26 03:47:47.682351
3cd39c6c-83a7-440d-8fdd-029123af8422	NY	11975	4	2021-08-27 05:37:49.984781	2021-08-27 05:37:49.984781
96e5eb2e-dba7-4668-a47f-831dd4752150	GA	30188	4	2021-10-18 06:28:32.341319	2021-10-18 06:28:32.341319
b76216d1-5d3f-48a5-bbcf-d3e598be1d3d	TX	77070	6.25	2021-10-21 05:07:44.307182	2021-10-21 05:07:44.307182
bbc0b154-30ec-4151-8cdc-d7a3be00c997	NE	51640	6	2021-10-21 08:14:21.682881	2021-10-21 08:14:21.682881
e3b9bca7-6f04-4b8e-8063-56615cb907df	AR	21201	6	2021-11-08 14:06:19.899297	2021-11-08 14:06:19.899297
ba1945f6-025f-4a45-ad53-4910f411cc5b	HI	71079	8.08	2021-12-23 06:16:43.451884	2021-12-23 06:16:43.451884
b9155fa6-2e2e-4c4e-9aa5-cfd4d2c448de	HI	50447	7	2021-12-23 06:29:38.2458	2021-12-23 06:29:38.2458
b3a8049c-66f4-4abe-bd58-31cdfd9d9470	HI	71079	8.08	2022-02-11 03:48:15.081787	2022-02-11 03:48:15.081787
e81acc00-0da7-4ab5-a0f1-0a0429a2af5c	HI	71079	8.08	2022-02-14 08:00:38.492849	2022-02-14 08:00:38.492849
a4ceb4b8-746a-40e3-94f4-811fd1f00cfb	HI	71079	8.08	2022-02-14 08:08:51.461877	2022-02-14 08:08:51.461877
070816b8-4365-43de-ab14-fe3d88fbfc89	HI	71079	8.08	2022-03-01 03:18:46.390163	2022-03-01 03:18:46.390163
308cae97-1670-4f34-8d44-1b4336154224	HI	71079	8.08	2022-03-01 03:22:09.500494	2022-03-01 03:22:09.500494
f98173e9-4a46-44a9-95f1-327340e3f3ab	HI	71079	8.08	2022-03-01 03:26:08.015114	2022-03-01 03:26:08.015114
3e84c051-d137-4548-9af2-59c80c774e50	HI	71079	8.08	2022-03-01 03:29:08.234661	2022-03-01 03:29:08.234661
5e7ffe4f-6bc7-4fa7-9baa-b061a62e0afa	HI	71079	8.08	2022-03-01 03:29:11.90467	2022-03-01 03:29:11.90467
5f207f31-a257-4e27-87bc-19f50d128839	AL	48021	6	2022-02-15 16:08:11.132	2022-03-07 06:36:32.958722
5f207f31-a257-4e27-87bc-19f50d128839	AL	48021	6	2022-02-15 16:08:11.132	2022-03-07 06:36:32.958722
5f207f31-a257-4e27-87bc-19f50d128839	AL	48021	6	2022-02-15 16:08:11.132	2022-03-07 06:36:32.958722
5f207f31-a257-4e27-87bc-19f50d128839	AL	48021	6	2022-02-15 16:08:11.132	2022-03-07 06:36:32.958722
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, user_id, group_id, payment_type, status, ref_id, shipping_address_id, tracking_number, qty, tax_rate, date_created, ship_date, shipping_method, date_delivered, buyer_notes, size_variant, capture_status) FROM stdin;
f13654ec-a81a-41ea-b041-e896297ce189	e498f885-498f-4a95-afa0-9370f4a6a866	1302dab3-b1b9-4ae8-b546-f9ec9b27ca48		unpaid	\N	\N	\N	1	\N	2022-03-01 08:55:30.394465	\N	\N	\N	\N	\N	\N
568a0f80-de0e-4a5c-ad4b-734ef5345f28	e498f885-498f-4a95-afa0-9370f4a6a866	ec5cd42f-0370-4cfb-8eb7-2206522415ac	paypal	unpaid	9B517969S80207642	32fb23c5-046a-43dd-84b1-6a45bd1f94aa	\N	\N	8.08	2022-02-09 06:07:32.663211	\N	\N	\N	\N	\N	\N
6896dbb3-3d14-4c11-b220-2ad5ed9f3dbc	e498f885-498f-4a95-afa0-9370f4a6a866	9a398999-4cb9-4f15-a411-1ebd5bc21eff		unpaid	\N	\N	\N	1	\N	2022-02-10 09:48:13.913344	\N	\N	\N	\N	\N	\N
445f4129-82ca-4b86-beef-8a6291ea6357	3a661f4d-f630-437d-842c-ea9f9b9e7cca	9a398999-4cb9-4f15-a411-1ebd5bc21eff		unpaid	\N	\N	\N	1	\N	2022-02-15 02:44:46.322646	\N	\N	\N	\N	\N	\N
c4d71af6-2714-4b47-a588-b508553ded4e	3a661f4d-f630-437d-842c-ea9f9b9e7cca	6418c466-d98d-46de-a265-e198d654729f		unpaid	\N	\N	\N	1	\N	2022-02-18 09:51:07.117669	\N	\N	\N	\N	\N	\N
024bc42e-7a73-4362-846d-c88641f90a26	e498f885-498f-4a95-afa0-9370f4a6a866	bb63e9ba-0156-46bf-84a6-d72e0d874503		unpaid	\N	\N	\N	1	\N	2022-02-23 06:15:06.480941	\N	\N	\N	\N	\N	\N
d0df71bf-daff-4331-96c5-973e819b7997	8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	606ed0f4-9106-49c4-9efb-b0a49e098bba		unpaid	\N	\N	\N	1	\N	2022-02-23 08:17:51.318228	\N	\N	\N	\N	\N	\N
3eadc4bc-726d-42f2-bab3-6bc173680540	3a661f4d-f630-437d-842c-ea9f9b9e7cca	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d		unpaid	\N	\N	\N	1	\N	2022-03-08 08:50:53.231719	\N	\N	\N	\N	\N	\N
04448bda-8924-41d4-9e7c-8861b14c02f8	e498f885-498f-4a95-afa0-9370f4a6a866	d977f086-9d97-48df-a1c7-4de273da77bc	card	complete	ch_3KbG0HKbGvoZpoL90P4EO4nQ	32fb23c5-046a-43dd-84b1-6a45bd1f94aa	test5444544	1	8.08	2022-03-09 03:14:00.975434	2022-03-09 00:00:00		\N	test	\N	\N
4adc5fd6-250c-4a0a-adc2-96e7d340e007	e498f885-498f-4a95-afa0-9370f4a6a866	daeaf235-ad9f-4bcb-901f-15f6af6e1904		unpaid	\N	\N	\N	1	\N	2022-03-09 08:18:13.416261	\N	\N	\N	\N	\N	\N
d64825e6-01a1-44a4-8402-eec3b3abb70b	bf9c540e-60b9-406c-a82a-c1859adf5d7d	7aac7a92-5376-484d-8fe9-a786e477f6a9		unpaid	\N	\N	\N	1	\N	2022-03-09 09:03:17.483147	\N	\N	\N	\N	\N	\N
535de4ee-8693-4aa1-b17c-0ce72c1ddf04	e498f885-498f-4a95-afa0-9370f4a6a866	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-03-14 08:07:49.797188	\N	\N	\N	\N	\N	\N
20de0fd4-904d-4b91-837a-d53f72d2a413	6ef390e4-2fd3-4266-aaa6-54dca52a334a	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-03-14 08:21:44.153891	\N	\N	\N	\N	\N	\N
804437da-fca5-46e9-be22-e70d67e230d6	46056b5e-3e3f-40ce-8477-8d3dcc19f006	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d		unpaid	\N	\N	\N	1	\N	2022-03-15 05:38:17.551883	\N	\N	\N	\N	\N	\N
ba99423e-43cf-4b8d-bd8e-bbf3e228f7bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-03-17 08:47:54.202499	\N	\N	\N	\N	\N	\N
3ad69bb5-767b-4b2e-8740-008dde4a18bc	e498f885-498f-4a95-afa0-9370f4a6a866	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d		unpaid	\N	\N	\N	1	\N	2022-03-18 09:39:03.625239	\N	\N	\N	\N	\N	\N
9e798a14-4411-4ef2-9103-e6de0eb9b2fd	e498f885-498f-4a95-afa0-9370f4a6a866	7aac7a92-5376-484d-8fe9-a786e477f6a9		unpaid	\N	\N	\N	1	\N	2022-02-24 04:27:46.126967	\N	\N	\N	\N	\N	\N
178a5154-8182-45d8-bb7b-36b524d332f5	968f0310-c811-4737-93bc-895610a8a7e3	7aac7a92-5376-484d-8fe9-a786e477f6a9		unpaid	\N	\N	\N	1	\N	2022-02-24 06:45:20.201031	\N	\N	\N	\N	\N	\N
605feca7-ed6c-43fb-b2ab-fc93f14a9a07	968f0310-c811-4737-93bc-895610a8a7e3	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-02-24 07:08:55.06758	\N	\N	\N	\N	\N	\N
d7eba180-0d2d-470c-9ccb-540eae966644	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-02-28 02:30:52.823835	\N	\N	\N	\N	\N	\N
82e8da8d-d885-4d22-bf4e-fcfce8308b0a	46056b5e-3e3f-40ce-8477-8d3dcc19f006	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-03-01 01:27:17.202462	\N	\N	\N	\N	\N	\N
dfef9a99-c1d9-47e0-959b-aed767e84613	46056b5e-3e3f-40ce-8477-8d3dcc19f006	7934d13e-087a-4831-85cb-c8a163a67bfb		unpaid	\N	\N	\N	1	\N	2022-03-02 07:50:32.675163	\N	\N	\N	\N	\N	\N
181c3be7-3064-4f32-b289-708c1cd624f6	e498f885-498f-4a95-afa0-9370f4a6a866	ac93d3c3-3628-4014-b0c7-12a68629ce30		unpaid	\N	\N	\N	1	\N	2022-03-03 06:08:49.130256	\N	\N	\N	\N	\N	\N
6eb6f859-3fb1-4e18-86e0-6b6ff6ec3403	e498f885-498f-4a95-afa0-9370f4a6a866	58d841e3-cd1c-433a-a239-924ea22d0b7d		unpaid	\N	\N	\N	1	\N	2022-03-03 08:49:47.474619	\N	\N	\N	\N	\N	\N
b250c705-3cd6-4f2b-92bc-77975698f891	6ef390e4-2fd3-4266-aaa6-54dca52a334a	7aac7a92-5376-484d-8fe9-a786e477f6a9		unpaid	\N	\N	\N	1	\N	2022-03-07 03:27:11.165826	\N	\N	\N	\N	\N	\N
1fc5acc0-5f83-4bca-ad63-806d31eab086	e498f885-498f-4a95-afa0-9370f4a6a866	6418c466-d98d-46de-a265-e198d654729f	card	paid	ch_3KaZzXKbGvoZpoL90Eirou3N	32fb23c5-046a-43dd-84b1-6a45bd1f94aa	\N	2	8.08	2022-02-21 09:44:39.327641	\N	\N	\N	\N	\N	\N
aa6b6da8-bdad-4c62-8c03-753a962c3ca7	bf9c540e-60b9-406c-a82a-c1859adf5d7d	894a997f-eb11-4dec-982a-f0066c64323d		unpaid	\N	\N	\N	1	\N	2022-03-09 08:29:24.702259	\N	\N	\N	\N	\N	\N
ccc3eb35-76f9-4158-9bb8-102836b0396e	2e09fd10-807f-4b82-8722-c27d2c280b0d	72b8ee43-cf44-464a-ad5f-496a9396a3ab		unpaid	\N	\N	\N	1	\N	2022-03-15 02:34:17.178962	\N	\N	\N	\N	\N	\N
c38a5926-4d5d-4c0e-9288-1e28845dfee3	e498f885-498f-4a95-afa0-9370f4a6a866	f6a2c267-ec63-4acc-b6ab-22274c80ef21		unpaid	\N	\N	\N	1	\N	2022-03-17 05:11:05.347743	\N	\N	\N	\N	\N	\N
eb30768f-7e4b-4c03-8958-674b3c292bb4	e498f885-498f-4a95-afa0-9370f4a6a866	894a997f-eb11-4dec-982a-f0066c64323d		unpaid	\N	\N	\N	1	\N	2022-03-17 08:55:06.091395	\N	\N	\N	\N	\N	\N
ca048164-c232-415e-a363-eec43e95bbad	79b69f8f-c2a8-45f0-aad7-7932b462a3af	79ee2231-bdb5-4e63-bd03-0b8b09f8b53a		unpaid	\N	\N	\N	1	\N	2022-04-27 09:04:22.107269	\N	\N	\N	\N	\N	\N
1ad1e383-18ea-400d-acb7-661423b83196	e498f885-498f-4a95-afa0-9370f4a6a866	ff3ec288-119f-4acc-8355-e55ada7e49f1		unpaid	\N	\N	\N	1	\N	2022-05-02 08:23:16.312218	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: user_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_activity (id, group_id, user_id, action, description, date_and_time, reason) FROM stdin;
1	ffeab45a-6598-4ea9-ab66-f8669e6789bc	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2021-12-02 23:26:29.189	Not interested in the product
2	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 22:17:26.297	Other
3	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 22:22:43.852	Other
4	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 22:24:56.753	Not interested in the product
5	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 22:25:42.634	Other
6	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 22:27:48.099	\N
7	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 23:00:55.52	Not interested in the product
8	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-05 23:20:31.941	Not interested in the product
9	39ed0dd2-5583-410b-ab87-f1b94ac7e864	a5c5171b-1331-474a-82f7-2876fb3843a1	leave group	\N	2021-12-05 23:40:30.035	I didn't like the price
10	22851185-d78b-47b0-8ebb-eff9d2c81686	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-06 01:54:03.072	Not interested in the product
11	39ed0dd2-5583-410b-ab87-f1b94ac7e864	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-06 19:59:59.87	I didn't like the price
12	20083f02-7ea1-40f5-9770-c2ce95aa1f3f	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2021-12-10 02:14:45.274	Not interested in the product
13	ffeab45a-6598-4ea9-ab66-f8669e6789bc	46056b5e-3e3f-40ce-8477-8d3dcc19f006	leave group	\N	2021-12-21 23:03:54.626	Not specified.
14	7246040a-c6cd-4ade-9e66-1ab3862a41d7	46056b5e-3e3f-40ce-8477-8d3dcc19f006	leave group	\N	2021-12-21 23:04:31.032	Not interested in the product
15	60873237-4c79-43bb-aa03-dd2dfb6ad55a	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2021-12-23 00:44:52.261	Not interested in the product
16	60873237-4c79-43bb-aa03-dd2dfb6ad55a	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-05 00:49:10.554	Not interested in the product
17	7246040a-c6cd-4ade-9e66-1ab3862a41d7	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-05 00:49:47.868	Not interested in the product
18	7246040a-c6cd-4ade-9e66-1ab3862a41d7	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-07 01:05:54.111	Not interested in the product
19	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-10 00:37:07.107	Not interested in the product
20	60181685-b4b7-4bab-b0a3-431648ea5fb9	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-01-19 02:35:31.51	Not interested in the product
21	60181685-b4b7-4bab-b0a3-431648ea5fb9	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-01-19 02:39:04.72	Not interested in the product
22	60181685-b4b7-4bab-b0a3-431648ea5fb9	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-01-19 02:41:41.027	Not interested in the product
23	60181685-b4b7-4bab-b0a3-431648ea5fb9	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-01-19 22:09:23.263	Not interested in the product
24	60873237-4c79-43bb-aa03-dd2dfb6ad55a	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-20 18:31:35.639	Not interested in the product
25	72b8ee43-cf44-464a-ad5f-496a9396a3ab	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-01-23 19:27:19.97	Not interested in the product
26	60873237-4c79-43bb-aa03-dd2dfb6ad55a	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 22:21:26.976	Not interested in the product
27	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 23:03:29.784	Not interested in the product
28	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 23:06:14.262	Not interested in the product
29	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 23:06:31.093	Not interested in the product
30	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 23:07:22.506	Not interested in the product
31	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-26 23:23:26.814	Not interested in the product
32	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 00:58:51.55	Not interested in the product
33	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 01:09:06.129	Not interested in the product
34	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 19:52:11.286	Not interested in the product
35	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 20:05:59.634	Not interested in the product
36	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 20:06:32.012	Not interested in the product
37	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-01-27 20:30:57.34	Not interested in the product
38	7f84baf0-db8d-42b9-a4f7-efd64a99223b	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-02 23:53:36.043	Not interested in the product
39	7f84baf0-db8d-42b9-a4f7-efd64a99223b	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 01:13:57.968	Not interested in the product
40	60181685-b4b7-4bab-b0a3-431648ea5fb9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 18:43:49.02	Not interested in the product
41	60181685-b4b7-4bab-b0a3-431648ea5fb9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 18:49:41.541	Not interested in the product
42	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 20:39:31.533	Not interested in the product
43	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 20:41:01.018	Not interested in the product
44	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 22:10:58.083	Not interested in the product
45	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 22:21:04.188	Not interested in the product
46	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 22:40:07.01	Not interested in the product
47	ec5cd42f-0370-4cfb-8eb7-2206522415ac	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-07 22:43:02.743	Not interested in the product
48	7f84baf0-db8d-42b9-a4f7-efd64a99223b	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-08 20:16:30.94	Not interested in the product
49	9a398999-4cb9-4f15-a411-1ebd5bc21eff	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-14 19:40:46.077	Not interested in the product
50	9a398999-4cb9-4f15-a411-1ebd5bc21eff	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-14 19:44:43.433	Not interested in the product
51	9130646e-92e8-4a5e-aaae-89f740856bc8	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-14 19:48:58.288	Not interested in the product
52	9130646e-92e8-4a5e-aaae-89f740856bc8	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-14 19:49:09.678	Not interested in the product
53	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-14 22:56:29.396	Not interested in the product
54	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-14 22:56:45.019	Not interested in the product
55	9130646e-92e8-4a5e-aaae-89f740856bc8	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-14 23:05:31.505	Not interested in the product
56	9130646e-92e8-4a5e-aaae-89f740856bc8	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-15 00:40:19.327	Not interested in the product
57	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-16 23:42:46.811	Not interested in the product
58	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-16 23:44:52.361	Not interested in the product
59	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-16 23:45:48.99	Not interested in the product
60	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-16 23:46:40.995	Not interested in the product
61	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-17 00:36:24.072	Not interested in the product
62	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-17 00:50:25.128	Not interested in the product
63	8f7c1af8-dcac-422e-b7ba-5ee6726e386d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-17 00:51:14.487	Not interested in the product
64	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 02:50:09.603	Not interested in the product
65	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 02:53:16.428	Not interested in the product
66	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 02:57:19.874	Not interested in the product
67	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 02:57:33.196	Not interested in the product
68	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 02:57:43.157	Not interested in the product
69	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-17 03:00:51.228	Not interested in the product
70	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-17 20:58:25.319	Not interested in the product
71	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-18 01:41:39.841	Not interested in the product
72	d977f086-9d97-48df-a1c7-4de273da77bc	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-18 01:42:06.592	Not interested in the product
73	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-18 02:40:21.346	Not interested in the product
74	6418c466-d98d-46de-a265-e198d654729f	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-02-18 02:51:03.734	Not interested in the product
75	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 19:52:46.086	Not interested in the product
76	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:39:30.055	Not interested in the product
77	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:44:38.698	Not interested in the product
78	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:45:17.533	Not interested in the product
79	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:46:42.221	Not interested in the product
80	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:47:18.781	Not interested in the product
81	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:56:45.566	Not interested in the product
82	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 22:58:17.421	Not interested in the product
83	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-22 23:01:39.554	Not interested in the product
84	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 02:55:19.627	Not interested in the product
85	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 02:55:39.374	Not interested in the product
86	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 17:38:10.401	Not interested in the product
87	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 17:44:04.894	Not interested in the product
88	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 18:33:41.085	Not interested in the product
89	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 19:49:57.957	Not interested in the product
90	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 19:50:34.513	Not interested in the product
91	7aac7a92-5376-484d-8fe9-a786e477f6a9	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 19:55:24.822	Not interested in the product
92	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 21:17:59.769	Not interested in the product
93	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 21:18:19.655	Not interested in the product
94	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 21:18:55.019	Not interested in the product
95	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 21:19:19.132	Not interested in the product
96	9130646e-92e8-4a5e-aaae-89f740856bc8	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-23 21:20:40.953	Not interested in the product
97	72b8ee43-cf44-464a-ad5f-496a9396a3ab	968f0310-c811-4737-93bc-895610a8a7e3	leave group	\N	2022-02-24 00:08:43.191	Not interested in the product
98	72b8ee43-cf44-464a-ad5f-496a9396a3ab	d700c16c-9d4e-4f86-b3fd-59c55f994fb7	leave group	\N	2022-02-27 19:30:46.691	Not interested in the product
99	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 02:14:28.798	Not interested in the product
100	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 02:15:00.567	Not interested in the product
101	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:17:56.094	Not interested in the product
102	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:18:57.519	Not interested in the product
103	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:20:02.394	Not interested in the product
104	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:23:18.734	Not interested in the product
105	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:24:37.598	Not interested in the product
106	72b8ee43-cf44-464a-ad5f-496a9396a3ab	46056b5e-3e3f-40ce-8477-8d3dcc19f006	leave group	\N	2022-02-28 18:26:39.635	Not interested in the product
107	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:48:26.404	Not interested in the product
108	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:49:43.414	Not interested in the product
109	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:51:14.733	Not interested in the product
110	d977f086-9d97-48df-a1c7-4de273da77bc	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-02-28 18:51:37.379	Not interested in the product
112	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-01 20:40:50.598	Not interested in the product
113	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:38:46.975	Not interested in the product
114	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:39:39.27	Not interested in the product
115	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:43:19.619	Not interested in the product
116	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:44:01.772	Not interested in the product
117	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:55:55.321	Not interested in the product
118	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 19:56:08.641	Not interested in the product
119	7aac7a92-5376-484d-8fe9-a786e477f6a9	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-06 20:00:01.318	Not interested in the product
120	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-07 22:14:31.31	Not interested in the product
121	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 00:43:44.149	Not interested in the product
122	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 02:34:27.899	Not interested in the product
123	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 02:35:11.339	Not interested in the product
124	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 19:09:50.096	Not interested in the product
125	606ed0f4-9106-49c4-9efb-b0a49e098bba	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 20:13:31.143	Not interested in the product
126	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-08 22:43:42.794	Not interested in the product
127	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-09 18:35:21.111	Not interested in the product
128	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-09 18:35:45.062	Not interested in the product
129	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-10 02:26:32.518	Not interested in the product
130	72b8ee43-cf44-464a-ad5f-496a9396a3ab	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-14 02:07:43.242	Not interested in the product
131	72b8ee43-cf44-464a-ad5f-496a9396a3ab	6ef390e4-2fd3-4266-aaa6-54dca52a334a	leave group	\N	2022-03-14 02:21:40.722	Not interested in the product
132	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	46056b5e-3e3f-40ce-8477-8d3dcc19f006	leave group	\N	2022-03-14 23:38:08.153	Not interested in the product
133	72b8ee43-cf44-464a-ad5f-496a9396a3ab	3a661f4d-f630-437d-842c-ea9f9b9e7cca	leave group	\N	2022-03-17 02:47:50.622	Not interested in the product
134	1639f1fe-f3f5-4d7a-a19b-490f9f0c2d3d	e498f885-498f-4a95-afa0-9370f4a6a866	leave group	\N	2022-03-18 03:38:59.082	Not interested in the product
135	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 02:23:55.714	Not interested in the product
136	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 02:24:16.797	Not interested in the product
137	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 03:22:35.572	Not interested in the product
138	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 03:35:16.028	Not interested in the product
139	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 03:37:01.307	Not interested in the product
140	72b8ee43-cf44-464a-ad5f-496a9396a3ab	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	leave group	\N	2022-04-28 03:48:16.432	Not interested in the product
141	72b8ee43-cf44-464a-ad5f-496a9396a3ab	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-04-29 01:35:24.001	Not interested in the product
142	72b8ee43-cf44-464a-ad5f-496a9396a3ab	826be7c9-b01e-4690-8cc3-e1dc75aadf85	leave group	\N	2022-04-29 01:36:02.589	Not interested in the product
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, supplier, admin, super_user, datetime_created, datetime_modified) FROM stdin;
968f0310-c811-4737-93bc-895610a8a7e3	f	f	f	2022-02-24 04:33:39.952081	2022-02-24 04:33:39.952081
c071dbd8-2c9c-4211-b082-ed790de0522b	t	f	f	2021-06-16 07:40:05.182281	2021-06-16 07:42:16.573458
d58f874e-ab30-4908-a181-add5a92e563b	f	f	f	2022-02-25 04:44:18.719598	2022-02-25 04:44:18.719598
910cf7c1-f8a9-4333-9335-02ee55a84a68	f	f	f	2022-02-25 04:50:26.019717	2022-02-25 04:50:26.019717
d700c16c-9d4e-4f86-b3fd-59c55f994fb7	f	f	f	2022-02-28 02:28:55.675307	2022-02-28 02:28:55.675307
304dc8e4-f277-425e-bec0-50430f85c662	f	f	f	2021-03-11 14:21:48.368503	2021-10-22 08:18:16.495828
c5ea053a-d64f-4f29-9c3f-626efa873eda	f	f	t	2021-03-25 22:23:34.340914	2021-03-25 22:34:47.962351
12823c4d-8fc9-4419-8551-10b29a0ab513	f	f	f	2022-02-28 07:47:48.978366	2022-02-28 07:47:48.978366
346f2048-dcd7-4c81-b22d-34326460f4ca	f	f	t	2021-11-02 17:54:30.383006	2021-11-02 17:54:57.465881
253b08ad-4f12-49ee-9098-650d62cdb866	f	f	f	2021-02-24 09:09:03.540676	2021-11-05 05:46:00.935218
3dec9e82-dda9-4ecf-9cd8-e8300aa7846d	f	f	f	2021-11-09 16:47:23.97524	2021-11-09 16:47:23.97524
c1cfcbbf-2ec9-4966-8849-277852afa41a	t	f	f	2021-04-08 05:40:07.951275	2021-07-05 02:52:11.864024
a5c5171b-1331-474a-82f7-2876fb3843a1	f	f	f	2021-11-23 05:45:09.394266	2021-11-23 05:45:09.394266
1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	t	f	f	2021-04-28 05:18:49.562052	2021-07-05 08:03:32.535023
5dc4fab6-d7f6-43e3-b4e0-caafc3e0971c	f	f	f	2021-03-11 13:57:53.573962	2021-07-08 02:49:57.566915
6d26f96b-3c4e-429a-a283-ac3ad5bdef15	t	f	f	2021-01-28 09:33:05.982681	2021-07-08 08:36:33.80856
4e42184e-d302-4f88-abcc-cdcb1ba1296a	t	f	f	2021-06-30 09:21:30.86667	2021-07-08 21:13:53.10398
81a5258c-6d0c-4067-8eb8-502189932224	f	f	f	2021-07-10 02:05:06.792087	2021-07-10 02:05:06.792087
b5783601-679c-41a2-a32d-f46678f01b43	f	f	f	2021-07-13 01:28:52.438364	2021-07-13 01:28:52.438364
cf2434f6-3248-4a68-b035-9269a30fc880	f	f	f	2021-12-01 09:39:45.137922	2021-12-01 09:39:45.137922
dff6529e-c8bc-4cc1-bf3f-1c377155fa49	f	f	f	2021-12-03 08:55:00.687343	2021-12-03 08:55:00.687343
d298f448-7e96-4324-9b19-35a408861c8b	f	f	f	2021-01-28 08:16:21.000333	2021-07-15 09:52:22.350241
c8af8c22-b265-4aed-984c-c3fbf3e736ed	f	f	f	2021-07-19 20:42:26.223785	2021-07-19 20:42:26.223785
566bf97d-79a1-493c-84c9-028c3d095c33	f	f	f	2021-07-21 01:28:03.694692	2021-07-21 01:28:03.694692
cbae9bc0-b44f-4e49-8a0a-bff3c8bd159e	f	f	f	2021-07-22 21:30:40.311588	2021-07-22 21:30:40.311588
fae2b509-47c3-48c1-be0a-c1207f962196	f	f	f	2021-07-27 06:40:52.992747	2021-07-27 06:40:52.992747
d2860210-8f2f-49ff-8a9b-e4d63e385d79	f	f	f	2021-03-11 14:01:09.30425	2021-03-11 14:01:09.30425
b4e70256-d7b6-4ed6-8d05-0b18b2e88ba2	f	f	f	2021-03-11 14:13:37.395851	2021-03-11 14:13:37.395851
f1b7f4f3-7138-4a7e-a14d-e9eee5c71e90	f	f	f	2021-03-11 14:16:06.696895	2021-03-11 14:16:06.696895
6a22158b-1e05-44a1-a2ca-6c81da35a008	f	f	f	2021-03-11 14:31:29.271351	2021-03-11 14:31:29.271351
c4463fb2-06f3-42cd-9934-991eb72f6eba	f	f	f	2021-03-11 14:32:39.71962	2021-03-11 14:32:39.71962
b73e8e65-8099-43a0-a32d-07484be61320	f	f	f	2021-03-11 14:33:33.243183	2021-03-11 14:33:33.243183
de70ff51-5084-413e-919d-050a432921fe	f	f	f	2021-03-11 14:34:58.406434	2021-03-11 14:34:58.406434
02b04890-110b-466e-bd2a-bd751250b820	f	f	f	2021-03-11 15:46:58.250203	2021-03-11 15:46:58.250203
456ea1ca-b7d1-4a58-8abd-c0622e78179a	f	f	f	2021-04-12 07:52:08.040767	2021-04-12 07:52:08.040767
62273c54-08a8-4d51-8356-a9619a2bc757	f	f	f	2021-04-12 07:52:09.588547	2021-04-12 07:52:09.588547
37606679-8dd0-4de8-8d92-a09bd951cf9c	f	f	f	2021-04-12 07:55:05.469344	2021-04-12 07:55:05.469344
1c1e07c5-5f6c-4d6d-b334-2034520618f6	f	f	f	2021-04-12 07:55:16.645975	2021-04-12 07:55:16.645975
98be6f5a-8796-4272-a055-5fc7ba77a38b	f	f	f	2021-04-12 07:56:11.40539	2021-04-12 07:56:11.40539
61b4e07d-9c97-4b0b-b4d7-f0e0c690083b	f	f	f	2021-08-26 02:08:01.826163	2021-08-26 02:08:01.826163
f1b6f7c0-2820-4c00-91a3-51fd35894f3b	f	f	f	2021-04-12 08:51:26.930112	2021-04-12 08:51:26.930112
178bfbb8-9cc9-4728-8871-a7ee8a80ece1	f	f	t	2021-04-07 15:22:53.828541	2021-04-14 23:04:06.579814
78d9414c-edcb-4aab-873c-456ee606e859	f	f	t	2021-02-03 05:49:22.143768	2021-03-12 02:35:38.632926
38694216-a4d0-4dd1-868f-46f507e7596b	f	f	t	2021-01-28 15:58:04.899597	2021-08-26 21:26:29.278037
2e6dcdfa-1bdb-4783-a662-bdf988385fb8	t	f	f	2021-07-05 05:34:21.353142	2021-08-31 03:08:30.504039
71c6bbaf-4c0d-431c-bcde-086a94b74cf2	f	f	f	2022-03-31 02:08:34.154529	2022-03-31 02:08:34.154529
8d48076e-4645-4537-b3b3-32fd88e3e6ae	f	f	f	2021-03-12 03:29:20.656205	2021-03-12 03:29:20.656205
54f22543-a586-4790-b29f-452415a90c38	f	f	f	2022-01-05 08:14:02.324032	2022-01-05 08:14:02.324032
501155dd-1910-40f9-a2c5-9730ab3170e6	f	f	t	2021-01-28 09:30:27.915535	2021-04-19 06:39:20.478784
a186f925-d72f-4507-a4e3-c68dfc74818a	f	f	f	2021-04-19 22:47:55.698844	2021-04-19 22:47:55.698844
cb37bc4a-d2df-484e-82c4-0d609683c547	f	f	f	2021-04-22 08:06:12.653292	2021-04-22 08:06:12.653292
e6b0ae5c-9b15-4eb4-a883-e3618c263912	f	f	f	2021-05-02 15:54:27.545846	2021-05-02 15:54:27.545846
ce73e9ea-e4cd-47a4-a67e-f5a7f9eb11a4	f	f	t	2021-01-28 09:33:34.667583	2021-03-16 12:58:49.061555
04c7936b-24ef-4495-a190-7850f7bf640f	f	f	f	2021-09-10 22:46:33.538836	2021-09-10 22:46:33.538836
3fb53321-ff41-4a66-9bba-1b6bc3464c1c	f	f	f	2022-01-06 09:12:46.007075	2022-01-06 09:12:46.007075
f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	t	f	f	2021-11-23 05:50:32.189681	2022-01-11 08:38:25.26022
f3f139e9-f6ef-4eef-8792-edc5010def66	f	f	f	2021-09-14 05:56:32.106365	2021-09-14 05:56:32.106365
e498f885-498f-4a95-afa0-9370f4a6a866	f	f	t	2021-01-28 09:30:32.269961	2021-05-07 06:25:41.903702
826be7c9-b01e-4690-8cc3-e1dc75aadf85	f	f	f	2021-07-01 07:41:49.975575	2022-01-19 09:09:15.42768
72d0082b-57bd-460c-820b-9515fe9634ba	f	f	f	2022-01-21 05:05:30.28181	2022-01-21 05:05:30.28181
f20649e9-d1d3-4db0-b702-db57cdb6e33c	f	f	t	2021-01-28 22:27:22.513011	2021-03-18 21:14:38.085372
d9acb795-6487-4e77-b232-159e32e02edc	f	f	f	2021-03-19 12:51:49.291725	2021-03-19 12:51:49.291725
f25c3687-cc1e-4db7-8394-f5cbe29f6b8a	f	f	f	2021-05-24 08:54:34.844696	2021-05-24 08:54:34.844696
5b65b8eb-a76d-4081-82bb-d4a7207caee5	f	f	f	2021-10-15 02:07:17.027584	2021-10-15 02:07:17.027584
3b98720c-905e-4ba0-b27a-b8f563bcec2b	f	f	f	2022-02-15 05:58:09.171447	2022-02-15 05:58:09.171447
55b527a3-24db-4321-ba78-2bbecb1c7dfa	f	f	f	2021-05-27 05:35:56.96814	2021-05-27 05:35:56.96814
cdd145d0-06e7-4856-8e05-612e8d5f4aa9	f	f	f	2021-10-15 02:37:08.8893	2021-10-15 02:37:08.8893
0b91be7b-a0e4-46e3-a27f-6a20901785d1	f	f	f	2022-02-23 07:40:18.528177	2022-02-23 07:40:18.528177
b4ad0ef9-f6e8-4c6b-9955-7821453f1faf	f	f	f	2022-02-23 07:45:54.198603	2022-02-23 07:45:54.198603
f7c3a660-dd54-4abf-b153-f08d404c5e82	f	f	f	2021-06-07 18:02:13.73938	2021-06-07 18:02:13.73938
45fa681c-7e82-480e-ba3f-a44445beb2d8	f	f	t	2021-01-28 15:58:46.261846	2021-06-10 21:52:39.426796
534c5afd-865c-44be-8ac2-99959af0daa9	f	f	f	2021-03-11 13:22:27.210684	2021-06-16 05:37:17.683617
d6fd49ae-64ec-49e1-a077-f71ead6b954e	t	f	f	2021-10-15 02:18:30.45019	2021-10-15 06:37:00.196746
3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	f	t	2021-02-03 02:00:02.92694	2021-06-16 05:37:24.214444
79f5a3a5-5774-4184-806e-079e0a4398a9	f	f	f	2022-02-23 07:47:44.276527	2022-02-23 07:47:44.276527
777e0670-291f-4660-b71c-c65c8e05a264	f	f	f	2022-02-23 07:54:19.890401	2022-02-23 07:54:19.890401
46056b5e-3e3f-40ce-8477-8d3dcc19f006	f	f	t	2021-03-12 01:42:48.644913	2021-10-18 05:39:12.463337
bf59ffe1-5782-48e5-9416-6147aed232fd	f	f	f	2022-02-23 07:57:01.942987	2022-02-23 07:57:01.942987
62998a0d-077b-41c2-acad-9aa5e301ab4f	f	f	f	2021-10-18 06:19:22.273478	2021-10-18 06:19:22.273478
2dcc57b5-0538-4025-99ea-b04724481f21	f	f	f	2021-10-19 06:00:21.772069	2021-10-19 06:00:21.772069
ef562ed6-1679-49c2-b9b0-46d05910fc53	f	f	f	2021-10-21 02:25:17.921493	2021-10-21 02:25:17.921493
15329586-0822-433a-a72f-6777256a0c94	f	f	f	2022-02-23 08:02:26.860722	2022-02-23 08:02:26.860722
fc2dbeb7-d474-47f6-97d4-ea3b6d15c985	f	f	f	2022-02-23 08:12:07.878741	2022-02-23 08:12:07.878741
8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	f	f	f	2022-02-23 08:16:51.016554	2022-02-23 08:16:51.016554
8e069970-9b1c-4b95-859f-d9726fd80d97	f	f	f	2022-02-28 08:23:49.859507	2022-02-28 08:23:49.859507
2a061ec4-08f9-4c31-81ac-13d247328221	f	f	f	2022-02-23 10:00:38.917064	2022-02-23 10:00:38.917064
90eca2ab-8bea-45b4-ab87-42ec580c9b3b	f	f	f	2022-02-23 10:03:10.616961	2022-02-23 10:03:10.616961
80dfa440-cbb8-4f55-9642-a586a9306163	f	f	f	2022-02-24 01:14:10.169269	2022-02-24 01:14:10.169269
b2bcf4f3-e507-436a-a24d-07d8db297a80	f	f	f	2022-02-28 09:23:49.012314	2022-02-28 09:23:49.012314
92f29b2a-4865-4f05-9b56-5ccd8235ea55	f	f	f	2022-02-28 09:33:38.052751	2022-02-28 09:33:38.052751
f85cbf25-c34b-44aa-b9e9-8abbecf0ea15	f	f	f	2022-02-28 09:34:43.792406	2022-02-28 09:34:43.792406
6ef390e4-2fd3-4266-aaa6-54dca52a334a	f	f	f	2022-03-03 09:48:13.311237	2022-03-03 09:48:13.311237
bf9c540e-60b9-406c-a82a-c1859adf5d7d	f	f	f	2022-03-04 09:00:01.992327	2022-03-04 09:00:01.992327
bccbb60e-a754-4ce9-b002-8fbaed3986b2	f	f	f	2022-03-31 03:16:09.625299	2022-03-31 03:16:09.625299
c34c5ab9-1033-469b-9096-4ec9133a28f4	f	f	f	2021-06-16 05:52:04.455013	2022-03-07 06:26:39.511515
c2f2bfe5-cb5c-4418-a16a-7705a782b8d7	f	f	f	2022-03-07 06:22:37.486948	2022-03-07 06:30:13.33225
2e09fd10-807f-4b82-8722-c27d2c280b0d	f	f	f	2022-03-11 05:33:00.9706	2022-03-11 05:33:00.9706
e7a1d853-083c-44ca-939e-f5a6c663151e	f	f	f	2022-03-11 05:36:37.292312	2022-03-11 05:36:37.292312
4e6b01c7-2e22-495a-ac45-dbfb1265ec87	f	f	f	2022-03-11 05:42:21.970197	2022-03-11 05:42:21.970197
dba74431-a1c3-4baa-8b10-d050b8a6a90b	f	f	f	2022-03-11 05:49:09.514726	2022-03-11 05:49:09.514726
3a80067d-5a89-445c-b016-3cc20e586964	f	f	f	2022-03-31 06:12:10.305568	2022-03-31 06:12:10.305568
2c0edf20-6a25-4693-91b6-195f7c55738c	f	f	f	2022-04-08 18:34:37.137632	2022-04-08 18:34:37.137632
014f5284-99fa-493f-bfae-6a2900b23ec5	f	f	f	2022-04-27 05:08:58.321413	2022-04-27 05:08:58.321413
093de4bb-71a5-4eaf-9f4b-aae69c3fc355	f	f	f	2022-04-27 05:12:35.397352	2022-04-27 05:12:35.397352
47b1979e-50f9-45aa-880a-34b76ccd8f4d	f	f	f	2022-04-27 05:14:17.92178	2022-04-27 05:14:17.92178
79b69f8f-c2a8-45f0-aad7-7932b462a3af	f	f	f	2022-04-27 06:24:34.037276	2022-04-27 06:24:34.037276
1fe14ebc-ff2a-4366-b1e7-7a15ddfc3857	f	f	f	2022-04-27 07:34:24.695855	2022-04-27 07:34:24.695855
b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	f	f	f	2022-04-28 01:28:21.041135	2022-04-28 01:28:21.041135
0b8a6598-6626-41ac-af7f-9f9bc766807b	f	f	f	2022-04-28 09:35:05.370834	2022-04-28 09:35:05.370834
3f0f211d-17e0-4669-9ada-c44c92cd6c55	f	f	f	2022-04-28 09:41:22.829914	2022-04-28 09:41:22.829914
92696082-3259-4e90-8e7d-58c198051056	f	f	f	2022-04-29 01:32:42.020182	2022-04-29 01:32:42.020182
59f15176-edc5-4e0f-a0ea-2d787647ccbc	f	f	f	2022-05-03 02:33:26.766704	2022-05-03 02:33:26.766704
\.


--
-- Data for Name: user_subscription; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_subscription (user_id, new_group, followed_group, related_group, request_group_updated, recommended_group, joined_group, group_requested, group_ending) FROM stdin;
3a661f4d-f630-437d-842c-ea9f9b9e7cca	f	f	f	f	f	f	f	f
78d9414c-edcb-4aab-873c-456ee606e859	f	f	f	f	f	f	f	f
\.


--
-- Data for Name: userpaymentinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userpaymentinfo (paymentinfo_id, user_id, type, details, datetime_created, datetime_modified, stripe_customer_id) FROM stdin;
41267a54-472e-4b39-8722-54abf7ee8ea1	8e069970-9b1c-4b95-859f-d9726fd80d97	card	{"id":"card_1KY4WfKbGvoZpoL9VHggYngE","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":2,"exp_year":2023,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-02-28 01:24:14.483	2022-02-28 01:24:14.483	cus_LEXby5zCKA8iF4
24499784-c7fe-41d2-9510-b5b1d0d50039	3a661f4d-f630-437d-842c-ea9f9b9e7cca	card	{"id":"card_1KY5HMKbGvoZpoL9zSq6lXRl","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-02-28 02:12:30.718	2022-02-28 02:12:30.718	cus_LEYOt2j31Jvpeu
1a9b4918-e01c-4540-9d8b-7b9702d7b62d	e498f885-498f-4a95-afa0-9370f4a6a866	card	{"id":"card_1KY5HRKbGvoZpoL9JDq77HpW","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-02-28 02:12:34.731	2022-02-28 02:12:34.731	cus_LEYOceZeRt22l1
2afcff8a-51a2-4235-b2b3-2a75f225da64	92f29b2a-4865-4f05-9b56-5ccd8235ea55	card	{"id":"card_1KY5c9KbGvoZpoL9ixnArkaR","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-02-28 02:33:59.205	2022-02-28 02:33:59.205	cus_LEYjHvMXdDemaj
9b43ced1-09f2-4c25-82c5-d91bcbefe5d4	f85cbf25-c34b-44aa-b9e9-8abbecf0ea15	card	{"id":"card_1KY5dCKbGvoZpoL9VO2QBMug","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-02-28 02:35:03.458	2022-02-28 02:35:03.458	cus_LEYkj3oF3wUDwj
47eaec33-190a-4efc-84ea-9d10bf9671f5	e498f885-498f-4a95-afa0-9370f4a6a866	card	{"id":"card_1KYPNTKbGvoZpoL91JDX7VGo","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"FR","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"3155","name":null,"tokenization_method":null}	2022-02-28 23:40:08.408	2022-02-28 23:40:08.408	cus_LEt9gQvHa8tWqh
a1671f21-5051-45f1-97f6-3d4fc8517d16	e498f885-498f-4a95-afa0-9370f4a6a866	card	{"id":"card_1KYQIJKbGvoZpoL9eFlbDVD6","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":2,"exp_year":2042,"funding":"credit","last4":"0341","name":null,"tokenization_method":null}	2022-03-01 00:38:52.655	2022-03-01 00:38:52.655	cus_LEu6ecA2xwMtSL
f21a8d5c-068e-48f1-b5a6-6a37356715c0	e498f885-498f-4a95-afa0-9370f4a6a866	card	{"id":"card_1KYQO0KbGvoZpoL9LsQ73B8j","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"MasterCard","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"prepaid","last4":"5100","name":null,"tokenization_method":null}	2022-03-01 00:44:47.757	2022-03-01 00:44:47.757	cus_LEuCCYVa4FtQh0
99eadbd6-9f71-4f46-ac5a-94f9bc997b1e	46056b5e-3e3f-40ce-8477-8d3dcc19f006	card	{"id":"card_1KYSHIKbGvoZpoL9yweMrfrl","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-03-01 02:45:58.475	2022-03-01 02:45:58.475	cus_LEw9Bqzgt4qCos
bc6554a2-5846-44b5-b0d7-200fe26fc19f	6ef390e4-2fd3-4266-aaa6-54dca52a334a	card	{"id":"card_1KaXE1KbGvoZpoL97HjwC6Mt","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-03-06 20:27:10.893	2022-03-06 20:27:10.893	cus_LH5OHZzfcYAMx1
3c8fecff-3cde-4c17-adcc-9d779de03270	c2f2bfe5-cb5c-4418-a16a-7705a782b8d7	card	{"id":"card_1KaZyGKbGvoZpoL95xjH3R72","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2025,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-03-06 23:23:05.39	2022-03-06 23:23:05.39	cus_LH8E77QO9h5fJw
0a265db1-41f6-4f6e-9c85-5a3f14aa8b71	bf9c540e-60b9-406c-a82a-c1859adf5d7d	card	{"id":"card_1KbLQNKbGvoZpoL9znP6c1QE","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-03-09 02:03:17.222	2022-03-09 02:03:17.222	cus_LHvGQScRTfrST5
9271b936-ecb4-4adb-96a5-5892832f91e8	2e09fd10-807f-4b82-8722-c27d2c280b0d	card	{"id":"card_1KdQDDKbGvoZpoL9nlGAS6UE","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-03-14 20:34:16.82	2022-03-14 20:34:16.82	cus_LK4L78hzVQKjF7
b5639816-b8da-410a-aceb-c7cd8b055190	79b69f8f-c2a8-45f0-aad7-7932b462a3af	card	{"id":"card_1Kt6MXKbGvoZpoL9thAFwOuo","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":2,"exp_year":2042,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-04-27 08:36:44.993	2022-04-27 08:36:44.993	cus_LaGuot0QYJqNbl
7f653431-147f-465c-a1d9-7db266d7a4bb	b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	card	{"id":"card_1KtMBVKbGvoZpoL9AvijW8RM","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":4,"exp_year":2024,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-04-28 01:30:23.565	2022-04-28 01:30:23.565	cus_LaXGejQUNG8eJW
a94f3694-57a0-4d62-850a-1103dc5a0000	826be7c9-b01e-4690-8cc3-e1dc75aadf85	card	{"id":"card_1KtijQKbGvoZpoL9HI4xtMjH","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","cvc_check":"unchecked","dynamic_last4":null,"exp_month":2,"exp_year":2042,"funding":"credit","last4":"4242","name":null,"tokenization_method":null}	2022-04-29 01:34:54.679	2022-04-29 01:34:54.679	cus_LauYbGj4nj7bU3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (uuid, first_name, last_name, password, email, primary_address, secondary_address, google_id, datetime_created, datetime_modified, user_image, email_settings, privacy_settings, username, temp_password, acc_status, facebook_id) FROM stdin;
777e0670-291f-4660-b71c-c65c8e05a264	asd3	asd3	$argon2i$v=19$m=4096,t=3,p=1$hUgSjjgVTEfm9bx2J0pK1A$/yO/zl0o/PEMEJPMqBTPcuRd+4Hj9917JqwnuneE3lE	asd3@test.com	\N	\N	\N	2022-02-23 07:54:19.882202	2022-02-23 07:54:19.882202	\N	\N	\N	asd3	\N	t	\N
fc2dbeb7-d474-47f6-97d4-ea3b6d15c985	asd6	asd6	$argon2i$v=19$m=4096,t=3,p=1$ubL+Zou/Yt+JlsNMoTPWdA$mzxFV/Ibaup+bR9krwFavaSYqKL0YjYseWc/oRXcQRc	asd6@test.com	\N	\N	\N	2022-02-23 08:12:07.870559	2022-02-23 08:12:07.870559	\N	\N	\N	asd6	\N	t	\N
c071dbd8-2c9c-4211-b082-ed790de0522b	seller	admin	$argon2i$v=19$m=4096,t=3,p=1$4wAF/VOOoGp8OxKNWq/vhg$pOx14DDBYSdBAuFuzUR+uyYa/RcmRRE8wG0YUr/9Z9U	seller_admin@test.com	\N	\N	\N	2021-06-16 07:40:05.176765	2021-09-01 05:51:40.432236	\N	\N	\N	seller_admin	\N	t	\N
5b65b8eb-a76d-4081-82bb-d4a7207caee5	buyer	001	$argon2i$v=19$m=4096,t=3,p=1$PQjwrGcSoKUOUi3DQ3IZng$3EBksMEDIiPm9HvDwf8d8U5KPvyY++zzBJ/oHJNCqZI	buyer001@test.com	\N	\N	\N	2021-10-15 02:07:17.007831	2021-10-15 02:07:17.007831	\N	\N	\N	buyer001	\N	\N	\N
62998a0d-077b-41c2-acad-9aa5e301ab4f	Weena	Bernal	$argon2i$v=19$m=4096,t=3,p=1$20sdwgDnTGiXdeuSe5Jh6Q$avjlo61YQLcRU/DqPQO6lSiso0vFdfYztwMTrFPCogc	weenamuri@gmail.com	\N	\N	\N	2021-10-18 06:19:22.265076	2021-10-18 06:19:22.265076	\N	\N	\N	weenamuri	\N	t	\N
346f2048-dcd7-4c81-b22d-34326460f4ca	Jeff	Christensen	$argon2i$v=19$m=4096,t=3,p=1$43JlpzXsyJWU2lSu1859wQ$sxxoBilpK1q9+Xk8LOfdpa7iXJhjv0lrQSi5vRIcGSA	jeff@landsbe.com	\N	\N	\N	2021-11-02 17:54:30.375254	2021-11-02 17:54:30.375254	\N	\N	\N	jeff@landsbe.com	\N	t	\N
3dec9e82-dda9-4ecf-9cd8-e8300aa7846d	jules	one	$argon2i$v=19$m=4096,t=3,p=1$k7LzOpmjVWknB0ySH2HXEA$vS3IW/EkrUA/EDRun87hfPNyimWkBerD71+uMhcTyB0	jules1@gmail.com	\N	\N	\N	2021-11-09 16:47:23.964373	2021-11-09 16:47:23.964373	\N	\N	\N	jules1	\N	t	\N
dff6529e-c8bc-4cc1-bf3f-1c377155fa49	Raymond	Nasol	\N	brotherjules123@gmail.com	\N	\N	\N	2021-12-03 08:55:00.676374	2021-12-03 08:55:00.676374	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3106558512920460&height=50&width=50&ext=1641113700&hash=AeS_aTTYuXTi0fUag_Q	{"new_group":true,"followed_group":true,"related_group":true,"requested_group":true,"recommended_group":true,"joined_group":true,"group_you_requested":true,"group_ending_soon":true}	{"show_my_profile":true,"show_my_comments":true}	\N	\N	t	3106558512920460
3b98720c-905e-4ba0-b27a-b8f563bcec2b	buyer	103	$argon2i$v=19$m=4096,t=3,p=1$x5+eUAW9Q4Ekgp5hdoirag$WwPbri5KLWhCPrFWHdReX329xWyfDXpbFAiyBQLTHlM	buyer103@example.com	\N	\N	\N	2022-02-15 05:58:09.162716	2022-02-15 05:58:09.162716	\N	\N	\N	buyer103	\N	t	\N
c2f2bfe5-cb5c-4418-a16a-7705a782b8d7	jhon kean	band	$argon2i$v=19$m=4096,t=3,p=1$CuZSiW9CJLfu+EMRc+0mmg$aprxK3EDo+MfHv7DOwisymzEGEJp/Xm6t6GFJexwif8	jhonkeanband@yandex.com	\N	\N	\N	2022-03-07 06:22:37.479079	2022-03-07 06:29:35.317134	\N	\N	\N	jhonkeanband	\N	t	\N
968f0310-c811-4737-93bc-895610a8a7e3	user11	user11	$argon2i$v=19$m=4096,t=3,p=1$Y27El8Yw4fDu/TPJc3nA0Q$bBXG70cQrODtZPWuulYMn29diOBovA4lITvv38GZzn4	user11@mail.com	\N	\N	\N	2022-02-24 04:33:39.943998	2022-02-24 04:33:39.943998	\N	\N	\N	user11	\N	t	\N
2e09fd10-807f-4b82-8722-c27d2c280b0d	testinv	testinv	$argon2i$v=19$m=4096,t=3,p=1$TtuzUpJxCA6dbuceh/72Zw$Z5XrbbqdA9J2HlRP9YTFy+ynJUWMf8/v1WF00KI1DzU	testinv@mail.com	\N	\N	\N	2022-03-11 05:33:00.961603	2022-03-11 05:33:00.961603	\N	\N	\N	testinv	\N	t	\N
910cf7c1-f8a9-4333-9335-02ee55a84a68	seller1	seller1	$argon2i$v=19$m=4096,t=3,p=1$6ZGIEBqfD3j0N9AA862nlQ$KwSKrVr/2z07bnJvG1sGdDSLhzbWUCnFBd57d1M9JUs	seller1@mail.com	\N	\N	\N	2022-02-25 04:50:26.014546	2022-02-25 04:50:26.014546	\N	\N	\N	seller1	\N	t	\N
2c0edf20-6a25-4693-91b6-195f7c55738c	testing000	testing000	$argon2i$v=19$m=4096,t=3,p=1$aPArcbIo/l3lnVn+FyEtNw$8t5WZO7cM5SxeBRhzGE82ZGXGqO7WxszlRK1tVRWWuE	testing000@mail.com	\N	\N	\N	2022-04-08 18:34:37.127622	2022-04-08 18:34:37.127622	\N	\N	\N	testing000	\N	t	\N
f85cbf25-c34b-44aa-b9e9-8abbecf0ea15	testbug2	testbug2	$argon2i$v=19$m=4096,t=3,p=1$8Bes3w4/PjwtPKLuJhmMuw$JlH6pG58yiphtNcC2M1ZVLL6tIt4WPIgmiuD6TYIYss	testbug2@mail.com	\N	\N	\N	2022-02-28 09:34:43.785664	2022-02-28 09:34:43.785664	\N	\N	\N	testbug2	\N	t	\N
3a661f4d-f630-437d-842c-ea9f9b9e7cca	Samuel	Lopez	$argon2i$v=19$m=4096,t=3,p=1$C6sUle8U35+Ioxl31b5b7Q$8OJL7Q/eqpdw1D3B0GE0PkPxYXYIEkA41fpA/JBp4O8	samuel.lopez@boom.camp	\N	\N	105564339705509300138	2021-02-03 02:00:02.885905	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14GikYKGVog0bcRiqORnP_kbCIfZDrsFuKjIvj3pr=s96-c	\N	\N	samuel.lopez	\N	t	\N
45fa681c-7e82-480e-ba3f-a44445beb2d8	Rogelio	Jimenez	$argon2i$v=19$m=4096,t=3,p=1$2TkeZ3Q+Wod2c1W/gWdh+Q$NnpGc/Hg+Eut7BGfow3ednnE/9NzAdO2YtcyQT16Djs	rjmultimedia@gmail.com	\N	\N	110949791156280832939	2021-01-28 15:58:46.251843	2021-09-01 05:31:25.530633	\N	\N	\N	rogeliopersonal	\N	t	\N
253b08ad-4f12-49ee-9098-650d62cdb866	Samuel	Lopez	$argon2i$v=19$m=4096,t=3,p=1$O1IVX8cNpzQluMA28OOyfg$XaEQODTGwyWsA/KT5Nzmo/lG7u+PHAGLbMcfqYu2yp8	samuel152018@gmail.com	\N	\N	112940675650009639625	2021-02-24 09:09:03.53466	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14GhdEewuaQylx8cI-5XLUVaLPK8BDoNiR_sUiNYL=s96-c	\N	\N	samuel	\N	t	\N
cfa59d79-f5b3-40f5-8b55-382d4660ca28	sample1	sample1	\N	asad1s@gmail.com	Philippines EARTH	sample address	\N	2021-01-28 06:26:27.662641	2021-09-01 05:31:25.530633	\N	\N	\N	\N	\N	t	\N
d298f448-7e96-4324-9b19-35a408861c8b	supplier	supp	\N	supplier@gmail.com	Philippines EARTH	sample address	\N	2021-01-28 08:16:20.995766	2021-09-01 05:31:25.530633	\N	\N	\N	\N	\N	t	\N
38694216-a4d0-4dd1-868f-46f507e7596b	Rogelio	Jimenez	$argon2i$v=19$m=4096,t=3,p=1$YDYq6fEsulw1dNUfMIEeaQ$XUyJeJC/kvuyeiTRvQwDEbAY3QYjEWZKidktL+y9Ouw	rogelio@boomsourcing.com	\N	\N	105426842970075958010	2021-01-28 15:58:04.890874	2021-09-01 05:31:25.530633	\N	\N	\N	rogelio	\N	t	\N
f20649e9-d1d3-4db0-b702-db57cdb6e33c	James	Cahoon	$argon2i$v=19$m=4096,t=3,p=1$cB1/yNXGfqAVqOGwvLZIHA$P6NzEe2tMSSby2HT6tpoMeiM7C2cQB/yJ4RR+Xu51Eo	jamescahoon33@gmail.com	\N	\N	103174539519557308290	2021-01-28 22:27:22.508914	2021-09-01 05:31:25.530633	\N	\N	\N	jamescahoon	\N	t	\N
78d9414c-edcb-4aab-873c-456ee606e859	Jules	Ballaran	$argon2i$v=19$m=4096,t=3,p=1$iOnEPv2O1kP/+UhAXSJ8MQ$3EfPrFYPRWIq104fqgj7N8covm2+2GYg1J8GIvL+RR4	jules.ballaran@boom.camp	\N	\N	115639281490655050549	2021-02-20 03:49:22.137	2021-09-01 05:31:25.530633	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/78d9414c-edcb-4aab-873c-456ee606e859/profileImg.jpeg	null	null	jules	\N	t	\N
e498f885-498f-4a95-afa0-9370f4a6a866	Jomar	Bandol	$argon2i$v=19$m=4096,t=3,p=1$jo+cxoqjE3UhZgJV0u8fWg$L8eHebadu+rYZB1aIBRZDi0Rx7hS4EC1ZA2DQ2ZEfX0	jomar.bandol@boom.camp	\N	\N	107234037824522967720	2021-01-29 13:30:32.263	2021-09-01 05:31:25.530633	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/e498f885-498f-4a95-afa0-9370f4a6a866/profileImg.png	\N	\N	jbx	\N	t	\N
bf59ffe1-5782-48e5-9416-6147aed232fd	asd4	asd4	$argon2i$v=19$m=4096,t=3,p=1$Cfk4yWIzuishbIbuAO76Ww$TGeN3Sf7wx3i37AhzfBjgKySPU5nwzsZhNqfxTkEVjk	asd4@test.com	\N	\N	\N	2022-02-23 07:57:01.934789	2022-02-23 07:57:01.934789	\N	\N	\N	asd4	\N	t	\N
8d0e1eb0-1f5c-4cc8-b03b-ebf2595bed1c	asd7	asd7	$argon2i$v=19$m=4096,t=3,p=1$VpLJNGsd49q65hNgFCyj9g$dini/lNDIIm0ItOqj9R3dKTsk0nt5MnTEJORiiiVFHo	asd7@test.com	\N	\N	\N	2022-02-23 08:16:51.009141	2022-02-23 08:16:51.009141	\N	\N	\N	asd7	\N	t	\N
80dfa440-cbb8-4f55-9642-a586a9306163	test555	test555	$argon2i$v=19$m=4096,t=3,p=1$Km1DY0XprdPtr+uRx9mLbQ$h6vgCZfPScnsFgZtx/nxk/1mrCnsAfp8PFKfhu4Ntdo	test555@est.com	\N	\N	\N	2022-02-24 01:14:10.16356	2022-02-24 01:14:10.16356	\N	\N	\N	test555	\N	t	\N
bf9c540e-60b9-406c-a82a-c1859adf5d7d	Bravery	Magdalo	$argon2i$v=19$m=4096,t=3,p=1$8KWsBINxR90IJX89wvjEHw$vHOyPJ3UHqXaHSd+mqZAY+83RdJucEWHkjimL9zKeoE	braverymatatag@gmail.com	\N	\N	102123321755372426720	2022-03-04 09:00:01.958202	2022-03-04 09:00:13.181089	https://lh3.googleusercontent.com/a-/AOh14GgeYFIRfcmksLfgcYBj2R7qOmb-KBCqxDqhCzx3=s96-c	\N	\N	braverymatatag	\N	t	\N
62273c54-08a8-4d51-8356-a9619a2bc757	Bryan	Alfuente	$argon2i$v=19$m=4096,t=3,p=1$jA8tjNgN78/lxbr/KmMr0g$gGb/gAD/4c8pHmH91iT8OUtMsVmZT6T8lhhf3PhfEDI	bryan.alfuente@boom.camp	\N	\N	105971517044222860079	2021-04-12 07:52:09.58557	2021-09-22 01:51:51.255622	https://lh3.googleusercontent.com/a-/AOh14GgjEY5dRdh8csIndTsJC1LNPaGGQUCxZLg9ib_IzA=s96-c	\N	\N	ogbry	\N	t	\N
e7a1d853-083c-44ca-939e-f5a6c663151e	testinv1	testinv1	$argon2i$v=19$m=4096,t=3,p=1$Gp54Uw7J+b3AIopkVtQIGQ$UtbIoup/Zby6uuZd/uW2Cw1l2yPi9tn525JOt3ua7qE	testinv1@mail.com	\N	\N	\N	2022-03-11 05:36:37.28543	2022-03-11 05:36:37.28543	\N	\N	\N	testinv1	\N	t	\N
d6fd49ae-64ec-49e1-a077-f71ead6b954e	buyer	002	$argon2i$v=19$m=4096,t=3,p=1$MzzgEtE+CEIO6KZBVfKDjw$ZRN/zyCQJOZd1Fd/lGmmZnYQJjLlvWw/EckIGj/1BqM	buyer002@test.com	\N	\N	\N	2021-10-15 02:18:30.440118	2021-10-15 02:18:30.440118	\N	\N	\N	buyer002	\N	t	\N
71c6bbaf-4c0d-431c-bcde-086a94b74cf2	tester	test	$argon2i$v=19$m=4096,t=3,p=1$8V16WZx4nzp19xkCbS8fow$ruQxrEnlr3WfeGN6ODZP7jkwV2jbiHr2Rla8kAyc9q0	testtest123@gmail.com	\N	\N	\N	2022-03-31 02:08:34.144944	2022-03-31 02:08:34.144944	\N	\N	\N	testtest123	\N	t	\N
2dcc57b5-0538-4025-99ea-b04724481f21	Lieza	Daria	$argon2i$v=19$m=4096,t=3,p=1$TkRBHQElouuLBTY5uyjQow$EwfrWAXpkBSpNtUG5DkWltokRFCvheQkaadaRGi5Z4I	lieza@boomsourcing.com	\N	\N	104854919597032694889	2021-10-19 06:00:21.76347	2021-10-19 06:05:17.676181	https://lh3.googleusercontent.com/a-/AOh14GhQrW2wPFYwv-VzoWD_Qvqcc77FXmsq4NwV8Maz=s96-c	\N	\N	lieza99	\N	t	\N
a5c5171b-1331-474a-82f7-2876fb3843a1	test	buy	$argon2i$v=19$m=4096,t=3,p=1$MvULH0IocIVdX9PUJRVKJA$JrWgDp2YxvEZvw4OguFnGqsGK8Q+aeqzVUEY/TshMCI	testbuy12@example.com	\N	\N	\N	2021-11-23 05:45:09.382929	2021-11-23 05:45:09.382929	\N	\N	\N	testbuy12	\N	t	\N
72d0082b-57bd-460c-820b-9515fe9634ba	seller	test	$argon2i$v=19$m=4096,t=3,p=1$mY3U0p800W4vAGkrlM4ubQ$EMxz9c/rN0oA4tneyWIk9R7qaekDYAOBifQLPFhEjT8	sellerbecometest3@test.com	\N	\N	\N	2022-01-21 05:05:30.270207	2022-01-21 05:05:30.270207	\N	\N	\N	sellertest3	\N	t	\N
0b91be7b-a0e4-46e3-a27f-6a20901785d1	asdf	asdf	$argon2i$v=19$m=4096,t=3,p=1$yedq4+/sj4bkQxV7Kwqd0w$s+qShxSvMBQK9EBm/uazD6qzSXNJZhQGulEDJ9HYyD4	asdf@test.com	\N	\N	\N	2022-02-23 07:40:18.522917	2022-02-23 07:40:18.522917	\N	\N	\N	asdf	\N	t	\N
8e069970-9b1c-4b95-859f-d9726fd80d97	Weena	Test	$argon2i$v=19$m=4096,t=3,p=1$APBcNE432s3G72HnlSOUQg$x94ZH2oqU1i6Tj3Sl7TKyqr5FW21/sq/POE3ipXxloQ	weenatest@gmail.com	\N	\N	\N	2022-02-28 08:23:49.852529	2022-03-01 09:57:44.054302	\N	\N	\N	WeenaTest	\N	t	\N
6d26f96b-3c4e-429a-a283-ac3ad5bdef15	Jan Patrick	Bañares	$argon2i$v=19$m=4096,t=3,p=1$bY099paav0HzvghNCxuvlA$IWBYxsYH6lzMj/m6PGPWFiz3QGImlSVO3IH7Oe0FBsQ	janpatrick.banares@boom.camp	\N	\N	106710953231710970770	2021-01-28 16:33:05.976	2021-09-01 05:31:25.530633	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/6d26f96b-3c4e-429a-a283-ac3ad5bdef15/profileImg.jpeg	\N	\N	patrick	\N	t	\N
501155dd-1910-40f9-a2c5-9730ab3170e6	Jan Patrick	Bañares	$argon2i$v=19$m=4096,t=3,p=1$3bk1KHk35lDjOnxXatUFHA$8Qhaq6oFCoiAPos9YdnJbnfxKgECkNhGg8wMUn/eqVk	janpatrickbanares@gmail.com	\N	\N	110191337015688122042	2021-01-28 23:30:27.909	2021-09-01 05:31:25.530633	\N	\N	\N	jplbanares	\N	t	\N
cdd145d0-06e7-4856-8e05-612e8d5f4aa9	Jomar L.	Bandol	$argon2i$v=19$m=4096,t=3,p=1$NO9IIxLQpmQbhSmaT3Phvg$m61mgjl7Ea16Uk6OCC7nq6euCrnLtHekQrqMitLtO9A	jomar.bandol@bicol-u.edu.ph	\N	\N	107496026589643169187	2021-10-15 02:37:08.883884	2021-10-15 02:38:21.613533	https://lh3.googleusercontent.com/a/AATXAJyhOPSrRB82UyGkcnMGzh7-Uik5pbu_RQDqQlyZ=s96-c	\N	\N	buyer003	\N	t	\N
ef562ed6-1679-49c2-b9b0-46d05910fc53	juana	moana	$argon2i$v=19$m=4096,t=3,p=1$hAhg/tM/C7XyAWjx7fkaZw$l7sUqesP2J8ujIQJ+D7Fg5eGqsaxgg/5tqUITaLliJU	newuser101@gmail.com	\N	\N	\N	2021-10-21 02:25:17.913142	2021-10-21 02:25:17.913142	\N	\N	\N	newuser101	\N	t	\N
4e6b01c7-2e22-495a-ac45-dbfb1265ec87	testinv2	testinv2	$argon2i$v=19$m=4096,t=3,p=1$QZ/dOG/7Aradf24QiwlgLg$AfW+JR551zGUH4c5911DIIfozKysxSZMd5r5FoqPO1Y	testinv2@mail.com	\N	\N	\N	2022-03-11 05:42:21.963146	2022-03-11 05:42:21.963146	\N	\N	\N	testinv2	\N	t	\N
f1dd3f66-b7de-4b7b-af34-4b08a458f1cb	test	buy	$argon2i$v=19$m=4096,t=3,p=1$BLE7iyfC//l7/WUL0jPI3g$jZEE18c/QPqiqxZFY8MM2x1Khsm3OjgjoAcbzz5wxVc	testbuy13@example.com	\N	\N	\N	2021-11-23 05:50:32.182219	2021-11-23 05:50:32.182219	\N	\N	\N	testbuy13	\N	t	\N
cf2434f6-3248-4a68-b035-9269a30fc880	SAMUEL	LOPEZ	\N	samuel.lopez@bicol-u.edu.ph	\N	\N	101009311007526379393	2021-12-01 09:39:45.131511	2021-12-01 09:39:45.131511	https://lh3.googleusercontent.com/a-/AOh14GiBV-HhII_jzz9aHuLE8v6fbObUxQFGo-vxbMgV=s96-c	{"new_group":true,"followed_group":true,"related_group":true,"requested_group":true,"recommended_group":true,"joined_group":true,"group_you_requested":true,"group_ending_soon":true}	{"show_my_profile":true,"show_my_comments":true}	\N	\N	t	\N
bccbb60e-a754-4ce9-b002-8fbaed3986b2	ttest	testt	$argon2i$v=19$m=4096,t=3,p=1$/jardW6cAYciarbWFa+8ew$hWw8JhDbEWCdvfWy82pXK2mNX5blLWd/YdRxpE3q7GE	test123456@gmail.com	\N	\N	\N	2022-03-31 03:16:09.615143	2022-03-31 03:16:09.615143	\N	\N	\N	test123456	\N	t	\N
54f22543-a586-4790-b29f-452415a90c38	seller	test	$argon2i$v=19$m=4096,t=3,p=1$e6u2u2FmQRKrC5wOAhPwEg$AOJux1rx37rtCliOsuSwSpUb6//BGJqzmi/AZ3xHSsY	sellertest1@gmail.com	\N	\N	\N	2022-01-05 08:14:02.310441	2022-01-05 08:14:02.310441	\N	\N	\N	sellertest1	\N	t	\N
b4ad0ef9-f6e8-4c6b-9955-7821453f1faf	asd1	asd1	$argon2i$v=19$m=4096,t=3,p=1$NYRz9mC9NYZYvoxx/9hXrg$W7W5jBrUjEH9LlDVGbZf/ARLjiq0oCPO3GjskWG/upI	asd1@test.com	\N	\N	\N	2022-02-23 07:45:54.191917	2022-02-23 07:45:54.191917	\N	\N	\N	asd1	\N	t	\N
2a061ec4-08f9-4c31-81ac-13d247328221	test10	test10	$argon2i$v=19$m=4096,t=3,p=1$rNDU6sb0a+jATaP0Z9ooTA$Y2TmPMkHbV2/x8cwNrvOFoZpqQYHWf0BoiCnZWB0ImQ	test10@test.com	\N	\N	\N	2022-02-23 10:00:38.909639	2022-02-23 10:00:38.909639	\N	\N	\N	test10	\N	t	\N
04c7936b-24ef-4495-a190-7850f7bf640f	Alexis	Deforge	$argon2i$v=19$m=4096,t=3,p=1$IJVskTKTARJv46jHDiIwIg$0R4Qj7pJOQ6/DaJ1hrZ17bjxEkID+Z47D/DmWC0gx4E	tototouri@gmail.com	\N	\N	\N	2021-09-10 22:46:33.527971	2021-09-10 22:46:33.527971	\N	\N	\N	tototouri	\N	\N	\N
5dc4fab6-d7f6-43e3-b4e0-caafc3e0971c	asd	asd	$argon2i$v=19$m=4096,t=3,p=1$KsGoOSA35tjTNL8A+GBAPQ$5/7/u3+cAPFz7vZ3mVK2rHtBeyUA+P4vi8hg3GETc3c	asd@gmail.com	\N	\N	\N	2021-03-11 13:57:53.569259	2021-09-22 01:52:19.929175	\N	\N	\N	asd	\N	f	\N
d700c16c-9d4e-4f86-b3fd-59c55f994fb7	Test	0001	$argon2i$v=19$m=4096,t=3,p=1$xlQFTV/vvqeZq3Dx4OXXxA$XOZ0stSUZrVRyOFj+45sEKEgGj1By1evEi/Wnt2eYnI	winamurilla@gmail.com	\N	\N	\N	2022-02-28 02:28:55.667454	2022-02-28 06:47:22.487467	\N	\N	\N	test001	\N	t	\N
b2bcf4f3-e507-436a-a24d-07d8db297a80	testbug	testbug	$argon2i$v=19$m=4096,t=3,p=1$/Gh+VD607eVAqzxamhEP6Q$MQIFqFRHwfAxA2IMhuQOvUaFypU6Y0X5/G48Srz7IyQ	testbug@mail.com	\N	\N	\N	2022-02-28 09:23:49.001585	2022-02-28 09:23:49.001585	\N	\N	\N	testbug	\N	t	\N
d2860210-8f2f-49ff-8a9b-e4d63e385d79	Landsbe	Corp	$argon2i$v=19$m=4096,t=3,p=1$0lnprBzL2jZL7Whciuq1Ig$xqFhXyVQ8F5MiBOihWRLR5T5m3jdyH+r6TgxSkTR7o4	lansbe_testing@landsbe.com	\N	\N	\N	2021-03-11 14:01:09.298165	2021-09-01 05:31:25.530633	\N	\N	\N	landsbe_tester	\N	t	\N
b4e70256-d7b6-4ed6-8d05-0b18b2e88ba2	wel	come	$argon2i$v=19$m=4096,t=3,p=1$w/jRx/wuiLBaGmOy2Vcxvg$6O4EPeHymohUvHg5VA9XTlJkYiax/iH3Z0NHdOZ875I	welcome@welcome.com	\N	\N	\N	2021-03-11 14:13:37.38969	2021-09-01 05:31:25.530633	\N	\N	\N	welcome_test	\N	t	\N
f1b7f4f3-7138-4a7e-a14d-e9eee5c71e90	Dio	Jojo	$argon2i$v=19$m=4096,t=3,p=1$tC69fV9oPleExJuS+dwy7Q$rHACduet9uJgz2nL0uSiCsFLQ3ro87clqJcdPtoU4xA	dioj370@gmail.com	\N	\N	118396347964972219833	2021-03-11 14:16:06.691337	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/-snL-ccPpJgw/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuckE1R9OGEt0-nZS2EUtz4hGLKTeIg/s96-c/photo.jpg	\N	\N	giorno_giovana	\N	t	\N
304dc8e4-f277-425e-bec0-50430f85c662	zxc	zxc	$argon2i$v=19$m=4096,t=3,p=1$9uto4k3w/jQyBZkaz5xiaA$ocnnfk/QfpTCOES0mlPTP24oassnULmtKH2jsv2I7lU	zxc@gmail.com	\N	\N	\N	2021-03-11 14:21:48.36206	2021-09-01 05:31:25.530633	\N	\N	\N	zxc	\N	t	\N
534c5afd-865c-44be-8ac2-99959af0daa9	Glenshin	Himpak	$argon2i$v=19$m=4096,t=3,p=1$H2DyioH0BzNvP7NQxEAymA$HZTm7Yns7XMw/UbqE/A9qYDF9tlaLgefXEBjex9SoSs	glenshinhimpak@gmail.com	\N	\N	106558940280096868523	2021-03-11 13:22:27.204402	2021-09-01 05:31:25.530633	https://lh4.googleusercontent.com/-ux3gnu5adQ4/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnZIpwCqh2YphACrjifZN9y_-tlLw/s96-c/photo.jpg	\N	\N	Diluc	\N	t	\N
f1b6f7c0-2820-4c00-91a3-51fd35894f3b	Micko	Matamorosa	$argon2i$v=19$m=4096,t=3,p=1$vc0uPJcKAK/X0KHrNde8DQ$QXStHjWvhzRgn3xswmv5PQg/wVrTwnLsqCQ9Oa70IzY	micko.matamorosa@boom.camp	\N	\N	107329641015311898342	2021-04-12 08:51:22.897392	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14Gg-bUhb8ZUR0xpkCpRpXoKx3McwNw2niF-tI_WH=s96-c	\N	\N	Micko	\N	t	\N
a186f925-d72f-4507-a4e3-c68dfc74818a	stacey	cahoon	$argon2i$v=19$m=4096,t=3,p=1$JzxLTBQ8jtPrHA6Ej2imIQ$UtDqZkncNFTXL+Ch02leHEgxnPcqB/e3XdFPhR1/CWE	jeppy11@yahoo.com	\N	\N	\N	2021-04-19 22:47:55.694229	2021-09-01 05:31:25.530633	\N	\N	\N	jeppy11	\N	t	\N
cb37bc4a-d2df-484e-82c4-0d609683c547	Samingkil	Samingkil	$argon2i$v=19$m=4096,t=3,p=1$V9ydIaxhPQCXe8lfLO733A$4D8PwuxfEPPvd6drg12LLClZ/ZojHPkKAoRZPwzVRA0	Samingkil@tiil.tk	\N	\N	\N	2021-04-22 08:06:12.64733	2021-09-01 05:31:25.530633	\N	\N	\N	Samingkil	\N	t	\N
b5783601-679c-41a2-a32d-f46678f01b43	test	test	$argon2i$v=19$m=4096,t=3,p=1$5h3/w0pFTBO1f2BBNQTWFg$5Fs8IevC4mGng8Q2pGA0/g31hnBcc502fotbqYlZViM	test1122@gmail.com	\N	\N	\N	2021-07-13 01:28:52.430921	2021-09-01 05:31:25.530633	\N	\N	\N	test112233	\N	t	\N
6a22158b-1e05-44a1-a2ca-6c81da35a008	qawe	qwe	$argon2i$v=19$m=4096,t=3,p=1$jFWDatC31SdCGnviLWH8Cw$VTkFWx5s646/KufQQNGPkRKwHGzrAad0NQXspCTVzR0	qwe@gmail.com	\N	\N	\N	2021-03-11 14:31:29.265124	2021-09-01 05:31:25.530633	\N	\N	\N	qwe	\N	t	\N
c4463fb2-06f3-42cd-9934-991eb72f6eba	rty	rty	$argon2i$v=19$m=4096,t=3,p=1$hJXdkW2uLWGBsWmM7l5+vg$9C2Htb1QeHwg7AXmccYP/monyfKbjW0sS8Rlc1t8Bk8	rty@gmail.com	\N	\N	\N	2021-03-11 14:32:39.71323	2021-09-01 05:31:25.530633	\N	\N	\N	rty	\N	t	\N
b73e8e65-8099-43a0-a32d-07484be61320	fgh	fgh	$argon2i$v=19$m=4096,t=3,p=1$483RYhSEMqkYWYU2oOnfYg$oZy2amBkia8zNl4Pm4yvFxmg74CpwTEqok03KT4WD+k	fgh@gmail.com	\N	\N	\N	2021-03-11 14:33:33.237222	2021-09-01 05:31:25.530633	\N	\N	\N	fgh	\N	t	\N
de70ff51-5084-413e-919d-050a432921fe	vbn	vbn	$argon2i$v=19$m=4096,t=3,p=1$KE3dxcTYD0Kfw6YCpRczkw$BpLoeh3o+65vGhpCcSLiNg1QYC+/SydoeJA0VMPyG/M	vbn@gmail.com	\N	\N	\N	2021-03-11 14:34:58.400238	2021-09-01 05:31:25.530633	\N	\N	\N	vbn	\N	t	\N
02b04890-110b-466e-bd2a-bd751250b820	Eric	Nasul	$argon2i$v=19$m=4096,t=3,p=1$Vt3dSe5d/ZQkbhTSOeX2yA$OX5PjLL3Hw+XXwoJH0ByytLJGs/5jNPw+SYFy9yQ19c	enasul111@gmail.com	\N	\N	118007984861532233104	2021-03-11 15:46:58.243731	2021-09-01 05:31:25.530633	https://lh6.googleusercontent.com/-AWcXowS9I34/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnNtykM5n5xvENuylK-QHNiTzW0gw/s96-c/photo.jpg	\N	\N	enasul	\N	t	\N
8d48076e-4645-4537-b3b3-32fd88e3e6ae	test	user	$argon2i$v=19$m=4096,t=3,p=1$fwYIUHdkwl+JlrUKXlV9kg$vULB+jlvbD7ufnLj6DfRax1yDPWxSoDMB9OCFxvNHr4	test@test.com	\N	\N	\N	2021-03-12 03:29:20.649754	2021-09-01 05:31:25.530633	\N	\N	\N	test_user123	\N	t	\N
d9acb795-6487-4e77-b232-159e32e02edc	Pinky	Sancho	$argon2i$v=19$m=4096,t=3,p=1$A0JpII5JnTMnHhU7NJgHEw$HG2sUNvJ5QmQYgIwojaoy50ECv4MuY8K2VWVcPfsDXA	pinkysancho@gmail.com	\N	\N	101151546269002330670	2021-03-19 12:51:49.283295	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14Gjw_U3ipxa_NoMKma0aqBf7yrVTUCol7C-4ccFvYQ=s96-c	\N	\N	pinkysushi	\N	t	\N
c5ea053a-d64f-4f29-9c3f-626efa873eda	James	Cahoon	$argon2i$v=19$m=4096,t=3,p=1$T/YEYA5Kbj24kwPDFnQr7Q$MGknIjoZ5iMd5w8c0b7tAahAgwo8nbzYX/ikCHkTzyI	james@landsbe.com	\N	\N	112707541152531391409	2021-03-25 22:23:34.333196	2021-09-01 05:31:25.530633	https://lh5.googleusercontent.com/-TuJ6kJhlT5Q/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucldRy6TUz581P3cVaXcd9pZCR-fLw/s96-c/photo.jpg	\N	\N	jamescadmin	\N	t	\N
456ea1ca-b7d1-4a58-8abd-c0622e78179a	Rex	Rojo	$argon2i$v=19$m=4096,t=3,p=1$QPi55MIdbbOh9LkT5huUUA$GEYsgxV03/IJ+4bK223oakKcWFBAC9bhTidTXAqKthQ	rex.rojo@boom.camp	\N	\N	113359654243808598527	2021-04-12 07:52:08.03448	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14GgUnGm-DEXALA720knhds5Q3ZAodb5yaDv32-6r=s96-c	\N	\N	ph-dev	\N	t	\N
37606679-8dd0-4de8-8d92-a09bd951cf9c	Vincent	Navas	$argon2i$v=19$m=4096,t=3,p=1$Jq5ZbBFyUs6H5+4eHR+7pw$GJFBnUqDot1IyUhc6h2Wf4Xf9Ozf8agxzLA3zO7tNnI	vincent.navas@boom.camp	\N	\N	109900884708651925530	2021-04-12 07:55:05.464356	2021-09-01 05:31:25.530633	https://lh5.googleusercontent.com/-L0-EiCNbptM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnF5zHsnNawR0XLJUprizTNFnMTpw/s96-c/photo.jpg	\N	\N	Vincent	\N	t	\N
1c1e07c5-5f6c-4d6d-b334-2034520618f6	Diana	Geromo	$argon2i$v=19$m=4096,t=3,p=1$gr+qqYItc1i+vO4BkAhCuQ$tJzWf1KBMYiMZl59s9JaFzv0mvHRxTEkt2JjxCeUnFM	diana.geromo@boom.camp	\N	\N	102880613174706276633	2021-04-12 07:55:16.640464	2021-09-01 05:31:25.530633	https://lh5.googleusercontent.com/-JgiNVC5vYdY/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuckyWx1goZQnvB9TfYOX8eIU2POCcg/s96-c/photo.jpg	\N	\N	Diana	\N	t	\N
c1cfcbbf-2ec9-4966-8849-277852afa41a	Jomar	Bandol	$argon2i$v=19$m=4096,t=3,p=1$YxhjcTs/vxcLaXyo89FlJQ$ZA3tdBLDMS0Jj5rH/uBrHSDZwvU89Eo+emP4LUkLKfU	jomar2999@gmail.com	\N	\N	101301290460998141213	2021-04-08 11:40:07.945	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/-8lviLRWzEQc/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnM-Yp429ScGMaVO0HDi7mlMJnTCQ/s96-c/photo.jpg	\N	\N	user101	\N	t	\N
ce73e9ea-e4cd-47a4-a67e-f5a7f9eb11a4	Patrick	Banares	$argon2i$v=19$m=4096,t=3,p=1$ds2BX/3eSCorXMAgaAgfBQ$J3PutfqfF4Z1PVMNfWHylbxeCRTAxiE9BNmxpqxZkL4	sandwich0131@gmail.com	\N	\N	109136885734569851747	2021-01-28 16:33:34.617	2021-09-01 05:31:25.530633	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/ce73e9ea-e4cd-47a4-a67e-f5a7f9eb11a4/profileImg.gif	\N	\N	pbanares	\N	t	\N
e6b0ae5c-9b15-4eb4-a883-e3618c263912	Scott	Christensen	$argon2i$v=19$m=4096,t=3,p=1$U7dft6wNOmaNTqcr9mI+Ng$OQycVztVh8nk+6/naqybQiZc54yQLjbsEIbACMFlEbA	scottdchristensen@gmail.com	\N	\N	114617269918605966914	2021-05-02 15:54:27.539707	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14GgOkWwh1uDL3RUpTOGUXONU296XL-4YICDldudhmQ=s96-c	\N	\N	s.christensen	\N	t	\N
1ad1ef24-bda9-4216-9f99-b0294b9cf8f2	Sr	Dev	$argon2i$v=19$m=4096,t=3,p=1$32628DukCCBIv0xygrbhmg$eh6phOtFfBBFGbdqPQGghg15GY8OdME97xoBgSxdXIc	test@gmail.com	\N	\N	\N	2021-04-29 05:18:49.555	2021-09-01 05:31:25.530633	https://s3.amazonaws.com/dev.landsbe.boom.ai/static/media/1ad1ef24-bda9-4216-9f99-b0294b9cf8f2/profileImg.jpeg	null	null	1111	\N	t	\N
f25c3687-cc1e-4db7-8394-f5cbe29f6b8a	Raymond	Nasol	$argon2i$v=19$m=4096,t=3,p=1$UjkoUVWU0nPvRh+b7IAmcA$uK0Tu4m46/k1lpG2o3JuQ/x3WSzJ6PCgbB06gPiLS8c	testemail@mail.com	\N	\N	\N	2021-05-24 08:54:34.839669	2021-09-01 05:31:25.530633	\N	\N	\N	2222	\N	t	\N
55b527a3-24db-4321-ba78-2bbecb1c7dfa	test	user0	$argon2i$v=19$m=4096,t=3,p=1$Uplr0RfDYfFzgvvK+ehvCg$O0LuIHumBhvEsCCnFuKhBOuLPGVllolnVX7YyhS27j8	testuser0@test.com	\N	\N	\N	2021-05-27 05:35:56.961745	2021-09-01 05:31:25.530633	\N	\N	\N	testuser0	\N	t	\N
f7c3a660-dd54-4abf-b153-f08d404c5e82	Karmen	O'Leary	$argon2i$v=19$m=4096,t=3,p=1$MA/Xaninu4U1bRzavp4j5g$PWmGK7jWtLgpua7KM3Y9ExJKePO26qIp9RGcGTAhQM0	spincess3@gmail.com	\N	\N	114293210415320665077	2021-06-07 18:02:13.732402	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a/AATXAJxLK8nCAZDKjooEi3ERMrmSWRaSy_zNFkzeWs_e=s96-c	\N	\N	spincess3@gmail.com	\N	t	\N
c34c5ab9-1033-469b-9096-4ec9133a28f4	admin	test	$argon2i$v=19$m=4096,t=3,p=1$glq+o90eJeZpWc/Sm/Jm0Q$k8at0nL33msD0rlC/7qM+U4HMOz2yUIw2cImcf5MwrY	admintest@gmail.com	\N	\N	\N	2021-06-16 05:52:04.448047	2021-09-01 05:31:25.530633	\N	\N	\N	admintest	\N	t	\N
4e42184e-d302-4f88-abcc-cdcb1ba1296a	Pepe	Sylvia	$argon2i$v=19$m=4096,t=3,p=1$UPpn1yEh2T2ZcSc3XFAHlw$UXy7b8DRLZIcHDMQPXf+m4esRYnwVpp4GXv9tEo7OtA	samuel15201818@gmail.com	\N	\N	101662805968233132249	2021-06-30 09:21:30.854574	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a-/AOh14GibuByDstgDq0J_O-R8xJBpPLPpM2tH9-y7wm2R=s96-c	\N	\N	pepenimo	\N	t	\N
2e6dcdfa-1bdb-4783-a662-bdf988385fb8	test	er	$argon2i$v=19$m=4096,t=3,p=1$imt2CNeDAEuaTVsUxLsE6g$S6/M+mDLMmNPloNzOQ497ZNgIPBvnkqDoTGJF0+LvcU	tester@tester.com	\N	\N	\N	2021-07-05 05:34:21.345316	2021-09-01 05:31:25.530633	\N	\N	\N	tester	\N	t	\N
178bfbb8-9cc9-4728-8871-a7ee8a80ece1	Jeffrey	Christensen	\N	jeffchristensen5@gmail.com	\N	\N	\N	2021-04-07 15:22:53.820638	2021-11-02 17:52:47.185522	\N	\N	\N	chrisje	SoYKnh2M	t	\N
81a5258c-6d0c-4067-8eb8-502189932224	Angela	Arevalo	\N	reyleenangela1997@gmail.com	\N	\N	108553536719915924231	2021-07-10 02:05:06.783419	2021-09-01 05:53:32.248962	https://lh3.googleusercontent.com/a-/AOh14GiO2pmBkSbXkTbFotZn8aoy8C41iYgPskI_pd6b=s96-c	\N	\N	\N	\N	t	\N
98be6f5a-8796-4272-a055-5fc7ba77a38b	Seatiel	Austria	$argon2i$v=19$m=4096,t=3,p=1$PGpUGM9InlBYAGpGIo8rxw$pyJmSl3eAYupCe0r7DXM0Ac24/lXC25BxFECBNOH2oE	seatiel.austria@boom.camp	\N	\N	\N	2021-04-12 07:56:11.401701	2021-09-01 07:55:13.672969	\N	\N	\N	sityel	\N	t	\N
46056b5e-3e3f-40ce-8477-8d3dcc19f006	Wina	Bernal	$argon2i$v=19$m=4096,t=3,p=1$FpsOse8oX1yX0HT42FBPvQ$hoEw309xD+qllYjHg9y3gszLmsanIh9WuitjxMqJOiw	wina@boomsourcing.com	\N	\N	116046746145716813977	2021-03-12 01:42:48.639517	2021-09-22 01:58:49.395091	https://lh3.googleusercontent.com/a-/AOh14GivPa4zGoxrm2_mbz8HijX_g35kvxoy-vs933G5Lw=s96-c	\N	\N	Wina	\N	t	\N
dba74431-a1c3-4baa-8b10-d050b8a6a90b	testinv3	testinv3	$argon2i$v=19$m=4096,t=3,p=1$HiAH9fLUhud1a4mj02Iceg$h95m9tGyUdaDzAxluPOQQqVMflaKDjQQ83HswEqmNb8	testinv3@mail.com	\N	\N	\N	2022-03-11 05:49:09.510092	2022-03-11 05:49:09.510092	\N	\N	\N	testinv3	\N	t	\N
3a80067d-5a89-445c-b016-3cc20e586964	Landsbe	Landsbe	\N	donotreply@landsbe.com	\N	\N	\N	2022-03-31 06:12:10.296886	2022-03-31 06:12:10.296886	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=108078065047216&height=50&width=50&ext=1651299130&hash=AeTfnTRv3IHzj3Zu_gM	{"new_group":true,"followed_group":true,"related_group":true,"requested_group":true,"recommended_group":true,"joined_group":true,"group_you_requested":true,"group_ending_soon":true}	{"show_my_profile":true,"show_my_comments":true}	\N	\N	t	108078065047216
c8af8c22-b265-4aed-984c-c3fbf3e736ed	Martha	Peña Peña	\N	geno3mx@gmail.com	\N	\N	113173497198608023733	2021-07-19 20:42:26.214371	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a/AATXAJxCrxrdXwNT5HqU_faWek7Rpqb5ovJv0iGyEA2k=s96-c	{"new_group":true,"followed_group":true,"related_group":true,"requested_group":true,"recommended_group":true,"joined_group":true,"group_you_requested":true,"group_ending_soon":true}	{"show_my_profile":true,"show_my_comments":true}	\N	\N	t	\N
566bf97d-79a1-493c-84c9-028c3d095c33	more	together	$argon2i$v=19$m=4096,t=3,p=1$x/2Ig8IevTYgIWKRryON1A$4pKbu10jo4fv6Z7ux0jdlIIopHgMZMNTlIiw0Hn5v90	moretogether11@rave.com	\N	\N	\N	2021-07-21 01:28:03.683004	2021-09-01 05:31:25.530633	\N	\N	\N	moretogether11	\N	t	\N
cbae9bc0-b44f-4e49-8a0a-bff3c8bd159e	yeyo	Jimenez	$argon2i$v=19$m=4096,t=3,p=1$Zk3uPS3W1DNLNBH1NAxvwg$agCUWtoiJJyNgX+u4Auk3MgpZv2MHUo/i/6R+WIJNqo	rjmultimedia1@gmail.com	\N	\N	111430284179332092289	2021-07-22 21:30:40.30563	2021-09-01 05:31:25.530633	https://lh3.googleusercontent.com/a/AATXAJz32b1_DrVK6XZN1RC30W1eHZ7hH7CQBDl7IkvJ=s96-c	\N	\N	rjmultimedia1	\N	t	\N
fae2b509-47c3-48c1-be0a-c1207f962196	seller	test	$argon2i$v=19$m=4096,t=3,p=1$D5qRXQbx0feylmi64fAyRQ$dD3pOnfsnoQGFiDBf32GEdQhJqYiym9o+MJSdEsYhKA	sellerbecometest@test.com	\N	\N	\N	2021-07-27 06:40:52.984696	2021-09-01 05:31:25.530633	\N	\N	\N	sellerbecometest	\N	t	\N
61b4e07d-9c97-4b0b-b4d7-f0e0c690083b	buyer	zero	$argon2i$v=19$m=4096,t=3,p=1$qXYRtJYbko2clAdkKbEW1w$q2vuwkfA4dRnSulGEY6qwbzmneD5p6VehUQEQZgbGbI	buyer000@test.com	\N	\N	\N	2021-08-26 02:08:01.817208	2021-09-01 05:31:25.530633	\N	\N	\N	buyer000	\N	t	\N
f3f139e9-f6ef-4eef-8792-edc5010def66	Mary	Lynne	$argon2i$v=19$m=4096,t=3,p=1$ICmMAeFLumcBE1itk6WhEQ$gbRC9NvlDWcIPtrjk0guABNIEL9ci1QXLOffZeuCMt4	marylynne75@overcomeoj.com	\N	\N	\N	2021-09-14 05:56:32.099654	2021-09-14 05:56:32.099654	\N	\N	\N	marlyn75	\N	\N	\N
15329586-0822-433a-a72f-6777256a0c94	asd5	asd5	$argon2i$v=19$m=4096,t=3,p=1$+7A36AnoDBRM7hDdlbowIw$Ijj1MCR6TGCkQwmScNyWyiCF02m5d6uBHLtQzBivT8I	asd5@test.com	\N	\N	\N	2022-02-23 08:02:26.853695	2022-02-23 08:02:26.853695	\N	\N	\N	asd5	\N	t	\N
90eca2ab-8bea-45b4-ab87-42ec580c9b3b	test100	test100	$argon2i$v=19$m=4096,t=3,p=1$khbJoPA9jThMYWr2IAXctg$iPGUVl/E/pYowmpLm4rcuXuD88hhes+RfcpjhFPdnRQ	test100@test.com	\N	\N	\N	2022-02-23 10:03:10.609571	2022-02-23 10:03:10.609571	\N	\N	\N	test100	\N	t	\N
826be7c9-b01e-4690-8cc3-e1dc75aadf85	test	user102	$argon2i$v=19$m=4096,t=3,p=1$hD/MfU/9QkXwJrcWqV5z/A$zC2tQ7eZ2MD7B/sfzqqd5x6+SnYcy2bpdkRT9cscNrI	user102@test.com	\N	\N	\N	2021-07-03 01:41:49.968	2021-09-20 01:56:33.409233	\N	null	null	user102	\N	t	\N
3fb53321-ff41-4a66-9bba-1b6bc3464c1c	seller2	test	$argon2i$v=19$m=4096,t=3,p=1$QEVhZ97WgrYRXJpMpQw6iA$8biXX6jEiyICC4JhHCJtKxghjxqqx2dFKJOR5J6LHo4	sellertest2@gmail.com	\N	\N	\N	2022-01-06 09:12:46.000726	2022-01-06 09:12:46.000726	\N	\N	\N	sellertest2	\N	t	\N
79f5a3a5-5774-4184-806e-079e0a4398a9	asd2	asd2	$argon2i$v=19$m=4096,t=3,p=1$+4UsQN8m1UZe31G9bn+cwg$s5HIfZ1MOig2awBKIv82CM6RCMugH51w8asyg6XNcJg	asd2@test.com	\N	\N	\N	2022-02-23 07:47:44.269871	2022-02-23 07:47:44.269871	\N	\N	\N	asd2	\N	t	\N
d58f874e-ab30-4908-a181-add5a92e563b	seller12	seller12	$argon2i$v=19$m=4096,t=3,p=1$IAGef4VTo9MIR1T8wc+nzg$N4cYyL7pfTv1A5NMWVv+NtNM5bNi/DPWYUN7yCFxQn8	seller12@mail.com	\N	\N	\N	2022-02-25 04:44:18.707922	2022-02-25 04:44:18.707922	\N	\N	\N	seller12	\N	t	\N
12823c4d-8fc9-4419-8551-10b29a0ab513	Test	User02	$argon2i$v=19$m=4096,t=3,p=1$0yOoLvQI6Ca+T0QATVmmoA$Q9VlIYP2sb3uWO+pN/eao747xTJtgT/13DqDAIgZXbk	weena.pptech@gmail.com	\N	\N	\N	2022-02-28 07:47:48.969453	2022-02-28 07:47:48.969453	\N	\N	\N	TestUser02	\N	t	\N
92f29b2a-4865-4f05-9b56-5ccd8235ea55	testbug1	testbug1	$argon2i$v=19$m=4096,t=3,p=1$2qge4a9HX4UsjYYyDFYwzQ$XNO5Q/4GEpiCihv0H4pGVWkp+Ky4Yrjj7YyjNglbZyA	testbug1@mail.com	\N	\N	\N	2022-02-28 09:33:38.046373	2022-02-28 09:33:38.046373	\N	\N	\N	testbug1	\N	t	\N
6ef390e4-2fd3-4266-aaa6-54dca52a334a	Alex	Gonzalo	$argon2i$v=19$m=4096,t=3,p=1$6Aqyw7gdAtTLs0mGGKQE1Q$uscwyudsi09z7yc3MjGIZzOIAsHruMyjPk2jMP1/F44	icbm69@outlook.com	\N	\N	\N	2022-03-03 09:48:13.303286	2022-03-03 09:48:30.18637	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=100628999249695&height=50&width=50&ext=1648892893&hash=AeSMe4qQKU_xPPJ4Hss	\N	\N	AlexTest	\N	t	100628999249695
014f5284-99fa-493f-bfae-6a2900b23ec5	testbuyer5	testbuyer5	$argon2i$v=19$m=4096,t=3,p=1$nf5vTyScv8HJ53lZC1Tf6Q$xv0PxzYA4nxPN/p0cVk20iZyCQHpPDPoXjtnnutd/X8	testbuyer5@mail.com	\N	\N	\N	2022-04-27 05:08:58.314978	2022-04-27 05:08:58.314978	\N	\N	\N	testbuyer5	\N	t	\N
093de4bb-71a5-4eaf-9f4b-aae69c3fc355	testbuyer6	testbuyer6	$argon2i$v=19$m=4096,t=3,p=1$oZzmjMVl2O+vkhrlk7/fBw$02fANQCKg3I94ZBUFeoMsLSdGc6fSQ/+S9/4APMsLew	testbuyer6@mail.com	\N	\N	\N	2022-04-27 05:12:35.389169	2022-04-27 05:12:35.389169	\N	\N	\N	testbuyer6	\N	t	\N
47b1979e-50f9-45aa-880a-34b76ccd8f4d	testbuyer7	testbuyer7	$argon2i$v=19$m=4096,t=3,p=1$zyLsbB/xq0cRJVuy+8w74Q$RsBGS1O3d4WiTqgxcXL8la+9thdOVk9oOnurtQPrimE	testbuyer7@test.com	\N	\N	\N	2022-04-27 05:14:17.914284	2022-04-27 05:14:17.914284	\N	\N	\N	testbuyer7	\N	t	\N
79b69f8f-c2a8-45f0-aad7-7932b462a3af	testbuyer8	testbuyer8	$argon2i$v=19$m=4096,t=3,p=1$43NNoDsC7O+2jRQifrYjgQ$192fx/0Uh0VUncg4mRB7z086pRmHc4O0GKzCgZwNGpk	testbuyer8@mail.com	\N	\N	\N	2022-04-27 06:24:34.030502	2022-04-27 06:24:34.030502	\N	\N	\N	testbuyer8	\N	t	\N
1fe14ebc-ff2a-4366-b1e7-7a15ddfc3857	testbuyer9	testbuyer9	$argon2i$v=19$m=4096,t=3,p=1$W9w+KmFvLkIy4ytLAiFT8w$yIF5kHb6od1/3UBTvWpO1EJsSbm5p9xtNRW4SjlsJzo	testbuyer9@mail.com	\N	\N	\N	2022-04-27 07:34:24.688724	2022-04-27 07:34:24.688724	\N	\N	\N	testbuyer9	\N	t	\N
b84cf4e6-a7aa-4bbc-9984-7beeb8b153d1	testbuyer10	testbuyer10	$argon2i$v=19$m=4096,t=3,p=1$liUG+ZLs+7XJJ2iG/628Gw$h7KvCIQBEh/HDydA7EA8665y3/p7XTaqSYS8Ewu7Vuk	testbuyer10@mail.com	\N	\N	\N	2022-04-28 01:28:21.033777	2022-04-28 01:28:21.033777	\N	\N	\N	testbuyer10	\N	t	\N
0b8a6598-6626-41ac-af7f-9f9bc766807b	landsbe	test	$argon2i$v=19$m=4096,t=3,p=1$iPFAWBjoOCj5LgNjhc3RsQ$8V3zlSu109aI3qSPsq08O/hq5hI1kdTn8MTBWplKuC8	landsbe-test1@gmail.com	\N	\N	\N	2022-04-28 09:35:05.353523	2022-04-28 09:35:05.353523	\N	\N	\N	landsbe11	\N	t	\N
3f0f211d-17e0-4669-9ada-c44c92cd6c55	sam	test	$argon2i$v=19$m=4096,t=3,p=1$x78IvLgQDw7nXeCG612CkA$rUV0nx0nF9YFVXkszw+J5YJl8oh7Fh2Fr8btTPELYjA	samtest1@boom.ai	\N	\N	\N	2022-04-28 09:41:22.815454	2022-04-28 09:41:22.815454	\N	\N	\N	samtest	\N	t	\N
92696082-3259-4e90-8e7d-58c198051056	juan	tutri	$argon2i$v=19$m=4096,t=3,p=1$ogTbjwMRM36mqdunYPqV3g$6K/HZxuyHQQ5wclaffKWSuYhscC9qeRFWi423l3XCLI	juan23@gmail.com	\N	\N	\N	2022-04-29 01:32:42.000343	2022-04-29 01:32:42.000343	\N	\N	\N	juan23	\N	t	\N
59f15176-edc5-4e0f-a0ea-2d787647ccbc	setets	tests	$argon2i$v=19$m=4096,t=3,p=1$FSUwSNWSj1Epy+oq5S3qug$XTUCnCm6CH1ekkwfP9ZGEStF8KSNUPAZ8lWc/aKc7II	DEVteam12345@gmail.com	\N	\N	\N	2022-05-03 02:33:26.751752	2022-05-03 02:33:26.751752	\N	\N	\N	test123	\N	t	\N
\.


--
-- Data for Name: website_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.website_settings (id, showwebsite) FROM stdin;
1	t
\.


--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_announcement_id_seq', 1, true);


--
-- Name: crawler_queue_crawler_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crawler_queue_crawler_id_seq', 173, true);


--
-- Name: email_management_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_management_id_seq', 3, true);


--
-- Name: email_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_template_id_seq', 10, true);


--
-- Name: faq_editor_faq_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faq_editor_faq_id_seq', 9, true);


--
-- Name: feature_group_editor_feat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feature_group_editor_feat_id_seq', 12, true);


--
-- Name: form_group_tutorial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.form_group_tutorial_id_seq', 6, true);


--
-- Name: homepage_edit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.homepage_edit_id_seq', 3, true);


--
-- Name: how_it_works_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.how_it_works_id_seq', 47, true);


--
-- Name: invited_sellers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invited_sellers_id_seq', 206, true);


--
-- Name: legalities_editor_l_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.legalities_editor_l_id_seq', 6, true);


--
-- Name: notification_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_template_id_seq', 25, true);


--
-- Name: popup_editor_pop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.popup_editor_pop_id_seq', 5, true);


--
-- Name: private_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.private_groups_id_seq', 166, true);


--
-- Name: promo_editor_promo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promo_editor_promo_id_seq', 35, true);


--
-- Name: rejected_sellers_rs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rejected_sellers_rs_id_seq', 3, true);


--
-- Name: seller_feedback_seller_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seller_feedback_seller_feedback_id_seq', 6, true);


--
-- Name: site_feedbacks_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.site_feedbacks_feedback_id_seq', 39, true);


--
-- Name: user_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_activity_id_seq', 142, true);


--
-- Name: website_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.website_settings_id_seq', 1, true);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: bidding bidding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidding
    ADD CONSTRAINT bidding_pkey PRIMARY KEY (bid_uuid);


--
-- Name: crawler_queue crawler_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawler_queue
    ADD CONSTRAINT crawler_queue_pkey PRIMARY KEY (crawler_id);


--
-- Name: email_management email_management_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_management
    ADD CONSTRAINT email_management_pkey PRIMARY KEY (id);


--
-- Name: email_template email_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_template
    ADD CONSTRAINT email_template_pkey PRIMARY KEY (id);


--
-- Name: faq_editor faq_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq_editor
    ADD CONSTRAINT faq_editor_pkey PRIMARY KEY (faq_id);


--
-- Name: feature_group_editor feature_group_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_group_editor
    ADD CONSTRAINT feature_group_editor_pkey PRIMARY KEY (feat_id);


--
-- Name: form_group_tutorial form_group_tutorial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_group_tutorial
    ADD CONSTRAINT form_group_tutorial_pkey PRIMARY KEY (id);


--
-- Name: group_members group_members_group_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_user_id_key UNIQUE (group_id, user_id);


--
-- Name: group_notification_counter group_notification_counter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_notification_counter
    ADD CONSTRAINT group_notification_counter_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (group_uuid);


--
-- Name: homepage_edit homepage_edit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homepage_edit
    ADD CONSTRAINT homepage_edit_pkey PRIMARY KEY (id);


--
-- Name: how_it_works how_it_works_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.how_it_works
    ADD CONSTRAINT how_it_works_pkey PRIMARY KEY (id);


--
-- Name: invited_sellers invited_sellers_invited_site_url_invited_site_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invited_sellers
    ADD CONSTRAINT invited_sellers_invited_site_url_invited_site_email_key UNIQUE (invited_site_url, invited_site_email);


--
-- Name: invited_sellers invited_sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invited_sellers
    ADD CONSTRAINT invited_sellers_pkey PRIMARY KEY (id);


--
-- Name: legalities_editor legalities_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.legalities_editor
    ADD CONSTRAINT legalities_editor_pkey PRIMARY KEY (l_id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (notification_id);


--
-- Name: notification_template notification_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_template
    ADD CONSTRAINT notification_template_pkey PRIMARY KEY (id);


--
-- Name: popup_editor popup_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.popup_editor
    ADD CONSTRAINT popup_editor_pkey PRIMARY KEY (pop_id);


--
-- Name: private_groups private_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_groups
    ADD CONSTRAINT private_groups_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_category_name_key UNIQUE (category_name);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (category_uuid);


--
-- Name: group_suggestions product_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_suggestions
    ADD CONSTRAINT product_suggestions_pkey PRIMARY KEY (suggestion_uuid);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_uuid);


--
-- Name: promo_editor promo_editor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_editor
    ADD CONSTRAINT promo_editor_pkey PRIMARY KEY (promo_id);


--
-- Name: rejected_sellers rejected_sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rejected_sellers
    ADD CONSTRAINT rejected_sellers_pkey PRIMARY KEY (rs_id);


--
-- Name: seller_feedback seller_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_feedback
    ADD CONSTRAINT seller_feedback_pkey PRIMARY KEY (seller_feedback_id);


--
-- Name: shipping_address shipping_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_address
    ADD CONSTRAINT shipping_address_pkey PRIMARY KEY (shipping_id);


--
-- Name: site_feedbacks site_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_feedbacks
    ADD CONSTRAINT site_feedbacks_pkey PRIMARY KEY (feedback_id);


--
-- Name: user_activity user_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_pkey PRIMARY KEY (id);


--
-- Name: userpaymentinfo userpaymentinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpaymentinfo
    ADD CONSTRAINT userpaymentinfo_pkey PRIMARY KEY (paymentinfo_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uuid);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: website_settings website_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT website_settings_pkey PRIMARY KEY (id);


--
-- Name: product_categories set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.product_categories FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: users set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: products set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: groups set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.groups FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: group_members set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.group_members FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: user_roles set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: shipping_address set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.shipping_address FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: notification set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.notification FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: tax set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.tax FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: blogs set_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.blogs FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: bidders bidders_bid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidders
    ADD CONSTRAINT bidders_bid_id_fkey FOREIGN KEY (bid_id) REFERENCES public.bidding(bid_uuid) ON DELETE CASCADE;


--
-- Name: bidders bidders_bidder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidders
    ADD CONSTRAINT bidders_bidder_id_fkey FOREIGN KEY (bidder_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: bidding bidding_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidding
    ADD CONSTRAINT bidding_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: bidding bidding_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidding
    ADD CONSTRAINT bidding_product_fkey FOREIGN KEY (product) REFERENCES public.products(product_uuid);


--
-- Name: crawler_queue crawler_queue_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawler_queue
    ADD CONSTRAINT crawler_queue_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_uuid);


--
-- Name: group_insights group_insights_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_insights
    ADD CONSTRAINT group_insights_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: group_insights group_insights_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_insights
    ADD CONSTRAINT group_insights_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid);


--
-- Name: group_members group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid) ON DELETE CASCADE;


--
-- Name: group_members group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: group_notification_counter group_notification_counter_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_notification_counter
    ADD CONSTRAINT group_notification_counter_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid) ON DELETE CASCADE;


--
-- Name: groups groups_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_uuid);


--
-- Name: groups groups_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: notification notification_triggered_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_triggered_by_fkey FOREIGN KEY (triggered_by) REFERENCES public.users(uuid);


--
-- Name: notification notification_user_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_uuid_fkey FOREIGN KEY (user_uuid) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: payouts payouts_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payouts
    ADD CONSTRAINT payouts_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: private_groups private_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_groups
    ADD CONSTRAINT private_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: private_groups private_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_groups
    ADD CONSTRAINT private_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid);


--
-- Name: group_suggestions product_suggestions_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_suggestions
    ADD CONSTRAINT product_suggestions_product_fkey FOREIGN KEY (product) REFERENCES public.products(product_uuid);


--
-- Name: product_suggestions product_suggestions_proposer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_suggestions
    ADD CONSTRAINT product_suggestions_proposer_fkey FOREIGN KEY (proposer) REFERENCES public.users(uuid);


--
-- Name: group_suggestions product_suggestions_proposer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_suggestions
    ADD CONSTRAINT product_suggestions_proposer_id_fkey FOREIGN KEY (proposer_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: products products_product_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_product_category_fkey FOREIGN KEY (product_category) REFERENCES public.product_categories(category_uuid);


--
-- Name: products products_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(uuid);


--
-- Name: seller_details seller_details_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_details
    ADD CONSTRAINT seller_details_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(uuid);


--
-- Name: seller_feedback seller_feedback_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_feedback
    ADD CONSTRAINT seller_feedback_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: shipping_address shipping_address_user_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_address
    ADD CONSTRAINT shipping_address_user_uuid_fkey FOREIGN KEY (user_uuid) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: transactions transactions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: transactions transactions_shipping_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_shipping_address_id_fkey FOREIGN KEY (shipping_address_id) REFERENCES public.shipping_address(shipping_id);


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid);


--
-- Name: user_activity user_activity_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(group_uuid);


--
-- Name: user_activity user_activity_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity
    ADD CONSTRAINT user_activity_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid);


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: user_subscription user_subscription_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_subscription
    ADD CONSTRAINT user_subscription_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- Name: userpaymentinfo userpaymentinfo_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userpaymentinfo
    ADD CONSTRAINT userpaymentinfo_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(uuid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0 (Debian 12.0-2.pgdg100+1)
-- Dumped by pg_dump version 12.0 (Debian 12.0-2.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

