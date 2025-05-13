Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9991A0B0E
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2025 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102141; cv=none; b=igdIlfImMxB6UA43qNn64f9qAO7d7baYsEyXl2bgOtifeQH4ucplPNmac+Ov3gdr4j2cWn+aTAvhdIhSs/lePQu1Gagn7shJHhoYznccqIEarBnzPnd6GmRjWc5Xa/Wj8HdjNIQrKJMtC/g2TzPZ/Nm3eV2wRlGniKURQYAE1r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102141; c=relaxed/simple;
	bh=kXRMHYYqLxpumHvVBP6wUzBhK46FCwTtd7TAdhdBTi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X0liEcq/V5dUTUplwSKSA+5us41ibibyHT1tYY8gCP5aEJeZ07hbcsl5ayTs7jJ0/cq7Ium11VonZnq1rj4Hu4eaa4js0MgJS3n5HKp4DBG5Yn+N0sBwSLeA/FFF5qHMcmk5RytSc0DJyZdckstQao9Vqq2HW0IfqaO6anEIlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcGrCz+D; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcGrCz+D"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6f0ad74483fso58359256d6.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 19:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747102138; x=1747706938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C1TL1q/Y8d4Q6WygDifr+GbGXNppc7aN+DZUJ9qzJWo=;
        b=QcGrCz+D0e6X3YSlgPwMCG7qONj5X1bKVOjYpJNTr+yCrBaZcqQWgxelWw8b6eFkwx
         yEtdU7jXz+KTfXCwu5xia4GAJsNnEhPVbsn+jxk1hyH2/iCQSUl1HNapbcpftSq1T4Te
         ibps355Ed/8CxUVFrhoHh6UmH7rEVRUOz8LRWj7394dvCoXcCn8CTPA4Jqy+T5HLIg4R
         /9xBCkUTmClUbxMbCeVPpgP1IxQDn8eXXQUS1viNlFyV0DV5OFep+lfIVpmQhSSE3lY/
         3qESWSGW5jxbMLkxiqaSk0m2XLD/0RYCmgj1Ve3KwpCtKpSlf9/CvdmX6NVlbP+N0l67
         tRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747102138; x=1747706938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1TL1q/Y8d4Q6WygDifr+GbGXNppc7aN+DZUJ9qzJWo=;
        b=hZXB+ONiPoYn7iiR5r/YdkVHbAn5xnc/1E5vjPK48d/WLss4WzJ3iiP9l0G7Rt1wsW
         kK3qWUjwJJuLwryYH/OnRtRlyhKszLaMGX7xX/2ENNutGAwPRPHWBPX5LaR8X9hlBZ1U
         o0+R4dsqjYI2E4a6l8DL7KHuIDIUjpJnMEjGf2kWtFArjnr00NuLPAJWpk6kmQ1DEmYy
         V4yaJwZJ3o+VG/UtUahMJHI5xcALfDV5XWz6eWSqOo4WFgSu/GAm4Nv3TLk4XLxi6XZ5
         yNntThhvDbTXLRFip9XvISN5HUsGrkEcHibM4bCYfRltCkxdEmabseNMcSxFhLCHQV4d
         B4fg==
X-Gm-Message-State: AOJu0YyVMzNtcUJr2AfzvYg43DPexNfiOynuXnqQymjk4/KnXvvEaxb8
	wg/ZWnLie39rh3oouE5pINJkOngwb8wqWpheR5JBEM4eS2LH+0A+UW1gPQ==
X-Gm-Gg: ASbGncuitlKzlb/U57pvjzS5OFSAC7Vvmn/T5A5OT86Vr3alpbqPJbQ9HN4NH4S1ZKW
	RuxRb/dya2pyfiY4lCkH8vjiNV0pgZv9Z007uufFbZG0a70ln5x1Rva86a/O22AjzZlYPyPTRTr
	bhII5e0Vtw2s24t0Yfru2o2Eikp4l+yn1XMlRnxAzOcRs3Q4d3dZixiIuOd84cA6lLX9JG2XAZ1
	FZqi/WwVYoJ3fFBN94hHSiJAvB51+RGUYTZC9K6Z/9dVEWobTjztvfwiUiO9tUlOzmpDFmUkd2H
	HWvHDL435EhUNthSb2VV2ERnghx4fswcww3WQ4WzPB97rKjBEaHj9mwy76nh274I6GSh5Ol6HDX
	RLmK8QZi2JwE=
X-Google-Smtp-Source: AGHT+IER9y7+VnnpBcMvBbK7sFD4WBjY4h2WuirlOKNioJZnJAVyOVFHd9Tdk6g9ykPliTKcYRSEbQ==
X-Received: by 2002:ad4:5763:0:b0:6f5:115c:9bfc with SMTP id 6a1803df08f44-6f6e47ed64bmr212376526d6.24.1747102137526;
        Mon, 12 May 2025 19:08:57 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39e0721sm61063776d6.12.2025.05.12.19.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 19:08:57 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de
