Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F7A2E889C
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2026 07:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777708626; cv=none; b=EnLA5okTl8NxsNzGYvxYncVp3koAgzSMfV0Rgfmes08UMDenjBSr63QYu7XVQ3eHXSS1axjCo9viK1i1LUF0NDSMcFGJcL+gx0uibt64p8AzqrMAmCKqvng5dKQStpdyHQudGbsx/2Q1uy0ak8mBZtn9ZQWKGHe4B9bpYoGHQDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777708626; c=relaxed/simple;
	bh=b1vak7SD4dDjAbNs0AWLp/JSDJFFq8NRvvTeNswPBX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4xwW71FPkMHpllKa86Od8yRR4LCmlqauERmwIUpaaa9coXVRiD5h/LKfGIrBdKgStbRDP7p7/OV8a6oP6tCbmmejEx9gDaOw8VFuze5mQbDRoxmtkeTcgXTYMLKS12C346pXqkgKQXsK6M6uNHL0ZaWoylLSOBLHk3aqMf8qxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18636605BD; Sat, 02 May 2026 09:57:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: tristan@talencesecurity.com,
	Florian Westphal <fw@strlen.de>,
	Tristan Madani <tristmd@gmail.com>
Subject: [PATCH nf 4/5] netfilter: x_tables: add and use xtables_unregister_table_exit
Date: Sat,  2 May 2026 09:56:38 +0200
Message-ID: <20260502075639.7440-5-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260502075639.7440-1-fw@strlen.de>
References: <20260502075639.7440-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous change added xtables_unregister_table_pre_exit to detach the
table from the packetpath and to unlink it from the active table list.
In case of rmmod, userspace that is doing set/getsockopt for this table
will not be able to re-instantiate the table:
 1. The larval table has been removed already
 2. existing instantiated table is no longer on the xt pernet table list.

This adds the second stage helper:

unlink the table from the dying list, free the hook ops (if any) and do
the audit notification.  It replaces xt_unregister_table().

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Tristan Madani <tristmd@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  2 +-
 net/ipv4/netfilter/arp_tables.c    |  9 ++--
 net/ipv4/netfilter/ip_tables.c     |  9 ++--
 net/ipv6/netfilter/ip6_tables.c    |  9 ++--
 net/netfilter/x_tables.c           | 81 +++++++++++++++++++++++-------
 5 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 74486714ae20..5a1c5c336fa4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -308,8 +308,8 @@ struct xt_table *xt_register_table(struct net *net,
 				   const struct nf_hook_ops *template_ops,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo);
-void *xt_unregister_table(struct xt_table *table);
 void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name);
+struct xt_table *xt_unregister_table_exit(struct net *net, u8 af, const char *name);
 
 struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       unsigned int num_counters,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index bd348b7bad2c..ad2259678c78 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1501,13 +1501,11 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 
 static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
+	void *loc_cpu_entry;
 	struct arpt_entry *iter;
 
