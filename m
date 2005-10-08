From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/4] change the random value on resizing hash
Date: Sat, 08 Oct 2005 20:09:41 +0900 (JST)
Message-ID: <200510081109.j98B9gQU023437@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct__8_20_09_41_2005_789)--"
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

----Next_Part(Sat_Oct__8_20_09_41_2005_789)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This synchronizes nf_conntrack with ip_conntrack and re-seeds the random
value for hashing when the hash size of conntrack is changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Oct__8_20_09_41_2005_789)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-change-random.patch"

[NETFILTER] change the random value on resizing hash in nf_conntrack

This synchronizes nf_conntrack with ip_conntrack and re-seeds the random
value for hashing when the hash size of conntrack is changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit eb6b86e4268d54fc5a5ef430e5391f1413b84784
tree 564b2ab6b6046223b24ea3237c0f0dab3952e558
parent c1928ab8b9055013bf7e90fca007525bd58a876c
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:23:10 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:23:10 +0900

 net/netfilter/nf_conntrack_core.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -203,7 +203,7 @@ static int nf_conntrack_hash_rnd_initted
 static unsigned int nf_conntrack_hash_rnd;
 
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
-				  unsigned int size)
+				  unsigned int size, unsigned int rnd)
 {
 	unsigned int a, b;
 	a = jhash((void *)tuple->src.u3.all, sizeof(tuple->src.u3.all),
@@ -211,12 +211,13 @@ static u_int32_t __hash_conntrack(const 
 	b = jhash((void *)tuple->dst.u3.all, sizeof(tuple->dst.u3.all),
 			(tuple->src.u.all << 16) | tuple->dst.u.all);
 
-	return jhash_2words(a, b, nf_conntrack_hash_rnd) % size;
+	return jhash_2words(a, b, rnd) % size;
 }
 
 static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
 {
-	return __hash_conntrack(tuple, nf_conntrack_htable_size);
+	return __hash_conntrack(tuple, nf_conntrack_htable_size,
+				nf_conntrack_hash_rnd);
 }
 
 /* Initialize "struct nf_conn" which has spaces for helper */
@@ -1427,6 +1428,7 @@ int set_hashsize(const char *val, struct
 {
 	int i, bucket, hashsize, vmalloced;
 	int old_vmalloced, old_size;
+	int rnd;
 	struct list_head *hash, *old_hash;
 	struct nf_conntrack_tuple_hash *h;
 
@@ -1442,13 +1444,17 @@ int set_hashsize(const char *val, struct
 	if (!hash)
 		return -ENOMEM;
 
+	/* We have to rehash for the new table anyway, so we also can
+	 * use a new random seed */
+	get_random_bytes(&rnd, 4);
+
 	write_lock_bh(&nf_conntrack_lock);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
 		while (!list_empty(&nf_conntrack_hash[i])) {
 			h = list_entry(nf_conntrack_hash[i].next,
 				       struct nf_conntrack_tuple_hash, list);
 			list_del(&h->list);
-			bucket = __hash_conntrack(&h->tuple, hashsize);
+			bucket = __hash_conntrack(&h->tuple, hashsize, rnd);
 			list_add_tail(&h->list, &hash[bucket]);
 		}
 	}
@@ -1459,6 +1465,7 @@ int set_hashsize(const char *val, struct
 	nf_conntrack_htable_size = hashsize;
 	nf_conntrack_vmalloc = vmalloced;
 	nf_conntrack_hash = hash;
+	nf_conntrack_hash_rnd = rnd;
 	write_unlock_bh(&nf_conntrack_lock);
 
 	free_conntrack_hash(old_hash, old_vmalloced, old_size);

----Next_Part(Sat_Oct__8_20_09_41_2005_789)----
