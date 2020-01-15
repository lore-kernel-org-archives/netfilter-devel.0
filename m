Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9C0C33CB3
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE952081E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 21:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FjtHyqO1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgAOVcV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:32:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56850 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbgAOVcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 16:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=plc2ugXJZPDyInX8U5Ek2zakif7sCVEOMJE7WTe9CH4=; b=FjtHyqO1MBo5ZCl9XxkAIA9lWM
        navT/dlomXgXsITMnlmPbDzBeTBXkKg6aekHe1ENrXK47anOQThWmGWGPLAG/cv56SbJ3ohMkm4Me
        QfgwTjR3esBYBVLIN3lO1b/wyybs0/+ns6Wmqni6MhriVyNbf9RU10AJXfgpLjkpepWeX26otzz6Q
        qMhUgHAX6dbJEw2sTIw4v7KwfcxQ/r0KsvulA6lzNVhBGfA1XJPMn3+Z0ZGe0Vdy9x8KPwmBYLE68
        EEgynMUe3RS0Cw88Ol3dSXWMczbqMEiirOcB+VXmQjv/LRmWTxBQyvKqKL0/rUvyPih0ho47F31dn
        oetmqJ6A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irqGw-0008BP-Gc; Wed, 15 Jan 2020 21:32:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v4 07/10] netfilter: bitwise: add helper for dumping boolean operations.
Date:   Wed, 15 Jan 2020 21:32:13 +0000
Message-Id: <20200115213216.77493-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115213216.77493-1-jeremy@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split the code specific to dumping bitwise boolean operations out into a
separate function.  A similar function will be added later for shift
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 5f9d151b7047..40272a45deeb 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -142,6 +142,20 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	return -EINVAL;
 }
 
+static int nft_bitwise_dump_bool(struct sk_buff *skb,
+				 const struct nft_bitwise *priv)
+{
+	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
+			  NFT_DATA_VALUE, priv->len) < 0)
+		return -1;
+
+	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor,
+			  NFT_DATA_VALUE, priv->len) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
@@ -155,15 +169,12 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(priv->op)))
 		return -1;
 
-	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
-			  NFT_DATA_VALUE, priv->len) < 0)
-		return -1;
-
-	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor,
-			  NFT_DATA_VALUE, priv->len) < 0)
-		return -1;
+	switch (priv->op) {
+	case NFT_BITWISE_BOOL:
+		return nft_bitwise_dump_bool(skb, priv);
+	}
 
-	return 0;
+	return -1;
 }
 
 static struct nft_data zero;
-- 
2.24.1

