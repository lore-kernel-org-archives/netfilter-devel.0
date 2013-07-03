From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-ct] src: callback: fix memory leak when ct has dynamically allocated attr
Date: Wed,  3 Jul 2013 12:52:41 +0200
Message-ID: <1372848761-14444-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49652 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab3GCKut (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:50:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Must free ct and exp using the _destroy functions, else we leak attributes with malloc'd data.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/callback.c |   34 ++++++++--------------------------
 1 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/src/callback.c b/src/callback.c
index 684d3b2..19cc663 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -82,31 +82,13 @@ int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 		break;
 	}
 
-	switch(ret) {
-	case NFCT_CB_FAILURE:
-		if (ct)
-			free(ct);
-		if (exp)
-			free(exp);
-		ret = NFNL_CB_FAILURE;
-		break;
-	case NFCT_CB_STOP:
-		if (ct)
-			free(ct);
-		if (exp)
-			free(exp);
-		ret = NFNL_CB_STOP;
-		break;
-	case NFCT_CB_CONTINUE:
-		if (ct)
-			free(ct);
-		if (exp)
-			free(exp);
-		ret = NFNL_CB_CONTINUE;
-		break;
-	case NFCT_CB_STOLEN:
-		ret = NFNL_CB_CONTINUE;
-		break;
-	}
+	if (ret == NFCT_CB_STOLEN)
+		return NFNL_CB_CONTINUE;
+
+	if (ct)
+		nfct_destroy(ct);
+	if (exp)
+		nfexp_destroy(exp);
+
 	return ret;
 }
-- 
1.7.8.6

