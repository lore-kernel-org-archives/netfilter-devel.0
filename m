From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/33] netfilter: conntrack: remove nf_ct_l4proto_find_get
Date: Tue, 29 Jan 2019 00:57:39 +0100
Message-ID: <20190128235750.18412-23-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its now same as __nf_ct_l4proto_find(), so rename that to
nf_ct_l4proto_find and use it everywhere.

It never returns NULL and doesn't need locks or reference counts.

Before this series:
302824  net/netfilter/nf_conntrack.ko
 21504  net/netfilter/nf_conntrack_proto_gre.ko

  text	   data	    bss	    dec	    hex	filename
  6281	   1732	      4	   8017	   1f51	nf_conntrack_proto_gre.ko
108356	  20613	    236	 129205	  1f8b5	nf_conntrack.ko

After:
294864  net/netfilter/nf_conntrack.ko
  text	   data	    bss	    dec	    hex	filename
106979	  19557	    240	 126776	  1ef38	nf_conntrack.ko

so, even with builtin gre, total size got reduced.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h    |   2 +-
 include/net/netfilter/nf_conntrack_l4proto.h |   8 +-
 net/netfilter/nf_conntrack_core.c            |  11 +-
 net/netfilter/nf_conntrack_expect.c          |   2 +-
 net/netfilter/nf_conntrack_netlink.c         |  14 +--
 net/netfilter/nf_conntrack_proto.c           | 175 ++++-----------------------
 net/netfilter/nf_conntrack_standalone.c      |   3 +-
 net/netfilter/nf_flow_table_core.c           |   2 +-
 net/netfilter/nfnetlink_cttimeout.c          |   6 +-
 net/netfilter/nft_ct.c                       |   2 +-
 net/netfilter/xt_CT.c                        |   2 +-
 11 files changed, 45 insertions(+), 182 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 235c182022b2..ae41e92251dd 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -26,7 +26,7 @@ int nf_conntrack_init_net(struct net *net);
 void nf_conntrack_cleanup_net(struct net *net);
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list);
 
-int nf_conntrack_proto_pernet_init(struct net *net);
+void nf_conntrack_proto_pernet_init(struct net *net);
 void nf_conntrack_proto_pernet_fini(struct net *net);
 
 int nf_conntrack_proto_init(void);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 5d1419ac6a38..778087591983 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -140,13 +140,7 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
 #define MAX_NF_CT_PROTO IPPROTO_UDPLITE
 
-const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto);
-
-const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4proto);
-
-/* Protocol global registration. */
-int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *proto);
-void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *proto);
+const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto);
 
 /* Generic netlink helpers */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 52e6c5c6f202..171659aa69a1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -845,7 +845,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	enum ip_conntrack_info oldinfo;
 	struct nf_conn *loser_ct = nf_ct_get(skb, &oldinfo);
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->allow_clash &&
 	    !nf_ct_is_dying(ct) &&
 	    atomic_inc_not_zero(&ct->ct_general.use)) {
@@ -1117,7 +1117,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->can_early_drop && l4proto->can_early_drop(ct))
 		return true;
 
@@ -2452,15 +2452,10 @@ int nf_conntrack_init_net(struct net *net)
 	nf_conntrack_tstamp_pernet_init(net);
 	nf_conntrack_ecache_pernet_init(net);
 	nf_conntrack_helper_pernet_init(net);
+	nf_conntrack_proto_pernet_init(net);
 
-	ret = nf_conntrack_proto_pernet_init(net);
-	if (ret < 0)
-		goto err_proto;
 	return 0;
 
