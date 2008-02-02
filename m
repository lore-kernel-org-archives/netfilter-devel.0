From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 06/34]  New version of SQL schema.
Date: Sat,  2 Feb 2008 22:24:01 +0100
Message-ID: <12019874701589-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <p.chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45987 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757565AbYBBWNp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:13:45 -0500
In-Reply-To: <12019874703998-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <p.chifflier@inl.fr>

 Add insert functions for the PostgreSQL version (read instructions).

Signed-off-by: Pierre Chifflier <p.chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 cbec234... ccbb8e8... M	doc/mysql-ulogd2.sql
:100644 100644 61356b3... 016abc8... M	doc/pgsql-ulogd2.sql
 doc/mysql-ulogd2.sql |   18 ---
 doc/pgsql-ulogd2.sql |  282 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 213 insertions(+), 87 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index cbec234..ccbb8e8 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -658,24 +658,6 @@ $$
 delimiter ;
 
 -- suppressing tuples
-DROP PROCEDURE IF EXISTS DELETE_CT_TUPLE;
-delimiter $$
-CREATE PROCEDURE DELETE_CT_TUPLE(
-		IN _packet_id bigint unsigned
-                )
-SQL SECURITY INVOKER
-COMMENT 'Delete a tuple from conntrack'
-BEGIN
-        -- remember : table with most constraints first
-        DELETE FROM ct_icmp  WHERE ct_icmp._icmp_id = _packet_id;
-        DELETE FROM ct_l4   WHERE ct_l4._l4_id = _packet_id;
-        DELETE FROM ct_tuple WHERE ct_tuple._tuple_id = _packet_id;
-END
-$$
-
-delimiter ;
-
-
 DROP PROCEDURE IF EXISTS DELETE_CT_FLOW;
 delimiter $$
 CREATE PROCEDURE DELETE_CT_FLOW(
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 61356b3..016abc8 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -7,14 +7,13 @@
 --        - ON UPDATE is not supported ?
 --        - type 'integer' is used (we have to check for overflows ..)
 --        - type 'datetime' has been replaced by 'timestamp'
---        - deleting from table ulog2_ct will delete entries from ct_tuple
 
 DROP TABLE IF EXISTS _format;
 CREATE TABLE _format (
   version integer
 ) WITH (OIDS=FALSE);
 
-INSERT INTO _format (version) VALUES (3);
+INSERT INTO _format (version) VALUES (4);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -32,9 +31,6 @@ DROP TABLE IF EXISTS udp CASCADE;
 DROP TABLE IF EXISTS icmp CASCADE;
 DROP TABLE IF EXISTS nufw CASCADE;
 DROP TABLE IF EXISTS ulog2_ct CASCADE;
-DROP TABLE IF EXISTS ct_tuple CASCADE;
-DROP TABLE IF EXISTS ct_l4 CASCADE;
-DROP TABLE IF EXISTS ct_icmp CASCADE;
 DROP TABLE IF EXISTS ulog2 CASCADE;
 
 
@@ -133,6 +129,11 @@ CREATE OR REPLACE VIEW view_udp AS
 CREATE OR REPLACE VIEW view_icmp AS
         SELECT * FROM ulog2 INNER JOIN icmp ON ulog2._id = icmp._icmp_id;
 
+-- complete view
+CREATE OR REPLACE VIEW ulog AS
+        SELECT * FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
+                INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
+
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
         SELECT ulog2._id,ulog2.ip_saddr,tcp.tcp_sport,ulog2.ip_daddr,tcp.tcp_dport FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id;
@@ -143,47 +144,48 @@ CREATE OR REPLACE VIEW view_udp_quad AS
 -- 
 -- conntrack
 -- 
--- orig_id is linked to ulog2.id and is the packet before conntrack (and NAT, for ex)
--- reply_id is linked to ulog2.id and is the packet after conntrack (and NAT, for ex)
+DROP SEQUENCE IF EXISTS ulog2_ct__ct_id_seq;
+CREATE SEQUENCE ulog2_ct__ct_id_seq;
 CREATE TABLE ulog2_ct (
-  _ct_id serial PRIMARY KEY UNIQUE NOT NULL,
-  orig_id integer default NULL,
-  reply_id integer default NULL,
-  state smallint default NULL,
-  start_timestamp timestamp default NULL,
-  end_timestamp timestamp default NULL
-) WITH (OIDS=FALSE);
-
-CREATE TABLE ct_tuple (
-  _tuple_id bigint PRIMARY KEY UNIQUE NOT NULL,
-  ip_saddr inet default NULL,
-  ip_daddr inet default NULL,
-  ip_protocol smallint default NULL,
-  packets bigint default 0,
-  bytes bigint default 0
-) WITH (OIDS=FALSE);
-
-CREATE INDEX ct_tuple_ip_saddr ON ct_tuple(ip_saddr);
-CREATE INDEX ct_tuple_ip_daddr ON ct_tuple(ip_daddr);
-
-CREATE TABLE ct_l4 (
-  _l4_id bigint PRIMARY KEY UNIQUE NOT NULL,
-  l4_sport integer default NULL,
-  l4_dport integer default NULL
-) WITH (OIDS=FALSE);
-
-CREATE INDEX ct_l4_l4_sport ON ct_l4(l4_sport);
-CREATE INDEX ct_l4_l4_dport ON ct_l4(l4_dport);
-
-CREATE TABLE ct_icmp (
-  _icmp_id bigint PRIMARY KEY UNIQUE NOT NULL,
+  _ct_id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('ulog2_ct__ct_id_seq'),
+  orig_ip_saddr inet default NULL,
+  orig_ip_daddr inet default NULL,
+  orig_ip_protocol smallint default NULL,
+  orig_l4_sport integer default NULL,
+  orig_l4_dport integer default NULL,
+  orig_bytes bigint default 0,
+  orig_packets bigint default 0,
+  reply_ip_saddr inet default NULL,
+  reply_ip_daddr inet default NULL,
+  reply_ip_protocol smallint default NULL,
+  reply_l4_sport integer default NULL,
+  reply_l4_dport integer default NULL,
+  reply_bytes bigint default 0,
+  reply_packets bigint default 0,
+  icmp_code smallint default NULL,
   icmp_type smallint default NULL,
-  icmp_code smallint default NULL
+  ct_mark bigint default 0,
+  flow_start_sec integer default 0,
+  flow_start_usec integer default 0,
+  flow_end_sec integer default 0,
+  flow_end_usec integer default 0,
+  state smallint default 0
 ) WITH (OIDS=FALSE);
 
-
-ALTER TABLE ulog2_ct ADD CONSTRAINT ulog2_orig_id_fk   FOREIGN KEY (orig_id)   REFERENCES ct_tuple(_tuple_id) ON DELETE CASCADE;
-ALTER TABLE ulog2_ct ADD CONSTRAINT ulog2_reply_id_fk  FOREIGN KEY (reply_id)  REFERENCES ct_tuple(_tuple_id) ON DELETE CASCADE;
+CREATE INDEX ulog2_ct_orig_ip_saddr ON ulog2_ct(orig_ip_saddr);
+CREATE INDEX ulog2_ct_orig_ip_daddr ON ulog2_ct(orig_ip_daddr);
+CREATE INDEX ulog2_ct_reply_ip_saddr ON ulog2_ct(reply_ip_saddr);
+CREATE INDEX ulog2_ct_reply_ip_daddr ON ulog2_ct(reply_ip_daddr);
+CREATE INDEX ulog2_ct_orig_l4_sport ON ulog2_ct(orig_l4_sport);
+CREATE INDEX ulog2_ct_orig_l4_dport ON ulog2_ct(orig_l4_dport);
+CREATE INDEX ulog2_ct_reply_l4_sport ON ulog2_ct(reply_l4_sport);
+CREATE INDEX ulog2_ct_reply_l4_dport ON ulog2_ct(reply_l4_dport);
+CREATE INDEX ulog2_ct_state ON ulog2_ct(state);
+
+ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_sport CHECK(orig_l4_sport >= 0 AND orig_l4_sport <= 65536);
+ALTER TABLE ulog2_ct ADD CONSTRAINT orig_l4_dport CHECK(orig_l4_dport >= 0 AND orig_l4_dport <= 65536);
+ALTER TABLE ulog2_ct ADD CONSTRAINT reply_l4_sport CHECK(reply_l4_sport >= 0 AND reply_l4_sport <= 65536);
+ALTER TABLE ulog2_ct ADD CONSTRAINT reply_l4_dport CHECK(reply_l4_dport >= 0 AND reply_l4_dport <= 65536);
 
 -- 
 -- Helper table
@@ -254,6 +256,172 @@ RETURNS void AS $$
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 
+CREATE OR REPLACE FUNCTION INSERT_IP_PACKET(
+                IN oob_time_sec integer,
+                IN oob_time_usec integer,
+                IN oob_prefix varchar(32),
+                IN oob_mark integer,
+                IN oob_in varchar(32),
+                IN oob_out varchar(32),
+                IN ip_saddr inet,
+                IN ip_daddr inet,
+                IN ip_protocol smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
+                        oob_in,oob_out,ip_saddr,ip_daddr,ip_protocol)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+
+CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
+                IN oob_time_sec integer,
+                IN oob_time_usec integer,
+                IN oob_prefix varchar(32),
+                IN oob_mark integer,
+                IN oob_in varchar(32),
+                IN oob_out varchar(32),
+                IN ip_saddr inet,
+                IN ip_daddr inet,
+                IN ip_protocol smallint,
+                IN ip_tos smallint,
+                IN ip_ttl smallint,
+                IN ip_totlen smallint,
+                IN ip_ihl smallint,
+                IN ip_csum smallint,
+                IN ip_id smallint,
+                IN ip_fragoff smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
+                        oob_in,oob_out,ip_saddr,ip_daddr,ip_protocol,
+                        ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+CREATE OR REPLACE FUNCTION INSERT_TCP_FULL(
+                IN tcp_id bigint,
+                IN tcp_sport integer,
+                IN tcp_dport integer,
+                IN tcp_seq integer,
+                IN tcp_ackseq integer,
+                IN tcp_window smallint,
+                IN tcp_urg smallint,
+                IN tcp_urgp smallint ,
+                IN tcp_ack smallint,
+                IN tcp_psh smallint,
+                IN tcp_rst smallint,
+                IN tcp_syn smallint,
+                IN tcp_fin smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO tcp (_tcp_id,tcp_sport,tcp_dport,tcp_seq,tcp_ackseq,tcp_window,tcp_urg,
+                        tcp_urgp,tcp_ack,tcp_psh,tcp_rst,tcp_syn,tcp_fin)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+CREATE OR REPLACE FUNCTION INSERT_UDP(
+                IN tcp_id bigint,
+                IN tcp_sport integer,
+                IN tcp_dport integer,
+                IN tcp_len smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO udp (_udp_id,udp_sport,udp_dport,udp_len)
+                VALUES ($1,$2,$3,$4);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+CREATE OR REPLACE FUNCTION INSERT_ICMP(
+                IN icmp_id bigint,
+                IN icmp_type smallint,
+                IN icmp_code smallint,
+                IN icmp_echoid smallint,
+                IN icmp_echoseq smallint,
+                IN icmp_gateway integer,
+                IN icmp_fragmtu smallint 
+        )
+RETURNS bigint AS $$
+        INSERT INTO icmp (_icmp_id,icmp_type,icmp_code,icmp_echoid,icmp_echoseq,icmp_gateway,icmp_fragmtu)
+                VALUES ($1,$2,$3,$4,$5,$6,$7);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+CREATE OR REPLACE FUNCTION INSERT_MAC(
+                IN tcp_id bigint,
+                IN udp_sport integer,
+                IN udp_dport integer,
+                IN udp_len smallint
+        )
+RETURNS bigint AS $$
+        INSERT INTO udp (_udp_id,udp_sport,udp_dport,udp_len)
+                VALUES ($1,$2,$3,$4);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+-- this function requires plpgsql
+-- su -c "createlang plpgsql ulog2" postgres
+CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
+                IN oob_time_sec integer,
+                IN oob_time_usec integer,
+                IN oob_prefix varchar(32),
+                IN oob_mark integer,
+                IN oob_in varchar(32),
+                IN oob_out varchar(32),
+                IN ip_saddr inet,
+                IN ip_daddr inet,
+                IN ip_protocol smallint,
+                IN ip_tos smallint,
+                IN ip_ttl smallint,
+                IN ip_totlen smallint,
+                IN ip_ihl smallint,
+                IN ip_csum smallint,
+                IN ip_id smallint,
+                IN ip_fragoff smallint,
+                IN tcp_sport integer,
+                IN tcp_dport integer,
+                IN tcp_seq integer,
+                IN tcp_ackseq integer,
+                IN tcp_window smallint,
+                IN tcp_urg smallint,
+                IN tcp_urgp smallint ,
+                IN tcp_ack smallint,
+                IN tcp_psh smallint,
+                IN tcp_rst smallint,
+                IN tcp_syn smallint,
+                IN tcp_fin smallint,
+                IN udp_sport integer,
+                IN udp_dport integer,
+                IN udp_len smallint,
+                IN icmp_type smallint,
+                IN icmp_code smallint,
+                IN icmp_echoid smallint,
+                IN icmp_echoseq smallint,
+                IN icmp_gateway integer,
+                IN icmp_fragmtu smallint 
+        )
+RETURNS bigint AS $$
+DECLARE
+        _id bigint;
+BEGIN
+        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16) ;
+        IF (ip_protocol = 6) THEN
+                SELECT INSERT_TCP_FULL(_id,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28);
+        ELSIF (ip_protocol = 17) THEN
+                SELECT INSERT_UDP(_id,$29,$30,$31,$32);
+        ELSIF (ip_protocol = 1) THEN
+                SELECT INSERT_ICMP(_id,$33,$34,$35,$36,$37,$38);
+        END IF;
+        RETURN _id;
+END
+$$ LANGUAGE plpgsql SECURITY INVOKER;
+
+
+
+
 CREATE OR REPLACE FUNCTION DELETE_PACKET(
                 IN _packet_id bigint
         )
@@ -283,14 +451,12 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 -- END
 -- $$ LANGUAGE plpgsql SECURITY INVOKER;
 
-CREATE OR REPLACE FUNCTION DELETE_CT_TUPLE(
-                IN _packet_id bigint
+CREATE OR REPLACE FUNCTION DELETE_CT_FLOW(
+                IN _ct_packet_id bigint
         )
 RETURNS void AS $$
   -- remember : table with most constraints first
-  DELETE FROM ct_icmp  WHERE ct_icmp._icmp_id   = $1;
-  DELETE FROM ct_l4    WHERE ct_l4._l4_id       = $1;
-  DELETE FROM ct_tuple WHERE ct_tuple._tuple_id = $1;
+  DELETE FROM ulog2_ct WHERE ulog2_ct._ct_id = $1;
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 
@@ -332,26 +498,4 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 -- Add foreign keys to tables
 SELECT ULOG2_ADD_FOREIGN_KEYS();
 
--- 
--- Test section
--- 
-
--- pas besoin de faire une transaction, LAST_INSERT_ID est par connexion (donc pas de race condition, mais par contre il faut pas
--- faire d'insertions multiples)
-BEGIN;
-INSERT INTO ulog2 (ip_saddr,ip_daddr,ip_protocol) VALUES ('127.0.0.1','127.0.0.1',6);
-INSERT INTO tcp (_tcp_id,tcp_sport,tcp_dport) VALUES (currval('ulog2__id_seq'),46546,80);
-COMMIT;
-
-BEGIN;
-INSERT INTO ulog2 (ip_saddr,ip_daddr,ip_protocol) VALUES ('127.0.0.2','127.0.0.2',2);
-INSERT INTO icmp (_icmp_id) VALUES (currval('ulog2__id_seq'));
-COMMIT;
-
--- INSERT INTO ulog2_ct (orig_id,reply_id) VALUES (@tcp_packet1,@tcp_packet2);
-
-INSERT INTO ulog2 (ip_saddr,ip_daddr,ip_protocol) VALUES ('127.0.0.1','127.0.0.1',0);
-INSERT INTO nufw (_nufw_id,user_id,username) VALUES (currval('ulog2__id_seq'),1000,'toto');
-
-INSERT INTO ulog2 (ip_saddr,ip_daddr,ip_protocol) VALUES ('127.0.0.1','127.0.0.1',0);
 
-- 
1.5.2.5

