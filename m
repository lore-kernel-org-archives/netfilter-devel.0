From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/9]: Fix multiple bugs in ipv6header match
Date: Mon, 15 Nov 2004 22:44:00 +0100
Message-ID: <41992320.9020703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020205060204070200010500"
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
--------------020205060204070200010500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes an invalid cast and unlogical inverse match in
the ipv6header match.



--------------020205060204070200010500
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/04 03:12:42+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix multiple bugs in ipv6header match
#   
#   This patch fixes following bugs in ip6t_ipv6header.c
#   
#   - The cast of the pointer to the next IPv6 extension header is wrong.
#   - The logical operation is wrong. These fixes intends
#   
#   	- soft mode without invert flag "!"
#   		match if the packet contains all of the specified headers.
#   
#   	- soft mode with invert flag "!"
#   		match if the packet DOESN'T contain all of the specified
#   		headers.
#   
#   	- strict mode without invert flag "!"
#   		match if the packet contains JUST ONLY the specified headers.
#   		if the packet doesn't contain some specified headers or
#   		contains unspecified headers, the packet doesn't match with
#   		rule.
#   
#   	- strict mode with invert flag "!"
#   		NOT MATCH if the packet contains JUST ONLY the specified
#   		headers. Otherwise, match. So, if the packet contains some
#   		specified headers and DOESN'T contain other specified headers,
#   		the packet MATCHES with rule.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_ipv6header.c
#   2004/11/04 03:12:35+01:00 yasuyuki.kozakai@toshiba.co.jp +16 -5
#   [NETFILTER]: Fix multiple bugs in ipv6header match
#   
#   This patch fixes following bugs in ip6t_ipv6header.c
#   
#   - The cast of the pointer to the next IPv6 extension header is wrong.
#   - The logical operation is wrong. These fixes intends
#   
#   	- soft mode without invert flag "!"
#   		match if the packet contains all of the specified headers.
#   
#   	- soft mode with invert flag "!"
#   		match if the packet DOESN'T contain all of the specified
#   		headers.
#   
#   	- strict mode without invert flag "!"
#   		match if the packet contains JUST ONLY the specified headers.
#   		if the packet doesn't contain some specified headers or
#   		contains unspecified headers, the packet doesn't match with
#   		rule.
#   
#   	- strict mode with invert flag "!"
#   		NOT MATCH if the packet contains JUST ONLY the specified
#   		headers. Otherwise, match. So, if the packet contains some
#   		specified headers and DOESN'T contain other specified headers,
#   		the packet MATCHES with rule.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
--- a/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-15 22:06:09 +01:00
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c	2004-11-15 22:06:09 +01:00
@@ -68,7 +68,7 @@
 			break;
 		}
 
-		hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+		hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
 		/* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -111,10 +111,14 @@
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
@@ -124,9 +128,16 @@
 		      unsigned int matchsize,
 		      unsigned int hook_mask)
 {
+	const struct ip6t_ipv6header_info *info = matchinfo;
+
 	/* Check for obvious errors */
 	/* This match is valid in all hooks! */
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)))
+		return 0;
+
+	/* invflags is 0 or 0xff in hard mode */
+	if ((!info->modeflag) && info->invflags != 0x00
+			      && info->invflags != 0xFF)
 		return 0;
 
 	return 1;

--------------020205060204070200010500--
