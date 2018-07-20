From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/38] netfilter: conntrack: remove ctnetlink callbacks from l3 protocol trackers
Date: Fri, 20 Jul 2018 15:08:36 +0200
Message-ID: <20180720130906.27687-9-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

handle everything from ctnetlink directly.

After all these years we still only support ipv4 and ipv6, so it
seems reasonable to remove l3 protocol tracker support and instead
handle ipv4/ipv6 from a common, always builtin inet tracker.

Step 1: Get rid of all the l3proto->func() calls.

Start with ctnetlink, then move on to packet-path ones.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h      |  6 +-
 include/net/netfilter/nf_conntrack_l3proto.h   |  8 ---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 47 -------------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 48 -------------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |  1 -
 net/netfilter/nf_conntrack_expect.c            |  1 -
 net/netfilter/nf_conntrack_helper.c            |  1 -
 net/netfilter/nf_conntrack_netlink.c           | 96 +++++++++++++++++++-------
 net/netfilter/nf_conntrack_proto.c             |  5 +-
 net/netfilter/nf_conntrack_standalone.c        | 14 ++--
 net/netfilter/nfnetlink_cttimeout.c            |  1 -
 11 files changed, 79 insertions(+), 149 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 90df45022c51..d454a53ba646 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -68,10 +68,8 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	return ret;
 }
 
