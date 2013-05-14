From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 7/7] chain: handle attribute is relevant if only there is no name to use
Date: Tue, 14 May 2013 13:51:22 +0300
Message-ID: <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:40 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While changing chain's settings, like its policy, it requires either the
handle or the name, but not both.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/chain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/chain.c b/src/chain.c
index 1b1c3fe..e9a7896 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -263,7 +263,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
 		mnl_attr_nest_end(nlh, nest);
 	}
-	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE))
+	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE) &&
+	    !(c->flags & (1 << NFT_CHAIN_ATTR_NAME)))
 		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE, be64toh(c->handle));
 	if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
-- 
1.8.2.1

