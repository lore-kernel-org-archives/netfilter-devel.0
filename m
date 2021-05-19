Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A94CC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C598611AE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 21:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhESVIh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 17:08:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46776 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhESVIh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 17:08:37 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4C1226417E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 23:06:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] libnftables: location-based error reporting for chain type
Date:   Wed, 19 May 2021 23:07:11 +0200
Message-Id: <20210519210711.264687-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store the location of the chain type for better error reporting.

Several users that compile custom kernels reported that error
reporting is misleading when accidentally selecting
CONFIG_NFT_NAT=n.

After this patch, a better hint is provided:

 # nft 'add chain x y { type nat hook prerouting priority dstnat; }'
 Error: Could not process rule: No such file or directory
 add chain x y { type nat hook prerouting priority dstnat; }
                      ^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 7 ++++++-
 src/mnl.c          | 8 +++++++-
 src/netlink.c      | 2 +-
 src/parser_bison.y | 3 ++-
 src/parser_json.c  | 2 +-
 src/rule.c         | 6 +++---
 6 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index fbd2c9a79b47..f469db55bf60 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -213,6 +213,11 @@ struct hook_spec {
 	unsigned int	num;
 };
 
+struct chain_type_spec {
+	struct location	loc;
+	const char	*str;
+};
+
 /**
  * struct chain - nftables chain
  *
@@ -242,7 +247,7 @@ struct chain {
 		struct prio_spec	priority;
 		struct hook_spec	hook;
 		struct expr		*policy;
-		const char		*type;
+		struct chain_type_spec	type;
 		const char		**dev_array;
 		struct expr		*dev_expr;
 		int			dev_array_len;
diff --git a/src/mnl.c b/src/mnl.c
index 1a8e8105707b..ef45cbd193f9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -698,7 +698,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 					BYTEORDER_HOST_ENDIAN, sizeof(int));
 			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO, priority);
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
-					    cmd->chain->type);
+					    cmd->chain->type.str);
 		}
 		if (cmd->chain->dev_expr) {
 			dev_array = xmalloc(sizeof(char *) * 8);
@@ -764,6 +764,12 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
 	}
 
+	if (cmd->chain && cmd->chain->flags & CHAIN_F_BASECHAIN) {
+		nftnl_chain_unset(nlc, NFTNL_CHAIN_TYPE);
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->type.loc);
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, cmd->chain->type.str);
+	}
+
 	if (cmd->chain && cmd->chain->policy) {
 		mpz_export_data(&policy, cmd->chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
diff --git a/src/netlink.c b/src/netlink.c
index 8cdd6d818221..6b6fe27762d5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -552,7 +552,7 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 						    BYTEORDER_HOST_ENDIAN,
 						    sizeof(int) * BITS_PER_BYTE,
 						    &priority);
-		chain->type          =
+		chain->type.str =
 			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
 		policy = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
 		chain->policy = constant_expr_alloc(&netlink_location,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cdb04fa8d19b..4e6c2ba75099 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2261,7 +2261,8 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
 					xfree($2);
 					YYERROR;
 				}
-				$<chain>0->type		= xstrdup(chain_type);
+				$<chain>0->type.loc = @2;
+				$<chain>0->type.str = xstrdup(chain_type);
 				xfree($2);
 
 				$<chain>0->loc = @$;
diff --git a/src/parser_json.c b/src/parser_json.c
index 17bb10c34cbc..9d8cef726ad3 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2741,7 +2741,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 
 	chain = chain_alloc(NULL);
 	chain->flags |= CHAIN_F_BASECHAIN;
-	chain->type = xstrdup(type);
+	chain->type.str = xstrdup(type);
 	chain->priority.expr = constant_expr_alloc(int_loc, &integer_type,
 						   BYTEORDER_HOST_ENDIAN,
 						   sizeof(int) * BITS_PER_BYTE,
diff --git a/src/rule.c b/src/rule.c
index 07a541a20bb9..dda1718d69ef 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -730,7 +730,7 @@ void chain_free(struct chain *chain)
 		rule_free(rule);
 	handle_free(&chain->handle);
 	scope_release(&chain->scope);
-	xfree(chain->type);
+	xfree(chain->type.str);
 	expr_free(chain->dev_expr);
 	for (i = 0; i < chain->dev_array_len; i++)
 		xfree(chain->dev_array[i]);
@@ -1024,7 +1024,7 @@ static void chain_print_declaration(const struct chain *chain,
 		nft_print(octx, "\n\t\tcomment \"%s\"", chain->comment);
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		nft_print(octx, "\t\ttype %s hook %s", chain->type,
+		nft_print(octx, "\t\ttype %s hook %s", chain->type.str,
 			  hooknum2str(chain->handle.family, chain->hook.num));
 		if (chain->dev_array_len == 1) {
 			nft_print(octx, " device \"%s\"", chain->dev_array[0]);
@@ -1085,7 +1085,7 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 		mpz_export_data(&policy, chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		nft_print(octx, " { type %s hook %s priority %s; policy %s; }",
-			  chain->type, chain->hook.name,
+			  chain->type.str, chain->hook.name,
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hook.num,
 				   chain->priority.expr),
-- 
2.30.2

