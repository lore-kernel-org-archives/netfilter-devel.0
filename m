From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] [PATCH] remove module dependency between ctnetlink
 and	nf_nat
Date: Mon, 13 Oct 2008 15:50:03 +0200
Message-ID: <48F3520B.7010306@trash.net>
References: <20081011152116.6436.17277.stgit@Decadence> <20081011152312.6436.15322.stgit@Decadence>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050609030507030501050700"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJMNuF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:50:05 -0400
In-Reply-To: <20081011152312.6436.15322.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050609030507030501050700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I really can't get the other patches in at this point since they
don't really qualify as bug fixes. I'll start a nf-next tree once
Dave opens up the net-next tree, which will be in about two weeks.
Sorry about that, I know its partially my fault.

I've tried applying this without the others, and it applies and
compiled cleanly with one minor reject:

> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -445,7 +445,7 @@ static inline size_t calculate_helper_room_size(const struct nf_conn *ct)
>  {
>  	const struct nf_conn_help *help = nfct_help(ct);
>  	struct nf_conntrack_helper *helper;
> -	size_t size;
> +	size_t size = 0;
>  
>  	if (!help)
>  		goto out;

This chunk doesn't apply, but it doesn't seem to belong in the patch
anyway.

Do you want me to apply the patch as attached to this email, or would
you prefer to rediff it?


--------------050609030507030501050700
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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
index 27de3c7..622d7c6 100644
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
index cadfd15..48c9602 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -689,71 +689,6 @@ ctnetlink_parse_tuple(struct nlattr *cda[], struct nf_conntrack_tuple *tuple,
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
@@ -879,6 +814,33 @@ out:
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
@@ -901,23 +863,21 @@ ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
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

--------------050609030507030501050700--
