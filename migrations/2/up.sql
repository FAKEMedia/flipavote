-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.4
-- Diff date: 2024-05-23 21:44:13
-- Source model: samizdat
-- Database: samizdat
-- PostgreSQL version: 13.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 45
-- Changed objects: 0

SET search_path = public,pg_catalog,account;
-- ddl-end --


-- [ Created objects ] --
-- object: account | type: SCHEMA --
-- DROP SCHEMA IF EXISTS account CASCADE;
CREATE SCHEMA account;
-- ddl-end --
ALTER SCHEMA account OWNER TO samizdat;
-- ddl-end --

-- object: account.contacts | type: TABLE --
-- DROP TABLE IF EXISTS account.contacts CASCADE;
CREATE TABLE account.contacts
(
  contactid    BIGINT            NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  email        CHARACTER VARYING NOT NULL,
  givenname    CHARACTER VARYING,
  commonname   CHARACTER VARYING,
  displayname  CHARACTER VARYING NOT NULL DEFAULT '',
  organization CHARACTER VARYING,
  address      CHARACTER VARYING,
  pc           CHARACTER VARYING,
  city         CHARACTER(63),
  telephone    CHARACTER VARYING(31),
  mobile       CHARACTER VARYING(31),
  website      CHARACTER VARYING,
  dob          DATE,
  countryid    INTEGER,
  languageid   INTEGER                    DEFAULT 1,
  stateid      INTEGER,
  CONSTRAINT contacts_pk PRIMARY KEY (contactid)
);
-- ddl-end --
ALTER TABLE account.contacts
  OWNER TO samizdat;
-- ddl-end --

-- object: account.passwords | type: TABLE --
-- DROP TABLE IF EXISTS account.passwords CASCADE;
CREATE TABLE account.passwords
(
  passwordid       BIGINT                   NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  passwordmysql    CHARACTER VARYING,
  passwordsha512   CHARACTER VARYING,
  passwordpbkdf2   CHARACTER VARYING,
  passwordbcrypt   CHARACTER VARYING,
  passwordargon2id CHARACTER VARYING,
  changed          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  userid           BIGINT                   NOT NULL,
  CONSTRAINT passwords_pk PRIMARY KEY (passwordid),
  CONSTRAINT password_userid_uq UNIQUE (userid)
);
-- ddl-end --
ALTER TABLE account.passwords
  OWNER TO samizdat;
-- ddl-end --

-- object: account.roles | type: TABLE --
-- DROP TABLE IF EXISTS account.roles CASCADE;
CREATE TABLE account.roles
(
  roleid INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  CONSTRAINT roles_pk PRIMARY KEY (roleid)
);
-- ddl-end --
ALTER TABLE account.roles
  OWNER TO samizdat;
-- ddl-end --

-- object: account.messages | type: TABLE --
-- DROP TABLE IF EXISTS account.messages CASCADE;
CREATE TABLE account.messages
(
  messageid   BIGINT  NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  recipientid BIGINT  NOT NULL,
  senderid    BIGINT,
  contents    json    NOT NULL,
  viewed      BOOLEAN NOT NULL         DEFAULT FALSE,
  created     TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  modified    TIMESTAMP WITH TIME ZONE,
  CONSTRAINT messages_pk PRIMARY KEY (messageid)
);
-- ddl-end --
ALTER TABLE account.messages
  OWNER TO samizdat;
-- ddl-end --

-- object: account.userbans | type: TABLE --
-- DROP TABLE IF EXISTS account.userbans CASCADE;
CREATE TABLE account.userbans
(
  userbanid BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  banner    BIGINT NOT NULL,
  banned    BIGINT NOT NULL,
  CONSTRAINT userbans_pk PRIMARY KEY (userbanid)
);
-- ddl-end --
ALTER TABLE account.userbans
  OWNER TO samizdat;
-- ddl-end --

-- object: account.loginfailures | type: TABLE --
-- DROP TABLE IF EXISTS account.loginfailures CASCADE;
CREATE TABLE account.loginfailures
(
  loginfailureid BIGINT                   NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  ip             inet                     NOT NULL,
  username       CHARACTER VARYING(31)    NOT NULL DEFAULT '',
  failuretime    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  CONSTRAINT loginfailures_pk PRIMARY KEY (loginfailureid)
);
-- ddl-end --
ALTER TABLE account.loginfailures
  OWNER TO samizdat;
-- ddl-end --

-- object: loginfailures_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS account.loginfailures_ip_idx CASCADE;
CREATE INDEX loginfailures_ip_idx ON account.loginfailures
  USING btree
  (
   ip
    )
  INCLUDE (ip)
  WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: account.users | type: TABLE --
