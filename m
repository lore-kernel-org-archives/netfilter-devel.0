Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D02D60F2
	for <netfilter-devel@vger.kernel.org>; Tue,  6 May 2025 02:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746499746; cv=none; b=lcNz6YkDtO4nbriTYNwr+X20Dq8bv+He/Bo1EVqKd+p8yg8CPyC5hkytVu4tXBnTRgEAgSFdUyxhbQG9fkpaO/6wshDwG5sE1N/hBLQ6L1g5hW9wW7oodCQqqbzkNxNPSTz+Un03vLC50CUaH34yfrOvKxnc0/8jkz9DjG41pSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746499746; c=relaxed/simple;
	bh=QEyZWqKCMnVQmE9NT8IQG6WypkAWP4yITBv7Gl26sZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1K9eC4gQ6iDG4eHa5i3Q8ivk0WIyuRphNJYCiIwH0KIfOljkW/+em1aOCxqXhTwoC8C7E5UXYBmpmBARzWHM5eYtGMREXABTOgVVs7pRRYWOeYm0Cv4d8fQP9myQBgBoUds6Ai7O0fFasb52MNcftA090aetLei6BTfDXmv7Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHYhx/8y; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHYhx/8y"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6e8f254b875so55591766d6.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 May 2025 19:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746499742; x=1747104542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pxg9sRWp2MsAc58npl/RNhwuHYYnNhewcoQrGT9F8e4=;
        b=ZHYhx/8y+8/5uUBJuOC7fGVEIOX9WSI5Zm68Kr7d8rQy6U/3qHLbzLflJn+UcQdrcY
         m9uvB+fvn98ubXTMFCT7WY5YWOimikyLyBbK9t9YLh/BMgNh1iB6Efr0Jvz1ao4CHow6
         hvVOKGijfuTU0sJmT8WL3yGO1SIQu3WjPAKUOtt8myLMpVic/35Kawmi0XG0j2bYEqIY
         js3jhImtVOMvTi1PnJsHhww0+Bbj5MsFuE74EYQ8REEDWAVhwQ2VpYR0ufgS9eQUJrNg
         3CZrYWKhE4OmHmO793IaF4PdugTDJc8/7MEK3uJ7UJApJWhsv+/1aTKeGyqVcCYuOFAT
         7Leg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746499742; x=1747104542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxg9sRWp2MsAc58npl/RNhwuHYYnNhewcoQrGT9F8e4=;
        b=D8QuVWmUbu5uIcHfnQaqtFKTeHZoo0DHTA4D2y01086YQNdoUzHDK+D4ZiQOTVlt0A
         44gndqgx13RIaR3gSfUqvL6CYMTUAkOzha0O4pBc4q+i1H3CWoaiZZ2PSYev3AmkbT/A
         phaF6vNLDbES1R9bH+eER0fSJbdUJmjcQWhnjC60GJWfU6PQ+eezXozFQx7pKrfPkNJo
         N3GIkipU2T94RleO1iOzFntUH/1zJpdjC0leoKkD7n9EjU/tvDHnaLDI6oq87AzQV+U/
         4LzC7sGyShggtG2wiZpPRqJaS3DKfUfgrI5xJmdwY785M5/eb/ginetaafAuUSmMq1wd
         ZXBw==
X-Gm-Message-State: AOJu0Yyp+0JzP9QBQFt7rcFIlhSiF2XKk3R5Ox7n92eJUZlnBY1PKHpU
	N5x4USzYOf6lgRXqxIPWtX8y3OpfAtswHmLuszuZKTKeaT6+GH6RWGjW8g==
X-Gm-Gg: ASbGncsIhxHoVBosky8N/nJdYzC2nBh5hv6BWZEHaeXIsPKKy8GlkgwzPFf8Fj4cIoD
	pZVvLPn2irzVeKwYSrhoZAdg/GTWLo+Jwx54yOSI/I42ax3vpyAbUCSq/lXJ6uFoAzOhAIe10fg
	LerkAn5a60BEzCnWw+dA3QMLlYX6M7IyC6nwPYdeqDgJcH3SqeI/1VZjkfa+q1kYxd2zdJwr9bD
	gr5lS5tblyB/kc18vfhDG+1VLv95xltk8p7/t9i1AGIPYqF+y/hbGFKmzzFw89BGkEs4/Vm6XUB
	UKCjcIbd43O7Cf4zugqgh0DIN2r/D7sQ1XlzAHGBJ3GXzR9/dPxrMafP1WCHXtkDWCK1gcH94Tu
	d
X-Google-Smtp-Source: AGHT+IH/pmO3URnbvbg8Sg0IoAAM1cJcZHIIKXPK9sQIv3AVxgq0EeWCASlnw5x24GhNvxiPUGPErw==
X-Received: by 2002:ad4:5ecb:0:b0:6e8:9dfa:d932 with SMTP id 6a1803df08f44-6f535897af7mr22294656d6.15.1746499741661;
        Mon, 05 May 2025 19:49:01 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f50f4515b6sm63706336d6.70.2025.05.05.19.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 19:49:01 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de
Subject: [PATCH v2] netfilter: nf_tables: Implement jump limit for nft_table_validate
Date: Mon,  5 May 2025 22:49:00 -0400
Message-ID: <20250506024900.1568391-1-brady.1345@gmail.com>
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

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
---
 Documentation/networking/netfilter-sysctl.rst |   9 ++
 include/net/netfilter/nf_tables.h             |   4 +
 include/net/netns/netfilter.h                 |   4 +
 net/netfilter/nf_tables_api.c                 | 114 +++++++++++++++++-
 net/netfilter/nft_immediate.c                 |   1 +
 5 files changed, 130 insertions(+), 2 deletions(-)

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
index a6a0bf4a247e..cac35c70ef20 100644
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
@@ -33,5 +34,8 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	unsigned int defrag_ipv6_users;
 #endif
+#ifdef CONFIG_SYSCTL
+	u32 nf_max_table_jumps_netns;
+#endif
 };
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b28f6730e26d..e3b27ad1d919 100644
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
@@ -4039,14 +4051,33 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
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
+			    sibling_table->family == NFPROTO_NETDEV){
+				ctx.total_jump_count += sibling_table->total_jump_count;
+			}
+		}
+	}
+
+	total_jumps_before_validate = ctx.total_jump_count;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4060,6 +4091,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		cond_resched();
 	}
 
+	table->total_jump_count = ctx.total_jump_count - total_jumps_before_validate;
+
 	return 0;
 }
 
@@ -4084,6 +4117,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
@@ -11916,6 +11950,78 @@ static struct notifier_block nft_nl_notifier = {
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
+static int __net_init nf_limit_control_net_init(struct net *net)
+{
+	int ret = netfilter_limit_control_sysctl_init(net);
+
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static void __net_exit nf_limit_control_net_exit(struct net *net)
+{
+	netfilter_limit_control_sysctl_exit(net);
+}
+
+static struct pernet_operations nf_limit_control_net_ops = {
+	.init = nf_limit_control_net_init,
+	.exit = nf_limit_control_net_exit,
+};
+
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -12003,6 +12109,10 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		return err;
 
+	err = register_pernet_subsys(&nf_limit_control_net_ops);
+	if (err < 0)
+		return err;
+
 	err = nft_chain_filter_init();
 	if (err < 0)
 		goto err_chain_filter;
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