-	private = xt_unregister_table(table);
-
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
@@ -1515,6 +1513,7 @@ static void __arpt_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int arpt_register_table(struct net *net,
@@ -1556,7 +1555,7 @@ int arpt_register_table(struct net *net,
 
 void arpt_unregister_table(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_ARP, name);
 
 	if (table)
 		__arpt_unregister_table(net, table);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 864489928fb5..5cbdb0815857 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1704,12 +1704,10 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 static void __ipt_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
 	struct ipt_entry *iter;
-
-	private = xt_unregister_table(table);
+	void *loc_cpu_entry;
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
@@ -1718,6 +1716,7 @@ static void __ipt_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int ipt_register_table(struct net *net, const struct xt_table *table,
@@ -1758,7 +1757,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 void ipt_unregister_table_exit(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_IPV4, name);
 
 	if (table)
 		__ipt_unregister_table(net, table);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index edf50bc7787e..9d9c3763f2f5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1713,12 +1713,10 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
+	struct xt_table_info *private = table->private;
 	struct module *table_owner = table->me;
 	struct ip6t_entry *iter;
-
-	private = xt_unregister_table(table);
+	void *loc_cpu_entry;
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries;
@@ -1727,6 +1725,7 @@ static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
+	kfree(table);
 }
 
 int ip6t_register_table(struct net *net, const struct xt_table *table,
@@ -1767,7 +1766,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 void ip6t_unregister_table_exit(struct net *net, const char *name)
 {
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
+	struct xt_table *table = xt_unregister_table_exit(net, NFPROTO_IPV6, name);
 
 	if (table)
 		__ip6t_unregister_table(net, table);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ec72ba0da983..47dc1dff2996 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -55,6 +55,9 @@ static struct list_head xt_templates[NFPROTO_NUMPROTO];
 
 struct xt_pernet {
 	struct list_head tables[NFPROTO_NUMPROTO];
+
+	/* stash area used during netns exit */
+	struct list_head dead_tables[NFPROTO_NUMPROTO];
 };
 
 struct compat_delta {
@@ -1621,23 +1624,6 @@ struct xt_table *xt_register_table(struct net *net,
 }
 EXPORT_SYMBOL_GPL(xt_register_table);
 
-void *xt_unregister_table(struct xt_table *table)
-{
-	struct xt_table_info *private;
-
-	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
-	list_del(&table->list);
-	mutex_unlock(&xt[table->af].mutex);
-	audit_log_nfcfg(table->name, table->af, private->number,
-			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
-	kfree(table->ops);
-	kfree(table);
-
-	return private;
-}
-EXPORT_SYMBOL_GPL(xt_unregister_table);
-
 /**
  * xt_unregister_table_pre_exit - pre-shutdown unregister of a table
  * @net: network namespace
@@ -1647,6 +1633,14 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
  * Unregisters the specified netfilter table from the given network namespace
  * and also unregisters the hooks from netfilter core: no new packets will be
  * processed.
+ *
+ * This must be called prior to xt_unregister_table_exit() from the pernet
+ * .pre_exit callback.  After this call, the table is no longer visible to
+ * the get/setsockopt path.  In case of rmmod, module exit path must have
+ * called xt_unregister_template() prior to unregistering pernet ops to
+ * prevent re-instantiation of the table.
+ *
+ * See also: xt_unregister_table_exit()
  */
 void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 {
@@ -1656,6 +1650,7 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt_net->tables[af], list) {
 		if (strcmp(t->name, name) == 0) {
+			list_move(&t->list, &xt_net->dead_tables[af]);
 			mutex_unlock(&xt[af].mutex);
 
 			if (t->ops) /* nat table registers with nat core, t->ops is NULL. */
@@ -1666,6 +1661,50 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
 	mutex_unlock(&xt[af].mutex);
 }
 EXPORT_SYMBOL(xt_unregister_table_pre_exit);
+
+/**
+ * xt_unregister_table_exit - remove a table during namespace teardown
+ * @net: the network namespace from which to unregister the table
+ * @af: address family (e.g., NFPROTO_IPV4, NFPROTO_IPV6)
+ * @name: name of the table to unregister
+ *
+ * Completes the unregister process for a table. This must be called from
+ * the pernet ops .exit callback. This is the second stage after
+ * xt_unregister_table_pre_exit().
+ *
+ * pair with xt_unregister_table_pre_exit() during namespace shutdown.
+ *
+ * Return: the unregistered table or NULL if the table was never
+ *         instantiated. The caller needs to kfree() the table after it
+ *         has removed the family specific matches/targets.
+ */
+struct xt_table *xt_unregister_table_exit(struct net *net, u8 af, const char *name)
+{
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *table;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(table, &xt_net->dead_tables[af], list) {
+		struct nf_hook_ops *ops = NULL;
+
+		if (strcmp(table->name, name) != 0)
+			continue;
+
+		list_del(&table->list);
+
+		audit_log_nfcfg(table->name, table->af, table->private->number,
+				AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
+		swap(table->ops, ops);
+		mutex_unlock(&xt[af].mutex);
+
+		kfree(ops);
+		return table;
+	}
+	mutex_unlock(&xt[af].mutex);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt_unregister_table_exit);
 #endif
 
 #ifdef CONFIG_PROC_FS
@@ -2112,8 +2151,10 @@ static int __net_init xt_net_init(struct net *net)
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		INIT_LIST_HEAD(&xt_net->tables[i]);
+		INIT_LIST_HEAD(&xt_net->dead_tables[i]);
+	}
 	return 0;
 }
 
@@ -2122,8 +2163,10 @@ static void __net_exit xt_net_exit(struct net *net)
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
 	int i;
 
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		WARN_ON_ONCE(!list_empty(&xt_net->tables[i]));
+		WARN_ON_ONCE(!list_empty(&xt_net->dead_tables[i]));
+	}
 }
 
 static struct pernet_operations xt_net_ops = {
-- 
2.53.0

