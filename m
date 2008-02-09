From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/5] Add Icmpv6 support to SQL schema.
Date: Sat,  9 Feb 2008 13:36:33 +0100
Message-ID: <1202560595625-git-send-email-eric@inl.fr>
References: <12025605952271-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54968 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752870AbYBIMgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:38 -0500
In-Reply-To: <12025605952271-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 d42d216... b154c74... M	doc/mysql-ulogd2.sql
:100644 100644 740a7ef... 87a85fb... M	doc/pgsql-ulogd2.sql
 doc/mysql-ulogd2.sql |   67 +++++++++++++++++++++++++++++++++++++++++++++----
 doc/pgsql-ulogd2.sql |   55 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 110 insertions(+), 12 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index d42d216..b154c74 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -14,7 +14,7 @@ CREATE TABLE `_format` (
   `version` int(4) NOT NULL
 ) ENGINE=INNODB;
 
-INSERT INTO _format (version) VALUES (4);
+INSERT INTO _format (version) VALUES (5);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -31,8 +31,11 @@ DROP TABLE IF EXISTS `mac`;
 DROP TABLE IF EXISTS `tcp`;
 DROP TABLE IF EXISTS `udp`;
 DROP TABLE IF EXISTS `icmp`;
+DROP TABLE IF EXISTS `icmpv6`;
 DROP TABLE IF EXISTS `nufw`;
 DROP TABLE IF EXISTS `ulog2_ct`;
