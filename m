From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 3/5] netfilter: nf_tables: Check u32 load in u8 nft_cmp
 attribute
Date: Wed, 10 Aug 2016 17:31:24 +0200
Message-ID: <1b5a19c8e8439e5e7b078f4572af69f6c180078f.1470842571.git.nevola@gmail.com>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34215 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935832AbcHJTkT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:40:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id q128so11552212wma.1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:39:59 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id g7sm43586353wjx.10.2016.08.10.08.31.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:31:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into the len attribute
with a size of u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_cmp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index e25b35d..ca247e5 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,8 +84,11 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (desc.len > U8_MAX)
+		return -EINVAL;
 	priv->len = desc.len;
+	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+
 	return 0;
 }
 
-- 
2.8.1

