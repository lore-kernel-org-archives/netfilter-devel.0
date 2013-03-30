From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH] netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths
Date: Sat, 30 Mar 2013 21:03:53 +0100
Message-ID: <bba4b68de747f6d3d580232a15592f6ba0fc6722.1364673589.git.mschiffer@universe-factory.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([5.9.180.86]:52048 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639Ab3C3UEA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:04:00 -0400
Received: from avalon.fritz.box (31-17-90-183-dynip.superkabel.de [31.17.90.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by chaos.universe-factory.net (Postfix) with ESMTPSA id 792661801CD
	for <netfilter-devel@vger.kernel.org>; Sat, 30 Mar 2013 21:03:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The bitmask used for the prefix mangling was being calculated incorrectly,
leading to the wrong part of the address being replaced when the prefix length
wasn't a multiple of 32.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
Hi, this patch should to 3.9 and, if possible, 3.8-stable.

Regards,
Matthias Schiffer

 net/ipv6/netfilter/ip6t_NPT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 33608c6..c476f16 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -57,7 +57,7 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 		if (pfx_len - i >= 32)
 			mask = 0;
 		else
-			mask = htonl(~((1 << (pfx_len - i)) - 1));
+			mask = htonl(((1 << (i - pfx_len + 32)) - 1));
 
 		idx = i / 32;
 		addr->s6_addr32[idx] &= mask;
-- 
1.8.2

