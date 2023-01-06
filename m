Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C433BC4708E
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 01:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbjAFBC7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbjAFBC5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 20:02:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F6836F94A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2023 17:02:55 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: allow for updating devices on existing netdev chain
Date:   Fri,  6 Jan 2023 02:02:51 +0100
Message-Id: <20230106010251.27038-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to add/remove devices to an existing chain:

 # cat ruleset.nft
 table netdev x {
	chain y {
		type filter hook ingress devices = { eth0 } priority 0; policy accept;
	}
 }
 # nft -f ruleset.nft
 # nft add chain netdev x y '{ devices = { eth1 };  }'
 # nft list ruleset
 table netdev x {
	chain y {
		type filter hook ingress devices = { eth0, eth1 } priority 0; policy accept;
	}
 }
 # nft delete chain netdev x y '{ devices = { eth0 }; }'
 # nft list ruleset
 table netdev x {
	chain y {
		type filter hook ingress devices = { eth1 } priority 0; policy accept;
	}
 }

This patch also allows for creating an empty netdev chain, with no devices.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |  7 +-
 src/mnl.c                                     | 80 +++++++++++--------
 src/monitor.c                                 | 11 ++-
 src/parser_bison.y                            | 16 ++++
 src/rule.c                                    | 17 +++-
 .../testcases/chains/dumps/netdev_chain_0.nft |  5 ++
 tests/shell/testcases/chains/netdev_chain_0   | 33 ++++++++
 7 files changed, 123 insertions(+), 46 deletions(-)
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 21de18409c87..e739636f1ca1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4771,11 +4771,8 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		if (chain->handle.family == NFPROTO_NETDEV ||
 		    (chain->handle.family == NFPROTO_INET &&
 		     chain->hook.num == NF_INET_INGRESS)) {
-			if (!chain->dev_expr)
-				return __stmt_binary_error(ctx, &chain->loc, NULL,
-							   "Missing `device' in this chain definition");
-
-			if (!evaluate_device_expr(ctx, &chain->dev_expr))
+			if (chain->dev_expr &&
+			    !evaluate_device_expr(ctx, &chain->dev_expr))
 				return -1;
 		} else if (chain->dev_expr) {
 			return __stmt_binary_error(ctx, &chain->dev_expr->location, NULL,
diff --git a/src/mnl.c b/src/mnl.c
index 62b0b59c2da8..239c3ba06b2d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -696,18 +696,52 @@ err:
 /*
  * Chain
  */
+
+static void nft_chain_set_dev(struct nftnl_chain *nlc, struct chain *chain)
+{
+	unsigned int ifname_len;
+	const char **dev_array;
+	char ifname[IFNAMSIZ];
+	int dev_array_len;
+	struct expr *expr;
+	int i = 0;
+
+	dev_array = xmalloc(sizeof(char *) * 8);
+	dev_array_len = 8;
+	list_for_each_entry(expr, &chain->dev_expr->expressions, list) {
+		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+		memset(ifname, 0, sizeof(ifname));
+		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
+				ifname_len);
+		dev_array[i++] = xstrdup(ifname);
+		if (i == dev_array_len) {
+			dev_array_len *= 2;
+			dev_array = xrealloc(dev_array,
+					     dev_array_len * sizeof(char *));
+		}
+	}
+
+	dev_array[i] = NULL;
+	if (i == 1)
+		nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV, dev_array[0]);
+	else if (i > 1)
+		nftnl_chain_set_data(nlc, NFTNL_CHAIN_DEVICES, dev_array,
+				     sizeof(char *) * dev_array_len);
+
+	i = 0;
+	while (dev_array[i] != NULL)
+		xfree(dev_array[i++]);
+
+	xfree(dev_array);
+}
+
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
 	struct nftnl_udata_buf *udbuf;
-	int priority, policy, i = 0;
 	struct nftnl_chain *nlc;
-	unsigned int ifname_len;
-	const char **dev_array;
-	char ifname[IFNAMSIZ];
 	struct nlmsghdr *nlh;
-	struct expr *expr;
-	int dev_array_len;
+	int priority, policy;
 
 	nlc = nftnl_chain_alloc();
 	if (nlc == NULL)
@@ -730,36 +764,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
 					    cmd->chain->type.str);
 		}
