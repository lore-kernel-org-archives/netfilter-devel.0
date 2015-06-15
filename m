From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 04/15] netfilter: add pernet hook support
Date: Mon, 15 Jun 2015 17:46:46 +0200
Message-ID: <1434383217-13732-5-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36842 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbbFOPls (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:48 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the nf_register_hook() and nf_register_hooks() interfaces
to allow to register hooks at a pernet level.

This starts using init_net for all the existing callers though, so the full
conversion of existing netfilter hook clients to comes in follow up patches.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h                      |   27 +++++++++++++++---------
 include/linux/netfilter_ingress.h              |    6 +++---
 include/net/netns/netfilter.h                  |    1 +
 net/bridge/br_netfilter.c                      |    2 +-
 net/bridge/netfilter/ebtable_filter.c          |    3 ++-
 net/bridge/netfilter/ebtable_nat.c             |    3 ++-
 net/core/dev.c                                 |    6 ++++--
 net/decnet/netfilter/dn_rtmsg.c                |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    2 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c              |    2 +-
 net/ipv4/netfilter/iptable_nat.c               |    3 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    3 ++-
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |    2 +-
 net/ipv6/netfilter/ip6table_nat.c              |    3 ++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    3 ++-
 net/netfilter/core.c                           |   26 +++++++++++------------
 net/netfilter/ipvs/ip_vs_core.c                |    2 +-
 net/netfilter/nf_queue.c                       |    2 +-
 net/netfilter/nf_tables_api.c                  |    6 ++++--
 net/netfilter/x_tables.c                       |    2 +-
 security/selinux/hooks.c                       |    6 ++++--
 security/smack/smack_netfilter.c               |    3 ++-
 24 files changed, 70 insertions(+), 49 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 00050df..f3c1c21 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -52,11 +52,13 @@ struct nf_hook_state {
 	struct net_device *in;
 	struct net_device *out;
 	struct sock *sk;
+	struct net *net;
 	struct list_head *hook_list;
 	int (*okfn)(struct sock *, struct sk_buff *);
 };
 
 static inline void nf_hook_state_init(struct nf_hook_state *p,
+				      struct net *net,
 				      struct list_head *hook_list,
 				      unsigned int hook,
 				      int thresh, u_int8_t pf,
@@ -65,6 +67,7 @@ static inline void nf_hook_state_init(struct nf_hook_state *p,
 				      struct sock *sk,
 				      int (*okfn)(struct sock *, struct sk_buff *))
 {
+	p->net = net;
 	p->hook = hook;
 	p->thresh = thresh;
 	p->pf = pf;
@@ -118,9 +121,9 @@ struct nf_sockopt_ops {
 };
 
 /* Function to register/unregister hook points. */
-int nf_register_hook(struct nf_hook_ops *reg);
+int nf_register_hook(struct net *net, struct nf_hook_ops *reg);
 void nf_unregister_hook(struct nf_hook_ops *reg);
-int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n);
+int nf_register_hooks(struct net *net, struct nf_hook_ops *reg, unsigned int n);
 void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
 
 /* Functions to register get/setsockopt ranges (non-inclusive).  You
@@ -128,8 +131,6 @@ void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n);
 int nf_register_sockopt(struct nf_sockopt_ops *reg);
 void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 
-extern struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
-
 #ifdef HAVE_JUMP_LABEL
 extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 
@@ -150,9 +151,12 @@ static inline bool nf_hook_list_active(struct list_head *nf_hook_list,
 }
 #endif
 
-static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
+#include <linux/netdevice.h>
+
+static inline bool nf_hooks_active(struct net *net, u_int8_t pf,
+				   unsigned int hook)
 {
-	return nf_hook_list_active(&nf_hooks[pf][hook], pf, hook);
+	return nf_hook_list_active(&net->nf.hooks[pf][hook], pf, hook);
 }
 
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state);
@@ -172,11 +176,13 @@ static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 int (*okfn)(struct sock *, struct sk_buff *),
 				 int thresh)
 {
-	if (nf_hooks_active(pf, hook)) {
+	struct net *net = indev ? dev_net(indev) : dev_net(outdev);
+
+	if (nf_hooks_active(net, pf, hook)) {
 		struct nf_hook_state state;
 
-		nf_hook_state_init(&state, &nf_hooks[pf][hook], hook, thresh,
-				   pf, indev, outdev, sk, okfn);
+		nf_hook_state_init(&state, net, &net->nf.hooks[pf][hook], hook,
+				   thresh, pf, indev, outdev, sk, okfn);
 		return nf_hook_slow(skb, &state);
 	}
 	return 1;
@@ -339,7 +345,8 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, sk, skb, indev, outdev, okfn) (okfn)(sk, skb)
 #define NF_HOOK_COND(pf, hook, sk, skb, indev, outdev, okfn, cond) (okfn)(sk, skb)
-static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
+static inline int nf_hook_thresh(struct net *net,
+				 u_int8_t pf, unsigned int hook,
 				 struct sock *sk,
 				 struct sk_buff *skb,
 				 struct net_device *indev,
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index cb0727f..99a78e9 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -5,17 +5,17 @@
 #include <linux/netdevice.h>
 
 #ifdef CONFIG_NETFILTER_INGRESS
-static inline int nf_hook_ingress_active(struct sk_buff *skb)
+static inline int nf_hook_ingress_active(struct net *net, struct sk_buff *skb)
 {
 	return nf_hook_list_active(&skb->dev->nf_hooks_ingress,
 				   NFPROTO_NETDEV, NF_NETDEV_INGRESS);
 }
 
-static inline int nf_hook_ingress(struct sk_buff *skb)
+static inline int nf_hook_ingress(struct net *net, struct sk_buff *skb)
 {
 	struct nf_hook_state state;
 
-	nf_hook_state_init(&state, &skb->dev->nf_hooks_ingress,
+	nf_hook_state_init(&state, net, &skb->dev->nf_hooks_ingress,
 			   NF_NETDEV_INGRESS, INT_MIN, NFPROTO_NETDEV, NULL,
 			   skb->dev, NULL, NULL);
 	return nf_hook_slow(skb, &state);
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 532e4ba..38aa498 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -14,5 +14,6 @@ struct netns_nf {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
 #endif
+	struct list_head hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 };
 #endif
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index e4e5f2f..af14ef1 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -1246,7 +1246,7 @@ static int __init br_netfilter_init(void)
 {
 	int ret;
 
-	ret = nf_register_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	ret = nf_register_hooks(&init_net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	if (ret < 0)
 		return ret;
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 8a3f63b..9a5a798 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -119,7 +119,8 @@ static int __init ebtable_filter_init(void)
 	ret = register_pernet_subsys(&frame_filter_net_ops);
 	if (ret < 0)
 		return ret;
-	ret = nf_register_hooks(ebt_ops_filter, ARRAY_SIZE(ebt_ops_filter));
+	ret = nf_register_hooks(&init_net, ebt_ops_filter,
+				ARRAY_SIZE(ebt_ops_filter));
 	if (ret < 0)
 		unregister_pernet_subsys(&frame_filter_net_ops);
 	return ret;
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index c5ef5b1..3d2759d 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -119,7 +119,8 @@ static int __init ebtable_nat_init(void)
 	ret = register_pernet_subsys(&frame_nat_net_ops);
 	if (ret < 0)
 		return ret;
-	ret = nf_register_hooks(ebt_ops_nat, ARRAY_SIZE(ebt_ops_nat));
+	ret = nf_register_hooks(&init_net, ebt_ops_nat,
+				ARRAY_SIZE(ebt_ops_nat));
 	if (ret < 0)
 		unregister_pernet_subsys(&frame_nat_net_ops);
 	return ret;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6778a99..a176606 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3741,13 +3741,15 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 			     int *ret, struct net_device *orig_dev)
 {
 #ifdef CONFIG_NETFILTER_INGRESS
-	if (nf_hook_ingress_active(skb)) {
+	struct net *net = dev_net(orig_dev);
+
+	if (nf_hook_ingress_active(net, skb)) {
 		if (*pt_prev) {
 			*ret = deliver_skb(skb, *pt_prev, orig_dev);
 			*pt_prev = NULL;
 		}
 
-		return nf_hook_ingress(skb);
+		return nf_hook_ingress(net, skb);
 	}
 #endif /* CONFIG_NETFILTER_INGRESS */
 	return 0;
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index af34fc9..ba02eac 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -134,7 +134,7 @@ static int __init dn_rtmsg_init(void)
 		return -ENOMEM;
 	}
 
-	rv = nf_register_hook(&dnrmg_ops);
+	rv = nf_register_hook(&init_net, &dnrmg_ops);
 	if (rv) {
 		netlink_kernel_release(dnrmg);
 	}
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 45cb16a..cf23858 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -767,7 +767,7 @@ static int __init clusterip_tg_init(void)
 	if (ret < 0)
 		goto cleanup_subsys;
 
-	ret = nf_register_hook(&cip_arp_ops);
+	ret = nf_register_hook(&init_net, &cip_arp_ops);
 	if (ret < 0)
 		goto cleanup_target;
 
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index fe8cc18..a57d3d1 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -450,7 +450,7 @@ static int __init synproxy_tg4_init(void)
 {
 	int err;
 
-	err = nf_register_hooks(ipv4_synproxy_ops,
+	err = nf_register_hooks(&init_net, ipv4_synproxy_ops,
 				ARRAY_SIZE(ipv4_synproxy_ops));
 	if (err < 0)
 		goto err1;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 0d4d9cd..5ef83d3 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -131,7 +131,8 @@ static int __init iptable_nat_init(void)
 	if (err < 0)
 		goto err1;
 
-	err = nf_register_hooks(nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+	err = nf_register_hooks(&init_net, nf_nat_ipv4_ops,
+				ARRAY_SIZE(nf_nat_ipv4_ops));
 	if (err < 0)
 		goto err2;
 	return 0;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 30ad955..2384975 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -467,7 +467,7 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_sockopt;
 	}
 
-	ret = nf_register_hooks(ipv4_conntrack_ops,
+	ret = nf_register_hooks(&init_net, ipv4_conntrack_ops,
 				ARRAY_SIZE(ipv4_conntrack_ops));
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index c88b7d4..ad74929 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -110,7 +110,8 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 
 static int __init nf_defrag_init(void)
 {
-	return nf_register_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	return nf_register_hooks(&init_net, ipv4_defrag_ops,
+				 ARRAY_SIZE(ipv4_defrag_ops));
 }
 
 static void __exit nf_defrag_fini(void)
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 6edb7b1..ed5d4a6 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -473,7 +473,7 @@ static int __init synproxy_tg6_init(void)
 {
 	int err;
 
-	err = nf_register_hooks(ipv6_synproxy_ops,
+	err = nf_register_hooks(&init_net, ipv6_synproxy_ops,
 				ARRAY_SIZE(ipv6_synproxy_ops));
 	if (err < 0)
 		goto err1;
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index c3a7f7a..ecb0511 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -133,7 +133,8 @@ static int __init ip6table_nat_init(void)
 	if (err < 0)
 		goto err1;
 
-	err = nf_register_hooks(nf_nat_ipv6_ops, ARRAY_SIZE(nf_nat_ipv6_ops));
+	err = nf_register_hooks(&init_net, nf_nat_ipv6_ops,
+				ARRAY_SIZE(nf_nat_ipv6_ops));
 	if (err < 0)
 		goto err2;
 	return 0;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 4ba0c34..8bcf625 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -407,7 +407,7 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	if (ret < 0)
 		goto cleanup_sockopt;
 
-	ret = nf_register_hooks(ipv6_conntrack_ops,
+	ret = nf_register_hooks(&init_net, ipv6_conntrack_ops,
 				ARRAY_SIZE(ipv6_conntrack_ops));
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: can't register pre-routing defrag "
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index a45db0b..7bc330f 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -108,7 +108,8 @@ static int __init nf_defrag_init(void)
 		pr_err("nf_defrag_ipv6: can't initialize frag6.\n");
 		return ret;
 	}
-	ret = nf_register_hooks(ipv6_defrag_ops, ARRAY_SIZE(ipv6_defrag_ops));
+	ret = nf_register_hooks(&init_net, ipv6_defrag_ops,
+				ARRAY_SIZE(ipv6_defrag_ops));
 	if (ret < 0) {
 		pr_err("nf_defrag_ipv6: can't register hooks\n");
 		goto cleanup_frag6;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 653e32e..73c8ecb 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -52,9 +52,6 @@ void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
 
-struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly;
-EXPORT_SYMBOL(nf_hooks);
-
 #ifdef HAVE_JUMP_LABEL
 struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
@@ -62,7 +59,7 @@ EXPORT_SYMBOL(nf_hooks_needed);
 
 static DEFINE_MUTEX(nf_hook_mutex);
 
-int nf_register_hook(struct nf_hook_ops *reg)
+int nf_register_hook(struct net *net, struct nf_hook_ops *reg)
 {
 	struct list_head *nf_hook_list;
 	struct nf_hook_ops *elem;
@@ -80,7 +77,7 @@ int nf_register_hook(struct nf_hook_ops *reg)
 #endif
 		/* Fall through. */
 	default:
-		nf_hook_list = &nf_hooks[reg->pf][reg->hooknum];
+		nf_hook_list = &net->nf.hooks[reg->pf][reg->hooknum];
 		break;
 	}
 
@@ -121,13 +118,13 @@ void nf_unregister_hook(struct nf_hook_ops *reg)
 }
 EXPORT_SYMBOL(nf_unregister_hook);
 
-int nf_register_hooks(struct nf_hook_ops *reg, unsigned int n)
+int nf_register_hooks(struct net *net, struct nf_hook_ops *reg, unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
 
 	for (i = 0; i < n; i++) {
-		err = nf_register_hook(&reg[i]);
+		err = nf_register_hook(net, &reg[i]);
 		if (err)
 			goto err;
 	}
@@ -296,6 +293,13 @@ EXPORT_SYMBOL(nf_nat_decode_session_hook);
 
 static int __net_init netfilter_net_init(struct net *net)
 {
+	int i, h;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		for (h = 0; h < NF_MAX_HOOKS; h++)
+			INIT_LIST_HEAD(&net->nf.hooks[i][h]);
+	}
+
 #ifdef CONFIG_PROC_FS
 	net->nf.proc_netfilter = proc_net_mkdir(net, "netfilter",
 						net->proc_net);
@@ -306,6 +310,7 @@ static int __net_init netfilter_net_init(struct net *net)
 		return -ENOMEM;
 	}
 #endif
+
 	return 0;
 }
 
@@ -321,12 +326,7 @@ static struct pernet_operations netfilter_net_ops = {
 
 int __init netfilter_init(void)
 {
-	int i, h, ret;
-
-	for (i = 0; i < ARRAY_SIZE(nf_hooks); i++) {
-		for (h = 0; h < NF_MAX_HOOKS; h++)
-			INIT_LIST_HEAD(&nf_hooks[i][h]);
-	}
+	int ret;
 
 	ret = register_pernet_subsys(&netfilter_net_ops);
 	if (ret < 0)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 5d2b806..2751d5a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2088,7 +2088,7 @@ static int __init ip_vs_init(void)
 	if (ret < 0)
 		goto cleanup_sub;
 
-	ret = nf_register_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+	ret = nf_register_hooks(&init_net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	if (ret < 0) {
 		pr_err("can't register hooks.\n");
 		goto cleanup_dev;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 2e88032..ab077fe 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -196,7 +196,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	if (verdict == NF_ACCEPT) {
 	next_hook:
-		verdict = nf_iterate(&nf_hooks[entry->state.pf][entry->state.hook],
+		verdict = nf_iterate(entry->state.hook_list,
 				     skb, &entry->state, &elem);
 	}
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4528f12..a8d4044 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -566,7 +566,8 @@ static int nf_tables_table_enable(const struct nft_af_info *afi,
 		if (!(chain->flags & NFT_BASE_CHAIN))
 			continue;
 
-		err = nf_register_hooks(nft_base_chain(chain)->ops, afi->nops);
+		err = nf_register_hooks(&init_net, nft_base_chain(chain)->ops,
+					afi->nops);
 		if (err < 0)
 			goto err;
 
@@ -1418,7 +1419,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN) {
-		err = nf_register_hooks(nft_base_chain(chain)->ops, afi->nops);
+		err = nf_register_hooks(&init_net, nft_base_chain(chain)->ops,
+					afi->nops);
 		if (err < 0)
 			goto err1;
 	}
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6062ce3..0891564 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1201,7 +1201,7 @@ struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
 		++i;
 	}
 
-	ret = nf_register_hooks(ops, num_hooks);
+	ret = nf_register_hooks(&init_net, ops, num_hooks);
 	if (ret < 0) {
 		kfree(ops);
 		return ERR_PTR(ret);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7dade28..7246654 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6156,7 +6156,8 @@ static int __init selinux_nf_ip_init(void)
 
 	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
 
-	err = nf_register_hooks(selinux_nf_ops, ARRAY_SIZE(selinux_nf_ops));
+	err = nf_register_hooks(&init_net, selinux_nf_ops,
+				ARRAY_SIZE(selinux_nf_ops));
 	if (err)
 		panic("SELinux: nf_register_hooks: error %d\n", err);
 
@@ -6170,7 +6171,8 @@ static void selinux_nf_ip_exit(void)
 {
 	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
 
-	nf_unregister_hooks(selinux_nf_ops, ARRAY_SIZE(selinux_nf_ops));
+	nf_unregister_hooks(&init_net, selinux_nf_ops,
+			    ARRAY_SIZE(selinux_nf_ops));
 }
 #endif
 
diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
index a455cfc..e39f79e 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -82,7 +82,8 @@ static int __init smack_nf_ip_init(void)
 
 	printk(KERN_DEBUG "Smack: Registering netfilter hooks\n");
 
-	err = nf_register_hooks(smack_nf_ops, ARRAY_SIZE(smack_nf_ops));
+	err = nf_register_hooks(&init_net, smack_nf_ops,
+				ARRAY_SIZE(smack_nf_ops));
 	if (err)
 		pr_info("Smack: nf_register_hooks: error %d\n", err);
 
-- 
1.7.10.4

