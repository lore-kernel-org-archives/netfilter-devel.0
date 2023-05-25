Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF794C7EE29
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 May 2023 14:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbjEYOIB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 May 2023 10:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjEYOIB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2023 10:08:01 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0443EE53
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2023 07:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tDu4iPgqKFlj56C1pCdeHIBC4T3mKruhvWN2+OOK3BI=; b=ASAuno+lB0ZjIY1CfKl43LDYPU
        xqUKWEEAuV27K9n13PSF3+nAJUAN1Z49WYkd14Gmm4ILr2S/XsJTSvBSbqt+PUQFQBQSez2OmMXjs
        kSeRuYXEcsjBCPIqc3fSJSomDVT8cqa1mnM1wMa/u38/VZvnDaKl5mZ1u2+tRTquQugAVaL5ao1TM
        WIw+jA3FXYxbI7/Sq/oWtd7JfkO+/hc6UXY5gj5QUeIV+W8v1+kCpcQ2qKIHrhDLMPkYFKPhl46bJ
        bd7zvK7YpLoeVDTCoHO/o/9X9DhTSMCVXNJDWqHYvztU9IsC9QUAZLky+XcMrUgNBtQ2KmnRMbLBO
        it+1Vumw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q2Bcu-005Ppm-6N
        for netfilter-devel@vger.kernel.org; Thu, 25 May 2023 15:07:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf] netfilter: bitwise: fix register tracking
Date:   Thu, 25 May 2023 15:07:24 +0100
Message-Id: <20230525140724.998373-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At the end of `nft_bitwise_reduce`, there is a loop which is intended to
update the bitwise expression associated with each tracked destination
register.  However, currently, it just updates the first register
repeatedly.  Fix it.

Fixes: 34cc9e52884a ("netfilter: nf_tables: cancel tracking for clobbered destination registers")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67..2527a01486ef 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -323,7 +323,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	dreg = priv->dreg;
 	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
 	for (i = 0; i < regcount; i++, dreg++)
-		track->regs[priv->dreg].bitwise = expr;
+		track->regs[dreg].bitwise = expr;
 
 	return false;
 }
-- 
2.39.2

