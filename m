Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B254AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 16:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356669AbiELQsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 12:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356680AbiELQsD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 12:48:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44406250E95
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 09:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LP9Qd1CYJnaO7scLoYFhPAzLx8yRLmREQ24Tm+YkQ1c=; b=E0YvLg1o03WtB+lszt0JP6LU+U
        r7d6hghymZ7kGuxpmWIPNFhrd7q5Z5bjlUvAjUgTTegDnARyMoz7qaIXC8fVe/GD54bo4mcdO1hpJ
        0Z1qIaGMUfLNu4g54e76Q/SsoMVK7HbfWAr3khiB+vTkG6H/GbKXSBFzSivGdtFnYW8WDNOI4EEdj
        09sdACBoz1LOTVYfQaccVuqufKtQGLtPY4+BnvpBFbzMHl8i5eK3/XFJv3BZz76iP6YNSVbFvKy45
        /GKz7QapFP6stN2uT6Lb5gTCo2IX59rEyH1GrD777r+hMwFoNI/j2xc7RAGOfOfHKak5bQ30Xo8fR
        rwG2uN9A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1npByq-0004QF-Ma; Thu, 12 May 2022 18:48:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 4/4] netfilter: nf_tables: Annotate reduced expressions
Date:   Thu, 12 May 2022 18:47:41 +0200
Message-Id: <20220512164741.31440-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512164741.31440-1-phil@nwl.cc>
References: <20220512164741.31440-1-phil@nwl.cc>
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
Changes since v1:
- Keep pointers in struct nft_regs_track const and avoid assigning from
  track.cur to expr instead.
- Fix for situations where nft_expr_reduce() causes skipping of multiple
  expressions (payload + bitwise for instance).
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

