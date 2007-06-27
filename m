From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Wed, 27 Jun 2007 15:18:07 +0200
Message-ID: <4682638F.40507@trash.net>
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru>
	<4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru>
	<461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru>
	<46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net>
	<46811292.1010501@sw.ru>	<468223D0.90305@sw.ru>
	<46822540.2010004@trash.net> <4682523F.6000002@trash.net>
	<4682582D.7080501@sw.ru> <46825D63.3060500@trash.net>
	<46825FE0.7060306@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040001010701060403070901"
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46825FE0.7060306@sw.ru>
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
--------------040001010701060403070901
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Vasily Averin wrote:
> Patrick McHardy wrote:
> 
> it is incorrect again: when cnt=0 you should break both cycles.

Indeed, thanks. Fixed now. Also changed it to leave the loop
if we found an entry within a chain (we want the last one of
the chain, so we still walk it entirely) and replaced

hash = (hash + 1) % nf_conntrack_htable_size

by

hash = (hash + 1) & (nf_conntrack_htable_size - 1)

since one of my queued patches makes sure that its always
a power of two.

--------------040001010701060403070901
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack: early_drop improvement

When the maximum number of conntrack entries is reached and a new
one needs to be allocated, conntrack tries to drop an unassured
connection from the same hash bucket the new conntrack would hash
to. Since with a properly sized hash the average number of entries
per bucket is 1, the chances of actually finding one are not very
good. This patch increases those chances by walking over the hash
until 8 entries are checked.

Based on patch by Vasily Averin <vvs@sw.ru>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 047d8f088a71f30d3042cc7615a7a25aa60a668b
tree c83c4a356caf608fe21a646c24678bef74023270
parent 665d98d03473cab252830129f414e1b38fb2b038
author Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 15:17:17 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 27 Jun 2007 15:17:17 +0200

 net/netfilter/nf_conntrack_core.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e62ad..2d5c10f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -377,22 +377,33 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
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
-	int dropped = 0;
+	unsigned int i;
+	int dropped = 0, cnt = NF_CT_EVICTION_RANGE;
 
 	read_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry(h, n, chain, hnode) {
-		tmp = nf_ct_tuplehash_to_ctrack(h);
-		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
-			ct = tmp;
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+			tmp = nf_ct_tuplehash_to_ctrack(h);
+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+				ct = tmp;
+			if (--cnt <= 0)
+				goto stop;
+		}
+		if (ct)
+			break;
+		hash = (hash + 1) & (nf_conntrack_htable_size - 1);
 	}
+stop:
 	if (ct)
 		atomic_inc(&ct->ct_general.use);
 	read_unlock_bh(&nf_conntrack_lock);
@@ -425,8 +436,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
+		if (!early_drop(hash)) {
 			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING

--------------040001010701060403070901--
