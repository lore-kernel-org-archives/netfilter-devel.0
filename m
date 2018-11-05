From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/14] netfilter: conntrack: fix calculation of next bucket number in early_drop
Date: Tue,  6 Nov 2018 00:28:32 +0100
Message-ID: <20181105232832.21896-15-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Vasily Khoruzhick <vasilykh@arista.com>

If there's no entry to drop in bucket that corresponds to the hash,
early_drop() should look for it in other buckets. But since it increments
hash instead of bucket number, it actually looks in the same bucket 8
times: hsize is 16k by default (14 bits) and hash is 32-bit value, so
reciprocal_scale(hash, hsize) returns the same value for hash..hash+7 in
most cases.

Fix it by increasing bucket number instead of hash and rename _hash
to bucket to avoid future confusion.

Fixes: 3e86638e9a0b ("netfilter: conntrack: consider ct netns in early_drop logic")
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Vasily Khoruzhick <vasilykh@arista.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ca1168d67fac..e92e749aff53 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1073,19 +1073,22 @@ static unsigned int early_drop_list(struct net *net,
 	return drops;
 }
 
-static noinline int early_drop(struct net *net, unsigned int _hash)
+static noinline int early_drop(struct net *net, unsigned int hash)
 {
-	unsigned int i;
+	unsigned int i, bucket;
 
 	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
 		struct hlist_nulls_head *ct_hash;
-		unsigned int hash, hsize, drops;
+		unsigned int hsize, drops;
 
 		rcu_read_lock();
 		nf_conntrack_get_ht(&ct_hash, &hsize);
-		hash = reciprocal_scale(_hash++, hsize);
+		if (!i)
+			bucket = reciprocal_scale(hash, hsize);
+		else
+			bucket = (bucket + 1) % hsize;
 
-		drops = early_drop_list(net, &ct_hash[hash]);
+		drops = early_drop_list(net, &ct_hash[bucket]);
 		rcu_read_unlock();
 
 		if (drops) {
-- 
2.11.0
