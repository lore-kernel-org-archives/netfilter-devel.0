From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/13]: nf_conntrack/nf_nat: fix incorrect config ifdefs
Date: Wed,  7 Mar 2007 22:34:29 +0100 (MET)
Message-ID: <20070307213349.22306.32501.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcaac807aeec7ae9aff8a62261b1138979d6dd5b
tree cee8dd8717b07b5ee23f408e60b7d45f53d33632
parent 841de8621862a5406d2a236dd142a5e5db167d25
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:22:01 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:22:01 +0100

 net/ipv4/netfilter/nf_nat_core.c       |    3 +--
 net/ipv4/netfilter/nf_nat_proto_gre.c  |    3 +--
 net/ipv4/netfilter/nf_nat_proto_icmp.c |    3 +--
 net/ipv4/netfilter/nf_nat_proto_tcp.c  |    3 +--
 net/ipv4/netfilter/nf_nat_proto_udp.c  |    3 +--
 net/netfilter/nf_conntrack_proto_gre.c |    3 +--
 6 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 86a9227..8de7188 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -540,8 +540,7 @@ void nf_nat_protocol_unregister(struct n
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
index dcfd772..b93c78a 100644
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
index 7e26a7e..f6b99d6 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -140,8 +140,7 @@ struct nf_nat_protocol nf_nat_protocol_t
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
index ab0ce4c..c00ab6e 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -130,8 +130,7 @@ struct nf_nat_protocol nf_nat_protocol_u
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= udp_in_range,
 	.unique_tuple		= udp_unique_tuple,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nfattr	= nf_nat_port_range_to_nfattr,
 	.nfattr_to_range	= nf_nat_port_nfattr_to_range,
 #endif
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
