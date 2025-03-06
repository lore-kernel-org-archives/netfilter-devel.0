Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5E20C46A;
	Thu,  6 Mar 2025 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275303; cv=none; b=lXbOMW5miVcZRs1VIms+mtLnvA6OhY3u2GyqXqfA+oFbRJzMOqsT6JOVy9kN+hmdbv/85g+zMLuVOm6ke0pRM+DU6MUp95v2+aMdi5sbG7tywIUd19ZuK6/1+XuBB0Y8K2CfCABz+3qtlBkARkN7EsWmIKTBgkzmVc+MZtGHe6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275303; c=relaxed/simple;
	bh=jpeCnE3HJfsofmxO8W9m3xNHL3wARCCkrvgT3AbdNvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NBYpnxnjSyFkIFaPmE+GpGkKWbHGa7jU1y7vWsOCC5UCsrGQTycCpy1vgcFbYpR/Vzzso8r2x7ucyRVs3Di0Lax1CujG7bK+ZBFOifPKvSPuwh5vbSvBPyPN7n28iLcqMqZyInpZg0GVng0D8sFU9DurzAFH4ECqq3nu/SDfHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PPhxYtUA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vcGpmHj+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PPhxYtUA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vcGpmHj+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4A09860309; Thu,  6 Mar 2025 16:34:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275298;
	bh=a8cWGaq49n2A6fXIPbnph0hjKXtxxbdOlnnG+dTzH2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPhxYtUAsJqiStl5SaOQ3Em9LllALgz/93EkcSw905lieTnySqpH8aXSuy19i+TZR
	 QC2YKrPVNmgJkHQUlGSF70o15RbY63qd19pjRkbkM2E8N7tCKlmkYMOv69gp6Mjxkt
	 yLwgCDLJqcc9QXqHXtrMwLADQuoVZSivKk6HzxAq3+GyWACMhJwdbQSUGFnyGlogO2
	 /ueO5W/WLrTvXbTrDFPoConNc0Xfm/eM1y75yFcg6/m3s6Vwp0Q8eD7nGCzysXUFz5
	 MoDLJCNPHNlfmssCT/vLGut/cprkDqCEK0Wa2N8tN9mlEt2pDheMX0rL2tanzq/nNV
	 BzTQWryHTJVeQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88F4160301;
	Thu,  6 Mar 2025 16:34:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275293;
	bh=a8cWGaq49n2A6fXIPbnph0hjKXtxxbdOlnnG+dTzH2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcGpmHj+qcm5VyWBZwf1zOlIiXe7/CtSs2zoojhEwoNITtF2Z06cszNR8w2lPG0Az
	 oT+ndQRuvZ2fRDzs8TySKyKE/SQlQq0arcfpQibNxX0EFLAIdeINpMuUeAQlKLDKek
	 MwjRROXZhwjoPCBexrKAE6TkbJZyNX/i+s2leMiMyHe/N2HY55ueiM8oO+/fuNzX+j
	 tX8V9spi7FLehaO8tOBl9ErfSMt0gEkvRswajoiW3fL7t0fyHRFolVpFn6nZEe1+z8
	 NJtyVcMANSYaC4jk8+WPePIKVp8m76yNTh5fe2ydaTr2ekuL+RcxQtHKGoz4vZAT6H
	 SqQuK2uGDQaLQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/3] netfilter: nf_tables: make destruction work queue pernet
Date: Thu,  6 Mar 2025 16:34:46 +0100
Message-Id: <20250306153446.46712-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250306153446.46712-1-pablo@netfilter.org>
References: <20250306153446.46712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The call to flush_work before tearing down a table from the netlink
notifier was supposed to make sure that all earlier updates (e.g. rule
add) that might reference that table have been processed.

Unfortunately, flush_work() waits for the last queued instance.
This could be an instance that is different from the one that we must
wait for.

This is because transactions are protected with a pernet mutex, but the
work item is global, so holding the transaction mutex doesn't prevent
another netns from queueing more work.

Make the work item pernet so that flush_work() will wait for all
transactions queued from this netns.

A welcome side effect is that we no longer need to wait for transaction
objects from foreign netns.

The gc work queue is still global.  This seems to be ok because nft_set
structures are reference counted and each container structure owns a
reference on the net namespace.

The destroy_list is still protected by a global spinlock rather than
pernet one but the hold time is very short anyway.

v2: call cancel_work_sync before reaping the remaining tables (Pablo).

