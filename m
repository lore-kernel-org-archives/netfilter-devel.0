From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] netlink: use build_id to lower message size
Date: Thu,  3 Oct 2013 01:16:33 +0200
Message-ID: <1380755793-18011-1-git-send-email-eric@regit.org>
References: <1380755553.6862.32.camel@tiger2>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50428 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3JBXQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:16:49 -0400
In-Reply-To: <1380755553.6862.32.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

THis patch makes use of the new nft_rule_nlmsg_build_id function
from libnftables for the delete operation. This lower the size
of the netlink message sent to kernel when flushing the rules.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 27b181a..3c07156 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -292,7 +292,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
 
-	nft_rule_nlmsg_build_payload(nlh, nlr);
+	nft_rule_nlmsg_build_id(nlh, nlr);
 
 	if (!mnl_nlmsg_batch_next(batch))
 		mnl_batch_page_add();
-- 
1.8.4.rc3

