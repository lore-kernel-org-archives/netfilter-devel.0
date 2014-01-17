From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: fix chain type autoloading
Date: Fri, 17 Jan 2014 13:22:10 +0100
Message-ID: <1389961330-18930-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52668 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaAQM3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:29:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing NLM_F_CREATE flag when creating new chains to trigger
module autoloading in the kernel.

Reported-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 1662500..d457e31 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -394,7 +394,7 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
-			NLM_F_ACK|flags, seq);
+			NLM_F_CREATE|NLM_F_ACK|flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-- 
1.7.10.4

