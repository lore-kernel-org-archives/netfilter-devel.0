From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/21] netfilter: nf_tables: use struct nft_set_iter in set element flush
Date: Sun, 12 Feb 2017 20:42:35 +0100
Message-ID: <1486928573-24773-4-git-send-email-pablo@netfilter.org>
References: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Instead of struct nft_set_dump_args, remove unnecessary wrapper
structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3643ce345b59..790ffed82930 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3936,15 +3936,13 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 		return -EBUSY;
 
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
-		struct nft_set_dump_args args = {
-			.iter	= {
-				.genmask	= genmask,
-				.fn		= nft_flush_set,
-			},
+		struct nft_set_iter iter = {
+			.genmask	= genmask,
+			.fn		= nft_flush_set,
 		};
-		set->ops->walk(&ctx, set, &args.iter);
+		set->ops->walk(&ctx, set, &iter);
 
-		return args.iter.err;
+		return iter.err;
 	}
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-- 
2.1.4
