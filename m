From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable-3.8.y 9/9] netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths
Date: Tue,  7 May 2013 01:05:28 +0200
Message-ID: <1367881528-15524-9-git-send-email-pablo@netfilter.org>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab3EFXGE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 19:06:04 -0400
In-Reply-To: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Matthias Schiffer <mschiffer@universe-factory.net>

The bitmask used for the prefix mangling was being calculated
incorrectly, leading to the wrong part of the address being replaced
when the prefix length wasn't a multiple of 32.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[ git cherry-pick 906b1c3 ]
---
 net/ipv6/netfilter/ip6t_NPT.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 83acc14..0ea43c7 100644
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
1.7.10.4

