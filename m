From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/23] netfilter: nft_hash: fix nft_hash_deactivate
Date: Tue,  7 Nov 2017 01:52:08 +0100
Message-ID: <20171107005213.22618-19-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Jindřich Makovička says:
  The logical OR looks fishy to me. Shouldn't be && there instead?

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1199
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 0fa01d772c5e..650677f1e539 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -494,7 +494,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
-			    set->klen) ||
+			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
 			return he;
-- 
2.11.0
