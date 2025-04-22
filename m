Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9092D2F2E
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Apr 2025 00:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281008; cv=none; b=SaOiSFyZ14vF1Ew3z2dLCIwVh1y2MpEfg7nWok+lMa4hutNxOKvO4Eug+ejuegE5oOYLCmfSEoiBL0ILJQ+AFi5EVQ0GQ39/PIxVdZ7EHImGaY1T9oAhvfLzZpXtKxIH6Ig5r7ZzyRlSHVurYfq9FQq/fqJjyYww3zMmLzMwxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281008; c=relaxed/simple;
	bh=cGKrR7DM1aL6defHMU9gBIZxy088ezax2XVpDMw4t3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c9E36gh/xQRk897l4vOClzRIy5qkVidNzmVuNEa5j8f5k35PNlJoySfUEkKKUwTRNmKAy9z6MWH8wKdSvGcsCgd8iH6X0HAmxRvD/9m3MFa5FLjw+8VcnXyBokZjLd/TZQPWrFVeKnQix8/MIuC4QeeYxEsjAhxutvxXxGj6rvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OeQpkiPb; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeQpkiPb"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c5f720c717so578522385a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Apr 2025 17:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745281005; x=1745885805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=15rzjxywi7ScRGEnNW0dsYl/xt9bj64vOyNO9AWJXNo=;
        b=OeQpkiPbstDjt3HqtaqnJ9RTqx3F21wFvddWlokPZKv2gj7SZpOxPZ9kL8m7GZEKh8
         CQnlDda4b98ujD9eODjrNgMVKxeIidFSLRy1tOa69uwg9193MlGH9l1UMrwN9UCrdtzS
         Dq3ccsDzVx8kijXFn/vkpC3pnjJfPB1QyUeJ8HljXDaRXtRs++abzmyzRx2qrZ0P/0bq
         RrXJA1v3Gg9XFqZM9hbhdWFIZc6ZclYxyxNZjnvIcFTTpgGbfTGhEC+Y2K/Athktkhzm
         Ni0ijiGgckuj3OVYPxIuYXUzA77k3fcU1dEQluM4vgNhoR55caQda1hl5cxHGnlmMXG2
         So2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745281005; x=1745885805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15rzjxywi7ScRGEnNW0dsYl/xt9bj64vOyNO9AWJXNo=;
        b=gTUkAVjQF9T7UyFgKJfpa/omEv+aB706KgIW3lUvmor09m1iYuoJy7dX1zVtyFhQ8n
         87ByWkQILEaHtk/pmWdmy5nvpH2GKZNVQAiTOENgsEhyPWfpmwLFACsTTsxkIA2C/OaO
         6+Hj73ol9YzUtyBIyeek4oZEALxs/RFFQ3cAAIl11H+7YElnpWVXMQaV3EefCtm1EkPd
         pej8u06xPJI6z9p5pjgfqf/xQhYmjvCwBJYtwx4mG2CAmy6iNurTGuErB0xF5zvIn43n
         QfZXvlld/l+KA5nyqFrDomWa1t2Jfy8uvTOS76fhh6JnUKdo0Y3cTRmEfCRXOz9pZXmH
         3KTg==
X-Gm-Message-State: AOJu0YybDmaTBrKhzeBawkQhqOY3ZR8TFFfdqFWqCzLQe6rpUzsOails
	ho2xz2CCbxdlmfFnNY75NGlkopSnsv7YnLgrl43Hjscw44QzzYjjkCQ2vQ==
X-Gm-Gg: ASbGncveDrqfGHzTH5WveLa/JBUKqDxwnpPXA+hAbjJVTuICHb2jNgx4ASjeF/xkZ3c
	DEz+zpTBWMsvmoaHmhoXvnaRw1aX+Szda5VQVnYwJoiyPyG3rtuKbUeSdRGPdkjJPAIRhLDeQG5
	mmqXqoeOYTHRd5AMD9tF+Yk4F1DHIyh0AjffVIs/W+shEfAcvhJxXnZFuP+d2IuX2lbbUKpoG4W
	QTL/05rdkjdcGVZyCa4awoLgStyA9ViAnzK9OmJbt7+dHZVru18CfSV6VwAT2ZVp/1deDljYh6j
	9fWnfiiZRaJ6GvsD407GL1JvquSjVHctTXNe1s6y8j4GCzC9UhCSCENojz8S8MCaj8zJ/vfnrne
	f
X-Google-Smtp-Source: AGHT+IGYPuJhfSsctQR7+NqURI7iejLR458MoJJYI/ZZhPoAw12zDSOYysEDq3XhvOX8ol8xl66CMQ==
X-Received: by 2002:a05:620a:4111:b0:7c9:1c6f:b4c8 with SMTP id af79cd13be357-7c9282a2170mr2190089285a.15.1745281004864;
        Mon, 21 Apr 2025 17:16:44 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c925b6e198sm477062385a.103.2025.04.21.17.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 17:16:44 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org
