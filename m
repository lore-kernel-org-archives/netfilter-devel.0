From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] chain: print usage counter for base chain via default output as well
Date: Tue, 11 Feb 2014 12:24:25 +0100
Message-ID: <1392117865-5109-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38261 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaBKLYf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:24:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For some reason this was only printed in custom chains. Print it for
any chain, this is useful for debugging purposes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 2cc7c61..34eb91d 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -843,16 +843,16 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, len, "%s %s %s",
-		       nft_family2str(c->family), c->table, c->name);
+	ret = snprintf(buf, len, "%s %s %s use %u",
+		       nft_family2str(c->family), c->table, c->name, c->use);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
 		ret = snprintf(buf+offset, len,
-			       " type %s hook %s prio %d policy %s use %d "
+			       " type %s hook %s prio %d policy %s "
 			       "packets %"PRIu64" bytes %"PRIu64"",
 			       c->type, nft_hooknum2str(c->family, c->hooknum),
-			       c->prio, nft_verdict2str(c->policy), c->use,
+			       c->prio, nft_verdict2str(c->policy),
 			       c->packets, c->bytes);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-- 
1.7.10.4

