From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 083/103] netfilter: ip6tables: remove xt1 GET_ENTRIES code
Date: Tue,  4 Aug 2009 09:26:07 +0200
Message-ID: <1249370787-17583-84-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56957 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbZHDH2C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:02 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |   75 +++++++-------------------------------
 1 files changed, 14 insertions(+), 61 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index fe420fb..8535995 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1032,8 +1032,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 {
 	int ret;
 	struct ip6t_get_entries get;
-	struct xt2_table *xt2_table;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
@@ -1047,33 +1046,13 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	xt2_table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
-	            XT2_TAKE_RCULOCK);
-	if (xt2_table != NULL) {
-		ret = ip6t2_table_to_xt1(uptr->entrytable, get.size,
-		      xt2_table, &ip6t_xlat_info);
-		rcu_read_unlock();
-		return ret;
-	}
+	table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
+	        XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ip6t2_table_to_xt1(uptr->entrytable, get.size,
+	      table, &ip6t_xlat_info);
 	rcu_read_unlock();
-
-	t = xt_find_table_lock(net, AF_INET6, get.name);
-	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
-		duprintf("t->private->number = %u\n", private->number);
-		if (get.size == private->size)
-			ret = copy_entries_to_user(private->size,
-						   t, uptr->entrytable);
-		else {
-			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
-			ret = -EAGAIN;
-		}
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-
 	return ret;
 }
 
@@ -1829,8 +1808,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 {
 	int ret;
 	struct compat_ip6t_get_entries get;
-	struct xt2_table *xt2_table;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
@@ -1846,38 +1824,13 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	xt2_table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
-	            XT2_TAKE_RCULOCK);
-	if (xt2_table != NULL) {
-		ret = ip6t2_compat_table_to_xt1(uptr->entrytable, get.size,
-		      xt2_table, &ip6t_compat_xlat_info);
-		rcu_read_unlock();
-		return ret;
-	}
+	table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
+	        XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ip6t2_compat_table_to_xt1(uptr->entrytable, get.size,
+	      table, &ip6t_compat_xlat_info);
 	rcu_read_unlock();
-
-	xt_compat_lock(AF_INET6);
-	t = xt_find_table_lock(net, AF_INET6, get.name);
-	if (t && !IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-		struct xt_table_info info;
-		duprintf("t->private->number = %u\n", private->number);
-		ret = compat_table_info(private, &info);
-		if (!ret && get.size == info.size) {
-			ret = compat_copy_entries_to_user(private->size,
-							  t, uptr->entrytable);
-		} else if (!ret) {
-			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
-			ret = -EAGAIN;
-		}
-		xt_compat_flush_offsets(AF_INET6);
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-
-	xt_compat_unlock(AF_INET6);
 	return ret;
 }
 
-- 
1.6.3.3

