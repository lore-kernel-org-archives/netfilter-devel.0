From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] netfilter: xt_recent: inform user when hitcount is too large
Date: Fri, 12 Feb 2010 17:31:57 +0100
Message-ID: <1265992318-14872-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46295 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab0BLQcA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:32:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is one of these things that iptables cannot catch and which can
cause "Invalid argument" to be printed. Without a hint in dmesg, it is
not going to be helpful.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_recent.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 2033331..132cfaa 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -53,7 +53,7 @@ module_param(ip_list_perms, uint, 0400);
 module_param(ip_list_uid, uint, 0400);
 module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
-MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
+MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
 MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
@@ -306,8 +306,12 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
 		return false;
-	if (info->hit_count > ip_pkt_list_tot)
+	if (info->hit_count > ip_pkt_list_tot) {
+		pr_info(KBUILD_MODNAME ": hitcount (%u) is larger than "
+			"packets to be remembered (%u)\n",
+			info->hit_count, ip_pkt_list_tot);
 		return false;
+	}
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN)
 		return false;
-- 
1.6.6.1

