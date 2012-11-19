From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] conntrack: fix nfct_clone with certain attribute data types
Date: Mon, 19 Nov 2012 22:39:55 +0100
Message-ID: <1353361195-2345-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53894 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab2KSVnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:43:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

some attributes are pointers to malloc'd objects.  Simply
copying the pointer results in use-after free
when the original or the clone is destroyed.

Also, add test case for cloned objects to ensure that
ct = nfct_new();
ct2 = nfct_clone(ct);
nfct_destroy(ct);
nfct_destroy(ct2);

won't crash due to double-frees.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 When working on the connlabel stuff I noticed that nfct_clone does a
 plain memcpy.  Afaics nfct_clone has returned a shallow copy for ages.
 But documentation implies that it really should do a deep copy.

 Pablo, could you please double-check?  Thanks!

 qa/test_api.c       |    6 ++++++
 src/conntrack/api.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index d5f95e9..fa325c8 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -2,6 +2,7 @@
  * Run this after adding a new attribute to the nf_conntrack object
  */
 
+#include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -199,6 +200,10 @@ int main(void)
 		eval_sigterm(status);
 	}
 
+	ct2 = nfct_clone(ct);
+	assert(ct2);
+	nfct_destroy(ct2);
+
 	ct2 = nfct_new();
 	if (!ct2) {
 		perror("nfct_new");
@@ -264,6 +269,7 @@ int main(void)
 	}
 
 	nfct_destroy(ct2);
+	printf("== destroy cloned ct entry ==\n");
 	nfct_destroy(ct);
 	nfct_destroy(tmp);
 	nfexp_destroy(exp);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 000571f..ebf0d52 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -147,7 +147,7 @@ struct nf_conntrack *nfct_clone(const struct nf_conntrack *ct)
 
 	if ((clone = nfct_new()) == NULL)
 		return NULL;
-	memcpy(clone, ct, sizeof(*ct));
+	nfct_copy(clone, ct, NFCT_CP_ALL);
 
 	return clone;
 }
-- 
1.7.8.6

