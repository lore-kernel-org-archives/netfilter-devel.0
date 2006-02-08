From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] nf_conntrack: Fix module refcount dropping too far
Date: Wed, 08 Feb 2006 19:00:05 +0900 (JST)
Message-ID: <200602081000.k18A06Hs029199@toshiba.co.jp>
References: <200602080954.k189suUS003834@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Feb__8_19_00_05_2006_804)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200602080954.k189suUS003834@toshiba.co.jp>
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

----Next_Part(Wed_Feb__8_19_00_05_2006_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 08 Feb 2006 18:54:56 +0900 (JST)

> This is missing port from ip_conntrack, and prevents
> nf_conntrack_l3proto_find_get() from taking refcount of
> nf_conntrack_l3proto_generic to fix refcount underflow.

sorry for missing patch...

----Next_Part(Wed_Feb__8_19_00_05_2006_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfct-mod-refcnt.patch"

[NETFILTER] nf_conntrack: Fix module refcount dropping too far

nf_ct_l3proto_find_get() may return nf_ct_l3proto_generic without taking
refcount. But nf_ct_l3proto_put() always drops it. To fix this problem,
this patch prevents nf_ct_l3proto_find_get() from taking refcount.
It's OK, because all of them live in same module(nf_conntrack.ko).

This also removes NULL check. __nf_ct_{l3proto,proto}_find_get() never
return NULL.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 6f95d916a3fd6eb8edf75eba29c86cd96447ccdc
tree d9bc4827a5db6d5570d0e5536046e4d59fbd0046
parent ecd52256054fb1e2a2864f4b7bc85a601121590d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 08 Feb 2006 11:46:22 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 08 Feb 2006 11:46:22 +0900

 net/netfilter/nf_conntrack_core.c            |   12 ++++--------
 net/netfilter/nf_conntrack_l3proto_generic.c |    2 +-
 net/netfilter/nf_conntrack_proto_generic.c   |    1 +
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0ce337a..0496ee9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -203,10 +203,8 @@ nf_ct_proto_find_get(u_int16_t l3proto, 
 
 	preempt_disable();
 	p = __nf_ct_proto_find(l3proto, protocol);
-	if (p) {
-		if (!try_module_get(p->me))
-			p = &nf_conntrack_generic_protocol;
-	}
+	if (!try_module_get(p->me))
+		p = &nf_conntrack_generic_protocol;
 	preempt_enable();
 	
 	return p;
@@ -224,10 +222,8 @@ nf_ct_l3proto_find_get(u_int16_t l3proto
 
 	preempt_disable();
 	p = __nf_ct_l3proto_find(l3proto);
-	if (p) {
-		if (!try_module_get(p->me))
-			p = &nf_conntrack_generic_l3proto;
-	}
+	if (!try_module_get(p->me))
+		p = &nf_conntrack_generic_l3proto;
 	preempt_enable();
 
 	return p;
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 7de4f06..ee3bfd8 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -94,5 +94,5 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_conntrack = generic_print_conntrack,
 	.prepare	 = generic_prepare,
 	.get_features	 = generic_get_features,
-	.me		 = THIS_MODULE,
+	/* .me isn't set: getting a ref to this cannot fail. */
 };
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 46bc27e..bc60cf3 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -82,4 +82,5 @@ struct nf_conntrack_protocol nf_conntrac
 	.print_conntrack	= generic_print_conntrack,
 	.packet			= packet,
 	.new			= new,
+	/* .me isn't set: getting a ref to this cannot fail. */
 };

----Next_Part(Wed_Feb__8_19_00_05_2006_804)----
