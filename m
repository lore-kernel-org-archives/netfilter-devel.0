Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333C8C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06505206D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKURhR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:37:17 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41646 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfKURhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:37:17 -0500
Received: from localhost ([::1]:54736 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXqOJ-0006KG-U0; Thu, 21 Nov 2019 18:37:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 11/12] nft: Support parsing lookup expression
Date:   Thu, 21 Nov 2019 18:36:46 +0100
Message-Id: <20191121173647.31488-12-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121173647.31488-1-phil@nwl.cc>
References: <20191121173647.31488-1-phil@nwl.cc>
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
Changes since v2:
- Remove call to add_nft_among() which is implemented in next patch to
  not temporarily break builds.
---
 iptables/nft-shared.c | 9 +++++++++
 iptables/nft-shared.h | 2 ++
 iptables/nft.c        | 3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

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
index 91762d2ed8a3e..bee99a7dd0c93 100644
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
index a8e7694f86781..2bc94ff92e294 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3114,7 +3114,8 @@ static const char *supported_exprs[] = {
 	"cmp",
 	"bitwise",
 	"counter",
-	"immediate"
+	"immediate",
+	"lookup",
 };
 
 
-- 
2.24.0