-err_proto:
-	nf_conntrack_ecache_pernet_fini(net);
-	nf_conntrack_expect_pernet_fini(net);
 err_expect:
 	free_percpu(net->ct.stat);
 err_pcpu_lists:
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 3034038bfdf0..334d6e5b7762 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -610,7 +610,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
-		    __nf_ct_l4proto_find(expect->tuple.dst.protonum));
+		    nf_ct_l4proto_find(expect->tuple.dst.protonum));
 
 	if (expect->flags & NF_CT_EXPECT_PERMANENT) {
 		seq_puts(s, "PERMANENT");
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1213beb5a714..8071bb04a849 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -134,7 +134,7 @@ static int ctnetlink_dump_tuples(struct sk_buff *skb,
 	ret = ctnetlink_dump_tuples_ip(skb, tuple);
 
 	if (ret >= 0) {
-		l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
+		l4proto = nf_ct_l4proto_find(tuple->dst.protonum);
 		ret = ctnetlink_dump_tuples_proto(skb, tuple, l4proto);
 	}
 	rcu_read_unlock();
@@ -182,7 +182,7 @@ static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 	struct nlattr *nest_proto;
 	int ret;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (!l4proto->to_nlattr)
 		return 0;
 
@@ -590,7 +590,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 	len = nla_policy_len(cta_ip_nla_policy, CTA_IP_MAX + 1);
 	len *= 3u; /* ORIG, REPLY, MASTER */
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	len += l4proto->nlattr_size;
 	if (l4proto->nlattr_tuple_size) {
 		len4 = l4proto->nlattr_tuple_size();
@@ -1059,7 +1059,7 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
 	rcu_read_lock();
-	l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
+	l4proto = nf_ct_l4proto_find(tuple->dst.protonum);
 
 	if (likely(l4proto->nlattr_to_tuple)) {
 		ret = nla_validate_nested(attr, CTA_PROTO_MAX,
@@ -1722,11 +1722,9 @@ static int ctnetlink_change_protoinfo(struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	rcu_read_lock();
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (l4proto->from_nlattr)
 		err = l4proto->from_nlattr(tb, ct);
-	rcu_read_unlock();
 
 	return err;
 }
@@ -2676,7 +2674,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	rcu_read_lock();
 	ret = ctnetlink_dump_tuples_ip(skb, &m);
 	if (ret >= 0) {
-		l4proto = __nf_ct_l4proto_find(tuple->dst.protonum);
+		l4proto = nf_ct_l4proto_find(tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
 	}
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index e6bc02c13f0f..aa8d3fe0b37f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -43,8 +43,6 @@
 
 extern unsigned int nf_conntrack_net_id;
 
-static struct nf_conntrack_l4proto __rcu *nf_ct_protos[MAX_NF_CT_PROTO + 1] __read_mostly;
-
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
 #ifdef CONFIG_SYSCTL
@@ -95,121 +93,32 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_log_invalid);
 #endif
 
-const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto)
-{
-	if (unlikely(l4proto >= ARRAY_SIZE(nf_ct_protos)))
-		return &nf_conntrack_l4proto_generic;
-
-	return rcu_dereference(nf_ct_protos[l4proto]);
-}
-EXPORT_SYMBOL_GPL(__nf_ct_l4proto_find);
-
-const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4num)
-{
-	const struct nf_conntrack_l4proto *p;
-
-	rcu_read_lock();
-	p = __nf_ct_l4proto_find(l4num);
-	rcu_read_unlock();
-
-	return p;
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_find_get);
-
-static int kill_l4proto(struct nf_conn *i, void *data)
+const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 {
-	const struct nf_conntrack_l4proto *l4proto;
-	l4proto = data;
-	return nf_ct_protonum(i) == l4proto->l4proto;
-}
-
-/* FIXME: Allow NULL functions and sub in pointers to generic for
-   them. --RR */
-int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *l4proto)
-{
-	int ret = 0;
-
-	if ((l4proto->to_nlattr && l4proto->nlattr_size == 0) ||
-	    (l4proto->tuple_to_nlattr && !l4proto->nlattr_tuple_size))
-		return -EINVAL;
-
-	mutex_lock(&nf_ct_proto_mutex);
-	if (rcu_dereference_protected(
-			nf_ct_protos[l4proto->l4proto],
-			lockdep_is_held(&nf_ct_proto_mutex)
-			) != &nf_conntrack_l4proto_generic) {
-		ret = -EBUSY;
-		goto out_unlock;
+	switch (l4proto) {
+	case IPPROTO_UDP: return &nf_conntrack_l4proto_udp;
+	case IPPROTO_TCP: return &nf_conntrack_l4proto_tcp;
+	case IPPROTO_ICMP: return &nf_conntrack_l4proto_icmp;
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	case IPPROTO_DCCP: return &nf_conntrack_l4proto_dccp;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	case IPPROTO_SCTP: return &nf_conntrack_l4proto_sctp;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	case IPPROTO_UDPLITE: return &nf_conntrack_l4proto_udplite;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: return &nf_conntrack_l4proto_gre;
+#endif
+#if IS_ENABLED(CONFIG_IPV6)
+	case IPPROTO_ICMPV6: return &nf_conntrack_l4proto_icmpv6;
+#endif /* CONFIG_IPV6 */
 	}
 
-	rcu_assign_pointer(nf_ct_protos[l4proto->l4proto], l4proto);
-out_unlock:
-	mutex_unlock(&nf_ct_proto_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_register_one);
-
-static void __nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
-
-{
-	BUG_ON(l4proto->l4proto >= ARRAY_SIZE(nf_ct_protos));
-
-	BUG_ON(rcu_dereference_protected(
-			nf_ct_protos[l4proto->l4proto],
-			lockdep_is_held(&nf_ct_proto_mutex)
-			) != l4proto);
-	rcu_assign_pointer(nf_ct_protos[l4proto->l4proto],
-			   &nf_conntrack_l4proto_generic);
-}
-
-void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *l4proto)
-{
-	mutex_lock(&nf_ct_proto_mutex);
-	__nf_ct_l4proto_unregister_one(l4proto);
-	mutex_unlock(&nf_ct_proto_mutex);
-
-	synchronize_net();
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister_one);
-
-static void
-nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
-			 unsigned int num_proto)
-{
-	int i;
-
-	mutex_lock(&nf_ct_proto_mutex);
-	for (i = 0; i < num_proto; i++)
-		__nf_ct_l4proto_unregister_one(l4proto[i]);
-	mutex_unlock(&nf_ct_proto_mutex);
-
-	synchronize_net();
-
-	for (i = 0; i < num_proto; i++)
-		nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto[i]);
-}
-
-static int
-nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
-		       unsigned int num_proto)
-{
-	int ret = -EINVAL;
-	unsigned int i;
-
-	for (i = 0; i < num_proto; i++) {
-		ret = nf_ct_l4proto_register_one(l4proto[i]);
-		if (ret < 0)
-			break;
-	}
-	if (i != num_proto) {
-		pr_err("nf_conntrack: can't register l4 %d proto.\n",
-		       l4proto[i]->l4proto);
-		nf_ct_l4proto_unregister(l4proto, i);
-	}
-	return ret;
-}
+	return &nf_conntrack_l4proto_generic;
+};
+EXPORT_SYMBOL_GPL(nf_ct_l4proto_find);
 
 static unsigned int nf_confirm(struct sk_buff *skb,
 			       unsigned int protoff,
@@ -651,30 +560,9 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_netns_put);
 
