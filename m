From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 7/7] Implements change protoinfo via from_nfattr
Date: Mon, 01 Aug 2005 19:07:01 +0200
Message-ID: <42EE56B5.5030504@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020706020802090303020108"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------020706020802090303020108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Add a function to parse private protocol attributes.

--------------020706020802090303020108
Content-Type: text/x-patch;
 name="07from-nfattr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07from-nfattr.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-01 18:20:57.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-01 18:21:26.000000000 +0200
@@ -351,6 +351,17 @@
 nfattr_failure:
 	return -1;
 }
+
+static int nfattr_to_tcp(struct nfattr *tb[], struct ip_conntrack *ct)
+{
+	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+		return -EINVAL;
+
+	ct->proto.tcp.state = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+
+	return 0;
+}
 #endif
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
@@ -1121,6 +1132,7 @@
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
 #endif
Index: netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
===================================================================
--- netfilter-2.6.14.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-08-01 18:20:57.000000000 +0200
+++ netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-08-01 18:21:26.000000000 +0200
@@ -52,6 +52,8 @@
 	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct);
 
+	int (*from_nfattr)(struct nfattr *tb[], struct ip_conntrack *ct);
+
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct ip_conntrack_tuple *t);
 	int (*nfattr_to_tuple)(struct nfattr *tb[],

--------------020706020802090303020108--
