From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] [PATCH] remove module dependency between ctnetlink and
	nf_nat
Date: Thu, 09 Oct 2008 10:36:25 +0200
Message-ID: <20081009083625.9824.69320.stgit@Decadence>
References: <20081009083339.9824.24056.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36250 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753392AbYJIItR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:49:17 -0400
In-Reply-To: <20081009083339.9824.24056.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes the module dependency between ctnetlink and
nf_nat by means of an indirect call that is initialized when
nf_nat is loaded. Now, nf_conntrack_netlink only requires
nf_conntrack and nfnetlink.

This patch puts nfnetlink_parse_nat_setup_hook into the
nf_conntrack_core to avoid dependencies between ctnetlink,
nf_conntrack_ipv4 and nf_conntrack_ipv6.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_nat_core.h  |    8 ++
 net/ipv4/netfilter/nf_nat_core.c     |   97 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c    |    7 ++
 net/netfilter/nf_conntrack_netlink.c |  116 +++++++++++-----------------------
 4 files changed, 150 insertions(+), 78 deletions(-)

diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
index f29eeb9..5868406 100644
--- a/include/net/netfilter/nf_nat_core.h
+++ b/include/net/netfilter/nf_nat_core.h
@@ -25,4 +25,12 @@ static inline int nf_nat_initialized(struct nf_conn *ct,
 	else
 		return test_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
 }
+
+struct nlattr;
+
+extern int
+(*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
+				  enum nf_nat_manip_type manip,
+				  struct nlattr *attr);
+
 #endif /* _NF_NAT_CORE_H */
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 2ac9eaf..91ec535 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -584,6 +584,98 @@ static struct nf_ct_ext_type nat_extend __read_mostly = {
 	.flags		= NF_CT_EXT_F_PREALLOC,
 };
 
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static const struct nla_policy protonat_nla_policy[CTA_PROTONAT_MAX+1] = {
+	[CTA_PROTONAT_PORT_MIN]	= { .type = NLA_U16 },
+	[CTA_PROTONAT_PORT_MAX]	= { .type = NLA_U16 },
+};
+
+static int nfnetlink_parse_nat_proto(struct nlattr *attr,
+				     const struct nf_conn *ct,
+				     struct nf_nat_range *range)
+{
+	struct nlattr *tb[CTA_PROTONAT_MAX+1];
+	const struct nf_nat_protocol *npt;
+	int err;
+
+	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, protonat_nla_policy);
+	if (err < 0)
+		return err;
+
+	npt = nf_nat_proto_find_get(nf_ct_protonum(ct));
+	if (npt->nlattr_to_range)
+		err = npt->nlattr_to_range(tb, range);
+	nf_nat_proto_put(npt);
+	return err;
+}
+
+static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
+	[CTA_NAT_MINIP]		= { .type = NLA_U32 },
+	[CTA_NAT_MAXIP]		= { .type = NLA_U32 },
+};
+
+static int
+nfnetlink_parse_nat(struct nlattr *nat,
+		    const struct nf_conn *ct, struct nf_nat_range *range)
+{
+	struct nlattr *tb[CTA_NAT_MAX+1];
+	int err;
+
+	memset(range, 0, sizeof(*range));
+
+	err = nla_parse_nested(tb, CTA_NAT_MAX, nat, nat_nla_policy);
+	if (err < 0)
+		return err;
+
+	if (tb[CTA_NAT_MINIP])
+		range->min_ip = nla_get_be32(tb[CTA_NAT_MINIP]);
+
+	if (!tb[CTA_NAT_MAXIP])
+		range->max_ip = range->min_ip;
+	else
+		range->max_ip = nla_get_be32(tb[CTA_NAT_MAXIP]);
+
+	if (range->min_ip)
+		range->flags |= IP_NAT_RANGE_MAP_IPS;
+
+	if (!tb[CTA_NAT_PROTO])
+		return 0;
+
+	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO], ct, range);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int
+nfnetlink_parse_nat_setup(struct nf_conn *ct,
+			  enum nf_nat_manip_type manip,
+			  struct nlattr *attr)
+{
+	struct nf_nat_range range;
+
+	if (nfnetlink_parse_nat(attr, ct, &range) < 0)
+		return -EINVAL;
+	if (nf_nat_initialized(ct, manip))
+		return -EEXIST;
+
+	return nf_nat_setup_info(ct, &range, manip);
+}
+#else
+static int
+nfnetlink_parse_nat_setup(struct nf_conn *ct,
+			  enum nf_nat_manip_type manip,
+			  struct nlattr *attr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static int __net_init nf_nat_net_init(struct net *net)
 {
 	net->ipv4.nat_bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size,
@@ -654,6 +746,9 @@ static int __init nf_nat_init(void)
 
 	BUG_ON(nf_nat_seq_adjust_hook != NULL);
 	rcu_assign_pointer(nf_nat_seq_adjust_hook, nf_nat_seq_adjust);
+	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
+	rcu_assign_pointer(nfnetlink_parse_nat_setup_hook, 
+			   nfnetlink_parse_nat_setup);
 	return 0;
 
  cleanup_extend:
@@ -667,10 +762,12 @@ static void __exit nf_nat_cleanup(void)
 	nf_ct_l3proto_put(l3proto);
 	nf_ct_extend_unregister(&nat_extend);
 	rcu_assign_pointer(nf_nat_seq_adjust_hook, NULL);
+	rcu_assign_pointer(nfnetlink_parse_nat_setup_hook, NULL);
 	synchronize_net();
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("nf-nat-ipv4");
 
 module_init(nf_nat_init);
 module_exit(nf_nat_cleanup);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 281b398..1f9a0a8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -38,9 +38,16 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_nat.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
+unsigned int
+(*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
+				  enum nf_nat_manip_type manip,
+				  struct nlattr *attr) __read_mostly;
+EXPORT_SYMBOL_GPL(nfnetlink_parse_nat_setup_hook);
+
 DEFINE_SPINLOCK(nf_conntrack_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1046901..bce9e5d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -784,71 +784,6 @@ ctnetlink_parse_tuple(struct nlattr *cda[], struct nf_conntrack_tuple *tuple,
 	return 0;
 }
 
-#ifdef CONFIG_NF_NAT_NEEDED
-static const struct nla_policy protonat_nla_policy[CTA_PROTONAT_MAX+1] = {
-	[CTA_PROTONAT_PORT_MIN]	= { .type = NLA_U16 },
-	[CTA_PROTONAT_PORT_MAX]	= { .type = NLA_U16 },
-};
-
-static int nfnetlink_parse_nat_proto(struct nlattr *attr,
-				     const struct nf_conn *ct,
-				     struct nf_nat_range *range)
-{
-	struct nlattr *tb[CTA_PROTONAT_MAX+1];
-	const struct nf_nat_protocol *npt;
-	int err;
-
-	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, protonat_nla_policy);
-	if (err < 0)
-		return err;
-
-	npt = nf_nat_proto_find_get(nf_ct_protonum(ct));
-	if (npt->nlattr_to_range)
-		err = npt->nlattr_to_range(tb, range);
-	nf_nat_proto_put(npt);
-	return err;
-}
-
-static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
-	[CTA_NAT_MINIP]		= { .type = NLA_U32 },
-	[CTA_NAT_MAXIP]		= { .type = NLA_U32 },
-};
-
-static inline int
-nfnetlink_parse_nat(struct nlattr *nat,
-		    const struct nf_conn *ct, struct nf_nat_range *range)
-{
-	struct nlattr *tb[CTA_NAT_MAX+1];
-	int err;
-
-	memset(range, 0, sizeof(*range));
-
-	err = nla_parse_nested(tb, CTA_NAT_MAX, nat, nat_nla_policy);
-	if (err < 0)
-		return err;
-
-	if (tb[CTA_NAT_MINIP])
-		range->min_ip = nla_get_be32(tb[CTA_NAT_MINIP]);
-
-	if (!tb[CTA_NAT_MAXIP])
-		range->max_ip = range->min_ip;
-	else
-		range->max_ip = nla_get_be32(tb[CTA_NAT_MAXIP]);
-
-	if (range->min_ip)
-		range->flags |= IP_NAT_RANGE_MAP_IPS;
-
-	if (!tb[CTA_NAT_PROTO])
-		return 0;
-
-	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO], ct, range);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-#endif
-
 static inline int
 ctnetlink_parse_help(struct nlattr *attr, char **helper_name)
 {
@@ -986,6 +921,33 @@ out:
 }
 
 static int
