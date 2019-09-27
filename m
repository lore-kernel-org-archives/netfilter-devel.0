Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE92BC4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23FC217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfI0OFG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:05:06 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50000 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OFG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:05:06 -0400
Received: from localhost ([::1]:34858 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDqro-0006vJ-NW; Fri, 27 Sep 2019 16:05:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 11/12] nft: Support parsing lookup expression
Date:   Fri, 27 Sep 2019 16:04:32 +0200
Message-Id: <20190927140433.9504-12-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927140433.9504-1-phil@nwl.cc>
References: <20190927140433.9504-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add required glue code to support family specific lookup expression
parsers implemented as family_ops callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 9 +++++++++
 iptables/nft-shared.h | 2 ++
 iptables/nft.c        | 5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 19630c1e2990c..78e422781723f 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -588,6 +588,13 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
+static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
+			     struct nftnl_expr *e)
+{
+	if (ctx->h->ops->parse_lookup)
+		ctx->h->ops->parse_lookup(ctx, e, NULL);
+}
+
 void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
@@ -628,6 +635,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_target(&ctx, expr);
 		else if (strcmp(name, "limit") == 0)
 			nft_parse_limit(&ctx, expr);
+		else if (strcmp(name, "lookup") == 0)
+			nft_parse_lookup(&ctx, h, expr);
 
 		expr = nftnl_expr_iter_next(iter);
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 55e7f3c7c1da4..b7539365acf89 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -86,6 +86,8 @@ struct nft_family_ops {
 			      void *data);
 	void (*parse_cmp)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 			  void *data);
+	void (*parse_lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
+			     void *data);
 	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
 
 	void (*print_table_header)(const char *tablename);
diff --git a/iptables/nft.c b/iptables/nft.c
index 7cab4a236aaa7..71171b106febe 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1085,6 +1085,8 @@ int add_match(struct nft_handle *h,
 
 	if (!strcmp(m->u.user.name, "limit"))
 		return add_nft_limit(r, m);
+	else if (!strcmp(m->u.user.name, "among"))
+		return add_nft_among(h, r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
@@ -3697,7 +3699,8 @@ static const char *supported_exprs[] = {
 	"cmp",
 	"bitwise",
 	"counter",
-	"immediate"
+	"immediate",
+	"lookup"
 };
 
 
-- 
2.23.0

