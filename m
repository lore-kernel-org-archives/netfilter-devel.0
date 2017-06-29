From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/29] netfilter: nft_set_hash: unnecessary forward declaration
Date: Fri, 30 Jun 2017 00:53:08 +0200
Message-ID: <1498776807-11124-11-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Replace struct rhashtable_params forward declaration by the structure
definition itself.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 3d3a6df4ce70..850be3a00e62 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -40,8 +40,6 @@ struct nft_hash_cmp_arg {
 	u8				genmask;
 };
 
-static const struct rhashtable_params nft_hash_params;
-
 static inline u32 nft_hash_key(const void *data, u32 len, u32 seed)
 {
 	const struct nft_hash_cmp_arg *arg = data;
@@ -71,6 +69,14 @@ static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
 	return 0;
 }
 
+static const struct rhashtable_params nft_hash_params = {
+	.head_offset		= offsetof(struct nft_hash_elem, node),
+	.hashfn			= nft_hash_key,
+	.obj_hashfn		= nft_hash_obj,
+	.obj_cmpfn		= nft_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
 static bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 			    const u32 *key, const struct nft_set_ext **ext)
 {
@@ -320,14 +326,6 @@ static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 	return sizeof(struct nft_hash);
 }
 
-static const struct rhashtable_params nft_hash_params = {
-	.head_offset		= offsetof(struct nft_hash_elem, node),
-	.hashfn			= nft_hash_key,
-	.obj_hashfn		= nft_hash_obj,
-	.obj_cmpfn		= nft_hash_cmp,
-	.automatic_shrinking	= true,
-};
-
 static int nft_hash_init(const struct nft_set *set,
 			 const struct nft_set_desc *desc,
 			 const struct nlattr * const tb[])
-- 
2.1.4
