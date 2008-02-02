From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 28/34]  Update SQL schema
Date: Sat,  2 Feb 2008 22:24:23 +0100
Message-ID: <1201987471602-git-send-email-eric@inl.fr>
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
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46005 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761850AbYBBWOo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:44 -0500
In-Reply-To: <12019874711816-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

This patch adds oob_family to the schema. Thus it is now possible to easily select IPv4
or IPv6 entries in the database. This patch also explicitly selects fields to create view.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 ccbb8e8... a146d87... M	doc/mysql-ulogd2.sql
:100644 100644 d6e6efd... a488c11... M	doc/pgsql-ulogd2.sql
 doc/mysql-ulogd2.sql |  179 ++++++++++++++++++++++++++++++++------------------
 doc/pgsql-ulogd2.sql |   66 ++++++++++++++++---
 2 files changed, 170 insertions(+), 75 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index ccbb8e8..a146d87 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -14,7 +14,7 @@ CREATE TABLE `_format` (
   `version` int(4) NOT NULL
 ) ENGINE=INNODB;
 
-INSERT INTO _format (version) VALUES (3);
+INSERT INTO _format (version) VALUES (4);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -33,9 +33,6 @@ DROP TABLE IF EXISTS `udp`;
 DROP TABLE IF EXISTS `icmp`;
 DROP TABLE IF EXISTS `nufw`;
 DROP TABLE IF EXISTS `ulog2_ct`;
