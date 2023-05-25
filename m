Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1D8C77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 15:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbjEYPkf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 11:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbjEYPkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 11:40:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74EF9198
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 08:40:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 6/6] netfilter: nf_tables: skip comment match when building blob
Date:   Thu, 25 May 2023 17:40:24 +0200
Message-Id: <20230525154024.222338-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525154024.222338-1-pablo@netfilter.org>
References: <20230525154024.222338-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use tracking infrastructure to skip the comment match when building
the ruleset blob, this restores the comment match suppression done in
c828414ac935 ("netfilter: nft_compat: suppress comment match"). If
.track returns -1, then skip the expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  3 ++-
 net/netfilter/nft_compat.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3c5c3f3af333..3fc1a7d30f8b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8917,7 +8917,8 @@ static int nft_expr_track(struct nft_exprs_track *expr_track,
 	if (ret > 0) {
 		expr_track->num_exprs++;
 		return 1;
-	}
+	} else if (ret < 0)
+		return 0;
 
 	switch (expr_track->num_exprs) {
 	case 0:
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index e178b479dfaf..89a5e4d2b03d 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -734,6 +734,17 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
+static int nft_match_track(struct nft_expr_track *track,
+			   const struct nft_expr *expr)
+{
+	const struct xt_match *match = expr->ops->data;
+
+	if (!strcmp(match->name, "comment"))
+		return -1;
+
+	return 1;
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -776,6 +787,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
 	ops->data = match;
+	ops->track = nft_match_track;
 
 	matchsize = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
 	if (matchsize > NFT_MATCH_LARGE_THRESH) {
-- 
2.30.2

