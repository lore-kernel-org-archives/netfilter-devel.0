From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/3] Nest TCP protocol private info
Date: Thu, 25 Aug 2005 22:42:57 +0200
Message-ID: <430E2D51.7020405@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040000070109010700070503"
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
--------------040000070109010700070503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

To keep consistency, the TCP private protocol information is nested 
attributes under CTA_PROTOINFO_TCP. This way the sequence of attributes 
to access the TCP state information looks like here below:

CTA_PROTOINFO
CTA_PROTOINFO_TCP
CTA_PROTOINFO_TCP_STATE

instead of:

CTA_PROTOINFO
CTA_PROTOINFO_TCP_STATE

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

--------------040000070109010700070503
Content-Type: text/x-patch;
 name="03protoinfo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03protoinfo.patch"

Index: netfilter-2.6.14/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- netfilter-2.6.14.orig/include/linux/netfilter/nfnetlink_conntrack.h	2005-08-20 18:19:43.000000000 +0200
+++ netfilter-2.6.14/include/linux/netfilter/nfnetlink_conntrack.h	2005-08-20 18:19:49.000000000 +0200
@@ -70,11 +70,18 @@
 
 enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
-	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
 
+enum ctattr_protoinfo_tcp {
+	CTA_PROTOINFO_TCP_UNSPEC,
+	CTA_PROTOINFO_TCP_STATE,
+	__CTA_PROTOINFO_TCP_MAX
+};
+#define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
+
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
 	CTA_COUNTERS_PACKETS,
Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-20 18:19:44.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-08-20 18:19:49.000000000 +0200
@@ -341,11 +341,15 @@
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	
 	read_lock_bh(&tcp_lock);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 	read_unlock_bh(&tcp_lock);
 
+	NFA_NEST_END(skb, nest_parms);
+
 	return 0;
 
 nfattr_failure:

--------------040000070109010700070503--
