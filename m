From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/5]: Verify NAT manips have been applied before
 reversing them in icmp_reply_translation
Date: Mon, 29 Nov 2004 00:29:33 +0100
Message-ID: <41AA5F5D.5060207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030204030503050009090903"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------030204030503050009090903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

ICMP errors can be generated for packets that don't have all
NAT manips applied yet. Verify manips have been applied before
reversing them. Fixes invalid ICMP errors in multiple situations.



--------------030204030503050009090903
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/27 13:35:38+01:00 kaber@coreworks.de 
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/11/27 13:35:30+01:00 kaber@coreworks.de +36 -0
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/11/27 13:35:30+01:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-11-28 21:36:55 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-11-28 21:36:55 +01:00
@@ -882,6 +882,7 @@
 
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
+EXPORT_SYMBOL(ip_ct_get_tuple);
 EXPORT_SYMBOL(invert_tuplepr);
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:55 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-11-28 21:36:55 +01:00
@@ -813,6 +813,23 @@
 	/* not reached */
 }
 
+static inline int tuple_src_equal_dst(const struct ip_conntrack_tuple *t1,
+                                      const struct ip_conntrack_tuple *t2)
+{
+	if (t1->dst.protonum != t2->dst.protonum || t1->src.ip != t2->dst.ip)
+		return 0;
+	if (t1->dst.protonum != IPPROTO_ICMP)
+		return t1->src.u.all == t2->dst.u.all;
+	else {
+		struct ip_conntrack_tuple inv;
+
+		/* ICMP tuples are asymetric */
+		invert_tuplepr(&inv, t1);
+		return inv.src.u.all == t2->src.u.all &&
+		       inv.dst.u.all == t2->dst.u.all;
+	}
+}
+
 int
 icmp_reply_translation(struct sk_buff **pskb,
 		       struct ip_conntrack *conntrack,
@@ -825,6 +842,7 @@
 	} *inside;
 	unsigned int i;
 	struct ip_nat_info *info = &conntrack->nat.info;
+	struct ip_conntrack_tuple *cttuple, innertuple;
 	int hdrlen;
 
 	if (!skb_ip_make_writable(pskb,(*pskb)->nh.iph->ihl*4+sizeof(*inside)))
@@ -868,6 +886,13 @@
 	   such addresses are not too uncommon, as Alan Cox points
 	   out) */
 
+	if (!ip_ct_get_tuple(&inside->ip, *pskb, (*pskb)->nh.iph->ihl*4 +
+	                     sizeof(struct icmphdr) + inside->ip.ihl*4,
+	                     &innertuple,
+	                     ip_ct_find_proto(inside->ip.protocol)))
+		return 0;
+	cttuple = &conntrack->tuplehash[dir].tuple;
+
 	READ_LOCK(&ip_nat_lock);
 	for (i = 0; i < info->num_manips; i++) {
 		DEBUGP("icmp_reply: manip %u dir %s hook %u\n",
@@ -890,6 +915,17 @@
 
 		if (info->manips[i].hooknum != hooknum)
 			continue;
+
+		/* ICMP errors may be generated locally for packets that
+		 * don't have all NAT manips applied yet. Verify manips
+		 * have been applied before reversing them */
+		if (info->manips[i].maniptype == IP_NAT_MANIP_SRC) {
+			if (!tuple_src_equal_dst(cttuple, &innertuple))
+				continue;
+		} else {
+			if (!tuple_src_equal_dst(&innertuple, cttuple))
+				continue;
+		}
 
 		DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
 		       info->manips[i].maniptype == IP_NAT_MANIP_SRC

--------------030204030503050009090903--
