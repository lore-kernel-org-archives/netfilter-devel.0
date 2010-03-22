From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] netfilter: xt_recent: allow changing ip_list_[ug]id at runtime
Date: Mon, 22 Mar 2010 20:18:01 +0100
Message-ID: <1269285486-22653-6-git-send-email-jengelh@medozas.de>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42173 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0CVTSP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:15 -0400
In-Reply-To: <1269285486-22653-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_recent.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 72cbced..8530944 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -51,14 +51,14 @@ module_param(ip_list_tot, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
-module_param(ip_list_uid, uint, 0400);
-module_param(ip_list_gid, uint, 0400);
+module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
+module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
-MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
-MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/xt_recent/* files");
+MODULE_PARM_DESC(ip_list_uid, "default owner of /proc/net/xt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* files");
 
 struct recent_entry {
 	struct list_head	list;
-- 
1.7.0.2

