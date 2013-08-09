From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 09/16] xtables: Add support for registering nft translation function for match
Date: Fri,  9 Aug 2013 16:31:23 +0300
Message-ID: <1376055090-26551-10-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:53 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
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