Subject: [PATCH v3] netfilter: nf_tables: Implement jump limit for nft_table_validate
Date: Mon, 12 May 2025 22:08:56 -0400
Message-ID: <20250513020856.2466270-1-brady.1345@gmail.com>
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
tables with the same family, as well as netdev.

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

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
---
 Documentation/networking/netfilter-sysctl.rst |   9 +
 include/net/netfilter/nf_tables.h             |   4 +
 include/net/netns/netfilter.h                 |   2 +
 net/netfilter/nf_tables_api.c                 | 100 +++++++-
 net/netfilter/nft_immediate.c                 |   1 +
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../netfilter/nft_max_table_jumps_netns.sh    | 218 ++++++++++++++++++
 7 files changed, 333 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh

diff --git a/Documentation/networking/netfilter-sysctl.rst b/Documentation/networking/netfilter-sysctl.rst
index beb6d7b275d4..528b55b3ecd4 100644
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
+                    The maximum numbers of jumps a table family (+ netdev) can
+                    have. This only applies to non-init_net namespaces, and is read
+                    only for non-init_user_ns namespaces. Meeting or exceeding this
+                    value will cause additional rules to not be added, with EMLINK being
+                    return to the user.
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 803d5f1601f9..800326da83a1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -205,6 +205,7 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
  *	@nla: netlink attributes
  *	@portid: netlink portID of the original message
  *	@seq: netlink sequence number
+ *	@total_jump_count: Found jumps for family set + netdev
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
index b28f6730e26d..b9fa35d8d1a2 100644
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
@@ -25,10 +26,13 @@
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
+#define NFT_DEFAULT_MAX_TABLE_JUMPS 65536
 
 /* limit compaction to avoid huge kmalloc/krealloc sizes. */
 #define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
 
+u32 nf_max_table_jumps_netns __read_mostly = NFT_DEFAULT_MAX_TABLE_JUMPS;
+
 unsigned int nf_tables_net_id __read_mostly;
 
 static LIST_HEAD(nf_tables_expressions);
@@ -4011,8 +4015,16 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
 	int err;
+	u32 jump_check = nf_max_table_jumps_netns;
+
+	if (IS_ENABLED(CONFIG_SYSCTL)) {
+		if (!net_eq(ctx->net, &init_net))
+			jump_check = ctx->net->nf.nf_max_table_jumps_netns;
+	}
 
-	if (ctx->level == NFT_JUMP_STACK_SIZE)
+	if (ctx->level == NFT_JUMP_STACK_SIZE ||
+	    (!net_eq(ctx->net, &init_net) &&
+	    ctx->total_jump_count >= jump_check))
 		return -EMLINK;
 
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -4039,14 +4051,35 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
 
-static int nft_table_validate(struct net *net, const struct nft_table *table)
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
+	struct nft_table *sibling_table; /* or netdev */
+
+	nft_net = nft_pernet(net);
+
+	if (!net_eq(net, &init_net)) {
+		list_for_each_entry(sibling_table, &nft_net->tables, list) {
+			if (sibling_table == table) /* ourselves */
+				continue;
+			if (sibling_table->family == table->family ||
+			    sibling_table->family == NFPROTO_NETDEV ||
+			    (sibling_table->family == NFPROTO_IPV4 && table->family == NFPROTO_INET)  ||
+			    (sibling_table->family == NFPROTO_IPV6 && table->family == NFPROTO_INET)) {
+				ctx.total_jump_count += sibling_table->total_jump_count;
+			}
+		}
+	}
+
+	total_jumps_before_validate = ctx.total_jump_count;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4060,6 +4093,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		cond_resched();
 	}
 
+	table->total_jump_count = ctx.total_jump_count - total_jumps_before_validate;
+
 	return 0;
 }
 
