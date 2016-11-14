From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_tables: validate maximum value of u32
 netlink hash attribute
Date: Mon, 14 Nov 2016 22:33:34 +0100
Message-ID: <20161114213331.GA13743@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33182 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933258AbcKNVdj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 16:33:39 -0500
Received: by mail-wm0-f68.google.com with SMTP id u144so19256724wmu.0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 13:33:38 -0800 (PST)
Received: from sonyv (72.red-88-15-56.dynamicip.rima-tde.net. [88.15.56.72])
        by smtp.gmail.com with ESMTPSA id b15sm495214wma.5.2016.11.14.13.33.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 14 Nov 2016 13:33:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the function nft_parse_u32_check() to fetch the value and validate
the u32 attribute into the hash len u8 field.

This patch revisits 4da449ae1df9 ("netfilter: nft_exthdr: Add size check
on u8 nft_exthdr attributes").

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_hash.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 97ad8e30e4b4..eb2721af898d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -53,6 +53,7 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 {
 	struct nft_hash *priv = nft_expr_priv(expr);
 	u32 len;
+	int err;
 
 	if (!tb[NFTA_HASH_SREG] ||
 	    !tb[NFTA_HASH_DREG] ||
@@ -66,8 +67,10 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
-	len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
-	if (len == 0 || len > U8_MAX)
+	err = nft_parse_u32_check(tb[NFTA_HASH_LEN], U8_MAX, &len);
+	if (err < 0)
+		return err;
+	if (len == 0)
 		return -ERANGE;
 
 	priv->len = len;
-- 
2.10.2

