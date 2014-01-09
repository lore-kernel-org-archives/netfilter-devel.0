From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf_tables] netfilter: nft_meta: fix lack of validation of the input register
Date: Thu,  9 Jan 2014 20:06:19 +0100
Message-ID: <1389294379-22042-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45667 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbaAITG1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:06:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to validate that the input register is in the range of
allowed registers, otherwise we can take a incorrect register
value as input that may lead us to a crash.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index b43975a..e8254ad 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -239,6 +239,9 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return err;
 
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
+	err = nft_validate_input_register(priv->sreg);
+	if (err < 0)
+		return err;
 
 	return 0;
 }
-- 
1.7.10.4

