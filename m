From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: nf_conntrack: use hlists for conntrack hash
Date: Wed, 27 Jun 2007 14:01:32 +0200
Message-ID: <4682519C.6070603@trash.net>
References: <46816369.4070407@trash.net>	<200706270703.l5R73LS6001509@toshiba.co.jp>
	<4682116B.70702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030600060105040608000902"
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4682116B.70702@trash.net>
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

This is a multi-part message in MIME format.
--------------030600060105040608000902
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Yasuyuki KOZAKAI wrote:
> 
>>> Convert conntrack hash to hlists to reduce its size and cache
>>> footprint. Since the default hashsize to max. entries ratio
>>> sucks (1:16), this patch doesn't reduce the amount of memory
>>> used for the hash by default, but instead uses a better ratio
>>> of 1:8, which results in the same max. entries value.
>>>     
>>
>>
>> What do you think the impact to nat hash table is ? nf_nat_htable_size
>> is set to nf_conntrack_htable_size at initialization.
>>
>> I think we can also replace list with hlist for nat hash and then
>> there is no problem.
>>   
> 
> 
> Sounds good, I'll look into that today.


I've added this patch to my tree. I'll push out a new git tree now.

--------------030600060105040608000902
Content-Type: text/x-diff;
 name="31.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="31.diff"

[NETFILTER]: nf_nat: use hlists for bysource hash

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 665d98d03473cab252830129f414e1b38fb2b038
tree c84b778490ffabf547f44b8dd859a7e6791df619
parent 507cd7e1b2b776e269309a7c8e3e51e15baf2a3a
author Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 13:57:47 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 13:57:47 +0200

 include/net/netfilter/nf_nat.h   |    2 +-
 net/ipv4/netfilter/nf_nat_core.c |   23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index d0e5e43..6ae52f7 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -66,7 +66,7 @@ struct nf_conn;
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat
 {
-	struct list_head bysource;
+	struct hlist_node bysource;
 	struct nf_nat_seq seq[IP_CT_DIR_MAX];
 	struct nf_conn *ct;
 	union nf_conntrack_nat_help help;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 04691ed..4348f61 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/skbuff.h>
-#include <linux/vmalloc.h>
 #include <net/checksum.h>
 #include <net/icmp.h>
 #include <net/ip.h>
@@ -44,8 +43,9 @@ static struct nf_conntrack_l3proto *l3proto = NULL;
 
 /* Calculated at init based on memory size */
 static unsigned int nf_nat_htable_size;
+static int nf_nat_vmalloced;
 
-static struct list_head *bysource;
+static struct hlist_head *bysource;
 
 #define MAX_IP_NAT_PROTO 256
 static struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
@@ -84,7 +84,7 @@ hash_by_src(const struct nf_conntrack_tuple *tuple)
 {
 	/* Original src, to ensure we map it consistently if poss. */
 	return jhash_3words((__force u32)tuple->src.u3.ip, tuple->src.u.all,
-			    tuple->dst.protonum, 0) % nf_nat_htable_size;
+			    tuple->dst.protonum, 0) & (nf_nat_htable_size - 1);
 }
 
 /* Is this tuple already taken? (not by us) */
@@ -153,9 +153,10 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 	unsigned int h = hash_by_src(tuple);
 	struct nf_conn_nat *nat;
 	struct nf_conn *ct;
+	struct hlist_node *n;
 
 	read_lock_bh(&nf_nat_lock);
-	list_for_each_entry(nat, &bysource[h], bysource) {
+	hlist_for_each_entry(nat, n, &bysource[h], bysource) {
 		ct = nat->ct;
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
@@ -336,7 +337,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
 		nat = nfct_nat(ct);
 		nat->ct = ct;
-		list_add(&nat->bysource, &bysource[srchash]);
+		hlist_add_head(&nat->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
 	}
 
@@ -600,7 +601,7 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 	NF_CT_ASSERT(nat->ct->status & IPS_NAT_DONE_MASK);
 
 	write_lock_bh(&nf_nat_lock);
-	list_del(&nat->bysource);
+	hlist_del(&nat->bysource);
 	nat->ct = NULL;
 	write_unlock_bh(&nf_nat_lock);
 }
@@ -618,7 +619,7 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	write_lock_bh(&nf_nat_lock);
-	list_replace(&old_nat->bysource, &new_nat->bysource);
+	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;
 	write_unlock_bh(&nf_nat_lock);
 }
@@ -646,8 +647,8 @@ static int __init nf_nat_init(void)
 	/* Leave them the same for the moment. */
 	nf_nat_htable_size = nf_conntrack_htable_size;
 
-	/* One vmalloc for both hash tables */
-	bysource = vmalloc(sizeof(struct list_head) * nf_nat_htable_size);
+	bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size,
+					 &nf_nat_vmalloced);
 	if (!bysource) {
 		ret = -ENOMEM;
 		goto cleanup_extend;
@@ -663,7 +664,7 @@ static int __init nf_nat_init(void)
 	write_unlock_bh(&nf_nat_lock);
 
 	for (i = 0; i < nf_nat_htable_size; i++) {
-		INIT_LIST_HEAD(&bysource[i]);
+		INIT_HLIST_HEAD(&bysource[i]);
 	}
 
 	/* Initialize fake conntrack so that NAT will skip it */
@@ -693,7 +694,7 @@ static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
 	synchronize_rcu();
-	vfree(bysource);
+	nf_ct_free_hashtable(bysource, nf_nat_htable_size, nf_nat_vmalloced);
 	nf_ct_l3proto_put(l3proto);
 	nf_ct_extend_unregister(&nat_extend);
 }

--------------030600060105040608000902--
