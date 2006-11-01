From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 07/11] More sanity checks in protocol
	registration/unregistration
Date: Wed, 01 Nov 2006 22:08:52 +0100
Message-ID: <20061101210914.114593334@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=l3l4proto-checks
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

Add some more sanity checks when registering/unregistering l3/l4 protocols.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 include/net/netfilter/nf_conntrack_l3proto.h |    2 
 include/net/netfilter/nf_conntrack_l4proto.h |    2 
 net/netfilter/nf_conntrack_core.c            |    2 
 net/netfilter/nf_conntrack_proto.c           |   55 ++++++++++++++++++++++++---
 4 files changed, 52 insertions(+), 9 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l3proto.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_l3proto.h	2006-11-01 21:40:01.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l3proto.h	2006-11-01 21:40:07.000000000 +0100
@@ -86,7 +86,7 @@ extern struct nf_conntrack_l3proto *nf_c
 
 /* Protocol registration. */
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
-extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
+extern int nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
 extern struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto);
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:01.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:07.000000000 +0100
@@ -1199,7 +1199,7 @@ int __init nf_conntrack_init(void)
 
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
-        for (i = 0; i < PF_MAX; i++)
+        for (i = 0; i < AF_MAX; i++)
 		nf_ct_l3protos[i] = &nf_conntrack_l3proto_generic;
         write_unlock_bh(&nf_conntrack_lock);
 
Index: linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l4proto.h
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/include/net/netfilter/nf_conntrack_l4proto.h	2006-11-01 21:40:01.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/include/net/netfilter/nf_conntrack_l4proto.h	2006-11-01 21:40:07.000000000 +0100
@@ -102,7 +102,7 @@ extern void nf_ct_l4proto_put(struct nf_
 
 /* Protocol registration. */
 extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
-extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
+extern int nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
 
 /* Generic netlink helpers */
 extern int nf_ct_port_tuple_to_nfattr(struct sk_buff *skb,
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_proto.c	2006-11-01 21:40:01.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_proto.c	2006-11-01 21:40:07.000000000 +0100
@@ -28,7 +28,7 @@
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

--
/Martin
