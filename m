From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8] Check ctnetlink_dump_tuples_proto return value
Date: Mon, 05 Dec 2005 12:21:02 +0100
Message-ID: <4394229E.6000100@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000708070301030106020002"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------000708070301030106020002
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000708070301030106020002
Content-Type: text/plain;
 name="12.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="12.patch"

Check ctnetlink_dump_tuples_proto return value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 03:39:49.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 03:40:35.000000000 +0100
@@ -78,6 +78,7 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 		      const struct ip_conntrack_tuple *tuple)
 {
 	struct nfattr *nest_parms;
+	int ret;
 	
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
 	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t), &tuple->src.ip);
@@ -85,10 +86,10 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 	NFA_NEST_END(skb, nest_parms);
 
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
-	ctnetlink_dump_tuples_proto(skb, tuple);
+	ret = ctnetlink_dump_tuples_proto(skb, tuple);
 	NFA_NEST_END(skb, nest_parms);
 
-	return 0;
+	return ret;
 
 nfattr_failure:
 	return -1;

--------------000708070301030106020002--
