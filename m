From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/3] introduce skb_header_pointer() to ipv6header match
Date: Mon, 01 Nov 2004 17:42:45 +0900 (JST)
Message-ID: <200411010842.iA18glBH005475@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Nov__1_17:42:45_2004_422)--"
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Mon_Nov__1_17:42:45_2004_422)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch introduces skb_header_pointer() to ipv6header match.

Signed-off-by Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_Nov__1_17:42:45_2004_422)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ipv6header-nolin.patch"

--- linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-01 16:37:54.074790232 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-01 16:37:26.603966432 +0900
@@ -51,7 +51,7 @@ ipv6header_match(const struct sk_buff *s
 	temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-        	struct ipv6_opt_hdr *hdr;
+		struct ipv6_opt_hdr _hdr, *hp;
         	int hdrlen;
 
 		/* Is there enough space for the next ext header? */
@@ -68,15 +68,16 @@ ipv6header_match(const struct sk_buff *s
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
@@ -100,7 +101,7 @@ ipv6header_match(const struct sk_buff *s
 				break;
 		}
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if (ptr > skb->len)

----Next_Part(Mon_Nov__1_17:42:45_2004_422)----
