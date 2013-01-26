From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [RFC PATCH 2/4] netfilter: ip6t_NPT: Use csum_partial().
Date: Sun, 27 Jan 2013 03:36:48 +0900
Message-ID: <51042240.1020606@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: jm@dilly.me, fw@strlen.de, yoshfuji@linux-ipv6.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:57777 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSgt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:36:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 net/ipv6/netfilter/ip6t_NPT.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 3ff281b..b1bf3ed 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -17,18 +17,13 @@
 static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 {
 	struct ip6t_npt_tginfo *npt = par->targinfo;
-	__wsum src_sum = 0, dst_sum = 0;
-	unsigned int i;
+	__wsum src_sum, dst_sum;
 
 	if (npt->src_pfx_len > 64 || npt->dst_pfx_len > 64)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(npt->src_pfx.in6.s6_addr16); i++) {
-		src_sum = csum_add(src_sum,
-				(__force __wsum)npt->src_pfx.in6.s6_addr16[i]);
-		dst_sum = csum_add(dst_sum,
-				(__force __wsum)npt->dst_pfx.in6.s6_addr16[i]);
-	}
+	src_sum = csum_partial(&npt->src_pfx.in6, sizeof(npt->src_pfx.in6), 0);
+	dst_sum = csum_partial(&npt->dst_pfx.in6, sizeof(npt->dst_pfx.in6), 0);
 
 	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
 	return 0;
-- 
1.7.9.5


