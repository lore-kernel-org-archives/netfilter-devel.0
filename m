From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/12] netfilter: conntrack: timeout interface depend on CONFIG_NF_CONNTRACK_TIMEOUT
Date: Tue, 11 Sep 2018 02:20:41 +0200
Message-ID: <20180911002044.9100-10-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Now that cttimeout support for nft_ct is in place, these should depend
on CONFIG_NF_CONNTRACK_TIMEOUT otherwise we can crash when dumping the
policy if this option is not enabled.

[   71.600121] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[...]
[   71.600141] CPU: 3 PID: 7612 Comm: nft Not tainted 4.18.0+ #246
[...]
[   71.600188] Call Trace:
[   71.600201]  ? nft_ct_timeout_obj_dump+0xc6/0xf0 [nft_ct]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c    | 12 ++++++------
 net/netfilter/nf_conntrack_proto_generic.c |  8 ++++----
 net/netfilter/nf_conntrack_proto_gre.c     |  8 ++++----
 net/netfilter/nf_conntrack_proto_icmp.c    |  8 ++++----
 net/netfilter/nf_conntrack_proto_icmpv6.c  |  8 ++++----
 net/netfilter/nf_conntrack_proto_sctp.c    | 14 +++++++-------
 net/netfilter/nf_conntrack_proto_tcp.c     | 12 ++++++------
 net/netfilter/nf_conntrack_proto_udp.c     | 20 ++++++++++----------
 8 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b81f70039828..f3f91ed2c21a 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -675,7 +675,7 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -728,7 +728,7 @@ dccp_timeout_nla_policy[CTA_TIMEOUT_DCCP_MAX+1] = {
 	[CTA_TIMEOUT_DCCP_CLOSING]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_DCCP_TIMEWAIT]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 /* template, data assigned later */
@@ -863,7 +863,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= dccp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= dccp_timeout_obj_to_nlattr,
@@ -871,7 +871,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 		.obj_size	= sizeof(unsigned int) * CT_DCCP_MAX,
 		.nla_policy	= dccp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= dccp_init_net,
 	.get_net_proto		= dccp_get_net_proto,
 };
