From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: don't set NLM_F_ACK flag in mnl_nft_rule_batch_[add|del]
Date: Sat,  7 Dec 2013 20:24:22 +0100
Message-ID: <1386444262-4556-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60997 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab3LGTYl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 14:24:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the NLM_F_ACK flag is unset, the kernel still explicitly reports
errors. Thus, we can save the handling of many explicit (useless) ack
messages that indicate success.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 4f515e1..fe218fc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -273,7 +273,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			flags|NLM_F_ACK|NLM_F_CREATE, seqnum);
+			flags|NLM_F_CREATE, seqnum);
 
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 	if (!mnl_nlmsg_batch_next(batch))
@@ -290,7 +290,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_DELRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			NLM_F_ACK, seqnum);
+			0, seqnum);
 
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
-- 
1.7.10.4

