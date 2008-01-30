From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 41/69]: nf_conntrack: avoid duplicate protocol comparison in nf_ct_tuple_equal()
Date: Wed, 30 Jan 2008 21:17:58 +0100 (MET)
Message-ID: <20080130201755.29874.30014.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbYA3UR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:58 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: avoid duplicate protocol comparison in nf_ct_tuple_equal()

nf_ct_tuple_src_equal() and nf_ct_tuple_dst_equal() both compare the protocol
numbers. Unfortunately gcc doesn't optimize out the second comparison, so
remove it and prefix both functions with __ to indicate that they should not
be used directly.

Saves another 16 byte of text in __nf_conntrack_find() on x86_64:

  nf_conntrack_tuple_taken |  -20 # 320 -> 300, size inlines: 181 -> 161
  __nf_conntrack_find      |  -16 # 267 -> 251, size inlines: 127 -> 115
  __nf_conntrack_confirm   |  -40 # 875 -> 835, size inlines: 570 -> 537
 3 functions changed, 76 bytes removed

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 18fd2bf273954b4fa527e5d630049f40acc29fca
tree f2b287d7b240777464be03524e99b18cd3e4e497
parent 419fd8e88eba9f4c35fd1bdc27aaa22578f202fb
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:14 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100

 include/net/netfilter/nf_conntrack_tuple.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 45cb17c..e69ab2e 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -132,34 +132,33 @@ struct nf_conntrack_tuple_hash
 
 #endif /* __KERNEL__ */
 
-static inline int nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
-				        const struct nf_conntrack_tuple *t2)
+static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
+					  const struct nf_conntrack_tuple *t2)
 { 
 	return (t1->src.u3.all[0] == t2->src.u3.all[0] &&
 		t1->src.u3.all[1] == t2->src.u3.all[1] &&
 		t1->src.u3.all[2] == t2->src.u3.all[2] &&
 		t1->src.u3.all[3] == t2->src.u3.all[3] &&
 		t1->src.u.all == t2->src.u.all &&
-		t1->src.l3num == t2->src.l3num &&
-		t1->dst.protonum == t2->dst.protonum);
+		t1->src.l3num == t2->src.l3num);
 }
 
-static inline int nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
-				        const struct nf_conntrack_tuple *t2)
+static inline int __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
+					  const struct nf_conntrack_tuple *t2)
 {
 	return (t1->dst.u3.all[0] == t2->dst.u3.all[0] &&
 		t1->dst.u3.all[1] == t2->dst.u3.all[1] &&
 		t1->dst.u3.all[2] == t2->dst.u3.all[2] &&
 		t1->dst.u3.all[3] == t2->dst.u3.all[3] &&
 		t1->dst.u.all == t2->dst.u.all &&
-		t1->src.l3num == t2->src.l3num &&
 		t1->dst.protonum == t2->dst.protonum);
 }
 
 static inline int nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
 				    const struct nf_conntrack_tuple *t2)
 {
-	return nf_ct_tuple_src_equal(t1, t2) && nf_ct_tuple_dst_equal(t1, t2);
+	return __nf_ct_tuple_src_equal(t1, t2) &&
+	       __nf_ct_tuple_dst_equal(t1, t2);
 }
 
 static inline int nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
@@ -199,7 +198,7 @@ static inline int nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
 				       const struct nf_conntrack_tuple_mask *mask)
 {
 	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
-	       nf_ct_tuple_dst_equal(t, tuple);
+	       __nf_ct_tuple_dst_equal(t, tuple);
 }
 
 #endif /* _NF_CONNTRACK_TUPLE_H */
