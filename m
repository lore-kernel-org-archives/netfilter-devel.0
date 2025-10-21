Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C92BE7CC
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090057; cv=none; b=JnbVoRjMqwFUyduVE5Mr4zAjuoGdsGbqW6p8+DYzAxVG7+QTD+ECTCV5uQzfCNZPuGSV5ca4Co2/Gl9U+98kkqJeF4Yb5ohcQQxEeom5Uj7j/76glcC0+OmXyPPGZlFlsrXoqEuFohXBpap0RBcyZVfQvBzwhGIHj9YeXUtdxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090057; c=relaxed/simple;
	bh=WKhcQEZdOd7evW6N91snI7aHC4sgyi5xW2VGg+jXJiw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RdaUpCYd1ZDCWBTFyvmdpXjHdHxxQuV6RXIwbDWHRZcsYiHgpnCFw3MHpPtpPszmlazbTllLXRjsGvQj65svurosFfbbF4jHT2Ok20ZErfm3AvkOdso0seY69tH8pCfqC2tZyHdGXum681PB75158YPQx8E7lMSlg1y5dSVGwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OkO4JcOf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OkO4JcOf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 70CAB60359;
	Wed, 22 Oct 2025 01:40:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761090043;
	bh=ANnlau8tEHWJlOwtJOpRpG+b5iiaY5n90qnKe/LLzdo=;
	h=From:To:Cc:Subject:Date:From;
	b=OkO4JcOflmtHc1UJMtV0Pfy5kqBuJ1S961YLDsGBnrfp3twbnkeEjNQH9DHAq9xmL
	 uI6iq5q8sdd8UTQ9DxBqrPuhMWC4ppbn6DTNP2N8ErfXqA0hjJ/nxKs0v7+RUV0b3z
	 eDxFoBjxIMR+zfFGuod3SdBDsmxD5RM16fPtwzZZaIQCMzjX4ucH2h3y/5kur6l5UR
	 iKGlE5cnvTKVSc/YHA3Qg2yYtWBkF6fXaca0QWPR5FYsWmBYcbvIo9x8RvDIW5mZZ0
	 JiUf/F8cRl0+RP7LSzJeUb0lgC8IcTtXoVvZ2X2MCDqY0yVR/OSpkVykO97/vAKo9L
	 5lCSv1OAvcyzw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	fmancera@suse.de
Subject: [PATCH nf] netfilter: nf_tables: limit maximum number of jumps/gotos per netns
Date: Wed, 22 Oct 2025 01:40:39 +0200
Message-Id: <20251021234039.2505-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is set from the init_netns via:

   net.netfilter.nf_tables_jump_max_netns

which is 65536 by default.

According to Shawn Brady: "The compile time limit of 65536 was chosen to
account for any normal use case, and when this value (and associated
stressing loop table) was tested against a 1CPU/256MB machine, the
system remained functional."

To simplify the logic, this jump limit is global for all tables that are
defined in the netns, regardless the family type.

Jump from verdict map is only counted as one single jump because set
lookup provides a single exact match, therefore, this is equivalent to
an immediate jump.

Tables now provide a new jump_count[2] field which stores the current
number of jump chains in the present [0] and the future [1]. During the
preparation phase, jump_count[1] is updated to store the number of jumps
after the last table validation while processing the batch.

If this batch does not update the number of jumps in this table, then
jump_count[0] provides the current number of jumps and jump_count[1] is
set to -1. When checking if the number of jumps go over the limit, check
if jump_count[1] is >= 0, meaning the number of jumps for this table has
been modified by this batch, otherwise use jump_count[0], meaning this
table has not been modified in terms of new jumps.

After the commit phase, jump_count[0] is set to jump_count[1] if it is
>= 0. Otherwise, in case of abort, jump_count[1] is reset to -1 to
prepare for handling the next batch.

This patch includes a documentation update from Shawn Brady.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: very lightly tested, target nf as a fix for long jump chain calls.

 Documentation/networking/netfilter-sysctl.rst |   9 ++
 include/net/netfilter/nf_tables.h             |   7 +
 net/netfilter/nf_tables_api.c                 | 149 +++++++++++++++++-
 net/netfilter/nft_immediate.c                 |   4 +
 net/netfilter/nft_lookup.c                    |   9 ++
 5 files changed, 174 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netfilter-sysctl.rst b/Documentation/networking/netfilter-sysctl.rst
