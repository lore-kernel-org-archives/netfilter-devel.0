Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EA6C7EE2F
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbjFETUT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbjFETTz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:55 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183FA170F
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PJT81BzRs/yHfDDfeWxI/KSga8MxqnzMfUDsCESegEk=; b=ILyRLb2T0Vd9H5eCngLnBoo8wY
        pdLpXTp9b2nWbjPxojwS6bH9KtKrJcH+LKrwm0E6c1OAIorB5SfdGc7g/MfiPdWixfSTyXjQEtbA7
        15rXhPsZjoWtQrDSv41U6n33ny2W9ar/sr9xIY+gH8E46Z2pYmzJ/IGKwcXUH7iZkX+DUEtPqGH2S
        wqzu8i6XDksPsaBvg7+yr7Va4GH9MbYjFzo2r8hhrv0mcZO746kFMJDERt3leOKfSwNOp9PMx15Z+
        JKGAC0OqZQmQRtUM223UG+PedepYxKo7HXV4CPjYVQth67MLkE5Wchb34xzn0QXqg7nRSdFDNo6jf
        kmRzCV1g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-FC
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 8/8] xt_ipp2p: drop requirement that skb is linear
Date:   Mon,  5 Jun 2023 20:17:35 +0100
Message-Id: <20230605191735.119210-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605191735.119210-1-jeremy@azazel.net>
References: <20230605191735.119210-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is no longer necessary.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index def2d1ffc7bf..c7712660816d 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -1278,13 +1278,6 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return 0;
 	}
 
-	/* make sure that skb is linear */
-	if (skb_is_nonlinear(skb)) {
-		if (info->debug)
-			printk("IPP2P.match: nonlinear skb found\n");
-		return 0;
-	}
-
 	if (family == NFPROTO_IPV4) {
 		const struct iphdr *ip = ip_hdr(skb);
 
-- 
2.39.2