Subject: [PATCH] netfilter: nf_tables: Implement jump limit for nft_table_validate
Date: Mon, 21 Apr 2025 20:16:43 -0400
Message-ID: <20250422001643.113149-1-brady.1345@gmail.com>
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
found in the bug report.

Add a new counter, total_jump_counter, to nft_ctx.  On every call to
nft_table_validate() (rule addition time, versus packet inspection time)
start the counter at 0.

Increment said counter for every jump encountered during table
validation.  If the counter ever exceeds the system's jump limit *during
validation*, gracefully reject the rule with -EMLINK (the same behavior
as exceeding NFT_JUMP_STACK_SIZE).

This allows immediate feedback to the user about a bad chain, versus the
original idea (from the bug report) of allowing the addition to the
table.  It keeps the in memory ruleset consistent, versus catching the
failure during packet inspection at some unknown point in the future and
arbitrarily denying the packet.  Most importantly, it removes the original
problem of a kernel crash.

The compile time limit NFT_DEFAULT_MAX_TABLE_JUMPS of 8192 was chosen to
account for any normal use case, and when this value (and associated
stressing loop table) was tested against a 1CPU/256MB machine, the
system remained functional.

A sysctl entry net/netfilter/nf_max_table_jumps for the limit was also
added for any use cases that may exceed this limit.  As it is a control
limit, it is only available in the root network namespace.

Example output of nft when patch is applied (and count is reached):

Error: Could not process rule: Too many links
add rule inet loop-test test14 jump test15
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1665
---
 Documentation/networking/netfilter-sysctl.rst |  8 ++
 include/net/netfilter/nf_tables.h             |  1 +
 include/net/netns/netfilter.h                 |  1 +
 net/netfilter/nf_tables_api.c                 | 75 ++++++++++++++++++-
 net/netfilter/nft_immediate.c                 |  1 +
 5 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/netfilter-sysctl.rst b/Documentation/networking/netfilter-sysctl.rst
index beb6d7b275d4..d957272c8ae6 100644
--- a/Documentation/networking/netfilter-sysctl.rst
+++ b/Documentation/networking/netfilter-sysctl.rst
@@ -15,3 +15,11 @@ nf_log_all_netns - BOOLEAN
 	with LOG target; this aims to prevent containers from flooding host
 	kernel log. If enabled, this target also works in other network
 	namespaces. This variable is only accessible from init_net.
+
+nf_max_table_jumps - INTEGER (count)
+	default 8192
+
+	The maximum numbers of jumps a table can contain.  Meeting or exceeding
+	this value will cause additional rules to not be added with
+	EMLINK being return to the user. This variable is only accessible from
+	init_net.
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0027beca5cd5..9c9473c37f08 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -218,6 +218,7 @@ struct nft_ctx {
 	const struct nlattr * const 	*nla;
 	u32				portid;
 	u32				seq;
+	u32				total_jump_count;
 	u16				flags;
 	u8				family;
 	u8				level;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index a6a0bf4a247e..cbb4f672d21f 100644
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f7ca7165e66e..e70c6cb7d90a 100644
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
@@ -25,10 +26,14 @@
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 #define NFT_SET_MAX_ANONLEN 16
+#define NFT_DEFAULT_MAX_TABLE_JUMPS 8192
 
 /* limit compaction to avoid huge kmalloc/krealloc sizes. */
 #define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
 
+u32 sysctl_nf_max_table_jumps __read_mostly = NFT_DEFAULT_MAX_TABLE_JUMPS;
+EXPORT_SYMBOL(sysctl_nf_max_table_jumps);
+
 unsigned int nf_tables_net_id __read_mostly;
 
 static LIST_HEAD(nf_tables_expressions);
@@ -4009,7 +4014,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 	struct nft_rule *rule;
 	int err;
 
-	if (ctx->level == NFT_JUMP_STACK_SIZE)
+	if (ctx->level == NFT_JUMP_STACK_SIZE ||
+	    ctx->total_jump_count >= sysctl_nf_max_table_jumps)
 		return -EMLINK;
 
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -4042,6 +4048,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	struct nft_ctx ctx = {
 		.net	= net,
 		.family	= table->family,
+		.total_jump_count = 0,
 	};
 	int err;
 
@@ -4081,6 +4088,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		pctx->level++;
+		pctx->total_jump_count++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
@@ -11875,6 +11883,67 @@ static struct notifier_block nft_nl_notifier = {
 	.notifier_call  = nft_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table nf_limit_control_sysctl_table[] = {
+	{
+		.procname	= "nf_max_table_jumps",
+		.data		= &sysctl_nf_max_table_jumps,
+		.maxlen		= sizeof(sysctl_nf_max_table_jumps),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int netfilter_limit_control_sysctl_init(struct net *net)
+{
+	if (net_eq(net, &init_net)) {
+		net->nf.nf_limit_control_dir_header = register_net_sysctl(
+				net,
+				"net/netfilter",
+				nf_limit_control_sysctl_table);
+		if (!net->nf.nf_limit_control_dir_header)
+			goto err_alloc;
+	}
+	return 0;
+
+err_alloc:
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
@@ -11957,6 +12026,10 @@ static int __init nf_tables_module_init(void)
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

