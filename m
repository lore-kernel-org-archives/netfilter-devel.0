From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/9] netfilter: nf_conncount: don't skip eviction when age is negative
Date: Sat, 29 Dec 2018 13:57:57 +0100
Message-ID: <20181229125803.7415-4-pablo@netfilter.org>
References: <20181229125803.7415-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181229125803.7415-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

age is signed integer, so result can be negative when the timestamps
have a large delta.  In this case we want to discard the entry.

Instead of using age >= 2 || age < 0, just make it unsigned.

Fixes: b36e4523d4d56 ("netfilter: nf_conncount: fix garbage collection confirm race")
Reviewed-by: Shawn Bohrer <sbohrer@cloudflare.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3271a4e00500..8bb4ed85c262 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -155,7 +155,7 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	const struct nf_conntrack_tuple_hash *found;
 	unsigned long a, b;
 	int cpu = raw_smp_processor_id();
-	__s32 age;
+	u32 age;
 
 	found = nf_conntrack_find_get(net, &conn->zone, &conn->tuple);
 	if (found)
-- 
2.11.0
