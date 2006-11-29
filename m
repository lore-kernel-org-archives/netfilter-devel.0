From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/33]: nf_conntrack: more sanity checks in protocol
	registration/unregistration
Date: Wed, 29 Nov 2006 03:08:55 +0100 (MET)
Message-ID: <20061129020854.21082.60730.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: more sanity checks in protocol registration/unregistration

Add some more sanity checks when registering/unregistering l3/l4 protocols.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 806420ab0fbfae2bcb4a3942190747afe5809b4d
tree 179894f058bff731aa57fc2c9f2dc211ea4beb4a
parent 1ef0a3824fdd09eeeaaf25e9d50165dfbaa88ad0
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:13:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:57:07 +0100

 include/net/netfilter/nf_conntrack_l3proto.h |    2 -
 include/net/netfilter/nf_conntrack_l4proto.h |    2 -
 net/netfilter/nf_conntrack_core.c            |    2 -
 net/netfilter/nf_conntrack_proto.c           |   55 +++++++++++++++++++++++---
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index ffe23a1..11b4b29 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -86,7 +86,7 @@ extern struct nf_conntrack_l3proto *nf_c
 
 /* Protocol registration. */
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
-extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
+extern int nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
 extern struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 0c6babd..5193e48 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -102,7 +102,7 @@ extern void nf_ct_l4proto_put(struct nf_
 
 /* Protocol registration. */
 extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
-extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
+extern int nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
 
 /* Generic netlink helpers */
 extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 441a647..73615d3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1198,7 +1198,7 @@ int __init nf_conntrack_init(void)
 
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
-        for (i = 0; i < PF_MAX; i++)
+        for (i = 0; i < AF_MAX; i++)
 		nf_ct_l3protos[i] = &nf_conntrack_l3proto_generic;
         write_unlock_bh(&nf_conntrack_lock);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 330b9ac..a6a3b1d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -28,7 +28,7 @@ #include <net/netfilter/nf_conntrack_l4p
 #include <net/netfilter/nf_conntrack_core.h>
 
 struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
-struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
 
 struct nf_conntrack_l4proto *
 __nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto)
@@ -128,21 +128,40 @@ int nf_conntrack_l3proto_register(struct
 {
 	int ret = 0;
 
+	if (proto->l3proto >= AF_MAX) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_l3proto_generic) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 	nf_ct_l3protos[proto->l3proto] = proto;
-out:
-	write_unlock_bh(&nf_conntrack_lock);
 
+out_unlock:
+	write_unlock_bh(&nf_conntrack_lock);
+out:
 	return ret;
 }
 
-void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
+int nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 {
+	int ret = 0;
+
+	if (proto->l3proto >= AF_MAX) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	write_lock_bh(&nf_conntrack_lock);
+	if (nf_ct_l3protos[proto->l3proto] != proto) {
+		write_unlock_bh(&nf_conntrack_lock);
+		ret = -EBUSY;
+		goto out;
+	}
+
 	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_l3proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
 
@@ -151,6 +170,9 @@ void nf_conntrack_l3proto_unregister(str
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l3proto, proto);
+
+out:
+	return ret;
 }
 
 /* FIXME: Allow NULL functions and sub in pointers to generic for
@@ -159,6 +181,11 @@ int nf_conntrack_l4proto_register(struct
 {
 	int ret = 0;
 
+	if (l4proto->l3proto >= PF_MAX) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 retry:
 	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_protos[l4proto->l3proto]) {
@@ -210,9 +237,22 @@ out:
 	return ret;
 }
 
-void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
+int nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 {
+	int ret = 0;
+
+	if (l4proto->l3proto >= PF_MAX) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	write_lock_bh(&nf_conntrack_lock);
+	if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
+	    != l4proto) {
+		write_unlock_bh(&nf_conntrack_lock);
+		ret = -EBUSY;
+		goto out;
+	}
 	nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
 		= &nf_conntrack_l4proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
@@ -222,4 +262,7 @@ void nf_conntrack_l4proto_unregister(str
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
+
+out:
+	return ret;
 }