+ctnetlink_parse_nat_setup(struct nf_conn *ct,
+			  enum nf_nat_manip_type manip,
+			  struct nlattr *attr)
+{
+	typeof(nfnetlink_parse_nat_setup_hook) parse_nat_setup;
+
+	parse_nat_setup = rcu_dereference(nfnetlink_parse_nat_setup_hook);
+	if (!parse_nat_setup) {
+#ifdef CONFIG_KMOD
+		spin_unlock_bh(&nf_conntrack_lock);
+		if (request_module("nf-nat-ipv4") < 0) {
+			spin_lock_bh(&nf_conntrack_lock);
+			return -EOPNOTSUPP;
+		}
+		spin_lock_bh(&nf_conntrack_lock);
+		parse_nat_setup =
+			rcu_dereference(nfnetlink_parse_nat_setup_hook);
+		if (parse_nat_setup)
+			return -EAGAIN;
+#endif
+		return -EOPNOTSUPP;
+	}
+
+	return parse_nat_setup(ct, manip, attr);
+}
+
+static int
 ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 {
 	unsigned long d;
@@ -1008,23 +970,21 @@ ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 #ifndef CONFIG_NF_NAT_NEEDED
 		return -EOPNOTSUPP;
 #else
-		struct nf_nat_range range;
+		int ret;
 
 		if (cda[CTA_NAT_DST]) {
-			if (nfnetlink_parse_nat(cda[CTA_NAT_DST], ct,
-						&range) < 0)
-				return -EINVAL;
-			if (nf_nat_initialized(ct, IP_NAT_MANIP_DST))
-				return -EEXIST;
-			nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
+			ret = ctnetlink_parse_nat_setup(ct,
+							IP_NAT_MANIP_DST,
+							cda[CTA_NAT_DST]);
+			if (ret < 0)
+				return ret;
 		}
 		if (cda[CTA_NAT_SRC]) {
-			if (nfnetlink_parse_nat(cda[CTA_NAT_SRC], ct,
-						&range) < 0)
-				return -EINVAL;
-			if (nf_nat_initialized(ct, IP_NAT_MANIP_SRC))
-				return -EEXIST;
-			nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
+			ret = ctnetlink_parse_nat_setup(ct,
+							IP_NAT_MANIP_SRC,
+							cda[CTA_NAT_SRC]);
+			if (ret < 0)
+				return ret;
 		}
 #endif
 	}

