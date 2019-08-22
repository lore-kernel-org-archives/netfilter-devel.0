Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE572C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 16:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46B623404
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 16:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="f5nL48wc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbfHVQsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:48:38 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50666 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731428AbfHVQsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 12:48:38 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D1EA81A652C
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2019 09:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566492517; bh=6IXxUll4uGRpbHVzL+gQv1CCvBtO+upfs03bBiVCsRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5nL48wcq2GO9CbbxfwguEfsIVWubDP96oHfbcO+Iv1Svmp+mRqLKExQ9NZ6MWIMC
         RdHhqVRV6p6Hu67WGXGyxjfHDeSvhJCja6Wr1rFH1CUAbseji4v1aQbmi8FItsFu5F
         JFTajZsRTKd9vT9uEJILq0iDGO9cNkyOiHm+LuBw=
X-Riseup-User-ID: 56E9E8BEAF3E70B7AC6566D4A3D4D44C8818A4C33F213326E5556C90AA4A2E23
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 7EDCA1209F2;
        Thu, 22 Aug 2019 09:48:36 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nf-next v2] netfilter: nft_quota: add quota object update support
Date:   Thu, 22 Aug 2019 18:48:27 +0200
Message-Id: <20190822164827.1064-2-ffmancera@riseup.net>
In-Reply-To: <20190822164827.1064-1-ffmancera@riseup.net>
References: <20190822164827.1064-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nft_quota.c | 42 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c8745d454bf8..2afea3f50a51 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -105,6 +105,47 @@ static int nft_quota_obj_init(const struct nft_ctx *ctx,
 	return nft_quota_do_init(tb, priv);
 }
 
+static int nft_quota_do_update(const struct nlattr * const tb[],
+			       struct nft_quota * priv, bool commit)
+{
+	unsigned long flags;
+	u64 quota;
+
+	flags = priv->flags;
+	quota = priv->quota;
+
+	if (tb[NFTA_QUOTA_BYTES]) {
+		quota = be64_to_cpu(nla_get_be64(tb[NFTA_QUOTA_BYTES]));
+		if (quota > S64_MAX)
+			return -EOVERFLOW;
+	}
+
+	if (tb[NFTA_QUOTA_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_QUOTA_FLAGS]));
+		if (flags & ~NFT_QUOTA_F_INV)
+			return -EINVAL;
+		if (flags & ~NFT_QUOTA_F_DEPLETED)
+			return -EOPNOTSUPP;
+	}
+
+	if (commit) {
+		priv->quota = quota;
+		priv->flags = flags;
+	}
+
+	return 0;
+}
+
+static int nft_quota_obj_update(const struct nft_ctx *ctx,
+				const struct nlattr * const tb[],
+				struct nft_object *obj,
+				bool commit)
+{
+	struct nft_quota *priv = nft_obj_data(obj);
+
+	return nft_quota_do_update(tb, priv, commit);
+}
+
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
@@ -155,6 +196,7 @@ static const struct nft_object_ops nft_quota_obj_ops = {
 	.init		= nft_quota_obj_init,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
+	.update		= nft_quota_obj_update,
 };
 
 static struct nft_object_type nft_quota_obj_type __read_mostly = {
-- 
2.20.1

