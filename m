From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] introducing skb_header_pointer() to ip6t_{ah,esp}.c
Date: Thu, 07 Oct 2004 11:18:33 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410070218.i972IZJd002109@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Oct__7_11:18:33_2004_516)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Oct__7_11:18:33_2004_516)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

These patches enable ip6t_{ah,esp}.c to work without skb_linearize().

Before trying these patches, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Oct__7_11:18:33_2004_516)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ah-nolin.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_ah.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_ah.c	2004-09-29 14:59:05.000000000 +0900
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ip_auth_hdr *ah = NULL;
+       struct ip_auth_hdr *ah = NULL, _ah;
        const struct ip6t_ah *ahinfo = matchinfo;
        unsigned int temp;
        int len;
@@ -69,7 +69,7 @@ match(const struct sk_buff *skb,
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_ah header iteration \n");
 
@@ -85,15 +85,16 @@ match(const struct sk_buff *skb,
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+	      BUG_ON(hp == NULL);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
                         hdrlen = 8;
                 } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hdr->hdrlen+2)<<2;
+                        hdrlen = (hp->hdrlen+2)<<2;
                 else
-                        hdrlen = ipv6_optlen(hdr);
+                        hdrlen = ipv6_optlen(hp);
 
               /* AH -> evaluate */
                 if (nexthdr == NEXTHDR_AUTH) {
@@ -116,7 +117,7 @@ match(const struct sk_buff *skb,
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -133,7 +134,8 @@ match(const struct sk_buff *skb,
        		return 0;
        }
 
-       ah = (struct ip_auth_hdr *) (skb->data + ptr);
+       ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
+       BUG_ON(ah == NULL);
 
        DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
        DEBUGP("RES %04X ", ah->reserved);

----Next_Part(Thu_Oct__7_11:18:33_2004_516)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="esp-nolin.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_esp.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_esp.c	2004-09-29 14:57:47.000000000 +0900
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	struct ip_esp_hdr *esp = NULL;
+	struct ip_esp_hdr _esp, *eh = NULL;
 	const struct ip6t_esp *espinfo = matchinfo;
 	unsigned int temp;
 	int len;
@@ -67,7 +67,7 @@ match(const struct sk_buff *skb,
 	temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-        	struct ipv6_opt_hdr *hdr;
+        	struct ipv6_opt_hdr _hdr, *hp;
         	int hdrlen;
 
 		DEBUGP("ipv6_esp header iteration \n");
@@ -85,15 +85,16 @@ match(const struct sk_buff *skb,
 			break;
 		}
 
-		hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		BUG_ON(hp == NULL);
 
 		/* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
                         hdrlen = 8;
                 } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hdr->hdrlen+2)<<2;
+                        hdrlen = (hp->hdrlen+2)<<2;
                 else
-                        hdrlen = ipv6_optlen(hdr);
+                        hdrlen = ipv6_optlen(hp);
 
 		/* set the flag */
 		switch (nexthdr){
@@ -109,7 +110,7 @@ match(const struct sk_buff *skb,
 				break;
 		}
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -126,13 +127,14 @@ match(const struct sk_buff *skb,
        		return 0;
        }
 
-	esp = (struct ip_esp_hdr *) (skb->data + ptr);
+	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
+	BUG_ON(eh == NULL);
 
-	DEBUGP("IPv6 ESP SPI %u %08X\n", ntohl(esp->spi), ntohl(esp->spi));
+	DEBUGP("IPv6 ESP SPI %u %08X\n", ntohl(eh->spi), ntohl(eh->spi));
 
-	return (esp != NULL)
+	return (eh != NULL)
 		&& spi_match(espinfo->spis[0], espinfo->spis[1],
-			      ntohl(esp->spi),
+			      ntohl(eh->spi),
 			      !!(espinfo->invflags & IP6T_ESP_INV_SPI));
 }
 

----Next_Part(Thu_Oct__7_11:18:33_2004_516)----
