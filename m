From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] nf_tables: reduce chain type table size
Date: Wed, 14 Jun 2017 11:51:29 +0200
Message-ID: <20170614095129.5705-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750764AbdFNJvN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 05:51:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

       text  data  bss     dec    hex filename
old: 151590  2240 1152  154982  25d66 net/netfilter/nf_tables_api.o
new: 151666  2240  416  154322  25ad2 net/netfilter/nf_tables_api.o

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bc8f03a53734..5f3339978f6b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -387,7 +387,7 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 	return ++table->hgenerator;
 }
 
-static const struct nf_chain_type *chain_type[AF_MAX][NFT_CHAIN_T_MAX];
+static const struct nf_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nf_chain_type *
 __nf_tables_chain_type_lookup(int family, const struct nlattr *nla)
@@ -870,6 +870,9 @@ int nft_register_chain_type(const struct nf_chain_type *ctype)
 {
 	int err = 0;
 
+	if (WARN_ON(ctype->family >= NFPROTO_NUMPROTO))
+		return -EINVAL;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (chain_type[ctype->family][ctype->type] != NULL) {
 		err = -EBUSY;
-- 
2.13.0