@@ -896,7 +896,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= dccp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= dccp_timeout_obj_to_nlattr,
@@ -904,7 +904,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 		.obj_size	= sizeof(unsigned int) * CT_DCCP_MAX,
 		.nla_policy	= dccp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= dccp_init_net,
 	.get_net_proto		= dccp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index ac4a0b296dcd..1df3244ecd07 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -70,7 +70,7 @@ static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -113,7 +113,7 @@ static const struct nla_policy
 generic_timeout_nla_policy[CTA_TIMEOUT_GENERIC_MAX+1] = {
 	[CTA_TIMEOUT_GENERIC_TIMEOUT]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table generic_sysctl_table[] = {
@@ -164,7 +164,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.packet			= generic_packet,
 	.new			= generic_new,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= generic_timeout_obj_to_nlattr,
@@ -172,7 +172,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 		.obj_size	= sizeof(unsigned int),
 		.nla_policy	= generic_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= generic_init_net,
 	.get_net_proto		= generic_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index d1632252bf5b..650eb4fba2c5 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -285,7 +285,7 @@ static void gre_destroy(struct nf_conn *ct)
 		nf_ct_gre_keymap_destroy(master);
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -334,7 +334,7 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 	[CTA_TIMEOUT_GRE_UNREPLIED]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_GRE_REPLIED]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 static int gre_init_net(struct net *net, u_int16_t proto)
 {
@@ -367,7 +367,7 @@ static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 	.nlattr_to_tuple = nf_ct_port_nlattr_to_tuple,
 	.nla_policy	 = nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout    = {
 		.nlattr_to_obj	= gre_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= gre_timeout_obj_to_nlattr,
@@ -375,7 +375,7 @@ static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 		.obj_size	= sizeof(unsigned int) * GRE_CT_MAX,
 		.nla_policy	= gre_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.net_id		= &proto_gre_net_id,
 	.init_net	= gre_init_net,
 };
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 036670b38282..43c7e1a217b9 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -273,7 +273,7 @@ static unsigned int icmp_nlattr_tuple_size(void)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -313,7 +313,7 @@ static const struct nla_policy
 icmp_timeout_nla_policy[CTA_TIMEOUT_ICMP_MAX+1] = {
 	[CTA_TIMEOUT_ICMP_TIMEOUT]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table icmp_sysctl_table[] = {
@@ -374,7 +374,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
 	.nla_policy		= icmp_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= icmp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= icmp_timeout_obj_to_nlattr,
@@ -382,7 +382,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 		.obj_size	= sizeof(unsigned int),
 		.nla_policy	= icmp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= icmp_init_net,
 	.get_net_proto		= icmp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index bed07b998a10..97e40f77d678 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -274,7 +274,7 @@ static unsigned int icmpv6_nlattr_tuple_size(void)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -314,7 +314,7 @@ static const struct nla_policy
 icmpv6_timeout_nla_policy[CTA_TIMEOUT_ICMPV6_MAX+1] = {
 	[CTA_TIMEOUT_ICMPV6_TIMEOUT]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table icmpv6_sysctl_table[] = {
@@ -373,7 +373,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 	.nlattr_to_tuple	= icmpv6_nlattr_to_tuple,
 	.nla_policy		= icmpv6_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= icmpv6_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= icmpv6_timeout_obj_to_nlattr,
@@ -381,7 +381,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 		.obj_size	= sizeof(unsigned int),
 		.nla_policy	= icmpv6_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= icmpv6_init_net,
 	.get_net_proto		= icmpv6_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5eddfd32b852..e4d738d34cd0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -591,7 +591,7 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -646,7 +646,7 @@ sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 
 #ifdef CONFIG_SYSCTL
@@ -780,7 +780,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= sctp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= sctp_timeout_obj_to_nlattr,
@@ -788,7 +788,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 		.obj_size	= sizeof(unsigned int) * SCTP_CONNTRACK_MAX,
 		.nla_policy	= sctp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= sctp_init_net,
 	.get_net_proto		= sctp_get_net_proto,
 };
@@ -813,7 +813,8 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= sctp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= sctp_timeout_obj_to_nlattr,
@@ -821,8 +822,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 		.obj_size	= sizeof(unsigned int) * SCTP_CONNTRACK_MAX,
 		.nla_policy	= sctp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
-#endif
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= sctp_init_net,
 	.get_net_proto		= sctp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3e2dc56a96c3..b4bdf9eda7b7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1279,7 +1279,7 @@ static unsigned int tcp_nlattr_tuple_size(void)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -1394,7 +1394,7 @@ static const struct nla_policy tcp_timeout_nla_policy[CTA_TIMEOUT_TCP_MAX+1] = {
 	[CTA_TIMEOUT_TCP_RETRANS]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_TCP_UNACK]		= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table tcp_sysctl_table[] = {
@@ -1558,7 +1558,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 	.nlattr_size		= TCP_NLATTR_SIZE,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= tcp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= tcp_timeout_obj_to_nlattr,
@@ -1567,7 +1567,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 					TCP_CONNTRACK_TIMEOUT_MAX,
 		.nla_policy	= tcp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= tcp_init_net,
 	.get_net_proto		= tcp_get_net_proto,
 };
@@ -1593,7 +1593,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 	.nlattr_tuple_size	= tcp_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= tcp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= tcp_timeout_obj_to_nlattr,
@@ -1602,7 +1602,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 					TCP_CONNTRACK_TIMEOUT_MAX,
 		.nla_policy	= tcp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= tcp_init_net,
 	.get_net_proto		= tcp_get_net_proto,
 };
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 9272a2c525a8..3065fb8ef91b 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -171,7 +171,7 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_cttimeout.h>
@@ -221,7 +221,7 @@ udp_timeout_nla_policy[CTA_TIMEOUT_UDP_MAX+1] = {
        [CTA_TIMEOUT_UDP_UNREPLIED]	= { .type = NLA_U32 },
        [CTA_TIMEOUT_UDP_REPLIED]	= { .type = NLA_U32 },
 };
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table udp_sysctl_table[] = {
@@ -292,7 +292,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
@@ -300,7 +300,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
 		.nla_policy	= udp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
@@ -321,7 +321,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
@@ -329,7 +329,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
 		.nla_policy	= udp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
@@ -350,7 +350,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
@@ -358,7 +358,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
 		.nla_policy	= udp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
@@ -379,7 +379,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
 		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
@@ -387,7 +387,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
 		.nla_policy	= udp_timeout_nla_policy,
 	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	.init_net		= udp_init_net,
 	.get_net_proto		= udp_get_net_proto,
 };
-- 
2.11.0
