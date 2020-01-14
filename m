Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12222C33CB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9A2D24656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="gcrcPbrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgANV3Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:29:24 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55082 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbgANV3U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:29:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5R7rJZtK438G0Rhnzl9o2VYsf+EsM470cPNvqvVjV8k=; b=gcrcPbrs4ImFa70ylia33u/6ca
        p3Iwt0SUxIQSiW3GgMvJu1arXhnHzFUojHLPjyMUHgykOLiMaHTstHg6wkjQmJ5Z8PW/iriljkDBi
        7Lb2lg9X1WOFCI+/wdQJLhIdxldSKVZy2L4Xs2I7ywOhIFMi7STn8ZZTSvAkuHTlrVC78x+KlbqR9
        8Gv7ll5uWGOFD4g3LZd27clquOH8MIERYT0OMr/l0uyd5yEvQbKQxgZeqeTBGplPIn6CGlUuKfwww
        dLbrbYfoTJi8zjJckrROwwJncCrMsW24jPGLrUoOPmGI+kJS5qRHzrVSvJ9kCoIaGG67qjk/HmJuX
        KYpVuHnQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkV-0001Dh-F7; Tue, 14 Jan 2020 21:29:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 06/10] netfilter: bitwise: add helper for evaluating boolean operations.
Date:   Tue, 14 Jan 2020 21:29:14 +0000
Message-Id: <20200114212918.134062-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114212918.134062-1-jeremy@azazel.net>
References: <20200114212918.134062-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split the code specific to evaluating bitwise boolean operations out
into a separate function.  Similar functions will be added later for
shift operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 4a8d37eb43a4..5f9d151b7047 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -24,16 +24,27 @@ struct nft_bitwise {
 	struct nft_data		xor;
 };
 
+static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
+				  const struct nft_bitwise *priv)
+{
+	unsigned int i;
+
+	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
+		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const u32 *src = &regs->data[priv->sreg];
 	u32 *dst = &regs->data[priv->dreg];
-	unsigned int i;
 
-	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
-		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+	switch (priv->op) {
+	case NFT_BITWISE_BOOL:
+		nft_bitwise_eval_bool(dst, src, priv);
+		break;
+	}
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
-- 
2.24.1

