From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/2] Fix wrong definition of views in flat DB schema
Date: Thu, 17 Sep 2009 21:28:20 +0200
Message-ID: <1253215700-15032-3-git-send-email-chifflier@inl.fr>
References: <1253215700-15032-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr, Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49116 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZIQT2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:28:32 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id EDF989401F2
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:28:31 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id C5D4A9401C0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:28:28 +0200 (CEST)
In-Reply-To: <1253215700-15032-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Create views using the ip_protocol field (and not the oob_family).

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 doc/mysql-ulogd2-flat.sql |   12 ++++++------
 doc/pgsql-ulogd2-flat.sql |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/doc/mysql-ulogd2-flat.sql b/doc/mysql-ulogd2-flat.sql
index 11474c0..acac6aa 100644
--- a/doc/mysql-ulogd2-flat.sql
+++ b/doc/mysql-ulogd2-flat.sql
@@ -107,19 +107,19 @@ ALTER TABLE ulog2 ADD KEY `sctp_dport` (`sctp_dport`);
 
 DROP VIEW IF EXISTS `view_tcp`;
 CREATE SQL SECURITY INVOKER VIEW `view_tcp` AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 6;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 6;
 
 DROP VIEW IF EXISTS `view_udp`;
 CREATE SQL SECURITY INVOKER VIEW `view_udp` AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 17;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 17;
 
 DROP VIEW IF EXISTS `view_icmp`;
 CREATE SQL SECURITY INVOKER VIEW `view_icmp` AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 1;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 1;
 
 DROP VIEW IF EXISTS `view_icmpv6`;
 CREATE SQL SECURITY INVOKER VIEW `view_icmpv6` AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 58;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 58;
 
 -- ulog view
 DROP VIEW IF EXISTS `ulog`;
@@ -222,11 +222,11 @@ delimiter ;
 
 DROP VIEW IF EXISTS `view_tcp_quad`;
 CREATE SQL SECURITY INVOKER VIEW `view_tcp_quad` AS
-	SELECT _id,BIN_TO_IPV6(ip_saddr_bin) AS ip_saddr_str,tcp_sport,BIN_TO_IPV6(ip_daddr_bin) AS ip_daddr_str,tcp_dport FROM ulog2 WHERE ulog2.oob_family = 6;
+	SELECT _id,BIN_TO_IPV6(ip_saddr_bin) AS ip_saddr_str,tcp_sport,BIN_TO_IPV6(ip_daddr_bin) AS ip_daddr_str,tcp_dport FROM ulog2 WHERE ulog2.ip_protocol = 6;
 
 DROP VIEW IF EXISTS `view_udp_quad`;
 CREATE SQL SECURITY INVOKER VIEW `view_udp_quad` AS
-	SELECT _id,BIN_TO_IPV6(ip_saddr_bin) AS ip_saddr_str,udp_sport,BIN_TO_IPV6(ip_daddr_bin) AS ip_daddr_str,udp_dport FROM ulog2 WHERE ulog2.oob_family = 17;
+	SELECT _id,BIN_TO_IPV6(ip_saddr_bin) AS ip_saddr_str,udp_sport,BIN_TO_IPV6(ip_daddr_bin) AS ip_daddr_str,udp_dport FROM ulog2 WHERE ulog2.ip_protocol = 17;
 
 
 
diff --git a/doc/pgsql-ulogd2-flat.sql b/doc/pgsql-ulogd2-flat.sql
index cf1a07f..9ff0ec6 100644
--- a/doc/pgsql-ulogd2-flat.sql
+++ b/doc/pgsql-ulogd2-flat.sql
@@ -108,16 +108,16 @@ CREATE INDEX sctp_dport ON ulog2(sctp_dport);
 --
 
 CREATE OR REPLACE VIEW view_tcp AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 6;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 6;
 
 CREATE OR REPLACE VIEW view_udp AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 17;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 17;
 
 CREATE OR REPLACE VIEW view_icmp AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 1;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 1;
 
 CREATE OR REPLACE VIEW view_icmpv6 AS
-        SELECT * FROM ulog2 WHERE ulog2.oob_family = 58;
+        SELECT * FROM ulog2 WHERE ulog2.ip_protocol = 58;
 
 -- complete view
 CREATE OR REPLACE VIEW ulog AS
@@ -179,10 +179,10 @@ CREATE OR REPLACE VIEW ulog AS
 
 -- shortcuts
 CREATE OR REPLACE VIEW view_tcp_quad AS
-        SELECT _id,ip_saddr_str,tcp_sport,ip_daddr_str,tcp_dport FROM ulog2 WHERE ulog2.oob_family = 6;
+        SELECT _id,ip_saddr_str,tcp_sport,ip_daddr_str,tcp_dport FROM ulog2 WHERE ulog2.ip_protocol = 6;
 
 CREATE OR REPLACE VIEW view_udp_quad AS
-        SELECT _id,ip_saddr_str,udp_sport,ip_daddr_str,udp_dport FROM ulog2 WHERE ulog2.oob_family = 17;
+        SELECT _id,ip_saddr_str,udp_sport,ip_daddr_str,udp_dport FROM ulog2 WHERE ulog2.ip_protocol = 17;
 
 --
 -- conntrack
-- 
1.6.4.3

