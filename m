From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 4/4] Add destination mac_addr and raw header to database
Date: Wed, 23 Jul 2008 23:20:48 +0200
Message-ID: <1216848048-13516-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39933 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754116AbYGWVUv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:20:51 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for logging the destination mac address and raw header
in the SQL databases.
In case of an ethernet header, a tuple (mac_saddr,mac_daddr,mac_proto) is
logged only once.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/mysql-ulogd2.sql |   68 +++++++++++++++++++++++++++++++++++++------------
 doc/pgsql-ulogd2.sql |   49 +++++++++++++++++++++++++++++++----
 2 files changed, 94 insertions(+), 23 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 8659c38..f1fc710 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -28,6 +28,7 @@ CREATE TABLE `_extensions` (
 ) ENGINE=INNODB;
 
 DROP TABLE IF EXISTS `mac`;
+DROP TABLE IF EXISTS `hwhdr`;
 DROP TABLE IF EXISTS `tcp`;
 DROP TABLE IF EXISTS `udp`;
 DROP TABLE IF EXISTS `icmp`;
@@ -75,13 +76,24 @@ ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
 CREATE TABLE `mac` (
   `_mac_id` bigint unsigned NOT NULL auto_increment,
   `mac_saddr` varchar(32) default NULL,
+  `mac_daddr` varchar(32) default NULL,
   `mac_protocol` smallint(5) default NULL,
   UNIQUE KEY `key_id` (`_mac_id`)
 ) ENGINE=INNODB;
 
-ALTER TABLE mac ADD UNIQUE KEY `mac_saddr` (`mac_saddr`,`mac_protocol`);
+ALTER TABLE mac ADD UNIQUE KEY `mac_addr` (`mac_saddr`,`mac_daddr`,`mac_protocol`);
 ALTER TABLE mac ADD KEY `index_mac_id` (`_mac_id`);
 
+CREATE TABLE `hwhdr` (
+  `_hw_id` bigint unsigned NOT NULL,
+  `raw_type` int(10) unsigned default NULL,
+  `raw_header` varchar(255) default NULL
+) ENGINE=INNODB;
+
+ALTER TABLE hwhdr ADD UNIQUE KEY `_hw_id` (`_hw_id`);
+ALTER TABLE hwhdr ADD KEY `raw_type` (`raw_type`);
+ALTER TABLE hwhdr ADD KEY `raw_header` (`raw_header`);
+
 CREATE TABLE `tcp` (
   `_tcp_id` bigint unsigned NOT NULL,
   `tcp_sport` int(5) unsigned default NULL,
@@ -176,8 +188,8 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         oob_prefix,
         oob_mark,
         oob_in,
-	oob_out,
-	oob_family,
+        oob_out,
+        oob_family,
         ip_saddr AS ip_saddr_bin,
         ip_daddr AS ip_daddr_bin,
         ip_protocol,
@@ -209,17 +221,20 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         icmp_echoseq,
         icmp_gateway,
         icmp_fragmtu,
-	icmpv6_type,
-	icmpv6_code,
-	icmpv6_echoid,
-	icmpv6_echoseq,
-	icmpv6_csum,
-	mac_saddr as mac_saddr_str,
-	mac_protocol as oob_protocol,
-	label as raw_label
+        icmpv6_type,
+        icmpv6_code,
+        icmpv6_echoid,
+        icmpv6_echoseq,
+        icmpv6_csum,
+        raw_type,
+        raw_header AS mac_str,
+        mac_saddr as mac_saddr_str,
+        mac_daddr as mac_daddr_str,
+        mac_protocol as oob_protocol,
+        label as raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
-                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
-                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2.mac_id = mac._mac_id
+		LEFT JOIN hwhdr ON ulog2._id = hwhdr._hw_id LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
 
 
 -- shortcuts
@@ -607,18 +622,32 @@ delimiter $$
 DROP FUNCTION IF EXISTS INSERT_OR_SELECT_MAC;
 CREATE FUNCTION INSERT_OR_SELECT_MAC(
 		`_saddr` varchar(32),
+		`_daddr` varchar(32),
 		`_protocol` smallint(5)
 		) RETURNS bigint unsigned
 NOT DETERMINISTIC
 READS SQL DATA
 BEGIN
-	INSERT IGNORE INTO mac (mac_saddr, mac_protocol) VALUES (_saddr, _protocol);
-	SELECT _mac_id FROM mac WHERE mac_saddr = _saddr AND mac_protocol = _protocol INTO @last_id;
+	INSERT IGNORE INTO mac (mac_saddr, mac_daddr, mac_protocol) VALUES (_saddr, _daddr, _protocol);
+	SELECT _mac_id FROM mac WHERE mac_saddr = _saddr AND mac_daddr = _daddr AND mac_protocol = _protocol INTO @last_id;
 	RETURN @last_id;
 END
 $$
 
 delimiter $$
+DROP PROCEDURE IF EXISTS PACKET_ADD_HARDWARE_HEADER;
+CREATE PROCEDURE PACKET_ADD_HARDWARE_HEADER(
+		IN `id` int(10) unsigned,
+		IN `_hw_type` integer,
+		IN `_hw_addr` varchar(256)
+		)
+BEGIN
+	INSERT INTO hwhdr (_hw_id, raw_type, raw_header) VALUES
+	(id, _hw_type, _hw_addr);
+END
+$$
+
+delimiter $$
 DROP FUNCTION IF EXISTS INSERT_PACKET_FULL;
 CREATE FUNCTION INSERT_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
@@ -665,7 +694,10 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_echoid smallint(5) unsigned,
 		icmpv6_echoseq smallint(5) unsigned,
 		icmpv6_csum int(10) unsigned,
+                raw_type integer,
+                raw_header varchar(256),
 		mac_saddr varchar(32),
+		mac_daddr varchar(32),
 		mac_protocol smallint(5),
 		_label tinyint(4) unsigned
 		) RETURNS bigint unsigned
