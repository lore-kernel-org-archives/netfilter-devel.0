From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 06/14] MAC address handling in MySQL output plugin.
Date: Sun, 23 Mar 2008 17:25:14 +0100
Message-ID: <12062895234125-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55060 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752884AbYCWQZ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:26 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds MAC address handling to the MySQL output plugin.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 1265eba..bb31339 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -72,14 +72,12 @@ ALTER TABLE ulog2 ADD KEY `timestamp` (`timestamp`);
 
 CREATE TABLE `mac` (
   `_mac_id` bigint unsigned NOT NULL,
-  `mac_saddr` binary(12) default NULL,
-  `mac_daddr` binary(12) default NULL,
+  `mac_saddr` varchar(32) default NULL,
   `mac_protocol` smallint(5) default NULL
 ) ENGINE=INNODB;
 
 ALTER TABLE mac ADD UNIQUE KEY `_mac_id` (`_mac_id`);
 ALTER TABLE mac ADD KEY `mac_saddr` (`mac_saddr`);
-ALTER TABLE mac ADD KEY `mac_daddr` (`mac_daddr`);
 ALTER TABLE mac ADD KEY `index_mac_id` (`_mac_id`);
 
 CREATE TABLE `tcp` (
@@ -213,10 +211,9 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
 	icmpv6_code,
 	icmpv6_echoid,
 	icmpv6_echoseq,
-	icmpv6_csum
---	mac_saddr,
---	mac_daddr,
---	mac_protocol,
+	icmpv6_csum,
+	mac_saddr as mac_saddr_str,
+	mac_protocol as oob_protocol
         FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
                 LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id
                 LEFT JOIN icmpv6 ON ulog2._id = icmpv6._icmpv6_id;
@@ -571,13 +568,12 @@ delimiter $$
 DROP PROCEDURE IF EXISTS PACKET_ADD_MAC;
 CREATE PROCEDURE PACKET_ADD_MAC(
 		IN `id` int(10) unsigned,
-		IN `_saddr` binary(12),
-		IN `_daddr` binary(12),
+		IN `_saddr` varchar(32),
 		IN `_protocol` smallint(5)
 		)
 BEGIN
-	INSERT INTO mac (_mac_id, mac_saddr, mac_daddr, mac_protocol) VALUES
-	(id, _saddr, _daddr, _protocol);
+	INSERT INTO mac (_mac_id, mac_saddr, mac_protocol) VALUES
+	(id, _saddr, _protocol);
 END
 $$
 
@@ -627,10 +623,9 @@ CREATE FUNCTION INSERT_PACKET_FULL(
 		icmpv6_code tinyint(3) unsigned,
 		icmpv6_echoid smallint(5) unsigned,
 		icmpv6_echoseq smallint(5) unsigned,
-		icmpv6_csum int(10) unsigned
---		mac_saddr binary(12),
---		mac_daddr binary(12),
---		mac_protocol smallint(5)
+		icmpv6_csum int(10) unsigned,
+		mac_saddr varchar(32),
+		mac_protocol smallint(5)
 		) RETURNS bigint unsigned
 READS SQL DATA
 BEGIN
@@ -652,9 +647,9 @@ BEGIN
 		CALL PACKET_ADD_ICMPV6(@lastid, icmpv6_type, icmpv6_code, icmpv6_echoid,
 				       icmpv6_echoseq, icmpv6_csum);
 	END IF;
---	IF mac_protocol IS NOT NULL THEN
---		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_daddr, mac_protocol);
---	END IF;
+	IF mac_protocol IS NOT NULL THEN
+		CALL PACKET_ADD_MAC(@lastid, mac_saddr, mac_protocol);
+	END IF;
 	RETURN @lastid;
 END
 $$
-- 
1.5.2.5

