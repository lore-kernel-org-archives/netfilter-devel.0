Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F61C35671
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C60D2072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="jhUdClEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBXMte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
Received: from kadath.azazel.net ([81.187.231.250]:57308 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBXMte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 07:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ec1eUAbhUyY93eQVJ54OSmsGPab44JlTEiIv2rjjGUA=; b=jhUdClErxiWPT/FdZJ83VYd/AS
        4B/v/IZ8Mynso1oQQgMO0jTUYcpAsi4Dy/ycKzXgyir5XbKWm5PaN5V8ctK40G7S385FZTR91qvcS
        1vNGietxwPLzGUCjzjIPUbRWwR3T7mAz3DvTEoLiqbPGSGZRhwhILjd6UUlByEOfwHpGzzDOR/ayb
        pc8fKNJ5crV0/8daxK5R7fjlRTvkc2vazkYknnbvAvhElrykjRULqx8Br9A21SP08na+QdXYmfUzE
        k/X7fEVY75WSfUkW544e9+QbVGZzS9DozCcX+OnWxk44M2mWajvNE4eulhvralrEb3TDpUuOgo30S
        /Fp/KaKQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6DAy-0001eE-7i; Mon, 24 Feb 2020 12:49:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 1/2] netfilter: bitwise: use more descriptive variable-names.
Date:   Mon, 24 Feb 2020 12:49:30 +0000
Message-Id: <20200224124931.512416-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224124931.512416-1-jeremy@azazel.net>
References: <20200224124931.512416-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Name the mask and xor data variables, "mask" and "xor," instead of "d1"
and "d2."

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
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
2.25.0

