From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [RFC PATCH 1/4] netfilter: ip6t_NPT: Fix checksuming.
Date: Sun, 27 Jan 2013 03:37:48 +0900
Message-ID: <5104227C.3030306@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: jm@dilly.me, fw@strlen.de, yoshfuji@linux-ipv6.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:57804 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSht (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:37:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cast __wsum from/to __sum16 is wrong.  Instead, apply appropriate
conversion function: csum_unfold() or csum_fold().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 7302b0b..3ff281b 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -30,7 +30,7 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 				(__force __wsum)npt->dst_pfx.in6.s6_addr16[i]);
 	}
 
-	npt->adjustment = (__force __sum16) csum_sub(src_sum, dst_sum);
+	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
 	return 0;
 }
 
@@ -66,8 +66,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 			return false;
 	}
 
-	sum = (__force __sum16) csum_add((__force __wsum)addr->s6_addr16[idx],
-			 npt->adjustment);
+	sum = csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
+				 csum_unfold(npt->adjustment)));
 	if (sum == CSUM_MANGLED_0)
 		sum = 0;
 	*(__force __sum16 *)&addr->s6_addr16[idx] = sum;
-- 
1.7.9.5


