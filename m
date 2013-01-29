From: Ulrich Weber <ulrich.weber@gmail.com>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Tue, 29 Jan 2013 15:50:02 +0100
Message-ID: <5107E19A.4000507@gmail.com>
References: <06023CFA-4D28-43B3-8C7F-B8223F3390DD@dilly.me> <20130124224924.GH8541@breakpoint.cc> <AD70451A-D1CE-4B5A-AB9B-B30FDCD0FB7F@dilly.me> <51040455.9090003@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101040604050908010204"
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Jean-Michel DILLY <jm@dilly.me>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:40125 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3A2OuH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:50:07 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so360132lab.29
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jan 2013 06:50:05 -0800 (PST)
In-Reply-To: <51040455.9090003@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020101040604050908010204
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jean-Michel,

can you please test again with Yoshifuji's patches and attached patch?
I think csum16_add() is still not proper, we would also need a carry bit if
"result < a". We better use the internal checksum functions if possible...

Cheers
  Ulrich

--------------020101040604050908010204
Content-Type: text/x-patch;
 name="0001-netfilter-ip6t_NTP-Use-onces-complement-of-csum_fold.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-ip6t_NTP-Use-onces-complement-of-csum_fold.pa";
 filename*1="tch"

>From 40e0c6d86514a8dcc80f18fbe8a2945c6ee78f6d Mon Sep 17 00:00:00 2001
From: Ulrich Weber <ulrich.weber@sophos.com>
Date: Tue, 29 Jan 2013 15:24:21 +0100
Subject: [PATCH] netfilter: ip6t_NTP: Use onces complement of csum_fold

we need a 16bit value but not folded

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 74e171d..61a9b95 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -35,7 +35,7 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 	src_sum = csum_partial(&npt->src_pfx.in6, sizeof(npt->src_pfx.in6), 0);
 	dst_sum = csum_partial(&npt->dst_pfx.in6, sizeof(npt->dst_pfx.in6), 0);
 
-	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
+	npt->adjustment = ~csum_fold(csum_sub(src_sum, dst_sum));
 	return 0;
 }
 
@@ -71,8 +71,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 			return false;
 	}
 
-	sum = csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
-				 csum_unfold(npt->adjustment)));
+	sum = ~csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
+				  csum_unfold(npt->adjustment)));
 	if (sum == CSUM_MANGLED_0)
 		sum = 0;
 	*(__force __sum16 *)&addr->s6_addr16[idx] = sum;
-- 
1.7.9.5


--------------020101040604050908010204--
