Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF30FC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Mar 2022 22:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiC0WiL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Mar 2022 18:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbiC0WiK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Mar 2022 18:38:10 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A17411141
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Mar 2022 15:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7E+0LzssTJNLLVd+0aFH5RcVmMzLcOrrvBKi6gd+BNY=; b=Je6PxiQtVq+I1/YvU2BM5gtelD
        Uh7SHtjnRjUqaPOAcjhzP2R1HILPyMnkDuYop9GnICxnVir544JYsjruqbPPobau29rKWs6Q18GH3
        VjyG/eBJU1M4CpnmvTi+73++i93s8fU/WDT7UzH5HRZ7ZNUXo37Liry4scs0WGDojc7ya95ext53A
        bZ0VUik9u5JcILi8aGgicxUpumxSSyUPx5/vCcHuaD/WXoMCvRY7PAyv8zWf4DPHkbxZk00+WN4/f
        lwfscFtXiRTv21tuiyxAzXzWts0p4gN81244x/NCS3/OhbLXri/eOOmJtuXgetR3Xvuwj1QdYzpvY
        wF7Cfkxg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nYbUr-00DmvK-FI; Sun, 27 Mar 2022 23:36:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf PATCH v2] netfilter: bitwise: fix reduce comparisons
Date:   Sun, 27 Mar 2022 23:36:25 +0100
Message-Id: <20220327223625.134198-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220327215223.73014-1-jeremy@azazel.net>
References: <20220327215223.73014-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `nft_bitwise_reduce` and `nft_bitwise_fast_reduce` functions should
compare the bitwise operation in `expr` with the tracked operation
associated with the destination register of `expr`.  However, instead of
being called on `expr` and `track->regs[priv->dreg].selector`,
`nft_expr_priv` is called on `expr` twice, so both reduce functions
return true even when the operations differ.

Fixes: be5650f8f47e ("netfilter: nft_bitwise: track register operations")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
Since v1:

  * fix `nft_bitwise_fast_reduce` as well as `nft_bitwise_reduce`.
 
 net/netfilter/nft_bitwise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..04bd2f89afe8 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -287,7 +287,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
@@ -434,7 +434,7 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-- 
2.35.1

