From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/19]: Enable ip6t_ah.c to work without skb_linearize()
Date: Mon, 25 Oct 2004 02:49:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D81.70500@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050404050901080804070902"
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
--------------050404050901080804070902
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_ah to skb_header_pointer.



--------------050404050901080804070902
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:16:42+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Enable ip6t_ah.c to work without skb_linearize()
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ah.c
#   2004/10/19 02:16:15+02:00 yasuyuki.kozakai@toshiba.co.jp +9 -7
#   [NETFILTER]: Enable ip6t_ah.c to work without skb_linearize()
#      
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:38:01 +02:00
+++ b/net/ipv6/netfilter/ip6t_ah.c	2004-10-22 03:38:01 +02:00
@@ -48,7 +48,7 @@
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ip_auth_hdr *ah = NULL;
+       struct ip_auth_hdr *ah = NULL, _ah;
        const struct ip6t_ah *ahinfo = matchinfo;
        unsigned int temp;
        int len;
@@ -69,7 +69,7 @@
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_ah header iteration \n");
 
@@ -85,15 +85,16 @@
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
@@ -116,7 +117,7 @@
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -133,7 +134,8 @@
        		return 0;
        }
 
-       ah = (struct ip_auth_hdr *) (skb->data + ptr);
+       ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
+       BUG_ON(ah == NULL);
 
        DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
        DEBUGP("RES %04X ", ah->reserved);

--------------050404050901080804070902--
