From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/31] netfilter: conntrack: remove l3->l4 mapping information
Date: Tue,  9 Oct 2018 01:01:14 +0200
Message-ID: <20181008230125.2330-21-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

l4 protocols are demuxed by l3num, l4num pair.

However, almost all l4 trackers are l3 agnostic.

Only exceptions are:
 - gre, icmp (ipv4 only)
 - icmpv6 (ipv6 only)

This commit gets rid of the l3 mapping, l4 trackers can now be looked up
by their IPPROTO_XXX value alone, which gets rid of the additional l3
indirection.

For icmp, ipcmp6 and gre, add a check on state->pf and
return -NF_ACCEPT in case we're asked to track e.g. icmpv6-in-ipv4,
this seems more fitting than using the generic tracker.

Additionally we can kill the 2nd l4proto definitions that were needed
for v4/v6 split -- they are now the same so we can use single l4proto
struct for each protocol, rather than two.

The EXPORT_SYMBOLs can be removed as all these object files are
part of nf_conntrack with no external references.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |  13 ++--
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |  13 ----
 include/net/netfilter/nf_conntrack_l4proto.h   |   9 +--
 net/netfilter/nf_conntrack_core.c              |  15 ++--
 net/netfilter/nf_conntrack_expect.c            |   3 +-
 net/netfilter/nf_conntrack_netlink.c           |  14 ++--
 net/netfilter/nf_conntrack_proto.c             | 104 +++++++------------------
 net/netfilter/nf_conntrack_proto_dccp.c        |  35 +--------
 net/netfilter/nf_conntrack_proto_generic.c     |   1 -
 net/netfilter/nf_conntrack_proto_gre.c         |   4 +-
 net/netfilter/nf_conntrack_proto_icmp.c        |   6 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c      |   6 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |  36 +--------
 net/netfilter/nf_conntrack_proto_tcp.c         |  37 +--------
 net/netfilter/nf_conntrack_proto_udp.c         |  62 +--------------
 net/netfilter/nf_conntrack_standalone.c        |   2 +-
 net/netfilter/nf_flow_table_core.c             |   2 +-
 net/netfilter/nfnetlink_cttimeout.c            |  11 +--
 net/netfilter/nft_ct.c                         |   2 +-
 net/netfilter/xt_CT.c                          |   2 +-
 20 files changed, 76 insertions(+), 301 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index c84b51682f08..135ee702c7b0 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -10,20 +10,17 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite;
 #endif
 
-int nf_conntrack_ipv4_compat_init(void);
-void nf_conntrack_ipv4_compat_fini(void);
-
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index effa8dfba68c..7b3c873f8839 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -2,20 +2,7 @@
 #ifndef _NF_CONNTRACK_IPV6_H
 #define _NF_CONNTRACK_IPV6_H
 
-extern const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
-
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
-#ifdef CONFIG_NF_CT_PROTO_DCCP
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6;
-#endif
-#ifdef CONFIG_NF_CT_PROTO_SCTP
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6;
-#endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
-#endif
 
 #include <linux/sysctl.h>
 extern struct ctl_table nf_ct_ipv6_sysctl_table[];
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 420823a8648f..d838a93430a1 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -18,9 +18,6 @@
 struct seq_file;
 
 struct nf_conntrack_l4proto {
-	/* L3 Protocol number. */
-	u_int16_t l3proto;
-
 	/* L4 Protocol number. */
 	u_int8_t l4proto;
 
@@ -107,11 +104,9 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
 #define MAX_NF_CT_PROTO 256
 
-const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u_int16_t l3proto,
-						  u_int8_t l4proto);
+const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto);
 
-const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u_int16_t l3proto,
-						    u_int8_t l4proto);
+const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4proto);
 void nf_ct_l4proto_put(const struct nf_conntrack_l4proto *p);
 
 /* Protocol pernet registration. */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 087bf63826fb..ca1168d67fac 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -379,7 +379,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		return false;
 	}
 
-	l4proto = __nf_ct_l4proto_find(l3num, protonum);
+	l4proto = __nf_ct_l4proto_find(protonum);
 
 	ret = nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, net, tuple,
 			      l4proto);
@@ -539,7 +539,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 		nf_ct_tmpl_free(ct);
 		return;
 	}
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->destroy)
 		l4proto->destroy(ct);
 
