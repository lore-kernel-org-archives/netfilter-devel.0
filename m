From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Fri, 26 May 2006 09:15:50 +0900 (JST)
Message-ID: <200605260015.k4Q0FpPC024839@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="jhash.patch"
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

[NETFILTER] nf_conntrack: optimize hash calculation of tuple

This reduces the number of calling __jhash_mix() and addition of
JHASH_GOLDEN_RATIO.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

---
commit eac276f083c283360ed15571e8623463a8ace379
tree e7492317c9399f445bef061e76e01546f2517ef9
parent a54c9d30dbb06391ec4422aaf0e1dc2c8c53bd3e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 24 May 2006 21:16:51 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 24 May 2006 21:16:51 +0900

 net/netfilter/nf_conntrack_core.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9b83f9..b24edc9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -271,13 +271,31 @@ static unsigned int nf_conntrack_hash_rn
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 				  unsigned int size, unsigned int rnd)
 {
-	unsigned int a, b;
-	a = jhash((void *)tuple->src.u3.all, sizeof(tuple->src.u3.all),
-		  ((tuple->src.l3num) << 16) | tuple->dst.protonum);
-	b = jhash((void *)tuple->dst.u3.all, sizeof(tuple->dst.u3.all),
-			(tuple->src.u.all << 16) | tuple->dst.u.all);
+	u32 a, b, c;
 
-	return jhash_2words(a, b, rnd) % size;
+	a = JHASH_GOLDEN_RATIO;
+	b = JHASH_GOLDEN_RATIO;
+	c = rnd;
+
+	a += tuple->src.u3.all[0];
+	b += tuple->src.u3.all[1];
+	c += tuple->src.u3.all[2];
+	__jhash_mix(a, b, c);
+
+	a += tuple->src.u3.all[3],
+	b += (tuple->src.l3num << 16) | tuple->src.u.all;
+	c += tuple->dst.u3.all[0];
+	__jhash_mix(a, b, c);
+
+	a += tuple->dst.u3.all[1];
+	b += tuple->dst.u3.all[2];
+	c += tuple->dst.u3.all[3];
+	__jhash_mix(a, b, c);
+
+	a += (tuple->dst.protonum << 16) | tuple->dst.u.all;
+	__jhash_mix(a, b, c);
+
+	return c % size;
 }
 
 static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
