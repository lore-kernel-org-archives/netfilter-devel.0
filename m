From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [RFC PATCH 4/4] netfilter: ip6t_NPT: Do not mix two prefixes.
Date: Sun, 27 Jan 2013 03:38:44 +0900
Message-ID: <510422B4.8020204@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: jm@dilly.me, fw@strlen.de, yoshfuji@linux-ipv6.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:57837 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSip (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:38:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 net/ipv6/netfilter/ip6t_NPT.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 7d23d22..74e171d 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -56,7 +56,7 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 
 		idx = i / 32;
 		addr->s6_addr32[idx] &= mask;
-		addr->s6_addr32[idx] |= npt->dst_pfx.in6.s6_addr32[idx];
+		addr->s6_addr32[idx] |= ~mask & npt->dst_pfx.in6.s6_addr32[idx];
 	}
 
 	if (pfx_len <= 48)
-- 
1.7.9.5

