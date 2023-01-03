Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9E3C4708E
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Jan 2023 21:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjACV6k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 16:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACV6i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 16:58:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C422A14D29
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2023 13:58:37 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v1] src: allow for updating devices on existing netdev chain
Date:   Tue,  3 Jan 2023 22:58:34 +0100
Message-Id: <20230103215834.1996-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c          | 37 +++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 16 ++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 62b0b59c2da8..e878e85fb90a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -848,7 +848,13 @@ int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_chain *nlc;
+	unsigned int ifname_len;
+	const char **dev_array;
+	char ifname[IFNAMSIZ];
 	struct nlmsghdr *nlh;
+	struct expr *expr;
+	int dev_array_len;
+	int i = 0;
 
 	nlc = nftnl_chain_alloc();
 	if (nlc == NULL)
@@ -856,6 +862,37 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
 
+	if (cmd->chain && cmd->chain->dev_expr) {
+		dev_array = xmalloc(sizeof(char *) * 8);
+		dev_array_len = 8;
+		list_for_each_entry(expr, &cmd->chain->dev_expr->expressions, list) {
+			ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+			memset(ifname, 0, sizeof(ifname));
+			mpz_export_data(ifname, expr->value,
+					BYTEORDER_HOST_ENDIAN,
+					ifname_len);
+			dev_array[i++] = xstrdup(ifname);
+			if (i == dev_array_len) {
+				dev_array_len *= 2;
+				dev_array = xrealloc(dev_array,
+						     dev_array_len * sizeof(char *));
+			}
+		}
+
+		dev_array[i] = NULL;
+		if (i == 1)
+			nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV, dev_array[0]);
+		else if (i > 1)
+			nftnl_chain_set_data(nlc, NFTNL_CHAIN_DEVICES, dev_array,
+					     sizeof(char *) * dev_array_len);
+
+		i = 0;
+		while (dev_array[i] != NULL)
+			xfree(dev_array[i++]);
+
+		xfree(dev_array);
+	}
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELCHAIN,
 				    cmd->handle.family,
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
-- 
2.30.2

