Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7F5C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 17:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiEQRVJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 13:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351433AbiEQRVF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 13:21:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E2B165A5
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 10:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/7IqEPG+apsidChCpZ2nczqv+3oKNfR3dlh7TElB4Q4=; b=qdldkGjHRMcB0wYfftjLfEXhI3
        xioFsQ8qOGi6BIlcfY1RCY46h5dS3BQ+c7FuuvnVykPQJ0ndYlVpranJWOln6pRUWth/DZPoeQAUz
        IDc6itcYQOzO8/7IF87/JwvQb+w3jJz5lY3y/POb2n61bC8or3VakwLhKCHcYpXYII5dA4sf1YE8K
        3l6hU4YwTRFXAb53FxNTIXrwQ8ntSXTc+QC9iTrt51oOMvhB9h20Eba7sngQzeVRSTMgrdx+TGdWg
        jqy+/powmSL5Y5qGx42/Gsb5UD+IWVLyflN79G5ccPmomFy2/oymmlcEaUkarhApVXt5UolJ78brg
        aRVrbzPg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nr0sV-0005nr-0y; Tue, 17 May 2022 19:20:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 2/4] netfilter: nf_tables: Introduce struct nft_expr_dp
Date:   Tue, 17 May 2022 19:20:48 +0200
Message-Id: <20220517172050.32653-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517172050.32653-1-phil@nwl.cc>
References: <20220517172050.32653-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a minimal variant of struct nft_expr for use in ruleset blob.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  9 ++++++++-
 net/netfilter/nf_tables_api.c     | 11 ++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3efdc68497148..d4da396052018 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -338,6 +338,8 @@ struct nft_set_estimate {
 #define NFT_EXPR_SIZE(size)		size
 #define NFT_EXPR_FULL_SIZE(size)	(sizeof(struct nft_expr) + \
 					 ALIGN(size, __alignof__(struct nft_expr)))
+#define NFT_EXPR_DP_SIZE(size)		(sizeof(struct nft_expr_dp) + \
+					 ALIGN(size, __alignof__(struct nft_expr_dp)))
 
 /**
  *	struct nft_expr - nf_tables expression
@@ -993,12 +995,17 @@ static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
 
 #define NFT_CHAIN_POLICY_UNSET		U8_MAX
 
+struct nft_expr_dp {
+	const struct nft_expr_ops	*ops;
+	unsigned char			data[] __aligned(__alignof__(u64));
+};
+
 struct nft_rule_dp {
 	u64				is_last:1,
 					dlen:12,
 					handle:42;	/* for tracing */
 	unsigned char			data[]
-		__attribute__((aligned(__alignof__(struct nft_expr))));
+		__aligned(__alignof__(struct nft_expr_dp));
 };
 
 struct nft_rule_blob {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 609fc9137ac01..ba2f712823776 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8363,6 +8363,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	struct nft_regs_track track = {};
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
+	struct nft_expr_dp *pexpr;
 	struct nft_rule *rule;
 
 	/* already handled or inactive chain? */
@@ -8372,7 +8373,9 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data_size = 0;
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (nft_is_active_next(net, rule)) {
-			data_size += sizeof(*prule) + rule->dlen;
+			data_size += sizeof(*prule);
+			nft_rule_for_each_expr(expr, last, rule)
+				data_size += NFT_EXPR_DP_SIZE(expr->ops->size);
 			if (data_size > INT_MAX)
 				return -ENOMEM;
 		}
@@ -8406,11 +8409,13 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 				continue;
 			}
 
-			expr_size = NFT_EXPR_FULL_SIZE(expr->ops->size);
+			expr_size = NFT_EXPR_DP_SIZE(expr->ops->size);
 			if (WARN_ON_ONCE(data + expr_size > data_boundary))
 				return -ENOMEM;
 
-			memcpy(data + size, expr, expr_size);
+			pexpr = (struct nft_expr_dp *)(data + size);
+			pexpr->ops = expr->ops;
+			memcpy(pexpr->data, expr->data, expr->ops->size);
 			size += expr_size;
 		}
 		if (WARN_ON_ONCE(size >= 1 << 12))
-- 
2.34.1

