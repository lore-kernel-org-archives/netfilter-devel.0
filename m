Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADC7C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiDDMGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbiDDMGa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:06:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D687735A8F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i/gIErQFu32b6V7l0WCEuQhiVq1YKZhZ/z4nlzcflOA=; b=NIkeXE+ef6UbJhKAAAeUgDHcz/
        FqPTFyQO0qR+iTAGbIL1meGVRfZyW09VrMSy1AM2tWCBp6s+xgj4EoC5PTwn7s7lACEhZJuB1wd1a
        TwXyxYeXiauqtAyDGajGY9xIxkY3WMDuftAYtmSn+WxBdZJjgyEvE1+kJYqBy0Y0Cxo2TIttL6T9N
        IdYTibAkcdJ9wlup6htsWieEZPuu354rMpSinEZd9bvvljRUGyBP0lg3YNOygpTxdzHCjAGONFxiG
        0Sk5fLVS0YDFUm+IdvfyzMIdBGodrZNq+SjQx5U582h6G2pLbiGunuJpBJNvzGXtEl3IJB5avxiSO
        pwJLT5KA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLRe-007FLB-NP
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:04:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v2 3/5] netfilter: bitwise: improve error goto labels
Date:   Mon,  4 Apr 2022 13:04:15 +0100
Message-Id: <20220404120417.188410-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120417.188410-1-jeremy@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace two labels (`err1` and `err2`) with more informative ones.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 38dd4aa8cd63..9d3039a4ffa3 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -111,22 +111,23 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 		return err;
 	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
 		err = -EINVAL;
-		goto err1;
+		goto err_mask_release;
 	}
 
 	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		goto err1;
+		goto err_mask_release;
 	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
 		err = -EINVAL;
-		goto err2;
+		goto err_xor_release;
 	}
 
 	return 0;
-err2:
+
+err_xor_release:
 	nft_data_release(&priv->xor, xor.type);
-err1:
+err_mask_release:
 	nft_data_release(&priv->mask, mask.type);
 	return err;
 }
-- 
2.35.1

