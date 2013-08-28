From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 1/5] src: Fix base chain print out
Date: Wed, 28 Aug 2013 11:33:07 +0300
Message-ID: <1377678791-7616-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab3H1IdR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:17 -0400
In-Reply-To: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Relying on chain's hooknum to know whether the chain is a base one or
not is bogus: having 0 as hooknum is a valid number. Thus setting the
right flag and handling it is the way to go, as parser does already.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/netlink.c | 4 +++-
 src/rule.c    | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 962561f..7f99416 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -535,7 +535,9 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 		chain->priority      =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
 		chain->type          =
-			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
+			xstrdup(nft_chain_attr_get_str(nlc,
+				NFT_CHAIN_ATTR_TYPE));
+		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 	list_add_tail(&chain->list, &ctx->list);
 
diff --git a/src/rule.c b/src/rule.c
index fb0387c..73054ba 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -249,7 +249,7 @@ static void chain_print(const struct chain *chain)
 	struct rule *rule;
 
 	printf("\tchain %s {\n", chain->handle.chain);
-	if (chain->hooknum) {
+	if (chain->flags & CHAIN_F_BASECHAIN) {
 		printf("\t\t type %s hook %s %u;\n", chain->type,
 		       hooknum2str(chain->hooknum), chain->priority);
 	}
-- 
1.8.3.2

