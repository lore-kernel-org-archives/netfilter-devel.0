From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] netfilter: nf_tables: Add size check on u8 nft_exthdr
 attributes
Date: Tue, 9 Aug 2016 20:46:16 +0200
Message-ID: <20160809184614.GA8947@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33074 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbcHISqV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 14:46:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so4957583wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2016 11:46:21 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id va3sm39315098wjb.18.2016.08.09.11.46.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 09 Aug 2016 11:46:19 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment of offset and length attributes included in
nft_exthdr structure from u32 data to u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_exthdr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index ba7aed1..dec3c36 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -59,6 +59,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
+	u32 offset, len;
 
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
 	    tb[NFTA_EXTHDR_TYPE] == NULL ||
@@ -67,8 +68,16 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_EXTHDR_OFFSET]));
-	priv->len    = ntohl(nla_get_be32(tb[NFTA_EXTHDR_LEN]));
+
+	offset = ntohl(nla_get_be32(tb[NFTA_EXTHDR_OFFSET]));
+	len    = ntohl(nla_get_be32(tb[NFTA_EXTHDR_LEN]));
+
+	if (offset > U8_MAX || len > U8_MAX)
+		return -EINVAL;
+
+	priv->offset = offset;
+	priv->len = len;
+
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
-- 
2.8.1

