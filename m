From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 4/4] fix possibility of infinite loop while evicting frag
 queue
Date: Sun, 13 Nov 2005 17:52:02 +0900 (JST)
Message-ID: <200511130852.jAD8q31N026649@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_52_02_2005_958)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Sun_Nov_13_17_52_02_2005_958)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This synchronizes nf_ct_reasm with ipv6 reassembly, and fixes possibility of
infinite loop if CPUs evict and create nf_ct_frag6_queue in parallel.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sun_Nov_13_17_52_02_2005_958)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="06-nfct-reasm-evictor.patch"

[NETFILTER] fix possibility of infinite loop while evicting nf_ct_frag6_queue

This synchronizes nf_ct_reasm with ipv6 reassembly, and fixes possibility of
infinite loop if CPUs evict and create nf_ct_frag6_queue in parallel.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f52909251ea9c78b0d35d9ae265023ef67559b6a
tree 9498f0e638a14a678b326efb770b07cdb97467bb
parent 9860fe99d5cc088973ef8108747cf46f583637be
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 16:33:37 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 16:33:37 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |   42 +++++++++++++++++++------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 99b0e13..fcc9391 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -177,8 +177,10 @@ static void nf_ct_frag6_secret_rebuild(u
 atomic_t nf_ct_frag6_mem = ATOMIC_INIT(0);
 
 /* Memory Tracking Functions. */
-static inline void frag_kfree_skb(struct sk_buff *skb)
+static inline void frag_kfree_skb(struct sk_buff *skb, unsigned int *work)
 {
+	if (work)
+		*work -= skb->truesize;
 	atomic_sub(skb->truesize, &nf_ct_frag6_mem);
 	if (NFCT_FRAG6_CB(skb)->orig)
 		kfree_skb(NFCT_FRAG6_CB(skb)->orig);
@@ -186,8 +188,11 @@ static inline void frag_kfree_skb(struct
 	kfree_skb(skb);
 }
 
-static inline void frag_free_queue(struct nf_ct_frag6_queue *fq)
+static inline void frag_free_queue(struct nf_ct_frag6_queue *fq,
+				   unsigned int *work)
 {
+	if (work)
+		*work -= sizeof(struct nf_ct_frag6_queue);
 	atomic_sub(sizeof(struct nf_ct_frag6_queue), &nf_ct_frag6_mem);
 	kfree(fq);
 }
@@ -205,7 +210,8 @@ static inline struct nf_ct_frag6_queue *
 /* Destruction primitives. */
 
 /* Complete destruction of fq. */
-static void nf_ct_frag6_destroy(struct nf_ct_frag6_queue *fq)
+static void nf_ct_frag6_destroy(struct nf_ct_frag6_queue *fq,
+				unsigned int *work)
 {
 	struct sk_buff *fp;
 
@@ -217,17 +223,17 @@ static void nf_ct_frag6_destroy(struct n
 	while (fp) {
 		struct sk_buff *xp = fp->next;
 
-		frag_kfree_skb(fp);
+		frag_kfree_skb(fp, work);
 		fp = xp;
 	}
 
-	frag_free_queue(fq);
+	frag_free_queue(fq, work);
 }
 
-static __inline__ void fq_put(struct nf_ct_frag6_queue *fq)
+static __inline__ void fq_put(struct nf_ct_frag6_queue *fq, unsigned int *work)
 {
 	if (atomic_dec_and_test(&fq->refcnt))
-		nf_ct_frag6_destroy(fq);
+		nf_ct_frag6_destroy(fq, work);
 }
 
 /* Kill fq entry. It is not destroyed immediately,
@@ -249,10 +255,14 @@ static void nf_ct_frag6_evictor(void)
 {
 	struct nf_ct_frag6_queue *fq;
 	struct list_head *tmp;
+	unsigned int work;
 
-	for (;;) {
-		if (atomic_read(&nf_ct_frag6_mem) <= nf_ct_frag6_low_thresh)
-			return;
+	work = atomic_read(&nf_ct_frag6_mem);
+	if (work <= nf_ct_frag6_low_thresh)
+		return;
+
+	work -= nf_ct_frag6_low_thresh;
+	while (work > 0) {
 		read_lock(&nf_ct_frag6_lock);
 		if (list_empty(&nf_ct_frag6_lru_list)) {
 			read_unlock(&nf_ct_frag6_lock);
@@ -274,7 +284,7 @@ static void nf_ct_frag6_evictor(void)
 			fq_kill(fq);
 		spin_unlock(&fq->lock);
 
-		fq_put(fq);
+		fq_put(fq, &work);
 	}
 }
 
@@ -291,7 +301,7 @@ static void nf_ct_frag6_expire(unsigned 
 
 out:
 	spin_unlock(&fq->lock);
-	fq_put(fq);
+	fq_put(fq, NULL);
 }
 
 /* Creation primitives. */
@@ -313,7 +323,7 @@ static struct nf_ct_frag6_queue *nf_ct_f
 			atomic_inc(&fq->refcnt);
 			write_unlock(&nf_ct_frag6_lock);
 			fq_in->last_in |= COMPLETE;
-			fq_put(fq_in);
+			fq_put(fq_in, NULL);
 			return fq;
 		}
 	}
@@ -528,7 +538,7 @@ static int nf_ct_frag6_queue(struct nf_c
 				fq->fragments = next;
 
 			fq->meat -= free_it->len;
-			frag_kfree_skb(free_it);
+			frag_kfree_skb(free_it, NULL);
 		}
 	}
 
@@ -804,7 +814,7 @@ struct sk_buff *nf_ct_frag6_gather(struc
 	if (nf_ct_frag6_queue(fq, clone, fhdr, nhoff) < 0) {
 		spin_unlock(&fq->lock);
 		DEBUGP("Can't insert skb to queue\n");
-		fq_put(fq);
+		fq_put(fq, NULL);
 		goto ret_orig;
 	}
 
@@ -815,7 +825,7 @@ struct sk_buff *nf_ct_frag6_gather(struc
 	}
 	spin_unlock(&fq->lock);
 
-	fq_put(fq);
+	fq_put(fq, NULL);
 	return ret_skb;
 
 ret_orig:

----Next_Part(Sun_Nov_13_17_52_02_2005_958)----
