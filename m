Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32511286D72
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762204684; cv=none; b=KE7/14D9X+qW5ruUKYEa/XefwG55A9qdNIHaywnO03rsVIKfCDQsJCbtH1wiklNLcS2pEE4CtaeMKuLI8rljtuSJQNlG0m1FLLWBKT3pGZchYwvmthJzwd+lVXFxhpqISTFdBjFvBIPRLNZL9I93GSXfHB6P0gnydJKiy5MVgFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762204684; c=relaxed/simple;
	bh=zN0I2oNAqTRjtrsgqMylioIs4Cxe9XHmDDfJx8QaNtM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KnoJR0SYGDzBQgGQaWkVMnozqvBYHnITOnzVqC98gvGWRDAimUhX+hlEY0ZF/YSXC/A3r0s+b4fI6KS8fpfUNWnUzKMpmNqo4THgx6dARxhnaIJET01tiZkwEgsI0zXvOMmxltpegnu9ABlo70E95zNOSwmpUpNxRw+ej0+OJLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=prtIYzE9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="prtIYzE9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D497D6057F;
	Mon,  3 Nov 2025 22:17:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762204670;
	bh=DJnuj8XuWHLfvBX4lFAlM18kJbML97v5VZSHNzeV0Uw=;
	h=From:To:Cc:Subject:Date:From;
	b=prtIYzE9uurTp+XLuqyCsFNhnLYFIypUG1Vc+QJnO5GJdgfm6sCJkr1Gk212Bg8Fk
	 PssEcDikJCq8maTQSdQPhfB4i6uyOjg6Qb7M8I7LPm1hnb2q7WzibYVnuGjkm/qVL2
	 ct1QmeR7s99/l3qWnbywRaXzsmKi9A9coq5808UB9c7YL9uPZyOrOQC7n+2/HOx4A9
	 xsr4OPdbgU2TjZ2Ik/gXQgG1W38SSKakzA6VsWM3wYYMvh3KTRUg66uMIE5rYvrXyZ
	 q3p02nqMuFKh8HzGlE7LezIC6V7k1qnho5Tmm29JfRfeP2jJDZVoPsAkX75a8Tp6a/
	 3irLE9N8u0GaQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fmancera@suse.de,
	fw@strlen.de,
	brady.1345@gmail.com
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: limit maximum number of jumps/gotos per netns
Date: Mon,  3 Nov 2025 22:17:43 +0100
Message-Id: <20251103211744.6613-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new sysctl:

   net.netfilter.nf_tables_jump_max_netns

which is 256000 by default, because old iptables-nft rulesets are more
likely to have more jumps/gotos compared to native nftables rulesets.

This limit prevents soft lockups on the packet caused by crafted
rulesets with too many jumps.

This jump/goto limit is global for all tables that are defined in the
netns, regardless the family type, but IPv4 and IPv6 are mutually
excluded in the jump counting.

Note that verdict maps count as a single jump/goto because a map lookup
provides a single exact match, therefore, this is equivalent to an
immediate jump.

This limit is not the net count of jumps in your ruleset, but the number
of jumps can be visited traversing the acyclic directed graph with
depth-first search. This is done from control plane where the evaluation
of the selectors is not possible, therefore, this represents the
hypothetical worst case.

This patch adds a jump_count[2] field per table which stores the current
number of jumps/gotos in the present [0] and the future [1]. During the
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: - target nf-next instead nf.
    - rise default to 256000, requested by Florian.
    - use check_add_overflow() to deal with jump count overflows.
    - mutually exclude IPv4 and IPv6.
    - use:

       struct {
               int                     jumps;
       } count[2];

      to prepare for sysctl to limit maximum number of rules in netns.

 Documentation/networking/netfilter-sysctl.rst |  19 ++
 include/net/netfilter/nf_tables.h             |   9 +
 include/net/netns/netfilter.h                 |   6 +
 net/netfilter/Makefile                        |   2 +-
 net/netfilter/core.c                          |   9 +
 net/netfilter/nf_tables_api.c                 | 166 +++++++++++++++++-
 net/netfilter/nf_tables_sysctl.c              |  91 ++++++++++
 net/netfilter/nft_immediate.c                 |   4 +
 net/netfilter/nft_lookup.c                    |   9 +
 9 files changed, 310 insertions(+), 5 deletions(-)
 create mode 100644 net/netfilter/nf_tables_sysctl.c

