From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Wed, 27 Jun 2007 14:04:15 +0200
Message-ID: <4682523F.6000002@trash.net>
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050005060903000103060406"
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759341AbXF0MEy@vger.kernel.org>
In-Reply-To: <46822540.2010004@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050005060903000103060406
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Vasily Averin wrote:
> 
>>When the number of conntracks is reached nf_conntrack_max limit, early_drop()
>>tries to free one of already used conntracks. If it does not find any conntracks
>>that may be freed, it leads to transmission errors.
>>In current implementation the conntracks are searched in one hash bucket only.
>>It have some drawbacks: if used hash bucket is empty we have not any chances to
>>find something. On the other hand the hash bucket can contain a huge number of
>>conntracks and its check can last a long time.
>>The proposed patch limits the number of checked conntracks and allows to search
>>conntracks in other hash buckets. As result in any case the search will have the
>>same chances to free one of the conntracks and the check will not lead to long
>>delays.
> 
> 
> 
> Thanks Vasily. I have some patches queued to convert all conntrack
> hashes to hlists, which conflict with your patches. They need a bit
> more work, I'll integrate your changes on top of them once I'm done.


I've added this patch to my tree at

http://people.netfilter.org/kaber/nf-2.6.23.git/

I've joined the two loops from your patch since that avoids an
otherwise useless function and doesn't take the lock up to 8
times in a row.


--------------050005060903000103060406
Content-Type: text/x-diff;
 name="32.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="32.diff"

[NETFILTER]: nf_conntrack: early_drop improvement

When the maximum number of conntrack entries is reached and a new
one needs to be allocated, conntrack tries to drop an unassured
connection from the same hash bucket the new conntrack would hash
to. Since with a properly sized hash the average number of entries
per bucket is 1, the chances of actually finding one are not very
good. This patch increases the range of buckets scanned to 8 to
increase those chances.

Based on patch by Vasily Averin <vvs@sw.ru>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e43d18c1b499b10971954aead30fb403aed89180
tree ce34b0c817a29d78727705e42e267756917aef28
parent 665d98d03473cab252830129f414e1b38fb2b038
author Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 13:57:47 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 13:57:47 +0200

 net/netfilter/nf_conntrack_core.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e62ad..72b3ba0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -377,24 +377,32 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
+#define NF_CT_EVICTION_RANGE	8
+
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(struct hlist_head *chain)
+static int early_drop(unsigned int hash)
 {
 	/* Use oldest entry, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct = NULL, *tmp;
 	struct hlist_node *n;
+	unsigned int i;
 	int dropped = 0;
 
 	read_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry(h, n, chain, hnode) {
-		tmp = nf_ct_tuplehash_to_ctrack(h);
-		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
-			ct = tmp;
+	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+			tmp = nf_ct_tuplehash_to_ctrack(h);
+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+				ct = tmp;
+		}
+		if (ct) {
+			atomic_inc(&ct->ct_general.use);
+			break;
+		}
+		hash = (hash + 1) % nf_conntrack_htable_size;
 	}
-	if (ct)
-		atomic_inc(&ct->ct_general.use);
 	read_unlock_bh(&nf_conntrack_lock);
 
 	if (!ct)
@@ -425,8 +433,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
+		if (!early_drop(hash)) {
 			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING

--------------050005060903000103060406--