@@ -689,11 +721,13 @@ BEGIN
 		CALL PACKET_ADD_ICMPV6(@lastid, icmpv6_type, icmpv6_code, icmpv6_echoid,
 				       icmpv6_echoseq, icmpv6_csum);
 	END IF;
-	IF mac_protocol IS NOT NULL THEN
-		SET @mac_id = INSERT_OR_SELECT_MAC(mac_saddr, mac_protocol);
+	IF raw_type = 1 THEN
+		SET @mac_id = INSERT_OR_SELECT_MAC(mac_saddr, mac_daddr, mac_protocol);
 		IF @mac_id IS NOT NULL THEN
 			UPDATE ulog2 SET mac_id = @mac_id WHERE _id = @lastid;
 		END IF;
+	ELSE
+		CALL PACKET_ADD_HARDWARE_HEADER(@lastid, raw_type, raw_header);
 	END IF;
 	RETURN @lastid;
 END
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index b7e0038..78c06b5 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -26,6 +26,7 @@ CREATE TABLE _extensions (
 ) WITH (OIDS=FALSE);
 
 DROP TABLE IF EXISTS mac CASCADE;
+DROP TABLE IF EXISTS hwhdr CASCADE;
 DROP TABLE IF EXISTS tcp CASCADE;
 DROP TABLE IF EXISTS udp CASCADE;
 DROP TABLE IF EXISTS icmp CASCADE;
@@ -72,11 +73,22 @@ CREATE SEQUENCE mac__id_seq;
 CREATE TABLE mac (
   _mac_id bigint PRIMARY KEY UNIQUE NOT NULL DEFAULT nextval('mac__id_seq'),
   mac_saddr macaddr NOT NULL,
+  mac_daddr macaddr default NULL,
   mac_protocol smallint default NULL
 ) WITH (OIDS=FALSE);
 
 CREATE INDEX mac_saddr ON mac(mac_saddr);
