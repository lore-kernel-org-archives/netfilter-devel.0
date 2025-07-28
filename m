Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7D61FC3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 04:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753675404; cv=none; b=IaPn2GiDytU6z+Egk1KkwOobA96f5wyIu+NHhekwuzhQq5vGFWCmnJfNsxb6/uyaqJxzyF6bIT20Iaq5/jVM1UEPeMZw2DSupaoGXE5G889j3VrtqmOKt4SIyAo0VCkYyCV+F+qxsYg/qQzIXpx20d3MaAIOKotwl1Zhe1ML+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753675404; c=relaxed/simple;
	bh=PUIcNDB1qX3aGUsbwZqybxjG3Nc0iVeTjgZfoZYgKD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h2NFypcUJ4rG/KNUFOXI3z3L4j7tJsbnPDAK2OxOCn/UCcyzoy5k55IFKrBMoAwFJRDSDeW8m01rHWkBFa7YWIK7wtNJKfRtmNfw8e1MliDxb5PSlEID2jRDeGoBXYvllXymaPY25lVquRVLSA+YVnrI8SD3emEsr8FnUvUch5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3fjU+3T; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3fjU+3T"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-707365f4d47so13198016d6.1
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jul 2025 21:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753675397; x=1754280197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IpE879cxSJjpHX2CizwKYFHKYXy4MxYf15gl4bGHp+k=;
        b=d3fjU+3TqAlG7WQdlMi93WybMsH04Lpf7GNtl6DG291bmb+45Cn6HUaEEDZz8P0/3E
         gIl3qNcKicN99nIFAVz1rZairnmfDyrvF2BKxTR1bKU8AZ6U8HRcXACR5UO4Ips7661r
         EBJrF+LBrTWboJAUgVq76r7GkiAH+ZgdqnbXyCbcjZ5JUrlwDaOlZ4z+rjBr8wwzc8DD
         NqoRCrg9F5rzchD4gSe+5E5DW+G3AQSY3hyl48dPWaYrVe2r+zdFhZvOknCVxlEy3KL+
         QDu8058CqPowGdn1SbaRfOrdq4y9vcZq1aYsP7sEFL2yW6LaF/Bi2foey83t+/o1Gn/E
         BdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753675397; x=1754280197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IpE879cxSJjpHX2CizwKYFHKYXy4MxYf15gl4bGHp+k=;
        b=GbNmO1TL3Dqu6PH55IW5fKwBsCWYrrqq/IC/E2tTdkpMcA4KwQo86f6lAWlaW6QOoV
         lMaMakjdlGBi76tmsOh8Pm0/bdaK8W/suGnWy/a4HZV2SOZXQdrne0gjTl+R3tGK9IK7
         o1KsvNJD/pvz6uPlMm8mlZ1j57CoKJjXwBIl8UapJILP/ydRvDDXoqjkX5QbUIvfxjx4
         ZgjFPgInICr0ipUOqkGjPZMpMUMpqkgPFNKJHA9v9Rk3e2uafOuup92wnR+ZJyCAS579
         TQFbOkskDe95rgYtubP9qOhBd1oIy1dyg+85Q43qZC52/ZkOZSZLjxqZQMNQqdEXVSdb
         /1VQ==
X-Gm-Message-State: AOJu0Yyl4QjnypvWhi48SVhPZr7iWJSFo7R1p1KqKVRxjXxEr3eTqj9H
	hbw0U6DcAu90s1eYAaRUi6ZM+OsiBZoM4ffESL72myp6mRU4X10ra94LSIMqZw==
X-Gm-Gg: ASbGnct1onCUTs/i7TxtHgW2ydSmHvuqAPOrCL2ok06z5J9ZQ0F44aY1V+7QFF7c8Ue
	ll2dh/ObsaRNEC1SJnJeP1ofWg8PE9DTkYlmb6RSPm4FQKbBh7AYPuH/k3baoWP5bNHYSCrIYHG
	1seAEzh8nJWBYCKWj9IaxQx4V4/d6LdRnggLZZDBbBPlHxxFOHZz9Z6EyUC2uWqglpdIXnJCNBQ
	Ll0ZBNlA6pwMq+IB1eZXJ8bsn3qaa3F+DzqlFojVX+YPuXhMVVDFMFab2Iy4MnQ3stEiuQ4Ga8y
	KkchOET0YC5h5mtRrMkr/Be3nKVVEZkF2hSz7LwI4zcNYmtR9r2CRHpD7v5uC2QWeJ42F3MoqrX
	7Xx1oAn1BV6+OGef6i7qgGE523HWIPIZgJN4ZZUvgQfw5UqUJj3CHza1Z+1Y1fPO5jm0e
