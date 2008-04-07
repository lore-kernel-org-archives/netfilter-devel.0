From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: xt_hashlimit: fix mask calculation
Date: Mon, 07 Apr 2008 13:57:16 +0200
Message-ID: <47FA0C1C.70301@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000509080903060308010609"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65298 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbYDGL5T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:57:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000509080903060308010609
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The following two patches fix an invalid mask calculation
in xt_hashlimit for prefix-lengths of 32 and add a missing
module dependency from nf_nat to nf_conntrack_ipv4.

Please apply, thanks.


--------------000509080903060308010609
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 01b916505ef235308d0b3b1f688a76153583bafe
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Apr 7 13:52:15 2008 +0200

    [NETFILTER]: xt_hashlimit: fix mask calculation
    
    Shifts larger than the data type are undefined, don't try to shift
    an u32 by 32. Also remove some special-casing of bitmasks divisible
    by 32.
    
    Based on patch by Jan Engelhardt <jengelh@computergmbh.de>.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index dc29007..40d344b 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -466,38 +466,25 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 
 static inline __be32 maskl(__be32 a, unsigned int l)
 {
-	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
+	return l ? htonl(ntohl(a) & ~0 << (32 - l)) : 0;
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
 {
 	switch (p) {
-	case 0:
-		i[0] = i[1] = 0;
-		i[2] = i[3] = 0;
-		break;
-	case 1 ... 31:
+	case 0 ... 31:
 		i[0] = maskl(i[0], p);
 		i[1] = i[2] = i[3] = 0;
 		break;
-	case 32:
-		i[1] = i[2] = i[3] = 0;
-		break;
-	case 33 ... 63:
+	case 32 ... 63:
 		i[1] = maskl(i[1], p - 32);
 		i[2] = i[3] = 0;
 		break;
-	case 64:
-		i[2] = i[3] = 0;
-		break;
-	case 65 ... 95:
+	case 64 ... 95:
 		i[2] = maskl(i[2], p - 64);
 		i[3] = 0;
-	case 96:
-		i[3] = 0;
-		break;
-	case 97 ... 127:
+	case 96 ... 127:
 		i[3] = maskl(i[3], p - 96);
 		break;
 	case 128:

--------------000509080903060308010609--