-- DROP TABLE IF EXISTS account.users CASCADE;
CREATE TABLE account.users
(
  userid    BIGINT                NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  username  CHARACTER VARYING(31) NOT NULL,
  deleted   BOOLEAN               NOT NULL DEFAULT FALSE,
  blocked   BOOLEAN               NOT NULL DEFAULT FALSE,
  activated BOOLEAN               NOT NULL DEFAULT FALSE,
  created   TIMESTAMP WITH TIME ZONE       DEFAULT NOW(),
  modified  TIMESTAMP WITH TIME ZONE,
  checked   BOOLEAN               NOT NULL DEFAULT FALSE,
  contactid BIGINT                NOT NULL,
  CONSTRAINT users_pk PRIMARY KEY (userid),
  CONSTRAINT username_uq UNIQUE (username),
  CONSTRAINT contactid_uq UNIQUE (contactid)
);
-- ddl-end --
ALTER TABLE account.users
  OWNER TO samizdat;
-- ddl-end --

-- object: account.logins | type: TABLE --
-- DROP TABLE IF EXISTS account.logins CASCADE;
CREATE TABLE account.logins
(
  loginid   BIGINT                   NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  userid    BIGINT                   NOT NULL,
  logintime TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  active    BOOLEAN                  NOT NULL DEFAULT TRUE,
  ip        inet                     NOT NULL,
  CONSTRAINT logins_pk PRIMARY KEY (loginid)
);
-- ddl-end --
ALTER TABLE account.logins
  OWNER TO samizdat;
-- ddl-end --

-- object: account.rolenames | type: TABLE --
-- DROP TABLE IF EXISTS account.rolenames CASCADE;
CREATE TABLE account.rolenames
(
  rolenameid INTEGER      NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  rolename   VARCHAR(191) NOT NULL,
  languageid INTEGER      NOT NULL,
  roleid     INTEGER      NOT NULL,
  CONSTRAINT rolenames_pk PRIMARY KEY (rolenameid)
);
-- ddl-end --
ALTER TABLE account.rolenames
  OWNER TO samizdat;
-- ddl-end --

-- object: account.presentations | type: TABLE --
-- DROP TABLE IF EXISTS account.presentations CASCADE;
CREATE TABLE account.presentations
(
  presentationid BIGINT  NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  presentation   TEXT    NOT NULL DEFAULT '',
  userid         BIGINT  NOT NULL,
  languageid     INTEGER NOT NULL DEFAULT 1,
  CONSTRAINT presentations_pk PRIMARY KEY (presentationid)
);
-- ddl-end --
ALTER TABLE account.presentations
  OWNER TO samizdat;
-- ddl-end --

-- object: account.images | type: TABLE --
-- DROP TABLE IF EXISTS account.images CASCADE;
CREATE TABLE account.images
(
  imageid      BIGINT      NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  profileimage BIT VARYING NOT NULL,
  userid       BIGINT      NOT NULL,
  filename     CHARACTER VARYING,
  CONSTRAINT images_pk PRIMARY KEY (imageid),
  CONSTRAINT userid_uq UNIQUE (userid)
);
-- ddl-end --
ALTER TABLE account.images
  OWNER TO samizdat;
-- ddl-end --

-- object: account.displayfields | type: TABLE --
-- DROP TABLE IF EXISTS account.displayfields CASCADE;
CREATE TABLE account.displayfields
(
  displayfieldid BIGINT              NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  fieldnames     CHARACTER VARYING[] NOT NULL,
  displaylevel   SMALLINT            NOT NULL DEFAULT 0,
  userid         BIGINT              NOT NULL,
  CONSTRAINT displayfields_pk PRIMARY KEY (displayfieldid)
);
-- ddl-end --
ALTER TABLE account.displayfields
  OWNER TO samizdat;
-- ddl-end --

-- object: account.groups | type: TABLE --
-- DROP TABLE IF EXISTS account.groups CASCADE;
CREATE TABLE account.groups
(
  groupid   BIGINT            NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  groupname CHARACTER VARYING NOT NULL,
  creator   INTEGER,
  updater   INTEGER,
  CONSTRAINT groups_pk PRIMARY KEY (groupid),
  CONSTRAINT groupname_uq UNIQUE (groupname)
);
-- ddl-end --
ALTER TABLE account.groups
  OWNER TO samizdat;
-- ddl-end --

-- object: account.usergroups | type: TABLE --
-- DROP TABLE IF EXISTS account.usergroups CASCADE;
CREATE TABLE account.usergroups
(
  usergroupid BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  userid      BIGINT NOT NULL,
  groupid     BIGINT NOT NULL,
  CONSTRAINT usergroups_pk PRIMARY KEY (usergroupid)
);
-- ddl-end --
ALTER TABLE account.usergroups
  OWNER TO samizdat;
