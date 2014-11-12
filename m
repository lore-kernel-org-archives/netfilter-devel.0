From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nft_redir: fix sparse warnings
Date: Wed, 12 Nov 2014 12:01:36 +0100
Message-ID: <1415790096-6625-2-git-send-email-pablo@netfilter.org>
References: <1415790096-6625-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaKLK7q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:59:46 -0500
In-Reply-To: <1415790096-6625-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> net/netfilter/nft_redir.c:39:26: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_redir.c:39:26:    expected unsigned int [unsigned] [usertype] nla_be32
   net/netfilter/nft_redir.c:39:26:    got restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:40:40: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:46:34: sparse: incorrect type in assignment (different base types)
   net/netfilter/nft_redir.c:46:34:    expected unsigned int [unsigned] [usertype] nla_be32
   net/netfilter/nft_redir.c:46:34:    got restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32
>> net/netfilter/nft_redir.c:47:48: sparse: cast to restricted __be32

Fixes: e9105f1 ("netfilter: nf_tables: add new expression nft_redir")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_redir.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index e27b4e3..9e8093f 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -28,7 +28,6 @@ int nft_redir_init(const struct nft_ctx *ctx,
 		   const struct nlattr * const tb[])
 {
 	struct nft_redir *priv = nft_expr_priv(expr);
-	u32 nla_be32;
 	int err;
 
 	err = nft_chain_validate_dependency(ctx->chain, NFT_CHAIN_T_NAT);
@@ -36,15 +35,17 @@ int nft_redir_init(const struct nft_ctx *ctx,
 		return err;
 
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
-		nla_be32 = nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MIN]);
-		priv->sreg_proto_min = ntohl(nla_be32);
+		priv->sreg_proto_min =
+			ntohl(nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MIN]));
+
 		err = nft_validate_input_register(priv->sreg_proto_min);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
-			nla_be32 = nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MAX]);
-			priv->sreg_proto_max = ntohl(nla_be32);
+			priv->sreg_proto_max =
+				ntohl(nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MAX]));
+
 			err = nft_validate_input_register(priv->sreg_proto_max);
 			if (err < 0)
 				return err;
-- 
1.7.10.4

