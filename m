Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5B8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Mar 2022 21:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiC0VyR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Mar 2022 17:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0VyR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Mar 2022 17:54:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768873FDB9
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Mar 2022 14:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UCIAIVx8H5TK0jWBStNtm7uJfbvewNeYFV5OKukbeD0=; b=rLPrPRfwHdRsPIufd9FMaLsPAd
        QdRw1p7uzU/ihQDomqih7Ek+T7oXpYprssMtjcs18FPn2oFv0kJUy5FJBXvLsZUaLl8fQv6bfKad2
        /Ro8wYh+1cZ+TuOcZzymE1NFJW4HjCRC6R++iRs3deqvh43o5U/rSxegM4+jRHTtE3X+D8++fvmJm
        Hf0qg3sdRsddkqCI5Xpglvs9s39NlwtPuEBQRvBk95TXXOBjKnEkrM2YceI9v8dxX7oHaS+ZWIY2K
        iAbGEXmjEmEjERhiT9oyOUCR977mH8MNBGkcTw3GPAFRSrxRxpKMRcNzbABhUBdsKsSBkLgkSSMYR
        ZPhHvQ3g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nYaoM-00DlqV-I4; Sun, 27 Mar 2022 22:52:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] netfilter: bitwise: fix reduce comparison
Date:   Sun, 27 Mar 2022 22:52:23 +0100
Message-Id: <20220327215223.73014-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `nft_bitwise_reduce` function should compare the bitwise operation
in `expr` with the tracked operation associated with the destination
register of `expr`.  However, instead being called on `expr` and
`track->regs[priv->dreg].selector`, `nft_expr_priv` is called on `expr`
twice, so `nft_bitwise_reduce` returns true even when the operations
differ.

Fixes: be5650f8f47e ("netfilter: nft_bitwise: track register operations")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..120a657bf8ea 100644
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
-- 
2.35.1

