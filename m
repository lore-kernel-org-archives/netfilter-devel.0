From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/33] netfilter: conntrack: fix IPV6=n builds
Date: Tue, 29 Jan 2019 00:57:44 +0100
Message-ID: <20190128235750.18412-28-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Stephen Rothwell reports:
 After merging the netfilter-next tree, today's linux-next build
 (powerpc ppc64_defconfig) failed like this:

 ERROR: "nf_conntrack_invert_icmpv6_tuple" [nf_conntrack.ko] undefined!
 ERROR: "nf_conntrack_icmpv6_packet" [nf_conntrack.ko] undefined!
 ERROR: "nf_conntrack_icmpv6_init_net" [nf_conntrack.ko] undefined!
 ERROR: "icmpv6_pkt_to_tuple" [nf_conntrack.ko] undefined!
 ERROR: "nf_ct_gre_keymap_destroy" [nf_conntrack.ko] undefined!

icmpv6 related errors are due to lack of IS_ENABLED(CONFIG_IPV6) (no
icmpv6 support is builtin if kernel has CONFIG_IPV6=n), the
nf_ct_gre_keymap_destroy error is due to lack of PROTO_GRE check.

Fixes: a47c54048162 ("netfilter: conntrack: handle builtin l4proto packet functions via direct calls")
Fixes: e2e48b471634 ("netfilter: conntrack: handle icmp pkt_to_tuple helper via direct calls")
Fixes: 197c4300aec0 ("netfilter: conntrack: remove invert_tuple callback")
Fixes: 2a389de86e4a ("netfilter: conntrack: remove l4proto init and get_net callbacks")
Fixes: e56894356f60 ("netfilter: conntrack: remove l4proto destroy hook")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c  | 8 ++++++++
 net/netfilter/nf_conntrack_proto.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 171659aa69a1..a3e5232c2088 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -274,8 +274,10 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
 	switch (protonum) {
+#if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6:
 		return icmpv6_pkt_to_tuple(skb, dataoff, net, tuple);
+#endif
 	case IPPROTO_ICMP:
 		return icmp_pkt_to_tuple(skb, dataoff, net, tuple);
 #ifdef CONFIG_NF_CT_PROTO_GRE
@@ -412,8 +414,10 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 	switch (orig->dst.protonum) {
 	case IPPROTO_ICMP:
 		return nf_conntrack_invert_icmp_tuple(inverse, orig);
+#if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6:
 		return nf_conntrack_invert_icmpv6_tuple(inverse, orig);
+#endif
 	}
 
 	inverse->src.u.all = orig->dst.u.all;
@@ -526,10 +530,12 @@ EXPORT_SYMBOL_GPL(nf_ct_tmpl_free);
 
 static void destroy_gre_conntrack(struct nf_conn *ct)
 {
+#ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_conn *master = ct->master;
 
 	if (master)
 		nf_ct_gre_keymap_destroy(master);
+#endif
 }
 
 static void
@@ -1553,8 +1559,10 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 					       ctinfo, state);
 	case IPPROTO_ICMP:
 		return nf_conntrack_icmp_packet(ct, skb, ctinfo, state);
+#if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6:
 		return nf_conntrack_icmpv6_packet(ct, skb, ctinfo, state);
+#endif
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	case IPPROTO_UDPLITE:
 		return nf_conntrack_udplite_packet(ct, skb, dataoff,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index aa8d3fe0b37f..b9403a266a2e 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -597,7 +597,9 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 	nf_conntrack_udp_init_net(net);
 	nf_conntrack_tcp_init_net(net);
 	nf_conntrack_icmp_init_net(net);
+#if IS_ENABLED(CONFIG_IPV6)
 	nf_conntrack_icmpv6_init_net(net);
+#endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	nf_conntrack_dccp_init_net(net);
 #endif
-- 
2.11.0
