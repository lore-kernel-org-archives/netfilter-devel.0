Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86268C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiDDMI0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiDDMIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:08:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AD23DA62
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WsFa8wgagDjf0dCFZXOsmSM1LviWs9C0i4Nvri3rRwc=; b=gRGdsuiiNVmsvvdvxqVRLFUBbS
        zhw4QsU4qiDMtrPzuUuB5xr7HA5ev0cluSWutvPtMDBpxFcj5K5NNLAiuQS9Z4TD2a6pDCfhk9rCA
        9tDt3D9f5m47ted3oA3voNT+0JWOJUcoRuyDL99/Pbt93vVQNzQzi9+qjkaIeZw2UICTCVu8/addp
        9GYhtRChpHyqhE7gnoPKPyTBafEYNogVc638w3ZRJHHGB+Dhkjn9iRkZEs0nhQLzgZpM7fiFdwzoh
        IvYKeGDhqmN6CfMLTK29IiJQhuklmmlIrBypnk3Mv/cDxZOwYsDpXJy2nKosIEHEOvWBHAOdIJecN
        9i17uM3w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLTX-007FNA-Lk
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:06:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnftnl PATCH v2 2/9] include: add new bitwise bit-length attribute to nf_tables.h
Date:   Mon,  4 Apr 2022 13:06:16 +0100
Message-Id: <20220404120623.188439-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120623.188439-1-jeremy@azazel.net>
References: <20220404120623.188439-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel can now keep track of the bit-length of boolean expressions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 466fd3f4447c..f3dcc4a34ff1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -561,6 +561,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_NBITS: length of operation in bits (NLA_U32)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -584,6 +585,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_NBITS,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
-- 
2.35.1

