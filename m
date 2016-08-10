From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 2/5] netfilter: nf_tables: Check u32 load in u8 nft_byteorder
 attribute
Date: Wed, 10 Aug 2016 17:31:00 +0200
Message-ID: <0b8cf8c8d981de2ee30440a24a011ab88a16c67b.1470842571.git.nevola@gmail.com>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36690 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934117AbcHJTcw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:32:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id i138so11490359wmf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:32:51 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id bw9sm43613764wjc.33.2016.08.10.08.31.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:31:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into the len and size
attributes with a size of u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_byteorder.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b78c28b..fdd23d5 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -100,6 +100,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
 	int err;
+	u32 len, size;
 
 	if (tb[NFTA_BYTEORDER_SREG] == NULL ||
 	    tb[NFTA_BYTEORDER_DREG] == NULL ||
@@ -117,7 +118,10 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 	}
 
-	priv->size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
+	size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
+	if (size > U8_MAX)
+		return -EINVAL;
+	priv->size = size;
 	switch (priv->size) {
 	case 2:
 	case 4:
@@ -128,7 +132,12 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	}
 
 	priv->sreg = nft_parse_register(tb[NFTA_BYTEORDER_SREG]);
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
+
+	len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
+	if (len > U8_MAX)
+		return -EINVAL;
+	priv->len = len;
+
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
 		return err;
-- 
2.8.1

