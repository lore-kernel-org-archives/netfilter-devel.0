From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2] nf_conntrack: replace handmade list with hlist in IPv6
 reassembly
Date: Thu, 05 Jan 2006 16:40:28 +0900 (JST)
Message-ID: <200601050740.k057eTU2022650@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
Content-Disposition: inline; filename="03-nfct-reasm-hlist.patch"
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

[NETFILTER] nf_conntrack: replace handmade list with hlist in IPv6 reassembly

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 6bf90f969545fbd9467d42b0bd823bef4059506a
tree bdcd48f9387eeefca62bf3b5f304a2d6228c6638
parent 629a7391cc095248a79153f37977ce9f1071c14d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 25 Dec 2005 19:56:20 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 05 Jan 2006 15:25:33 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |   45 +++++++++++--------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index ab3387d..3e31903 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -70,8 +70,8 @@ struct nf_ct_frag6_skb_cb
 
 struct nf_ct_frag6_queue
 {
-	struct nf_ct_frag6_queue	*next;
-	struct list_head lru_list;		/* lru list member	*/
+	struct hlist_node	list;
+	struct list_head	lru_list;	/* lru list member	*/
 
 	__u32			id;		/* fragment id		*/
 	struct in6_addr		saddr;
@@ -90,14 +90,13 @@ struct nf_ct_frag6_queue
 #define FIRST_IN		2
 #define LAST_IN			1
 	__u16			nhoffset;
-	struct nf_ct_frag6_queue	**pprev;
 };
 
 /* Hash table. */
 
 #define FRAG6Q_HASHSZ	64
 
-static struct nf_ct_frag6_queue *nf_ct_frag6_hash[FRAG6Q_HASHSZ];
+static struct hlist_head nf_ct_frag6_hash[FRAG6Q_HASHSZ];
 static DEFINE_RWLOCK(nf_ct_frag6_lock);
 static u32 nf_ct_frag6_hash_rnd;
 static LIST_HEAD(nf_ct_frag6_lru_list);
@@ -105,9 +104,7 @@ int nf_ct_frag6_nqueues = 0;
 
 static __inline__ void __fq_unlink(struct nf_ct_frag6_queue *fq)
 {
-	if (fq->next)
-		fq->next->pprev = fq->pprev;
-	*fq->pprev = fq->next;
+	hlist_del(&fq->list);
 	list_del(&fq->lru_list);
 	nf_ct_frag6_nqueues--;
 }
@@ -158,28 +155,18 @@ static void nf_ct_frag6_secret_rebuild(u
 	get_random_bytes(&nf_ct_frag6_hash_rnd, sizeof(u32));
 	for (i = 0; i < FRAG6Q_HASHSZ; i++) {
 		struct nf_ct_frag6_queue *q;
+		struct hlist_node *p, *n;
 
-		q = nf_ct_frag6_hash[i];
-		while (q) {
-			struct nf_ct_frag6_queue *next = q->next;
+		hlist_for_each_entry_safe(q, p, n, &nf_ct_frag6_hash[i], list) {
 			unsigned int hval = ip6qhashfn(q->id,
 						       &q->saddr,
 						       &q->daddr);
-
 			if (hval != i) {
-				/* Unlink. */
-				if (q->next)
-					q->next->pprev = q->pprev;
-				*q->pprev = q->next;
-
+				hlist_del(&q->list);
 				/* Relink to new hash chain. */
-				if ((q->next = nf_ct_frag6_hash[hval]) != NULL)
-					q->next->pprev = &q->next;
-				nf_ct_frag6_hash[hval] = q;
-				q->pprev = &nf_ct_frag6_hash[hval];
+				hlist_add_head(&q->list,
+					       &nf_ct_frag6_hash[hval]);
 			}
-
-			q = next;
 		}
 	}
 	write_unlock(&nf_ct_frag6_lock);
@@ -314,15 +301,17 @@ out:
 
 /* Creation primitives. */
 
-
 static struct nf_ct_frag6_queue *nf_ct_frag6_intern(unsigned int hash,
 					  struct nf_ct_frag6_queue *fq_in)
 {
 	struct nf_ct_frag6_queue *fq;
+#ifdef CONFIG_SMP
+	struct hlist_node *n;
+#endif
 
 	write_lock(&nf_ct_frag6_lock);
 #ifdef CONFIG_SMP
-	for (fq = nf_ct_frag6_hash[hash]; fq; fq = fq->next) {
+	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == fq_in->id && 
 		    ipv6_addr_equal(&fq_in->saddr, &fq->saddr) &&
 		    ipv6_addr_equal(&fq_in->daddr, &fq->daddr)) {
@@ -340,10 +329,7 @@ static struct nf_ct_frag6_queue *nf_ct_f
 		atomic_inc(&fq->refcnt);
 
 	atomic_inc(&fq->refcnt);
-	if ((fq->next = nf_ct_frag6_hash[hash]) != NULL)
-		fq->next->pprev = &fq->next;
-	nf_ct_frag6_hash[hash] = fq;
-	fq->pprev = &nf_ct_frag6_hash[hash];
+	hlist_add_head(&fq->list, &nf_ct_frag6_hash[hash]);
 	INIT_LIST_HEAD(&fq->lru_list);
 	list_add_tail(&fq->lru_list, &nf_ct_frag6_lru_list);
 	nf_ct_frag6_nqueues++;
@@ -384,10 +370,11 @@ static __inline__ struct nf_ct_frag6_que
 fq_find(u32 id, struct in6_addr *src, struct in6_addr *dst)
 {
 	struct nf_ct_frag6_queue *fq;
+	struct hlist_node *n;
 	unsigned int hash = ip6qhashfn(id, src, dst);
 
 	read_lock(&nf_ct_frag6_lock);
-	for (fq = nf_ct_frag6_hash[hash]; fq; fq = fq->next) {
+	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == id && 
 		    ipv6_addr_equal(src, &fq->saddr) &&
 		    ipv6_addr_equal(dst, &fq->daddr)) {
