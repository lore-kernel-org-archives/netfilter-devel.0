From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/19]: Introduce tabs to ip6t_ah.c
Date: Mon, 25 Oct 2004 02:49:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D89.1000002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080707070406000800050700"
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
--------------080707070406000800050700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Whitespace cleanup, someone's tab-key seems to be broken.



--------------080707070406000800050700
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:18:14+02:00 kaber@coreworks.de 
#   [NETFILTER]: Introduce tabs to ip6t_ah.c
#   
#   Fix horrible indentation, not a single tab in the file.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ah.c
#   2004/10/19 02:17:48+02:00 kaber@coreworks.de +130 -134
#   [NETFILTER]: Introduce tabs to ip6t_ah.c
#   
#   Fix horrible indentation, not a single tab in the file.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:38:20 +02:00
+++ b/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:38:20 +02:00
@@ -31,12 +31,12 @@
 static inline int
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
 {
-       int r=0;
-       DEBUGP("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-              min,spi,max);
-       r=(spi >= min && spi <= max) ^ invert;
-       DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
-       return r;
+	int r=0;
+	DEBUGP("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
+	       min,spi,max);
+	r = (spi >= min && spi <= max) ^ invert;
+	DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
+	return r;
 }
 
 static int
@@ -48,123 +48,121 @@
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ip_auth_hdr *ah = NULL, _ah;
-       const struct ip6t_ah *ahinfo = matchinfo;
-       unsigned int temp;
-       int len;
-       u8 nexthdr;
-       unsigned int ptr;
-       unsigned int hdrlen = 0;
-
-       /*DEBUGP("IPv6 AH entered\n");*/
-       /* if (opt->auth == 0) return 0;
-       * It does not filled on output */
-
-       /* type of the 1st exthdr */
-       nexthdr = skb->nh.ipv6h->nexthdr;
-       /* pointer to the 1st exthdr */
-       ptr = sizeof(struct ipv6hdr);
-       /* available length */
-       len = skb->len - ptr;
-       temp = 0;
-
-        while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr _hdr, *hp;
-
-              DEBUGP("ipv6_ah header iteration \n");
-
-              /* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
-              /* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
-                     break;
-              }
-              /* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
-                     break;
-              }
-
-	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-	      BUG_ON(hp == NULL);
-
-              /* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
-
-              /* AH -> evaluate */
-                if (nexthdr == NEXTHDR_AUTH) {
-                     temp |= MASK_AH;
-                     break;
-              }
-
-
-              /* set the flag */
-              switch (nexthdr){
-                     case NEXTHDR_HOP:
-                     case NEXTHDR_ROUTING:
-                     case NEXTHDR_FRAGMENT:
-                     case NEXTHDR_AUTH:
-                     case NEXTHDR_DEST:
-                            break;
-                     default:
-                            DEBUGP("ipv6_ah match: unknown nextheader %u\n",nexthdr);
-                            return 0;
-                            break;
-              }
-
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
-			DEBUGP("ipv6_ah: new pointer too large! \n");
+	struct ip_auth_hdr *ah = NULL, _ah;
+	const struct ip6t_ah *ahinfo = matchinfo;
+	unsigned int temp;
+	int len;
+	u8 nexthdr;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+
+	/*DEBUGP("IPv6 AH entered\n");*/
+	/* if (opt->auth == 0) return 0;
+	* It does not filled on output */
+
+	/* type of the 1st exthdr */
+	nexthdr = skb->nh.ipv6h->nexthdr;
+	/* pointer to the 1st exthdr */
+	ptr = sizeof(struct ipv6hdr);
+	/* available length */
+	len = skb->len - ptr;
+	temp = 0;
+
+	while (ip6t_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		DEBUGP("ipv6_ah header iteration \n");
+
+		/* Is there enough space for the next ext header? */
+		if (len < sizeof(struct ipv6_opt_hdr))
+			return 0;
+		/* No more exthdr -> evaluate */
+		if (nexthdr == NEXTHDR_NONE)
+			break;
+		/* ESP -> evaluate */
+		if (nexthdr == NEXTHDR_ESP)
+			break;
+
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		BUG_ON(hp == NULL);
+
+		/* Calculate the header length */
+		if (nexthdr == NEXTHDR_FRAGMENT)
+			hdrlen = 8;
+		else if (nexthdr == NEXTHDR_AUTH)
+			hdrlen = (hp->hdrlen+2)<<2;
+		else
+			hdrlen = ipv6_optlen(hp);
+
+		/* AH -> evaluate */
+		if (nexthdr == NEXTHDR_AUTH) {
+			temp |= MASK_AH;
+			break;
+		}
+
+		
+		/* set the flag */
+		switch (nexthdr) {
+		case NEXTHDR_HOP:
+		case NEXTHDR_ROUTING:
+		case NEXTHDR_FRAGMENT:
+		case NEXTHDR_AUTH:
+		case NEXTHDR_DEST:
 			break;
+		default:
+			DEBUGP("ipv6_ah match: unknown nextheader %u\n",nexthdr);
+			return 0;
 		}
-        }
 
-       /* AH header not found */
-       if ( temp != MASK_AH ) return 0;
+		nexthdr = hp->nexthdr;
+		len -= hdrlen;
+		ptr += hdrlen;
+		if (ptr > skb->len) {
+			DEBUGP("ipv6_ah: new pointer too large! \n");
+			break;
+		}
+	}
 
