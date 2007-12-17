From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 63/64]: non-power-of-two jhash optimizations
Date: Tue, 18 Dec 2007 00:47:39 +0100 (MET)
Message-ID: <20071217234738.23601.44693.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbXLQXrk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:40 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: non-power-of-two jhash optimizations

Apply Eric Dumazet's jhash optimizations where applicable. Quoting Eric:

Thanks to jhash, hash value uses full 32 bits. Instead of returning
hash % size (implying a divide) we return the high 32 bits of the
(hash * size) that will give results between [0 and size-1] and same
hash distribution.

On most cpus, a multiply is less expensive than a divide, by an order
of magnitude.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e5dc0b8b87651227dc92fa1365ab3e9707f9898e
tree f888429a2ffbb20f348d8c8bf0b2602647983c49
parent 0a5d984db399c3f71a657b3bbe13904a359bf614
author Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c  |    2 +-
 net/ipv4/netfilter/nf_nat_core.c    |   10 +++++++---
 net/netfilter/nf_conntrack_core.c   |    2 +-
 net/netfilter/nf_conntrack_expect.c |    8 +++++---
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index a48e264..df39ca0 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -273,7 +273,7 @@ clusterip_hashfn(const struct sk_buff *skb,
 	}
 
 	/* node numbers are 1..n, not 0..n */
-	return (hashval % config->num_total_nodes) + 1;
+	return (((u64)hashval * config->num_total_nodes) >> 32) + 1;
 }
 
 static inline int
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index aec157d..e53ae1e 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -77,10 +77,13 @@ EXPORT_SYMBOL_GPL(nf_nat_proto_put);
 static inline unsigned int
 hash_by_src(const struct nf_conntrack_tuple *tuple)
 {
+	unsigned int hash;
+
 	/* Original src, to ensure we map it consistently if poss. */
-	return jhash_3words((__force u32)tuple->src.u3.ip,
+	hash = jhash_3words((__force u32)tuple->src.u3.ip,
 			    (__force u32)tuple->src.u.all,
-			    tuple->dst.protonum, 0) % nf_nat_htable_size;
+			    tuple->dst.protonum, 0);
+	return ((u64)hash * nf_nat_htable_size) >> 32;
 }
 
 /* Is this tuple already taken? (not by us) */
@@ -211,7 +214,8 @@ find_best_ips_proto(struct nf_conntrack_tuple *tuple,
 	maxip = ntohl(range->max_ip);
 	j = jhash_2words((__force u32)tuple->src.u3.ip,
 			 (__force u32)tuple->dst.u3.ip, 0);
-	*var_ipp = htonl(minip + j % (maxip - minip + 1));
+	j = ((u64)j * (maxip - minip + 1)) >> 32;
+	*var_ipp = htonl(minip + j);
 }
 
 /* Manipulate the tuple into the range given.  For NF_INET_POST_ROUTING,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b63b09a..b155c8f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -81,7 +81,7 @@ static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 		   ((__force __u16)tuple->src.u.all << 16) |
 		    (__force __u16)tuple->dst.u.all);
 
-	return jhash_2words(a, b, rnd) % size;
+	return ((u64)jhash_2words(a, b, rnd) * size) >> 32;
 }
 
 static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 0efbf34..e0cd9d0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -73,15 +73,17 @@ static void nf_ct_expectation_timed_out(unsigned long ul_expect)
 
 static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple)
 {
+	unsigned int hash;
+
 	if (unlikely(!nf_ct_expect_hash_rnd_initted)) {
 		get_random_bytes(&nf_ct_expect_hash_rnd, 4);
 		nf_ct_expect_hash_rnd_initted = 1;
 	}
 
-	return jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
+	hash = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
 		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
-		       (__force __u16)tuple->dst.u.all) ^ nf_ct_expect_hash_rnd) %
-	       nf_ct_expect_hsize;
+		       (__force __u16)tuple->dst.u.all) ^ nf_ct_expect_hash_rnd);
+	return ((u64)hash * nf_ct_expect_hsize) >> 32;
 }
 
 struct nf_conntrack_expect *
