From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3] fixes for ipv6header match
Date: Mon, 01 Nov 2004 17:42:17 +0900 (JST)
Message-ID: <200411010842.iA18gINc004549@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Nov__1_17:42:17_2004_268)--"
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

----Next_Part(Mon_Nov__1_17:42:17_2004_268)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes following bugs in ip6t_ipv6header.c

- The cast of the pointer to the next IPv6 extension header is wrong.
- The logical operation is wrong. These fixes intends

	- soft mode without invert flag "!"
		match if the packet contains all of the specified headers.

	- soft mode with invert flag "!"
		match if the packet DOESN'T contain all of the specified
		headers.

	- strict mode without invert flag "!"
		match if the packet contains JUST ONLY the specified headers.
		if the packet doesn't contain some specified headers or
		contains unspecified headers, the packet doesn't match with
		rule.

	- strict mode with invert flag "!"
		NOT MATCH if the packet contains JUST ONLY the specified
		headers. Otherwise, match. So, if the packet contains some
		specified headers and DOESN'T contain other specified headers,
		the packet MATCHES with rule.

By the way, I think UI like "--tcp-flags" is preferred than the current UI.
But anyway, the current bugs in mainline kernel should be fixed at first.

Signed-off-by Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_Nov__1_17:42:17_2004_268)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ipv6header-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_ipv6header.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-01 16:37:54.074790232 +0900
@@ -68,7 +68,7 @@ ipv6header_match(const struct sk_buff *s
 			break;
 		}
 
-		hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+		hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
 		/* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -111,10 +111,14 @@ ipv6header_match(const struct sk_buff *s
 		temp |= MASK_PROTO;
 
 	if (info->modeflag)
-		return (!( (temp & info->matchflags)
-			^ info->matchflags) ^ info->invflags);
-	else
-		return (!( temp ^ info->matchflags) ^ info->invflags);
+		return !((temp ^ info->matchflags ^ info->invflags)
+			 & info->matchflags);
+	else {
+		if (info->invflags)
+			return temp != info->matchflags;
+		else
+			return temp == info->matchflags;
+	}
 }
 
 static int
@@ -124,11 +128,18 @@ ipv6header_checkentry(const char *tablen
 		      unsigned int matchsize,
 		      unsigned int hook_mask)
 {
+	const struct ip6t_ipv6header_info *info = matchinfo;
+
 	/* Check for obvious errors */
 	/* This match is valid in all hooks! */
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)))
 		return 0;
 
+	/* invflags is 0 or 0xff in hard mode */
+	if ((!info->modeflag) && info->invflags != 0x00
+			      && info->invflags != 0xFF)
+		return 0;
+
 	return 1;
 }
 

----Next_Part(Mon_Nov__1_17:42:17_2004_268)----
