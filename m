From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 7/19]: Enable ip6t_esp.c to work without skb_linearize()
Date: Mon, 25 Oct 2004 02:49:18 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D8E.7020402@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000805010005090402000806"
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
--------------000805010005090402000806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_esp to skb_header_pointer.



--------------000805010005090402000806
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:19:33+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Enable ip6t_esp.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_esp.c
#   2004/10/19 02:19:06+02:00 yasuyuki.kozakai@toshiba.co.jp +12 -10
#   [NETFILTER]: Enable ip6t_esp.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:38:39 +02:00
+++ b/net/ipv6/netfilter/ip6t_esp.c	2004-10-22 03:38:39 +02:00
@@ -48,7 +48,7 @@
       unsigned int protoff,
       int *hotdrop)
 {
-	struct ip_esp_hdr *esp = NULL;
+	struct ip_esp_hdr _esp, *eh = NULL;
 	const struct ip6t_esp *espinfo = matchinfo;
 	unsigned int temp;
 	int len;
@@ -67,7 +67,7 @@
 	temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-        	struct ipv6_opt_hdr *hdr;
+        	struct ipv6_opt_hdr _hdr, *hp;
         	int hdrlen;
 
 		DEBUGP("ipv6_esp header iteration \n");
@@ -85,15 +85,16 @@
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
@@ -109,7 +110,7 @@
 				break;
 		}
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -126,13 +127,14 @@
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
 

--------------000805010005090402000806--