-		if (cmd->chain->dev_expr) {
-			dev_array = xmalloc(sizeof(char *) * 8);
-			dev_array_len = 8;
-			list_for_each_entry(expr, &cmd->chain->dev_expr->expressions, list) {
-				ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
-				memset(ifname, 0, sizeof(ifname));
-				mpz_export_data(ifname, expr->value,
-						BYTEORDER_HOST_ENDIAN,
-						ifname_len);
-				dev_array[i++] = xstrdup(ifname);
-				if (i == dev_array_len) {
-					dev_array_len *= 2;
-					dev_array = xrealloc(dev_array,
-							     dev_array_len * sizeof(char *));
-				}
-			}
+		if (cmd->chain->dev_expr)
+			nft_chain_set_dev(nlc, cmd->chain);
 
-			dev_array[i] = NULL;
-			if (i == 1)
-				nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV, dev_array[0]);
-			else if (i > 1)
-				nftnl_chain_set_data(nlc, NFTNL_CHAIN_DEVICES, dev_array,
-						     sizeof(char *) * dev_array_len);
-
-			i = 0;
-			while (dev_array[i] != NULL)
-				xfree(dev_array[i++]);
-
-			xfree(dev_array);
-		}
 		if (cmd->chain->comment) {
 			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 			if (!udbuf)
@@ -856,6 +863,9 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
 
+	if (cmd->chain && cmd->chain->dev_expr)
+		nft_chain_set_dev(nlc, cmd->chain);
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELCHAIN,
 				    cmd->handle.family,
diff --git a/src/monitor.c b/src/monitor.c
index 9692b859e6eb..3a1896917923 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -272,10 +272,13 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			chain_print_plain(c, &monh->ctx->nft->output);
 			break;
 		case NFT_MSG_DELCHAIN:
-			nft_mon_print(monh, "chain %s %s %s",
-				      family2str(c->handle.family),
-				      c->handle.table.name,
-				      c->handle.chain.name);
+			if (c->dev_array_len > 0)
+				chain_print_plain(c, &monh->ctx->nft->output);
+			else
+				nft_mon_print(monh, "chain %s %s %s",
+					      family2str(c->handle.family),
+					      c->handle.table.name,
+					      c->handle.chain.name);
 			break;
 		}
 		nft_mon_print(monh, "\n");
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ccf07a30fbfc..ba7b2e0b7ad1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1350,6 +1350,13 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
+			|	CHAIN		chain_spec	chain_block_alloc
+						'{'	chain_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, $5);
+			}
 			|	RULE		ruleid_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
@@ -1892,6 +1899,15 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 				list_add_tail(&$2->list, &$1->rules);
 				$$ = $1;
 			}
+			|	chain_block	DEVICES		'='	flowtable_expr	stmt_separator
+			{
+				if ($$->dev_expr) {
+					list_splice_init(&$4->expressions, &$$->dev_expr->expressions);
+					expr_free($4);
+					break;
+				}
+				$$->dev_expr = $4;
+			}
 			|	chain_block	comment_spec	stmt_separator
 			{
 				if (already_set($1->comment, &@2, state)) {
diff --git a/src/rule.c b/src/rule.c
index 903c01f53825..2f8b1c80c22e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1091,8 +1091,21 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		mpz_export_data(&policy, chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		nft_print(octx, " { type %s hook %s priority %s; policy %s; }",
-			  chain->type.str, chain->hook.name,
+		nft_print(octx, " { type %s hook %s ",
+			  chain->type.str, chain->hook.name);
+
+		if (chain->dev_array_len > 0) {
+			int i;
+
+			nft_print(octx, "devices = { ");
+			for (i = 0; i < chain->dev_array_len; i++) {
+				nft_print(octx, "%s", chain->dev_array[i]);
+				if (i + 1 != chain->dev_array_len)
+					nft_print(octx, ", ");
+			}
+			nft_print(octx, " } ");
+		}
+		nft_print(octx, "priority %s; policy %s; }",
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hook.num,
 				   chain->priority.expr),
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_0.nft b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
new file mode 100644
index 000000000000..bc02dc18692d
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
@@ -0,0 +1,5 @@
+table netdev x {
+	chain y {
+		type filter hook ingress devices = { d0, d1 } priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
new file mode 100755
index 000000000000..67cd715fc59f
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+ip link add d0 type dummy || {
+        echo "Skipping, no dummy interface available"
+        exit 0
+}
+trap "ip link del d0" EXIT
+
+ip link add d1 type dummy || {
+        echo "Skipping, no dummy interface available"
+        exit 0
+}
+trap "ip link del d1" EXIT
+
+ip link add d2 type dummy || {
+        echo "Skipping, no dummy interface available"
+        exit 0
+}
+trap "ip link del d2" EXIT
+
+set -e
+
+RULESET="table netdev x {
+	chain y {
+		type filter hook ingress priority 0; policy accept;
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
+
+$NFT add chain netdev x y '{ devices = { d0 }; }'
+$NFT add chain netdev x y '{ devices = { d1, d2, lo }; }'
+$NFT delete chain netdev x y '{ devices = { lo }; }'
-- 
2.30.2

