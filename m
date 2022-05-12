Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FD6C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 12:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiELMaQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 08:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiELMaP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 08:30:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB44218
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 05:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bbnyzJikqQM6uJ6wDVbwzf04WoGCzlEWnwjUiNuczxY=; b=mJOZMxE2CN4zWQZB/n5W9aehn9
        RCe1VJ4vAQT75j1Ebyge+Q48lpoRz0okGlMmVqggg1CZF9bi+FXou3epSkBlw/+sO32yT9KsKLZ+V
        2zwl2znPhS9EKfM9CMnoTJO2fSo0R+9F+++UQqPggj6J/RmxQ9SRo+0WVWN56KMZmK12/70nzDigv
        Z2ishtrX3ieShjaGkNKKZGhha/QPTLuc3eQfdH0XL5B7LcWTXUD8faYAvQwhJZ9p5pczc6u+czVvQ
        wq/4bfPBrZxZzDEZEKF+pexeEwxBtxpOhcN7HtvFoaJG1QEtt69PzpXbhRxD3Ui9lmOQ6R6+ylX9B
        Bi1ypPTA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1np7xL-0000wB-UL; Thu, 12 May 2022 14:30:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2 2/2] netfilter: nf_tables: Annotate reduced expressions
Date:   Thu, 12 May 2022 14:30:03 +0200
Message-Id: <20220512123003.29903-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512123003.29903-1-phil@nwl.cc>
References: <20220512123003.29903-1-phil@nwl.cc>
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
index fddc557983119..d4fd32cf74d69 100644
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
@@ -8404,7 +8404,11 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
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

