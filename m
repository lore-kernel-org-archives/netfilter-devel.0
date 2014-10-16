From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 1/3] netfilter: nft_nat: insufficient attribute validation
Date: Thu, 16 Oct 2014 14:57:16 +0200
Message-ID: <1413464238-4071-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58545 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaJPM4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:56:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to validate that we at least get an NFTA_NAT_REG_ADDR_MIN or
NFTA_NFT_REG_PROTO_MIN attribute. Reject the configuration if none
of them are present.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 0f0af6e..3edb76c 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -99,7 +99,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_NAT_TYPE] == NULL)
+	if (tb[NFTA_NAT_TYPE] == NULL ||
+	    (tb[NFTA_NAT_REG_ADDR_MIN] == NULL &&
+	     tb[NFTA_NFT_REG_PROTO_MIN] == NULL))
 		return -EINVAL;
 
 	switch (ntohl(nla_get_be32(tb[NFTA_NAT_TYPE]))) {
-- 
1.7.10.4

