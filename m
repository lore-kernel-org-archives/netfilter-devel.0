From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] netfilter: use IS_ENABLED() macro
Date: Fri, 27 Jun 2014 13:50:27 +0800
Message-ID: <53AD0623.5090104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46706 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbaF0Fxx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:53:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


replace:
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
with
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 4 ++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   | 4 ++--
 net/ipv4/netfilter/nf_nat_proto_gre.c          | 2 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         | 2 +-
 net/netfilter/nf_nat_core.c                    | 2 +-
 net/netfilter/nf_nat_proto_common.c            | 2 +-
 net/netfilter/nf_nat_proto_dccp.c              | 2 +-
 net/netfilter/nf_nat_proto_sctp.c              | 2 +-
 net/netfilter/nf_nat_proto_tcp.c               | 2 +-
 net/netfilter/nf_nat_proto_udp.c               | 2 +-
 net/netfilter/nf_nat_proto_udplite.c           | 2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 8127dc8..4ce44c4 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -314,7 +314,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 	return -ENOENT;
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -388,7 +388,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.invert_tuple	 = ipv4_invert_tuple,
 	.print_tuple	 = ipv4_print_tuple,
 	.get_l4proto	 = ipv4_get_l4proto,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
 	.nlattr_tuple_size = ipv4_nlattr_tuple_size,
 	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index a338dad..b91b264 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -226,7 +226,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	return icmp_error_message(net, tmpl, skb, ctinfo, hooknum);
 }
 
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
@@ -408,7 +408,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 	.error			= icmp_error,
 	.destroy		= NULL,
 	.me			= NULL,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmp_nlattr_tuple_size,
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 690d8901..9414923 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -124,7 +124,7 @@ static const struct nf_nat_l4proto gre = {
 	.manip_pkt		= gre_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= gre_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index eb30347..4557b4a 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -77,7 +77,7 @@ const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
 	.manip_pkt		= icmp_manip_pkt,
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index a49907b..552f97c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -710,7 +710,7 @@ static struct nf_ct_ext_type nat_extend __read_mostly = {
 	.flags		= NF_CT_EXT_F_PREALLOC,
 };
 
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 83a72a2..fbce552 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -95,7 +95,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range *range)
 {
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index c8be2cd..b8067b5 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -78,7 +78,7 @@ static const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
 	.manip_pkt		= dccp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= dccp_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index 754536f..cbc7ade 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -59,7 +59,7 @@ static const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
 	.manip_pkt		= sctp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= sctp_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index 83ec8a6..37f5505 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -79,7 +79,7 @@ const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
 	.manip_pkt		= tcp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= tcp_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 7df613f..b0ede2f 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -70,7 +70,7 @@ const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= udp_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
diff --git a/net/netfilter/nf_nat_proto_udplite.c b/net/netfilter/nf_nat_proto_udplite.c
index 776a0d1..368f14e 100644
--- a/net/netfilter/nf_nat_proto_udplite.c
+++ b/net/netfilter/nf_nat_proto_udplite.c
@@ -69,7 +69,7 @@ static const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
 	.manip_pkt		= udplite_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
 	.unique_tuple		= udplite_unique_tuple,
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
 };
-- 
1.8.3.1
