From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 087/103] netfilter: ip6tables: remove xt1 ADD_COUNTERS code
Date: Tue,  4 Aug 2009 09:26:11 +0200
Message-ID: <1249370787-17583-88-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbZHDH2G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:06 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |   61 +++-----------------------------------
 1 files changed, 5 insertions(+), 56 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 69fe30d..0bd646d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -869,19 +869,13 @@ static int
 do_add_counters(struct net *net, const void __user *user, unsigned int len,
 		int compat)
 {
-	unsigned int i, curcpu;
 	struct xt_counters_info tmp;
-	struct xt_counters *paddc;
 	unsigned int num_counters;
 	char *name;
 	int size;
 	void *ptmp;
-	struct xt_table *t;
-	const struct xt_table_info *private;
 	int ret = 0;
-	const void *loc_cpu_entry;
-	struct ip6t_entry *iter;
-	struct xt2_table *xt2_table;
+	struct xt2_table *table;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -912,56 +906,11 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	if (len != size + num_counters * sizeof(struct xt_counters))
 		return -EINVAL;
 
-	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
-	            XT2_TAKE_RCULOCK);
-	if (xt2_table != NULL) {
-		ret = xts_get_counters(xt2_table, user + size, num_counters);
-		rcu_read_unlock();
-		return ret;
-	}
+	table = xt2_table_lookup(net, name, NFPROTO_IPV6, XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = xts_get_counters(table, user + size, num_counters);
 	rcu_read_unlock();
-
-	paddc = vmalloc_node(len - size, numa_node_id());
-	if (!paddc)
-		return -ENOMEM;
-
-	if (copy_from_user(paddc, user + size, len - size) != 0) {
-		ret = -EFAULT;
-		goto free;
-	}
-
-	t = xt_find_table_lock(net, AF_INET6, name);
-	if (!t || IS_ERR(t)) {
-		ret = t ? PTR_ERR(t) : -ENOENT;
-		goto free;
-	}
-
-
-	local_bh_disable();
-	private = t->private;
-	if (private->number != num_counters) {
-		ret = -EINVAL;
-		goto unlock_up_free;
-	}
-
-	i = 0;
-	/* Choose the copy that is on our node */
-	curcpu = smp_processor_id();
-	xt_info_wrlock(curcpu);
-	loc_cpu_entry = private->entries[curcpu];
-	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
-		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
-		++i;
-	}
-	xt_info_wrunlock(curcpu);
-
- unlock_up_free:
-	local_bh_enable();
-	xt_table_unlock(t);
-	module_put(t->me);
- free:
-	vfree(paddc);
-
 	return ret;
 }
 
-- 
1.6.3.3

