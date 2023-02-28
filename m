Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC467C64ED6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 19:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjB1Thz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 14:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1Thz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 14:37:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFD88268C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 11:37:49 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_last: copy content when cloning expression
Date:   Tue, 28 Feb 2023 20:37:46 +0100
Message-Id: <20230228193746.87007-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the ruleset contains last timestamps, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_last.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 7f2bda6641bd..8e6d7eaf9dc8 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -105,11 +105,15 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
 static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_last_priv *priv_src = nft_expr_priv(src);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
 	if (!priv_dst->last)
 		return -ENOMEM;
 
+	priv_dst->last->set = priv_src->last->set;
+	priv_dst->last->jiffies = priv_src->last->jiffies;
+
 	return 0;
 }
 
-- 
2.30.2

