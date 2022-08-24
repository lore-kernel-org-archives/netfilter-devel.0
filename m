Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C69C3F6B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 22:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbiHXWD5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbiHXWDx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 18:03:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C2CF76948;
        Wed, 24 Aug 2022 15:03:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 07/14] netfilter: nft_payload: do not truncate csum_offset and csum_type
Date:   Thu, 25 Aug 2022 00:03:23 +0200
Message-Id: <20220824220330.64283-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead report ERANGE if csum_offset is too long, and EOPNOTSUPP if type
is not support.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 4fee67abfe2c..eb0e40c29712 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -740,17 +740,23 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nlattr * const tb[])
 {
 	struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
+	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
-		priv->csum_type =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
-	if (tb[NFTA_PAYLOAD_CSUM_OFFSET])
-		priv->csum_offset =
-			ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_OFFSET]));
+		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
+	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
+		err = nft_parse_u32_check(tb[NFTA_PAYLOAD_CSUM_OFFSET], U8_MAX,
+					  &csum_offset);
+		if (err < 0)
+			return err;
+
+		priv->csum_offset = csum_offset;
+	}
 	if (tb[NFTA_PAYLOAD_CSUM_FLAGS]) {
 		u32 flags;
 
@@ -761,7 +767,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		priv->csum_flags = flags;
 	}
 
-	switch (priv->csum_type) {
+	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
@@ -775,6 +781,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	default:
 		return -EOPNOTSUPP;
 	}
+	priv->csum_type = csum_type;
 
 	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
 				       priv->len);
-- 
2.30.2

