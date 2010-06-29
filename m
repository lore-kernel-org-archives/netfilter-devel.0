From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 22/56] netfilter: xtables2: xt1->xt2 translation - ADD_COUNTERS support
Date: Tue, 29 Jun 2010 10:43:02 +0200
Message-ID: <1277801017-30600-23-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44281 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0F2IoE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:04 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +
 net/ipv6/netfilter/ip6_tables.c    |   11 ++++++
 net/netfilter/xt1_support.c        |   63 ++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index d672b3d..99d05ba 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -739,6 +739,8 @@ extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
 			     const struct xt2_entry_target *);
 extern int xts_table_replace(void __user *, unsigned int, struct net *,
 			     struct xt2_table *);
+extern int xts_get_counters(struct xt2_table *,
+			    const struct xt_counters __user *, unsigned int);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 78dca6f..80177a5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1239,6 +1239,7 @@ static int get_info(struct net *net, void __user *user,
 	if (xt2_table != NULL) {
 		ret = ip6t2_get_info(user, *len, xt2_table);
 		rcu_read_unlock();
+		module_put(xt2_table->owner);
 		if (t != NULL)
 			module_put(t->me);
 		return ret;
@@ -1482,6 +1483,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	int ret = 0;
 	const void *loc_cpu_entry;
 	struct ip6t_entry *iter;
+	struct xt2_table *xt2_table;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1512,6 +1514,15 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	if (len != size + num_counters * sizeof(struct xt_counters))
 		return -EINVAL;
 
+	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
+				     XT2_KEEP_RCULOCK);
+	if (xt2_table != NULL) {
+		ret = xts_get_counters(xt2_table, user + size, num_counters);
+		rcu_read_unlock();
+		return ret;
+	}
+	rcu_read_unlock();
+
 	paddc = vmalloc(len - size);
 	if (!paddc)
 		return -ENOMEM;
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index d87e0ab..675428c 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -88,6 +88,23 @@ void xts_rule_get_quota(const struct xt2_entry_match *ematch,
 }
 EXPORT_SYMBOL_GPL(xts_rule_get_quota);
 
+static void xts_rule_set_quota(const struct xt2_entry_match *ematch,
+			       uint64_t bytes, uint64_t pkts)
+{
+	const struct xt_quota_mtinfo3 *q;
+
+	/* Bytes */
+	q = ematch->data;
+	spin_lock_bh(&q->master->lock);
+	q->master->quota = bytes;
+	spin_unlock_bh(&q->master->lock);
+	/* Packets */
+	q = list_entry(ematch->anchor.next, typeof(*ematch), anchor)->data;
+	spin_lock_bh(&q->master->lock);
+	q->master->quota = pkts;
+	spin_unlock_bh(&q->master->lock);
+}
+
 static int
 xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
 		   unsigned int *underflow, unsigned int z)
@@ -326,4 +343,50 @@ int xts_table_replace(void __user *counters_ptr, unsigned int num_counters,
 }
 EXPORT_SYMBOL_GPL(xts_table_replace);
 
+/**
+ * @table:	xt2 table with rules to modify
+ * @ptr:	source counter array
+ * @cnum:	maximum number of counters to read
+ */
+int xts_get_counters(struct xt2_table *table,
+		     const struct xt_counters __user *ptr, unsigned int cnum)
+{
+	const struct xt2_entry_match *ematch;
+	const struct xt2_chain *chain;
+	const struct xt2_rule *rule;
+	struct xt_counters ctinfo;
+	unsigned int i = 0;
+	int ret = 0;
+
+	rcu_read_lock();
+	list_for_each_entry(chain, &table->chain_list, anchor) {
+		if (i == cnum)
+			break;
+		if (!xt2_builtin_chain(chain))
+			/* Skip counters for start-of-chain marker */
+			++i;
+
+		list_for_each_entry(rule, &chain->rule_list, anchor) {
+			if (i == cnum)
+				break;
+			ematch = xts_rule_quota_ptr(rule);
+			if (ematch == NULL) {
+				ret = -EIO;
+				goto out;
+			}
+			ret = copy_from_user(&ctinfo, &ptr[i++],
+			      sizeof(ctinfo));
+			if (ret < 0)
+				goto out;
+			xts_rule_set_quota(ematch, ctinfo.bcnt, ctinfo.pcnt);
+		}
+	}
+
+	/* Ignore EOR marker or additional counters. */
+ out:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xts_get_counters);
+
 MODULE_LICENSE("GPL");
-- 
1.7.1

