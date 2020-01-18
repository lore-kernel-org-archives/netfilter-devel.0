Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780F7C32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D2B24683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgARUOs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:48 -0500
Received: from correo.us.es ([193.147.175.20]:48472 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgARUOe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15B522EFEB3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01F88DA711
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBE2CDA70F; Sat, 18 Jan 2020 21:14:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4FA2DA705;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BB48241E4800;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/21] netfilter: bitwise: add helper for initializing boolean operations.
Date:   Sat, 18 Jan 2020 21:14:12 +0100
Message-Id: <20200118201417.334111-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Split the code specific to initializing bitwise boolean operations out
into a separate function.  A similar function will be added later for
shift operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 66 ++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 6948df7b0587..d0cc5f753e52 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -45,20 +45,53 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 };
 
+static int nft_bitwise_init_bool(struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
+{
+	struct nft_data_desc d1, d2;
+	int err;
+
+	if (!tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
+			    tb[NFTA_BITWISE_MASK]);
+	if (err < 0)
+		return err;
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
+			    tb[NFTA_BITWISE_XOR]);
+	if (err < 0)
+		goto err1;
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
+		err = -EINVAL;
+		goto err2;
+	}
+
+	return 0;
+err2:
+	nft_data_release(&priv->xor, d2.type);
+err1:
+	nft_data_release(&priv->mask, d1.type);
+	return err;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
 {
 	struct nft_bitwise *priv = nft_expr_priv(expr);
-	struct nft_data_desc d1, d2;
 	u32 len;
 	int err;
 
 	if (!tb[NFTA_BITWISE_SREG] ||
 	    !tb[NFTA_BITWISE_DREG] ||
-	    !tb[NFTA_BITWISE_LEN]  ||
-	    !tb[NFTA_BITWISE_MASK] ||
-	    !tb[NFTA_BITWISE_XOR])
+	    !tb[NFTA_BITWISE_LEN])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
@@ -90,29 +123,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		priv->op = NFT_BITWISE_BOOL;
 	}
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
-			    tb[NFTA_BITWISE_MASK]);
-	if (err < 0)
-		return err;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
-		err = -EINVAL;
-		goto err1;
-	}
-
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
-			    tb[NFTA_BITWISE_XOR]);
-	if (err < 0)
-		goto err1;
-	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
-		err = -EINVAL;
-		goto err2;
+	switch(priv->op) {
+	case NFT_BITWISE_BOOL:
+		err = nft_bitwise_init_bool(priv, tb);
+		break;
 	}
 
-	return 0;
-err2:
-	nft_data_release(&priv->xor, d2.type);
-err1:
-	nft_data_release(&priv->mask, d1.type);
 	return err;
 }
 
-- 
2.11.0

