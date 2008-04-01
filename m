From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask
 patch
Date: Tue, 01 Apr 2008 14:49:39 +0200
Message-ID: <47F22F63.8020102@trash.net>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com> <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040402050602000608070509"
Cc: Iavor Stoev <iavor@icdsoft.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61177 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYDAMtu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:49:50 -0400
In-Reply-To: <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040402050602000608070509
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> [NETFILTER]: xt_hashlimit: add workaround for >>32 case
> 
> Hardware surprisingly does nothing when a 32-bit right-shift is
> to be done. Worse yet, compilers do not even work around it.

Thats because the C standard states that the result is undefined.
Anyways, I think this patch is slightly nicer because it
gets rid of the double negation and the %32 == 0 special-casing
for IPv6.

Do you want to add an ACKed-by?

--------------040402050602000608070509
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 830213d52cb7a7e003335003bd56bf82d6153dcf
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Apr 1 14:48:04 2008 +0200

    [NETFILTER]: xt_hashlimit: fix mask calculation
    
    Shifts larger than the data type are undefined, don't try to shift
    an u32 by 32. Also remove some special-casing of bitmasks divisible
    by 32.
    
    Based on patch by Jan Engelhardt <jengelh@computergmbh.de>.

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

--------------040402050602000608070509--
