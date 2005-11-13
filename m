From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/4] use auxiliary functions in nf_ct_reasm
Date: Sun, 13 Nov 2005 17:51:04 +0900 (JST)
Message-ID: <200511130851.jAD8p5Uw012057@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Nov_13_17_51_04_2005_247)--"
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

----Next_Part(Sun_Nov_13_17_51_04_2005_247)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This replaces old codes with spin_lock_init(), DEFINE_RWLOCK(), and
ipv6_addr_equal().

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sun_Nov_13_17_51_04_2005_247)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="05-nfct-reasm-sync.patch"

[NETFILTER] use auxiliary functions in nf_ct_reasm

This replaces old codes with spin_lock_init(), DEFINE_RWLOCK(), and
ipv6_addr_equal().

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 9860fe99d5cc088973ef8108747cf46f583637be
tree e4db8cf3b53a60bed66c8afcb2e49d37f1cb922d
parent 7f3c8051c47ebe6260a6c6159bcb2feae10c9dcc
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 16:18:51 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 16:18:51 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5556a19..99b0e13 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -97,7 +97,7 @@ struct nf_ct_frag6_queue
 #define FRAG6Q_HASHSZ	64
 
 static struct hlist_head nf_ct_frag6_hash[FRAG6Q_HASHSZ];
-static rwlock_t nf_ct_frag6_lock = RW_LOCK_UNLOCKED;
+static DEFINE_RWLOCK(nf_ct_frag6_lock);
 static u32 nf_ct_frag6_hash_rnd;
 static LIST_HEAD(nf_ct_frag6_lru_list);
 int nf_ct_frag6_nqueues = 0;
@@ -308,8 +308,8 @@ static struct nf_ct_frag6_queue *nf_ct_f
 #ifdef CONFIG_SMP
 	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == fq_in->id && 
-		    !ipv6_addr_cmp(&fq_in->saddr, &fq->saddr) &&
-		    !ipv6_addr_cmp(&fq_in->daddr, &fq->daddr)) {
+		    ipv6_addr_equal(&fq_in->saddr, &fq->saddr) &&
+		    ipv6_addr_equal(&fq_in->daddr, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			write_unlock(&nf_ct_frag6_lock);
 			fq_in->last_in |= COMPLETE;
@@ -352,7 +352,7 @@ nf_ct_frag6_create(unsigned int hash, u3
 	init_timer(&fq->timer);
 	fq->timer.function = nf_ct_frag6_expire;
 	fq->timer.data = (long) fq;
-	fq->lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&fq->lock);
 	atomic_set(&fq->refcnt, 1);
 
 	return nf_ct_frag6_intern(hash, fq);
@@ -371,8 +371,8 @@ fq_find(u32 id, struct in6_addr *src, st
 	read_lock(&nf_ct_frag6_lock);
 	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == id && 
-		    !ipv6_addr_cmp(src, &fq->saddr) &&
-		    !ipv6_addr_cmp(dst, &fq->daddr)) {
+		    ipv6_addr_equal(src, &fq->saddr) &&
+		    ipv6_addr_equal(dst, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			read_unlock(&nf_ct_frag6_lock);
 			return fq;

----Next_Part(Sun_Nov_13_17_51_04_2005_247)----
