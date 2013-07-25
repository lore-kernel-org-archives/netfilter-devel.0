From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  10/17] xtables: Add support for registering nft translation function for match
Date: Thu, 25 Jul 2013 20:16:30 +0300
Message-ID: <1374772597-20548-11-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3GYRQ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:56 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the method which will be called by the core to register the xtables 
matches extensions into the nft translator. Through that method, the extension
will provide the combination of pattern/parser to the translation tree.


Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/xtables.h b/include/xtables.h
index fe1f31c..03139a0 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -274,6 +274,7 @@ struct xtables_match
 
 	/* NFT related */
 	int (*to_nft)(struct nft_rule *r, struct xt_entry_match *);
+	int (*register_nft_instructions)(struct nft_trans_instruction_tree *);
 
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
-- 
1.8.3.2

