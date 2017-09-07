From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] chain: Don't print unset policy value in netlink debug
Date: Thu,  7 Sep 2017 19:41:27 +0200
Message-ID: <20170907174127.1909-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35026 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdIGRlj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2017 13:41:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The policy field was printed unconditionally, but if it wasn't set the
default value 0 was printed as 'policy drop' which is not correct.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 29860c509a180..3190a775a0005 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -795,11 +795,19 @@ static int nftnl_chain_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (c->flags & (1 << NFTNL_CHAIN_HOOKNUM)) {
-		ret = snprintf(buf+offset, len,
-			       " type %s hook %s prio %d policy %s "
-			       "packets %"PRIu64" bytes %"PRIu64"",
+		ret = snprintf(buf+offset, len, " type %s hook %s prio %d",
 			       c->type, nftnl_hooknum2str(c->family, c->hooknum),
-			       c->prio, nftnl_verdict2str(c->policy),
+			       c->prio);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (c->flags & (1 << NFTNL_CHAIN_POLICY)) {
+			ret = snprintf(buf+offset, len, " policy %s",
+				       nftnl_verdict2str(c->policy));
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf+offset, len,
+			       " packets %"PRIu64" bytes %"PRIu64"",
 			       c->packets, c->bytes);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.13.1

