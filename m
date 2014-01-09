From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 06/13] netfilter: nf_tables: replay request after dropping locks to load chain type
Date: Thu,  9 Jan 2014 18:42:36 +0000
Message-ID: <1389292963-4089-7-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaAISnS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:18 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To avoid races, we need to replay to request after dropping the nfnl_mutex
to auto-load the chain type module.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d913fb0..7d6a226 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -147,16 +147,20 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 	struct nf_chain_type *type;
 
 	type = __nf_tables_chain_type_lookup(afi->family, nla);
+	if (type != NULL)
+		return type;
 #ifdef CONFIG_MODULES
-	if (type == NULL && autoload) {
+	if (autoload) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		request_module("nft-chain-%u-%*.s", afi->family,
 			       nla_len(nla)-1, (const char *)nla_data(nla));
 		nfnl_lock(NFNL_SUBSYS_NFTABLES);
 		type = __nf_tables_chain_type_lookup(afi->family, nla);
+		if (type != NULL)
+			return ERR_PTR(-EAGAIN);
 	}
 #endif
-	return type;
+	return ERR_PTR(-ENOENT);
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
@@ -906,8 +910,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			type = nf_tables_chain_type_lookup(afi,
 							   nla[NFTA_CHAIN_TYPE],
 							   create);
-			if (type == NULL)
-				return -ENOENT;
+			if (IS_ERR(type))
+				return PTR_ERR(type);
 		}
 
 		err = nla_parse_nested(ha, NFTA_HOOK_MAX, nla[NFTA_CHAIN_HOOK],
-- 
1.8.4.2

