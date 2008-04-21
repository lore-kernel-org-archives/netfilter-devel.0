From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD PATCH 3/4] Add function and some view to display IP addresses as strings (MySQL)
Date: Mon, 21 Apr 2008 23:58:25 +0200
Message-ID: <1208815106-3315-4-git-send-email-chifflier@inl.fr>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:52258
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035AbYDUVy5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:54:57 -0400
In-Reply-To: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce function to convert binary data to printable strings.
Update view_tcp_quad and view_udp_quad.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
:100644 100644 bcd3ab8... ba50f48... M	doc/mysql-ulogd2.sql
 doc/mysql-ulogd2.sql |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index bcd3ab8..ba50f48 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -222,13 +222,48 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
 
 
 -- shortcuts
+DROP FUNCTION IF EXISTS BIN_TO_IPV6;
+delimiter $$
+CREATE FUNCTION BIN_TO_IPV6(
+		_in binary(16)
+                ) RETURNS varchar(64)
+SQL SECURITY INVOKER
+DETERMINISTIC
+COMMENT 'Convert binary ip to printable string'
+BEGIN
+	-- IPv4 address in IPv6 form
+	IF HEX(SUBSTRING(_in, 1, 12)) = '00000000000000000000FFFF' THEN
+		RETURN CONCAT(
+			'::ffff:',
+			ASCII(SUBSTRING(_in, 13, 1)), '.',
+			ASCII(SUBSTRING(_in, 14, 1)), '.',
+			ASCII(SUBSTRING(_in, 15, 1)), '.',
+			ASCII(SUBSTRING(_in, 16, 1))
+		);
+	END IF;
+	-- return the full IPv6 form
+	RETURN LOWER(CONCAT(
+		HEX(SUBSTRING(_in,  1, 2)), ':',
+		HEX(SUBSTRING(_in,  3, 2)), ':',
+		HEX(SUBSTRING(_in,  5, 2)), ':',
+		HEX(SUBSTRING(_in,  7, 2)), ':',
+		HEX(SUBSTRING(_in,  9, 2)), ':',
+		HEX(SUBSTRING(_in, 11, 2)), ':',
+		HEX(SUBSTRING(_in, 13, 2)), ':',
+		HEX(SUBSTRING(_in, 15, 2))
+	));
+END
+$$
+delimiter ;
+
+
 DROP VIEW IF EXISTS `view_tcp_quad`;
 CREATE SQL SECURITY INVOKER VIEW `view_tcp_quad` AS
-        SELECT ulog2._id,ulog2.ip_saddr,tcp.tcp_sport,ulog2.ip_daddr,tcp.tcp_dport FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id;
+	SELECT ulog2._id,BIN_TO_IPV6(ulog2.ip_saddr) AS ip_saddr_str,tcp.tcp_sport,BIN_TO_IPV6(ulog2.ip_daddr) AS ip_daddr_str,tcp.tcp_dport FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id;
 
 DROP VIEW IF EXISTS `view_udp_quad`;
 CREATE SQL SECURITY INVOKER VIEW `view_udp_quad` AS
-        SELECT ulog2._id,ulog2.ip_saddr,udp.udp_sport,ulog2.ip_daddr,udp.udp_dport FROM ulog2 INNER JOIN udp ON ulog2._id = udp._udp_id;
+	SELECT ulog2._id,BIN_TO_IPV6(ulog2.ip_saddr) AS ip_saddr_str,udp.udp_sport,BIN_TO_IPV6(ulog2.ip_daddr) AS ip_daddr_str,udp.udp_dport FROM ulog2 INNER JOIN udp ON ulog2._id = udp._udp_id;
 
 
 
-- 
1.5.5

