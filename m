From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: fix wrong check of NFT_SET_MAP in nf_tables_bind_set
Date: Sat, 11 Jun 2016 12:20:26 +0800
Message-ID: <1465618828-22162-2-git-send-email-zlpnobody@163.com>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49442 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbcFKEVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 00:21:17 -0400
In-Reply-To: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We should check "i" is used as a dictionary or not, "binding" is already
checked before.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4d292b9..e4a6d7e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2944,7 +2944,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		 * jumps are already validated for that chain.
 		 */
 		list_for_each_entry(i, &set->bindings, list) {
-			if (binding->flags & NFT_SET_MAP &&
+			if (i->flags & NFT_SET_MAP &&
 			    i->chain == binding->chain)
 				goto bind;
 		}
-- 
2.5.5


