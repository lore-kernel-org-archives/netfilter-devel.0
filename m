Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C89C10F29
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D672075E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQNuq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:50:46 -0400
Received: from correo.us.es ([193.147.175.20]:51394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQNup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 09:50:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D55C3C4801
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:50:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C62D0100A43
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:50:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C57F6100A4B; Tue, 17 Mar 2020 14:50:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9648100A43
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:50:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Mar 2020 14:50:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B702842EE38E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:50:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: support for counter in set definition
Date:   Tue, 17 Mar 2020 14:50:38 +0100
Message-Id: <20200317135038.27490-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to turn on counter for each element in the set.

 table ip x {
	set y {
		typeof ip saddr
		counter
		elements = { 192.168.10.35, 192.168.10.101, 192.168.10.135 }
	}

	chain z {
		type filter hook output priority filter; policy accept;
		ip daddr @y
	}
 }

This example shows how to turn on counters globally in the set 'y'.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     |  1 +
 src/evaluate.c     |  9 +++++++++
 src/mnl.c          |  5 +++++
 src/netlink.c      |  7 +++++++
 src/parser_bison.y |  5 +++++
 src/rule.c         | 10 ++++++++++
 6 files changed, 37 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 224e68717bc7..70c8c4cf7b43 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -308,6 +308,7 @@ struct set {
 	struct expr		*init;
 	struct expr		*rg_cache;
 	uint32_t		policy;
+	struct stmt		*stmt;
 	bool			root;
 	bool			automerge;
 	bool			key_typeof_valid;
diff --git a/src/evaluate.c b/src/evaluate.c
index 4a23b231c74d..74d33ad489ae 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1306,8 +1306,17 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 
 static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 {
+	struct set *set = ctx->set;
 	struct expr *elem = *expr;
 
+	if (elem->stmt && set->stmt && set->stmt->ops != elem->stmt->ops)
+		return stmt_binary_error(ctx, set->stmt, elem,
+					 "statement mismatch, element expects %s, "
+					 "%s has type %s",
+					 elem->stmt->ops->name,
+					 set_is_map(set->flags) ? "map" : "set",
+					 set->stmt->ops->name);
+
 	if (expr_evaluate(ctx, &elem->key) < 0)
 		return -1;
 
diff --git a/src/mnl.c b/src/mnl.c
index a517712c14eb..18a73e2878b6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1026,6 +1026,11 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
 
+	if (set->stmt) {
+		nftnl_set_set_data(nls, NFTNL_SET_EXPR,
+				   netlink_gen_stmt_stateful(set->stmt), 0);
+	}
+
 	netlink_dump_set(nls, ctx);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
diff --git a/src/netlink.c b/src/netlink.c
index e10af564bcac..b254753f7424 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -766,6 +766,13 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
 
+	if (nftnl_set_is_set(nls, NFTNL_SET_EXPR)) {
+		const struct nftnl_expr *nle;
+
+		nle = nftnl_set_get(nls, NFTNL_SET_EXPR);
+		set->stmt = netlink_parse_set_expr(set, &ctx->nft->cache, nle);
+	}
+
 	if (datatype) {
 		dtype = set_datatype_alloc(datatype, databyteorder);
 		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3d65d20816d6..e14118ca971e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1733,6 +1733,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->gc_int = $3;
 				$$ = $1;
 			}
+			|	set_block	COUNTER		stmt_separator
+			{
+				$1->stmt = counter_stmt_alloc(&@$);
+				$$ = $1;
+			}
 			|	set_block	ELEMENTS	'='		set_block_expr
 			{
 				$1->init = $4;
diff --git a/src/rule.c b/src/rule.c
index 8e5852689091..ab99bbd22616 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -355,6 +355,7 @@ void set_free(struct set *set)
 	if (set->init != NULL)
 		expr_free(set->init);
 	handle_free(&set->handle);
+	stmt_free(set->stmt);
 	expr_free(set->key);
 	expr_free(set->data);
 	xfree(set);
@@ -544,6 +545,15 @@ static void set_print_declaration(const struct set *set,
 		}
 		nft_print(octx, "%s", opts->stmt_separator);
 	}
+
+	if (set->stmt) {
+		nft_print(octx, "%s%s", opts->tab, opts->tab);
+		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
+		stmt_print(set->stmt, octx);
+		octx->flags &= ~NFT_CTX_OUTPUT_STATELESS;
+		nft_print(octx, "%s", opts->stmt_separator);
+	}
+
 	if (set->automerge)
 		nft_print(octx, "%s%sauto-merge%s", opts->tab, opts->tab,
 			  opts->stmt_separator);
-- 
2.11.0

