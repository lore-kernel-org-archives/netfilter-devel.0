From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: conntrack: use get_random_once for nat and expectations
Date: Mon, 18 Apr 2016 16:17:00 +0200
Message-ID: <1460989021-10780-3-git-send-email-fw@strlen.de>
References: <1460989021-10780-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48402 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbcDROQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 10:16:49 -0400
In-Reply-To: <1460989021-10780-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a private seed and init it using get_random_once.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_expect.c | 7 +++----
 net/netfilter/nf_nat_core.c         | 6 ++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 278927a..c2f7c4f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -38,6 +38,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
 unsigned int nf_ct_expect_max __read_mostly;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
+static unsigned int nf_ct_expect_hashrnd __read_mostly;
 
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
@@ -76,13 +77,11 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
 {
 	unsigned int hash;
 
-	if (unlikely(!nf_conntrack_hash_rnd)) {
-		init_nf_conntrack_hash_rnd();
-	}
+	get_random_once(&nf_ct_expect_hashrnd, sizeof(nf_ct_expect_hashrnd));
 
 	hash = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
 		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
-		       (__force __u16)tuple->dst.u.all) ^ nf_conntrack_hash_rnd);
+		       (__force __u16)tuple->dst.u.all) ^ nf_ct_expect_hashrnd);
 
 	return reciprocal_scale(hash, nf_ct_expect_hsize);
 }
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 06a9f45..3d52271 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -37,7 +37,7 @@ static const struct nf_nat_l3proto __rcu *nf_nat_l3protos[NFPROTO_NUMPROTO]
 						__read_mostly;
 static const struct nf_nat_l4proto __rcu **nf_nat_l4protos[NFPROTO_NUMPROTO]
 						__read_mostly;
-
+static unsigned int nf_nat_hash_rnd __read_mostly;
 
 inline const struct nf_nat_l3proto *
 __nf_nat_l3proto_find(u8 family)
@@ -122,9 +122,11 @@ hash_by_src(const struct net *net, const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 
+	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));
+
 	/* Original src, to ensure we map it consistently if poss. */
 	hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
-		      tuple->dst.protonum ^ nf_conntrack_hash_rnd);
+		      tuple->dst.protonum ^ nf_nat_hash_rnd);
 
 	return reciprocal_scale(hash, net->ct.nat_htable_size);
 }
-- 
2.7.3