@@ -4084,6 +4119,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
@@ -11916,6 +11952,59 @@ static struct notifier_block nft_nl_notifier = {
 	.notifier_call  = nft_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table nf_limit_control_sysctl_table[] = {
+	{
+		.procname	= "nf_max_table_jumps_netns",
+		.data		= &nf_max_table_jumps_netns,
+		.maxlen		= sizeof(nf_max_table_jumps_netns),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int netfilter_limit_control_sysctl_init(struct net *net)
+{
+	struct ctl_table *tbl;
+
+	tbl = nf_limit_control_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		tbl = kmemdup(tbl, sizeof(nf_limit_control_sysctl_table), GFP_KERNEL);
+		net->nf.nf_max_table_jumps_netns = nf_max_table_jumps_netns;
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
@@ -11933,6 +12022,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
+	int ret = netfilter_limit_control_sysctl_init(net);
+
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -11971,6 +12065,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
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
diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ffe161fac8b5..bc7df8feb0f7 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -23,6 +23,7 @@ TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
+TEST_PROGS += nft_max_table_jumps_netns.sh
 TEST_PROGS += nft_meta.sh
 TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
new file mode 100755
index 000000000000..b79e4800a4dc
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
@@ -0,0 +1,218 @@
+#!/bin/bash
+
+source lib.sh
+
+DEFAULT_SYSCTL=65536
+
+user_owned_netns="a_user_owned_netns"
+
+cleanup() {
+        ip netns del $user_owned_netns 2>/dev/null || true
+}
+
+trap cleanup EXIT
+
+init_net_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+
+# Check that init ns inits to default value
+if [ "$init_net_value" -ne "$DEFAULT_SYSCTL" ];then
+	echo "Fail: Does not init default value"
+	exit 1
+fi
+
+# Set to extremely small, demonstrate CAN exceed value
+sysctl -w net.netfilter.nf_max_table_jumps_netns=32 2>&1 >/dev/null
+new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+if [ "$new_value" -ne "32" ];then
+	echo "Fail: Set value not respected"
+	exit 1
+fi
+
+err_string=$(
+nft -f - <<EOF
+table inet loop-test {
+	chain test0 {
+		type filter hook input priority filter; policy accept;
+		jump test1
+		jump test1
+	}
+
+	chain test1 {
+		jump test2
+		jump test2
+	}
+
+	chain test2 {
+		jump test3
+		tcp dport 8080 drop
+		tcp dport 8080 drop
+	}
+
+	chain test3 {
+		jump test4
+	}
+
+	chain test4 {
+		jump test5
+	}
+
+	chain test5 {
+		jump test6
+	}
+
+	chain test6 {
+		jump test7
+	}
+
+	chain test7 {
+		jump test8
+	}
+
+	chain test8 {
+		jump test9
+	}
+
+	chain test9 {
+		jump test10
+	}
+
+	chain test10 {
+		jump test11
+	}
+
+	chain test11 {
+		jump test12
+	}
+
+	chain test12 {
+		jump test13
+	}
+
+	chain test13 {
+		jump test14
+	}
+
+	chain test14 {
+		jump test15
+		jump test15
+	}
+
+	chain test15 {
+	}
+}
+EOF
+
+)
+if [[ "$err_string" != "" ]];then
+	echo "Fail: limit not exceeded when expected"
+	exit 1
+fi
+
+nft flush ruleset
+
+# reset to default
+sysctl -w net.netfilter.nf_max_table_jumps_netns=$DEFAULT_SYSCTL 2>&1 >/dev/null
+
+# Make init_user_ns owned netns, can change value, limit is applied
+ip netns add $user_owned_netns
+err_string=$(ip netns exec $user_owned_netns sysctl -qw net.netfilter.nf_max_table_jumps_netns=32 2>&1)
+if [[ "$err_string" != "" ]];then
+	echo "Fail: Can't change value in init_user_ns owned namespace"
+	exit 1
+fi
+err_string=$(
+ip netns exec $user_owned_netns \
+nft -f - 2>&1 <<EOF
+table inet loop-test {
+	chain test0 {
+		type filter hook input priority filter; policy accept;
+		jump test1
+		jump test1
+	}
+
+	chain test1 {
+		jump test2
+		jump test2
+	}
+
+	chain test2 {
+		jump test3
+		tcp dport 8080 drop
+		tcp dport 8080 drop
+	}
+
+	chain test3 {
+		jump test4
+	}
+
+	chain test4 {
+		jump test5
+	}
+
+	chain test5 {
+		jump test6
+	}
+
+	chain test6 {
+		jump test7
+	}
+
+	chain test7 {
+		jump test8
+	}
+
+	chain test8 {
+		jump test9
+	}
+
+	chain test9 {
+		jump test10
+	}
+
+	chain test10 {
+		jump test11
+	}
+
+	chain test11 {
+		jump test12
+	}
+
+	chain test12 {
+		jump test13
+	}
+
+	chain test13 {
+		jump test14
+	}
+
+	chain test14 {
+		jump test15
+		jump test15
+	}
+
+	chain test15 {
+	}
+}
+EOF
+)
+if [[ "$err_string" != *"Too many links"* ]];then
+	echo "Fail: Limited incorrectly applied"
+	exit 1
+fi
+ip netns del $user_owned_netns
+
+# Previously set value does not impact root namespace; check value from before
+new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+if [ "$new_value" -ne "$DEFAULT_SYSCTL" ];then
+	echo "Fail: Non-init namespace altered init namespace"
+	exit 1
+fi
+
+# Make non-init_user_ns owned netns, can not change value
+err_string=$(unshare -Un sysctl -w net.netfilter.nf_max_table_jumps_netns=1234 2>&1)
+if [[ "$err_string" != *"Operation not permitted"* ]];then
+	echo "Fail: Error message incorrect when non-user-init"
+	exit 1
+fi
+
+exit 0
-- 
2.49.0