-DROP TABLE IF EXISTS `ct_tuple`;
-DROP TABLE IF EXISTS `ct_l4`;
-DROP TABLE IF EXISTS `ct_icmp`;
 DROP TABLE IF EXISTS `ulog2`;
 
 CREATE TABLE `ulog2` (
@@ -46,6 +43,7 @@ CREATE TABLE `ulog2` (
   `oob_mark` int(10) unsigned default NULL,
   `oob_in` varchar(32) default NULL,
   `oob_out` varchar(32) default NULL,
+  `oob_family` tinyint(3) unsigned default NULL,
   `ip_saddr` binary(16) default NULL,
   `ip_daddr` binary(16) default NULL,
   `ip_protocol` tinyint(3) unsigned default NULL,
@@ -61,9 +59,10 @@ CREATE TABLE `ulog2` (
 ) ENGINE=INNODB COMMENT='Table for IP packets';
 
 ALTER TABLE ulog2 ADD KEY `index_id` (`_id`);
-ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
+ALTER TABLE ulog2 ADD KEY `oob_family` (`oob_family`);
 ALTER TABLE ulog2 ADD KEY `ip_saddr` (`ip_saddr`);
 ALTER TABLE ulog2 ADD KEY `ip_daddr` (`ip_daddr`);
+ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
 -- This index does not seem very useful:
 -- ALTER TABLE ulog2 ADD KEY `oob_time_sec` (`oob_time_sec`);
 
@@ -146,9 +145,51 @@ CREATE SQL SECURITY INVOKER VIEW `view_icmp` AS
 
 -- ulog view
 DROP VIEW IF EXISTS `ulog`;
+-- CREATE SQL SECURITY INVOKER VIEW `ulog` AS
+--         SELECT * FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
+-- 		 INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
 CREATE SQL SECURITY INVOKER VIEW `ulog` AS
-        SELECT * FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
-		 INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
+        SELECT _id,
+        oob_time_sec,
+        oob_time_usec,
+        oob_prefix,
+        oob_mark,
+        oob_in,
+	oob_out,
+	oob_family,
+        ip_saddr as ip_saddr_bin,
+        ip_daddr as ip_daddr_bin,
+        ip_protocol,
+        ip_tos,
+        ip_ttl,
+        ip_totlen,
+        ip_ihl,
+        ip_csum,
+        ip_id,
+        ip_fragoff,
+        tcp_sport,
+        tcp_dport,
+        tcp_seq,
+        tcp_ackseq,
+        tcp_window,
+        tcp_urg,
+        tcp_urgp,
+        tcp_ack,
+        tcp_psh,
+        tcp_rst,
+        tcp_syn,
+        tcp_fin,
+        udp_sport,
+        udp_dport,
+        udp_len,
+        icmp_type,
+        icmp_code,
+        icmp_echoid,
+        icmp_echoseq,
+        icmp_gateway,
+        icmp_fragmtu
+        FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
+                INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
 
 -- shortcuts
 DROP VIEW IF EXISTS `view_tcp_quad`;
@@ -165,6 +206,7 @@ CREATE SQL SECURITY INVOKER VIEW `view_udp_quad` AS
 
 CREATE TABLE `ulog2_ct` (
   `_ct_id` bigint unsigned NOT NULL auto_increment,
+  `oob_family` tinyint(3) unsigned default NULL,
   `orig_ip_saddr` binary(16) default NULL,
   `orig_ip_daddr` binary(16) default NULL,
   `orig_ip_protocol` tinyint(3) unsigned default NULL,
@@ -192,6 +234,7 @@ CREATE TABLE `ulog2_ct` (
 ) ENGINE=INNODB;
 
 ALTER TABLE ulog2_ct ADD KEY `index_ct_id` (`_ct_id`);
+ALTER TABLE ulog2_ct ADD KEY `oob_family` (`oob_family`);
 ALTER TABLE ulog2_ct ADD KEY `orig_ip_saddr` (`orig_ip_saddr`);
 ALTER TABLE ulog2_ct ADD KEY `orig_ip_daddr` (`orig_ip_daddr`);
 ALTER TABLE ulog2_ct ADD KEY `orig_ip_protocol` (`orig_ip_protocol`);
@@ -211,15 +254,16 @@ ALTER TABLE ulog2_ct ADD KEY `reply_tuple` (`reply_ip_saddr`, `reply_ip_daddr`,
 DROP VIEW IF EXISTS `conntrack`;
 CREATE SQL SECURITY INVOKER VIEW `conntrack` AS
 	SELECT _ct_id,
-	       orig_ip_saddr,
-	       orig_ip_daddr,
+	       oob_family,
+	       orig_ip_saddr AS orig_ip_saddr_raw,
+	       orig_ip_daddr AS orig_ip_daddr_raw,
 	       orig_ip_protocol,
 	       orig_l4_sport,
 	       orig_l4_dport,
 	       orig_bytes AS orig_raw_pktlen,
 	       orig_packets AS orig_raw_pktcount,
-	       reply_ip_saddr,
-	       reply_ip_daddr,
+	       reply_ip_saddr AS reply_ip_saddr_bin,
+	       reply_ip_daddr AS reply_ip_daddr_bin,
 	       reply_ip_protocol,
 	       reply_l4_sport,
 	       reply_l4_dport,
@@ -321,17 +365,18 @@ CREATE FUNCTION INSERT_IP_PACKET(
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
 		_oob_out varchar(32),
-		_ip_saddr int(16),
-		_ip_daddr int(16),
+		_oob_family tinyint(3) unsigned,
+		_ip_saddr binary(16),
+		_ip_daddr binary(16),
 		_ip_protocol tinyint(3) unsigned
 		) RETURNS bigint unsigned
 SQL SECURITY INVOKER
 NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
-	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out,
+	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out,
+		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol);
 	RETURN LAST_INSERT_ID();
 END
@@ -346,8 +391,9 @@ CREATE FUNCTION INSERT_IP_PACKET_FULL(
 		_oob_mark int(10) unsigned,
 		_oob_in varchar(32),
 		_oob_out varchar(32),
-		_ip_saddr int(16),
-		_ip_daddr int(16),
+		_oob_family tinyint(3) unsigned,
+		_ip_saddr binary(16),
+		_ip_daddr binary(16),
 		_ip_protocol tinyint(3) unsigned,
 	  	_ip_tos tinyint(3) unsigned,
 	  	_ip_ttl tinyint(3) unsigned,
@@ -361,10 +407,10 @@ SQL SECURITY INVOKER
 NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
-	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out,
+	INSERT INTO ulog2 (oob_time_sec, oob_time_usec, oob_prefix, oob_mark, oob_in, oob_out, oob_family,
 			   ip_saddr, ip_daddr, ip_protocol, ip_tos, ip_ttl, ip_totlen, ip_ihl,
 		 	   ip_csum, ip_id, ip_fragoff ) VALUES 
-		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out,
+		(_oob_time_sec, _oob_time_usec, _oob_prefix, _oob_mark, _oob_in, _oob_out, oob_family,
 		 _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl, _ip_totlen, _ip_ihl,
 		 _ip_csum, _ip_id, _ip_fragoff);
 	RETURN LAST_INSERT_ID();
@@ -457,54 +503,56 @@ END
 $$
 
 delimiter $$
-DROP PROCEDURE IF EXISTS INSERT_PACKET_FULL;
-CREATE PROCEDURE INSERT_PACKET_FULL(
-		IN `_oob_time_sec` int(10) unsigned,
-		IN `_oob_time_usec` int(10) unsigned,
-		IN `_oob_prefix` varchar(32),
-		IN `_oob_mark` int(10) unsigned,
-		IN `_oob_in` varchar(32),
-		IN `_oob_out` varchar(32),
-		IN `_ip_saddr` int(16),
-		IN `_ip_daddr` int(16),
-		IN `_ip_protocol` tinyint(3) unsigned,
-	  	IN `_ip_tos` tinyint(3) unsigned,
-	  	IN `_ip_ttl` tinyint(3) unsigned,
-	  	IN `_ip_totlen` smallint(5) unsigned,
-	  	IN `_ip_ihl` tinyint(3) unsigned,
-	  	IN `_ip_csum` smallint(5) unsigned,
-	  	IN `_ip_id` smallint(5) unsigned,
-	  	IN `_ip_fragoff` smallint(5) unsigned,
-		IN `tcp_sport` smallint(5) unsigned,
-		IN `tcp_dport` smallint(5) unsigned,
-		IN `tcp_seq` int(10) unsigned,
-		IN `tcp_ackseq` int(10) unsigned,
-		IN `tcp_window` smallint(5) unsigned,
-		IN `tcp_urg` tinyint(4),
-		IN `tcp_urgp` smallint(5) unsigned,
-		IN `tcp_ack` tinyint(4),
-		IN `tcp_psh` tinyint(4),
-		IN `tcp_rst` tinyint(4),
-		IN `tcp_syn` tinyint(4),
-		IN `tcp_fin` tinyint(4),
-		IN `udp_sport` smallint(5) unsigned,
-		IN `udp_dport` smallint(5) unsigned,
-		IN `udp_len` smallint(5) unsigned,
-		IN `icmp_type` tinyint(3) unsigned,
-		IN `icmp_code` tinyint(3) unsigned,
-		IN `icmp_echoid` smallint(5) unsigned,
-		IN `icmp_echoseq` smallint(5) unsigned,
-		IN `icmp_gateway` int(10) unsigned,
-		IN `icmp_fragmtu` smallint(5) unsigned
---		IN `mac_saddr` binary(12),
---		IN `mac_daddr` binary(12),
---		IN `mac_protocol` smallint(5)
-		)
+DROP FUNCTION IF EXISTS INSERT_PACKET_FULL;
+CREATE FUNCTION INSERT_PACKET_FULL(
+		_oob_time_sec int(10) unsigned,
+		_oob_time_usec int(10) unsigned,
+		_oob_prefix varchar(32),
+		_oob_mark int(10) unsigned,
+		_oob_in varchar(32),
+		_oob_out varchar(32),
+		_oob_family tinyint(3) unsigned,
+		_ip_saddr binary(16),
+		_ip_daddr binary(16),
+		_ip_protocol tinyint(3) unsigned,
+	  	_ip_tos tinyint(3) unsigned,
+	  	_ip_ttl tinyint(3) unsigned,
+	  	_ip_totlen smallint(5) unsigned,
+	  	_ip_ihl tinyint(3) unsigned,
+	  	_ip_csum smallint(5) unsigned,
+	  	_ip_id smallint(5) unsigned,
+	  	_ip_fragoff smallint(5) unsigned,
+		tcp_sport smallint(5) unsigned,
+		tcp_dport smallint(5) unsigned,
+		tcp_seq int(10) unsigned,
+		tcp_ackseq int(10) unsigned,
+		tcp_window smallint(5) unsigned,
+		tcp_urg tinyint(4),
+		tcp_urgp smallint(5) unsigned,
+		tcp_ack tinyint(4),
+		tcp_psh tinyint(4),
+		tcp_rst tinyint(4),
+		tcp_syn tinyint(4),
+		tcp_fin tinyint(4),
+		udp_sport smallint(5) unsigned,
+		udp_dport smallint(5) unsigned,
+		udp_len smallint(5) unsigned,
+		icmp_type tinyint(3) unsigned,
+		icmp_code tinyint(3) unsigned,
+		icmp_echoid smallint(5) unsigned,
+		icmp_echoseq smallint(5) unsigned,
+		icmp_gateway int(10) unsigned,
+		icmp_fragmtu smallint(5) unsigned
+--		mac_saddr binary(12),
+--		mac_daddr binary(12),
+--		mac_protocol smallint(5)
+		) RETURNS bigint unsigned
+READS SQL DATA
 BEGIN
 	SET @lastid = INSERT_IP_PACKET_FULL(_oob_time_sec, _oob_time_usec, _oob_prefix,
-					   _oob_mark, _oob_in, _oob_out, _ip_saddr, 
-					   _ip_daddr, _ip_protocol, _ip_tos, _ip_ttl,
-					   _ip_totlen, _ip_ihl, _ip_csum, _ip_id,
+					   _oob_mark, _oob_in, _oob_out, _oob_family, 
+					   _ip_saddr, _ip_daddr, _ip_protocol, _ip_tos,
+					   _ip_ttl, _ip_totlen, _ip_ihl, _ip_csum, _ip_id,
 					   _ip_fragoff);
 	IF _ip_protocol = 6 THEN
 		CALL PACKET_ADD_TCP_FULL(@lastid, tcp_sport, tcp_dport, tcp_seq, tcp_ackseq,
@@ -519,6 +567,7 @@ BEGIN
 --	IF mac_protocol IS NOT NULL THEN
 --		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_daddr, mac_protocol);
 --	END IF;
+	RETURN @lastid;
 END
 $$
 
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index d6e6efd..a488c11 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -44,6 +44,7 @@ CREATE TABLE ulog2 (
   oob_mark integer default NULL,
   oob_in varchar(32) default NULL,
   oob_out varchar(32) default NULL,
+  oob_family smallint default NULL,
   ip_saddr_str inet default NULL,
   ip_daddr_str inet default NULL,
   ip_protocol smallint default NULL,
@@ -57,9 +58,10 @@ CREATE TABLE ulog2 (
   timestamp timestamp NOT NULL default 'now'
 ) WITH (OIDS=FALSE);
 
-CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
+CREATE INDEX ulog2_oob_family ON ulog2(oob_family);
 CREATE INDEX ulog2_ip_saddr ON ulog2(ip_saddr_str);
 CREATE INDEX ulog2_ip_daddr ON ulog2(ip_daddr_str);
+CREATE INDEX ulog2_timestamp ON ulog2(timestamp);
 
 CREATE TABLE mac (
   _mac_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -131,7 +133,46 @@ CREATE OR REPLACE VIEW view_icmp AS
 
 -- complete view
 CREATE OR REPLACE VIEW ulog AS
-        SELECT * FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
+        SELECT _id,
+        oob_time_sec,
+        oob_time_usec,
+        oob_prefix,
+        oob_mark,
+        oob_in,
+        oob_out,
+        oob_family,
+        ip_saddr_str,
+        ip_daddr_str,
+        ip_protocol,
+        ip_tos,
+        ip_ttl,
+        ip_totlen,
+        ip_ihl,
+        ip_csum,
+        ip_id,
+        ip_fragoff,
+        tcp_sport,
+        tcp_dport,
+        tcp_seq,
+        tcp_ackseq,
+        tcp_window,
+        tcp_urg,
+        tcp_urgp,
+        tcp_ack,
+        tcp_psh,
+        tcp_rst,
+        tcp_syn,
+        tcp_fin,
+        udp_sport,
+        udp_dport,
+        udp_len,
+        icmp_type,
+        icmp_code,
+        icmp_echoid,
+        icmp_echoseq,
+        icmp_gateway,
+        icmp_fragmtu
+        FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
                 INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
 
 -- shortcuts
@@ -148,6 +189,7 @@ DROP SEQUENCE IF EXISTS ulog2_ct__ct_id_seq;
 CREATE SEQUENCE ulog2_ct__ct_id_seq;
 CREATE TABLE ulog2_ct (
   _ct_id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('ulog2_ct__ct_id_seq'),
+  oob_family smallint default NULL,
   orig_ip_saddr_str inet default NULL,
   orig_ip_daddr_str inet default NULL,
   orig_ip_protocol smallint default NULL,
@@ -172,6 +214,7 @@ CREATE TABLE ulog2_ct (
   state smallint default 0
 ) WITH (OIDS=FALSE);
 
+CREATE INDEX ulog2_ct_oob_family ON ulog2_ct(oob_family);
 CREATE INDEX ulog2_ct_orig_ip_saddr ON ulog2_ct(orig_ip_saddr_str);
 CREATE INDEX ulog2_ct_orig_ip_daddr ON ulog2_ct(orig_ip_daddr_str);
 CREATE INDEX ulog2_ct_reply_ip_saddr ON ulog2_ct(reply_ip_saddr_str);
@@ -263,14 +306,15 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
+                IN oob_family smallint,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
                 IN ip_protocol smallint
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
-                        oob_in,oob_out,ip_saddr_str,ip_daddr_str,ip_protocol)
-                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9);
+                        oob_in,oob_out,oob_family,ip_saddr_str,ip_daddr_str,ip_protocol)
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,10);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -282,6 +326,7 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
+                IN oob_family smallint,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
                 IN ip_protocol smallint,
@@ -295,9 +340,9 @@ CREATE OR REPLACE FUNCTION INSERT_IP_PACKET_FULL(
         )
 RETURNS bigint AS $$
         INSERT INTO ulog2 (oob_time_sec,oob_time_usec,oob_prefix,oob_mark,
-                        oob_in,oob_out,ip_saddr_str,ip_daddr_str,ip_protocol,
+                        oob_in,oob_out,oob_family,ip_saddr_str,ip_daddr_str,ip_protocol,
                         ip_tos,ip_ttl,ip_totlen,ip_ihl,ip_csum,ip_id,ip_fragoff)
-                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16);
+                VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17);
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -371,6 +416,7 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN oob_mark integer,
                 IN oob_in varchar(32),
                 IN oob_out varchar(32),
+                IN oob_family smallint,
                 IN ip_saddr_str inet,
                 IN ip_daddr_str inet,
                 IN ip_protocol smallint,
@@ -407,13 +453,13 @@ RETURNS bigint AS $$
 DECLARE
         _id bigint;
 BEGIN
-        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16) ;
+        _id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17) ;
         IF (ip_protocol = 6) THEN
-                SELECT INSERT_TCP_FULL(_id,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28);
+                SELECT INSERT_TCP_FULL(_id,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29);
         ELSIF (ip_protocol = 17) THEN
-                SELECT INSERT_UDP(_id,$29,$30,$31,$32);
+                SELECT INSERT_UDP(_id,$30,$31,$32,$33);
         ELSIF (ip_protocol = 1) THEN
-                SELECT INSERT_ICMP(_id,$33,$34,$35,$36,$37,$38);
+                SELECT INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
         END IF;
         RETURN _id;
 END
-- 
1.5.2.5

