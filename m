From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftnl PATCH 1/8] chain: Break the line properly when printing out the chain
Date: Tue, 11 Feb 2014 12:46:41 +0200
Message-ID: <1392115608-6733-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaBKKrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:03 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As when a rule is printed etc... It fixes a bug in iptables when
printing out the chain in debug mode.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/chain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/chain.c b/src/chain.c
index e26200d..86bd43a 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -849,7 +849,7 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
 		ret = snprintf(buf+offset, len,
 			       " type %s hook %s prio %d policy %s use %d "
-			       "packets %"PRIu64" bytes %"PRIu64"",
+			       "packets %"PRIu64" bytes %"PRIu64"\n",
 			       c->type, nft_hooknum2str(c->family, c->hooknum),
 			       c->prio, nft_verdict2str(c->policy), c->use,
 			       c->packets, c->bytes);
-- 
1.8.3.2

