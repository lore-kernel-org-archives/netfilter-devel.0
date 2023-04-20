Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9A9C77B72
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDTRAQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDTRAP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 13:00:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B9633A8E
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 09:59:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: allow for updating devices on existing netdev chain
Date:   Thu, 20 Apr 2023 18:59:03 +0200
Message-Id: <20230420165903.44420-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230420165903.44420-1-pablo@netfilter.org>
References: <20230420165903.44420-1-pablo@netfilter.org>
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

This feature allows for creating an empty netdev chain, with no devices.
In such case, no packets are seen until a device is registered.

This patch includes extended netlink error reporting:

 # nft add chain netdev x y '{ devices = { x } ; }'
 Error: Could not process rule: No such file or directory
 add chain netdev x y { devices = { x } ; }
                                    ^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: it includes extended netlink error reporting support.

 src/evaluate.c                                | 12 +--
 src/mnl.c                                     | 90 ++++++++-----------
 src/monitor.c                                 | 11 ++-
 src/parser_bison.y                            | 16 ++++
 src/rule.c                                    | 17 +++-
 .../testcases/chains/dumps/netdev_chain_0.nft |  5 ++
 tests/shell/testcases/chains/netdev_chain_0   | 33 +++++++
 7 files changed, 121 insertions(+), 63 deletions(-)
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_0

diff --git a/src/evaluate.c b/src/evaluate.c
index fe15d7ace5dd..35910b03ba7c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4964,15 +4964,17 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 				return chain_error(ctx, chain, "invalid policy expression %s",
 						   expr_name(chain->policy));
 		}
+	}
+
+	if (chain->dev_expr) {
+		if (!(chain->flags & CHAIN_F_BASECHAIN))
+			chain->flags |= CHAIN_F_BASECHAIN;
 
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
index 34678e98f2da..b7acd24b3d07 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -785,14 +785,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
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
@@ -805,46 +800,6 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS,
 					    CHAIN_F_HW_OFFLOAD);
 		}
-		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
-			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
-					    cmd->chain->hook.num);
-			mpz_export_data(&priority,
-					cmd->chain->priority.expr->value,
-					BYTEORDER_HOST_ENDIAN, sizeof(int));
-			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO, priority);
-			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
-					    cmd->chain->type.str);
-		}
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
-
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
@@ -879,12 +834,6 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
 	}
 
-	if (cmd->chain && cmd->chain->flags & CHAIN_F_BASECHAIN) {
-		nftnl_chain_unset(nlc, NFTNL_CHAIN_TYPE);
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->type.loc);
-		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, cmd->chain->type.str);
-	}
-
 	if (cmd->chain && cmd->chain->policy) {
 		mpz_export_data(&policy, cmd->chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
@@ -892,7 +841,34 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_POLICY, htonl(policy));
 	}
 
+	nftnl_chain_unset(nlc, NFTNL_CHAIN_TYPE);
+
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
+
+	if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
+		struct nlattr *nest;
+
+		if (cmd->chain->type.str) {
+			cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->type.loc);
+			mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, cmd->chain->type.str);
+		}
+
+		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
+
+		if (cmd->chain->type.str) {
+			mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM, cmd->chain->hook.num);
+			mpz_export_data(&priority, cmd->chain->priority.expr->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
+			mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, priority);
+		}
+
+		if (cmd->chain && cmd->chain->dev_expr) {
+			mnl_nft_devs_build(nlh, cmd, cmd->chain->dev_expr,
+					   NFTA_HOOK_DEVS);
+		}
+		mnl_attr_nest_end(nlh, nest);
+	}
+
 	nftnl_chain_free(nlc);
 
 	mnl_nft_batch_continue(ctx->batch);
@@ -961,6 +937,16 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 				 htobe64(cmd->handle.handle.id));
 	}
 
+	if (cmd->op == CMD_DELETE &&
+	    cmd->chain && cmd->chain->dev_expr) {
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
+		mnl_nft_devs_build(nlh, cmd, cmd->chain->dev_expr,
+				   NFTA_HOOK_DEVS);
+		mnl_attr_nest_end(nlh, nest);
+	}
+
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 	nftnl_chain_free(nlc);
 
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
index e4f21ca1a722..90a2b9c3d681 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1358,6 +1358,13 @@ delete_cmd		:	TABLE		table_or_id_spec
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
@@ -2004,6 +2011,15 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
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
index 06042239c843..c075d027f9ba 100644
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

