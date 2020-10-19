Return-Path: <SRS0=0udB=D2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2EBC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 12:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B69223BF
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 12:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgJSMuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:50:25 -0400
Received: from correo.us.es ([193.147.175.20]:35092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgJSMuZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 08:50:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2991E154E8C
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:50:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 143B5DA78A
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:50:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 09C86DA704; Mon, 19 Oct 2020 14:50:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F806DA72F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:50:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Oct 2020 14:50:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C74824301DE4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:50:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: improve rule error reporting
Date:   Mon, 19 Oct 2020 14:50:12 +0200
Message-Id: <20201019125012.14373-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201019125012.14373-1-pablo@netfilter.org>
References: <20201019125012.14373-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel provides information regarding expression since
83d9dcba06c5 ("netfilter: nf_tables: extended netlink error reporting for
expressions").

A common mistake is to reference a chain which does not exist, e.g.

 # nft add rule x y jump test
 Error: Could not process rule: No such file or directory
 add rule x y jump test
                   ^^^^

Use the existing netlink extended error reporting infrastructure to
provide better error reporting as in the example above.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h       |  27 ++++++-
 src/mnl.c               |  65 ++++++++++++++-
 src/netlink_linearize.c | 171 ++++++++++++++++++++++++++--------------
 3 files changed, 201 insertions(+), 62 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index b78277a8ce30..9730c6bb2cb6 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -123,9 +123,11 @@ extern struct expr *netlink_alloc_data(const struct location *loc,
 				       enum nft_registers dreg);
 
 extern int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h);
+
+struct netlink_linearize_ctx;
 extern void netlink_linearize_rule(struct netlink_ctx *ctx,
-				   struct nftnl_rule *nlr,
-				   const struct rule *rule);
+				   const struct rule *rule,
+				   struct netlink_linearize_ctx *lctx);
 extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 					     struct nftnl_rule *r);
 
@@ -215,4 +217,25 @@ enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype);
 void expr_handler_init(void);
 void expr_handler_exit(void);
 
+void netlink_linearize_init(struct netlink_linearize_ctx *lctx,
+			    struct nftnl_rule *nlr);
+void netlink_linearize_fini(struct netlink_linearize_ctx *lctx);
+
+struct netlink_linearize_ctx {
+	struct nftnl_rule	*nlr;
+	unsigned int		reg_low;
+	struct list_head	*expr_loc_htable;
+};
+
+#define NFT_EXPR_LOC_HSIZE      128
+
+struct nft_expr_loc {
+	struct list_head        hlist;
+	const struct nftnl_expr *nle;
+	struct location         loc;
+};
+
+struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
+				       struct netlink_linearize_ctx *ctx);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/src/mnl.c b/src/mnl.c
index adb55d4dec90..f776a1db6452 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -426,13 +426,55 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	return 0;
 }
 