X-Google-Smtp-Source: AGHT+IFPpNg8Nm4UlydS93LUAQOKgaL5RINyPZl47WqrTAuZbtLcccrSlVDk4neWqNscsTTJji5pHw==
X-Received: by 2002:a05:6214:2624:b0:702:c038:af78 with SMTP id 6a1803df08f44-7071fdbbdbemr140779706d6.5.1753675396755;
        Sun, 27 Jul 2025 21:03:16 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7074b52ddc7sm4928576d6.77.2025.07.27.21.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 21:03:16 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v6 1/2] netfilter: nf_tables: Implement jump limit for nft_table_validate
Date: Mon, 28 Jul 2025 00:03:14 -0400
Message-ID: <20250728040315.1014454-1-brady.1345@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Observing https://bugzilla.netfilter.org/show_bug.cgi?id=1665, I was
able to reproduce the bug using linux-stable.  Summarized, when adding
large/repeated jump chains, while still staying under the
NFT_JUMP_STACK_SIZE (currently 16), the kernel soons locks up.

From the bug report:
  table='loop-test'
  nft add table inet $table
  nft add chain inet $table test0 '{type filter hook input priority 0; policy accept;}'
  for((i=1;i<16;i++));do nft add chain inet $table test$i;done
  nft add rule inet $table test0 jump test1
  for((i=1;i<15;i++));do nft add rule inet $table test$i jump test$((i+1));done
  nft add rule inet $table test15 tcp dport 8080 drop

  After the jump rule is added for 3 to 5 times, the system freezes and even softlockup occurs.
  for((i=1;i<15;i++));do nft add rule inet $table test$i jump test$((i+1));done
  for((i=1;i<15;i++));do nft add rule inet $table test$i jump test$((i+1));done
  for((i=1;i<15;i++));do nft add rule inet $table test$i jump test$((i+1));done

This patch is a different approach than the original proposed approach
found in the bug report.  Additionally, the limit, namespace specific,
is only applied to non-init-net namespaces, with the common use case
being to protect against rogue containers.

Add a new counter, total_jump_counter, to nft_ctx.  On every call to
nft_table_validate() (rule addition time, versus packet inspection time)
start the counter at the current sum of all jump counts in all other
tables, sans 4 vs 6 differences.

Increment said counter for every jump encountered during table
validation.  If the counter ever exceeds the namespaces jump limit
*during validation*, gracefully reject the rule with -EMLINK (the same
behavior as exceeding NFT_JUMP_STACK_SIZE).

This allows immediate feedback to the user about a bad chain, versus the
original idea (from the bug report) of allowing the addition to the
table.  It keeps the in memory ruleset consistent, versus catching the
failure during packet inspection at some unknown point in the future and
arbitrarily denying the packet.  Most importantly, it removes the
original problem of a kernel crash.

The compile time limit NFT_DEFAULT_MAX_TABLE_JUMPS of 65536 was chosen
to account for any normal use case, and when this value (and associated
stressing loop table) was tested against a 1CPU/256MB machine, the
system remained functional.

A sysctl entry net/netfilter/nf_max_table_jumps_netns for the limit was
also added for any use cases that may exceed this limit.  It is network
namespace specific.  As it is a control limit, for namespaces with an
owner that is non-init_user_ns, this sysctl is read only.

Example output of nft when patch is applied (and count is reached):

Error: Could not process rule: Too many links
add rule inet loop-test test14 jump test15
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

v2: nf_max_table_jumps renamed to nf_max_table_jumps_netns;
    Limit namespace specific, only applies to non-init netns;
    Limit raised to 16k
v3: Fix improper conditional compile; removed unneeded pernet subsys;
    Include NFPROTO_IPV4|6 for _INET matches; add selftest script
v4: Simplify table jump count logic in for netns
v5: Move jump family test to helper function; move test to second commit
v6: Catch null pointer, syntax, thumb down total update in abort state

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
---
 Documentation/networking/netfilter-sysctl.rst |   9 ++
 include/net/netfilter/nf_tables.h             |   4 +
 include/net/netns/netfilter.h                 |   2 +
 net/netfilter/nf_tables_api.c                 | 144 +++++++++++++++++-
 net/netfilter/nft_immediate.c                 |   1 +
 5 files changed, 152 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/netfilter-sysctl.rst b/Documentation/networking/netfilter-sysctl.rst
