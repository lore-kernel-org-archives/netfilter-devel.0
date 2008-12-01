From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 07/18] Add SCTP support to MySQL and PGSQL output.
Date: Mon,  1 Dec 2008 22:36:05 +0100
Message-ID: <1228167376-22101-8-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39311 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752529AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for SCTP in the MySQL and PGSQL
output plugins. It adds a dedicated SCTP table and modifies
the insert_packet_full procedure.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   43 ++++++++++++++++++++++++++++++++++++++++---
 doc/pgsql-ulogd2.sql |   41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index f1fc710..0c2973d 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -31,6 +31,7 @@ DROP TABLE IF EXISTS `mac`;
 DROP TABLE IF EXISTS `hwhdr`;
 DROP TABLE IF EXISTS `tcp`;
 DROP TABLE IF EXISTS `udp`;
+DROP TABLE IF EXISTS `sctp`;
 DROP TABLE IF EXISTS `icmp`;
 DROP TABLE IF EXISTS `icmpv6`;
 DROP TABLE IF EXISTS `nufw`;
@@ -128,6 +129,19 @@ ALTER TABLE udp ADD KEY `index_udp_id` (`_udp_id`);
 ALTER TABLE udp ADD KEY `udp_sport` (`udp_sport`);
 ALTER TABLE udp ADD KEY `udp_dport` (`udp_dport`);
 
