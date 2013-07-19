From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  09/15] xtables: Add support for registering nft translation function for match
Date: Fri, 19 Jul 2013 18:17:38 +0300
Message-ID: <1374247064-3361-10-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GSPSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:12 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 1658842..592aae9 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -264,6 +264,7 @@ struct xtables_match
 
 	/* NFT related */
 	int (*to_nft)(struct nft_rule *r, struct xt_entry_match *);
+	int (*register_nft_instructions)(struct nft_trans_instruction_tree *);
 
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
-- 
1.8.3.2

