From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 8/19]: ip6t_esp.c whitespace cleanup
Date: Mon, 25 Oct 2004 02:49:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D93.90000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090600060500040707010009"
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
--------------090600060500040707010009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Whitespace cleanup in ip6t_esp.



--------------090600060500040707010009
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:21:00+02:00 kaber@coreworks.de 
#   [NETFILTER]: ip6t_esp.c whitespace cleanup
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_esp.c
#   2004/10/19 02:20:32+02:00 kaber@coreworks.de +36 -38
#   [NETFILTER]: ip6t_esp.c whitespace cleanup
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:38:58 +02:00
+++ b/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:38:58 +02:00
@@ -32,8 +32,8 @@
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
 {
 	int r=0;
-        DEBUGP("esp spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-        	min,spi,max);
+	DEBUGP("esp spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
+	       min,spi,max);
 	r=(spi >= min && spi <= max) ^ invert;
 	DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
 	return r;
@@ -66,21 +66,20 @@
 	len = skb->len - ptr;
 	temp = 0;
 
-        while (ip6t_ext_hdr(nexthdr)) {
-        	struct ipv6_opt_hdr _hdr, *hp;
-        	int hdrlen;
+	while (ip6t_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+		int hdrlen;
 
 		DEBUGP("ipv6_esp header iteration \n");
 
 		/* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
+		if (len < sizeof(struct ipv6_opt_hdr))
+			return 0;
 		/* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
+		if (nexthdr == NEXTHDR_NONE)
 			break;
-		}
 		/* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
+		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
 			break;
 		}
@@ -89,43 +88,43 @@
 		BUG_ON(hp == NULL);
 
 		/* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
+		if (nexthdr == NEXTHDR_FRAGMENT)
+			hdrlen = 8;
+		else if (nexthdr == NEXTHDR_AUTH)
+			hdrlen = (hp->hdrlen+2)<<2;
+		else
+			hdrlen = ipv6_optlen(hp);
 
 		/* set the flag */
-		switch (nexthdr){
-			case NEXTHDR_HOP:
-			case NEXTHDR_ROUTING:
-			case NEXTHDR_FRAGMENT:
-			case NEXTHDR_AUTH:
-			case NEXTHDR_DEST:
-				break;
-			default:
-				DEBUGP("ipv6_esp match: unknown nextheader %u\n",nexthdr);
-				return 0;
-				break;
+		switch (nexthdr) {
+		case NEXTHDR_HOP:
+		case NEXTHDR_ROUTING:
+		case NEXTHDR_FRAGMENT:
+		case NEXTHDR_AUTH:
+		case NEXTHDR_DEST:
+			break;
+		default:
+			DEBUGP("ipv6_esp match: unknown nextheader %u\n",nexthdr);
+			return 0;
 		}
 
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
+		nexthdr = hp->nexthdr;
+		len -= hdrlen;
+		ptr += hdrlen;
+		if (ptr > skb->len) {
 			DEBUGP("ipv6_esp: new pointer too large! \n");
 			break;
 		}
-        }
+	}
 
 	/* ESP header not found */
-	if ( temp != MASK_ESP ) return 0;
+	if (temp != MASK_ESP)
+		return 0;
 
-       if (len < (int)sizeof(struct ip_esp_hdr)){
-	       *hotdrop = 1;
-       		return 0;
-       }
+	if (len < sizeof(struct ip_esp_hdr)) {
+		*hotdrop = 1;
+		return 0;
+	}
 
 	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
 	BUG_ON(eh == NULL);
@@ -158,7 +157,6 @@
 			 espinfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 

--------------090600060500040707010009--
