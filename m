Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6AFC3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 11:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA94A20874
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 11:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="kf7W+ut4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfHZLlE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 07:41:04 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52982 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfHZLlE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 07:41:04 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D0D951A1611
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2019 04:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566819663; bh=saGT/03OnUNp2OcaABI7JVvdbK7Z4ydTc+BdOx3bIMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kf7W+ut4pDcm1J8QrBOOgEvzGcyuAxy5AircMXSfQvqZzonnKH6+rhwoEqsTCkkA/
         Ijd95PT69Y9iPXQ5QiNr3jE9F33rZI8388GpRESGABm56/TEKeo/SetDK07LfOyOGr
         T8EH2lYeJ07wwr5QZwjVigE0CwZHpP5MzXHuwp1Y=
X-Riseup-User-ID: 8EFACB0BA5F4BE461DFDE889ABB802CC0BE85B0F088B67336EB5C69391FD68D4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 102ED22224B;
        Mon, 26 Aug 2019 04:41:02 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nf-next v3] netfilter: nft_quota: add quota object update support
Date:   Mon, 26 Aug 2019 13:40:53 +0200
Message-Id: <20190826114054.877-2-ffmancera@riseup.net>
In-Reply-To: <20190826114054.877-1-ffmancera@riseup.net>
References: <20190826114054.877-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nft_quota.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c8745d454bf8..3860941f6824 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -13,7 +13,7 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_quota {
-	u64		quota;
+	atomic64_t	quota;
 	unsigned long	flags;
 	atomic64_t	consumed;
 };
@@ -21,7 +21,8 @@ struct nft_quota {
 static inline bool nft_overquota(struct nft_quota *priv,
 				 const struct sk_buff *skb)
 {
-	return atomic64_add_return(skb->len, &priv->consumed) >= priv->quota;
+	return atomic64_add_return(skb->len, &priv->consumed) >=
+	       atomic64_read(&priv->quota);
 }
 
 static inline bool nft_quota_invert(struct nft_quota *priv)
@@ -89,7 +90,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			return -EOPNOTSUPP;
 	}
 
-	priv->quota = quota;
+	atomic64_set(&priv->quota, quota);
 	priv->flags = flags;
 	atomic64_set(&priv->consumed, consumed);
 
@@ -105,10 +106,24 @@ static int nft_quota_obj_init(const struct nft_ctx *ctx,
 	return nft_quota_do_init(tb, priv);
 }
 
+static int nft_quota_obj_update(struct nft_object *obj,
+				struct nft_object *newobj)
+{
+	struct nft_quota *newpriv = nft_obj_data(newobj);
+	struct nft_quota *priv = nft_obj_data(obj);
+	u64 newquota;
+
+	newquota = atomic64_read(&newpriv->quota);
+	atomic64_set(&priv->quota, newquota);
+	priv->flags = newpriv->flags;
+
+	return 0;
+}
+
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
-	u64 consumed, consumed_cap;
+	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
 	/* Since we inconditionally increment consumed quota for each packet
@@ -116,14 +131,15 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	 * userspace.
 	 */
 	consumed = atomic64_read(&priv->consumed);
-	if (consumed >= priv->quota) {
-		consumed_cap = priv->quota;
+	quota = atomic64_read(&priv->quota);
+	if (consumed >= quota) {
+		consumed_cap = quota;
 		flags |= NFT_QUOTA_F_DEPLETED;
 	} else {
 		consumed_cap = consumed;
 	}
 
-	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(priv->quota),
+	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(quota),
 			 NFTA_QUOTA_PAD) ||
 	    nla_put_be64(skb, NFTA_QUOTA_CONSUMED, cpu_to_be64(consumed_cap),
 			 NFTA_QUOTA_PAD) ||
@@ -155,6 +171,7 @@ static const struct nft_object_ops nft_quota_obj_ops = {
 	.init		= nft_quota_obj_init,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
+	.update		= nft_quota_obj_update,
 };
 
 static struct nft_object_type nft_quota_obj_type __read_mostly = {
-- 
2.20.1

