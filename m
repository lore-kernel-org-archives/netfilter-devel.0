From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/3] change TCP state via nfnetlink
Date: Thu, 25 Aug 2005 22:43:16 +0200
Message-ID: <430E2D64.4000000@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070302060901010203010700"
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
--------------070302060901010203010700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds the ability of changing the state a TCP connection. I 
know that this must be used with care but it's required to provide a 
complete conntrack creation via conntrack_netlink. So I'll document this 
aspect on the upcoming docs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------070302060901010203010700
Content-Type: text/x-patch;
 name="04from-nfattr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04from-nfattr.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-20 18:19:49.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-20 18:19:54.000000000 +0200
@@ -355,6 +355,28 @@
 nfattr_failure:
 	return -1;
 }
+
+static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
+{
+	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
+	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
+
+        if (nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr) < 0)
+                goto nfattr_failure;
+
+	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+		return -EINVAL;
+
+	write_lock_bh(&tcp_lock);
+	ct->proto.tcp.state = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	write_unlock_bh(&tcp_lock);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
 #endif
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
@@ -1125,6 +1147,7 @@
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
+	.from_nfattr		= nfattr_to_tcp,
 	.tuple_to_nfattr	= ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= ip_ct_port_nfattr_to_tuple,
 #endif
Index: netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
===================================================================
--- netfilter-2.6.14.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-08-20 18:19:43.000000000 +0200
+++ netfilter-2.6.14/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-08-20 18:19:54.000000000 +0200
@@ -52,6 +52,9 @@
 	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct);
 
+	/* convert nfnetlink attributes to protoinfo */
+	int (*from_nfattr)(struct nfattr *tb[], struct ip_conntrack *ct);
+
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct ip_conntrack_tuple *t);
 	int (*nfattr_to_tuple)(struct nfattr *tb[],

--------------070302060901010203010700--
