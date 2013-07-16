From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 1/9] nft: Set the rule family when creating a new one
Date: Tue, 16 Jul 2013 15:38:45 +0300
Message-ID: <1373978333-17427-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab3GPMjA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:00 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes the debug output from (in case of ipv4 rule):
	DEBUG: rule: arp filter INPUT 0
to:
	DEBUG: rule: ip filter INPUT 0

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2dba7ff..f475d28 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -690,6 +690,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 		goto err;
 	}
 
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, h->family);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, (char *)table);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, (char *)chain);
 
-- 
1.8.2.1

