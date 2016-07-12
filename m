From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/2] netfilter: conntrack: simplify the code by using nf_conntrack_get_ht
Date: Tue, 12 Jul 2016 19:45:01 +0800
Message-ID: <1468323901-15767-2-git-send-email-zlpnobody@163.com>
References: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:60014 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbcGLLpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 07:45:47 -0400
In-Reply-To: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
nf_conntrack proc read and hash resize") introdue the
nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
again and again to get the hash table and hash size.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_conntrack_core.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2d46225..bafebf7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -461,7 +461,8 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 }
 
 /* must be called with rcu read lock held */
-void nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
+inline void
+nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
 {
 	struct hlist_nulls_head *hptr;
 	unsigned int sequence, hsz;
@@ -489,14 +490,11 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_head *ct_hash;
 	struct hlist_nulls_node *n;
-	unsigned int bucket, sequence;
+	unsigned int bucket, hsize;
 
 begin:
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		bucket = scale_hash(hash);
-		ct_hash = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+	nf_conntrack_get_ht(&ct_hash, &hsize);
+	bucket = reciprocal_scale(hash, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
 		if (nf_ct_key_equal(h, tuple, zone, net)) {
@@ -801,18 +799,15 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
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
@@ -878,14 +873,11 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 
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