diff --git a/Documentation/networking/netfilter-sysctl.rst b/Documentation/networking/netfilter-sysctl.rst
index beb6d7b275d4..83942c394284 100644
--- a/Documentation/networking/netfilter-sysctl.rst
+++ b/Documentation/networking/netfilter-sysctl.rst
@@ -15,3 +15,22 @@ nf_log_all_netns - BOOLEAN
 	with LOG target; this aims to prevent containers from flooding host
 	kernel log. If enabled, this target also works in other network
 	namespaces. This variable is only accessible from init_net.
+
+nf_tables_jumps_max_netns - INTEGER (count)
+	default 256000
+
+	This is the maximum number of jumps/gotos that a netns can have
+	across its tables. This limit prevents packet path soft lockups
+	caused by rulesets with too many jumps. This limit does not
+	represent the net count of jumps in your ruleset; rather, it
+	represents the number of jumps that can be reached when traversing
+	the ruleset via a depth-first search (DFS). Note that IPv4 and IPv6
+	tables are mutually excluded in this jump count. This limit is
+	determined in the control plane, where evaluating the rule
+	selectors is not possible; therefore, it represents the
+	hypothetical worst case. This limit only applies to non-init_net
+	namespaces and can be read for non-init_user_ns namespaces. Meeting
+	or exceeding this value will prevent additional rules from being
+	added and will return an EMLINK error to the user. Verdict map
+	lookups only count as a single jump, therefore, assuming you do not
+	use iptables-nft your system, then a good alternative default is 256.
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..65ae265428eb 100644
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
+ * 	@jump_count: current [0] and next [1] jump to chain counter
  *	@nlpid: netlink port ID
  *	@name: name of the table
  *	@udlen: length of the user data
@@ -1303,6 +1306,9 @@ struct nft_table {
 	u16				udlen;
 	u8				*udata;
 	u8				validate_state;
+	struct {
+		int			jumps;
+	} count[2];
 };
 
 static inline bool nft_table_has_owner(const struct nft_table *table)
@@ -1903,6 +1909,9 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
 static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
 #endif
 
+int netfilter_nf_tables_sysctl_init(void);
+void netfilter_nf_tables_sysctl_fini(void);
+
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index a6a0bf4a247e..6199f00fa2cb 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -18,6 +18,9 @@ struct netns_nf {
 #ifdef CONFIG_LWTUNNEL
 	struct ctl_table_header *nf_lwtnl_dir_header;
 #endif
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	struct ctl_table_header *nf_tables_dir_header;
+#endif
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
@@ -33,5 +36,8 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	unsigned int defrag_ipv6_users;
 #endif
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	unsigned int nf_tables_jumps_max_netns;
+#endif
 };
 #endif
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6bfc250e474f..cdd9cadbd76c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
+netfilter-objs := core.o nf_log.o nf_tables_sysctl.o nf_queue.o nf_sockopt.o utils.o
 
 nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o \
 		   nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o \
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 11a702065bab..2753e8aa3f1f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <net/net_namespace.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/netfilter/nf_tables.h>
 #include <net/sock.h>
 
 #include "nf_internals.h"
@@ -814,13 +815,21 @@ int __init netfilter_init(void)
 	ret = netfilter_lwtunnel_init();
 	if (ret < 0)
 		goto err_lwtunnel_pernet;
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES)
+	ret = netfilter_nf_tables_sysctl_init();
+	if (ret < 0)
+		goto err_nft_pernet;
 #endif
 	ret = netfilter_log_init();
 	if (ret < 0)
 		goto err_log_pernet;
 
 	return 0;
+
 err_log_pernet:
