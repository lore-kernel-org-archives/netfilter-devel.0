From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: Use strlcpy to copy dev name instead of strncpy
Date: Tue, 27 Dec 2016 19:16:53 +0800
Message-ID: <1482837413-32048-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg339.qq.com ([14.17.44.34]:55223 "EHLO smtpbg339.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753437AbcL0LRq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Dec 2016 06:17:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The current codes use strncpy to copy the dev name in
nf_tables_newchain, there is no real issue now. Because the sizes of
src and dst are IFNAMSIZ. But normally it should use count-1 with
strncpy, because strncpy doesn't make sure the dst must be
NULL-terminated when src exceeds the count bytes.
So use strlcpy to replace the strncpy to make it clearer.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..dc50801 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1488,7 +1488,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		}
 
 		if (hook.dev != NULL)
-			strncpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
+			strlcpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-- 
1.9.1