+struct mnl_nft_rule_build_ctx {
+	struct netlink_linearize_ctx	*lctx;
+	struct nlmsghdr			*nlh;
+	struct cmd			*cmd;
+};
+
+static int mnl_nft_expr_build_cb(struct nftnl_expr *nle, void *data)
+{
+	struct mnl_nft_rule_build_ctx *ctx = data;
+	struct nlmsghdr *nlh = ctx->nlh;
+	struct cmd *cmd = ctx->cmd;
+	struct nft_expr_loc *eloc;
+	struct nlattr *nest;
+
+	eloc = nft_expr_loc_find(nle, ctx->lctx);
+	if (eloc)
+		cmd_add_loc(cmd, nlh->nlmsg_len, &eloc->loc);
+
+	nest = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+	nftnl_expr_build_payload(nlh, nle);
+	mnl_attr_nest_end(nlh, nest);
+
+	nftnl_rule_del_expr(nle);
+	nftnl_expr_free(nle);
+
+	return 0;
+}
+
+static void mnl_nft_rule_build_ctx_init(struct mnl_nft_rule_build_ctx *rule_ctx,
+					struct nlmsghdr *nlh,
+					struct cmd *cmd,
+					struct netlink_linearize_ctx *lctx)
+{
+	memset(rule_ctx, 0, sizeof(*rule_ctx));
+	rule_ctx->nlh = nlh;
+	rule_ctx->cmd = cmd;
+	rule_ctx->lctx = lctx;
+}
+
 int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		     unsigned int flags)
 {
+	struct mnl_nft_rule_build_ctx rule_ctx;
+	struct netlink_linearize_ctx lctx;
 	struct rule *rule = cmd->rule;
 	struct handle *h = &rule->handle;
 	struct nftnl_rule *nlr;
 	struct nlmsghdr *nlh;
+	struct nlattr *nest;
 
 	nlr = nftnl_rule_alloc();
 	if (!nlr)
@@ -446,7 +488,8 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (h->position_id)
 		nftnl_rule_set_u32(nlr, NFTNL_RULE_POSITION_ID, h->position_id);
 
-	netlink_linearize_rule(ctx, nlr, rule);
+	netlink_linearize_init(&lctx, nlr);
+	netlink_linearize_rule(ctx, rule, &lctx);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWRULE,
 				    cmd->handle.family,
@@ -461,8 +504,15 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	else
 		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
 
+	mnl_nft_rule_build_ctx_init(&rule_ctx, nlh, cmd, &lctx);
+
+	nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
+	nftnl_expr_foreach(nlr, mnl_nft_expr_build_cb, &rule_ctx);
+	mnl_attr_nest_end(nlh, nest);
+
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
+	netlink_linearize_fini(&lctx);
 
 	mnl_nft_batch_continue(ctx->batch);
 
@@ -471,11 +521,14 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	struct mnl_nft_rule_build_ctx rule_ctx;
+	struct netlink_linearize_ctx lctx;
 	struct rule *rule = cmd->rule;
 	struct handle *h = &rule->handle;
 	unsigned int flags = 0;
 	struct nftnl_rule *nlr;
 	struct nlmsghdr *nlh;
+	struct nlattr *nest;
 
 	if (nft_output_echo(&ctx->nft->output))
 		flags |= NLM_F_ECHO;
@@ -486,7 +539,8 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
 
-	netlink_linearize_rule(ctx, nlr, rule);
+	netlink_linearize_init(&lctx, nlr);
+	netlink_linearize_rule(ctx, rule, &lctx);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWRULE,
 				    cmd->handle.family,
@@ -499,8 +553,15 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
 	mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
 
+	mnl_nft_rule_build_ctx_init(&rule_ctx, nlh, cmd, &lctx);
+
+	nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
+	nftnl_expr_foreach(nlr, mnl_nft_expr_build_cb, &rule_ctx);
+	mnl_attr_nest_end(nlh, nest);
+
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
+	netlink_linearize_fini(&lctx);
 
 	mnl_nft_batch_continue(ctx->batch);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e5f601d4bc94..28c1afbfe518 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -24,11 +24,34 @@
 #include <linux/netfilter.h>
 #include <libnftnl/udata.h>
 
+struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
+				       struct netlink_linearize_ctx *ctx)
+{
+	struct nft_expr_loc *eloc;
+	uint32_t hash;
+
+	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
+	list_for_each_entry(eloc, &ctx->expr_loc_htable[hash], hlist) {
+		if (eloc->nle == nle)
+			return eloc;
+	}
+
+	return NULL;
+}
 
-struct netlink_linearize_ctx {
-	struct nftnl_rule	*nlr;
-	unsigned int		reg_low;
-};
+static void nft_expr_loc_add(const struct nftnl_expr *nle,
+			     const struct location *loc,
+			     struct netlink_linearize_ctx *ctx)
+{
+	struct nft_expr_loc *eloc;
+	uint32_t hash;
+
+	eloc = xmalloc(sizeof(*eloc));
+	eloc->nle = nle;
+	eloc->loc = *loc;
+	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
+	list_add_tail(&eloc->hlist, &ctx->expr_loc_htable[hash]);
+}
 
 static void netlink_put_register(struct nftnl_expr *nle,
 				 uint32_t attr, uint32_t reg)
@@ -105,6 +128,14 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void nft_rule_add_expr(struct netlink_linearize_ctx *ctx,
+			      struct nftnl_expr *nle,
+			      const struct location *loc)
+{
+	nft_expr_loc_add(nle, loc, ctx);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_fib(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
@@ -116,7 +147,7 @@ static void netlink_gen_fib(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_RESULT, expr->fib.result);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_FLAGS, expr->fib.flags);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
@@ -144,7 +175,7 @@ static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_OFFSET, expr->hash.offset);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_TYPE, expr->hash.type);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
@@ -162,7 +193,7 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
@@ -181,7 +212,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS, expr->exthdr.flags);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
@@ -193,7 +224,7 @@ static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("meta");
 	netlink_put_register(nle, NFTNL_EXPR_META_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_META_KEY, expr->meta.key);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_rt(struct netlink_linearize_ctx *ctx,
@@ -205,7 +236,7 @@ static void netlink_gen_rt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("rt");
 	netlink_put_register(nle, NFTNL_EXPR_RT_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_RT_KEY, expr->rt.key);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_socket(struct netlink_linearize_ctx *ctx,
@@ -217,7 +248,7 @@ static void netlink_gen_socket(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("socket");
 	netlink_put_register(nle, NFTNL_EXPR_SOCKET_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_SOCKET_KEY, expr->socket.key);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
@@ -230,7 +261,7 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_OSF_DREG, dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_OSF_TTL, expr->osf.ttl);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_OSF_FLAGS, expr->osf.flags);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
@@ -244,7 +275,7 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_OFFSET, expr->numgen.offset);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
@@ -260,7 +291,7 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
 				  expr->ct.direction);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
