From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 5/18]: Verify NAT manips have been applied before
 reversing them in icmp_reply_translation
Date: Mon, 20 Dec 2004 08:14:27 +0100
Message-ID: <41C67BD3.1020502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090800070408040001030101"
Cc: netfilter-devel@lists.netfilter.org
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
--------------090800070408040001030101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

ICMP errors may be generated for packets that don't have
all NAT manips applied yet. Verify manips have been applied
before reversing them.


--------------090800070408040001030101
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 22:39:52+01:00 kaber@coreworks.de 
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/12/05 22:39:50+01:00 kaber@coreworks.de +34 -0
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_fw_compat_masq.c
#   2004/12/05 22:39:50+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/12/05 22:39:50+01:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/12/05 22:39:50+01:00 kaber@coreworks.de +5 -5
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_core.h
#   2004/12/05 22:39:50+01:00 kaber@coreworks.de +3 -3
#   [NETFILTER]: Verify NAT manips have been applied before reversing them in icmp_reply_translation
#   
#   ICMP errors may be generated for packets that don't have
#   all NAT manips applied yet. Verify manips have been applied
#   before reversing them.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-12-20 06:59:29 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-12-20 06:59:29 +01:00
@@ -25,9 +25,9 @@
 extern struct ip_conntrack *icmp_error_track(struct sk_buff *skb,
 					     enum ip_conntrack_info *ctinfo,
 					     unsigned int hooknum);
-extern int get_tuple(const struct iphdr *iph, size_t len,
-		     struct ip_conntrack_tuple *tuple,
-		     struct ip_conntrack_protocol *protocol);
+extern int ip_ct_get_tuple(const struct iphdr *iph, size_t len,
+                           struct ip_conntrack_tuple *tuple,
+                           struct ip_conntrack_protocol *protocol);
 
 /* Find a connection corresponding to a tuple. */
 struct ip_conntrack_tuple_hash *
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-20 06:59:29 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-20 06:59:29 +01:00
@@ -122,9 +122,9 @@
 }
 
 inline int
-get_tuple(const struct iphdr *iph, size_t len,
-	  struct ip_conntrack_tuple *tuple,
-	  struct ip_conntrack_protocol *protocol)
+ip_ct_get_tuple(const struct iphdr *iph, size_t len,
+                struct ip_conntrack_tuple *tuple,
+                struct ip_conntrack_protocol *protocol)
 {
 	int ret;
 
@@ -546,7 +546,7 @@
 	innerproto = ip_ct_find_proto(inner->protocol);
 	/* Are they talking about one of our connections? */
 	if (inner->ihl * 4 + 8 > datalen
-	    || !get_tuple(inner, datalen, &origtuple, innerproto)) {
+	    || !ip_ct_get_tuple(inner, datalen, &origtuple, innerproto)) {
 		DEBUGP("icmp_error: ! get_tuple p=%u (%u*4+%u dlen=%u)\n",
 		       inner->protocol, inner->ihl, 8,
 		       datalen);
@@ -757,7 +757,7 @@
 
 	IP_NF_ASSERT((skb->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
-	if (!get_tuple(skb->nh.iph, skb->len, &tuple, proto))
+	if (!ip_ct_get_tuple(skb->nh.iph, skb->len, &tuple, proto))
 		return NULL;
 
 	/* look for tuple match */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-20 06:59:29 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-20 06:59:29 +01:00
@@ -468,6 +468,7 @@
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(invert_tuplepr);
+EXPORT_SYMBOL(ip_ct_get_tuple);
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
diff -Nru a/net/ipv4/netfilter/ip_fw_compat_masq.c b/net/ipv4/netfilter/ip_fw_compat_masq.c
--- a/net/ipv4/netfilter/ip_fw_compat_masq.c	2004-12-20 06:59:29 +01:00
+++ b/net/ipv4/netfilter/ip_fw_compat_masq.c	2004-12-20 06:59:29 +01:00
@@ -157,7 +157,7 @@
 	case IPPROTO_UDP:
 		IP_NF_ASSERT(((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
-		if (!get_tuple(iph, (*pskb)->len, &tuple, protocol)) {
+		if (!ip_ct_get_tuple(iph, (*pskb)->len, &tuple, protocol)) {
 			if (net_ratelimit())
 				printk("ip_fw_compat_masq: Can't get tuple\n");
 			return NF_ACCEPT;
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:29 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:29 +01:00
@@ -860,6 +860,23 @@
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
 unsigned int
 icmp_reply_translation(struct sk_buff *skb,
 		       struct ip_conntrack *conntrack,
@@ -872,6 +889,7 @@
 	size_t datalen = skb->len - ((void *)inner - (void *)iph);
 	unsigned int i;
 	struct ip_nat_info *info = &conntrack->nat.info;
+	struct ip_conntrack_tuple *cttuple, innertuple;
 
 	IP_NF_ASSERT(skb->len >= iph->ihl*4 + sizeof(struct icmphdr));
 	/* Must be RELATED */
@@ -906,6 +924,11 @@
 	   such addresses are not too uncommon, as Alan Cox points
 	   out) */
 
+	if (!ip_ct_get_tuple(inner, datalen, &innertuple,
+	                     ip_ct_find_proto(inner->protocol)))
+		return 0;
+	cttuple = &conntrack->tuplehash[dir].tuple;
+
 	READ_LOCK(&ip_nat_lock);
 	for (i = 0; i < info->num_manips; i++) {
 		DEBUGP("icmp_reply: manip %u dir %s hook %u\n",
@@ -928,6 +951,17 @@
 
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

--------------090800070408040001030101--
