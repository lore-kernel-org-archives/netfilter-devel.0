From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/6] Add destination mac_addr to database
Date: Thu, 19 Jun 2008 14:23:06 +0200
Message-ID: <1213878187-909-6-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60862 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311AbYFSMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:32 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

This patch adds support for logging the destination mac address in
the SQL databases.
A tuple (mac_saddr,mac_daddr,mac_proto) is logged only once.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   32 ++++++++++++++++++--------------
 doc/pgsql-ulogd2.sql |   13 +++++++++----
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 8659c38..43a63d0 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -75,11 +75,12 @@ ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
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
 
 CREATE TABLE `tcp` (
@@ -176,8 +177,8 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
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
@@ -209,14 +210,15 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
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
+        mac_saddr as mac_saddr_str,
+        mac_daddr as mac_daddr_str,
+        mac_protocol as oob_protocol,
+        label as raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
@@ -607,13 +609,14 @@ delimiter $$
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
@@ -666,6 +669,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_echoseq smallint(5) unsigned,
 		icmpv6_csum int(10) unsigned,
 		mac_saddr varchar(32),
+		mac_daddr varchar(32),
 		mac_protocol smallint(5),
 		_label tinyint(4) unsigned
 		) RETURNS bigint unsigned
@@ -690,7 +694,7 @@ BEGIN
 				       icmpv6_echoseq, icmpv6_csum);
 	END IF;
 	IF mac_protocol IS NOT NULL THEN
-		SET @mac_id = INSERT_OR_SELECT_MAC(mac_saddr, mac_protocol);
+		SET @mac_id = INSERT_OR_SELECT_MAC(mac_saddr, mac_daddr, mac_protocol);
 		IF @mac_id IS NOT NULL THEN
 			UPDATE ulog2 SET mac_id = @mac_id WHERE _id = @lastid;
 		END IF;
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index b7e0038..51917fa 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -72,11 +72,13 @@ CREATE SEQUENCE mac__id_seq;
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
 
 CREATE TABLE tcp (
   _tcp_id bigint PRIMARY KEY UNIQUE NOT NULL,
@@ -196,6 +198,7 @@ CREATE OR REPLACE VIEW ulog AS
         icmpv6_echoseq,
         icmpv6_csum,
         mac_saddr AS mac_saddr_str,
+        mac_daddr AS mac_daddr_str,
         mac_protocol AS oob_protocol,
         label AS raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
@@ -445,15 +448,16 @@ $$ LANGUAGE SQL SECURITY INVOKER;
 
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
+        SELECT INTO _id _mac_id FROM mac WHERE mac_saddr = $1 AND mac_daddr = $2 AND mac_protocol = $3;
         IF NOT FOUND THEN
-                INSERT INTO mac (mac_saddr,mac_protocol) VALUES ($1,$2) RETURNING _mac_id INTO _id;
+                INSERT INTO mac (mac_saddr,mac_daddr,mac_protocol) VALUES ($1,$2,$3) RETURNING _mac_id INTO _id;
                 RETURN _id;
         END IF;
         RETURN _id;
@@ -508,6 +512,7 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN icmpv6_echoseq integer,
                 IN icmpv6_csum integer,
                 IN mac_saddr varchar(32),
+                IN mac_daddr varchar(32),
                 IN mac_protocol integer,
                 IN label integer
         )
@@ -527,7 +532,7 @@ BEGIN
                 PERFORM INSERT_ICMPV6(t_id,$40,$41,$42,$43,$44);
         END IF;
         IF (mac_saddr IS NOT NULL) THEN
-                t_mac_id = INSERT_OR_SELECT_MAC($45::macaddr,$46);
+                t_mac_id = INSERT_OR_SELECT_MAC($45::macaddr,$46::macaddr,$47);
                 UPDATE ulog2 SET mac_id = t_mac_id WHERE _id = t_id;
         END IF;
         RETURN t_id;
-- 
1.5.5.3