Fixes: 9f6958ba2e90 ("netfilter: nf_tables: unconditionally flush pending work before notifier")
Reported-by: syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 24 ++++++++++++++----------
 net/netfilter/nft_compat.c        |  8 ++++----
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 60d5dcdb289c..803d5f1601f9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1891,7 +1891,7 @@ void nft_chain_filter_fini(void);
 void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
 
-void nf_tables_trans_destroy_flush_work(void);
+void nf_tables_trans_destroy_flush_work(struct net *net);
 
 int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
 __be64 nf_jiffies64_to_msecs(u64 input);
@@ -1905,6 +1905,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	destroy_list;
 	struct list_head	commit_set_list;
 	struct list_head	binding_list;
 	struct list_head	module_list;
@@ -1915,6 +1916,7 @@ struct nftables_pernet {
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
 	u8			validate_state;
+	struct work_struct	destroy_work;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a34de9c17cf1..c2df81b7e950 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -34,7 +34,6 @@ unsigned int nf_tables_net_id __read_mostly;
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
-static LIST_HEAD(nf_tables_destroy_list);
 static LIST_HEAD(nf_tables_gc_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
 static DEFINE_SPINLOCK(nf_tables_gc_list_lock);
@@ -125,7 +124,6 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 	table->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
-static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
 
 static void nft_trans_gc_work(struct work_struct *work);
 static DECLARE_WORK(trans_gc_work, nft_trans_gc_work);
@@ -10006,11 +10004,12 @@ static void nft_commit_release(struct nft_trans *trans)
 
 static void nf_tables_trans_destroy_work(struct work_struct *w)
 {
+	struct nftables_pernet *nft_net = container_of(w, struct nftables_pernet, destroy_work);
 	struct nft_trans *trans, *next;
 	LIST_HEAD(head);
 
 	spin_lock(&nf_tables_destroy_list_lock);
-	list_splice_init(&nf_tables_destroy_list, &head);
+	list_splice_init(&nft_net->destroy_list, &head);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	if (list_empty(&head))
@@ -10024,9 +10023,11 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	}
 }
 
-void nf_tables_trans_destroy_flush_work(void)
+void nf_tables_trans_destroy_flush_work(struct net *net)
 {
-	flush_work(&trans_destroy_work);
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	flush_work(&nft_net->destroy_work);
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
@@ -10484,11 +10485,11 @@ static void nf_tables_commit_release(struct net *net)
 
 	trans->put_net = true;
 	spin_lock(&nf_tables_destroy_list_lock);
-	list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
+	list_splice_tail_init(&nft_net->commit_list, &nft_net->destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	nf_tables_module_autoload_cleanup(net);
-	schedule_work(&trans_destroy_work);
+	schedule_work(&nft_net->destroy_work);
 
 	mutex_unlock(&nft_net->commit_mutex);
 }
@@ -11853,7 +11854,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work(net);
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
@@ -11895,6 +11896,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->destroy_list);
 	INIT_LIST_HEAD(&nft_net->commit_set_list);
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
@@ -11903,6 +11905,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
+	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
 	return 0;
 }
@@ -11931,14 +11934,17 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	if (!list_empty(&nft_net->module_list))
 		nf_tables_module_autoload_cleanup(net);
 
+	cancel_work_sync(&nft_net->destroy_work);
 	__nft_release_tables(net);
 
 	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
+
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)
@@ -12029,10 +12035,8 @@ static void __exit nf_tables_module_exit(void)
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
 	nft_chain_route_fini();
-	nf_tables_trans_destroy_flush_work();
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_gc_work);
-	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
 	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7ca4f0d21fe2..72711d62fddf 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -228,7 +228,7 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	return 0;
 }
 
-static void nft_compat_wait_for_destructors(void)
+static void nft_compat_wait_for_destructors(struct net *net)
 {
 	/* xtables matches or targets can have side effects, e.g.
 	 * creation/destruction of /proc files.
@@ -236,7 +236,7 @@ static void nft_compat_wait_for_destructors(void)
 	 * work queue.  If we have pending invocations we thus
 	 * need to wait for those to finish.
 	 */
-	nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work(net);
 }
 
 static int
@@ -262,7 +262,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors();
+	nft_compat_wait_for_destructors(ctx->net);
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0) {
@@ -515,7 +515,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors();
+	nft_compat_wait_for_destructors(ctx->net);
 
 	return xt_check_match(&par, size, proto, inv);
 }
-- 
2.30.2

