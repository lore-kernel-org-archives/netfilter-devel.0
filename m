Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1348C33CB6
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD3024683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgARUOz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:55 -0500
Received: from correo.us.es ([193.147.175.20]:48418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbgARUOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EED6F2EFEAB
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCC05DA70F
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2682DA702; Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D56A1DA703;
        Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B033941E4800;
        Sat, 18 Jan 2020 21:14:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/21] netfilter: bitwise: replace gotos with returns.
Date:   Sat, 18 Jan 2020 21:14:10 +0100
Message-Id: <20200118201417.334111-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

When dumping a bitwise expression, if any of the puts fails, we use goto
to jump to a label.  However, no clean-up is required and the only
statement at the label is a return.  Drop the goto's and return
immediately instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 85605fb1e360..c15e9beb5243 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -107,24 +107,21 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_BITWISE_SREG, priv->sreg))
-		goto nla_put_failure;
+		return -1;
 	if (nft_dump_register(skb, NFTA_BITWISE_DREG, priv->dreg))
-		goto nla_put_failure;
+		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
-		goto nla_put_failure;
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
-		goto nla_put_failure;
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor,
 			  NFT_DATA_VALUE, priv->len) < 0)
-		goto nla_put_failure;
+		return -1;
 
 	return 0;
-
-nla_put_failure:
-	return -1;
 }
 
 static struct nft_data zero;
-- 
2.11.0