@@ -298,7 +329,7 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	if (dreg == NFT_REG_VERDICT)
 		release_register(ctx, expr->map);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
@@ -324,7 +355,7 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_FLAGS, NFT_LOOKUP_F_INV);
 
 	release_register(ctx, expr->left);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static enum nft_cmp_ops netlink_gen_cmp_op(enum ops op)
@@ -370,7 +401,7 @@ static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld.value, nld.len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &zero.value, zero.len);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 
 	return expr->right->prefix;
 }
@@ -400,7 +431,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 		netlink_gen_data(range->right, &nld);
 		nftnl_expr_set(nle, NFTNL_EXPR_RANGE_TO_DATA,
 			       nld.value, nld.len);
-		nftnl_rule_add_expr(ctx->nlr, nle);
+		nft_rule_add_expr(ctx, nle, &expr->location);
 		break;
 	case OP_EQ:
 	case OP_IMPLICIT:
@@ -410,7 +441,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 				   netlink_gen_cmp_op(OP_GTE));
 		netlink_gen_data(range->left, &nld);
 		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-		nftnl_rule_add_expr(ctx->nlr, nle);
+		nft_rule_add_expr(ctx, nle, &expr->location);
 
 		nle = alloc_nft_expr("cmp");
 		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
@@ -418,7 +449,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 				   netlink_gen_cmp_op(OP_LTE));
 		netlink_gen_data(range->right, &nld);
 		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-		nftnl_rule_add_expr(ctx->nlr, nle);
+		nft_rule_add_expr(ctx, nle, &expr->location);
 		break;
 	default:
 		BUG("invalid range operation %u\n", expr->op);
@@ -455,13 +486,13 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 
 	nle = alloc_nft_expr("cmp");
 	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 
 	mpz_clear(zero);
 	release_register(ctx, expr->left);
@@ -534,7 +565,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
 	release_register(ctx, expr->left);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void combine_binop(mpz_t mask, mpz_t xor, const mpz_t m, const mpz_t x)
@@ -570,7 +601,7 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_DATA, nld.value,
 		       nld.len);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
@@ -640,7 +671,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	mpz_clear(xor);
 	mpz_clear(mask);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
@@ -695,15 +726,16 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 			   byte_size);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_OP,
 			   netlink_gen_unary_op(expr->op));
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 				  const struct expr *expr,
 				  enum nft_registers dreg)
 {
-	struct nftnl_expr *nle;
+	const struct location *loc = &expr->location;
 	struct nft_data_linearize nld;
+	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("immediate");
 	netlink_put_register(nle, NFTNL_EXPR_IMM_DREG, dreg);
@@ -716,6 +748,7 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 		if (expr->chain) {
 			nftnl_expr_set_str(nle, NFTNL_EXPR_IMM_CHAIN,
 					   nld.chain);
+			loc = &expr->chain->location;
 		} else if (expr->chain_id) {
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_IMM_CHAIN_ID,
 					   nld.chain_id);
@@ -725,7 +758,7 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 	default:
 		break;
 	}
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, loc);
 }
 
 static void netlink_gen_xfrm(struct netlink_linearize_ctx *ctx,
@@ -739,7 +772,7 @@ static void netlink_gen_xfrm(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_XFRM_KEY, expr->xfrm.key);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_XFRM_DIR, expr->xfrm.direction);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_XFRM_SPNUM, expr->xfrm.spnum);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
@@ -822,7 +855,7 @@ static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
 	default:
 		BUG("unsupported expression %u\n", expr->etype);
 	}
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static struct nftnl_expr *netlink_gen_connlimit_stmt(const struct stmt *stmt)
@@ -941,7 +974,7 @@ static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
@@ -983,7 +1016,7 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
 				   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
 static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
@@ -999,7 +1032,7 @@ static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("meta");
 	netlink_put_register(nle, NFTNL_EXPR_META_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_META_KEY, stmt->meta.key);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
@@ -1030,7 +1063,7 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_FLAGS,
 					   stmt->log.logflags);
 	}
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
@@ -1044,7 +1077,7 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_REJECT_CODE,
 				  stmt->reject.icmp_code);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static unsigned int nat_addrlen(uint8_t family)
