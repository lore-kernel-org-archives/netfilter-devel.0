From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/9] netfilter: nft_exthdr: Add size check on u8 nft_exthdr attributes
Date: Wed, 10 Aug 2016 20:56:34 +0200
Message-ID: <1470855394-7234-10-git-send-email-pablo@netfilter.org>
References: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbcHJS4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:56:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9C4571F18CB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8BF96100A6B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7EDBE100A40
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:45 +0200 (CEST)
In-Reply-To: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Laura Garcia Liebana <nevola@gmail.com>

Fix the direct assignment of offset and length attributes included in
nft_exthdr structure from u32 data to u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index ba7aed1..82c264e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -59,6 +59,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
+	u32 offset, len;
 
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
 	    tb[NFTA_EXTHDR_TYPE] == NULL ||
@@ -66,9 +67,15 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	    tb[NFTA_EXTHDR_LEN] == NULL)
 		return -EINVAL;
 
+	offset = ntohl(nla_get_be32(tb[NFTA_EXTHDR_OFFSET]));
+	len = ntohl(nla_get_be32(tb[NFTA_EXTHDR_LEN]));
+
+	if (offset > U8_MAX || len > U8_MAX)
+		return -ERANGE;
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_EXTHDR_OFFSET]));
-	priv->len    = ntohl(nla_get_be32(tb[NFTA_EXTHDR_LEN]));
+	priv->offset = offset;
+	priv->len    = len;
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
-- 
2.1.4

