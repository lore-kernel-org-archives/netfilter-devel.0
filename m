From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCHv2] netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths
Date: Sat, 30 Mar 2013 21:23:12 +0100
Message-ID: <cf3234de124418a6954f079e473c3e01ea96952f.1364674922.git.mschiffer@universe-factory.net>
References: <bba4b68de747f6d3d580232a15592f6ba0fc6722.1364673589.git.mschiffer@universe-factory.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([5.9.180.86]:52197 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639Ab3C3UYU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:24:20 -0400
Received: from avalon.fritz.box (31-17-90-183-dynip.superkabel.de [31.17.90.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by chaos.universe-factory.net (Postfix) with ESMTPSA id 811601801CD
	for <netfilter-devel@vger.kernel.org>; Sat, 30 Mar 2013 21:24:18 +0100 (CET)
In-Reply-To: <bba4b68de747f6d3d580232a15592f6ba0fc6722.1364673589.git.mschiffer@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The bitmask used for the prefix mangling was being calculated incorrectly,
leading to the wrong part of the address being replaced when the prefix length
wasn't a multiple of 32.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
Hi, this patch should to 3.9 and, if possible, 3.8-stable.

v2: Remove a redundant pair of parentheses.

Regards,
Matthias Schiffer

 net/ipv6/netfilter/ip6t_NPT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 33608c6..cb63114 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -57,7 +57,7 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 		if (pfx_len - i >= 32)
 			mask = 0;
 		else
-			mask = htonl(~((1 << (pfx_len - i)) - 1));
+			mask = htonl((1 << (i - pfx_len + 32)) - 1);
 
 		idx = i / 32;
 		addr->s6_addr32[idx] &= mask;
-- 
1.8.2

