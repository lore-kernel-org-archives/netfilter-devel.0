From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next V2] netfilter: conntrack: simplify the code by using nf_conntrack_get_ht
Date: Sat, 30 Jul 2016 19:42:53 +0800
Message-ID: <1469878973-15201-1-git-send-email-zlpnobody@163.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:36151 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbcG3Lnh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2016 07:43:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
nf_conntrack proc read and hash resize") introdue the
nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
again and again to get the hash table and hash size.

But keep ____nf_conntrack_find unchanged, because it is performance
critical path, increase the overhead of the function call is not so
good.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V2: remove "inline void" declared to nf_conntrack_get_ht, and keep
     ____nf_conntrack_find unchanged suggested by Florian.

 net/netfilter/nf_conntrack_core.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2d46225..23c6db0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -801,18 +801,15 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	const struct nf_conntrack_zone *zone;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_head *ct_hash;
-	unsigned int hash, sequence;
+	unsigned int hash, hsize;
 	struct hlist_nulls_node *n;
 	struct nf_conn *ct;
 
 	zone = nf_ct_zone(ignored_conntrack);
 
 	rcu_read_lock();
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		hash = hash_conntrack(net, tuple);
-		ct_hash = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+	nf_conntrack_get_ht(&ct_hash, &hsize);
+	hash = __hash_conntrack(net, tuple, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[hash], hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
@@ -878,14 +875,11 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 
 	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
 		struct hlist_nulls_head *ct_hash;
-		unsigned hash, sequence, drops;
+		unsigned int hash, hsize, drops;
 
 		rcu_read_lock();
-		do {
-			sequence = read_seqcount_begin(&nf_conntrack_generation);
-			hash = scale_hash(_hash++);
-			ct_hash = nf_conntrack_hash;
-		} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+		nf_conntrack_get_ht(&ct_hash, &hsize);
+		hash = reciprocal_scale(_hash++, hsize);
 
 		drops = early_drop_list(net, &ct_hash[hash]);
 		rcu_read_unlock();
-- 
2.5.5


