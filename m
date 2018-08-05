From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/21] netfilter: nfnetlink_osf: extract nfnetlink_subsystem code from xt_osf.c
Date: Sun,  5 Aug 2018 23:21:25 +0200
Message-ID: <20180805212141.3033-6-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Move nfnetlink osf subsystem from xt_osf.c to standalone module so we can
reuse it from the new nft_ost extension.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_osf.h |  11 +++
 include/uapi/linux/netfilter/xt_osf.h |   9 +-
 net/netfilter/nfnetlink_osf.c         | 154 ++++++++++++++++++++++++++++++++++
 net/netfilter/xt_osf.c                | 149 +-------------------------------
 4 files changed, 169 insertions(+), 154 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
index 3738116b2bbe..cc2487ff74f6 100644
--- a/include/uapi/linux/netfilter/nf_osf.h
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -70,6 +70,8 @@ struct nf_osf_nlmsg {
 	struct tcphdr			tcp;
 };
 
+extern struct list_head nf_osf_fingers[2];
+
 /* Defines for IANA option kinds */
 enum iana_options {
 	OSFOPT_EOL = 0,		/* End of options */
@@ -94,4 +96,13 @@ enum nf_osf_attr_type {
 	OSF_ATTR_MAX,
 };
 
+/*
+ * Add/remove fingerprint from the kernel.
+ */
+enum nf_osf_msg_types {
+	OSF_MSG_ADD,
+	OSF_MSG_REMOVE,
+	OSF_MSG_MAX,
+};
+
 #endif /* _NF_OSF_H */
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index b189007f4f28..a90e90c27cef 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -47,13 +47,6 @@
 #define xt_osf_nlmsg		nf_osf_nlmsg
 
 #define xt_osf_attr_type	nf_osf_attr_type
-/*
- * Add/remove fingerprint from the kernel.
- */
-enum xt_osf_msg_types {
-	OSF_MSG_ADD,
-	OSF_MSG_REMOVE,
-	OSF_MSG_MAX,
-};
+#define xt_osf_msg_types	nf_osf_msg_types
 
 #endif				/* _XT_OSF_H */
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index f4c75e982902..ba0fa11869ce 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -20,6 +20,13 @@
 #include <net/netfilter/nf_log.h>
 #include <linux/netfilter/nf_osf.h>
 
+/*
+ * Indexed by dont-fragment bit.
+ * It is the only constant value in the fingerprint.
+ */
+struct list_head nf_osf_fingers[2];
+EXPORT_SYMBOL_GPL(nf_osf_fingers);
+
 static inline int nf_osf_ttl(const struct sk_buff *skb,
 			     int ttl_check, unsigned char f_ttl)
 {
@@ -279,4 +286,151 @@ const char *nf_osf_find(const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
+static const struct nla_policy nfnl_osf_policy[OSF_ATTR_MAX + 1] = {
+	[OSF_ATTR_FINGER]	= { .len = sizeof(struct nf_osf_user_finger) },
+};
+
+static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
+				 struct sk_buff *skb, const struct nlmsghdr *nlh,
+				 const struct nlattr * const osf_attrs[],
+				 struct netlink_ext_ack *extack)
+{
+	struct nf_osf_user_finger *f;
+	struct nf_osf_finger *kf = NULL, *sf;
+	int err = 0;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!osf_attrs[OSF_ATTR_FINGER])
+		return -EINVAL;
+
+	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+		return -EINVAL;
+
+	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
+
+	kf = kmalloc(sizeof(struct nf_osf_finger), GFP_KERNEL);
+	if (!kf)
+		return -ENOMEM;
+
+	memcpy(&kf->finger, f, sizeof(struct nf_osf_user_finger));
+
+	list_for_each_entry(sf, &nf_osf_fingers[!!f->df], finger_entry) {
+		if (memcmp(&sf->finger, f, sizeof(struct nf_osf_user_finger)))
+			continue;
+
+		kfree(kf);
+		kf = NULL;
+
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			err = -EEXIST;
+		break;
+	}
+
+	/*
+	 * We are protected by nfnl mutex.
+	 */
+	if (kf)
+		list_add_tail_rcu(&kf->finger_entry, &nf_osf_fingers[!!f->df]);
+
+	return err;
+}
+
+static int nfnl_osf_remove_callback(struct net *net, struct sock *ctnl,
+				    struct sk_buff *skb,
+				    const struct nlmsghdr *nlh,
+				    const struct nlattr * const osf_attrs[],
+				    struct netlink_ext_ack *extack)
+{
+	struct nf_osf_user_finger *f;
+	struct nf_osf_finger *sf;
+	int err = -ENOENT;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!osf_attrs[OSF_ATTR_FINGER])
+		return -EINVAL;
+
+	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
+
+	list_for_each_entry(sf, &nf_osf_fingers[!!f->df], finger_entry) {
+		if (memcmp(&sf->finger, f, sizeof(struct nf_osf_user_finger)))
+			continue;
+
+		/*
+		 * We are protected by nfnl mutex.
+		 */
+		list_del_rcu(&sf->finger_entry);
+		kfree_rcu(sf, rcu_head);
+
+		err = 0;
+		break;
+	}
+
+	return err;
+}
+
+static const struct nfnl_callback nfnl_osf_callbacks[OSF_MSG_MAX] = {
+	[OSF_MSG_ADD]	= {
+		.call		= nfnl_osf_add_callback,
+		.attr_count	= OSF_ATTR_MAX,
+		.policy		= nfnl_osf_policy,
+	},
+	[OSF_MSG_REMOVE]	= {
+		.call		= nfnl_osf_remove_callback,
+		.attr_count	= OSF_ATTR_MAX,
+		.policy		= nfnl_osf_policy,
+	},
+};
+
+static const struct nfnetlink_subsystem nfnl_osf_subsys = {
+	.name			= "osf",
+	.subsys_id		= NFNL_SUBSYS_OSF,
+	.cb_count		= OSF_MSG_MAX,
+	.cb			= nfnl_osf_callbacks,
+};
+
+static int __init nfnl_osf_init(void)
+{
+	int err = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nf_osf_fingers); ++i)
+		INIT_LIST_HEAD(&nf_osf_fingers[i]);
+
+	err = nfnetlink_subsys_register(&nfnl_osf_subsys);
+	if (err < 0) {
+		pr_err("Failed to register OSF nsfnetlink helper (%d)\n", err);
+		goto err_out_exit;
+	}
+	return 0;
+
+err_out_exit:
+	return err;
+}
+
+static void __exit nfnl_osf_fini(void)
+{
+	struct nf_osf_finger *f;
+	int i;
+
+	nfnetlink_subsys_unregister(&nfnl_osf_subsys);
+
+	rcu_read_lock();
+	for (i = 0; i < ARRAY_SIZE(nf_osf_fingers); ++i) {
+		list_for_each_entry_rcu(f, &nf_osf_fingers[i], finger_entry) {
+			list_del_rcu(&f->finger_entry);
+			kfree_rcu(f, rcu_head);
+		}
+	}
+	rcu_read_unlock();
+
+	rcu_barrier();
+}
+
+module_init(nfnl_osf_init);
+module_exit(nfnl_osf_fini);
+
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 9cfef73b4107..bf7bba80e24c 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -37,118 +37,6 @@
 #include <net/netfilter/nf_log.h>
 #include <linux/netfilter/xt_osf.h>
 
