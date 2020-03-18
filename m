Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE23C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06FE120663
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 00:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCRAlO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 20:41:14 -0400
Received: from correo.us.es ([193.147.175.20]:45612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbgCRAkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9522D27F8AC
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85F3ADA3A8
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B2C1DA3A1; Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98738DA3AA;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 71A0A426CCB9;
        Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/29] netfilter: bitwise: use more descriptive variable-names.
Date:   Wed, 18 Mar 2020 01:39:36 +0100
Message-Id: <20200318003956.73573-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Name the mask and xor data variables, "mask" and "xor," instead of "d1"
and "d2."

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 0ed2281f03be..bc37d6c59db4 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -93,7 +93,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 				 const struct nlattr *const tb[])
 {
-	struct nft_data_desc d1, d2;
+	struct nft_data_desc mask, xor;
 	int err;
 
 	if (tb[NFTA_BITWISE_DATA])
@@ -103,29 +103,29 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
+	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &mask,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
+	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
 
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
+	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
+	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
 
 	return 0;
 err2:
-	nft_data_release(&priv->xor, d2.type);
+	nft_data_release(&priv->xor, xor.type);
 err1:
-	nft_data_release(&priv->mask, d1.type);
+	nft_data_release(&priv->mask, mask.type);
 	return err;
 }
 
-- 
2.11.0

