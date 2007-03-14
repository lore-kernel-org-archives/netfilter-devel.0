From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/22]: nf_conntrack: simplify l4 protocol array
	allocation
Date: Wed, 14 Mar 2007 09:50:22 +0100 (MET)
Message-ID: <20070314085006.15282.89022.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: simplify l4 protocol array allocation

The retrying after an allocation failure is not necessary anymore
since we're holding the mutex the entire time, for the same
reason the double allocation race can't happen anymore.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e4cfced6765b323aaf85882448deef3008a2e204
tree 39afbf17c060a2de7cd21bfbbc807a14a2d66dad
parent ea67c267464258ebf4752a9f23a30b965b6985a0
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:24:32 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:29:11 +0100

 net/netfilter/nf_conntrack_proto.c |   37 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 5097254..e4aad20 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -281,47 +281,34 @@ int nf_conntrack_l4proto_register(struct
 		return -EBUSY;
 
 	mutex_lock(&nf_ct_proto_mutex);
-retry:
-	if (nf_ct_protos[l4proto->l3proto]) {
-		if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
-				!= &nf_conntrack_l4proto_generic) {
-			ret = -EBUSY;
-			goto out_unlock;
-		}
-	} else {
+	if (!nf_ct_protos[l4proto->l3proto]) {
 		/* l3proto may be loaded latter. */
 		struct nf_conntrack_l4proto **proto_array;
 		int i;
 
-		proto_array = (struct nf_conntrack_l4proto **)
-				kmalloc(MAX_NF_CT_PROTO *
-					 sizeof(struct nf_conntrack_l4proto *),
-					GFP_KERNEL);
+		proto_array = kmalloc(MAX_NF_CT_PROTO *
+				      sizeof(struct nf_conntrack_l4proto *),
+				      GFP_KERNEL);
 		if (proto_array == NULL) {
 			ret = -ENOMEM;
 			goto out_unlock;
 		}
+
 		for (i = 0; i < MAX_NF_CT_PROTO; i++)
 			proto_array[i] = &nf_conntrack_l4proto_generic;
-
-		if (nf_ct_protos[l4proto->l3proto])
-			/* bad timing, but no problem */
-			kfree(proto_array);
-		else
-			nf_ct_protos[l4proto->l3proto] = proto_array;
-
-		/*
-		 * Just once because array is never freed until unloading
-		 * nf_conntrack.ko
-		 */
-		goto retry;
+		nf_ct_protos[l4proto->l3proto] = proto_array;
+	} else if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto] !=
+					&nf_conntrack_l4proto_generic) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
 	ret = nf_ct_l4proto_register_sysctl(l4proto);
 	if (ret < 0)
 		goto out_unlock;
 
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto], l4proto);
+	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+			   l4proto);
 
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
