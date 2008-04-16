From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/7] Add label support to MySQL schema.
Date: Wed, 16 Apr 2008 15:22:36 +0200
Message-ID: <12083521611251-git-send-email-eric@inl.fr>
References: <4805E566.7010902@netfilter.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33227 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761321AbYDPNWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:22:44 -0400
In-Reply-To: <4805E566.7010902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for label_t table in the MySQL schema.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 ed8d982... 72575b3... M	doc/mysql-ulogd2.sql
 doc/mysql-ulogd2.sql |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index ed8d982..72575b3 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -139,6 +139,19 @@ CREATE TABLE `icmpv6` (
 ALTER TABLE icmpv6 ADD UNIQUE KEY `key_icmpv6_id` (`_icmpv6_id`);
 ALTER TABLE icmpv6 ADD KEY `index_icmpv6_id` (`_icmpv6_id`);
 
+-- State
+CREATE TABLE `label_t` (
+  `_label_id` bigint unsigned NOT NULL,
+  label tinyint(3) unsigned
+) ENGINE=INNODB;
+
+ALTER TABLE label_t ADD UNIQUE KEY `_label_id` (`_label_id`);
+ALTER TABLE label_t ADD KEY `index_label_id` (`_label_id`);
+ALTER TABLE label_t ADD KEY `label` (`label`);
+ALTER TABLE label_t ADD FOREIGN KEY (_label_id) REFERENCES ulog2 (_id);
+
+INSERT INTO _extensions (ext_name,table_name,join_name) VALUES
+        ('label','label_t','_label_id');
 
 -- views
 
@@ -213,10 +226,11 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
 	icmpv6_echoseq,
 	icmpv6_csum,
 	mac_saddr as mac_saddr_str,
-	mac_protocol as oob_protocol
+	mac_protocol as oob_protocol,
+	label as raw_label
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
-                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
+                LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id LEFT JOIN label_t ON ulog2._id = label_t._label_id;
 
 
 -- shortcuts
@@ -578,6 +592,18 @@ END
 $$
 
 delimiter $$
+DROP PROCEDURE IF EXISTS PACKET_ADD_LABEL;
+CREATE PROCEDURE PACKET_ADD_LABEL(
+		IN `id` int(10) unsigned,
+		IN `_label` tinyint(4)
+		)
+BEGIN
+	INSERT INTO label_t (_label_id, label) VALUES (id, _label);
+END
+$$
+
+
+delimiter $$
 DROP FUNCTION IF EXISTS INSERT_PACKET_FULL;
 CREATE FUNCTION INSERT_PACKET_FULL(
 		_oob_time_sec int(10) unsigned,
@@ -625,7 +651,8 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_echoseq smallint(5) unsigned,
 		icmpv6_csum int(10) unsigned,
 		mac_saddr varchar(32),
-		mac_protocol smallint(5)
+		mac_protocol smallint(5),
+		label tinyint(4)
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
@@ -650,6 +677,10 @@ BEGIN
 	IF mac_protocol IS NOT NULL THEN
 		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_protocol);
 	END IF;
+	IF label IS NOT NULL THEN
+		CALL PACKET_ADD_LABEL(@lastid, label);
+	END IF;
+
 	RETURN @lastid;
 END
 $$
-- 
1.5.2.5

