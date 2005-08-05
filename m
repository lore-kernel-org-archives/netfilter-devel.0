From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Change protocol private information
Date: Fri, 05 Aug 2005 02:38:46 +0200
Message-ID: <42F2B516.5020307@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000707090001080808040705"
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
--------------000707090001080808040705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

This is a resent. I'd like to discuss this a bit. Following the 
discusion left at:

[PATCH 4/7] Add ctnetlink_change_protoinfo

I think that users must be able to set the TCP state of a conntrack, 
otherwise if they create a conntrack via libnfnetlink_conntrack, the 
state will be set to NONE. If users aren't able to set the state, I'd 
consider that the library is kind of incomplete. I don't like the idea 
of kidding with stuff that could be compromising either, but I don't 
want to lose any features. So, I think that the solution is *remark* in 
the documentation of libnfnetlink_conntrack and the conntrack manpage 
that changing the protocol private information like the state could 
result in problems, I promise to do such thing.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------000707090001080808040705
Content-Type: text/x-patch;
 name="05from-nfattr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05from-nfattr.patch"

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

--------------000707090001080808040705
Content-Type: text/x-patch;
 name="06change-protoinfo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06change-protoinfo.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-04 15:25:17.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-04 16:05:45.000000000 +0200
@@ -948,6 +948,36 @@
 	return 0;
 }
 
+static inline int
+ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
+{
+	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
+	struct ip_conntrack_protocol *proto;
+	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	int err;
+
+	if (nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr) < 0)
+		goto nfattr_failure;
+
+	proto = ip_conntrack_proto_find_get(npt);
+	if (!proto)
+		return -EINVAL;
+
+	if (proto->from_nfattr) {
+		err = proto->from_nfattr(tb, ct);
+		if (err < 0) {
+			ip_conntrack_proto_put(proto);
+			return -EINVAL;
+		}
+	}
+	ip_conntrack_proto_put(proto);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+
 static int
 ctnetlink_change_conntrack(struct ip_conntrack *ct, struct nfattr *cda[])
 {
@@ -973,6 +1003,12 @@
 			return err;
 	}
 
+	if (cda[CTA_PROTOINFO-1]) {
+		err = ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	DEBUGP("all done\n");
 	return 0;
 }
@@ -1002,6 +1038,12 @@
 	if (err < 0)
 		goto err;
 
+	if (cda[CTA_PROTOINFO-1]) {
+		err = ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	ct->helper = ip_conntrack_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);

--------------000707090001080808040705--
