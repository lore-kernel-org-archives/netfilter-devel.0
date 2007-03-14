From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/22]: nf_conntrack: remove ugly hack in l4proto
	registration
Date: Wed, 14 Mar 2007 09:50:18 +0100 (MET)
Message-ID: <20070314085003.15282.53190.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: remove ugly hack in l4proto registration

Remove ugly special-casing of nf_conntrack_l4proto_generic, all it
wants is its sysctl tables registered, so do that explicitly in an
init function and move the remaining protocol initialization and
cleanup code to nf_conntrack_proto.c as well.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 54043273620aa19f6b4334a56e04d90385b96d85
tree b1d212025330251bf39a38414de7488a2bf9bf30
parent 69b5f8d51819903743c648e829d247f0d156b889
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:24:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:27:11 +0100

 include/net/netfilter/nf_conntrack_core.h |    3 +++
 net/netfilter/nf_conntrack_core.c         |   18 ++-------------
 net/netfilter/nf_conntrack_proto.c        |   34 ++++++++++++++++++++++-------
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 85634e1..9fb9066 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -27,6 +27,9 @@ extern unsigned int nf_conntrack_in(int 
 extern int nf_conntrack_init(void);
 extern void nf_conntrack_cleanup(void);
 
+extern int nf_conntrack_proto_init(void);
+extern void nf_conntrack_proto_fini(void);
+
 struct nf_conntrack_l3proto;
 extern struct nf_conntrack_l3proto *nf_ct_find_l3proto(u_int16_t pf);
 /* Like above, but you already have conntrack read lock. */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7694c51..9858bcb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1152,14 +1152,7 @@ void nf_conntrack_cleanup(void)
 	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
 			    nf_conntrack_htable_size);
 
-	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_generic);
-
-	/* free l3proto protocol tables */
-	for (i = 0; i < PF_MAX; i++)
-		if (nf_ct_protos[i]) {
-			kfree(nf_ct_protos[i]);
-			nf_ct_protos[i] = NULL;
-		}
+	nf_conntrack_proto_fini();
 }
 
 static struct list_head *alloc_hashtable(int size, int *vmalloced)
@@ -1237,7 +1230,6 @@ module_param_call(hashsize, set_hashsize
 
 int __init nf_conntrack_init(void)
 {
-	unsigned int i;
 	int ret;
 
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
@@ -1279,16 +1271,10 @@ int __init nf_conntrack_init(void)
 		goto err_free_conntrack_slab;
 	}
 
-	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_generic);
+	ret = nf_conntrack_proto_init();
 	if (ret < 0)
 		goto out_free_expect_slab;
 
-	/* Don't NEED lock here, but good form anyway. */
-	write_lock_bh(&nf_conntrack_lock);
-	for (i = 0; i < AF_MAX; i++)
-		nf_ct_l3protos[i] = &nf_conntrack_l3proto_generic;
-	write_unlock_bh(&nf_conntrack_lock);
-
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index e2c4a58..0ca2f0b 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -294,9 +294,6 @@ int nf_conntrack_l4proto_register(struct
 		goto out;
 	}
 
-	if (l4proto == &nf_conntrack_l4proto_generic)
-		return nf_ct_l4proto_register_sysctl(l4proto);
-
 	mutex_lock(&nf_ct_proto_mutex);
 retry:
 	if (nf_ct_protos[l4proto->l3proto]) {
@@ -353,11 +350,6 @@ void nf_conntrack_l4proto_unregister(str
 {
 	BUG_ON(l4proto->l3proto >= PF_MAX);
 
-	if (l4proto == &nf_conntrack_l4proto_generic) {
-		nf_ct_l4proto_unregister_sysctl(l4proto);
-		return;
-	}
-
 	mutex_lock(&nf_ct_proto_mutex);
 	BUG_ON(nf_ct_protos[l4proto->l3proto][l4proto->l4proto] != l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
@@ -371,3 +363,29 @@ void nf_conntrack_l4proto_unregister(str
 	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
+
+int nf_conntrack_proto_init(void)
+{
+	unsigned int i;
+	int err;
+
+	err = nf_ct_l4proto_register_sysctl(&nf_conntrack_l4proto_generic);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < AF_MAX; i++)
+		rcu_assign_pointer(nf_ct_l3protos[i],
+				   &nf_conntrack_l3proto_generic);
+	return 0;
+}
+
+void nf_conntrack_proto_fini(void)
+{
+	unsigned int i;
+
+	nf_ct_l4proto_unregister_sysctl(&nf_conntrack_l4proto_generic);
+
+	/* free l3proto protocol tables */
+	for (i = 0; i < PF_MAX; i++)
+		kfree(nf_ct_protos[i]);
+}
