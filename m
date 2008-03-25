From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:25 +0100
Message-ID: <1206468391-368-23-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-19-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-20-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-21-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-22-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52562 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300AbYCYSGj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:39 -0400
In-Reply-To: <1206468391-368-22-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: Use bool in nf_conntrack_tuple.h
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack.h       |   11 +++---
 include/net/netfilter/nf_conntrack_core.h  |    4 +-
 include/net/netfilter/nf_conntrack_tuple.h |   39 +++++++++++---------
 net/netfilter/nf_conntrack_core.c          |   22 +++++------
 4 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a3567a7..d619458 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -189,12 +189,11 @@ extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
 extern void nf_conntrack_flush(void);
 
-extern int nf_ct_get_tuplepr(const struct sk_buff *skb,
-			     unsigned int nhoff,
-			     u_int16_t l3num,
-			     struct nf_conntrack_tuple *tuple);
-extern int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
-				const struct nf_conntrack_tuple *orig);
+extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
+                              unsigned int nhoff, u_int16_t l3num,
+                              struct nf_conntrack_tuple *tuple);
+extern bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
+                                 const struct nf_conntrack_tuple *orig);
 
 extern void __nf_ct_refresh_acct(struct nf_conn *ct,
 				 enum ip_conntrack_info ctinfo,
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 74d7a01..2f1a551 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -30,7 +30,7 @@ extern void nf_conntrack_cleanup(void);
 extern int nf_conntrack_proto_init(void);
 extern void nf_conntrack_proto_fini(void);
 
-extern int
+extern bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
 		unsigned int dataoff,
@@ -40,7 +40,7 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		const struct nf_conntrack_l3proto *l3proto,
 		const struct nf_conntrack_l4proto *l4proto);
 
-extern int
+extern bool
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_l3proto *l3proto,
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 168c917..2c7e115 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -160,61 +160,64 @@ struct nf_conntrack_tuple_hash
 
 #endif /* __KERNEL__ */
 
-static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
-					  const struct nf_conntrack_tuple *t2)
+static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
+                                           const struct nf_conntrack_tuple *t2)
 { 
 	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
 		t1->src.u.all == t2->src.u.all &&
 		t1->src.l3num == t2->src.l3num);
 }
 
-static inline int __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
-					  const struct nf_conntrack_tuple *t2)
+static inline bool __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
+                                           const struct nf_conntrack_tuple *t2)
 {
 	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
 		t1->dst.u.all == t2->dst.u.all &&
 		t1->dst.protonum == t2->dst.protonum);
 }
 
-static inline int nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
-				    const struct nf_conntrack_tuple *t2)
+static inline bool nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
+                                     const struct nf_conntrack_tuple *t2)
 {
 	return __nf_ct_tuple_src_equal(t1, t2) &&
 	       __nf_ct_tuple_dst_equal(t1, t2);
 }
 
-static inline int nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
-					 const struct nf_conntrack_tuple_mask *m2)
+static inline bool
+nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
+                       const struct nf_conntrack_tuple_mask *m2)
 {
 	return (nf_inet_addr_cmp(&m1->src.u3, &m2->src.u3) &&
 		m1->src.u.all == m2->src.u.all);
 }
 
-static inline int nf_ct_tuple_src_mask_cmp(const struct nf_conntrack_tuple *t1,
-					   const struct nf_conntrack_tuple *t2,
-					   const struct nf_conntrack_tuple_mask *mask)
+static inline bool
+nf_ct_tuple_src_mask_cmp(const struct nf_conntrack_tuple *t1,
+                         const struct nf_conntrack_tuple *t2,
+                         const struct nf_conntrack_tuple_mask *mask)
 {
 	int count;
 
 	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++) {
 		if ((t1->src.u3.all[count] ^ t2->src.u3.all[count]) &
 		    mask->src.u3.all[count])
-			return 0;
+			return false;
 	}
 
 	if ((t1->src.u.all ^ t2->src.u.all) & mask->src.u.all)
-		return 0;
+		return false;
 
 	if (t1->src.l3num != t2->src.l3num ||
 	    t1->dst.protonum != t2->dst.protonum)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
-static inline int nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
-				       const struct nf_conntrack_tuple *tuple,
-				       const struct nf_conntrack_tuple_mask *mask)
+static inline bool
+nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
+                     const struct nf_conntrack_tuple *tuple,
+                     const struct nf_conntrack_tuple_mask *mask)
 {
 	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
 	       __nf_ct_tuple_dst_equal(t, tuple);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2c4eaff..b7ba7af 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -94,7 +94,7 @@ static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
 				nf_conntrack_hash_rnd);
 }
 
-int
+bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
 		unsigned int dataoff,
@@ -108,7 +108,7 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 
 	tuple->src.l3num = l3num;
 	if (l3proto->pkt_to_tuple(skb, nhoff, tuple) == 0)
-		return 0;
+		return false;
 
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
@@ -117,10 +117,8 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuple);
 
-int nf_ct_get_tuplepr(const struct sk_buff *skb,
-		      unsigned int nhoff,
-		      u_int16_t l3num,
-		      struct nf_conntrack_tuple *tuple)
+bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
+                       u_int16_t l3num, struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
@@ -134,7 +132,7 @@ int nf_ct_get_tuplepr(const struct sk_buff *skb,
 	ret = l3proto->get_l4proto(skb, nhoff, &protoff, &protonum);
 	if (ret != NF_ACCEPT) {
 		rcu_read_unlock();
-		return 0;
+		return false;
 	}
 
 	l4proto = __nf_ct_l4proto_find(l3num, protonum);
@@ -147,7 +145,7 @@ int nf_ct_get_tuplepr(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuplepr);
 
-int
+bool
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
 		   const struct nf_conntrack_l3proto *l3proto,
@@ -157,7 +155,7 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 	inverse->src.l3num = orig->src.l3num;
 	if (l3proto->invert_tuple(inverse, orig) == 0)
-		return 0;
+		return false;
 
 	inverse->dst.dir = !orig->dst.dir;
 
@@ -739,10 +737,10 @@ nf_conntrack_in(unsigned int pf, unsigned int hooknum, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_in);
 
-int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
-			 const struct nf_conntrack_tuple *orig)
+bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
+                          const struct nf_conntrack_tuple *orig)
 {
-	int ret;
+	bool ret;
 
 	rcu_read_lock();
 	ret = nf_ct_invert_tuple(inverse, orig,