+DROP TABLE IF EXISTS `state_t`;
+DROP TABLE IF EXISTS `nufw`;
 DROP TABLE IF EXISTS `ulog2`;
 
 CREATE TABLE `ulog2` (
@@ -125,6 +128,18 @@ CREATE TABLE `icmp` (
 ALTER TABLE icmp ADD UNIQUE KEY `key_icmp_id` (`_icmp_id`);
 ALTER TABLE icmp ADD KEY `index_icmp_id` (`_icmp_id`);
 
+CREATE TABLE `icmpv6` (
+  `_icmpv6_id` bigint unsigned NOT NULL,
+  `icmpv6_type` tinyint(3) unsigned default NULL,
+  `icmpv6_code` tinyint(3) unsigned default NULL,
+  `icmpv6_echoid` smallint(5) unsigned default NULL,
+  `icmpv6_echoseq` smallint(5) unsigned default NULL,
+  `icmpv6_csum` int(10) unsigned default NULL
+) ENGINE=INNODB;
+
+ALTER TABLE icmpv6 ADD UNIQUE KEY `key_icmpv6_id` (`_icmpv6_id`);
+ALTER TABLE icmpv6 ADD KEY `index_icmpv6_id` (`_icmpv6_id`);
+
 
 -- views
 
@@ -143,6 +158,10 @@ DROP VIEW IF EXISTS `view_icmp`;
 CREATE SQL SECURITY INVOKER VIEW `view_icmp` AS
         SELECT * FROM ulog2 INNER JOIN icmp ON ulog2._id = icmp._icmp_id;
 
+DROP VIEW IF EXISTS `view_icmpv6`;
+CREATE SQL SECURITY INVOKER VIEW `view_icmpv6` AS
+        SELECT * FROM ulog2 INNER JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+
 -- ulog view
 DROP VIEW IF EXISTS `ulog`;
 -- CREATE SQL SECURITY INVOKER VIEW `ulog` AS
@@ -187,9 +206,18 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         icmp_echoid,
         icmp_echoseq,
         icmp_gateway,
-        icmp_fragmtu
+        icmp_fragmtu,
+	icmpv6_type,
+	icmpv6_code,
+	icmpv6_echoid,
+	icmpv6_echoseq,
+	icmpv6_csum
+--	mac_saddr,
+--	mac_daddr,
+--	mac_protocol,
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
-                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id;
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
+                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
 
 
 -- shortcuts
@@ -303,7 +331,6 @@ INSERT INTO ip_proto (_proto_id,proto_name,proto_desc) VALUES
         (58,'ipv6-icmp','ICMP for IPv6');
 
 -- State
-DROP TABLE IF EXISTS `state_t`;
 CREATE TABLE `state_t` (
   `_state_id` bigint unsigned NOT NULL,
   state tinyint(3) unsigned
@@ -319,7 +346,6 @@ INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
 
 -- NuFW specific
 
-DROP TABLE IF EXISTS `nufw`;
 CREATE TABLE `nufw` (
   `_nufw_id` bigint unsigned NOT NULL,
   `username` varchar(30) default NULL,
@@ -362,6 +388,7 @@ SQL SECURITY INVOKER
 COMMENT 'Drop constraints for ulog2 tables'
 BEGIN
         -- remember : table with most constraints first
+        ALTER TABLE icmpv6 DROP FOREIGN KEY _icmpv6_id; 
         ALTER TABLE icmp DROP FOREIGN KEY _icmp_id; 
         ALTER TABLE udp DROP FOREIGN KEY _udp_id; 
         ALTER TABLE tcp DROP FOREIGN KEY _tcp_id; 
@@ -380,6 +407,7 @@ BEGIN
         ALTER TABLE tcp ADD CONSTRAINT _tcp_id FOREIGN KEY (_tcp_id) REFERENCES ulog2 (_id);
         ALTER TABLE udp ADD CONSTRAINT _udp_id FOREIGN KEY (_udp_id) REFERENCES ulog2 (_id);
         ALTER TABLE icmp ADD CONSTRAINT _icmp_id FOREIGN KEY (_icmp_id) REFERENCES ulog2 (_id);
+        ALTER TABLE icmpv6 ADD CONSTRAINT _icmpv6_id FOREIGN KEY (_icmpv6_id) REFERENCES ulog2 (_id);
 END
 $$
 delimiter ;
@@ -515,6 +543,25 @@ BEGIN
 END
 $$
 
+delimiter $$
+DROP PROCEDURE IF EXISTS PACKET_ADD_ICMPV6;
+CREATE PROCEDURE PACKET_ADD_ICMPV6(
+		IN `id` int(10) unsigned,
+		IN `_icmpv6_type` tinyint(3) unsigned,
+		IN `_icmpv6_code` tinyint(3) unsigned,
+		IN `_icmpv6_echoid` smallint(5) unsigned,
+		IN `_icmpv6_echoseq` smallint(5) unsigned,
+		IN `_icmpv6_csum` int(10) unsigned
+		)
+BEGIN
+	INSERT INTO icmpv6 (_icmpv6_id, icmpv6_type, icmpv6_code, icmpv6_echoid, 
+			    icmpv6_echoseq, icmpv6_csum) VALUES
+			   (id, _icmpv6_type, _icmpv6_code, _icmpv6_echoid,
+			    _icmpv6_echoseq, _icmpv6_csum);
+END
+$$
+
+
 
 delimiter $$
 DROP PROCEDURE IF EXISTS PACKET_ADD_MAC;
@@ -570,7 +617,12 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmp_echoid smallint(5) unsigned,
 		icmp_echoseq smallint(5) unsigned,
 		icmp_gateway int(10) unsigned,
-		icmp_fragmtu smallint(5) unsigned
+		icmp_fragmtu smallint(5) unsigned,
+		icmpv6_type tinyint(3) unsigned,
+		icmpv6_code tinyint(3) unsigned,
+		icmpv6_echoid smallint(5) unsigned,
+		icmpv6_echoseq smallint(5) unsigned,
+		icmpv6_csum int(10) unsigned
 --		mac_saddr binary(12),
 --		mac_daddr binary(12),
 --		mac_protocol smallint(5)
@@ -591,6 +643,9 @@ BEGIN
 	ELSEIF _ip_protocol = 1 THEN
 		CALL PACKET_ADD_ICMP(@lastid, icmp_type, icmp_code, icmp_echoid, icmp_echoseq, 
 				     icmp_gateway, icmp_fragmtu);
+	ELSEIF _ip_protocol = 58 THEN
+		CALL PACKET_ADD_ICMPV6(@lastid, icmpv6_type, icmpv6_code, icmpv6_echoid,
+				       icmpv6_echoseq, icmpv6_csum);
 	END IF;
 --	IF mac_protocol IS NOT NULL THEN
 --		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_daddr, mac_protocol);
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 740a7ef..87a85fb 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -13,7 +13,7 @@ CREATE TABLE _format (
   version integer
 ) WITH (OIDS=FALSE);
 
-INSERT INTO _format (version) VALUES (4);
+INSERT INTO _format (version) VALUES (5);
 
 -- this table could be used to know which user-defined tables are linked
 -- to ulog
@@ -29,6 +29,7 @@ DROP TABLE IF EXISTS mac CASCADE;
 DROP TABLE IF EXISTS tcp CASCADE;
 DROP TABLE IF EXISTS udp CASCADE;
 DROP TABLE IF EXISTS icmp CASCADE;
+DROP TABLE IF EXISTS icmpv6 CASCADE;
 DROP TABLE IF EXISTS nufw CASCADE;
 DROP TABLE IF EXISTS ulog2_ct CASCADE;
 DROP TABLE IF EXISTS ulog2 CASCADE;
@@ -118,6 +119,15 @@ CREATE TABLE icmp (
   icmp_fragmtu smallint  default NULL
 ) WITH (OIDS=FALSE);
 
+CREATE TABLE icmpv6 (
+  _icmpv6_id bigint PRIMARY KEY UNIQUE NOT NULL,
+  icmpv6_type smallint default NULL,
+  icmpv6_code smallint default NULL,
+  icmpv6_echoid smallint default NULL,
+  icmpv6_echoseq smallint default NULL,
+  icmpv6_csum integer default NULL
+) WITH (OIDS=FALSE);
+
 -- 
 -- VIEWS
 -- 
@@ -131,6 +141,9 @@ CREATE OR REPLACE VIEW view_udp AS
 CREATE OR REPLACE VIEW view_icmp AS
         SELECT * FROM ulog2 INNER JOIN icmp ON ulog2._id = icmp._icmp_id;
 
+CREATE OR REPLACE VIEW view_icmpv6 AS
+        SELECT * FROM ulog2 INNER JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+
 -- complete view
 CREATE OR REPLACE VIEW ulog AS
         SELECT _id,
@@ -171,9 +184,15 @@ CREATE OR REPLACE VIEW ulog AS
         icmp_echoid,
         icmp_echoseq,
         icmp_gateway,
-        icmp_fragmtu
+        icmp_fragmtu,
+        icmpv6_type,
+        icmpv6_code,
+        icmpv6_echoid,
+        icmpv6_echoseq,
+        icmpv6_csum
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
-                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id;
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
+                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
 
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
@@ -285,6 +304,7 @@ INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
 
 CREATE OR REPLACE FUNCTION ULOG2_DROP_FOREIGN_KEYS()
 RETURNS void AS $$
+  ALTER TABLE icmpv6 DROP CONSTRAINT icmpv6_id_fk;
   ALTER TABLE icmp DROP CONSTRAINT icmp_id_fk;
   ALTER TABLE udp  DROP CONSTRAINT udp_id_fk;
   ALTER TABLE tcp  DROP CONSTRAINT tcp_id_fk;
@@ -296,6 +316,7 @@ RETURNS void AS $$
   ALTER TABLE tcp  ADD CONSTRAINT tcp_id_fk  FOREIGN KEY (_tcp_id)  REFERENCES ulog2(_id);
   ALTER TABLE udp  ADD CONSTRAINT udp_id_fk  FOREIGN KEY (_udp_id)  REFERENCES ulog2(_id);
   ALTER TABLE icmp ADD CONSTRAINT icmp_id_fk FOREIGN KEY (_icmp_id) REFERENCES ulog2(_id);
+  ALTER TABLE icmpv6 ADD CONSTRAINT icmpv6_id_fk FOREIGN KEY (_icmpv6_id) REFERENCES ulog2(_id);
 $$ LANGUAGE SQL SECURITY INVOKER;
 
 
@@ -395,6 +416,21 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_ICMPV6(
+                IN icmpv6_id bigint,
+                IN icmpv6_type integer,
+                IN icmpv6_code integer,
+                IN icmpv6_echoid integer,
+                IN icmpv6_echoseq integer,
+                IN icmpv6_csum integer
+        )
+RETURNS bigint AS $$
+        INSERT INTO icmpv6 (_icmpv6_id,icmpv6_type,icmpv6_code,icmpv6_echoid,icmpv6_echoseq,icmpv6_csum)
+                VALUES ($1,$2,$3,$4,$5,$6);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
+
 -- this function requires plpgsql
 -- su -c "createlang plpgsql ulog2" postgres
 CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
@@ -435,7 +471,12 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmp_echoid integer,
                 IN icmp_echoseq integer,
                 IN icmp_gateway integer,
-                IN icmp_fragmtu integer 
+                IN icmp_fragmtu integer,
+                IN icmpv6_type integer,
+                IN icmpv6_code integer,
+                IN icmpv6_echoid integer,
+                IN icmpv6_echoseq integer,
+                IN icmpv6_csum integer
         )
 RETURNS bigint AS $$
 DECLARE
@@ -445,9 +486,11 @@ BEGIN
         IF (ip_protocol = 6) THEN
                 PERFORM INSERT_TCP_FULL(_id,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29);
         ELSIF (ip_protocol = 17) THEN
-                PERFORM INSERT_UDP(_id,$30,$31,$32,$33);
+                PERFORM INSERT_UDP(_id,$30,$31,$32);
         ELSIF (ip_protocol = 1) THEN
-                PERFORM INSERT_ICMP(_id,$34,$35,$36,$37,$38,$39);
+                PERFORM INSERT_ICMP(_id,$33,$34,$35,$36,$37,$38);
+        ELSIF (ip_protocol = 58) THEN
+                PERFORM INSERT_ICMPV6(_id,$39,$40,$41,$42,$43);
         END IF;
         RETURN _id;
 END
-- 
1.5.2.5