index beb6d7b275d4..28f193c196ce 100644
--- a/Documentation/networking/netfilter-sysctl.rst
+++ b/Documentation/networking/netfilter-sysctl.rst
@@ -15,3 +15,12 @@ nf_log_all_netns - BOOLEAN
 	with LOG target; this aims to prevent containers from flooding host
 	kernel log. If enabled, this target also works in other network
 	namespaces. This variable is only accessible from init_net.
+
+nf_tables_jump_max_netns - INTEGER (count)
+	default 65536
+
+	The maximum numbers of jumps/gotos a netns can have across its tables.
+	This only applies to non-init_net namespaces, and is read only for
+	non-init_user_ns namespaces. Meeting or exceeding this value will
+	cause additional rules to not be added, with EMLINK being return to
+	the user.
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..4886c938bf0e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -209,6 +209,7 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
  *	@family: protocol family
  *	@level: depth of the chains
  *	@report: notify via unicast netlink message
+ * 	@jump_count: jump to chain counter
  *	@reg_inited: bitmap of initialised registers
  */
 struct nft_ctx {
@@ -222,6 +223,7 @@ struct nft_ctx {
 	u8				family;
 	u8				level;
 	bool				report;
+	int				jump_count;
 	DECLARE_BITMAP(reg_inited, NFT_REG32_NUM);
 };
 
@@ -1279,6 +1281,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@family:address family
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
+ * 	@jump_count: present [0] and future [1] jump to chain counter
  *	@nlpid: netlink port ID
  *	@name: name of the table
  *	@udlen: length of the user data
@@ -1298,6 +1301,7 @@ struct nft_table {
 	u16				family:6,
 					flags:8,
 					genmask:2;
+	int				jump_count[2];
 	u32				nlpid;
 	char				*name;
 	u16				udlen;
@@ -1917,6 +1921,9 @@ struct nftables_pernet {
 	unsigned int		gc_seq;
 	u8			validate_state;
 	struct work_struct	destroy_work;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	*nf_tables_dir_header;
+#endif
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..e78546b1f02d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/sysctl.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
@@ -25,10 +26,12 @@
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
+#define NFT_TABLE_DEFAULT_JUMPS_MAX 65536
 
 /* limit compaction to avoid huge kmalloc/krealloc sizes. */
 #define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
 
+static u32 nf_tables_jumps_max_netns __read_mostly = NFT_TABLE_DEFAULT_JUMPS_MAX;
 unsigned int nf_tables_net_id __read_mostly;
 
 static LIST_HEAD(nf_tables_expressions);
@@ -1631,6 +1634,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
+	table->jump_count[1] = -1;
+
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
@@ -4121,7 +4126,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
 
-static int nft_table_validate(struct net *net, const struct nft_table *table)
+static int nft_table_validate(struct net *net, struct nft_table *table)
 {
 	struct nft_chain *chain;
 	struct nft_ctx ctx = {
@@ -4142,6 +4147,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		cond_resched();
 	}
 
+	table->jump_count[1] = ctx.jump_count;
+
 	return 0;
 }
 
@@ -4202,6 +4209,39 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 	return ret;
 }
 
+static u32 nft_jump_count(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+	u32 jump_count = 0;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		/* If table has been updated with new jumps in this batch, then
+		 * use future jump count. Otherwise, use current jump count.
+		 */
+		if (table->jump_count[1] < 0)
+			jump_count += table->jump_count[0];
+		else
+			jump_count += table->jump_count[1];
+	}
+
+	return jump_count;
+}
+
+static int nft_jump_count_check(struct net *net)
+{
+	u32 jump_count;
+
+	if (net_eq(net, &init_net))
+		return 0;
+
+	jump_count = nft_jump_count(net);
+	if (jump_count > nf_tables_jumps_max_netns)
+		return -EAGAIN;
+
+	return 0;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4421,8 +4461,17 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (flow)
 		nft_trans_flow_rule(trans) = flow;
 
-	if (table->validate_state == NFT_VALIDATE_DO)
-		return nft_table_validate(net, table);
+	if (table->validate_state == NFT_VALIDATE_DO) {
+		err = nft_table_validate(net, table);
+		if (err < 0)
+			return err;
+
+		/* rule might jump to chain either via immediate or lookup,
+		 * check if jump to chain count goes over the limit.
+		 */
+		if (nft_jump_count_check(net) < 0)
+			return -EMLINK;
+	}
 
 	return 0;
 
@@ -10109,6 +10158,9 @@ static int nf_tables_validate(struct net *net)
 		}
 	}
 
