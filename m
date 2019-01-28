From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/33] netfilter: conntrack: gre: switch module to be built-in
Date: Tue, 29 Jan 2019 00:57:27 +0100
Message-ID: <20190128235750.18412-11-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This makes the last of the modular l4 trackers 'bool'.

After this, all infrastructure to handle dynamic l4 protocol registration
becomes obsolete and can be removed in followup patches.

Old:
302824 net/netfilter/nf_conntrack.ko
 21504 net/netfilter/nf_conntrack_proto_gre.ko

New:
313728 net/netfilter/nf_conntrack.ko

Old:
   text	   data	    bss	    dec	    hex	filename
   6281	   1732	      4	   8017	   1f51	nf_conntrack_proto_gre.ko
 108356	  20613	    236	 129205	  1f8b5	nf_conntrack.ko
New:
 112095	  21381	    240	 133716	  20a54	nf_conntrack.ko

The size increase is only temporary.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_proto_gre.h | 14 +---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h   |  3 +
 include/net/netfilter/nf_conntrack_l4proto.h     |  7 ++
 include/net/netns/conntrack.h                    | 17 +++++
 net/netfilter/Kconfig                            |  2 +-
 net/netfilter/Makefile                           |  3 +-
 net/netfilter/nf_conntrack_proto.c               |  7 +-
 net/netfilter/nf_conntrack_proto_gre.c           | 93 +++++-------------------
 net/netfilter/nfnetlink_cttimeout.c              |  7 +-
 9 files changed, 55 insertions(+), 98 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 222c9d3d453f..59714e9ee4ef 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -22,23 +22,11 @@ struct nf_ct_gre_keymap {
 	struct rcu_head rcu;
 };
 
-enum grep_conntrack {
-	GRE_CT_UNREPLIED,
-	GRE_CT_REPLIED,
-	GRE_CT_MAX
-};
-
-struct netns_proto_gre {
-	struct nf_proto_net	nf;
-	rwlock_t		keymap_lock;
-	struct list_head	keymap_list;
-	unsigned int		gre_timeouts[GRE_CT_MAX];
-};
-
 /* add new tuple->key_reply pair to keymap */
 int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			 struct nf_conntrack_tuple *t);
 
+void nf_ct_gre_keymap_flush(struct net *net);
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 135ee702c7b0..2c8c2b023848 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -22,5 +22,8 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp;
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
+#endif
 
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 46d554806eb3..fded3f164dcc 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -239,4 +239,11 @@ static inline struct nf_sctp_net *nf_sctp_pernet(struct net *net)
 }
 #endif
 
+#ifdef CONFIG_NF_CT_PROTO_GRE
+static inline struct nf_gre_net *nf_gre_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.gre;
+}
+#endif
+
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 51cba0b8adf5..c72f413a2d4d 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -70,6 +70,20 @@ struct nf_sctp_net {
 };
 #endif
 
+#ifdef CONFIG_NF_CT_PROTO_GRE
+enum gre_conntrack {
+	GRE_CT_UNREPLIED,
+	GRE_CT_REPLIED,
+	GRE_CT_MAX
+};
+
+struct nf_gre_net {
+	struct nf_proto_net	nf;
+	struct list_head	keymap_list;
+	unsigned int		timeouts[GRE_CT_MAX];
+};
+#endif
+
 struct nf_ip_net {
 	struct nf_generic_net   generic;
 	struct nf_tcp_net	tcp;
@@ -82,6 +96,9 @@ struct nf_ip_net {
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	struct nf_sctp_net	sctp;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	struct nf_gre_net	gre;
+#endif
 };
 
 struct ct_pcpu {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index beb3a69ce1d4..fefd63a243f2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -174,7 +174,7 @@ config NF_CT_PROTO_DCCP
 	  If unsure, say Y.
 
 config NF_CT_PROTO_GRE
-	tristate
+	bool
 
 config NF_CT_PROTO_SCTP
 	bool 'SCTP protocol connection tracking support'
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1ae65a314d7a..e66067befa42 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -13,6 +13,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) += nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
+nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
@@ -25,8 +26,6 @@ obj-$(CONFIG_NETFILTER_NETLINK_OSF) += nfnetlink_osf.o
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
 
-obj-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
-
 # netlink interface for nf_conntrack
 obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
 obj-$(CONFIG_NF_CT_NETLINK_TIMEOUT) += nfnetlink_cttimeout.o
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 2bbc32d939e4..e113bb2dc88d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -817,6 +817,9 @@ static const struct nf_conntrack_l4proto * const builtin_l4proto[] = {
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	&nf_conntrack_l4proto_udplite,
 #endif
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	&nf_conntrack_l4proto_gre,
+#endif
 #if IS_ENABLED(CONFIG_IPV6)
 	&nf_conntrack_l4proto_icmpv6,
 #endif /* CONFIG_IPV6 */
@@ -897,9 +900,11 @@ void nf_conntrack_proto_pernet_fini(struct net *net)
 					ARRAY_SIZE(builtin_l4proto));
 	pn->users--;
 	nf_ct_l4proto_unregister_sysctl(pn);
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	nf_ct_gre_keymap_flush(net);
+#endif
 }
 