@@ -840,7 +840,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	enum ip_conntrack_info oldinfo;
 	struct nf_conn *loser_ct = nf_ct_get(skb, &oldinfo);
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->allow_clash &&
 	    !nf_ct_is_dying(ct) &&
 	    atomic_inc_not_zero(&ct->ct_general.use)) {
@@ -1109,7 +1109,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->can_early_drop && l4proto->can_early_drop(ct))
 		return true;
 
@@ -1549,7 +1549,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		goto out;
 	}
 
-	l4proto = __nf_ct_l4proto_find(state->pf, protonum);
+	l4proto = __nf_ct_l4proto_find(protonum);
 
 	if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
 		ret = nf_conntrack_handle_icmp(tmpl, skb, dataoff,
@@ -1618,8 +1618,7 @@ bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 
 	rcu_read_lock();
 	ret = nf_ct_invert_tuple(inverse, orig,
-				 __nf_ct_l4proto_find(orig->src.l3num,
-						      orig->dst.protonum));
+				 __nf_ct_l4proto_find(orig->dst.protonum));
 	rcu_read_unlock();
 	return ret;
 }
@@ -1776,7 +1775,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	if (dataoff <= 0)
 		return -1;
 
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+	l4proto = nf_ct_l4proto_find_get(l4num);
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
 			     l4num, net, &tuple, l4proto))
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 27b84231db10..3034038bfdf0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -610,8 +610,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
-		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
-				       expect->tuple.dst.protonum));
+		    __nf_ct_l4proto_find(expect->tuple.dst.protonum));
 
 	if (expect->flags & NF_CT_EXPECT_PERMANENT) {
 		seq_puts(s, "PERMANENT");
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f8c74f31aa36..099a450e26be 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -135,8 +135,7 @@ static int ctnetlink_dump_tuples(struct sk_buff *skb,
 	ret = ctnetlink_dump_tuples_ip(skb, tuple);
 
 	if (ret >= 0) {
-		l4proto = __nf_ct_l4proto_find(tuple->src.l3num,
-					       tuple->dst.protonum);
+		l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
 		ret = ctnetlink_dump_tuples_proto(skb, tuple, l4proto);
 	}
 	rcu_read_unlock();
@@ -184,7 +183,7 @@ static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 	struct nlattr *nest_proto;
 	int ret;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (!l4proto->to_nlattr)
 		return 0;
 
@@ -592,7 +591,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 	len = nla_policy_len(cta_ip_nla_policy, CTA_IP_MAX + 1);
 	len *= 3u; /* ORIG, REPLY, MASTER */
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	len += l4proto->nlattr_size;
 	if (l4proto->nlattr_tuple_size) {
 		len4 = l4proto->nlattr_tuple_size();
@@ -1054,7 +1053,7 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
 	rcu_read_lock();
-	l4proto = __nf_ct_l4proto_find(tuple->src.l3num, tuple->dst.protonum);
+	l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
 
 	if (likely(l4proto->nlattr_to_tuple)) {
 		ret = nla_validate_nested(attr, CTA_PROTO_MAX,
@@ -1702,7 +1701,7 @@ static int ctnetlink_change_protoinfo(struct nf_conn *ct,
 		return err;
 
 	rcu_read_lock();
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->from_nlattr)
 		err = l4proto->from_nlattr(tb, ct);
 	rcu_read_unlock();
@@ -2662,8 +2661,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	rcu_read_lock();
 	ret = ctnetlink_dump_tuples_ip(skb, &m);
 	if (ret >= 0) {
-		l4proto = __nf_ct_l4proto_find(tuple->src.l3num,
-					       tuple->dst.protonum);
+		l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
 	}
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 06a182a23d92..69d7170cfa8c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -43,7 +43,7 @@
 
 extern unsigned int nf_conntrack_net_id;
 
-static struct nf_conntrack_l4proto __rcu **nf_ct_protos[NFPROTO_NUMPROTO] __read_mostly;
+static struct nf_conntrack_l4proto __rcu *nf_ct_protos[MAX_NF_CT_PROTO] __read_mostly;
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
@@ -124,23 +124,21 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_log_invalid);
 #endif
 
-const struct nf_conntrack_l4proto *
-__nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto)
+const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto)
 {
-	if (unlikely(l3proto >= NFPROTO_NUMPROTO || nf_ct_protos[l3proto] == NULL))
+	if (unlikely(l4proto >= ARRAY_SIZE(nf_ct_protos)))
 		return &nf_conntrack_l4proto_generic;
 
-	return rcu_dereference(nf_ct_protos[l3proto][l4proto]);
+	return rcu_dereference(nf_ct_protos[l4proto]);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_l4proto_find);
 
-const struct nf_conntrack_l4proto *
-nf_ct_l4proto_find_get(u_int16_t l3num, u_int8_t l4num)
+const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4num)
 {
 	const struct nf_conntrack_l4proto *p;
 
 	rcu_read_lock();
-	p = __nf_ct_l4proto_find(l3num, l4num);
+	p = __nf_ct_l4proto_find(l4num);
 	if (!try_module_get(p->me))
 		p = &nf_conntrack_l4proto_generic;
 	rcu_read_unlock();
@@ -159,8 +157,7 @@ static int kill_l4proto(struct nf_conn *i, void *data)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	l4proto = data;
-	return nf_ct_protonum(i) == l4proto->l4proto &&
-	       nf_ct_l3num(i) == l4proto->l3proto;
+	return nf_ct_protonum(i) == l4proto->l4proto;
 }
 
 static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
@@ -219,48 +216,20 @@ int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
 {
 	int ret = 0;
 
-	if (l4proto->l3proto >= ARRAY_SIZE(nf_ct_protos))
-		return -EBUSY;
-
 	if ((l4proto->to_nlattr && l4proto->nlattr_size == 0) ||
 	    (l4proto->tuple_to_nlattr && !l4proto->nlattr_tuple_size))
 		return -EINVAL;
 
 	mutex_lock(&nf_ct_proto_mutex);
-	if (!nf_ct_protos[l4proto->l3proto]) {
-		/* l3proto may be loaded latter. */
-		struct nf_conntrack_l4proto __rcu **proto_array;
-		int i;
-
-		proto_array =
-			kmalloc_array(MAX_NF_CT_PROTO,
-				      sizeof(struct nf_conntrack_l4proto *),
-				      GFP_KERNEL);
-		if (proto_array == NULL) {
-			ret = -ENOMEM;
-			goto out_unlock;
-		}
-
-		for (i = 0; i < MAX_NF_CT_PROTO; i++)
-			RCU_INIT_POINTER(proto_array[i],
-					 &nf_conntrack_l4proto_generic);
-
-		/* Before making proto_array visible to lockless readers,
-		 * we must make sure its content is committed to memory.
-		 */
-		smp_wmb();
-
-		nf_ct_protos[l4proto->l3proto] = proto_array;
-	} else if (rcu_dereference_protected(
-			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+	if (rcu_dereference_protected(
+			nf_ct_protos[l4proto->l4proto],
 			lockdep_is_held(&nf_ct_proto_mutex)
 			) != &nf_conntrack_l4proto_generic) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
-			   l4proto);
+	rcu_assign_pointer(nf_ct_protos[l4proto->l4proto], l4proto);
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 	return ret;
@@ -296,13 +265,13 @@ EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register_one);
 static void __nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
 
 {
-	BUG_ON(l4proto->l3proto >= ARRAY_SIZE(nf_ct_protos));
+	BUG_ON(l4proto->l4proto >= ARRAY_SIZE(nf_ct_protos));
 
 	BUG_ON(rcu_dereference_protected(
-			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+			nf_ct_protos[l4proto->l4proto],
 			lockdep_is_held(&nf_ct_proto_mutex)
 			) != l4proto);
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+	rcu_assign_pointer(nf_ct_protos[l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
 }
 
@@ -352,7 +321,7 @@ static int
 nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 		       unsigned int num_proto)
 {
-	int ret = -EINVAL, ver;
+	int ret = -EINVAL;
 	unsigned int i;
 
 	for (i = 0; i < num_proto; i++) {
@@ -361,9 +330,8 @@ nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 			break;
 	}
 	if (i != num_proto) {
-		ver = l4proto[i]->l3proto == PF_INET6 ? 6 : 4;
-		pr_err("nf_conntrack_ipv%d: can't register l4 %d proto.\n",
-		       ver, l4proto[i]->l4proto);
+		pr_err("nf_conntrack: can't register l4 %d proto.\n",
+		       l4proto[i]->l4proto);
 		nf_ct_l4proto_unregister(l4proto, i);
 	}
 	return ret;
@@ -382,9 +350,8 @@ int nf_ct_l4proto_pernet_register(struct net *net,
 			break;
 	}
 	if (i != num_proto) {
-		pr_err("nf_conntrack_proto_%d %d: pernet registration failed\n",
-		       l4proto[i]->l4proto,
-		       l4proto[i]->l3proto == PF_INET6 ? 6 : 4);
+		pr_err("nf_conntrack %d: pernet registration failed\n",
+		       l4proto[i]->l4proto);
 		nf_ct_l4proto_pernet_unregister(net, l4proto, i);
 	}
 	return ret;
@@ -911,37 +878,26 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 EXPORT_SYMBOL_GPL(nf_ct_netns_put);
 
 static const struct nf_conntrack_l4proto * const builtin_l4proto[] = {
-	&nf_conntrack_l4proto_tcp4,
-	&nf_conntrack_l4proto_udp4,
+	&nf_conntrack_l4proto_tcp,
+	&nf_conntrack_l4proto_udp,
 	&nf_conntrack_l4proto_icmp,
 #ifdef CONFIG_NF_CT_PROTO_DCCP
-	&nf_conntrack_l4proto_dccp4,
+	&nf_conntrack_l4proto_dccp,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-	&nf_conntrack_l4proto_sctp4,
+	&nf_conntrack_l4proto_sctp,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	&nf_conntrack_l4proto_udplite4,
+	&nf_conntrack_l4proto_udplite,
 #endif
 #if IS_ENABLED(CONFIG_IPV6)
-	&nf_conntrack_l4proto_tcp6,
-	&nf_conntrack_l4proto_udp6,
 	&nf_conntrack_l4proto_icmpv6,
-#ifdef CONFIG_NF_CT_PROTO_DCCP
-	&nf_conntrack_l4proto_dccp6,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_SCTP
-	&nf_conntrack_l4proto_sctp6,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	&nf_conntrack_l4proto_udplite6,
-#endif
 #endif /* CONFIG_IPV6 */
 };
 
 int nf_conntrack_proto_init(void)
 {
-	int ret = 0;
+	int ret = 0, i;
 
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret < 0)
@@ -952,6 +908,11 @@ int nf_conntrack_proto_init(void)
 	if (ret < 0)
 		goto cleanup_sockopt;
 #endif
+
+	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
+		RCU_INIT_POINTER(nf_ct_protos[i],
+				 &nf_conntrack_l4proto_generic);
+
 	ret = nf_ct_l4proto_register(builtin_l4proto,
 				     ARRAY_SIZE(builtin_l4proto));
 	if (ret < 0)
@@ -969,17 +930,10 @@ int nf_conntrack_proto_init(void)
 
 void nf_conntrack_proto_fini(void)
 {
-	unsigned int i;
-
 	nf_unregister_sockopt(&so_getorigdst);
 #if IS_ENABLED(CONFIG_IPV6)
 	nf_unregister_sockopt(&so_getorigdst6);
 #endif
-	/* No need to call nf_ct_l4proto_unregister(), the register
-	 * tables are free'd here anyway.
-	 */
-	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
-		kfree(nf_ct_protos[i]);
 }
 
 int nf_conntrack_proto_pernet_init(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index d22852ae2316..171e9e122e5f 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -842,8 +842,7 @@ static struct nf_proto_net *dccp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.dccp.pn;
 }
 
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
-	.l3proto		= AF_INET,
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
 	.packet			= dccp_packet,
 	.can_early_drop		= dccp_can_early_drop,
@@ -871,35 +870,3 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.init_net		= dccp_init_net,
 	.get_net_proto		= dccp_get_net_proto,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp4);
-
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
-	.l3proto		= AF_INET6,
-	.l4proto		= IPPROTO_DCCP,
-	.packet			= dccp_packet,
-	.can_early_drop		= dccp_can_early_drop,
-#ifdef CONFIG_NF_CONNTRACK_PROCFS
-	.print_conntrack	= dccp_print_conntrack,
-#endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_size		= DCCP_NLATTR_SIZE,
-	.to_nlattr		= dccp_to_nlattr,
-	.from_nlattr		= nlattr_to_dccp,
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= dccp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= dccp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_DCCP_MAX,
-		.obj_size	= sizeof(unsigned int) * CT_DCCP_MAX,
-		.nla_policy	= dccp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= dccp_init_net,
-	.get_net_proto		= dccp_get_net_proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp6);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 4530f76b51bd..e10e867e0b55 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -153,7 +153,6 @@ static struct nf_proto_net *generic_get_net_proto(struct net *net)
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
-	.l3proto		= PF_UNSPEC,
 	.l4proto		= 255,
 	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.packet			= generic_packet,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 810039dcd779..9b48dc8b4b88 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -238,6 +238,9 @@ static int gre_packet(struct nf_conn *ct,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state)
 {
+	if (state->pf != NFPROTO_IPV4)
+		return -NF_ACCEPT;
+
 	if (!nf_ct_is_confirmed(ct)) {
 		unsigned int *timeouts = nf_ct_timeout_lookup(ct);
 
@@ -344,7 +347,6 @@ static int gre_init_net(struct net *net)
 
 /* protocol helper struct */
 static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
-	.l3proto	 = AF_INET,
 	.l4proto	 = IPPROTO_GRE,
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a9d2769f72d8..3598520bd19b 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -90,6 +90,9 @@ static int icmp_packet(struct nf_conn *ct,
 		[ICMP_ADDRESS] = 1
 	};
 
+	if (state->pf != NFPROTO_IPV4)
+		return -NF_ACCEPT;
+
 	if (ct->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new) ||
 	    !valid_new[ct->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
@@ -131,7 +134,7 @@ icmp_error_message(struct nf_conn *tmpl, struct sk_buff *skb,
 	}
 
 	/* rcu_read_lock()ed by nf_hook_thresh */
-	innerproto = __nf_ct_l4proto_find(PF_INET, origtuple.dst.protonum);
+	innerproto = __nf_ct_l4proto_find(origtuple.dst.protonum);
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
@@ -349,7 +352,6 @@ static struct nf_proto_net *icmp_get_net_proto(struct net *net)
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
-	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_ICMP,
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 8a88db599d66..378618feed5d 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -103,6 +103,9 @@ static int icmpv6_packet(struct nf_conn *ct,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
 
+	if (state->pf != NFPROTO_IPV6)
+		return -NF_ACCEPT;
+
 	if (!nf_ct_is_confirmed(ct)) {
 		int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
 
@@ -150,7 +153,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	}
 
 	/* rcu_read_lock()ed by nf_hook_thresh */
-	inproto = __nf_ct_l4proto_find(PF_INET6, origtuple.dst.protonum);
+	inproto = __nf_ct_l4proto_find(origtuple.dst.protonum);
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
@@ -360,7 +363,6 @@ static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
-	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_ICMPV6,
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 9cf59ab280c0..3d719d3eb9a3 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -759,8 +759,7 @@ static struct nf_proto_net *sctp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.sctp.pn;
 }
 
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
-	.l3proto		= PF_INET,
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
 	.l4proto 		= IPPROTO_SCTP,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
@@ -789,36 +788,3 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.init_net		= sctp_init_net,
 	.get_net_proto		= sctp_get_net_proto,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp4);
-
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
-	.l3proto		= PF_INET6,
-	.l4proto 		= IPPROTO_SCTP,
-#ifdef CONFIG_NF_CONNTRACK_PROCFS
-	.print_conntrack	= sctp_print_conntrack,
-#endif
-	.packet 		= sctp_packet,
-	.can_early_drop		= sctp_can_early_drop,
-	.me 			= THIS_MODULE,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_size		= SCTP_NLATTR_SIZE,
-	.to_nlattr		= sctp_to_nlattr,
-	.from_nlattr		= nlattr_to_sctp,
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= sctp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= sctp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_SCTP_MAX,
-		.obj_size	= sizeof(unsigned int) * SCTP_CONNTRACK_MAX,
-		.nla_policy	= sctp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= sctp_init_net,
-	.get_net_proto		= sctp_get_net_proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp6);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index f4954fa7be25..643e4edfa0c1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1534,9 +1534,8 @@ static struct nf_proto_net *tcp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.tcp.pn;
 }
 
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
 {
-	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_TCP,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
@@ -1565,37 +1564,3 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 	.init_net		= tcp_init_net,
 	.get_net_proto		= tcp_get_net_proto,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp4);
-
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
-{
-	.l3proto		= PF_INET6,
-	.l4proto 		= IPPROTO_TCP,
-#ifdef CONFIG_NF_CONNTRACK_PROCFS
-	.print_conntrack 	= tcp_print_conntrack,
-#endif
-	.packet 		= tcp_packet,
-	.can_early_drop		= tcp_can_early_drop,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_size		= TCP_NLATTR_SIZE,
-	.to_nlattr		= tcp_to_nlattr,
-	.from_nlattr		= nlattr_to_tcp,
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nlattr_tuple_size	= tcp_nlattr_tuple_size,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= tcp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= tcp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_TCP_MAX,
-		.obj_size	= sizeof(unsigned int) *
-					TCP_CONNTRACK_TIMEOUT_MAX,
-		.nla_policy	= tcp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= tcp_init_net,
-	.get_net_proto		= tcp_get_net_proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp6);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 4645bf5b20c8..a7aa70370913 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -310,9 +310,8 @@ static struct nf_proto_net *udp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.udp.pn;
 }
 
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
 {
-	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.packet			= udp_packet,
@@ -334,12 +333,10 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite =
 {
-	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
 	.packet			= udplite_packet,
@@ -361,59 +358,4 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite4);
-#endif
-
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
-{
-	.l3proto		= PF_INET6,
-	.l4proto		= IPPROTO_UDP,
-	.allow_clash		= true,
-	.packet			= udp_packet,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_UDP_MAX,
-		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
-		.nla_policy	= udp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= udp_init_net,
-	.get_net_proto		= udp_get_net_proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);
-
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
-{
-	.l3proto		= PF_INET6,
-	.l4proto		= IPPROTO_UDPLITE,
-	.allow_clash		= true,
-	.packet			= udplite_packet,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_UDP_MAX,
-		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
-		.nla_policy	= udp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.init_net		= udp_init_net,
-	.get_net_proto		= udp_get_net_proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite6);
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e3b329ebafd3..463d17d349c1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -292,7 +292,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (!net_eq(nf_ct_net(ct), net))
 		goto release;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
 	WARN_ON(!l4proto);
 
 	ret = -ENOSPC;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d8125616edc7..0c233cfcc84d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -120,7 +120,7 @@ static void flow_offload_fixup_ct_state(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP)
 		flow_offload_fixup_tcp(&ct->proto.tcp);
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), l4num);
+	l4proto = __nf_ct_l4proto_find(l4num);
 	if (!l4proto)
 		return;
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 6ca0df7f416f..b48545b84ce8 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -122,7 +122,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		return -EBUSY;
 	}
 
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+	l4proto = nf_ct_l4proto_find_get(l4num);
 
 	/* This protocol is not supportted, skip. */
 	if (l4proto->l4proto != l4num) {
@@ -361,7 +361,7 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 
 	l3num = ntohs(nla_get_be16(cda[CTA_TIMEOUT_L3PROTO]));
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+	l4proto = nf_ct_l4proto_find_get(l4num);
 
 	/* This protocol is not supported, skip. */
 	if (l4proto->l4proto != l4num) {
@@ -383,7 +383,7 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 
 static int
 cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
-			    u32 seq, u32 type, int event,
+			    u32 seq, u32 type, int event, u16 l3num,
 			    const struct nf_conntrack_l4proto *l4proto)
 {
 	struct nlmsghdr *nlh;
@@ -402,7 +402,7 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	nfmsg->version = NFNETLINK_V0;
 	nfmsg->res_id = 0;
 
-	if (nla_put_be16(skb, CTA_TIMEOUT_L3PROTO, htons(l4proto->l3proto)) ||
+	if (nla_put_be16(skb, CTA_TIMEOUT_L3PROTO, htons(l3num)) ||
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto))
 		goto nla_put_failure;
 
@@ -442,7 +442,7 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 
 	l3num = ntohs(nla_get_be16(cda[CTA_TIMEOUT_L3PROTO]));
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+	l4proto = nf_ct_l4proto_find_get(l4num);
 
 	/* This protocol is not supported, skip. */
 	if (l4proto->l4proto != l4num) {
@@ -460,6 +460,7 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 					  nlh->nlmsg_seq,
 					  NFNL_MSG_TYPE(nlh->nlmsg_type),
 					  IPCTNL_MSG_TIMEOUT_DEFAULT_SET,
+					  l3num,
 					  l4proto);
 	if (ret <= 0) {
 		kfree_skb(skb2);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 17ae5059c312..d74afa70774f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -855,7 +855,7 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 	l4num = nla_get_u8(tb[NFTA_CT_TIMEOUT_L4PROTO]);
 	priv->l4proto = l4num;
 
-	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+	l4proto = nf_ct_l4proto_find_get(l4num);
 
 	if (l4proto->l4proto != l4num) {
 		ret = -EOPNOTSUPP;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 89457efd2e00..2c7a4b80206f 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -159,7 +159,7 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	/* Make sure the timeout policy matches any existing protocol tracker,
 	 * otherwise default to generic.
 	 */
-	l4proto = __nf_ct_l4proto_find(par->family, proto);
+	l4proto = __nf_ct_l4proto_find(proto);
 	if (timeout->l4proto->l4proto != l4proto->l4proto) {
 		ret = -EINVAL;
 		pr_info_ratelimited("Timeout policy `%s' can only be used by L%d protocol number %d\n",
-- 
2.11.0