index beb6d7b275d4..8a87c72f0672 100644
--- a/Documentation/networking/netfilter-sysctl.rst
+++ b/Documentation/networking/netfilter-sysctl.rst
@@ -15,3 +15,12 @@ nf_log_all_netns - BOOLEAN
 	with LOG target; this aims to prevent containers from flooding host
 	kernel log. If enabled, this target also works in other network
 	namespaces. This variable is only accessible from init_net.
+
+nf_max_table_jumps_netns - INTEGER (count)
+	default 65536
+
+	The maximum numbers of jumps a netns can have across its tables.
+	This only applies to non-init_net namespaces, and is read only for
+	non-init_user_ns namespaces.  Meeting or exceeding this value will
+	cause additional rules to not be added, with EMLINK being return to
+	the user.
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 891e43a01bdc..8f809c2d0942 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -205,6 +205,7 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
  *	@nla: netlink attributes
  *	@portid: netlink portID of the original message
  *	@seq: netlink sequence number
+ *	@total_jump_count: Found jumps for netns
  *	@flags: modifiers to new request
  *	@family: protocol family
  *	@level: depth of the chains
@@ -218,6 +219,7 @@ struct nft_ctx {
 	const struct nlattr * const 	*nla;
 	u32				portid;
 	u32				seq;
+	u32				total_jump_count;
 	u16				flags;
 	u8				family;
 	u8				level;
@@ -1274,6 +1276,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
+ *	@total_jump_count: jumps as per last validate
  *	@family:address family
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
@@ -1293,6 +1296,7 @@ struct nft_table {
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
+	u32				total_jump_count;
 	u16				family:6,
 					flags:8,
 					genmask:2;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index a6a0bf4a247e..c0dcd85d108c 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -15,6 +15,7 @@ struct netns_nf {
 	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
+	struct ctl_table_header *nf_limit_control_dir_header;
 #ifdef CONFIG_LWTUNNEL
 	struct ctl_table_header *nf_lwtnl_dir_header;
 #endif
@@ -33,5 +34,6 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	unsigned int defrag_ipv6_users;
 #endif
+	u32 nf_max_table_jumps_netns __maybe_unused;
 };
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13d0ed9d1895..4789122ebca3 100644
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
@@ -25,6 +26,7 @@
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
+#define NFT_DEFAULT_MAX_TABLE_JUMPS 65536
 
 /* limit compaction to avoid huge kmalloc/krealloc sizes. */
 #define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
@@ -4062,8 +4064,16 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
 	int err;
+	u32 jump_check = NFT_DEFAULT_MAX_TABLE_JUMPS;
 
-	if (ctx->level == NFT_JUMP_STACK_SIZE)
+	if (IS_ENABLED(CONFIG_SYSCTL)) {
+		if (!net_eq(ctx->net, &init_net))
+			jump_check = ctx->net->nf.nf_max_table_jumps_netns;
+	}
+
+	if (ctx->level == NFT_JUMP_STACK_SIZE ||
+	    (!net_eq(ctx->net, &init_net) &&
+	    ctx->total_jump_count >= jump_check))
 		return -EMLINK;
 
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -4090,14 +4100,63 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
 
-static int nft_table_validate(struct net *net, const struct nft_table *table)
+/** nft_families_inc_jump - Determine if tables should add to the total jump
+ * count for a netns.
+ *
+ * @table: table of interest
+ * @sibling_table: a 'sibling' table to compare against
+ *
+ * Compare attributes of the tables to determine if the sibling tables
+ * total_jump_count should be added to the working context (done by caller).
+ * Mostly concerned with family compatibilities, but also identifying equality
+ * (a tables own addition will be recalculated soon).
+ *
+ * Ex: v4 tables do not apply to v6 packets
+ */
+static bool nft_families_inc_jump(struct nft_table *table, struct nft_table *sibling_table)
+{
+	/* Invert parameters to on require one test for two cases (the reverse) */
+	if (sibling_table->family > table->family) /* include/uapi/linux/netfilter.h */
+		return nft_families_inc_jump(sibling_table, table);
+
+	/* We found ourselves; don't add current jump count (will be counted dynamically) */
+	if (sibling_table == table)
+		return false;
+
+	switch (table->family) {
+	case NFPROTO_IPV4:
+		if (sibling_table->family == NFPROTO_IPV6)
+			return false;
+		break;
+	}
+
+	return true;
+}
+
+static int nft_table_validate(struct net *net, struct nft_table *table,
+			      enum nfnl_abort_action action)
 {
 	struct nft_chain *chain;
+	struct nftables_pernet *nft_net;
 	struct nft_ctx ctx = {
 		.net	= net,
 		.family	= table->family,
+		.total_jump_count = 0,
 	};
 	int err;
+	u32 total_jumps_before_validate;
+	struct nft_table *sibling_table;
+
+	nft_net = nft_pernet(net);
+
+	if (!net_eq(net, &init_net)) {
+		list_for_each_entry(sibling_table, &nft_net->tables, list) {
+			if (nft_families_inc_jump(table, sibling_table))
+				ctx.total_jump_count += sibling_table->total_jump_count;
+		}
+	}
+
+	total_jumps_before_validate = ctx.total_jump_count;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4111,6 +4170,12 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		cond_resched();
 	}
 
+	/* nft_table_validate() must be called in abort, but values will be
+	 * incorrect at call time (rollback has yet to happen)
+	 */
+	if (action != NFNL_ABORT_VALIDATE)
+		table->total_jump_count = ctx.total_jump_count - total_jumps_before_validate;
+
 	return 0;
 }
 
@@ -4135,6 +4200,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
@@ -4391,7 +4457,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		nft_trans_flow_rule(trans) = flow;
 
 	if (table->validate_state == NFT_VALIDATE_DO)
-		return nft_table_validate(net, table);
+		return nft_table_validate(net, table, NFNL_ABORT_NONE);
 
 	return 0;
 
@@ -7630,7 +7696,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	}
 
 	if (table->validate_state == NFT_VALIDATE_DO)
