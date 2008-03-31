From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/4] Convert SQL procedure to function in MySQL plugins.
Date: Tue,  1 Apr 2008 01:09:48 +0200
Message-ID: <1207004990860-git-send-email-eric@inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41723 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbYCaXJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:09:52 -0400
In-Reply-To: <1207004990315-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

DB output plugins have been modified to use function instead of procedure.
This patch convert the conntrack insertion procedure to function.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |   56 +++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 6368dc7..d6c6d46 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -689,46 +689,48 @@ END
 $$
 
 delimiter $$
-DROP PROCEDURE IF EXISTS INSERT_CT;
-CREATE PROCEDURE INSERT_CT(
-		IN `_orig_ip_saddr` binary(16),
-		IN `_orig_ip_daddr` binary(16),
-		IN `_orig_ip_protocol` tinyint(3) unsigned,
-		IN `_orig_l4_sport` int(5),
-		IN `_orig_l4_dport` int(5),
-		IN `_orig_bytes` bigint,
-		IN `_orig_packets` bigint,
-		IN `_reply_ip_saddr` binary(16),
-		IN `_reply_ip_daddr` binary(16),
-		IN `_reply_ip_protocol` tinyint(3) unsigned,
-		IN `_reply_l4_sport` int(5),
-		IN `_reply_l4_dport` int(5),
-		IN `_reply_bytes` bigint,
-		IN `_reply_packets` bigint,
-		IN `_icmp_code` tinyint(3),
-		IN `_icmp_type` tinyint(3),
-		IN `_ct_mark` bigint,
-		IN `_flow_start_sec` int(10),
-		IN `_flow_start_usec` int(10),
-		IN `_flow_end_sec` int(10),
-		IN `_flow_end_usec` int(10)
-		)
+DROP FUNCTION IF EXISTS INSERT_CT;
+CREATE FUNCTION INSERT_CT(
+		`_oob_family` bigint,
+		`_orig_ip_saddr` binary(16),
+		`_orig_ip_daddr` binary(16),
+		`_orig_ip_protocol` tinyint(3) unsigned,
+		`_orig_l4_sport` int(5),
+		`_orig_l4_dport` int(5),
+		`_orig_bytes` bigint,
+		`_orig_packets` bigint,
+		`_reply_ip_saddr` binary(16),
+		`_reply_ip_daddr` binary(16),
+		`_reply_ip_protocol` tinyint(3) unsigned,
+		`_reply_l4_sport` int(5),
+		`_reply_l4_dport` int(5),
+		`_reply_bytes` bigint,
+		`_reply_packets` bigint,
+		`_icmp_code` tinyint(3),
+		`_icmp_type` tinyint(3),
+		`_ct_mark` bigint,
+		`_flow_start_sec` int(10),
+		`_flow_start_usec` int(10),
+		`_flow_end_sec` int(10),
+		`_flow_end_usec` int(10)
+		) RETURNS bigint unsigned
+READS SQL DATA
 BEGIN
-	INSERT INTO ulog2_ct (orig_ip_saddr, orig_ip_daddr, orig_ip_protocol,
+	INSERT INTO ulog2_ct (oob_family, orig_ip_saddr, orig_ip_daddr, orig_ip_protocol,
 		orig_l4_sport, orig_l4_dport, orig_bytes, orig_packets,
 		reply_ip_saddr, reply_ip_daddr, reply_ip_protocol,
 		reply_l4_sport, reply_l4_dport, reply_bytes, reply_packets,
 		icmp_code, icmp_type, ct_mark, 
 		flow_start_sec, flow_start_usec,
 		flow_end_sec, flow_end_usec)
- 	VALUES (_orig_ip_saddr, _orig_ip_daddr, _orig_ip_protocol,
+ 	VALUES (_oob_family, _orig_ip_saddr, _orig_ip_daddr, _orig_ip_protocol,
 		_orig_l4_sport, _orig_l4_dport, _orig_bytes, _orig_packets,
 		_reply_ip_saddr, _reply_ip_daddr, _reply_ip_protocol,
 		_reply_l4_sport, _reply_l4_dport, _reply_bytes, _reply_packets,
 		_icmp_code, _icmp_type, _ct_mark,
 		_flow_start_sec, _flow_start_usec,
 		_flow_end_sec, _flow_end_usec);
-
+	RETURN LAST_INSERT_ID();
 END
 $$
 
-- 
1.5.2.5

