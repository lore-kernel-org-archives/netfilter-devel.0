From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 31/34]  Switch from INNER JOIN to LEFT JOIN in ulog view.
Date: Sat,  2 Feb 2008 22:24:26 +0100
Message-ID: <12019874721188-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
 <12019874711187-git-send-email-eric@inl.fr>
 <12019874721299-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46040 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762295AbYBBWQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:06 -0500
In-Reply-To: <12019874721299-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch fixes an error in MySQL schema which causes MySQL view to be always
empty.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 6dc865a... eec6e69... M	doc/mysql-ulogd2.sql
 doc/mysql-ulogd2.sql |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 6dc865a..eec6e69 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -157,8 +157,8 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         oob_in,
 	oob_out,
 	oob_family,
-        ip_saddr as ip_saddr_bin,
-        ip_daddr as ip_daddr_bin,
+        ip_saddr AS ip_saddr_bin,
+        ip_daddr AS ip_daddr_bin,
         ip_protocol,
         ip_tos,
         ip_ttl,
@@ -188,8 +188,8 @@ CREATE SQL SECURITY INVOKER VIEW `ulog` AS
         icmp_echoseq,
         icmp_gateway,
         icmp_fragmtu
-        FROM ulog2 INNER JOIN tcp ON ulog2._id = tcp._tcp_id INNER JOIN udp ON ulog2._id = udp._udp_id
-                INNER JOIN icmp ON ulog2._id = icmp._icmp_id INNER JOIN mac ON ulog2._id = mac._mac_id;
+        FROM ulog2 LEFT JOIN tcp ON ulog2._id = tcp._tcp_id LEFT JOIN udp ON ulog2._id = udp._udp_id
+                LEFT JOIN icmp ON ulog2._id = icmp._icmp_id LEFT JOIN mac ON ulog2._id = mac._mac_id;
 
 -- shortcuts
 DROP VIEW IF EXISTS `view_tcp_quad`;
-- 
1.5.2.5