+	netfilter_nf_tables_sysctl_fini();
+err_nft_pernet:
 #ifdef CONFIG_LWTUNNEL
 	netfilter_lwtunnel_fini();
 err_lwtunnel_pernet:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..6f35f0b7a33c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -112,7 +112,6 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 {
 	switch (table->validate_state) {
 	case NFT_VALIDATE_SKIP:
-		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
 		break;
 	case NFT_VALIDATE_NEED:
 		break;
@@ -140,6 +139,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->net	= net;
 	ctx->family	= family;
 	ctx->level	= 0;
+	ctx->jump_count = 0;
 	ctx->table	= table;
 	ctx->chain	= chain;
 	ctx->nla   	= nla;
@@ -1631,6 +1631,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
+	table->count[1].jumps = -1;
+
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
@@ -4121,13 +4123,14 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
 
-static int nft_table_validate(struct net *net, const struct nft_table *table)
+static int nft_table_validate(struct net *net, struct nft_table *table)
 {
 	struct nft_chain *chain;
 	struct nft_ctx ctx = {
 		.net	= net,
 		.family	= table->family,
 	};
+	int jump_count = 0;
 	int err;
 
 	list_for_each_entry(chain, &table->chains, list) {
@@ -4140,8 +4143,13 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 			return err;
 
 		cond_resched();
+
+		if (check_add_overflow(jump_count, ctx.jump_count, &jump_count))
+			return -EMLINK;
 	}
 
+	table->count[1].jumps = jump_count;
+
 	return 0;
 }
 
@@ -4202,6 +4210,108 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 	return ret;
 }
 
+struct nft_jump_count {
+	int	jumps;
+	int	jumps_ipv4;
+	int	jumps_ipv6;
+};
+
+static int nft_jump_count_update(const struct nft_table *table,
+				 struct nft_jump_count *count)
+{
+	int idx;
+
+	/* If table has been updated with new jumps in this batch, then
+	 * use future jump count. Otherwise, use current jump count.
+	 */
+	if (table->count[1].jumps < 0)
+		idx = 0;
+	else
+		idx = 1;
+
+	switch (table->family) {
+	case NFPROTO_IPV4:
+		if (check_add_overflow(count->jumps_ipv4,
+				       table->count[idx].jumps,
+				       &count->jumps_ipv4))
+			return -1;
+		break;
+	case NFPROTO_IPV6:
+		if (check_add_overflow(count->jumps_ipv6,
+				       table->count[idx].jumps,
+				       &count->jumps_ipv6))
+			return -1;
+		break;
+	default:
+		if (check_add_overflow(count->jumps, table->count[idx].jumps,
+				       &count->jumps))
+			return -1;
+		break;
+	}
+
+	return 0;
+}
+
+static int nft_jump_count(struct net *net, struct nft_jump_count *count)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		if (!nft_is_active_next(net, table))
+			continue;
+
+		if (nft_jump_count_update(table, count) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int nft_jump_count_ipv4(struct net *net,
+			       const struct nft_jump_count *count)
+{
+	int jumps;
+
+	if (check_add_overflow(count->jumps, count->jumps_ipv4, &jumps))
+		return -1;
+
+	return jumps;
+}
+
+static int nft_jump_count_ipv6(struct net *net,
+			       const struct nft_jump_count *count)
+{
+	int jumps;
+
+	if (check_add_overflow(count->jumps, count->jumps_ipv6, &jumps))
+		return -1;
+
+	return jumps;
+}
+
+static int nft_jump_count_check(struct net *net)
+{
+	u32 count_ipv4 = 0, count_ipv6 = 0;
+	struct nft_jump_count count = {};
+
+	if (net_eq(net, &init_net))
+		return 0;
+
+	if (nft_jump_count(net, &count) < 0)
+		return -EMLINK;
+
+	count_ipv4 = nft_jump_count_ipv4(net, &count);
+	if (count_ipv4 > net->nf.nf_tables_jumps_max_netns)
+		return -EMLINK;
+
+	count_ipv6 = nft_jump_count_ipv6(net, &count);
+	if (count_ipv6 > net->nf.nf_tables_jumps_max_netns)
+		return -EMLINK;
+
+	return 0;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4421,8 +4531,17 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
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
 
@@ -10109,6 +10228,17 @@ static int nf_tables_validate(struct net *net)
 		}
 	}
 
+	if (nft_jump_count_check(net) < 0) {
+		list_for_each_entry(table, &nft_net->tables, list) {
+			if (table->count[1].jumps < 0)
+				continue;
+
+			nft_validate_state_update(table, NFT_VALIDATE_DO);
+		}
+
+		return -EAGAIN;
+	}
+
 	return 0;
 }
 
@@ -10869,6 +10999,30 @@ static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
 	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
 }
 
