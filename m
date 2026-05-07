Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F530EF97;
	Thu,  7 May 2026 23:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197526; cv=none; b=hLTeLGsNbX8BLOl1Rq0/r450o5JwsiuTldW/xzzKVpxqLMWGCUGy6laC4bl+rGGkB2aHHv1z52ea6kHutAmMfjxAGCXmohiP+YykZfwZdPJf9U3WTyD4cdcbMJ9NcxZDxJtrZo5U/aqgA0s5SCvlj3s3SrD+kkxE9TTJwbv+2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197526; c=relaxed/simple;
	bh=DuuHgSr92inn576ODZb6Stp0ng4K2j/Q6Ck+wdaVBIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAJGKQPZSNJFHgvcmryY+NyBiQtWkndoil5J0nN6PFEV0Ra7h2tUTqf7RIHUfmvwhPxVZkPousEKMlspE1yz6qC0zlq+YFrcHbLEaYEpZa3PlVio0OV6JpismRhbMd3oJytpRZrJxm7EiwelwF+VWH3Sdy/SbGwwe0OFuFB16aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OQPOwHwV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OQPOwHwV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9889760253;
	Fri,  8 May 2026 01:45:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197516;
	bh=No/5ggqHNK00Ucjm5gErl+JUBUCnBfzciljjBE0NIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQPOwHwVvTpup1/NEnnlETghwB6z91AnqVu7ybwOSHfVZ4TVEBZwQzl+Gy8SLy+mD
	 qXN42Ctt73VZIyn9T3yF9sTgukzUQfwv3DSxiEkGdslV1QU6heMKxgbNuKwpJYORmA
	 dW3JxXocTA8jU5GxI1aCzmq1CSoA7Eg57sSAOf7epQITMbkVVAYxNlzGsz0WSaHwqS
	 h8jxyIz2gWnY8br3fZ1BaftIM5tKL359praVtJuEIi/vMUislTO8Xx/hfaiN0Afa63
	 +Cb9JrGrQDR3Y4TuuSKUNzXNsDfLULWgQcyv78S3LQkaKTPQAJbXqYEeNpMpNPJ1U0
	 qUmYz2e2qwUZw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/13] netfilter: x_tables: allocate hook ops while under mutex
Date: Fri,  8 May 2026 01:44:58 +0200
Message-ID: <20260507234509.603182-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507234509.603182-1-pablo@netfilter.org>
References: <20260507234509.603182-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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

audit log register message gets deferred until all operations have
passed, this avoids need to emit another ureg message in case of
error unwinding.

Based on earlier patch by Tristan Madani.

Fixes: f9006acc8dfe5 ("netfilter: arp_tables: pass table pointer via nf_hook_ops")
Fixes: ee177a54413a ("netfilter: ip6_tables: pass table pointer via nf_hook_ops")
Fixes: ae689334225f ("netfilter: ip_tables: pass table pointer via nf_hook_ops")
Link: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/ipv4/netfilter/arp_tables.c    | 35 +++------------------
 net/ipv4/netfilter/ip_tables.c     | 41 +++---------------------
 net/ipv6/netfilter/ip6_tables.c    | 38 +++--------------------
 net/netfilter/x_tables.c           | 50 +++++++++++++++++++++++++-----
 5 files changed, 55 insertions(+), 110 deletions(-)

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
index bb0cb3959551..06f27bea9eed 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1542,7 +1542,6 @@ xt_replace_table(struct xt_table *table, unsigned int num_counters,
 	private = do_replace_table(table, num_counters, newinfo, error);
 	if (private)
 		audit_log_nfcfg(table->name, table->af, private->number,
-				!private->number ? AUDIT_XT_OP_REGISTER :
 				AUDIT_XT_OP_REPLACE,
 				GFP_KERNEL);
 
@@ -1552,20 +1551,32 @@ EXPORT_SYMBOL_GPL(xt_replace_table);
 
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
@@ -1579,7 +1590,7 @@ struct xt_table *xt_register_table(struct net *net,
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
 
-	if (!xt_replace_table(table, 0, newinfo, &ret))
+	if (!do_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
 	private = table->private;
@@ -1588,14 +1599,37 @@ struct xt_table *xt_register_table(struct net *net,
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
+	audit_log_nfcfg(table->name, table->af, private->number,
+			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
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
2.47.3