-/*
- * Indexed by dont-fragment bit.
- * It is the only constant value in the fingerprint.
- */
-static struct list_head xt_osf_fingers[2];
-
-static const struct nla_policy xt_osf_policy[OSF_ATTR_MAX + 1] = {
-	[OSF_ATTR_FINGER]	= { .len = sizeof(struct xt_osf_user_finger) },
-};
-
-static int xt_osf_add_callback(struct net *net, struct sock *ctnl,
-			       struct sk_buff *skb, const struct nlmsghdr *nlh,
-			       const struct nlattr * const osf_attrs[],
-			       struct netlink_ext_ack *extack)
-{
-	struct xt_osf_user_finger *f;
-	struct xt_osf_finger *kf = NULL, *sf;
-	int err = 0;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (!osf_attrs[OSF_ATTR_FINGER])
-		return -EINVAL;
-
-	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
-		return -EINVAL;
-
-	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
-
-	kf = kmalloc(sizeof(struct xt_osf_finger), GFP_KERNEL);
-	if (!kf)
-		return -ENOMEM;
-
-	memcpy(&kf->finger, f, sizeof(struct xt_osf_user_finger));
-
-	list_for_each_entry(sf, &xt_osf_fingers[!!f->df], finger_entry) {
-		if (memcmp(&sf->finger, f, sizeof(struct xt_osf_user_finger)))
-			continue;
-
-		kfree(kf);
-		kf = NULL;
-
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
-			err = -EEXIST;
-		break;
-	}
-
-	/*
-	 * We are protected by nfnl mutex.
-	 */
-	if (kf)
-		list_add_tail_rcu(&kf->finger_entry, &xt_osf_fingers[!!f->df]);
-
-	return err;
-}
-
-static int xt_osf_remove_callback(struct net *net, struct sock *ctnl,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const osf_attrs[],
-				  struct netlink_ext_ack *extack)
-{
-	struct xt_osf_user_finger *f;
-	struct xt_osf_finger *sf;
-	int err = -ENOENT;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (!osf_attrs[OSF_ATTR_FINGER])
-		return -EINVAL;
-
-	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
-
-	list_for_each_entry(sf, &xt_osf_fingers[!!f->df], finger_entry) {
-		if (memcmp(&sf->finger, f, sizeof(struct xt_osf_user_finger)))
-			continue;
-
-		/*
-		 * We are protected by nfnl mutex.
-		 */
-		list_del_rcu(&sf->finger_entry);
-		kfree_rcu(sf, rcu_head);
-
-		err = 0;
-		break;
-	}
-
-	return err;
-}
-
-static const struct nfnl_callback xt_osf_nfnetlink_callbacks[OSF_MSG_MAX] = {
-	[OSF_MSG_ADD]	= {
-		.call		= xt_osf_add_callback,
-		.attr_count	= OSF_ATTR_MAX,
-		.policy		= xt_osf_policy,
-	},
-	[OSF_MSG_REMOVE]	= {
-		.call		= xt_osf_remove_callback,
-		.attr_count	= OSF_ATTR_MAX,
-		.policy		= xt_osf_policy,
-	},
-};
-
-static const struct nfnetlink_subsystem xt_osf_nfnetlink = {
-	.name			= "osf",
-	.subsys_id		= NFNL_SUBSYS_OSF,
-	.cb_count		= OSF_MSG_MAX,
-	.cb			= xt_osf_nfnetlink_callbacks,
-};
-
 static bool
 xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 {
@@ -159,7 +47,7 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 		return false;
 
 	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
-			    xt_out(p), info, net, xt_osf_fingers);
+			    xt_out(p), info, net, nf_osf_fingers);
 }
 
 static struct xt_match xt_osf_match = {
@@ -177,52 +65,21 @@ static struct xt_match xt_osf_match = {
 
 static int __init xt_osf_init(void)
 {
-	int err = -EINVAL;
-	int i;
-
-	for (i=0; i<ARRAY_SIZE(xt_osf_fingers); ++i)
-		INIT_LIST_HEAD(&xt_osf_fingers[i]);
-
-	err = nfnetlink_subsys_register(&xt_osf_nfnetlink);
-	if (err < 0) {
-		pr_err("Failed to register OSF nsfnetlink helper (%d)\n", err);
-		goto err_out_exit;
-	}
+	int err;
 
 	err = xt_register_match(&xt_osf_match);
 	if (err) {
 		pr_err("Failed to register OS fingerprint "
 		       "matching module (%d)\n", err);
-		goto err_out_remove;
+		return err;
 	}
 
 	return 0;
-
-err_out_remove:
-	nfnetlink_subsys_unregister(&xt_osf_nfnetlink);
-err_out_exit:
-	return err;
 }
 
 static void __exit xt_osf_fini(void)
 {
-	struct xt_osf_finger *f;
-	int i;
-
-	nfnetlink_subsys_unregister(&xt_osf_nfnetlink);
 	xt_unregister_match(&xt_osf_match);
-
-	rcu_read_lock();
-	for (i=0; i<ARRAY_SIZE(xt_osf_fingers); ++i) {
-
-		list_for_each_entry_rcu(f, &xt_osf_fingers[i], finger_entry) {
-			list_del_rcu(&f->finger_entry);
-			kfree_rcu(f, rcu_head);
-		}
-	}
-	rcu_read_unlock();
-
-	rcu_barrier();
 }
 
 module_init(xt_osf_init);
-- 
2.11.0
