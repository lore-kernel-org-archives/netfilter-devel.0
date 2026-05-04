Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5EE3E5EDB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919026; cv=none; b=rpEG19G/EyXOMH5rCPl9cOrF2G1+/MzwiAj0ps9I/6E5Ng23J0+qvwO+lfyA/InmAQjjlC1mJIgSrtOwCwS1F6sjzyjUCDnSh8Qna3xR3owrPuobscNKpyKSZPTIQ+HPJiZd212mIIjTf5EgMp9Pp4pmYxnev1jUVHgm3K4AO60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919026; c=relaxed/simple;
	bh=boAkyeOkE2QdhbqTqwPUutoDRtuMl23wsTTGFacU68g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSRP/RjjAGFnf0tzh65mcFUOuPYNYkJ20y9YcGCN/iJD04MxHVSQsp61rR2rjaI6aH6gYfjuiuK6rMkCIw9ORe77Q9B1bzbdOxjl/HQyKNcJkU7MPQIF9f4G9K10oe/WEOUK2bpNmce9HTSGwyC9Iq3zLd37M4YZne6Jd3g9ChI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5C1726079C; Mon, 04 May 2026 20:23:43 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 6/8] netfilter: ebtables: move to two-stage removal scheme
Date: Mon,  4 May 2026 20:22:18 +0200
Message-ID: <20260504182310.1916-7-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504182310.1916-1-fw@strlen.de>
References: <20260504182310.1916-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like previous patches for x_tables, follow same pattern in ebtables.
We can't reuse xt helpers: ebt_table struct layout is incompatible.

table->ops assignment is now done while still holding the ebt mutex
to make sure we never expose partially-filled table struct.

Fixes: 87663c39f898 ("netfilter: ebtables: do not hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: place synchronize_rcu after hook register failure.

 net/bridge/netfilter/ebtable_broute.c |  2 +-
 net/bridge/netfilter/ebtable_nat.c    |  2 +-
 net/bridge/netfilter/ebtables.c       | 60 +++++++++++++++++----------
 3 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 741360219552..e6f9e343b41f 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -128,8 +128,8 @@ static int __init ebtable_broute_init(void)
 
 static void __exit ebtable_broute_fini(void)
 {
-	unregister_pernet_subsys(&broute_net_ops);
 	ebt_unregister_template(&broute_table);
+	unregister_pernet_subsys(&broute_net_ops);
 }
 
 module_init(ebtable_broute_init);
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 0f2a8c6118d4..9985a82555c4 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -109,8 +109,8 @@ static int __init ebtable_nat_init(void)
 
 static void __exit ebtable_nat_fini(void)
 {
-	unregister_pernet_subsys(&frame_nat_net_ops);
 	ebt_unregister_template(&frame_nat);
+	unregister_pernet_subsys(&frame_nat_net_ops);
 }
 
 module_init(ebtable_nat_init);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index aea3e19875c6..3578ffbc14ae 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -42,6 +42,7 @@
 
 struct ebt_pernet {
 	struct list_head tables;
+	struct list_head dead_tables;
 };
 
 struct ebt_template {
@@ -1162,11 +1163,6 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 
 static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	mutex_lock(&ebt_mutex);
-	list_del(&table->list);
-	mutex_unlock(&ebt_mutex);
-	audit_log_nfcfg(table->name, AF_BRIDGE, table->private->nentries,
-			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
 	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
 			  ebt_cleanup_entry, net, NULL);
 	if (table->private->nentries)
@@ -1267,13 +1263,15 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	for (i = 0; i < num_ops; i++)
 		ops[i].priv = table;
 
-	list_add(&table->list, &ebt_net->tables);
-	mutex_unlock(&ebt_mutex);
-
 	table->ops = ops;
 	ret = nf_register_net_hooks(net, ops, num_ops);
-	if (ret)
+	if (ret) {
+		synchronize_rcu();
 		__ebt_unregister_table(net, table);
+	} else {
+		list_add(&table->list, &ebt_net->tables);
+	}
+	mutex_unlock(&ebt_mutex);
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REGISTER, GFP_KERNEL);
@@ -1339,7 +1337,7 @@ void ebt_unregister_template(const struct ebt_table *t)
 }
 EXPORT_SYMBOL(ebt_unregister_template);
 
-static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+void ebt_unregister_table_pre_exit(struct net *net, const char *name)
 {
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 	struct ebt_table *t;
@@ -1348,30 +1346,36 @@ static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
 
 	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, name) == 0) {
+			list_move(&t->list, &ebt_net->dead_tables);
 			mutex_unlock(&ebt_mutex);
-			return t;
+			nf_unregister_net_hooks(net, t->ops, hweight32(t->valid_hooks));
+			return;
 		}
 	}
 
 	mutex_unlock(&ebt_mutex);
-	return NULL;
-}
-
-void ebt_unregister_table_pre_exit(struct net *net, const char *name)
-{
-	struct ebt_table *table = __ebt_find_table(net, name);
-
-	if (table)
-		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
 
 void ebt_unregister_table(struct net *net, const char *name)
 {
-	struct ebt_table *table = __ebt_find_table(net, name);
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+	struct ebt_table *t;
 
-	if (table)
-		__ebt_unregister_table(net, table);
+	mutex_lock(&ebt_mutex);
+
+	list_for_each_entry(t, &ebt_net->dead_tables, list) {
+		if (strcmp(t->name, name) == 0) {
+			list_del(&t->list);
+			audit_log_nfcfg(t->name, AF_BRIDGE, t->private->nentries,
+					AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
+			__ebt_unregister_table(net, t);
+			mutex_unlock(&ebt_mutex);
+			return;
+		}
+	}
+
+	mutex_unlock(&ebt_mutex);
 }
 
 /* userspace just supplied us with counters */
@@ -2556,11 +2560,21 @@ static int __net_init ebt_pernet_init(struct net *net)
 	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
 
 	INIT_LIST_HEAD(&ebt_net->tables);
+	INIT_LIST_HEAD(&ebt_net->dead_tables);
 	return 0;
 }
 
+static void __net_exit ebt_pernet_exit(struct net *net)
+{
+	struct ebt_pernet *ebt_net = net_generic(net, ebt_pernet_id);
+
+	WARN_ON_ONCE(!list_empty(&ebt_net->tables));
+	WARN_ON_ONCE(!list_empty(&ebt_net->dead_tables));
+}
+
 static struct pernet_operations ebt_net_ops = {
 	.init = ebt_pernet_init,
+	.exit = ebt_pernet_exit,
 	.id   = &ebt_pernet_id,
 	.size = sizeof(struct ebt_pernet),
 };
-- 
2.53.0

