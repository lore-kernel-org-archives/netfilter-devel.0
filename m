From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 082/103] netfilter: ip6tables: remove xt1 GET_INFO code
Date: Tue,  4 Aug 2009 09:26:06 +0200
Message-ID: <1249370787-17583-83-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56955 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbZHDH2A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:00 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |   60 ++++----------------------------------
 1 files changed, 7 insertions(+), 53 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 67f676f..fe420fb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1003,8 +1003,7 @@ static int get_info(struct net *net, void __user *user,
                     const int *len, int compat)
 {
 	char name[IP6T_TABLE_MAXNAMELEN];
-	struct xt2_table *xt2_table;
-	struct xt_table *t;
+	struct xt2_table *table;
 	int ret;
 
 	if (*len != sizeof(struct ip6t_getinfo)) {
@@ -1017,58 +1016,13 @@ static int get_info(struct net *net, void __user *user,
 		return -EFAULT;
 
 	name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
-				    "ip6table_%s", name);
-	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
-	            XT2_TAKE_RCULOCK);
-	if (xt2_table != NULL) {
-		ret = ip6t2_get_info(user, *len, xt2_table, compat);
-		rcu_read_unlock();
-		module_put(xt2_table->owner);
-		if (t != NULL)
-			module_put(t->me);
-		return ret;
-	}
+	table = try_then_request_module(xt2_table_lookup(net,
+	        name, NFPROTO_IPV6, XT2_TAKE_RCULOCK),
+	        "ip6table_%s", name);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ip6t2_get_info(user, *len, table, compat);
 	rcu_read_unlock();
-
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_lock(AF_INET6);
-#endif
-	if (t && !IS_ERR(t)) {
-		struct ip6t_getinfo info;
-		const struct xt_table_info *private = t->private;
-
-#ifdef CONFIG_COMPAT
-		if (compat) {
-			struct xt_table_info tmp;
-			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(AF_INET6);
-			private = &tmp;
-		}
-#endif
-		info.valid_hooks = t->valid_hooks;
-		memcpy(info.hook_entry, private->hook_entry,
-		       sizeof(info.hook_entry));
-		memcpy(info.underflow, private->underflow,
-		       sizeof(info.underflow));
-		info.num_entries = private->number;
-		info.size = private->size;
-		strcpy(info.name, name);
-
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
-
-		xt_table_unlock(t);
-		module_put(t->me);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_unlock(AF_INET6);
-#endif
 	return ret;
 }
 
-- 
1.6.3.3

