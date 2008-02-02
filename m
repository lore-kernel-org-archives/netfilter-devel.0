From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 34/34]  Modify insert functions to accept standard integers to avoid casts.
Date: Sat,  2 Feb 2008 22:24:29 +0100
Message-ID: <1201987472938-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
 <12019874711187-git-send-email-eric@inl.fr>
 <12019874721299-git-send-email-eric@inl.fr>
 <12019874721188-git-send-email-eric@inl.fr>
 <12019874721527-git-send-email-eric@inl.fr>
 <12019874721483-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46058 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762566AbYBBWQw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:52 -0500
In-Reply-To: <12019874721483-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

This patch fixes the type of some fields in the SQL schema to sync
with datatype of the corresponding ulogd2 keys.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 a488c11... 740a7ef... M	doc/pgsql-ulogd2.sql
:100644 100644 0882357... 7ece626... M	output/pgsql/ulogd_output_PGSQL.c
 doc/pgsql-ulogd2.sql              |  150 +++++++++++++++++--------------------
 output/pgsql/ulogd_output_PGSQL.c |    6 +-
 2 files changed, 72 insertions(+), 84 deletions(-)

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index a488c11..740a7ef 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -52,8 +52,8 @@ CREATE TABLE ulog2 (
   ip_ttl smallint default NULL,
   ip_totlen smallint default NULL,
   ip_ihl smallint default NULL,
-  ip_csum smallint default NULL,
-  ip_id smallint default NULL,
+  ip_csum integer default NULL,
+  ip_id integer default NULL,
   ip_fragoff smallint default NULL,
   timestamp timestamp NOT NULL default 'now'
 ) WITH (OIDS=FALSE);
