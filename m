From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 43/47] netfilter: nf_tables: use nft_set_lookup_global from nf_tables_newsetelem()
Date: Fri, 30 Mar 2018 13:46:15 +0200
Message-ID: <20180330114619.18797-4-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Replace opencoded implementation of nft_set_lookup_global() by call to
this function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 769d84015073..2bd80fa9b070 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4032,17 +4032,10 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		return err;
 
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
-				   genmask);
-	if (IS_ERR(set)) {
-		if (nla[NFTA_SET_ELEM_LIST_SET_ID]) {
-			set = nf_tables_set_lookup_byid(net,
-					nla[NFTA_SET_ELEM_LIST_SET_ID],
-					genmask);
-		}
-		if (IS_ERR(set))
-			return PTR_ERR(set);
-	}
+	set = nft_set_lookup_global(net, ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
+				    nla[NFTA_SET_ELEM_LIST_SET_ID], genmask);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
 
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
-- 
2.11.0