+static void nft_jump_count_reset(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list)
+		table->count[1].jumps = -1;
+}
+
+static void nft_jump_count_commit(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		/* no new jumps in this table, skip. */
+		if (table->count[1].jumps < 0)
+			continue;
+
+		table->count[0].jumps = table->count[1].jumps;
+		table->count[1].jumps = -1;
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -10926,6 +11080,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (err < 0)
 		return err;
 
+	nft_jump_count_commit(net);
+
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -11266,6 +11422,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	    nf_tables_validate(net) < 0)
 		err = -EAGAIN;
 
+	nft_jump_count_reset(net);
+
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
 		struct nft_table *table = trans->table;
diff --git a/net/netfilter/nf_tables_sysctl.c b/net/netfilter/nf_tables_sysctl.c
new file mode 100644
index 000000000000..88b52f5d4bac
--- /dev/null
+++ b/net/netfilter/nf_tables_sysctl.c
@@ -0,0 +1,91 @@
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/net_namespace.h>
+
+#ifdef CONFIG_SYSCTL
+enum nf_ct_sysctl_index {
+	NF_SYSCTL_NFT_JUMPS_MAX,
+	NF_SYSCTL_NFT_LAST_SYSCTL
+};
+
+static struct ctl_table nf_tables_sysctl_table[] = {
+	[NF_SYSCTL_NFT_JUMPS_MAX] = {
+		.procname       = "nf_tables_jumps_max_netns",
+		.data           = &init_net.nf.nf_tables_jumps_max_netns,
+		.maxlen         = sizeof(init_net.nf.nf_tables_jumps_max_netns),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
+	},
+};
+
+#define NFT_TABLE_DEFAULT_JUMPS_MAX 256000
+
+static int __net_init nf_tables_sysctl_init(struct net *net)
+{
+	struct ctl_table *table = nf_tables_sysctl_table;
+
+	BUILD_BUG_ON(ARRAY_SIZE(nf_tables_sysctl_table) != NF_SYSCTL_NFT_LAST_SYSCTL);
+
+	if (net_eq(net, &init_net)) {
+		net->nf.nf_tables_jumps_max_netns = NFT_TABLE_DEFAULT_JUMPS_MAX;
+	} else {
+		table = kmemdup(nf_tables_sysctl_table,
+				sizeof(nf_tables_sysctl_table), GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+
+		net->nf.nf_tables_jumps_max_netns =
+			init_net.nf.nf_tables_jumps_max_netns;
+		table[NF_SYSCTL_NFT_JUMPS_MAX].data =
+			&net->nf.nf_tables_jumps_max_netns;
+
+		if (net->user_ns != &init_user_ns)
+			table[NF_SYSCTL_NFT_JUMPS_MAX].mode &= ~0222;
+	}
+
+	net->nf.nf_tables_dir_header =
+		register_net_sysctl_sz(net, "net/netfilter", table,
+				       ARRAY_SIZE(nf_tables_sysctl_table));
+	if (!net->nf.nf_tables_dir_header)
+		goto err_tbl_free;
+
+	return 0;
+
+err_tbl_free:
+	if (table != nf_tables_sysctl_table)
+		kfree(table);
+
+	return -ENOMEM;
+}
+
+static void nf_tables_sysctl_exit(struct net *net)
+{
+	const struct ctl_table *table;
+
+	unregister_net_sysctl_table(net->nf.nf_tables_dir_header);
+	table = net->nf.nf_tables_dir_header->ctl_table_arg;
+	if (!net_eq(net, &init_net))
+		kfree(table);
+}
+
+static struct pernet_operations nf_tables_sysctl_net_ops = {
+	.init = nf_tables_sysctl_init,
+	.exit = nf_tables_sysctl_exit,
+};
+
+int __init netfilter_nf_tables_sysctl_init(void)
+{
+	return register_pernet_subsys(&nf_tables_sysctl_net_ops);
+}
+
+void netfilter_nf_tables_sysctl_fini(void)
+{
+	unregister_pernet_subsys(&nf_tables_sysctl_net_ops);
+}
+#else
+int __init netfilter_nf_tables_sysctl_init(void) { return 0; }
+void netfilter_nf_tables_sysctl_fini(void) {}
+#endif /* CONFIG_SYSCTL */
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

