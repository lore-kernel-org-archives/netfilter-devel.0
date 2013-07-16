From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 9/9] nft: Fix small memory leaks
Date: Tue, 16 Jul 2013 15:38:53 +0300
Message-ID: <1373978333-17427-10-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab3GPMjM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:12 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2056032..0c0ca60 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2609,6 +2609,8 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
+
 	return 1;
 }
 
@@ -2646,6 +2648,8 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
+
+	nft_chain_list_iter_destroy(iter);
 err:
 	nft_chain_list_free(list);
 
-- 
1.8.2.1

