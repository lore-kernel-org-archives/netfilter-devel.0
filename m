From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/6]: Convert udp conntrack protocol to
	skb_header_pointer
Date: Sun, 26 Sep 2004 23:52:22 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A16.1020101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040201090103040002060602"
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
--------------040201090103040002060602
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch converts the remaining parts of the udp conntrack
protocol to skb_header_pointer. Most was already done, but the
conntrack error API patch added a couple of new skb_copy_bits
calls.



--------------040201090103040002060602
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:18:51+02:00 kaber@coreworks.de 
#   [NETFILTER]: Convert udp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_udp.c
#   2004/09/26 23:18:26+02:00 kaber@coreworks.de +5 -4
#   [NETFILTER]: Convert udp conntrack protocol to skb_header_pointer
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-09-26 23:23:20 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-09-26 23:23:20 +02:00
@@ -91,10 +91,11 @@
 {
 	struct iphdr *iph = skb->nh.iph;
 	unsigned int udplen = skb->len - iph->ihl * 4;
-	struct udphdr hdr;
+	struct udphdr _hdr, *hdr;
 
 	/* Header is too small? */
-	if (skb_copy_bits(skb, iph->ihl*4, &hdr, sizeof(hdr)) != 0) {
+	hdr = skb_header_pointer(skb, iph->ihl*4, sizeof(_hdr), &_hdr);
+	if (hdr == NULL) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: short packet ");
@@ -102,7 +103,7 @@
 	}
 	
 	/* Truncated/malformed packets */
-	if (ntohs(hdr.len) > udplen || ntohs(hdr.len) < sizeof(hdr)) {
+	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: truncated/malformed packet ");
@@ -110,7 +111,7 @@
 	}
 	
 	/* Packet with no checksum */
-	if (!hdr.check)
+	if (!hdr->check)
 		return NF_ACCEPT;
 
 	/* Checksum invalid? Ignore.

--------------040201090103040002060602--