-- ddl-end --

-- object: account.permissions | type: TABLE --
-- DROP TABLE IF EXISTS account.permissions CASCADE;
CREATE TABLE account.permissions
(
  permissionid INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  CONSTRAINT permissions_pk PRIMARY KEY (permissionid)
);
-- ddl-end --
ALTER TABLE account.permissions
  OWNER TO samizdat;
-- ddl-end --

-- object: account.rolepermissions | type: TABLE --
-- DROP TABLE IF EXISTS account.rolepermissions CASCADE;
CREATE TABLE account.rolepermissions
(
  rolepermissionid INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  roleid           INTEGER NOT NULL,
  permissionid     INTEGER,
  CONSTRAINT rolepermissions_pk PRIMARY KEY (rolepermissionid)
);
-- ddl-end --
ALTER TABLE account.rolepermissions
  OWNER TO samizdat;
-- ddl-end --

-- object: account.permissionnames | type: TABLE --
-- DROP TABLE IF EXISTS account.permissionnames CASCADE;
CREATE TABLE account.permissionnames
(
  permissionnameid INTEGER      NOT NULL GENERATED ALWAYS AS IDENTITY,
  permissionid     INTEGER      NOT NULL,
  languageid       INTEGER      NOT NULL,
  permissionname   VARCHAR(191) NOT NULL,
  CONSTRAINT permissionnames_pk PRIMARY KEY (permissionnameid)
);
-- ddl-end --
ALTER TABLE account.permissionnames
  OWNER TO samizdat;
-- ddl-end --

-- object: logins_userid_idx | type: INDEX --
-- DROP INDEX IF EXISTS account.logins_userid_idx CASCADE;
CREATE INDEX logins_userid_idx ON account.logins
  USING btree
  (
   userid DESC NULLS LAST
    )
  INCLUDE (userid);
-- ddl-end --

-- object: messages_recipientid_idx | type: INDEX --
-- DROP INDEX IF EXISTS account.messages_recipientid_idx CASCADE;
CREATE INDEX messages_recipientid_idx ON account.messages
  USING btree
  (
   recipientid
    );
-- ddl-end --


-- [ Created foreign keys ] --
-- object: languages_fk | type: CONSTRAINT --
-- ALTER TABLE account.contacts DROP CONSTRAINT IF EXISTS languages_fk CASCADE;
ALTER TABLE account.contacts
  ADD CONSTRAINT languages_fk FOREIGN KEY (languageid)
    REFERENCES public.languages (languageid) MATCH FULL
    ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: countries_fk | type: CONSTRAINT --
-- ALTER TABLE account.contacts DROP CONSTRAINT IF EXISTS countries_fk CASCADE;
ALTER TABLE account.contacts
  ADD CONSTRAINT countries_fk FOREIGN KEY (countryid)
    REFERENCES public.countries (countryid) MATCH FULL
    ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: states_fk | type: CONSTRAINT --