-       if (len < (int)sizeof(struct ip_auth_hdr)){
-	       *hotdrop = 1;
-       		return 0;
-       }
-
-       ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
-       BUG_ON(ah == NULL);
-
-       DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
-       DEBUGP("RES %04X ", ah->reserved);
-       DEBUGP("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
-
-       DEBUGP("IPv6 AH spi %02X ",
-       		(spi_match(ahinfo->spis[0], ahinfo->spis[1],
-                           ntohl(ah->spi),
-                           !!(ahinfo->invflags & IP6T_AH_INV_SPI))));
-       DEBUGP("len %02X %04X %02X ",
-       		ahinfo->hdrlen, hdrlen,
-       		(!ahinfo->hdrlen ||
-                           (ahinfo->hdrlen == hdrlen) ^
-                           !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
-       DEBUGP("res %02X %04X %02X\n", 
-       		ahinfo->hdrres, ah->reserved,
-       		!(ahinfo->hdrres && ah->reserved));
-
-       return (ah != NULL)
-              &&
-              (spi_match(ahinfo->spis[0], ahinfo->spis[1],
-                           ntohl(ah->spi),
-                           !!(ahinfo->invflags & IP6T_AH_INV_SPI)))
-              &&
-              (!ahinfo->hdrlen ||
-                           (ahinfo->hdrlen == hdrlen) ^
-                           !!(ahinfo->invflags & IP6T_AH_INV_LEN))
-              &&
-              !(ahinfo->hdrres && ah->reserved);
+	/* AH header not found */
+	if (temp != MASK_AH)
+		return 0;
+
+	if (len < sizeof(struct ip_auth_hdr)){
+		*hotdrop = 1;
+		return 0;
+	}
+
+	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
+	BUG_ON(ah == NULL);
+
+	DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
+	DEBUGP("RES %04X ", ah->reserved);
+	DEBUGP("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
+
+	DEBUGP("IPv6 AH spi %02X ",
+	       (spi_match(ahinfo->spis[0], ahinfo->spis[1],
+	                  ntohl(ah->spi),
+	                  !!(ahinfo->invflags & IP6T_AH_INV_SPI))));
+	DEBUGP("len %02X %04X %02X ",
+	       ahinfo->hdrlen, hdrlen,
+	       (!ahinfo->hdrlen ||
+	        (ahinfo->hdrlen == hdrlen) ^
+	        !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
+	DEBUGP("res %02X %04X %02X\n",
+	       ahinfo->hdrres, ah->reserved,
+	       !(ahinfo->hdrres && ah->reserved));
+
+	return (ah != NULL)
+	       &&
+	       (spi_match(ahinfo->spis[0], ahinfo->spis[1],
+	                  ntohl(ah->spi),
+	                  !!(ahinfo->invflags & IP6T_AH_INV_SPI)))
+	       &&
+	       (!ahinfo->hdrlen ||
+	        (ahinfo->hdrlen == hdrlen) ^
+	        !!(ahinfo->invflags & IP6T_AH_INV_LEN))
+	       &&
+	       !(ahinfo->hdrres && ah->reserved);
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -175,20 +173,18 @@
           unsigned int matchinfosize,
           unsigned int hook_mask)
 {
-       const struct ip6t_ah *ahinfo = matchinfo;
-
-       if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_ah))) {
-              DEBUGP("ip6t_ah: matchsize %u != %u\n",
-                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_ah)));
-              return 0;
-       }
-       if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
-              DEBUGP("ip6t_ah: unknown flags %X\n",
-                      ahinfo->invflags);
-              return 0;
-       }
+	const struct ip6t_ah *ahinfo = matchinfo;
 
-       return 1;
+	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_ah))) {
+		DEBUGP("ip6t_ah: matchsize %u != %u\n",
+		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_ah)));
+		return 0;
+	}
+	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
+		DEBUGP("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
+		return 0;
+	}
+	return 1;
 }
 
 static struct ip6t_match ah_match = {
@@ -200,12 +196,12 @@
 
 static int __init init(void)
 {
-       return ip6t_register_match(&ah_match);
+	return ip6t_register_match(&ah_match);
 }
 
 static void __exit cleanup(void)
 {
-       ip6t_unregister_match(&ah_match);
+	ip6t_unregister_match(&ah_match);
 }
 
 module_init(init);

--------------080707070406000800050700--