-void
-print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
-            const struct nf_conntrack_l3proto *l3proto,
-            const struct nf_conntrack_l4proto *proto);
+void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
+		 const struct nf_conntrack_l4proto *proto);
 
 #define CONNTRACK_LOCKS 1024
 
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index d5808f3e2715..d07b5216a925 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -46,14 +46,6 @@ struct nf_conntrack_l3proto {
 	int (*get_l4proto)(const struct sk_buff *skb, unsigned int nhoff,
 			   unsigned int *dataoff, u_int8_t *protonum);
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	int (*tuple_to_nlattr)(struct sk_buff *skb,
-			       const struct nf_conntrack_tuple *t);
-	int (*nlattr_to_tuple)(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t);
-	const struct nla_policy *nla_policy;
-#endif
-
 	/* Called when netns wants to use connection tracking */
 	int (*net_ns_get)(struct net *);
 	void (*net_ns_put)(struct net *);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 9db988f9a4d7..98ed12858c52 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -274,41 +274,6 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	return -ENOENT;
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nfnetlink_conntrack.h>
-
-static int ipv4_tuple_to_nlattr(struct sk_buff *skb,
-				const struct nf_conntrack_tuple *tuple)
-{
-	if (nla_put_in_addr(skb, CTA_IP_V4_SRC, tuple->src.u3.ip) ||
-	    nla_put_in_addr(skb, CTA_IP_V4_DST, tuple->dst.u3.ip))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static const struct nla_policy ipv4_nla_policy[CTA_IP_MAX+1] = {
-	[CTA_IP_V4_SRC]	= { .type = NLA_U32 },
-	[CTA_IP_V4_DST]	= { .type = NLA_U32 },
-};
-
-static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
-{
-	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
-		return -EINVAL;
-
-	t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
-	t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
-
-	return 0;
-}
-#endif
-
 static struct nf_sockopt_ops so_getorigdst = {
 	.pf		= PF_INET,
 	.get_optmin	= SO_ORIGINAL_DST,
@@ -360,13 +325,6 @@ const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
 	.invert_tuple	 = ipv4_invert_tuple,
 	.get_l4proto	 = ipv4_get_l4proto,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
-	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
-	.nla_policy	 = ipv4_nla_policy,
-	.nla_size	 = NLA_ALIGN(NLA_HDRLEN + sizeof(u32)) + /* CTA_IP_V4_SRC */
-			   NLA_ALIGN(NLA_HDRLEN + sizeof(u32)),  /* CTA_IP_V4_DST */
-#endif
 	.net_ns_get	 = ipv4_hooks_register,
 	.net_ns_put	 = ipv4_hooks_unregister,
 	.me		 = THIS_MODULE,
@@ -419,11 +377,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 
 	need_conntrack();
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	if (WARN_ON(nla_policy_len(ipv4_nla_policy, CTA_IP_MAX + 1) !=
-	    nf_conntrack_l3proto_ipv4.nla_size))
-		return -EINVAL;
-#endif
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret < 0) {
 		pr_err("Unable to register netfilter socket option\n");
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 663827ee3cf8..13a660ae5799 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -269,41 +269,6 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nfnetlink_conntrack.h>
-
-static int ipv6_tuple_to_nlattr(struct sk_buff *skb,
-				const struct nf_conntrack_tuple *tuple)
-{
-	if (nla_put_in6_addr(skb, CTA_IP_V6_SRC, &tuple->src.u3.in6) ||
-	    nla_put_in6_addr(skb, CTA_IP_V6_DST, &tuple->dst.u3.in6))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
-static const struct nla_policy ipv6_nla_policy[CTA_IP_MAX+1] = {
-	[CTA_IP_V6_SRC]	= { .len = sizeof(u_int32_t)*4 },
-	[CTA_IP_V6_DST]	= { .len = sizeof(u_int32_t)*4 },
-};
-
-static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
-{
-	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
-		return -EINVAL;
-
-	t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
-	t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
-
-	return 0;
-}
-#endif
-
 static int ipv6_hooks_register(struct net *net)
 {
 	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
@@ -345,13 +310,6 @@ const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.pkt_to_tuple		= ipv6_pkt_to_tuple,
 	.invert_tuple		= ipv6_invert_tuple,
 	.get_l4proto		= ipv6_get_l4proto,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= ipv6_tuple_to_nlattr,
-	.nlattr_to_tuple	= ipv6_nlattr_to_tuple,
-	.nla_policy		= ipv6_nla_policy,
-	.nla_size		= NLA_ALIGN(NLA_HDRLEN + sizeof(u32[4])) +
-				  NLA_ALIGN(NLA_HDRLEN + sizeof(u32[4])),
-#endif
 	.net_ns_get		= ipv6_hooks_register,
 	.net_ns_put		= ipv6_hooks_unregister,
 	.me			= THIS_MODULE,
@@ -409,12 +367,6 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 
 	need_conntrack();
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	if (WARN_ON(nla_policy_len(ipv6_nla_policy, CTA_IP_MAX + 1) !=
-	    nf_conntrack_l3proto_ipv6.nla_size))
-		return -EINVAL;
-#endif
-
 	ret = nf_register_sockopt(&so_getorigdst6);
 	if (ret < 0) {
 		pr_err("Unable to register netfilter socket option\n");
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index c87b48359e8f..e631be25337e 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -23,7 +23,6 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 #endif
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 853b23206bb7..3f586ba23d92 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -610,7 +610,6 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
-		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
 		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
 				       expect->tuple.dst.protonum));
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a75b11c39312..a55a58c706a9 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -24,7 +24,6 @@
 #include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 20a2e37c76d1..40152b9ad772 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -38,7 +38,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_acct.h>
@@ -81,9 +80,26 @@ static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 	return -1;
 }
 
+static int ipv4_tuple_to_nlattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *tuple)
+{
+	if (nla_put_in_addr(skb, CTA_IP_V4_SRC, tuple->src.u3.ip) ||
+	    nla_put_in_addr(skb, CTA_IP_V4_DST, tuple->dst.u3.ip))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int ipv6_tuple_to_nlattr(struct sk_buff *skb,
+				const struct nf_conntrack_tuple *tuple)
+{
+	if (nla_put_in6_addr(skb, CTA_IP_V6_SRC, &tuple->src.u3.in6) ||
+	    nla_put_in6_addr(skb, CTA_IP_V6_DST, &tuple->dst.u3.in6))
+		return -EMSGSIZE;
+	return 0;
+}
+
 static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
-				    const struct nf_conntrack_tuple *tuple,
-				    const struct nf_conntrack_l3proto *l3proto)
+				    const struct nf_conntrack_tuple *tuple)
 {
 	int ret = 0;
 	struct nlattr *nest_parms;
@@ -92,8 +108,14 @@ static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (likely(l3proto->tuple_to_nlattr))
-		ret = l3proto->tuple_to_nlattr(skb, tuple);
+	switch (tuple->src.l3num) {
+	case NFPROTO_IPV4:
+		ret = ipv4_tuple_to_nlattr(skb, tuple);
+		break;
+	case NFPROTO_IPV6:
+		ret = ipv6_tuple_to_nlattr(skb, tuple);
+		break;
+	}
 
 	nla_nest_end(skb, nest_parms);
 
@@ -106,13 +128,11 @@ static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
 static int ctnetlink_dump_tuples(struct sk_buff *skb,
 				 const struct nf_conntrack_tuple *tuple)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	int ret;
 
 	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
-	ret = ctnetlink_dump_tuples_ip(skb, tuple, l3proto);
+	ret = ctnetlink_dump_tuples_ip(skb, tuple);
 
 	if (ret >= 0) {
 		l4proto = __nf_ct_l4proto_find(tuple->src.l3num,
@@ -556,15 +576,20 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
+static const struct nla_policy cta_ip_nla_policy[CTA_IP_MAX + 1] = {
+	[CTA_IP_V4_SRC]	= { .type = NLA_U32 },
+	[CTA_IP_V4_DST]	= { .type = NLA_U32 },
+	[CTA_IP_V6_SRC]	= { .len = sizeof(__be32) * 4 },
+	[CTA_IP_V6_DST]	= { .len = sizeof(__be32) * 4 },
+};
+
 #if defined(CONFIG_NETFILTER_NETLINK_GLUE_CT) || defined(CONFIG_NF_CONNTRACK_EVENTS)
 static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	size_t len, len4 = 0;
 
-	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
-	len = l3proto->nla_size;
+	len = nla_policy_len(cta_ip_nla_policy, CTA_IP_MAX + 1);
 	len *= 3u; /* ORIG, REPLY, MASTER */
 
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
@@ -936,29 +961,54 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
+				struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
+		return -EINVAL;
+
+	t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
+	t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
+
+	return 0;
+}
+
+static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
+				struct nf_conntrack_tuple *t)
+{
+	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
+		return -EINVAL;
+
+	t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
+	t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
+
+	return 0;
+}
+
 static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
 				    struct nf_conntrack_tuple *tuple)
 {
 	struct nlattr *tb[CTA_IP_MAX+1];
-	struct nf_conntrack_l3proto *l3proto;
 	int ret = 0;
 
 	ret = nla_parse_nested(tb, CTA_IP_MAX, attr, NULL, NULL);
 	if (ret < 0)
 		return ret;
 
-	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
+	ret = nla_validate_nested(attr, CTA_IP_MAX,
+				  cta_ip_nla_policy, NULL);
+	if (ret)
+		return ret;
 
-	if (likely(l3proto->nlattr_to_tuple)) {
-		ret = nla_validate_nested(attr, CTA_IP_MAX,
-					  l3proto->nla_policy, NULL);
-		if (ret == 0)
-			ret = l3proto->nlattr_to_tuple(tb, tuple);
+	switch (tuple->src.l3num) {
+	case NFPROTO_IPV4:
+		ret = ipv4_nlattr_to_tuple(tb, tuple);
+		break;
+	case NFPROTO_IPV6:
+		ret = ipv6_nlattr_to_tuple(tb, tuple);
+		break;
 	}
 
-	rcu_read_unlock();
-
 	return ret;
 }
 
@@ -2581,7 +2631,6 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 				   const struct nf_conntrack_tuple *tuple,
 				   const struct nf_conntrack_tuple_mask *mask)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple m;
 	struct nlattr *nest_parms;
@@ -2597,8 +2646,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
-	ret = ctnetlink_dump_tuples_ip(skb, &m, l3proto);
+	ret = ctnetlink_dump_tuples_ip(skb, &m);
 	if (ret >= 0) {
 		l4proto = __nf_ct_l4proto_find(tuple->src.l3num,
 					       tuple->dst.protonum);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index d88841fbc560..859cb303bb91 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -294,10 +294,7 @@ int nf_ct_l3proto_register(const struct nf_conntrack_l3proto *proto)
 
 	if (proto->l3proto >= NFPROTO_NUMPROTO)
 		return -EBUSY;
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	if (proto->tuple_to_nlattr && proto->nla_size == 0)
-		return -EINVAL;
-#endif
+
 	mutex_lock(&nf_ct_proto_mutex);
 	old = rcu_dereference_protected(nf_ct_l3protos[proto->l3proto],
 					lockdep_is_held(&nf_ct_proto_mutex));
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b642c0b2495c..47b80fd0d2c3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -24,7 +24,6 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -38,10 +37,9 @@ MODULE_LICENSE("GPL");
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 void
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
-            const struct nf_conntrack_l3proto *l3proto,
             const struct nf_conntrack_l4proto *l4proto)
 {
-	switch (l3proto->l3proto) {
+	switch (tuple->src.l3num) {
 	case NFPROTO_IPV4:
 		seq_printf(s, "src=%pI4 dst=%pI4 ",
 			   &tuple->src.u3.ip, &tuple->dst.u3.ip);
@@ -282,7 +280,6 @@ static int ct_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_tuple_hash *hash = v;
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(hash);
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	struct net *net = seq_file_net(s);
 	int ret = 0;
@@ -303,14 +300,12 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (!net_eq(nf_ct_net(ct), net))
 		goto release;
 
-	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
-	WARN_ON(!l3proto);
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	WARN_ON(!l4proto);
 
 	ret = -ENOSPC;
 	seq_printf(s, "%-8s %u %-8s %u ",
-		   l3proto_name(l3proto->l3proto), nf_ct_l3num(ct),
+		   l3proto_name(nf_ct_l3num(ct)), nf_ct_l3num(ct),
 		   l4proto_name(l4proto->l4proto), nf_ct_protonum(ct));
 
 	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
@@ -320,7 +315,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		l4proto->print_conntrack(s, ct);
 
 	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-		    l3proto, l4proto);
+		    l4proto);
 
 	ct_show_zone(s, ct, NF_CT_ZONE_DIR_ORIG);
 
@@ -333,8 +328,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
 		seq_puts(s, "[UNREPLIED] ");
 
-	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
-		    l3proto, l4proto);
+	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, l4proto);
 
 	ct_show_zone(s, ct, NF_CT_ZONE_DIR_REPL);
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 9ee5fa551fa6..9da4b8462004 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -26,7 +26,6 @@
 #include <net/sock.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
-- 
2.11.0
