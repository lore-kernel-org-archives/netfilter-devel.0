From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 23/56] netfilter: xtables2: xt2->xt1 translation - compat GET_INFO support
Date: Tue, 29 Jun 2010 10:43:03 +0200
Message-ID: <1277801017-30600-24-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44268 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab0F2IoF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:05 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 80177a5..14804f2 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1188,8 +1188,21 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
+static const struct xt1_xlat_info ip6t_compat_xlat_info = {
+#ifdef CONFIG_COMPAT
+	.marker_size     = COMPAT_XT_ALIGN(sizeof(struct ip6t_error_target)),
+	.entry_hdr_size  = sizeof(struct compat_ip6t_entry),
+	.pmatch_size     = sizeof(struct ip6t_ip6),
+	.first_match     = "ipv6",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = COMPAT_XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(compat_uint_t)),
+#endif
+};
+
 static const struct xt1_xlat_info ip6t_xlat_info = {
-	.marker_size     = sizeof(struct ip6t_error_target),
+	.marker_size     = XT_ALIGN(sizeof(struct ip6t_error_target)),
 	.entry_hdr_size  = sizeof(struct ip6t_entry),
 	.pmatch_size     = sizeof(struct ip6t_ip6),
 	.first_match     = "ipv6",
@@ -1200,7 +1213,7 @@ static const struct xt1_xlat_info ip6t_xlat_info = {
 };
 
 static int ip6t2_get_info(void __user *uptr, int len,
-			  struct xt2_table *table)
+			  struct xt2_table *table, bool compat)
 {
 	struct ip6t_getinfo info = {
 		.valid_hooks = table->valid_hooks,
@@ -1208,7 +1221,9 @@ static int ip6t2_get_info(void __user *uptr, int len,
 
 	strncpy(info.name, table->name,
 		min(sizeof(info.name), sizeof(table->name)));
-	info.size = xts_blob_prep_table(table, &ip6t_xlat_info,
+	info.size = xts_blob_prep_table(table,
+					compat ? &ip6t_compat_xlat_info :
+					&ip6t_xlat_info,
 					info.hook_entry, info.underflow,
 					&info.num_entries);
 	return (copy_to_user(uptr, &info, sizeof(info)) != 0) ? -EFAULT : 0;
@@ -1237,7 +1252,7 @@ static int get_info(struct net *net, void __user *user,
 	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
 				     XT2_KEEP_RCULOCK);
 	if (xt2_table != NULL) {
-		ret = ip6t2_get_info(user, *len, xt2_table);
+		ret = ip6t2_get_info(user, *len, xt2_table, compat);
 		rcu_read_unlock();
 		module_put(xt2_table->owner);
 		if (t != NULL)
-- 
1.7.1