-
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 34dd89485be2..68f9bfb79c4e 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -48,18 +48,17 @@ static const unsigned int gre_timeouts[GRE_CT_MAX] = {
 	[GRE_CT_REPLIED]	= 180*HZ,
 };
 
-static unsigned int proto_gre_net_id __read_mostly;
 /* used when expectation is added */
 static DEFINE_SPINLOCK(keymap_lock);
 
-static inline struct netns_proto_gre *gre_pernet(struct net *net)
+static inline struct nf_gre_net *gre_pernet(struct net *net)
 {
-	return net_generic(net, proto_gre_net_id);
+	return &net->ct.nf_ct_proto.gre;
 }
 
-static void nf_ct_gre_keymap_flush(struct net *net)
+void nf_ct_gre_keymap_flush(struct net *net)
 {
-	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_gre_net *net_gre = gre_pernet(net);
 	struct nf_ct_gre_keymap *km, *tmp;
 
 	spin_lock_bh(&keymap_lock);
@@ -83,7 +82,7 @@ static inline int gre_key_cmpfn(const struct nf_ct_gre_keymap *km,
 /* look up the source key for a given tuple */
 static __be16 gre_keymap_lookup(struct net *net, struct nf_conntrack_tuple *t)
 {
-	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_gre_net *net_gre = gre_pernet(net);
 	struct nf_ct_gre_keymap *km;
 	__be16 key = 0;
 
@@ -105,7 +104,7 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			 struct nf_conntrack_tuple *t)
 {
 	struct net *net = nf_ct_net(ct);
-	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_gre_net *net_gre = gre_pernet(net);
 	struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
 	struct nf_ct_gre_keymap **kmp, *km;
 
@@ -210,7 +209,7 @@ static void gre_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 static unsigned int *gre_get_timeouts(struct net *net)
 {
-	return gre_pernet(net)->gre_timeouts;
+	return gre_pernet(net)->timeouts;
 }
 
 /* Returns verdict for packet, and may modify conntrack */
@@ -272,13 +271,13 @@ static int gre_timeout_nlattr_to_obj(struct nlattr *tb[],
 				     struct net *net, void *data)
 {
 	unsigned int *timeouts = data;
-	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_gre_net *net_gre = gre_pernet(net);
 
 	if (!timeouts)
 		timeouts = gre_get_timeouts(net);
 	/* set default timeouts for GRE. */
-	timeouts[GRE_CT_UNREPLIED] = net_gre->gre_timeouts[GRE_CT_UNREPLIED];
-	timeouts[GRE_CT_REPLIED] = net_gre->gre_timeouts[GRE_CT_REPLIED];
+	timeouts[GRE_CT_UNREPLIED] = net_gre->timeouts[GRE_CT_UNREPLIED];
+	timeouts[GRE_CT_REPLIED] = net_gre->timeouts[GRE_CT_REPLIED];
 
 	if (tb[CTA_TIMEOUT_GRE_UNREPLIED]) {
 		timeouts[GRE_CT_UNREPLIED] =
@@ -332,10 +331,11 @@ static struct ctl_table gre_sysctl_table[] = {
 };
 #endif
 
-static int gre_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *nf,
-				    struct netns_proto_gre *net_gre)
+static int gre_kmemdup_sysctl_table(struct net *net)
 {
 #ifdef CONFIG_SYSCTL
+	struct nf_gre_net *net_gre = gre_pernet(net);
+	struct nf_proto_net *nf = &net_gre->nf;
 	int i;
 
 	if (nf->ctl_table)
@@ -348,26 +348,25 @@ static int gre_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *nf,
 		return -ENOMEM;
 
 	for (i = 0; i < GRE_CT_MAX; i++)
-		nf->ctl_table[i].data = &net_gre->gre_timeouts[i];
+		nf->ctl_table[i].data = &net_gre->timeouts[i];
 #endif
 	return 0;
 }
 
 static int gre_init_net(struct net *net)
 {
-	struct netns_proto_gre *net_gre = gre_pernet(net);
-	struct nf_proto_net *nf = &net_gre->nf;
+	struct nf_gre_net *net_gre = gre_pernet(net);
 	int i;
 
 	INIT_LIST_HEAD(&net_gre->keymap_list);
 	for (i = 0; i < GRE_CT_MAX; i++)
-		net_gre->gre_timeouts[i] = gre_timeouts[i];
+		net_gre->timeouts[i] = gre_timeouts[i];
 
-	return gre_kmemdup_sysctl_table(net, nf, net_gre);
+	return gre_kmemdup_sysctl_table(net);
 }
 
 /* protocol helper struct */
-static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 	.l4proto	 = IPPROTO_GRE,
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
@@ -391,61 +390,5 @@ static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 		.nla_policy	= gre_timeout_nla_policy,
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-	.net_id		= &proto_gre_net_id,
 	.init_net	= gre_init_net,
 };
-
-static int proto_gre_net_init(struct net *net)
-{
-	int ret = 0;
-
-	ret = nf_ct_l4proto_pernet_register_one(net,
-						&nf_conntrack_l4proto_gre4);
-	if (ret < 0)
-		pr_err("nf_conntrack_gre4: pernet registration failed.\n");
-	return ret;
-}
-
-static void proto_gre_net_exit(struct net *net)
-{
-	nf_ct_l4proto_pernet_unregister_one(net, &nf_conntrack_l4proto_gre4);
-	nf_ct_gre_keymap_flush(net);
-}
-
-static struct pernet_operations proto_gre_net_ops = {
-	.init = proto_gre_net_init,
-	.exit = proto_gre_net_exit,
-	.id   = &proto_gre_net_id,
-	.size = sizeof(struct netns_proto_gre),
-};
-
-static int __init nf_ct_proto_gre_init(void)
-{
-	int ret;
-
-	BUILD_BUG_ON(offsetof(struct netns_proto_gre, nf) != 0);
-
-	ret = register_pernet_subsys(&proto_gre_net_ops);
-	if (ret < 0)
-		goto out_pernet;
-	ret = nf_ct_l4proto_register_one(&nf_conntrack_l4proto_gre4);
-	if (ret < 0)
-		goto out_gre4;
-
-	return 0;
-out_gre4:
-	unregister_pernet_subsys(&proto_gre_net_ops);
-out_pernet:
-	return ret;
-}
-
-static void __exit nf_ct_proto_gre_fini(void)
-{
-	nf_ct_l4proto_unregister_one(&nf_conntrack_l4proto_gre4);
-	unregister_pernet_subsys(&proto_gre_net_ops);
-}
-
-module_init(nf_ct_proto_gre_init);
-module_exit(nf_ct_proto_gre_fini);
-
-MODULE_LICENSE("GPL");
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 109b0d27345a..0e3e1a018206 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -474,12 +474,7 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 		break;
 	case IPPROTO_GRE:
 #ifdef CONFIG_NF_CT_PROTO_GRE
-		if (l4proto->net_id) {
-			struct netns_proto_gre *net_gre;
-
-			net_gre = net_generic(net, *l4proto->net_id);
-			timeouts = net_gre->gre_timeouts;
-		}
+		timeouts = nf_gre_pernet(net)->timeouts;
 #endif
 		break;
 	case 255:
-- 
2.11.0
