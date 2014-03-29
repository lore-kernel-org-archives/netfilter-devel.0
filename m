From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netfilter: nft_ct: add missing ifdef for NFT_MARK setting
Date: Sat, 29 Mar 2014 10:43:01 +0000
Message-ID: <1396089783-3984-2-git-send-email-kaber@trash.net>
References: <1396089783-3984-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 219.Red-2-139-50.dynamicIP.rima-tde.net ([2.139.50.219]:19630
	"EHLO macbook.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394AbaC2K5A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:57:00 -0400
In-Reply-To: <1396089783-3984-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The set operation for ct mark is only valid if CONFIG_NF_CONNTRACK_MARK is
enabled.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index bd0d41e..a2c45bd 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -268,8 +268,10 @@ static int nft_ct_init_validate_get(const struct nft_expr *expr,
 static int nft_ct_init_validate_set(uint32_t key)
 {
 	switch (key) {
+#ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
 		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.9.0