-static const struct nf_conntrack_l4proto * const builtin_l4proto[] = {
-	&nf_conntrack_l4proto_tcp,
-	&nf_conntrack_l4proto_udp,
-	&nf_conntrack_l4proto_icmp,
-#ifdef CONFIG_NF_CT_PROTO_DCCP
-	&nf_conntrack_l4proto_dccp,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_SCTP
-	&nf_conntrack_l4proto_sctp,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	&nf_conntrack_l4proto_udplite,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_GRE
-	&nf_conntrack_l4proto_gre,
-#endif
-#if IS_ENABLED(CONFIG_IPV6)
-	&nf_conntrack_l4proto_icmpv6,
-#endif /* CONFIG_IPV6 */
-};
-
 int nf_conntrack_proto_init(void)
 {
-	int ret = 0, i;
+	int ret;
 
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret < 0)
@@ -686,18 +574,8 @@ int nf_conntrack_proto_init(void)
 		goto cleanup_sockopt;
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
-		RCU_INIT_POINTER(nf_ct_protos[i],
-				 &nf_conntrack_l4proto_generic);
-
-	ret = nf_ct_l4proto_register(builtin_l4proto,
-				     ARRAY_SIZE(builtin_l4proto));
-	if (ret < 0)
-		goto cleanup_sockopt2;
-
 	return ret;