+	if (nft_jump_count_check(net) < 0)
+		return -EAGAIN;
+
 	return 0;
 }
 
@@ -10869,6 +10921,30 @@ static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
 	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
 }
 
+static void nft_jump_count_reset(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list)
+		table->jump_count[1] = -1;
+}
+
+static void nft_jump_count_update(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		/* no new jumps in this table, skip. */
+		if (table->jump_count[1] < 0)
+			continue;
+
+		table->jump_count[0] = table->jump_count[1];
+		table->jump_count[1] = -1;
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -10926,6 +11002,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (err < 0)
 		return err;
 
+	nft_jump_count_update(net);
+
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -11266,6 +11344,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	    nf_tables_validate(net) < 0)
 		err = -EAGAIN;
 
+	nft_jump_count_reset(net);
+
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
 		struct nft_table *table = trans->table;
@@ -12124,6 +12204,65 @@ static struct notifier_block nft_nl_notifier = {
 	.notifier_call  = nft_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table nf_tables_sysctl_table[] = {
+	{
+		.procname	= "nf_tables_jumps_max_netns",
+		.data		= &nf_tables_jumps_max_netns,
+		.maxlen		= sizeof(nf_tables_jumps_max_netns),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int nf_tables_sysctl_init(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct ctl_table *tbl = nf_tables_sysctl_table;
+
+	if (net_eq(net, &init_net)) {
+		nf_tables_jumps_max_netns = NFT_TABLE_DEFAULT_JUMPS_MAX;
+	} else {
+		tbl = kmemdup(tbl, sizeof(nf_tables_sysctl_table), GFP_KERNEL);
+		if (!tbl)
+			return -ENOMEM;
+
+		tbl->data = &nf_tables_jumps_max_netns;
+		tbl->mode = 0444;
+	}
+
+	nft_net->nf_tables_dir_header =
+		register_net_sysctl_sz(net, "net/netfilter", tbl,
+				       ARRAY_SIZE(nf_tables_sysctl_table));
+	if (!nft_net->nf_tables_dir_header)
+		goto err_tbl_free;
+
+	return 0;
+
+err_tbl_free:
+	if (tbl != nf_tables_sysctl_table)
+		kfree(tbl);
+
+	return -ENOMEM;
+}
+
+static void nf_tables_sysctl_exit(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	unregister_net_sysctl_table(nft_net->nf_tables_dir_header);
+}
+#else
+static int nf_tables_sysctl_init(struct net *net)
+{
+	return 0;
+}
+
+static void nf_tables_sysctl_exit(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
+
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -12141,7 +12280,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
-	return 0;
+	return nf_tables_sysctl_init(net);
 }
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
@@ -12158,6 +12297,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	unsigned int gc_seq;
 
+	nf_tables_sysctl_exit(net);
+
 	mutex_lock(&nft_net->commit_mutex);
 
 	gc_seq = nft_gc_seq_begin(nft_net);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 02ee5fb69871..43f81c81d179 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -259,6 +259,10 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	switch (data->verdict.code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
+		if (pctx->jump_count >= INT_MAX)
+			return -EMLINK;
+
+		pctx->jump_count++;
 		pctx->level++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 58c5b14889c4..0051aa5574e6 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -246,12 +246,16 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
 	struct nft_set_iter iter;
 
 	if (!(priv->set->flags & NFT_SET_MAP) ||
 	    priv->set->dtype != NFT_DATA_VERDICT)
 		return 0;
 
+	if (pctx->jump_count >= INT_MAX)
+		return -EMLINK;
+
 	iter.genmask	= nft_genmask_next(ctx->net);
 	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
@@ -266,6 +270,11 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	if (iter.err < 0)
 		return iter.err;
 
+	/* Verdict maps always have one exact match per lookup at least, count
+	 * only one jump per set reference.
+	 */
+	pctx->jump_count++;
+
 	return 0;
 }
 
-- 
2.30.2