-CREATE UNIQUE INDEX unique_mac ON mac(mac_saddr,mac_protocol);
+CREATE INDEX mac_daddr ON mac(mac_daddr);
+CREATE UNIQUE INDEX unique_mac ON mac(mac_saddr,mac_daddr,mac_protocol);
+
+CREATE TABLE hwhdr (
+  _hw_id bigint PRIMARY KEY UNIQUE NOT NULL,
+  raw_type integer default NULL,
+  raw_header varchar(256) default NULL
+) WITH (OIDS=FALSE);
+
+CREATE INDEX raw_type ON hwhdr(raw_type);
+CREATE INDEX raw_header ON hwhdr(raw_header);
 
 CREATE TABLE tcp (
   _tcp_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -195,12 +207,16 @@ CREATE OR REPLACE VIEW ulog AS
         icmpv6_echoid,
         icmpv6_echoseq,
         icmpv6_csum,
+        raw_type,
+        raw_header AS mac_str,
         mac_saddr AS mac_saddr_str,
+        mac_daddr AS mac_daddr_str,
         mac_protocol AS oob_protocol,
         label AS raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id
                 LEFT JOIN mac ON ulog2.mac_id = mac._mac_id
+                LEFT JOIN hwhdr ON ulog2._id = hwhdr._hw_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
 
 -- shortcuts
@@ -443,17 +459,33 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_HARDWARE_HEADER(
+                IN hw_id bigint,
+                IN hw_type integer,
+                IN hw_addr varchar(256)
+        )
+RETURNS bigint AS $$
+        INSERT INTO hwhdr (_hw_id,raw_type,raw_header)
+                VALUES ($1,$2,$3);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
 CREATE OR REPLACE FUNCTION INSERT_OR_SELECT_MAC(
                 IN in_mac_saddr macaddr,
+                IN in_mac_daddr macaddr,
                 IN in_mac_protocol integer
         )
 RETURNS bigint AS $$
 DECLARE
         _id bigint;
 BEGIN
-        SELECT INTO _id _mac_id FROM mac WHERE mac_saddr = $1 AND mac_protocol = $2;
+        IF $2 IS NULL THEN
+                SELECT INTO _id _mac_id FROM mac WHERE mac_saddr = $1 AND mac_daddr IS NULL AND mac_protocol = $3;
+        ELSE
+                SELECT INTO _id _mac_id FROM mac WHERE mac_saddr = $1 AND mac_daddr = $2 AND mac_protocol = $3;
+        END IF;
         IF NOT FOUND THEN
-                INSERT INTO mac (mac_saddr,mac_protocol) VALUES ($1,$2) RETURNING _mac_id INTO _id;
+                INSERT INTO mac (mac_saddr,mac_daddr,mac_protocol) VALUES ($1,$2,$3) RETURNING _mac_id INTO _id;
                 RETURN _id;
         END IF;
         RETURN _id;
@@ -507,7 +539,10 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmpv6_echoid integer,
                 IN icmpv6_echoseq integer,
                 IN icmpv6_csum integer,
+                IN raw_type integer,
+                IN raw_header varchar(256),
                 IN mac_saddr varchar(32),
+                IN mac_daddr varchar(32),
                 IN mac_protocol integer,
                 IN label integer
         )
@@ -516,7 +551,7 @@ DECLARE
         t_id bigint;
         t_mac_id bigint;
 BEGIN
-        t_id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$47);
+        t_id := INSERT_IP_PACKET_FULL($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$50);
         IF (ip_protocol = 6) THEN
                 PERFORM INSERT_TCP_FULL(t_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
         ELSIF (ip_protocol = 17) THEN
@@ -526,9 +561,11 @@ BEGIN
         ELSIF (ip_protocol = 58) THEN
                 PERFORM INSERT_ICMPV6(t_id,$40,$41,$42,$43,$44);
         END IF;
-        IF (mac_saddr IS NOT NULL) THEN
-                t_mac_id = INSERT_OR_SELECT_MAC($45::macaddr,$46);
+        IF (raw_type = 1) THEN
+                t_mac_id = INSERT_OR_SELECT_MAC($47::macaddr,$48::macaddr,$49);
                 UPDATE ulog2 SET mac_id = t_mac_id WHERE _id = t_id;
+        ELSE
+                PERFORM INSERT_HARDWARE_HEADER(t_id,$45,$46);
         END IF;
         RETURN t_id;
 END
-- 
1.5.4.3

