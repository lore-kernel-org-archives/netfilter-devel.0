From: sebek64@post.cz (Marcel Sebek)
Subject: ip6t_LOG and packets with HOPOPTS
Date: Thu, 27 May 2004 19:18:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040527171836.GA11162@penguin.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

I think there's a bug in ip6t_LOG.c. When it get packet with
IPPROTO_HOPOPTS (=0), only 'PROTO=0' is logged and nothing more (eg.
ICMPv6 content). It's caused by wrong return value from ip6_nexthdr
indicating 'no next header' status. It is safe to use IPPROTO_NONE
instead of 0.

The following patch does it. It has been tested on my computer with
2.6.6 and 2.6.7-rc1 kernels (with usagi patches, but they don't
change this file, so it shouldn't matter).


--- ip6t_LOG.c.old	2004-05-21 18:31:12.000000000 +0200
+++ ip6t_LOG.c	2004-05-21 19:14:02.000000000 +0200
@@ -48,10 +48,10 @@
 
 /* takes in current header and pointer to the header */
 /* if another header exists, sets hdrptr to the next header
-   and returns the new header value, else returns 0 */
+   and returns the new header value, else returns IPPROTO_NONE */
 static u_int8_t ip6_nexthdr(u_int8_t currenthdr, u_int8_t **hdrptr)
 {
-	u_int8_t hdrlen, nexthdr = 0;
+	u_int8_t hdrlen, nexthdr = IPPROTO_NONE;
 
 	switch(currenthdr){
 		case IPPROTO_AH:
@@ -77,7 +77,6 @@
 			break;
 	}	
 	return nexthdr;
-
 }
 
 /* One level of recursion won't kill us */
@@ -101,7 +100,7 @@
 
 	fragment = 0;
 	hdrptr = (u_int8_t *)(ipv6h + 1);
-	while (currenthdr) {
+	while (currenthdr != IPPROTO_NONE) {
 		if ((currenthdr == IPPROTO_TCP) ||
 		    (currenthdr == IPPROTO_UDP) ||
 		    (currenthdr == IPPROTO_ICMPV6))
@@ -264,7 +263,11 @@
 		}
 		break;
 	}
-	/* Max length: 10 "PROTO 255 " */
+	/* Max length: 11 "PROTO=NONE " */
+	case IPPROTO_NONE:
+		printk("PROTO=NONE ");
+		break;
+	/* Max length: 10 "PROTO=255 " */
 	default:
 		printk("PROTO=%u ", currenthdr);
 	}

-- 
Marcel Sebek
jabber: sebek@jabber.cz                     ICQ: 279852819
linux user number: 307850                 GPG ID: 5F88735E
GPG FP: 0F01 BAB8 3148 94DB B95D  1FCA 8B63 CA06 5F88 735E
