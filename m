From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-conntrack 1/3] qa: add api test for nfct_cmp and nfct_exp functions
Date: Sat,  1 Jun 2013 14:59:29 +0200
Message-ID: <1370091571-23140-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55759 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174Ab3FANAv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Jun 2013 09:00:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some of these checks will fail due to errors in nfct_cmp STRICT handling
and missing comparision of attributes in the nfexpect_cmp functions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 The two patches following this one fix these test cases.

 I will push this in a couple of days if there are no
 objections.

 qa/test_api.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 12 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index 499d01f..e6ec240 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -82,6 +82,91 @@ static void test_nfct_bitmask(void)
 	printf("OK\n");
 }
 
+static void test_nfct_cmp_api(struct nf_conntrack *ct1, struct nf_conntrack *ct2)
+{
+	int i;
+
+	printf("== test cmp API ==\n");
+
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 0);
+
+	nfct_copy(ct1, ct2, NFCT_CP_OVERRIDE);
+
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 1);
+
+	for (i=0; i < ATTR_MAX ; i++) {
+		nfct_attr_unset(ct1, i);
+
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 0);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_MASK) == 1);
+	}
+	nfct_copy(ct1, ct2, NFCT_CP_OVERRIDE);
+	for (i=0; i < ATTR_MAX ; i++) {
+		nfct_attr_unset(ct2, i);
+
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 0);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_MASK) == 0);
+	}
+	nfct_copy(ct1, ct2, NFCT_CP_OVERRIDE);
+	for (i=0; i < ATTR_MAX ; i++) {
+		nfct_attr_unset(ct1, i);
+		nfct_attr_unset(ct2, i);
+
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 1);
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_MASK) == 1);
+	}
+	nfct_destroy(ct1);
+	nfct_destroy(ct2);
+}
+
+static void test_nfexp_cmp_api(struct nf_expect *ex1, struct nf_expect *ex2)
+{
+	int i;
+
+	printf("== test expect cmp API ==\n");
+
+	/* XXX: missing nfexp_copy API. */
+	memcpy(ex1, ex2, nfexp_maxsize());
+
+	assert(nfexp_cmp(ex1, ex2, 0) == 1);
+	assert(nfexp_cmp(ex1, ex2, NFCT_CMP_STRICT) == 1);
+
+	assert(nfexp_attr_is_set(ex1, 0) == 1);
+	nfexp_attr_unset(ex1, 0);
+	assert(nfexp_attr_is_set(ex1, 0) == 0);
+
+	memcpy(ex1, ex2, nfexp_maxsize());
+	for (i=0; i < ATTR_EXP_MAX; i++) {
+		nfexp_attr_unset(ex1, i);
+
+		assert(nfexp_cmp(ex1, ex2, 0) == 1);
+		assert(nfexp_cmp(ex1, ex2, NFCT_CMP_STRICT) == 0);
+		assert(nfexp_cmp(ex1, ex2, NFCT_CMP_MASK) == 1);
+	}
+	memcpy(ex1, ex2, nfexp_maxsize());
+	for (i=0; i < ATTR_EXP_MAX; i++) {
+		nfexp_attr_unset(ex2, i);
+
+		assert(nfexp_cmp(ex1, ex2, 0) == 1);
+		assert(nfexp_cmp(ex1, ex2, NFCT_CMP_MASK) == 0);
+	}
+	memcpy(ex1, ex2, nfexp_maxsize());
+	for (i=0; i < ATTR_EXP_MAX; i++) {
+		nfexp_attr_unset(ex1, i);
+		nfexp_attr_unset(ex2, i);
+
+		assert(nfexp_cmp(ex1, ex2, 0) == 1);
+		assert(nfexp_cmp(ex1, ex2, NFCT_CMP_STRICT) == 1);
+		assert(nfexp_cmp(ex1, ex2, NFCT_CMP_MASK) == 1);
+	}
+	nfexp_destroy(ex1);
+	nfexp_destroy(ex2);
+}
 
 int main(void)
 {
@@ -211,10 +296,9 @@ int main(void)
 		eval_sigterm(status);
 	}
 
-	printf("== test cmp API ==\n");
 	ret = fork();
 	if (ret == 0) {
-		nfct_cmp(tmp, ct, NFCT_CMP_ALL);
+		test_nfct_cmp_api(tmp, ct);
 		exit(0);
 	} else {
 		wait(&status);
@@ -276,24 +360,15 @@ int main(void)
 		eval_sigterm(status);
 	}
 
-	/* XXX: missing nfexp_copy API. */
-	memcpy(tmp_exp, exp, nfexp_maxsize());
-
-	printf("== test expect cmp API ==\n");
 	ret = fork();
 	if (ret == 0) {
-		nfexp_cmp(tmp_exp, exp, 0);
+		test_nfexp_cmp_api(tmp_exp, exp);
 		exit(0);
 	} else {
 		wait(&status);
 		eval_sigterm(status);
 	}
 
-	ct2 = nfct_clone(ct);
-	assert(ct2);
-	assert(nfct_cmp(ct, ct2, NFCT_CMP_ALL) == 1);
-	nfct_destroy(ct2);
-
 	ct2 = nfct_new();
 	if (!ct2) {
 		perror("nfct_new");
-- 
1.8.1.5

