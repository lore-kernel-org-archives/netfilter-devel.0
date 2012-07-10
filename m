From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/4] netfilter: cleanup use of the term "IPs"
Date: Wed, 11 Jul 2012 01:52:28 +0200
Message-ID: <1341964350-13809-3-git-send-email-jengelh@inai.de>
References: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54421 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2GJXwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:37 -0400
In-Reply-To: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Seen meticulously, we have two IPs these days (Internet Protocol 4,
and 6). Clean up and explicitly use "IP addresses" to disambiguate.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/ipvs/Kconfig |   15 ++++++++-------
 net/netfilter/xt_recent.c  |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index f987138..e098980 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -238,13 +238,14 @@ config IP_VS_SH_TAB_BITS
 	range 4 20
 	default 8
 	---help---
-	  The source hashing scheduler maps source IPs to destinations
-	  stored in a hash table. This table is tiled by each destination
-	  until all slots in the table are filled. When using weights to
-	  allow destinations to receive more connections, the table is
-	  tiled an amount proportional to the weights specified. The table
-	  needs to be large enough to effectively fit all the destinations
-	  multiplied by their respective weights.
+	  The source hashing scheduler maps source IP addresses to
+	  destinations stored in a hash table. This table is tiled by
+	  each destination until all slots in the table are filled.
+	  When using weights to allow destinations to receive more
+	  connections, the table is tiled an amount proportional to
+	  the weights specified. The table needs to be large enough
+	  to effectively fit all the destinations multiplied by their
+	  respective weights.
 
 comment 'IPVS application helper'
 
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index b980b3f..0acc17f 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -53,9 +53,9 @@ module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
 module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
 module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list (>0)");
+MODULE_PARM_DESC(ip_list_tot, "number of IP addresses to remember per list (>0)");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (1-255)");
-MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
+MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IP addresses");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
 MODULE_PARM_DESC(ip_list_uid, "default owner of /proc/net/xt_recent/* files");
 MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* files");
-- 
1.7.7

