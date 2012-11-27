From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] conntrack: fix nfct_clone with certain attribute data types
Date: Tue, 27 Nov 2012 16:37:36 +0100
Message-ID: <1354030656-23507-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50579 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab2K0Pfj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:35:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

some attributes are pointers to malloc'd objects.  Simply copying the
pointer results in use-after free when the original or the clone is
destroyed.

Fix it by using nfct_copy instead of memcpy and add proper test case
for cloned objects:
- nfct_cmp of orig and clone should return 1 (equal)
- freeing both the original and the clone should
  neither leak memory nor result in double-frees.

the testsuite changes revealed a few more problems:
 - ct1->timeout == ct2->timeout returned 0, ie. same timeout
   was considered "not equal" by nfct_cmp
 - secctx comparision causes "Invalid address" valgrind warnings
   when pointer is NULL
 - NFCT_CP_OVERRIDE did not handle helper attribute and
   erronously freed ct1 secctx memory.

While at it, bump qa_test data dummy to 256 (else, valgrind
complains about move-depends-on-uninitialized-memory).

Lastly, fix compilation of test_api by killing bogus ATTR_CONNLABEL.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 qa/test_api.c           |   10 ++++++++--
 src/conntrack/api.c     |    2 +-
 src/conntrack/compare.c |    9 ++++-----
 src/conntrack/copy.c    |    3 +++
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index e44c228..cdd128a 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -2,6 +2,7 @@
  * Run this after adding a new attribute to the nf_conntrack object
  */
 
+#include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -35,7 +36,7 @@ int main(void)
 	int ret, i;
 	struct nf_conntrack *ct, *ct2, *tmp;
 	struct nf_expect *exp, *tmp_exp;
-	char data[32];
+	char data[256];
 	const char *val;
 	int status;
 
@@ -93,7 +94,6 @@ int main(void)
 			case ATTR_SECCTX:
 			case ATTR_TIMESTAMP_START:
 			case ATTR_TIMESTAMP_STOP:
-			case ATTR_CONNLABELS:
 				continue;
 			/* These attributes require special handling */
 			case ATTR_HELPER_INFO:
@@ -206,6 +206,11 @@ int main(void)
 		eval_sigterm(status);
 	}
 
+	ct2 = nfct_clone(ct);
+	assert(ct2);
+	assert(nfct_cmp(ct, ct2, NFCT_CMP_ALL) == 1);
+	nfct_destroy(ct2);
+
 	ct2 = nfct_new();
 	if (!ct2) {
 		perror("nfct_new");
@@ -271,6 +276,7 @@ int main(void)
 	}
 
 	nfct_destroy(ct2);
+	printf("== destroy cloned ct entry ==\n");
 	nfct_destroy(ct);
 	nfct_destroy(tmp);
 	nfexp_destroy(exp);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 000571f..0bc2091 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -147,7 +147,7 @@ struct nf_conntrack *nfct_clone(const struct nf_conntrack *ct)
 
 	if ((clone = nfct_new()) == NULL)
 		return NULL;
-	memcpy(clone, ct, sizeof(*ct));
+	nfct_copy(clone, ct, NFCT_CP_OVERRIDE);
 
 	return clone;
 }
diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index 830195f..b18f7fc 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -300,8 +300,8 @@ cmp_timeout(const struct nf_conntrack *ct1,
 #define __NFCT_CMP_TIMEOUT (NFCT_CMP_TIMEOUT_LE | NFCT_CMP_TIMEOUT_GT)
 
 	if (!(flags & __NFCT_CMP_TIMEOUT) &&
-	    ct1->timeout != ct2->timeout)
-	    	return 0;
+	    ct1->timeout == ct2->timeout)
+		return 1;
 	else {
 		if (flags & NFCT_CMP_TIMEOUT_GT &&
 		    ct1->timeout > ct2->timeout)
@@ -312,9 +312,6 @@ cmp_timeout(const struct nf_conntrack *ct1,
 		else if (flags & NFCT_CMP_TIMEOUT_EQ &&
 			 ct1->timeout == ct2->timeout)
 			ret = 1;
-
-	    	if (ret == 0)
-			return 0;
 	}
 	return ret;
 }
@@ -364,6 +361,8 @@ cmp_secctx(const struct nf_conntrack *ct1,
 	   const struct nf_conntrack *ct2,
 	   unsigned int flags)
 {
+	if (ct1->secctx == NULL || ct1->secctx == NULL)
+		return ct1->secctx == ct2->secctx;
 	return strcmp(ct1->secctx, ct2->secctx) == 0;
 }
 
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index a6aa9f7..e66c952 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -524,5 +524,8 @@ void __copy_fast(struct nf_conntrack *ct1, const struct nf_conntrack *ct2)
 {
 	memcpy(ct1, ct2, sizeof(*ct1));
 	/* special case: secctx attribute is allocated dinamically. */
+	ct1->secctx = NULL;	/* don't free: ct2 uses it */
+	ct1->helper_info = NULL;
 	copy_attr_secctx(ct1, ct2);
+	copy_attr_help_info(ct1, ct2);
 }
-- 
1.7.8.6

