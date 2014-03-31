From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: relax string validation of NFTA_CHAIN_TYPE
Date: Mon, 31 Mar 2014 17:43:47 +0200
Message-ID: <1396280627-4070-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55368 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbaCaPoN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:44:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use NLA_STRING for consistency with other string attributes in
nf_tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3fd159d..778c94c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -541,7 +541,7 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
-	[NFTA_CHAIN_TYPE]	= { .type = NLA_NUL_STRING },
+	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 };
 
-- 
1.7.10.4

