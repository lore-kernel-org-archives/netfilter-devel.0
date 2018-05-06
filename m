From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 37/51] netfilter: nf_tables: always use an upper set size for dynsets
Date: Mon,  7 May 2018 00:46:55 +0200
Message-ID: <20180506224709.29100-38-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nft rejects rules that lack a timeout and a size limit when they're used
to add elements from packet path.

Pick a sane upperlimit instead of rejecting outright.
The upperlimit is visible to userspace, just as if it would have been
given during set declaration.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 04863fad05dd..5cc3509659c6 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -36,7 +36,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	u64 timeout;
 	void *elem;
 
-	if (set->size && !atomic_add_unless(&set->nelems, 1, set->size))
+	if (!atomic_add_unless(&set->nelems, 1, set->size))
 		return NULL;
 
 	timeout = priv->timeout ? : set->timeout;
@@ -216,6 +216,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err1;
 
+	if (set->size == 0)
+		set->size = 0xffff;
+
 	priv->set = set;
 	return 0;
 
-- 
2.11.0
