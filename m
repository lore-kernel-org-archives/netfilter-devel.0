From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/9]: introduce skb_header_pointer() to ipv6header match
Date: Mon, 15 Nov 2004 22:44:12 +0100
Message-ID: <4199232C.6010408@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030301000007000304090807"
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
--------------030301000007000304090807
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ipt_ipv6header match to skb_header_pointer.



--------------030301000007000304090807
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/04 03:14:26+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: introduce skb_header_pointer() to ipv6header match
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ipv6header.c
#   2004/11/04 03:14:19+01:00 yasuyuki.kozakai@toshiba.co.jp +6 -5
#   [NETFILTER]: introduce skb_header_pointer() to ipv6header match
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
--- a/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-15 22:06:19 +01:00
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-15 22:06:19 +01:00
@@ -51,7 +51,7 @@
 	temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-        	struct ipv6_opt_hdr *hdr;
+		struct ipv6_opt_hdr _hdr, *hp;
         	int hdrlen;
 
 		/* Is there enough space for the next ext header? */
@@ -68,15 +68,16 @@
 			break;
 		}
 
-		hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
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
@@ -100,7 +101,7 @@
 				break;
 		}
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if (ptr > skb->len)

--------------030301000007000304090807--
