From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/07]: nf_conntrack: Fix module refcount dropping too
	far
Date: Fri, 21 Apr 2006 03:06:49 +0200 (MEST)
Message-ID: <20060421010649.8466.48853.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Fix module refcount dropping too far

If nf_ct_l3proto_find_get() fails to get the refcount of
nf_ct_l3proto_generic, nf_ct_l3proto_put() will drop the refcount
too far.

This gets rid of '.me = THIS_MODULE' of nf_ct_l3proto_generic so that
nf_ct_l3proto_find_get() doesn't try to get refcount of it.
It's OK because its symbol is usable until nf_conntrack.ko is unloaded.

This also kills unnecessary NULL pointer check as well.
__nf_ct_proto_find() allways returns non-NULL pointer.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bc79a39fcc0cb09ed73ba0052cb87c2893f4f65f
tree a2702573ee2acdc6fb865921a94042ef8d14f0f5
parent 5a7b46b369419493bab4de67b1526e9f76b22a7f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 21 Apr 2006 01:19:00 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:19:00 +0200

 net/netfilter/nf_conntrack_core.c            |   12 ++++--------
 net/netfilter/nf_conntrack_l3proto_generic.c |    1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e581190..e302222 100644
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
