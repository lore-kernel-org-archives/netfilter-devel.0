From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix unresolved symbol __nfa_fill when nfnetlink is not
 compiled in
Date: Sat, 23 Jul 2005 07:47:11 +0200
Message-ID: <42E1D9DF.7050908@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="x"
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

[NETFILTER]: Fix unresolved symbol __nfa_fill when nfnetlink is not compiled in

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f6a24a992ce129888cd3137a90689edf8c859aef
tree 12a6858f7108e210309ac681598281f05f099b7f
parent 97d4e0b5dc8578e9839dae473c61c82760a15a29
author Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 07:46:28 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 07:46:28 +0200

 net/ipv4/netfilter/ip_conntrack_core.c       |    3 +++
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |    6 ++++++
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |    3 +++
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c  |    6 ++++++
 net/ipv4/netfilter/ip_conntrack_proto_udp.c  |    3 +++
 net/ipv4/netfilter/ip_conntrack_standalone.c |    4 +++-
 net/ipv4/netfilter/ip_nat_core.c             |    3 +++
 net/ipv4/netfilter/ip_nat_proto_icmp.c       |    3 +++
 net/ipv4/netfilter/ip_nat_proto_tcp.c        |    3 +++
 net/ipv4/netfilter/ip_nat_proto_udp.c        |    3 +++
 10 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1158,6 +1158,8 @@ void ip_ct_refresh_acct(struct ip_conntr
 	}
 }
 
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
  * in ip_conntrack_core, since we don't want the protocols to autoload
  * or depend on ctnetlink */
@@ -1187,6 +1189,7 @@ int ip_ct_port_nfattr_to_tuple(struct nf
 
 	return 0;
 }
+#endif
 
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -270,6 +270,8 @@ checksum_skipped:
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 static int icmp_tuple_to_nfattr(struct sk_buff *skb,
 				const struct ip_conntrack_tuple *t)
 {
@@ -307,6 +309,7 @@ static int icmp_nfattr_to_tuple(struct n
 
 	return 0;
 }
+#endif
 
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
 {
@@ -319,6 +322,9 @@ struct ip_conntrack_protocol ip_conntrac
 	.packet			= icmp_packet,
 	.new			= icmp_new,
 	.error			= icmp_error,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
+#endif
 };
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -506,8 +506,11 @@ static struct ip_conntrack_protocol ip_c
 	.new 		 = sctp_new, 
 	.destroy 	 = NULL, 
 	.me 		 = THIS_MODULE,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr = ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple = ip_ct_port_nfattr_to_tuple,
+#endif
 };
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -336,6 +336,8 @@ static int tcp_print_conntrack(struct se
 	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
 }
 
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
@@ -349,6 +351,7 @@ static int tcp_to_nfattr(struct sk_buff 
 nfattr_failure:
 	return -1;
 }
+#endif
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 {
@@ -1114,7 +1117,10 @@ struct ip_conntrack_protocol ip_conntrac
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
+#endif
 };
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -145,6 +145,9 @@ struct ip_conntrack_protocol ip_conntrac
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
+#endif
 };
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -1028,6 +1028,8 @@ EXPORT_SYMBOL_GPL(__ip_conntrack_helper_
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_proto_put);
 EXPORT_SYMBOL_GPL(__ip_conntrack_proto_find);
-
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 EXPORT_SYMBOL_GPL(ip_ct_port_tuple_to_nfattr);
 EXPORT_SYMBOL_GPL(ip_ct_port_nfattr_to_tuple);
+#endif
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -537,6 +537,8 @@ void ip_nat_protocol_unregister(struct i
 	synchronize_net();
 }
 
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 int
 ip_nat_port_range_to_nfattr(struct sk_buff *skb, 
 			    const struct ip_nat_range *range)
@@ -576,6 +578,7 @@ ip_nat_port_nfattr_to_range(struct nfatt
 
 	return ret;
 }
+#endif
 
 int __init ip_nat_init(void)
 {
diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -112,6 +112,9 @@ struct ip_nat_protocol ip_nat_protocol_i
     icmp_unique_tuple,
     icmp_print,
     icmp_print_range,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
     ip_nat_port_range_to_nfattr,
     ip_nat_port_nfattr_to_range,
+#endif
 };
diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -176,6 +176,9 @@ struct ip_nat_protocol ip_nat_protocol_t
     tcp_unique_tuple,
     tcp_print,
     tcp_print_range,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
     ip_nat_port_range_to_nfattr,
     ip_nat_port_nfattr_to_range,
+#endif
 };
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -162,6 +162,9 @@ struct ip_nat_protocol ip_nat_protocol_u
     udp_unique_tuple,
     udp_print,
     udp_print_range,
+#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
+    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
     ip_nat_port_range_to_nfattr,
     ip_nat_port_nfattr_to_range,
+#endif
 };