-- ALTER TABLE account.contacts DROP CONSTRAINT IF EXISTS states_fk CASCADE;
ALTER TABLE account.contacts
  ADD CONSTRAINT states_fk FOREIGN KEY (stateid)
    REFERENCES public.states (stateid) MATCH SIMPLE
    ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.passwords DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.passwords
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: recipient_fk | type: CONSTRAINT --
-- ALTER TABLE account.messages DROP CONSTRAINT IF EXISTS recipient_fk CASCADE;
ALTER TABLE account.messages
  ADD CONSTRAINT recipient_fk FOREIGN KEY (recipientid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: sender_fk | type: CONSTRAINT --
-- ALTER TABLE account.messages DROP CONSTRAINT IF EXISTS sender_fk CASCADE;
ALTER TABLE account.messages
  ADD CONSTRAINT sender_fk FOREIGN KEY (senderid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: banner_id | type: CONSTRAINT --
-- ALTER TABLE account.userbans DROP CONSTRAINT IF EXISTS banner_id CASCADE;
ALTER TABLE account.userbans
  ADD CONSTRAINT banner_id FOREIGN KEY (banner)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: banned_id | type: CONSTRAINT --
-- ALTER TABLE account.userbans DROP CONSTRAINT IF EXISTS banned_id CASCADE;
ALTER TABLE account.userbans
  ADD CONSTRAINT banned_id FOREIGN KEY (banned)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: contacts_fk | type: CONSTRAINT --
-- ALTER TABLE account.users DROP CONSTRAINT IF EXISTS contacts_fk CASCADE;
ALTER TABLE account.users
  ADD CONSTRAINT contacts_fk FOREIGN KEY (contactid)
    REFERENCES account.contacts (contactid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.logins DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.logins
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: languages_fk | type: CONSTRAINT --
-- ALTER TABLE account.rolenames DROP CONSTRAINT IF EXISTS languages_fk CASCADE;
ALTER TABLE account.rolenames
  ADD CONSTRAINT languages_fk FOREIGN KEY (languageid)
    REFERENCES public.languages (languageid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: roles_fk | type: CONSTRAINT --
-- ALTER TABLE account.rolenames DROP CONSTRAINT IF EXISTS roles_fk CASCADE;
ALTER TABLE account.rolenames
  ADD CONSTRAINT roles_fk FOREIGN KEY (roleid)
    REFERENCES account.roles (roleid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.presentations DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.presentations
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: languages_fk | type: CONSTRAINT --
-- ALTER TABLE account.presentations DROP CONSTRAINT IF EXISTS languages_fk CASCADE;
ALTER TABLE account.presentations
  ADD CONSTRAINT languages_fk FOREIGN KEY (languageid)
    REFERENCES public.languages (languageid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.images DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.images
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.displayfields DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.displayfields
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: creator_fk | type: CONSTRAINT --
-- ALTER TABLE account.groups DROP CONSTRAINT IF EXISTS creator_fk CASCADE;
ALTER TABLE account.groups
  ADD CONSTRAINT creator_fk FOREIGN KEY (creator)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE SET NULL ON UPDATE NO ACTION;
-- ddl-end --

-- object: updater_fk | type: CONSTRAINT --
-- ALTER TABLE account.groups DROP CONSTRAINT IF EXISTS updater_fk CASCADE;
ALTER TABLE account.groups
  ADD CONSTRAINT updater_fk FOREIGN KEY (updater)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE SET NULL ON UPDATE NO ACTION;
-- ddl-end --

-- object: users_fk | type: CONSTRAINT --
-- ALTER TABLE account.usergroups DROP CONSTRAINT IF EXISTS users_fk CASCADE;
ALTER TABLE account.usergroups
  ADD CONSTRAINT users_fk FOREIGN KEY (userid)
    REFERENCES account.users (userid) MATCH FULL
    ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: groups_fk | type: CONSTRAINT --
-- ALTER TABLE account.usergroups DROP CONSTRAINT IF EXISTS groups_fk CASCADE;
ALTER TABLE account.usergroups
  ADD CONSTRAINT groups_fk FOREIGN KEY (groupid)
    REFERENCES account.groups (groupid) MATCH FULL
    ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: roles_fk | type: CONSTRAINT --
-- ALTER TABLE account.rolepermissions DROP CONSTRAINT IF EXISTS roles_fk CASCADE;
ALTER TABLE account.rolepermissions
  ADD CONSTRAINT roles_fk FOREIGN KEY (roleid)
    REFERENCES account.roles (roleid) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: permissions_fk | type: CONSTRAINT --
-- ALTER TABLE account.rolepermissions DROP CONSTRAINT IF EXISTS permissions_fk CASCADE;
ALTER TABLE account.rolepermissions
  ADD CONSTRAINT permissions_fk FOREIGN KEY (permissionid)
    REFERENCES account.permissions (permissionid) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: permissions_fk | type: CONSTRAINT --
-- ALTER TABLE account.permissionnames DROP CONSTRAINT IF EXISTS permissions_fk CASCADE;
ALTER TABLE account.permissionnames
  ADD CONSTRAINT permissions_fk FOREIGN KEY (permissionid)
    REFERENCES account.permissions (permissionid) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: languages_fk | type: CONSTRAINT --
-- ALTER TABLE account.permissionnames DROP CONSTRAINT IF EXISTS languages_fk CASCADE;
ALTER TABLE account.permissionnames
  ADD CONSTRAINT languages_fk FOREIGN KEY (languageid)
    REFERENCES public.languages (languageid) MATCH SIMPLE
    ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

INSERT INTO roles (roleid) VALUES (1);
INSERT INTO rolenames (rolename, languageid, roleid) VALUES ('Administrator', 1, 1);
INSERT INTO account.contacts (contactid, email, displayname, languageid)
VALUES
  (0, 'www-data@localhost', 'Super Administrator', 1);
INSERT INTO account."users"(userid, username, activated, checked, modified, contactid)
VALUES
  (0, 'root', TRUE, TRUE, NOW(), 0);
INSERT INTO account.groups (groupid, groupname, creator, updater)
VALUES
  (1, 'Administrators', 0, 0);
INSERT INTO account.usergroups (userid, groupid)
VALUES
  (0, 1);