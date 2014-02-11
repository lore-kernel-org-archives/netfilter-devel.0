From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 5/8] nft: Fix error message to output proper origin
Date: Tue, 11 Feb 2014 12:46:45 +0200
Message-ID: <1392115608-6733-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaBKKrH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:07 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So it prints "mnl_talk:__nft_chain_set" instead of
"mnl_talk:__nft_chain_policy".

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index fc9db99..3df0e47 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -745,7 +745,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 
 	ret = mnl_talk(h, nlh, NULL, NULL);
 	if (ret < 0)
-		perror("mnl_talk:__nft_chain_policy");
+		perror("mnl_talk:__nft_chain_set");
 
 	return ret;
 }
-- 
1.8.3.2

