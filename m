From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/13] netfilter: nft_range: validate operation netlink attribute
Date: Fri, 21 Oct 2016 12:12:19 +0200
Message-ID: <1477044743-18948-10-git-send-email-pablo@netfilter.org>
References: <1477044743-18948-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754876AbcJUKMp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:12:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38CC926E0D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:12:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25E3CDA911
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:12:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA177DA7FA
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:12:41 +0200 (CEST)
In-Reply-To: <1477044743-18948-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nft_parse_u32_check() to make sure we don't get a value over the
unsigned 8-bit integer. Moreover, make sure this value doesn't go over
the two supported range comparison modes.

Fixes: 9286c2eb1fda ("netfilter: nft_range: validate operation netlink attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_range.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index c6d5358482d1..9bc4586c3006 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -59,6 +59,7 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	struct nft_range_expr *priv = nft_expr_priv(expr);
 	struct nft_data_desc desc_from, desc_to;
 	int err;
+	u32 op;
 
 	err = nft_data_init(NULL, &priv->data_from, sizeof(priv->data_from),
 			    &desc_from, tb[NFTA_RANGE_FROM_DATA]);
@@ -80,7 +81,20 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	if (err < 0)
 		goto err2;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_RANGE_OP]));
+	err = nft_parse_u32_check(tb[NFTA_RANGE_OP], U8_MAX, &op);
+	if (err < 0)
+		goto err2;
+
+	switch (op) {
+	case NFT_RANGE_EQ:
+	case NFT_RANGE_NEQ:
+		break;
+	default:
+		err = -EINVAL;
+		goto err2;
+	}
+
+	priv->op  = op;
 	priv->len = desc_from.len;
 	return 0;
 err2:
-- 
2.1.4

