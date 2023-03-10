Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782A4C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 18:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCJS0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 13:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCJS0v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 13:26:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 890C91632D
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 10:26:48 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] src: improve error reporting for unsupported chain type
Date:   Fri, 10 Mar 2023 19:26:43 +0100
Message-Id: <20230310182643.182915-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

8c75d3a16960 ("Reject invalid chain priority values in user space")
provides error reporting from the evaluation phase. Instead, this patch
infers the error after the kernel reports EOPNOTSUPP.

test.nft:3:28-40: Error: Chains of type "nat" must have a priority value above -200
                type nat hook prerouting priority -300;
                                         ^^^^^^^^^^^^^

This patch also adds another common issue for users compiling their own
kernels if they forget to enable CONFIG_NFT_NAT in their .config file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c      | 36 ++++++++++++++++++++++++++++++++++++
 src/evaluate.c |  9 ---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index 9e375078b0ac..83526d3d56ce 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -241,6 +241,33 @@ static void nft_cmd_enoent(struct netlink_ctx *ctx, const struct cmd *cmd,
 	netlink_io_error(ctx, loc, "Could not process rule: %s", strerror(err));
 }
 
+static int nft_cmd_chain_error(struct netlink_ctx *ctx, struct cmd *cmd,
+			       struct mnl_err *err)
+{
+	struct chain *chain = cmd->chain;
+	int priority;
+
+	switch (err->err) {
+	case EOPNOTSUPP:
+		if (!(chain->flags & CHAIN_F_BASECHAIN))
+			break;
+
+		mpz_export_data(&priority, chain->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		if (priority <= -200 && !strcmp(chain->type.str, "nat"))
+			return netlink_io_error(ctx, &chain->priority.loc,
+						"Chains of type \"nat\" must have a priority value above -200");
+
+		return netlink_io_error(ctx, &chain->loc,
+					"Chain of type \"%s\" is not supported, kernel support is missing?",
+					chain->type.str);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		   struct mnl_err *err)
 {
@@ -263,6 +290,15 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		loc = &cmd->location;
 	}
 
+	switch (cmd->obj) {
+	case CMD_OBJ_CHAIN:
+		if (nft_cmd_chain_error(ctx, cmd, err) < 0)
+			return;
+		break;
+	default:
+		break;
+	}
+
 	netlink_io_error(ctx, loc, "Could not process rule: %s",
 			 strerror(err->err));
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 663ace26f897..47caf3b0d716 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4885,8 +4885,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	}
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		int priority;
-
 		chain->hook.num = str2hooknum(chain->handle.family,
 					      chain->hook.name);
 		if (chain->hook.num == NF_INET_NUMHOOKS)
@@ -4899,13 +4897,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
 						   "invalid priority expression %s in this context.",
 						   expr_name(chain->priority.expr));
-
-		mpz_export_data(&priority, chain->priority.expr->value,
-				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		if (priority <= -200 && !strcmp(chain->type.str, "nat"))
-			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
-						   "Chains of type \"nat\" must have a priority value above -200.");
-
 		if (chain->policy) {
 			expr_set_context(&ctx->ectx, &policy_type,
 					 NFT_NAME_MAXLEN * BITS_PER_BYTE);
-- 
2.30.2

