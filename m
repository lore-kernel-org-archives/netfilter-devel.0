From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/6]: Convert icmp conntrack protocol to
	skb_header_pointer
Date: Sun, 26 Sep 2004 23:52:25 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A19.6030303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090407000700010606060407"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090407000700010606060407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Same as for the UDP conntrack protocol:

This patch converts the remaining parts of the icmp conntrack
protocol to skb_header_pointer. Most was already done, but the
conntrack error API patch added a couple of new skb_copy_bits
calls.



--------------090407000700010606060407
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:20:58+02:00 kaber@coreworks.de 
#   [NETFILTER]: Convert icmp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_icmp.c
#   2004/09/26 23:20:28+02:00 kaber@coreworks.de +18 -16
#   [NETFILTER]: Convert icmp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-26 23:23:37 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-26 23:23:37 +02:00
@@ -139,7 +139,7 @@
 	struct {
 		struct icmphdr icmp;
 		struct iphdr ip;
-	} inside;
+	} _in, *inside;
 	struct ip_conntrack_protocol *innerproto;
 	struct ip_conntrack_tuple_hash *h;
 	int dataoff;
@@ -147,21 +147,22 @@
 	IP_NF_ASSERT(skb->nfct == NULL);
 
 	/* Not enough header? */
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
+	inside = skb_header_pointer(skb, skb->nh.iph->ihl*4, sizeof(_in), &_in);
+	if (inside == NULL)
 		return NF_ACCEPT;
 
 	/* Ignore ICMP's containing fragments (shouldn't happen) */
-	if (inside.ip.frag_off & htons(IP_OFFSET)) {
+	if (inside->ip.frag_off & htons(IP_OFFSET)) {
 		DEBUGP("icmp_error_track: fragment of proto %u\n",
-		       inside.ip.protocol);
+		       inside->ip.protocol);
 		return NF_ACCEPT;
 	}
 
-	innerproto = ip_ct_find_proto(inside.ip.protocol);
-	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
+	innerproto = ip_ct_find_proto(inside->ip.protocol);
+	dataoff = skb->nh.iph->ihl*4 + sizeof(inside->icmp) + inside->ip.ihl*4;
 	/* Are they talking about one of our connections? */
-	if (!ip_ct_get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
-		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
+	if (!ip_ct_get_tuple(&inside->ip, skb, dataoff, &origtuple, innerproto)) {
+		DEBUGP("icmp_error: ! get_tuple p=%u", inside->ip.protocol);
 		return NF_ACCEPT;
 	}
 
@@ -205,10 +206,11 @@
 icmp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
 	   unsigned int hooknum)
 {
-	struct icmphdr icmph;
+	struct icmphdr _ih, *icmph;
 
 	/* Not enough header? */
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &icmph, sizeof(icmph))!=0) {
+	icmph = skb_header_pointer(skb, skb->nh.iph->ihl*4, sizeof(_ih), &_ih);
+	if (icmph == NULL) {
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: short packet ");
@@ -245,7 +247,7 @@
 	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
 	 *		  discarded.
 	 */
-	if (icmph.type > NR_ICMP_TYPES) {
+	if (icmph->type > NR_ICMP_TYPES) {
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: invalid ICMP type ");
@@ -253,11 +255,11 @@
 	}
 
 	/* Need to track icmp error message? */
-	if (icmph.type != ICMP_DEST_UNREACH
-	    && icmph.type != ICMP_SOURCE_QUENCH
-	    && icmph.type != ICMP_TIME_EXCEEDED
-	    && icmph.type != ICMP_PARAMETERPROB
-	    && icmph.type != ICMP_REDIRECT)
+	if (icmph->type != ICMP_DEST_UNREACH
+	    && icmph->type != ICMP_SOURCE_QUENCH
+	    && icmph->type != ICMP_TIME_EXCEEDED
+	    && icmph->type != ICMP_PARAMETERPROB
+	    && icmph->type != ICMP_REDIRECT)
 		return NF_ACCEPT;
 
 	return icmp_error_message(skb, ctinfo, hooknum);

--------------090407000700010606060407--
