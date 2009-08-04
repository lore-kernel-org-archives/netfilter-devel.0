From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 069/103] netfilter: xtables2: xt2->xt1 translation - compat GET_INFO support
Date: Tue,  4 Aug 2009 09:25:53 +0200
Message-ID: <1249370787-17583-70-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbZHDH1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:47 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c4bcea6..2f14ef4 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1165,8 +1165,21 @@ static int compat_table_info(const struct xt_table_info *info,
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
@@ -1177,7 +1190,7 @@ static const struct xt1_xlat_info ip6t_xlat_info = {
 };
 
 static int ip6t2_get_info(void __user *uptr, int len,
-                          struct xt2_table *table)
+                          struct xt2_table *table, bool compat)
 {
 	struct ip6t_getinfo info = {
 		.valid_hooks = table->valid_hooks,
@@ -1185,7 +1198,8 @@ static int ip6t2_get_info(void __user *uptr, int len,
 
 	strncpy(info.name, table->name,
 	        min(sizeof(info.name), sizeof(table->name)));
-	info.size = xts_blob_prep_table(table, &ip6t_xlat_info,
+	info.size = xts_blob_prep_table(table,
+	            compat ? &ip6t_compat_xlat_info : &ip6t_xlat_info,
 	            info.hook_entry, info.underflow, &info.num_entries);
 	return (copy_to_user(uptr, &info, sizeof(info)) != 0) ? -EFAULT : 0;
 }
@@ -1213,7 +1227,7 @@ static int get_info(struct net *net, void __user *user,
 	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
 	            XT2_TAKE_RCULOCK);
 	if (xt2_table != NULL) {
-		ret = ip6t2_get_info(user, *len, xt2_table);
+		ret = ip6t2_get_info(user, *len, xt2_table, compat);
 		rcu_read_unlock();
 		module_put(xt2_table->owner);
 		if (t != NULL)
-- 
1.6.3.3

