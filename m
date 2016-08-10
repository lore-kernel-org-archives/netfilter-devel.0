From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 1/5] netfilter: nf_tables: Check u32 load in u8 nft_bitwise
 attribute
Date: Wed, 10 Aug 2016 17:30:13 +0200
Message-ID: <c01cc15bf84922f25dc18fe8c494d32d9048d524.1470842571.git.nevola@gmail.com>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36354 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbcHJTTx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:19:53 -0400
Received: by mail-wm0-f68.google.com with SMTP id i138so11425547wmf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:19:53 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id i8sm8915269wmg.21.2016.08.10.08.30.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:30:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into the len attribute
with a size of u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_bitwise.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d71cc18..2c49f69 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -53,6 +53,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_data_desc d1, d2;
 	int err;
+	u32 len;
 
 	if (tb[NFTA_BITWISE_SREG] == NULL ||
 	    tb[NFTA_BITWISE_DREG] == NULL ||
@@ -61,7 +62,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	    tb[NFTA_BITWISE_XOR] == NULL)
 		return -EINVAL;
 
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
+	len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
+	if (len > U8_MAX)
+		return -EINVAL;
+	priv->len = len;
+
 	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
-- 
2.8.1

