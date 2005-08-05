From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Remove ip_conntrack <-> nfnetlink dependency
Date: Fri, 05 Aug 2005 02:38:57 +0200
Message-ID: <42F2B521.2050408@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040101060202040803090800"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------040101060202040803090800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

@Patrick: This patch is related to one of the patches that you submitted 
some time ago.

Currently there's a dependency between nfnetlink and ip_conntrack. If 
the second if loaded, the first will be too because needs ip_conntrack 
needs the symbol __nfa_fill.

The following patch resolves such dependency by inlining __nfa_fill, I 
don't know if this solution is the best though since this could increase 
the size of the ip_conntrack_netlink binary. Anyway we could leave it 
that way until the generic netlink layer comes (I mean RTA_* and NFA_* 
unification).

BTW, just an observation, maybe those CONFIG_IP_NF_CONNTRACK_NETLINK in 
ip_conntrack_core.c should be CONFIG_NETFILTER_NETLINK instead since the 
dependency is __nfa_fill.

--------------040101060202040803090800
Content-Type: text/x-patch;
 name="10patrick.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10patrick.patch"

Index: netfilter-2.6.14/include/linux/netfilter/nfnetlink.h
===================================================================
--- netfilter-2.6.14.orig/include/linux/netfilter/nfnetlink.h	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/include/linux/netfilter/nfnetlink.h	2005-08-05 00:29:39.000000000 +0200
@@ -99,8 +99,19 @@
 	struct nfnl_callback *cb; /* callback for individual types */
 };
 
-extern void __nfa_fill(struct sk_buff *skb, int attrtype,
-        int attrlen, const void *data);
+static inline void 
+__nfa_fill(struct sk_buff *skb, int attrtype, int attrlen, const void *data)
+{
+	struct nfattr *nfa;
+	int size = NFA_LENGTH(attrlen);
+
+	nfa = (struct nfattr *)skb_put(skb, NFA_ALIGN(size));
+	nfa->nfa_type = attrtype;
+	nfa->nfa_len  = size;
+	memcpy(NFA_DATA(nfa), data, attrlen);
+	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
+}
+
 #define NFA_PUT(skb, attrtype, attrlen, data) \
 ({ if (skb_tailroom(skb) < (int)NFA_SPACE(attrlen)) goto nfattr_failure; \
    __nfa_fill(skb, attrtype, attrlen, data); })
Index: netfilter-2.6.14/net/netfilter/nfnetlink.c
===================================================================
--- netfilter-2.6.14.orig/net/netfilter/nfnetlink.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/netfilter/nfnetlink.c	2005-08-05 00:29:39.000000000 +0200
@@ -115,19 +115,6 @@
 	return &ss->cb[cb_id];
 }
 
-void __nfa_fill(struct sk_buff *skb, int attrtype, int attrlen,
-		const void *data)
-{
-	struct nfattr *nfa;
-	int size = NFA_LENGTH(attrlen);
-
-	nfa = (struct nfattr *)skb_put(skb, NFA_ALIGN(size));
-	nfa->nfa_type = attrtype;
-	nfa->nfa_len  = size;
-	memcpy(NFA_DATA(nfa), data, attrlen);
-	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
-}
-
 int nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
 {
 	memset(tb, 0, sizeof(struct nfattr *) * maxattr);
@@ -373,4 +360,3 @@
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 EXPORT_SYMBOL_GPL(nfattr_parse);
-EXPORT_SYMBOL_GPL(__nfa_fill);
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-05 00:29:39.000000000 +0200
@@ -1164,8 +1164,6 @@
 	}
 }
 
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
  * in ip_conntrack_core, since we don't want the protocols to autoload
  * or depend on ctnetlink */
@@ -1195,7 +1193,6 @@
 
 	return 0;
 }
-#endif
 
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_udp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-08-05 00:29:39.000000000 +0200
@@ -145,9 +145,6 @@
 	.packet			= udp_packet,
 	.new			= udp_new,
 	.error			= udp_error,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
-#endif
 };
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-05 00:29:39.000000000 +0200
@@ -336,8 +336,6 @@
 	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
 }
 
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
@@ -362,7 +360,6 @@
 
 	return 0;
 }
-#endif
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 {
@@ -1129,11 +1126,8 @@
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
 	.error			= tcp_error,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
 	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
-#endif
 };
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-08-05 00:29:39.000000000 +0200
@@ -270,8 +270,6 @@
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
 
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 static int icmp_tuple_to_nfattr(struct sk_buff *skb,
 				const struct ip_conntrack_tuple *t)
 {
@@ -309,7 +307,6 @@
 
 	return 0;
 }
-#endif
 
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
 {
@@ -322,9 +319,6 @@
 	.packet			= icmp_packet,
 	.new			= icmp_new,
 	.error			= icmp_error,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
-#endif
 };
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-08-05 00:29:28.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-08-05 00:29:39.000000000 +0200
@@ -506,11 +506,8 @@
 	.new 		 = sctp_new, 
 	.destroy 	 = NULL, 
 	.me 		 = THIS_MODULE,
-#if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
-    defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.tuple_to_nfattr = ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple = ip_ct_port_nfattr_to_tuple,
-#endif
 };
 
 #ifdef CONFIG_SYSCTL

--------------040101060202040803090800--
