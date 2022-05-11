Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92833C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 May 2022 16:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbiEKQzK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345187AbiEKQzJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 12:55:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217EE15F8
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 09:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ep+RhZWsp1yqGRpWEK6uSYp1Wv2wSloJyGM+ov2v8Lg=; b=kumv0wgqKWWkdGiUosmSp2h/4x
        JsJsszIDeZZ0wWRBP2sZV81qVm879VpULm9ENLV8UZmcxhYlDhMA1ZbeEtk8+WnliUFg6XJt8xZpG
        oMWHA0ESJh9B9Jds5JMre+UOUFPNBfk23S9Ozr3IXpEGvat77qOQRgUWiH9tiieYwKvBaWLthR2jx
        rCQ9eJCajrVZnt4UJZCb+tPhaXrNd+BupQLZtvu9IyDHM/Sekd8iVIc0ygD6oVygc8Pn70XgrF9Bf
        g98nI/J9mbmOmqki/M/OYpQwLYP8NKF4GdaSU2EOTz8lCEal7vY9JizfZRfgFZjoepjg+7XULmQwg
        DynqXbzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nopcB-0005jK-60; Wed, 11 May 2022 18:55:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/2] netfilter: nf_tables: Annotate reduced expressions
Date:   Wed, 11 May 2022 18:54:53 +0200
Message-Id: <20220511165453.22425-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220511165453.22425-1-phil@nwl.cc>
References: <20220511165453.22425-1-phil@nwl.cc>
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
 include/net/netfilter/nf_tables.h        | 2 +-
 include/uapi/linux/netfilter/nf_tables.h | 7 +++++++
 net/netfilter/nf_tables_api.c            | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 78db54737de00..031477edaa885 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -129,7 +129,7 @@ struct nft_regs_track {
 		u8				num_reg;
 	} regs[NFT_REG32_NUM];
 
-	const struct nft_expr			*cur;
+	struct nft_expr				*cur;
 	const struct nft_expr			*last;
 };
 
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
index fddc557983119..eb4fceae80385 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8360,8 +8360,8 @@ static bool nft_expr_reduce(struct nft_regs_track *track,
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
-	const struct nft_expr *expr, *last;
 	struct nft_regs_track track = {};
+	struct nft_expr *expr, *last;
 	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
@@ -8404,6 +8404,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			track.cur = expr;
 
 			if (nft_expr_reduce(&track, expr)) {
+				expr->flags |= NFTA_EXPR_FLAG_REDUCED;
 				expr = track.cur;
 				continue;
 			}
-- 
2.34.1