-		return nft_table_validate(net, table);
+		return nft_table_validate(net, table, NFNL_ABORT_NONE);
 
 	return 0;
 }
@@ -10046,7 +10112,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
-static int nf_tables_validate(struct net *net)
+static int nf_tables_validate(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
@@ -10059,7 +10125,7 @@ static int nf_tables_validate(struct net *net)
 			nft_validate_state_update(table, NFT_VALIDATE_DO);
 			fallthrough;
 		case NFT_VALIDATE_DO:
-			if (nft_table_validate(net, table) < 0)
+			if (nft_table_validate(net, table, action) < 0)
 				return -EAGAIN;
 
 			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
@@ -10875,7 +10941,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
-	if (nf_tables_validate(net) < 0) {
+	if (nf_tables_validate(net, NFNL_ABORT_NONE) < 0) {
 		nft_net->validate_state = NFT_VALIDATE_DO;
 		return -EAGAIN;
 	}
@@ -11220,7 +11286,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	int err = 0;
 
 	if (action == NFNL_ABORT_VALIDATE &&
-	    nf_tables_validate(net) < 0)
+	    nf_tables_validate(net, action) < 0)
 		err = -EAGAIN;
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
@@ -12081,6 +12147,61 @@ static struct notifier_block nft_nl_notifier = {
 	.notifier_call  = nft_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table nf_limit_control_sysctl_table[] = {
+	{
+		.procname	= "nf_max_table_jumps_netns",
+		.data		= &init_net.nf.nf_max_table_jumps_netns,
+		.maxlen		= sizeof(init_net.nf.nf_max_table_jumps_netns),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int netfilter_limit_control_sysctl_init(struct net *net)
+{
+	struct ctl_table *tbl;
+
+	net->nf.nf_max_table_jumps_netns = NFT_DEFAULT_MAX_TABLE_JUMPS;
+	tbl = nf_limit_control_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		tbl = kmemdup(tbl, sizeof(nf_limit_control_sysctl_table), GFP_KERNEL);
+		if (!tbl)
+			goto err_alloc;
+		tbl->data = &net->nf.nf_max_table_jumps_netns;
+		if (net->user_ns != &init_user_ns)
+			tbl->mode &= ~0222;
+	}
+
+	net->nf.nf_limit_control_dir_header = register_net_sysctl_sz(
+		net, "net/netfilter", tbl, ARRAY_SIZE(nf_limit_control_sysctl_table));
+
+	if (!net->nf.nf_limit_control_dir_header)
+		goto err_alloc;
+
+	return 0;
+
+err_alloc:
+	if (tbl != nf_limit_control_sysctl_table)
+		kfree(tbl);
+	return -ENOMEM;
+}
+
+static void netfilter_limit_control_sysctl_exit(struct net *net)
+{
+	unregister_net_sysctl_table(net->nf.nf_limit_control_dir_header);
+}
+#else
+static int netfilter_limit_control_sysctl_init(struct net *net)
+{
+	return 0;
+}
+
+static void netfilter_limit_control_sysctl_exit(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
+
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -12098,6 +12219,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
+	int ret = netfilter_limit_control_sysctl_init(net);
+
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -12136,6 +12262,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
+
+	netfilter_limit_control_sysctl_exit(net);
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 02ee5fb69871..b21736e389a4 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -260,6 +260,7 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
-- 
2.49.0

