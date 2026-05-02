Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBDE2FD1AA
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2026 07:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777708613; cv=none; b=Ca/XlzCv4wCMdLZ2U+fRuQlatA9sPhTEWIlhqIYZzdtEpUZgUe0qpGoXQRpIQDpJc76FcEU1iUsdxw2T2V1lvdj4WrxP0r8HOsNNnh0tWnDmzVJI5/n/GDiZ6lzRt+5KYphHAytZofVXbAkhCwHsh7rS6tBfb8c0cmSMSBTwSjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777708613; c=relaxed/simple;
	bh=HEU9gtg3d7Z3caXC3AdFyCmmGvxLWJ1jd4rMXMgL9Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGwEDCLKdzSgWKqSrqtAQTjBL6Sr3/RS46GVdb4o6feZUomJZMIQwtbWK2jIBToP1nsGhczV8kqQjmBt6nIL3wkq+Sf3ZjP8U7BDPzXzxlqVLsNbAAFznEtn613tWT8djGYj138H9oesMS6fd/4LTKGghHnIx/2yRRNMhpv7RJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 20448606C8; Sat, 02 May 2026 09:56:50 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: tristan@talencesecurity.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/5] netfilter: xtables: allocate hook ops while under mutex
Date: Sat,  2 May 2026 09:56:35 +0200
Message-ID: <20260502075639.7440-2-fw@strlen.de>
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

arp/ip(6)t_register_table() add the table to the per-netns list via
xt_register_table() before allocating the per-netns hook ops copy
via kmemdup_array().  This leaves a window where the table is
visible in the list with ops=NULL.

If the pernet exit happens runs concurrently the pre_exit callback finds
the table via xt_find_table() and passes the NULL ops pointer to
nf_unregister_net_hooks(), causing a NULL dereference:

  general protection fault in nf_unregister_net_hooks+0xbc/0x150
  RIP: nf_unregister_net_hooks (net/netfilter/core.c:613)
  Call Trace:
    ipt_unregister_table_pre_exit
    iptable_mangle_net_pre_exit
    ops_pre_exit_list
    cleanup_net

Fix by moving the ops allocation into the xtables core so the table is
never in the list without valid ops.  Also ensure the table is no longer
processing packets before its torn down on error unwind.
nf_register_net_hooks might have published at least one hook; call
synchronize_rcu() if there was an error.

Based on earlier patch by Tristan Madani.

Fixes: f9006acc8dfe5 ("netfilter: arp_tables: pass table pointer via nf_hook_ops")
Fixes: ee177a54413a ("netfilter: ip6_tables: pass table pointer via nf_hook_ops")
Fixes: ae689334225f ("netfilter: ip_tables: pass table pointer via nf_hook_ops")
Link: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/ipv4/netfilter/arp_tables.c    | 35 +++---------------------
 net/ipv4/netfilter/ip_tables.c     | 41 +++-------------------------
 net/ipv6/netfilter/ip6_tables.c    | 38 +++-----------------------
 net/netfilter/x_tables.c           | 44 ++++++++++++++++++++++++++----
 5 files changed, 51 insertions(+), 108 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index a81b46af5118..cb4b694dd9e4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -305,6 +305,7 @@ struct xt_counters *xt_counters_alloc(unsigned int counters);
 
 struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *table,
+				   const struct nf_hook_ops *template_ops,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo);
 void *xt_unregister_table(struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 97ead883e4a1..c02e46a0271a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1522,13 +1522,11 @@ int arpt_register_table(struct net *net,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1543,7 +1541,7 @@ int arpt_register_table(struct net *net,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct arpt_entry *iter;
 
@@ -1553,31 +1551,6 @@ int arpt_register_table(struct net *net,
 		return PTR_ERR(new_table);
 	}
 
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__arpt_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 23c8deff8095..488c5945ebb2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1724,13 +1724,11 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1745,7 +1743,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct ipt_entry *iter;
 
@@ -1755,37 +1753,6 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		return PTR_ERR(new_table);
 	}
 
-	/* No template? No need to do anything. This is used by 'nat' table, it registers
-	 * with the nat core instead of the netfilter core.
-	 */
-	if (!template_ops)
-		return 0;
-
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__ipt_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d585ac3c1113..dbe7c7acd702 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1733,13 +1733,11 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *template_ops)
 {
-	struct nf_hook_ops *ops;
-	unsigned int num_ops;
-	int ret, i;
-	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
-	void *loc_cpu_entry;
+	struct xt_table_info *newinfo;
 	struct xt_table *new_table;
+	void *loc_cpu_entry;
+	int ret;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
@@ -1754,7 +1752,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		return ret;
 	}
 
-	new_table = xt_register_table(net, table, &bootstrap, newinfo);
+	new_table = xt_register_table(net, table, template_ops, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct ip6t_entry *iter;
 
@@ -1764,34 +1762,6 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		return PTR_ERR(new_table);
 	}
 
-	if (!template_ops)
-		return 0;
-
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	for (i = 0; i < num_ops; i++)
-		ops[i].priv = new_table;
-
-	new_table->ops = ops;
-
-	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret != 0)
-		goto out_free;
-
-	return ret;
-
-out_free:
-	__ip6t_unregister_table(net, new_table);
 	return ret;
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2c67c2e6b132..958b5a8b462d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1541,20 +1541,32 @@ EXPORT_SYMBOL_GPL(xt_replace_table);
 
 struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *input_table,
+				   const struct nf_hook_ops *template_ops,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo)
 {
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *t, *table = NULL;
+	struct nf_hook_ops *ops = NULL;
 	struct xt_table_info *private;
-	struct xt_table *t, *table;
-	int ret;
+	unsigned int num_ops;
+	int ret = -EINVAL;
+
+	num_ops = hweight32(input_table->valid_hooks);
+	if (num_ops == 0)
+		goto out;
+
+	ret = -ENOMEM;
+	if (template_ops) {
+		ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
+		if (!ops)
+			goto out;
+	}
 
 	/* Don't add one object to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
-	if (!table) {
-		ret = -ENOMEM;
+	if (!table)
 		goto out;
-	}
 
 	mutex_lock(&xt[table->af].mutex);
 	/* Don't autoload: we'd eat our tail... */
@@ -1577,14 +1589,34 @@ struct xt_table *xt_register_table(struct net *net,
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
+	if (ops) {
+		int i;
+
+		for (i = 0; i < num_ops; i++)
+			ops[i].priv = table;
+
+		ret = nf_register_net_hooks(net, ops, num_ops);
+		if (ret != 0) {
+			mutex_unlock(&xt[table->af].mutex);
+			/* nf_register_net_hooks() might have published a
+			 * base chain before internal error unwind.
+			 */
+			synchronize_rcu();
+			goto out;
+		}
+
+		table->ops = ops;
+	}
+
 	list_add(&table->list, &xt_net->tables[table->af]);
 	mutex_unlock(&xt[table->af].mutex);
 	return table;
 
 unlock:
 	mutex_unlock(&xt[table->af].mutex);
-	kfree(table);
 out:
+	kfree(table);
+	kfree(ops);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(xt_register_table);
-- 
2.53.0

