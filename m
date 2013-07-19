From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH] nft: A non valid if index should not be handled
Date: Fri, 19 Jul 2013 15:28:34 +0300
Message-ID: <1374236914-14401-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3GSM2j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:28:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c0ee4c8..5762952 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -226,18 +226,16 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_IN;
 
-		if_indextoname(value, iniface);
-
-		memset(iniface_mask, 0xff, strlen(iniface)+1);
+		if (if_indextoname(value, iniface) != NULL)
+			memset(iniface_mask, 0xff, strlen(iniface)+1);
 		break;
 	case NFT_META_OIF:
 		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_OUT;
 
-		if_indextoname(value, outiface);
-
-		memset(outiface_mask, 0xff, strlen(outiface)+1);
+		if (if_indextoname(value, outiface) != NULL)
+			memset(outiface_mask, 0xff, strlen(outiface)+1);
 		break;
 	case NFT_META_IIFNAME:
 		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-- 
1.8.3.2