@@ -77,16 +77,16 @@ CREATE TABLE tcp (
   _tcp_id bigint PRIMARY KEY UNIQUE NOT NULL,
   tcp_sport integer default NULL,
   tcp_dport integer default NULL,
-  tcp_seq integer default NULL,
+  tcp_seq bigint default NULL,
   tcp_ackseq integer default NULL,
-  tcp_window smallint default NULL,
-  tcp_urg smallint default NULL,
-  tcp_urgp smallint  default NULL,
-  tcp_ack smallint default NULL,
-  tcp_psh smallint default NULL,
-  tcp_rst smallint default NULL,
-  tcp_syn smallint default NULL,
-  tcp_fin smallint default NULL
+  tcp_window integer default NULL,
+  tcp_urg boolean default NULL,
+  tcp_urgp integer  default NULL,
+  tcp_ack boolean default NULL,
+  tcp_psh boolean default NULL,
+  tcp_rst boolean default NULL,
+  tcp_syn boolean default NULL,
+  tcp_fin boolean default NULL
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX tcp_sport ON tcp(tcp_sport);
@@ -172,8 +172,8 @@ CREATE OR REPLACE VIEW ulog AS
         icmp_echoseq,
         icmp_gateway,
         icmp_fragmtu
-        FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
-                INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
+        FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id;
 
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
@@ -306,10 +306,10 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN oob_family smallint,
+                IN oob_family integer,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
-                IN ip_protocol smallint
+                IN ip_protocol integer
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
@@ -326,17 +326,17 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN oob_family smallint,
+                IN oob_family integer,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
-                IN ip_protocol smallint,
-                IN ip_tos smallint,
-                IN ip_ttl smallint,
-                IN ip_totlen smallint,
-                IN ip_ihl smallint,
-                IN ip_csum smallint,
-                IN ip_id smallint,
-                IN ip_fragoff smallint
+                IN ip_protocol integer,
+                IN ip_tos integer,
+                IN ip_ttl integer,
+                IN ip_totlen integer,
+                IN ip_ihl integer,
+                IN ip_csum integer,
+                IN ip_id integer,
+                IN ip_fragoff integer
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
@@ -350,16 +350,16 @@ CREATE OR REPLACE FUNCTION INSERT_TCP_FULL(
                 IN tcp_id bigint,
                 IN tcp_sport integer,
                 IN tcp_dport integer,
-                IN tcp_seq integer,
+                IN tcp_seq bigint,
                 IN tcp_ackseq integer,
-                IN tcp_window smallint,
-                IN tcp_urg smallint,
-                IN tcp_urgp smallint ,
-                IN tcp_ack smallint,
-                IN tcp_psh smallint,
-                IN tcp_rst smallint,
-                IN tcp_syn smallint,
-                IN tcp_fin smallint
+                IN tcp_window integer,
+                IN tcp_urg boolean,
+                IN tcp_urgp integer ,
+                IN tcp_ack boolean,
+                IN tcp_psh boolean,
+                IN tcp_rst boolean,
+                IN tcp_syn boolean,
+                IN tcp_fin boolean
         )
 RETURNS bigint AS $$
         INSERT INTO tcp (_tcp_id,tcp_sport,tcp_dport,tcp_seq,tcp_ackseq,tcp_window,tcp_urg,
@@ -369,10 +369,10 @@ RETURNS bigint AS $$
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 CREATE OR REPLACE FUNCTION INSERT_UDP(
-                IN tcp_id bigint,
-                IN tcp_sport integer,
-                IN tcp_dport integer,
-                IN tcp_len smallint
+                IN udp_id bigint,
+                IN udp_sport integer,
+                IN udp_dport integer,
+                IN udp_len integer
         )
 RETURNS bigint AS $$
         INSERT INTO udp (_udp_id,udp_sport,udp_dport,udp_len)
@@ -382,12 +382,12 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 
 CREATE OR REPLACE FUNCTION INSERT_ICMP(
                 IN icmp_id bigint,
-                IN icmp_type smallint,
-                IN icmp_code smallint,
-                IN icmp_echoid smallint,
-                IN icmp_echoseq smallint,
+                IN icmp_type integer,
+                IN icmp_code integer,
+                IN icmp_echoid integer,
+                IN icmp_echoseq integer,
                 IN icmp_gateway integer,
-                IN icmp_fragmtu smallint 
+                IN icmp_fragmtu integer 
         )
 RETURNS bigint AS $$
         INSERT INTO icmp (_icmp_id,icmp_type,icmp_code,icmp_echoid,icmp_echoseq,icmp_gateway,icmp_fragmtu)
@@ -395,18 +395,6 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
-CREATE OR REPLACE FUNCTION INSERT_MAC(
-                IN tcp_id bigint,
-                IN udp_sport integer,
-                IN udp_dport integer,
-                IN udp_len smallint
-        )
-RETURNS bigint AS $$
-        INSERT INTO udp (_udp_id,udp_sport,udp_dport,udp_len)
-                VALUES ($1,$2,$3,$4);
-        SELECT currval('ulog2__id_seq');
-$$ LANGUAGE SQL SECURITY INVOKER;
-
 -- this function requires plpgsql
 -- su -c "createlang plpgsql ulog2" postgres
 CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
@@ -416,38 +404,38 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
-                IN oob_family smallint,
+                IN oob_family integer,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
-                IN ip_protocol smallint,
-                IN ip_tos smallint,
-                IN ip_ttl smallint,
-                IN ip_totlen smallint,
-                IN ip_ihl smallint,
-                IN ip_csum smallint,
-                IN ip_id smallint,
-                IN ip_fragoff smallint,
+                IN ip_protocol integer,
+                IN ip_tos integer,
+                IN ip_ttl integer,
+                IN ip_totlen integer,
+                IN ip_ihl integer,
+                IN ip_csum integer,
+                IN ip_id integer,
+                IN ip_fragoff integer,
                 IN tcp_sport integer,
                 IN tcp_dport integer,
-                IN tcp_seq integer,
+                IN tcp_seq bigint,
                 IN tcp_ackseq integer,
-                IN tcp_window smallint,
-                IN tcp_urg smallint,
-                IN tcp_urgp smallint ,
-                IN tcp_ack smallint,
-                IN tcp_psh smallint,
-                IN tcp_rst smallint,
-                IN tcp_syn smallint,
-                IN tcp_fin smallint,
+                IN tcp_window integer,
+                IN tcp_urg boolean,
+                IN tcp_urgp integer ,
+                IN tcp_ack boolean,
+                IN tcp_psh boolean,
+                IN tcp_rst boolean,
+                IN tcp_syn boolean,
+                IN tcp_fin boolean,
                 IN udp_sport integer,
                 IN udp_dport integer,
-                IN udp_len smallint,
-                IN icmp_type smallint,
-                IN icmp_code smallint,
-                IN icmp_echoid smallint,
-                IN icmp_echoseq smallint,
+                IN udp_len integer,
+                IN icmp_type integer,
+                IN icmp_code integer,
+                IN icmp_echoid integer,
+                IN icmp_echoseq integer,
                 IN icmp_gateway integer,
-                IN icmp_fragmtu smallint 
+                IN icmp_fragmtu integer 
         )
 RETURNS bigint AS $$
 DECLARE
@@ -455,11 +443,11 @@ DECLARE
 BEGIN
         _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17) ;
         IF (ip_protocol = 6) THEN
-                SELECT INSERT_TCP_FULL(_id,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29);
+                PERFORM INSERT_TCP_FULL(_id,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29);
         ELSIF (ip_protocol = 17) THEN
-                SELECT INSERT_UDP(_id,$30,$31,$32,$33);
+                PERFORM INSERT_UDP(_id,$30,$31,$32,$33);
         ELSIF (ip_protocol = 1) THEN
-                SELECT INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
+                PERFORM INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
         END IF;
         RETURN _id;
 END
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 0882357..7ece626 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -280,8 +280,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 static int escape_string_pgsql(struct ulogd_pluginstance *upi,
 			       char *dst, const char *src, unsigned int len)
 {
-	PQescapeString(dst, src, strlen(src)); 
-	return 0;
+	return PQescapeString(dst, src, strlen(src)); 
 }
 
 static int execute_pgsql(struct ulogd_pluginstance *upi,
@@ -290,7 +289,8 @@ static int execute_pgsql(struct ulogd_pluginstance *upi,
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 
 	pi->pgres = PQexec(pi->dbh, stmt);
-	if (!pi->pgres || PQresultStatus(pi->pgres) != PGRES_COMMAND_OK) {
+	if (!(pi->pgres && (PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)
+		|| (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK))) {
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
 			  PQerrorMessage(pi->dbh));
 		return -1;
-- 
1.5.2.5