@@ -1175,7 +1208,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		registers--;
 	}
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
@@ -1214,7 +1247,7 @@ static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
 		registers--;
 	}
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_synproxy_stmt(struct netlink_linearize_ctx *ctx,
@@ -1229,7 +1262,7 @@ static void netlink_gen_synproxy_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_SYNPROXY_FLAGS,
 			   stmt->synproxy.flags);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
@@ -1260,7 +1293,7 @@ static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
 	if (stmt->dup.to != NULL)
 		release_register(ctx, stmt->dup.to);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
@@ -1287,7 +1320,7 @@ static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_FWD_NFPROTO,
 				   stmt->fwd.family);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
@@ -1312,7 +1345,7 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_FLAGS,
 				   stmt->queue.flags);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 
 	mpz_clear(low);
 	mpz_clear(high);
@@ -1335,7 +1368,7 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
 				  stmt->ct.direction);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_notrack_stmt(struct netlink_linearize_ctx *ctx,
@@ -1344,7 +1377,7 @@ static void netlink_gen_notrack_stmt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("notrack");
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_flow_offload_stmt(struct netlink_linearize_ctx *ctx,
@@ -1355,7 +1388,7 @@ static void netlink_gen_flow_offload_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("flow_offload");
 	nftnl_expr_set_str(nle, NFTNL_EXPR_FLOW_TABLE_NAME,
 			   stmt->flow.table_name);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
@@ -1377,7 +1410,7 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, stmt->set.op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set.name);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 
 	if (stmt->set.stmt)
 		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
@@ -1413,7 +1446,7 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
 			       netlink_gen_stmt_stateful(stmt->map.stmt), 0);
 
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
@@ -1444,7 +1477,7 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
 	nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
 		       netlink_gen_stmt_stateful(stmt->meter.stmt), 0);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
 static void netlink_gen_chain_stmt(struct netlink_linearize_ctx *ctx,
@@ -1496,7 +1529,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	case STMT_LIMIT:
 	case STMT_QUOTA:
 		nle = netlink_gen_stmt_stateful(stmt);
-		nftnl_rule_add_expr(ctx->nlr, nle);
+		nft_rule_add_expr(ctx, nle, &stmt->location);
 		break;
 	case STMT_NOTRACK:
 		return netlink_gen_notrack_stmt(ctx, stmt);
@@ -1513,18 +1546,40 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
-			    const struct rule *rule)
+void netlink_linearize_init(struct netlink_linearize_ctx *lctx,
+			    struct nftnl_rule *nlr)
 {
-	struct netlink_linearize_ctx lctx;
-	const struct stmt *stmt;
+	int i;
+
+	memset(lctx, 0, sizeof(*lctx));
+	lctx->reg_low = NFT_REG_1;
+	lctx->nlr = nlr;
+	lctx->expr_loc_htable =
+		xmalloc(sizeof(struct list_head) * NFT_EXPR_LOC_HSIZE);
+	for (i = 0; i < NFT_EXPR_LOC_HSIZE; i++)
+		init_list_head(&lctx->expr_loc_htable[i]);
+}
 
-	memset(&lctx, 0, sizeof(lctx));
-	lctx.reg_low = NFT_REG_1;
-	lctx.nlr = nlr;
+void netlink_linearize_fini(struct netlink_linearize_ctx *lctx)
+{
+	struct nft_expr_loc *eloc, *next;
+	int i;
+
+	for (i = 0; i < NFT_EXPR_LOC_HSIZE; i++) {
+		list_for_each_entry_safe(eloc, next, &lctx->expr_loc_htable[i], hlist)
+			xfree(eloc);
+	}
+	xfree(lctx->expr_loc_htable);
+}
+
+void netlink_linearize_rule(struct netlink_ctx *ctx,
+			    const struct rule *rule,
+			    struct netlink_linearize_ctx *lctx)
+{
+	const struct stmt *stmt;
 
 	list_for_each_entry(stmt, &rule->stmts, list)
-		netlink_gen_stmt(&lctx, stmt);
+		netlink_gen_stmt(lctx, stmt);
 
 	if (rule->comment) {
 		struct nftnl_udata_buf *udata;
@@ -1536,12 +1591,12 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 		if (!nftnl_udata_put_strz(udata, NFTNL_UDATA_RULE_COMMENT,
 					  rule->comment))
 			memory_allocation_error();
-		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
+		nftnl_rule_set_data(lctx->nlr, NFTNL_RULE_USERDATA,
 				    nftnl_udata_buf_data(udata),
 				    nftnl_udata_buf_len(udata));
 
 		nftnl_udata_buf_free(udata);
 	}
 
-	netlink_dump_rule(nlr, ctx);
+	netlink_dump_rule(lctx->nlr, ctx);
 }
-- 
2.20.1

