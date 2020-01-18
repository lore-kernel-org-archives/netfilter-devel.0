Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806D6C32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C3DC24683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgARUOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:42 -0500
Received: from correo.us.es ([193.147.175.20]:48486 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgARUOf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0ED872EFEBC
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2B8ADA712
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E740BDA70F; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E72BDDA713;
        Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C16C741E4800;
        Sat, 18 Jan 2020 21:14:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/21] netfilter: bitwise: add helper for dumping boolean operations.
Date:   Sat, 18 Jan 2020 21:14:14 +0100
Message-Id: <20200118201417.334111-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Split the code specific to dumping bitwise boolean operations out into a
separate function.  A similar function will be added later for shift
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 88a91c63f213..41265134cf0b 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -143,9 +143,24 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	return err;
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
+	int err = 0;
 
 	if (nft_dump_register(skb, NFTA_BITWISE_SREG, priv->sreg))
 		return -1;
@@ -156,15 +171,13 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
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
+		err = nft_bitwise_dump_bool(skb, priv);
+		break;
+	}
 
-	return 0;
+	return err;
 }
 
 static struct nft_data zero;
-- 
2.11.0