+CREATE TABLE `sctp` (
+  `_sctp_id` bigint unsigned NOT NULL,
+  `sctp_sport` int(5) unsigned default NULL,
+  `sctp_dport` int(5) unsigned default NULL,
+  `sctp_csum` int(5) unsigned default NULL
+) ENGINE=INNODB;
+
+ALTER TABLE sctp ADD UNIQUE KEY `_sctp_id` (`_sctp_id`);
+ALTER TABLE sctp ADD KEY `index_sctp_id` (`_sctp_id`);
+ALTER TABLE sctp ADD KEY `sctp_sport` (`sctp_sport`);
+ALTER TABLE sctp ADD KEY `sctp_dport` (`sctp_dport`);
+
+
 CREATE TABLE `icmp` (
   `_icmp_id` bigint unsigned NOT NULL,
   `icmp_type` tinyint(3) unsigned default NULL,
@@ -231,10 +245,14 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         mac_saddr as mac_saddr_str,
         mac_daddr as mac_daddr_str,
         mac_protocol as oob_protocol,
-        label as raw_label
+        label as raw_label,
+        sctp_sport,
+        sctp_dport,
+        sctp_csum
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2.mac_id = mac._mac_id
-		LEFT JOIN hwhdr ON ulog2._id = hwhdr._hw_id LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+		LEFT JOIN hwhdr ON ulog2._id = hwhdr._hw_id LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id
+		LEFT JOIN sctp ON ulog2._id = sctp._sctp_id;
 
 
 -- shortcuts
@@ -579,6 +597,20 @@ END
 $$
 
 delimiter $$
+DROP PROCEDURE IF EXISTS PACKET_ADD_SCTP;
+CREATE PROCEDURE PACKET_ADD_SCTP(
+		IN `id` int(10) unsigned,
+		IN `_sport` smallint(5) unsigned,
+		IN `_dport` smallint(5) unsigned,
+		IN `_csum` smallint(5) unsigned
+		)
+BEGIN
+	INSERT INTO sctp (_sctp_id, sctp_sport, sctp_dport, sctp_csum) VALUES
+	(id, _sport, _dport, _csum);
+END
+$$
+
+delimiter $$
 DROP PROCEDURE IF EXISTS PACKET_ADD_ICMP;
 CREATE PROCEDURE PACKET_ADD_ICMP(
 		IN `id` int(10) unsigned,
@@ -699,7 +731,10 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		mac_saddr varchar(32),
 		mac_daddr varchar(32),
 		mac_protocol smallint(5),
-		_label tinyint(4) unsigned
+		_label tinyint(4) unsigned,
+		sctp_sport smallint(5) unsigned,
+		sctp_dport smallint(5) unsigned,
+		sctp_csum int(10) unsigned
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
@@ -714,6 +749,8 @@ BEGIN
 					 tcp_rst, tcp_syn, tcp_fin);
 	ELSEIF _ip_protocol = 17 THEN
 		CALL PACKET_ADD_UDP(@lastid, udp_sport, udp_dport, udp_len);
+	ELSEIF _ip_protocol = 132 THEN
+		CALL PACKET_ADD_SCTP(@lastid, sctp_sport, sctp_dport, sctp_csum);
 	ELSEIF _ip_protocol = 1 THEN
 		CALL PACKET_ADD_ICMP(@lastid, icmp_type, icmp_code, icmp_echoid, icmp_echoseq, 
 				     icmp_gateway, icmp_fragmtu);
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 9340801..73e038d 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -29,6 +29,7 @@ DROP TABLE IF EXISTS mac CASCADE;
 DROP TABLE IF EXISTS hwhdr CASCADE;
 DROP TABLE IF EXISTS tcp CASCADE;
 DROP TABLE IF EXISTS udp CASCADE;
+DROP TABLE IF EXISTS sctp CASCADE;
 DROP TABLE IF EXISTS icmp CASCADE;
 DROP TABLE IF EXISTS icmpv6 CASCADE;
 DROP TABLE IF EXISTS nufw CASCADE;
@@ -119,6 +120,16 @@ CREATE TABLE udp (
 CREATE INDEX udp_sport ON udp(udp_sport);
 CREATE INDEX udp_dport ON udp(udp_dport);
 
+CREATE TABLE sctp (
+  _sctp_id bigint PRIMARY KEY UNIQUE NOT NULL,
+  sctp_sport integer default NULL,
+  sctp_dport integer default NULL,
+  sctp_csum smallint default NULL
+) WITH (OIDS=FALSE);
+
+CREATE INDEX sctp_sport ON sctp(sctp_sport);
+CREATE INDEX sctp_dport ON sctp(sctp_dport);
+
 CREATE TABLE icmp (
   _icmp_id bigint PRIMARY KEY UNIQUE NOT NULL,
   icmp_type smallint default NULL,
@@ -206,8 +217,12 @@ CREATE OR REPLACE VIEW ulog AS
         mac_saddr AS mac_saddr_str,
         mac_daddr AS mac_daddr_str,
         mac_protocol AS oob_protocol,
-        label AS raw_label
+        label AS raw_label,
+        sctp_sport,
+        sctp_dport,
+        sctp_csum
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
+                LEFT JOIN sctp ON ulog2._id = sctp._sctp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id
                 LEFT JOIN mac ON ulog2.mac_id = mac._mac_id
                 LEFT JOIN hwhdr ON ulog2._id = hwhdr._hw_id
@@ -291,6 +306,7 @@ INSERT INTO ip_proto (_proto_id,proto_name,proto_desc) VALUES
         (6,'tcp','transmission control protocol'),
         (17,'udp','user datagram protocol'),
         (41,'ipv6','Internet Protocol, version 6'),
+        (132,'sctp','Stream Control Transmission Protocol'),
         (58,'ipv6-icmp','ICMP for IPv6');
 
 -- 
@@ -335,6 +351,7 @@ CREATE OR REPLACE FUNCTION ULOG2_ADD_FOREIGN_KEYS()
 RETURNS void AS $$
   ALTER TABLE tcp  ADD CONSTRAINT tcp_id_fk  FOREIGN KEY (_tcp_id)  REFERENCES ulog2(_id);
   ALTER TABLE udp  ADD CONSTRAINT udp_id_fk  FOREIGN KEY (_udp_id)  REFERENCES ulog2(_id);
+  ALTER TABLE sctp  ADD CONSTRAINT sctp_id_fk  FOREIGN KEY (_sctp_id)  REFERENCES ulog2(_id);
   ALTER TABLE icmp ADD CONSTRAINT icmp_id_fk FOREIGN KEY (_icmp_id) REFERENCES ulog2(_id);
   ALTER TABLE icmpv6 ADD CONSTRAINT icmpv6_id_fk FOREIGN KEY (_icmpv6_id) REFERENCES ulog2(_id);
   ALTER TABLE ulog2 ADD CONSTRAINT mac_id_fk FOREIGN KEY (mac_id) REFERENCES mac(_mac_id);
@@ -424,6 +441,18 @@ RETURNS bigint AS $$
         SELECT currval('ulog2__id_seq');
 $$ LANGUAGE SQL SECURITY INVOKER;
 
+CREATE OR REPLACE FUNCTION INSERT_SCTP(
+                IN sctp_id bigint,
+                IN sctp_sport integer,
+                IN sctp_dport integer,
+                IN sctp_csum integer
+        )
+RETURNS bigint AS $$
+        INSERT INTO sctp (_sctp_id,sctp_sport,sctp_dport,sctp_csum)
+                VALUES ($1,$2,$3,$4);
+        SELECT currval('ulog2__id_seq');
+$$ LANGUAGE SQL SECURITY INVOKER;
+
 CREATE OR REPLACE FUNCTION INSERT_ICMP(
                 IN icmp_id bigint,
                 IN icmp_type integer,
@@ -538,7 +567,10 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN mac_saddr varchar(32),
                 IN mac_daddr varchar(32),
                 IN mac_protocol integer,
-                IN label integer
+                IN label integer,
+                IN sctp_sport integer,
+                IN sctp_dport integer,
+                IN sctp_csum integer
         )
 RETURNS bigint AS $$
 DECLARE
@@ -550,6 +582,8 @@ BEGIN
                 PERFORM INSERT_TCP_FULL(t_id,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30);
         ELSIF (ip_protocol = 17) THEN
                 PERFORM INSERT_UDP(t_id,$31,$32,$33);
+        ELSIF (ip_protocol = 132) THEN
+                PERFORM INSERT_SCTP(t_id,$51,$52,$53);
         ELSIF (ip_protocol = 1) THEN
                 PERFORM INSERT_ICMP(t_id,$34,$35,$36,$37,$38,$39);
         ELSIF (ip_protocol = 58) THEN
@@ -677,6 +711,7 @@ RETURNS void AS $$
   DELETE FROM icmp  WHERE icmp._icmp_id = $1;
   DELETE FROM tcp   WHERE tcp._tcp_id   = $1;
   DELETE FROM udp   WHERE udp._udp_id   = $1;
+  DELETE FROM sctp   WHERE sctp._sctp_id   = $1;
   DELETE FROM ulog2 WHERE ulog2._id     = $1;
 $$ LANGUAGE SQL SECURITY INVOKER;
 
@@ -717,10 +752,12 @@ RETURNS void AS $$
   -- DELETE FROM tcp WHERE _tcp_id IN (SELECT tcp._tcp_id FROM tcp LEFT OUTER JOIN ulog2  ON (tcp._tcp_id = ulog2._id) WHERE ulog2._id IS NULL);
   DELETE FROM mac WHERE _mac_id NOT IN (SELECT _id FROM ulog2);
   DELETE FROM udp WHERE _udp_id NOT IN (SELECT _id FROM ulog2);
+  DELETE FROM sctp WHERE _sctp_id NOT IN (SELECT _id FROM ulog2);
   DELETE FROM icmp WHERE _icmp_id NOT IN (SELECT _id FROM ulog2);
   -- look for packets in table ulog2 with proto tcp (or ipv6 ?) and not in table tcp
   DELETE FROM ulog2 WHERE ulog2.ip_protocol = '6' AND _id NOT IN (SELECT _tcp_id FROM tcp);
   DELETE FROM ulog2 WHERE ulog2.ip_protocol = '17' AND _id NOT IN (SELECT _udp_id FROM udp);
+  DELETE FROM ulog2 WHERE ulog2.ip_protocol = '132' AND _id NOT IN (SELECT _sctp_id FROM sctp);
   DELETE FROM ulog2 WHERE ulog2.ip_protocol = '2' AND _id NOT IN (SELECT _icmp_id FROM icmp);
 $$ LANGUAGE SQL SECURITY INVOKER;
 
-- 
1.5.6.3

