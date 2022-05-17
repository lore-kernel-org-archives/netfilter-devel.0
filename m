Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDCAC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 17:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351384AbiEQRVL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 13:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351440AbiEQRVH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 13:21:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4A0B48D
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 10:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qWbMVNrixiNrPAo0iVjw3L0SxWG4TnbYB4/DqC0NgoM=; b=deOsbM6g+b/BzhlQi/nGKyYt1f
        ybrfrpieP9iG4dKKtzwxSqKMiiLZBJ+cNQG9e2hkPi8p0pz9cEMCwT+nKMA3bUF+QjC+9it7TonOe
        ZEtR3J+RpqOKrdwvcrPX+FZucbkzPOc78pFsRhqyWQswtV9dCxNdctFAqS+4rpzfRVwVdXtPxtjD4
        OWzWJ5T+WxgI+rkSTEJFhkWo125My6L7mupoIwPPMpjwFE0ulte1rR14QP6MpvEdqE53ZC6hz8uZg
        3MHGVJcP9nlomyNYwIVsD6qXOX+YHL0Gr7Ryb9x43h3kyF+fsRiLeqJELxLSe5tAr7T08k9ddHkSS
        LrJCjP5A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nr0sa-0005ny-HQ; Tue, 17 May 2022 19:21:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 4/4] netfilter: nf_tables: Annotate reduced expressions
Date:   Tue, 17 May 2022 19:20:50 +0200
Message-Id: <20220517172050.32653-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517172050.32653-1-phil@nwl.cc>
References: <20220517172050.32653-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce NFTA_EXPR_FLAG_REDUCED and set it for expressions which were
omitted from the rule blob due to being redundant. This allows user
space to verify the rule optimizer's results.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 7 +++++++
 net/netfilter/nf_tables_api.c            | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 36bf019322a44..1da84ebc3f27a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -523,6 +523,13 @@ enum nft_expr_attributes {
 };
 #define NFTA_EXPR_MAX		(__NFTA_EXPR_MAX - 1)
 
+/**
+ * NFTA_EXPR_FLAGS values
+ *
+ * @NFTA_EXPR_FLAG_REDUCED: redundant expression omitted from blob
+ */
+#define NFTA_EXPR_FLAG_REDUCED	(1 << 0)
+
 /**
  * enum nft_immediate_attributes - nf_tables immediate expression netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 608c5e684dff7..01141412cb052 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8363,8 +8363,8 @@ static bool nft_expr_reduce(struct nft_regs_track *track,
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	unsigned int size, expr_size, data_size;
-	const struct nft_expr *expr, *last;
 	struct nft_regs_track track = {};
+	struct nft_expr *expr, *last;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_expr_dp *pexpr;
@@ -8409,7 +8409,11 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			track.cur = expr;
 
 			if (nft_expr_reduce(&track, expr)) {
-				expr = track.cur;
+				expr->flags |= NFTA_EXPR_FLAG_REDUCED;
+				while (expr != track.cur) {
+					expr = nft_expr_next(expr);
+					expr->flags |= NFTA_EXPR_FLAG_REDUCED;
+				}
 				continue;
 			}
 
-- 
2.34.1

