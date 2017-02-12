From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/21] netfilter: nf_tables: honor NFT_SET_OBJECT in set backend selection
Date: Sun, 12 Feb 2017 20:42:53 +0100
Message-ID: <1486928573-24773-22-git-send-email-pablo@netfilter.org>
References: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Check for NFT_SET_OBJECT feature flag, otherwise we may end up selecting
the wrong set backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c  | 3 ++-
 net/netfilter/nft_set_hash.c   | 2 +-
 net/netfilter/nft_set_rbtree.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6c782532615f..ff7304ae58ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2424,7 +2424,8 @@ nft_select_set_ops(const struct nlattr * const nla[],
 	features = 0;
 	if (nla[NFTA_SET_FLAGS] != NULL) {
 		features = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
-		features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT;
+		features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT |
+			    NFT_SET_OBJECT;
 	}
 
 	bops	    = NULL;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6938bc890f31..5f652720fc78 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -404,7 +404,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
 	.lookup		= nft_hash_lookup,
 	.update		= nft_hash_update,
 	.walk		= nft_hash_walk,
-	.features	= NFT_SET_MAP | NFT_SET_TIMEOUT,
+	.features	= NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 3387ed7dd231..71e8fb886a73 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -310,7 +310,7 @@ static struct nft_set_ops nft_rbtree_ops __read_mostly = {
 	.activate	= nft_rbtree_activate,
 	.lookup		= nft_rbtree_lookup,
 	.walk		= nft_rbtree_walk,
-	.features	= NFT_SET_INTERVAL | NFT_SET_MAP,
+	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.1.4
