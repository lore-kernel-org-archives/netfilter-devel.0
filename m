From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/22]: nf_conntrack: switch protocol
	registration/unregistration to mutex
Date: Wed, 14 Mar 2007 09:50:17 +0100 (MET)
Message-ID: <20070314085002.15282.94434.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: switch protocol registration/unregistration to mutex

The protocol lookups done by nf_conntrack are already protected by RCU,
there is no need to keep taking nf_conntrack_lock for registration
and unregistration. Switch to a mutex.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 69b5f8d51819903743c648e829d247f0d156b889
tree 561177b4d270b5e1f30ed316c8b1535a68e10be1
parent 659738c122a278d4c15cb1b2dbd641b7acf80460
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:23:57 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:26:28 +0100

 net/netfilter/nf_conntrack_proto.c |   52 ++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 456155f..e2c4a58 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -32,9 +32,9 @@ struct nf_conntrack_l4proto **nf_ct_prot
 struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
-#ifdef CONFIG_SYSCTL
-static DEFINE_MUTEX(nf_ct_proto_sysctl_mutex);
+static DEFINE_MUTEX(nf_ct_proto_mutex);
 
+#ifdef CONFIG_SYSCTL
 static int
 nf_ct_register_sysctl(struct ctl_table_header **header, struct ctl_table *path,
 		      struct ctl_table *table, unsigned int *users)
@@ -164,13 +164,13 @@ static int nf_ct_l3proto_register_sysctl
 	int err = 0;
 
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	mutex_lock(&nf_ct_proto_mutex);
 	if (l3proto->ctl_table != NULL) {
 		err = nf_ct_register_sysctl(&l3proto->ctl_table_header,
 					    l3proto->ctl_table_path,
 					    l3proto->ctl_table, NULL);
 	}
-	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+	mutex_unlock(&nf_ct_proto_mutex);
 #endif
 	return err;
 }
@@ -178,11 +178,11 @@ #endif
 static void nf_ct_l3proto_unregister_sysctl(struct nf_conntrack_l3proto *l3proto)
 {
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	mutex_lock(&nf_ct_proto_mutex);
 	if (l3proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
 					l3proto->ctl_table, NULL);
-	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+	mutex_unlock(&nf_ct_proto_mutex);
 #endif
 }
 
@@ -195,13 +195,13 @@ int nf_conntrack_l3proto_register(struct
 		goto out;
 	}
 
-	write_lock_bh(&nf_conntrack_lock);
+	mutex_lock(&nf_ct_proto_mutex);
 	if (nf_ct_l3protos[proto->l3proto] != &nf_conntrack_l3proto_generic) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 
 	ret = nf_ct_l3proto_register_sysctl(proto);
 	if (ret < 0)
@@ -209,7 +209,7 @@ int nf_conntrack_l3proto_register(struct
 	return ret;
 
 out_unlock:
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 out:
 	return ret;
 }
@@ -219,11 +219,11 @@ void nf_conntrack_l3proto_unregister(str
 {
 	BUG_ON(proto->l3proto >= AF_MAX);
 
-	write_lock_bh(&nf_conntrack_lock);
+	mutex_lock(&nf_ct_proto_mutex);
 	BUG_ON(nf_ct_l3protos[proto->l3proto] != proto);
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
 			   &nf_conntrack_l3proto_generic);
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 	synchronize_rcu();
 
 	nf_ct_l3proto_unregister_sysctl(proto);
@@ -238,7 +238,7 @@ static int nf_ct_l4proto_register_sysctl
 	int err = 0;
 
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	mutex_lock(&nf_ct_proto_mutex);
 	if (l4proto->ctl_table != NULL) {
 		err = nf_ct_register_sysctl(l4proto->ctl_table_header,
 					    nf_net_netfilter_sysctl_path,
@@ -260,7 +260,7 @@ #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 	}
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 out:
-	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+	mutex_unlock(&nf_ct_proto_mutex);
 #endif /* CONFIG_SYSCTL */
 	return err;
 }
@@ -268,7 +268,7 @@ #endif /* CONFIG_SYSCTL */
 static void nf_ct_l4proto_unregister_sysctl(struct nf_conntrack_l4proto *l4proto)
 {
 #ifdef CONFIG_SYSCTL
-	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	mutex_lock(&nf_ct_proto_mutex);
 	if (l4proto->ctl_table_header != NULL &&
 	    *l4proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
@@ -279,7 +279,7 @@ #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 		nf_ct_unregister_sysctl(&l4proto->ctl_compat_table_header,
 					l4proto->ctl_compat_table, NULL);
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
-	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+	mutex_unlock(&nf_ct_proto_mutex);
 #endif /* CONFIG_SYSCTL */
 }
 
@@ -297,8 +297,8 @@ int nf_conntrack_l4proto_register(struct
 	if (l4proto == &nf_conntrack_l4proto_generic)
 		return nf_ct_l4proto_register_sysctl(l4proto);
 
+	mutex_lock(&nf_ct_proto_mutex);
 retry:
-	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_protos[l4proto->l3proto]) {
 		if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
 				!= &nf_conntrack_l4proto_generic) {
@@ -310,28 +310,22 @@ retry:
 		struct nf_conntrack_l4proto **proto_array;
 		int i;
 
-		write_unlock_bh(&nf_conntrack_lock);
-
 		proto_array = (struct nf_conntrack_l4proto **)
 				kmalloc(MAX_NF_CT_PROTO *
 					 sizeof(struct nf_conntrack_l4proto *),
 					GFP_KERNEL);
 		if (proto_array == NULL) {
 			ret = -ENOMEM;
-			goto out;
+			goto out_unlock;
 		}
 		for (i = 0; i < MAX_NF_CT_PROTO; i++)
 			proto_array[i] = &nf_conntrack_l4proto_generic;
 
-		write_lock_bh(&nf_conntrack_lock);
-		if (nf_ct_protos[l4proto->l3proto]) {
+		if (nf_ct_protos[l4proto->l3proto])
 			/* bad timing, but no problem */
-			write_unlock_bh(&nf_conntrack_lock);
 			kfree(proto_array);
-		} else {
+		else
 			nf_ct_protos[l4proto->l3proto] = proto_array;
-			write_unlock_bh(&nf_conntrack_lock);
-		}
 
 		/*
 		 * Just once because array is never freed until unloading
@@ -341,7 +335,7 @@ retry:
 	}
 
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto], l4proto);
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 
 	ret = nf_ct_l4proto_register_sysctl(l4proto);
 	if (ret < 0)
@@ -349,7 +343,7 @@ retry:
 	return ret;
 
 out_unlock:
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 out:
 	return ret;
 }
@@ -364,11 +358,11 @@ void nf_conntrack_l4proto_unregister(str
 		return;
 	}
 
-	write_lock_bh(&nf_conntrack_lock);
+	mutex_lock(&nf_ct_proto_mutex);
 	BUG_ON(nf_ct_protos[l4proto->l3proto][l4proto->l4proto] != l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
-	write_unlock_bh(&nf_conntrack_lock);
+	mutex_unlock(&nf_ct_proto_mutex);
 	synchronize_rcu();
 
 	nf_ct_l4proto_unregister_sysctl(l4proto);
