Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA32C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D886A2332A
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ZH//VjDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfHUJo1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:44:27 -0400
Received: from mx1.riseup.net ([198.252.153.129]:57136 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfHUJo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:44:27 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 7CFDF1A4B83
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 02:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566380666; bh=q9v1B0d7Hf5AYMCV3c6oX2kmle83bzxfbR4xOlaE3KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH//VjDkHJgv8WhpvDlh4MZvUetXkFN5oGVuu9FcoQTbZTfmZCclIRkvQ3M+x/AYl
         G6ekKUW9G2m5c4ddQCKPPn9Qx10Z4oN16zolAAVK1dZ5TIHTKXgG5lAk9RNag//LSq
         gp7gtgQ8+BNG8aVZytnyRMNlPqrsQsaDTFO+fQ10=
X-Riseup-User-ID: 4B31B150C4B6C1A088014E8769EBB6AC6D1FF74A8CB1C2BBDDBE39802699BF46
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id AA7DC223414;
        Wed, 21 Aug 2019 02:44:25 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nf-next] netfilter: nft_quota: add quota object update support
Date:   Wed, 21 Aug 2019 11:44:20 +0200
Message-Id: <20190821094420.866-2-ffmancera@riseup.net>
In-Reply-To: <20190821094420.866-1-ffmancera@riseup.net>
References: <20190821094420.866-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nft_quota.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c8745d454bf8..ad95cac61e2d 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -105,6 +105,44 @@ static int nft_quota_obj_init(const struct nft_ctx *ctx,
 	return nft_quota_do_init(tb, priv);
 }
 
+static int nft_quota_do_update(const struct nlattr * const tb[],
+			       struct nft_quota * priv)
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
+	priv->quota = quota;
+	priv->flags = flags;
+
+	return 0;
+}
+
+static int nft_quota_obj_update(const struct nft_ctx *ctx,
+				const struct nlattr * const tb[],
+				struct nft_object *obj)
+{
+	struct nft_quota *priv = nft_obj_data(obj);
+
+	return nft_quota_do_update(tb, priv);
+}
+
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
@@ -155,6 +193,7 @@ static const struct nft_object_ops nft_quota_obj_ops = {
 	.init		= nft_quota_obj_init,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
+	.update		= nft_quota_obj_update,
 };
 
 static struct nft_object_type nft_quota_obj_type __read_mostly = {
-- 
2.20.1

