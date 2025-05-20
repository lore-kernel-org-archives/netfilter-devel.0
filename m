Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25F1DE88C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 03:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747710527; cv=none; b=DsbxWKosnsaSdcLn257b26hj0DwZXt77zQPiIxGirioMBQaK5jThwlrVgpSfLof1MfBaatD5bHnJjybDn7nG3g1bVrOxunaurXvmwucZQc3sl0UiEH+hNrbtf6buyDES90DIYJ0G55f6w62xDzx/IQrf8vWo/q3q/BL7arOATQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747710527; c=relaxed/simple;
	bh=IpLn3bM+ChdgBmAMXZOnj7ZsdxUmrGVioIXBNbT5dhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KzdMwp7dYlkQ8pVEEura7q8bAC2LV1NqMcwwlKxfxKy2OX1IPekCZhWruvb5sqdmbesgs3jvP8xJq/KpwEDhXLdd31Y3uN3P20NImaziuTLeRAD03Hiq7Ow3oYLdfj93OS4BFNpDdb5FUWmqCkieRJGmpCOvRZv4fIDWV1oPVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtUWJqNS; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtUWJqNS"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6f8b2682d61so39993236d6.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 May 2025 20:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747710524; x=1748315324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bq3u/+bdX7NLRfN2nrCmu/c8rUkc8Zh5gwGXCM/1qJE=;
        b=BtUWJqNS6jaAGwRJv0R4M7prpVknIq2CljFjtuTuz6NljVtt5fT+9lqUgQMPATvfDi
         iMPB/r9e92uuwbQQURT3civJij7s4l5pXZENZtcaPUVbpbmQJ4Md/3qtMDYALrbQbYvg
         v0VzNprTYGIBSb8wpVmLgPfBnawXl1JKM+/HgtNZvsQniKMy82qdwcJfZUIuRMmcQkQz
         iV0CinU1h+vFtlFV6tJRpbMssB0khoebmw8tqfo3cPv3msAVUsTxp5FTb4SUJV4uBdo3
         0dPqY8KTVi/lFEStDartysiJqnRGXevvoQCPT6at3ZwLhOXcuMr6p9BbDxDrIpF+qj+e
         +sFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747710524; x=1748315324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bq3u/+bdX7NLRfN2nrCmu/c8rUkc8Zh5gwGXCM/1qJE=;
        b=SvNKG53ZVCZ3z+713FljiGo+kG8d69E2xfMbR6YpymbWiNBcOKOj5q/uFtqT9SULkg
         Hx1aCzNDUzthlquh03/qrL321OBaNNcTsmhg+1IUX5WXiHsey+KSfRD1W5p2nwFvXhdz
         8XgzB3XzpRY/tTzCR8lG3O9i8kefy3TpDpZDja2RlhETtTVOiNk6JPdOmmCZEHlI4TsI
         3Zxik3tkKtI3PfkZfpZkEuhA9Y7YfiUDgFVtpv+wEE1yaBpApLZYEXPjUxcBdAqNX1gn
         lfy29NFr1qpM16yljHtYt29+cpMuxedlr41fUKr9yihSrBGPf49SEY3mzgop7dYNKIVE
         byew==
X-Gm-Message-State: AOJu0YylSIEOruKO3b+SzTK5T4y8hEQLs2ipVdOqarL41ljOp6XWkwfG
	3gjudbvTYsiBNmYPI+5BZNDank8b81tD5qlSsyAPGagn7E337Y4upZ6oBHLbag==
X-Gm-Gg: ASbGncumlxWW6IfIr6mQP1YdD6Rcr8ke9LFkZeyN1VewocV3ywM6C0vyTpDSZgVhNAQ
	lI3T4pKpm6tOePrj2MWIH9UR+sd55lI4RPP47w7c20VpTfZk92NTmKU0MV/9dRL/vYv5QH4uwhJ
	tLJ8dA88mmHvnsZtYn3obX5En1P3OijZXFPZNVLGb2XB9AzMcF78UMOO5nTSoGYtryrximk91ke
	oPV2c2GwUEy1+jpEfykHMZNvcTBhuGflEspQpB8I5f7CC8nbv7CXgoBFAS+2RYLfq7Qk0ijRtID
	7+LbWxslMpe+BJZqFU0f1K6hmXrpRQpO76jrpfg7spp2stsF7Pj/hy0hXZUavN9xs/V2ICvfMjC
	1AuXU6QswXe110RrUtBTfwA==
X-Google-Smtp-Source: AGHT+IHyVlheFdL0i9jyRYHB6wYHke2AeD+Y8yxuS/C00zSJtbj6vQKcwle9Gd7PsBQfeqvFwgGWMw==
X-Received: by 2002:ad4:5dc1:0:b0:6f8:ad11:276a with SMTP id 6a1803df08f44-6f8b12e9551mr257180536d6.19.1747710523994;
        Mon, 19 May 2025 20:08:43 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b097a3dbsm65449146d6.101.2025.05.19.20.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 20:08:43 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for nft_table_validate
Date: Mon, 19 May 2025 23:08:41 -0400
Message-ID: <20250520030842.3072235-1-brady.1345@gmail.com>
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

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
---
 Documentation/networking/netfilter-sysctl.rst |   9 ++
 include/net/netfilter/nf_tables.h             |   4 +
 include/net/netns/netfilter.h                 |   2 +
 net/netfilter/nf_tables_api.c                 | 125 +++++++++++++++++-
 net/netfilter/nft_immediate.c                 |   1 +
 5 files changed, 139 insertions(+), 2 deletions(-)

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
index 803d5f1601f9..61b8ae421e4f 100644
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
@@ -1275,6 +1277,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
+ *	@total_jump_count: jumps as per last validate
  *	@family:address family
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
@@ -1294,6 +1297,7 @@ struct nft_table {
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
index b28f6730e26d..78dcd0381ed7 100644
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
@@ -4011,8 +4013,16 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
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
@@ -4039,14 +4049,62 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
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
+static int nft_table_validate(struct net *net, struct nft_table *table)
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
+			if(nft_families_inc_jump(table, sibling_table))
+				ctx.total_jump_count += sibling_table->total_jump_count;
+		}
+	}
+
+	total_jumps_before_validate = ctx.total_jump_count;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4060,6 +4118,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		cond_resched();
 	}
 
+	table->total_jump_count = ctx.total_jump_count - total_jumps_before_validate;
+
 	return 0;
 }
 
@@ -4084,6 +4144,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
@@ -11916,6 +11977,59 @@ static struct notifier_block nft_nl_notifier = {
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
@@ -11933,6 +12047,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
+	int ret = netfilter_limit_control_sysctl_init(net);
+
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -11971,6 +12090,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
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

