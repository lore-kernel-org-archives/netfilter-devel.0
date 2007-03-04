From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/10]: nf_conntrack/nf_nat: fix incorrect config ifdefs
Date: Sun,  4 Mar 2007 21:20:00 +0100 (MET)
Message-ID: <20070304201908.28582.43204.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack/nf_nat: fix incorrect config ifdefs

The nf_conntrack_netlink config option is named CONFIG_NF_CT_NETLINK,
but multiple files use CONFIG_IP_NF_CONNTRACK_NETLINK or
CONFIG_NF_CONNTRACK_NETLINK for ifdefs.

Fix this and reformat all CONFIG_NF_CT_NETLINK ifdefs to only use a line.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e6ebc414bb13540bba508e404af7aa6b3e65e6f3
tree fc0e57dd55029b62245132beb180f081e4c84990
parent 3b0f1308568d67be761a89c95354cce8617e6715
author Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:21:03 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:21:03 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 ++----
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    6 ++----
 net/ipv4/netfilter/nf_nat_core.c               |    3 +--
 net/ipv4/netfilter/nf_nat_proto_gre.c          |    3 +--
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    3 +--
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |    3 +--
 net/ipv4/netfilter/nf_nat_proto_udp.c          |    3 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 ++----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    6 ++----
 net/netfilter/nf_conntrack_core.c              |    3 +--
 net/netfilter/nf_conntrack_proto_gre.c         |    3 +--
 net/netfilter/nf_conntrack_proto_tcp.c         |    9 +++------
 net/netfilter/nf_conntrack_proto_udp.c         |    6 ++----
 13 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index b984db7..8f3e92d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -379,8 +379,7 @@ getorigdst(struct sock *sk, int optval, 
 	return -ENOENT;
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -435,8 +434,7 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_conntrack = ipv4_print_conntrack,
 	.prepare	 = ipv4_prepare,
 	.get_features	 = ipv4_get_features,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr = ipv4_tuple_to_nfattr,
 	.nfattr_to_tuple = ipv4_nfattr_to_tuple,
 #endif
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 88cfa6a..5fd1e53 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -268,8 +268,7 @@ icmp_error(struct sk_buff *skb, unsigned
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -368,8 +367,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.error			= icmp_error,
 	.destroy		= NULL,
 	.me			= NULL,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 2c01378..452e9d3 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -546,8 +546,7 @@ void nf_nat_protocol_unregister(struct n
 }
 EXPORT_SYMBOL(nf_nat_protocol_unregister);
 
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 int
 nf_nat_port_range_to_nfattr(struct sk_buff *skb,
 			    const struct nf_nat_range *range)
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index d3de579..e5a34c1 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -152,8 +152,7 @@ static struct nf_nat_protocol gre __read
 	.manip_pkt		= gre_manip_pkt,
 	.in_range		= gre_in_range,
 	.unique_tuple		= gre_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 6bc2f06..f71ef9b 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -78,8 +78,7 @@ struct nf_nat_protocol nf_nat_protocol_i
 	.manip_pkt		= icmp_manip_pkt,
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 439164c..123c959 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -144,8 +144,7 @@ struct nf_nat_protocol nf_nat_protocol_t
 	.manip_pkt		= tcp_manip_pkt,
 	.in_range		= tcp_in_range,
 	.unique_tuple		= tcp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 8cae6e0..1c4c70e 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -134,8 +134,7 @@ struct nf_nat_protocol nf_nat_protocol_u
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= udp_in_range,
 	.unique_tuple		= udp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 4b7be4b..6f19c4a 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -353,8 +353,7 @@ static ctl_table nf_ct_ipv6_sysctl_table
 };
 #endif
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -403,8 +402,7 @@ struct nf_conntrack_l3proto nf_conntrack
 	.print_tuple		= ipv6_print_tuple,
 	.print_conntrack	= ipv6_print_conntrack,
 	.prepare		= ipv6_prepare,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= ipv6_tuple_to_nfattr,
 	.nfattr_to_tuple	= ipv6_nfattr_to_tuple,
 #endif
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 21f19cc..075da4f 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -244,8 +244,7 @@ icmpv6_error(struct sk_buff *skb, unsign
 	return icmpv6_error_message(skb, dataoff, ctinfo, hooknum);
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -327,8 +326,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.packet			= icmpv6_packet,
 	.new			= icmpv6_new,
 	.error			= icmpv6_error,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= icmpv6_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmpv6_nfattr_to_tuple,
 #endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4fdf484..b3a70eb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -976,8 +976,7 @@ #endif
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index ac193ce..5434472 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -281,8 +281,7 @@ static struct nf_conntrack_l4proto nf_co
 	.new		 = gre_new,
 	.destroy	 = gre_destroy,
 	.me 		 = THIS_MODULE,
-#if defined(CONFIG_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr = nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple = nf_ct_port_nfattr_to_tuple,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 069b85c..3b9ad7f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1099,8 +1099,7 @@ #endif
 	return 1;
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -1378,8 +1377,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
 	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
@@ -1408,8 +1406,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
 	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index d0a1cee..a5e5726 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -208,8 +208,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
@@ -236,8 +235,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
-#if defined(CONFIG_NF_CT_NETLINK) || \
-    defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
