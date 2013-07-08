From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] rule: honor flag argument during rule creation
Date: Tue,  9 Jul 2013 01:00:24 +0200
Message-ID: <1373324424-5240-1-git-send-email-eric@regit.org>
References: <1373324177-4991-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47410 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3GHXAg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:00:36 -0400
In-Reply-To: <1373324177-4991-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index ea9637c..71fe73b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -61,7 +61,7 @@ int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			NLM_F_APPEND|NLM_F_ACK|NLM_F_CREATE, seq);
+			flags|NLM_F_ACK|NLM_F_CREATE, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-- 
1.8.3.2

