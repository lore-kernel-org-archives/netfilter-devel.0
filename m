From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 09/14] Add state support to MySQL schema.
Date: Sun, 23 Mar 2008 17:25:17 +0100
Message-ID: <12062895233264-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55050 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752818AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for state_t table in the MySQL schema.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   51 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index bb31339..304173b 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -139,6 +139,19 @@ CREATE TABLE `icmpv6` (
 ALTER TABLE icmpv6 ADD UNIQUE KEY `key_icmpv6_id` (`_icmpv6_id`);
 ALTER TABLE icmpv6 ADD KEY `index_icmpv6_id` (`_icmpv6_id`);
 
+-- State
+CREATE TABLE `state_t` (
+  `_state_id` bigint unsigned NOT NULL,
+  state tinyint(3) unsigned
+) ENGINE=INNODB;
+
+ALTER TABLE state_t ADD UNIQUE KEY `_state_id` (`_state_id`);
+ALTER TABLE state_t ADD KEY `index_state_id` (`_state_id`);
+ALTER TABLE state_t ADD KEY `state` (`state`);
+ALTER TABLE state_t ADD FOREIGN KEY (_state_id) REFERENCES ulog2 (_id);
+
+INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
+        ('state','state_t','_state_id');
 
 -- views
 
@@ -213,10 +226,11 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
 	icmpv6_echoseq,
 	icmpv6_csum,
 	mac_saddr as mac_saddr_str,
-	mac_protocol as oob_protocol
+	mac_protocol as oob_protocol,
+	state as raw_state
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
-                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id LEFT JOIN state_t ON ulog2._id = state_t._state_id;
 
 
 -- shortcuts
@@ -329,20 +343,6 @@ INSERT INTO ip_proto (_proto_id,proto_name,proto_desc) VALUES
         (41,'ipv6','Internet Protocol, version 6'),
         (58,'ipv6-icmp','ICMP for IPv6');
 
--- State
-CREATE TABLE `state_t` (
-  `_state_id` bigint unsigned NOT NULL,
-  state tinyint(3) unsigned
-) ENGINE=INNODB;
-
-ALTER TABLE state_t ADD UNIQUE KEY `_state_id` (`_state_id`);
-ALTER TABLE state_t ADD KEY `index_state_id` (`_state_id`);
-ALTER TABLE state_t ADD KEY `state` (`state`);
-ALTER TABLE state_t ADD FOREIGN KEY (_state_id) REFERENCES ulog2 (_id);
-
-INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
-        ('state','state_t','_state_id');
-
 -- NuFW specific
 
 CREATE TABLE `nufw` (
@@ -578,6 +578,18 @@ END
 $$
 
 delimiter $$
+DROP PROCEDURE IF EXISTS PACKET_ADD_STATE;
+CREATE PROCEDURE PACKET_ADD_STATE(
+		IN `id` int(10) unsigned,
+		IN `_state` tinyint(4)
+		)
+BEGIN
+	INSERT INTO state_t (_state_id, state) VALUES (id, _state);
+END
+$$
+
+
+delimiter $$
 DROP FUNCTION IF EXISTS INSERT_PACKET_FULL;
 CREATE FUNCTION INSERT_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
@@ -625,7 +637,8 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_echoseq smallint(5) unsigned,
 		icmpv6_csum int(10) unsigned,
 		mac_saddr varchar(32),
-		mac_protocol smallint(5)
+		mac_protocol smallint(5),
+		state tinyint(4)
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
@@ -650,6 +663,10 @@ BEGIN
 	IF mac_protocol IS NOT NULL THEN
 		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_protocol);
 	END IF;
+	IF state IS NOT NULL THEN
+		CALL PACKET_ADD_STATE(@lastid, state);
+	END IF;
+
 	RETURN @lastid;
 END
 $$
-- 
1.5.2.5

