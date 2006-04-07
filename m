From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] nf_conntrack: Fix module refcount dropping too far
Date: Fri, 07 Apr 2006 17:59:43 +0900 (JST)
Message-ID: <200604070859.k378xiZ3009767@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Apr__7_17_59_43_2006_080)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
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

----Next_Part(Fri_Apr__7_17_59_43_2006_080)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


If nf_ct_l3proto_find_get() fails to get the refcount of
nf_ct_l3proto_generic, nf_ct_l3proto_put() will drop the refcount
too far. Only nf_ct_l3proto_generic has this problem.

This fix is missing synchronization with ip_conntrack at the last minutes,
but it's not critical, I think.

-- Yasuyuki Kozakai

----Next_Part(Fri_Apr__7_17_59_43_2006_080)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-generic-refcnt.patch"

[NETFILTER] nf_conntrack: Fix module refcount dropping too far

If nf_ct_l3proto_find_get() fails to get the refcount of
nf_ct_l3proto_generic, nf_ct_l3proto_put() will drop the refcount
too far.

This gets rid of '.me = THIS_MODULE' of nf_ct_l3proto_generic so that
nf_ct_l3proto_find_get() doesn't try to get refcount of it.
It's OK because its symbol is usable until nf_conntrack.ko is unloaded.

This also kills unnecessary NULL pointer check as well.
__nf_ct_proto_find() allways returns non-NULL pointer.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit e2a1cbe4dda205181d6206df84fe3eb22ec85273
tree 01324536d3cf7d405dfddbb954ea155bed8a64af
parent a8b9aa85685a7f5c5841dfc4c5772d453fbf5776
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 07 Apr 2006 14:54:25 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 07 Apr 2006 14:54:25 +0900

 net/netfilter/nf_conntrack_core.c            |   12 ++++--------
 net/netfilter/nf_conntrack_l3proto_generic.c |    1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 56389c8..54bdc08 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -208,10 +208,8 @@ nf_ct_proto_find_get(u_int16_t l3proto, 
 
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
@@ -229,10 +227,8 @@ nf_ct_l3proto_find_get(u_int16_t l3proto
 
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
index 7de4f06..3fc58e4 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -94,5 +94,4 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_conntrack = generic_print_conntrack,
 	.prepare	 = generic_prepare,
 	.get_features	 = generic_get_features,
-	.me		 = THIS_MODULE,
 };

----Next_Part(Fri_Apr__7_17_59_43_2006_080)----
