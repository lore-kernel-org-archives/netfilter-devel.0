From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 3/3] netfilter: conntrack: l4 protocol trackers can be const
Date: Tue,  7 Nov 2017 07:20:09 +0100
Message-ID: <20171107062009.2519-4-fw@strlen.de>
References: <20171107062009.2519-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49118 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753498AbdKGGUw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 01:20:52 -0500
In-Reply-To: <20171107062009.2519-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

previous patches removed all writes to these structs so we can
now mark them as const.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 12 ++++++------
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 12 ++++++------
 include/net/netfilter/nf_conntrack_l4proto.h   |  2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  2 +-
 net/netfilter/nf_conntrack_proto_dccp.c        |  4 ++--
 net/netfilter/nf_conntrack_proto_generic.c     |  2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |  4 ++--
 net/netfilter/nf_conntrack_proto_tcp.c         |  4 ++--
 net/netfilter/nf_conntrack_proto_udp.c         |  8 ++++----
 11 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 5534ecca7a5d..fc257b87328f 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -12,17 +12,17 @@
 
 const extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4;
 #endif
 
 int nf_conntrack_ipv4_compat_init(void);
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index 30dc57980866..b3ccdfd68836 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -3,17 +3,17 @@
 
 extern const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 #ifdef CONFIG_NF_CT_PROTO_DCCP
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6;
 #endif
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6;
 #endif
 
 #include <linux/sysctl.h>
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7a49cc967526..570bacb78ed9 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -107,7 +107,7 @@ struct nf_conntrack_l4proto {
 };
 
 /* Existing built-in generic protocol */
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
 #define MAX_NF_CT_PROTO 256
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 1849fedd9b81..669e586b6b8f 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -351,7 +351,7 @@ static struct nf_proto_net *icmp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.icmp.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_ICMP,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 3ac0d826afc4..75a85e35a16b 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -352,7 +352,7 @@ static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.icmpv6.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_ICMPV6,
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 2fee7c96ec09..abe647d5b8c6 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -861,7 +861,7 @@ static struct nf_proto_net *dccp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.dccp.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 __read_mostly = {
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.l3proto		= AF_INET,
 	.l4proto		= IPPROTO_DCCP,
 	.pkt_to_tuple		= dccp_pkt_to_tuple,
@@ -897,7 +897,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 __read_mostly = {
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp4);
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 __read_mostly = {
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.l3proto		= AF_INET6,
 	.l4proto		= IPPROTO_DCCP,
 	.pkt_to_tuple		= dccp_pkt_to_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 1f86ddf6649a..f2d22442c89e 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -163,7 +163,7 @@ static struct nf_proto_net *generic_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.generic.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l3proto		= PF_UNSPEC,
 	.l4proto		= 255,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index a2503005d80b..ea7eff484ac5 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -352,7 +352,7 @@ static int gre_init_net(struct net *net, u_int16_t proto)
 }
 
 /* protocol helper struct */
-static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
+struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 	.l3proto	 = AF_INET,
 	.l4proto	 = IPPROTO_GRE,
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index f5bff4de0386..69eaaca6f933 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -777,7 +777,7 @@ static struct nf_proto_net *sctp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.sctp.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_SCTP,
 	.pkt_to_tuple 		= sctp_pkt_to_tuple,
@@ -814,7 +814,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp4);
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_SCTP,
 	.pkt_to_tuple 		= sctp_pkt_to_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a61a6b7b4fc5..22b4c8ba5c2f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1538,7 +1538,7 @@ static struct nf_proto_net *tcp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.tcp.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_TCP,
@@ -1576,7 +1576,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp4);
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_TCP,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3a5f727103af..59a20f61c364 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -296,7 +296,7 @@ static struct nf_proto_net *udp_get_net_proto(struct net *net)
 	return &net->ct.nf_ct_proto.udp.pn;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 {
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDP,
@@ -328,7 +328,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 {
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDPLITE,
@@ -360,7 +360,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite4);
 #endif
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 {
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDP,
@@ -392,7 +392,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 {
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDPLITE,
-- 
2.13.6

