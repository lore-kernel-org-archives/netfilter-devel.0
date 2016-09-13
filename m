From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] netfilter: nft_hash: fix hash overflow validation
Date: Tue, 13 Sep 2016 10:21:46 +0200
Message-ID: <20160913082144.GA5689@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33462 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbcIMIVu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 04:21:50 -0400
Received: by mail-wm0-f65.google.com with SMTP id b187so17108545wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 01:21:50 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id e5sm4055065wma.13.2016.09.13.01.21.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 13 Sep 2016 01:21:49 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The overflow validation in the init() function establishes that the
maximum value that the hash could reach is less than U32_MAX, which is
likely to be true.

The fix detects the overflow when the maximum hash value is less than
the offset itself.

Fixes: 70ca767ea1b2 ("netfilter: nft_hash: Add hash offset value")

Reported-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index bd12f7a..09473b4 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -76,7 +76,7 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	if (priv->modulus <= 1)
 		return -ERANGE;
 
-	if (priv->offset + priv->modulus - 1 < U32_MAX)
+	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
 	priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
-- 
2.8.1

