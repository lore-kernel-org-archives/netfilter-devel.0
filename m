From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/22]: nf_conntrack: change
	nf_conntrack_l[34]proto_unregister to void
Date: Mon, 12 Feb 2007 11:36:45 +0100 (MET)
Message-ID: <20070212103644.661.50922.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: change nf_conntrack_l[34]proto_unregister to void

No caller checks the return value, and since its usually called within the
module unload path there's nothing a module could do about errors anyway,
so BUG on invalid conditions and return void.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4b4109fff045b66b7bc0a696fc020f0cc22bad0e
tree 88928fbaa762aca7dfce1d0b4138fc9372487e4e
parent 2428570e4fc9d689faeb4a96ba7b34352f0a6e2c
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:30 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:30 +0100

 include/net/netfilter/nf_conntrack_l3proto.h |    2 +
 include/net/netfilter/nf_conntrack_l4proto.h |    2 +
 net/netfilter/nf_conntrack_proto.c           |   40 +++++---------------------
 3 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index ba760fe..eb575cb 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -89,7 +89,7 @@ extern struct nf_conntrack_l3proto *nf_c
 
 /* Protocol registration. */
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
-extern int nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
+extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
 extern struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fc8af08..8415182 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -109,7 +109,7 @@ extern void nf_ct_l4proto_put(struct nf_
 
 /* Protocol registration. */
 extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
-extern int nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
+extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
 
 /* Generic netlink helpers */
 extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 4dab3fa..456155f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -215,22 +215,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_register);
 
-int nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
+void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 {
-	int ret = 0;
-
-	if (proto->l3proto >= AF_MAX) {
-		ret = -EBUSY;
-		goto out;
-	}
+	BUG_ON(proto->l3proto >= AF_MAX);
 
 	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_l3protos[proto->l3proto] != proto) {
-		write_unlock_bh(&nf_conntrack_lock);
-		ret = -EBUSY;
-		goto out;
-	}
-
+	BUG_ON(nf_ct_l3protos[proto->l3proto] != proto);
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
 			   &nf_conntrack_l3proto_generic);
 	write_unlock_bh(&nf_conntrack_lock);
@@ -240,9 +230,6 @@ int nf_conntrack_l3proto_unregister(stru
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l3proto, proto);
-
-out:
-	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -368,27 +355,17 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_register);
 
-int nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
+void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 {
-	int ret = 0;
-
-	if (l4proto->l3proto >= PF_MAX) {
-		ret = -EBUSY;
-		goto out;
-	}
+	BUG_ON(l4proto->l3proto >= PF_MAX);
 
 	if (l4proto == &nf_conntrack_l4proto_generic) {
 		nf_ct_l4proto_unregister_sysctl(l4proto);
-		goto out;
+		return;
 	}
 
 	write_lock_bh(&nf_conntrack_lock);
-	if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
-	    != l4proto) {
-		write_unlock_bh(&nf_conntrack_lock);
-		ret = -EBUSY;
-		goto out;
-	}
+	BUG_ON(nf_ct_protos[l4proto->l3proto][l4proto->l4proto] != l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
 	write_unlock_bh(&nf_conntrack_lock);
@@ -398,8 +375,5 @@ int nf_conntrack_l4proto_unregister(stru
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
-
-out:
-	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