-cleanup_sockopt2:
-	nf_unregister_sockopt(&so_getorigdst);
+
 #if IS_ENABLED(CONFIG_IPV6)
 cleanup_sockopt:
 	nf_unregister_sockopt(&so_getorigdst6);
@@ -713,7 +591,7 @@ void nf_conntrack_proto_fini(void)
 #endif
 }
 
-int nf_conntrack_proto_pernet_init(struct net *net)
+void nf_conntrack_proto_pernet_init(struct net *net)
 {
 	nf_conntrack_generic_init_net(net);
 	nf_conntrack_udp_init_net(net);
@@ -729,7 +607,6 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_conntrack_gre_init_net(net);
 #endif
-	return 0;
 }
 
 void nf_conntrack_proto_pernet_fini(struct net *net)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d848de713dc0..ddfca5f1784c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -310,8 +310,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (!net_eq(nf_ct_net(ct), net))
 		goto release;
 
-	l4proto = __nf_ct_l4proto_find(nf_ct_protonum(ct));
-	WARN_ON(!l4proto);
+	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 
 	ret = -ENOSPC;
 	seq_printf(s, "%-8s %u %-8s %u ",
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index fa0844e2a68d..8099f0f778ab 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -120,7 +120,7 @@ static void flow_offload_fixup_ct_state(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP)
 		flow_offload_fixup_tcp(&ct->proto.tcp);
 
-	l4proto = __nf_ct_l4proto_find(l4num);
+	l4proto = nf_ct_l4proto_find(l4num);
 	if (!l4proto)
 		return;
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 37b4f84ac153..c69b11ca5aad 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -122,7 +122,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		return -EBUSY;
 	}
 
-	l4proto = nf_ct_l4proto_find_get(l4num);
+	l4proto = nf_ct_l4proto_find(l4num);
 
 	/* This protocol is not supportted, skip. */
 	if (l4proto->l4proto != l4num) {
@@ -357,7 +357,7 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 		return -EINVAL;
 
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
-	l4proto = nf_ct_l4proto_find_get(l4num);
+	l4proto = nf_ct_l4proto_find(l4num);
 
 	/* This protocol is not supported, skip. */
 	if (l4proto->l4proto != l4num) {
@@ -438,7 +438,7 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 
 	l3num = ntohs(nla_get_be16(cda[CTA_TIMEOUT_L3PROTO]));
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
-	l4proto = nf_ct_l4proto_find_get(l4num);
+	l4proto = nf_ct_l4proto_find(l4num);
 
 	err = -EOPNOTSUPP;
 	if (l4proto->l4proto != l4num)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3249cc059048..7b717fad6cdc 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -870,7 +870,7 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 	l4num = nla_get_u8(tb[NFTA_CT_TIMEOUT_L4PROTO]);
 	priv->l4proto = l4num;
 
-	l4proto = nf_ct_l4proto_find_get(l4num);
+	l4proto = nf_ct_l4proto_find(l4num);
 
 	if (l4proto->l4proto != l4num) {
 		ret = -EOPNOTSUPP;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 2c7a4b80206f..0fa863f57575 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -159,7 +159,7 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	/* Make sure the timeout policy matches any existing protocol tracker,
 	 * otherwise default to generic.
 	 */
-	l4proto = __nf_ct_l4proto_find(proto);
+	l4proto = nf_ct_l4proto_find(proto);
 	if (timeout->l4proto->l4proto != l4proto->l4proto) {
 		ret = -EINVAL;
 		pr_info_ratelimited("Timeout policy `%s' can only be used by L%d protocol number %d\n",
-- 
2.11.0
