From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/22]: nf_conntrack: simplify protocol locking
Date: Wed, 14 Mar 2007 09:50:20 +0100 (MET)
Message-ID: <20070314085005.15282.95783.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: simplify protocol locking

Now that we don't use nf_conntrack_lock anymore but a single mutex for
all protocol handling, no need to release and grab it again for sysctl
registration.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ea67c267464258ebf4752a9f23a30b965b6985a0
tree ba2a559594f6035e5b827a9a2d6651559dfbde08
parent 54043273620aa19f6b4334a56e04d90385b96d85
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:24:21 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:28:46 +0100

 net/netfilter/nf_conntrack_proto.c |   45 +++++++++++-------------------------
 1 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 0ca2f0b..5097254 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -164,13 +164,11 @@ static int nf_ct_l3proto_register_sysctl
 	int err = 0;
 
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_mutex);
 	if (l3proto->ctl_table != NULL) {
 		err = nf_ct_register_sysctl(&l3proto->ctl_table_header,
 					    l3proto->ctl_table_path,
 					    l3proto->ctl_table, NULL);
 	}
-	mutex_unlock(&nf_ct_proto_mutex);
 #endif
 	return err;
 }
@@ -178,11 +176,9 @@ #endif
 static void nf_ct_l3proto_unregister_sysctl(struct nf_conntrack_l3proto *l3proto)
 {
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_mutex);
 	if (l3proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
 					l3proto->ctl_table, NULL);
-	mutex_unlock(&nf_ct_proto_mutex);
 #endif
 }
 
@@ -190,27 +186,23 @@ int nf_conntrack_l3proto_register(struct
 {
 	int ret = 0;
 
-	if (proto->l3proto >= AF_MAX) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (proto->l3proto >= AF_MAX)
+		return -EBUSY;
 
 	mutex_lock(&nf_ct_proto_mutex);
 	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_l3proto_generic) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
-	mutex_unlock(&nf_ct_proto_mutex);
 
 	ret = nf_ct_l3proto_register_sysctl(proto);
 	if (ret < 0)
-		nf_conntrack_l3proto_unregister(proto);
-	return ret;
+		goto out_unlock;
+
+	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
 
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
-out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_register);
@@ -223,10 +215,10 @@ void nf_conntrack_l3proto_unregister(str
 	BUG_ON(nf_ct_l3protos[proto->l3proto] != proto);
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
 			   &nf_conntrack_l3proto_generic);
+	nf_ct_l3proto_unregister_sysctl(proto);
 	mutex_unlock(&nf_ct_proto_mutex);
-	synchronize_rcu();
 
-	nf_ct_l3proto_unregister_sysctl(proto);
+	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l3proto, proto);
@@ -238,7 +230,6 @@ static int nf_ct_l4proto_register_sysctl
 	int err = 0;
 
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_mutex);
 	if (l4proto->ctl_table != NULL) {
 		err = nf_ct_register_sysctl(l4proto->ctl_table_header,
 					    nf_net_netfilter_sysctl_path,
@@ -260,7 +251,6 @@ #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 	}
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 out:
-	mutex_unlock(&nf_ct_proto_mutex);
 #endif /* CONFIG_SYSCTL */
 	return err;
 }
@@ -268,7 +258,6 @@ #endif /* CONFIG_SYSCTL */
 static void nf_ct_l4proto_unregister_sysctl(struct nf_conntrack_l4proto *l4proto)
 {
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_mutex);
 	if (l4proto->ctl_table_header != NULL &&
 	    *l4proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
@@ -279,7 +268,6 @@ #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 		nf_ct_unregister_sysctl(&l4proto->ctl_compat_table_header,
 					l4proto->ctl_compat_table, NULL);
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
-	mutex_unlock(&nf_ct_proto_mutex);
 #endif /* CONFIG_SYSCTL */
 }
 
@@ -289,10 +277,8 @@ int nf_conntrack_l4proto_register(struct
 {
 	int ret = 0;
 
-	if (l4proto->l3proto >= PF_MAX) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (l4proto->l3proto >= PF_MAX)
+		return -EBUSY;
 
 	mutex_lock(&nf_ct_proto_mutex);
 retry:
@@ -331,17 +317,14 @@ retry:
 		goto retry;
 	}
 
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto], l4proto);
-	mutex_unlock(&nf_ct_proto_mutex);
-
 	ret = nf_ct_l4proto_register_sysctl(l4proto);
 	if (ret < 0)
-		nf_conntrack_l4proto_unregister(l4proto);
-	return ret;
+		goto out_unlock;
+
+	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto], l4proto);
 
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
-out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_register);
@@ -354,10 +337,10 @@ void nf_conntrack_l4proto_unregister(str
 	BUG_ON(nf_ct_protos[l4proto->l3proto][l4proto->l4proto] != l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
+	nf_ct_l4proto_unregister_sysctl(l4proto);
 	mutex_unlock(&nf_ct_proto_mutex);
-	synchronize_rcu();
 
-	nf_ct_l4proto_unregister_sysctl(l4proto);
+	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
