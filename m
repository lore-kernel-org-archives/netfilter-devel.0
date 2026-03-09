Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE073DEAE2
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071118; cv=none; b=mf1Dr6dYt9+2s/710rahDoO+Ot97hqGKECYrDMXEgGYxAYXAMlRgP+k27sD1frnheLVfcO5gwiXGs6+cL2rWAk+5zm6ij3vYp3vTggm/9qlq3Z/qQv6SYPklRh3bMeMWwCqZMQrI+zf3ufaGUtLdltNUvX3WXgdafZm0IxVqe2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071118; c=relaxed/simple;
	bh=mLrqR5W+acDQMuSo7N+CS8phU4781OEiZZg0yOIsLqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bC4ImoZT6x/ffoNtlklzDPKUJe8iJLbb8f2rWtaSJYL0TaP/xALF9gMN+cq9yopq4vo55b8evZEJxZtEIEwWupfN/wv75fTWvvbyi3e5QRVR7+UQtW+hPRywpIElNx4M8OJNRsnnurG9r3mB54HbXWgvAnNrvS/ido/0YeFpPg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1D51A6047A; Mon, 09 Mar 2026 16:45:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_conntrack] tests: test_api: expose return value and fix various bugs
Date: Mon,  9 Mar 2026 16:45:05 +0100
Message-ID: <20260309154510.7079-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_api always returns 0, even if a subproccess segfaulted or asserted.

Propagate return value of children to the parent and resolve the test bugs:

1. ATTR_TIMESTAMP_EVENT is readonly, add it to the ro helper so that the
   setter tests get skipped.  Else, those cause an assertion.

2. ATTR_TIMESTAMP_EVENT doesn't implement a comparator, so skip subtest.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/test_api.c | 78 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff --git a/tests/test_api.c b/tests/test_api.c
index 57fdb902aabd..eaaf0cfee393 100644
--- a/tests/test_api.c
+++ b/tests/test_api.c
@@ -18,18 +18,29 @@
  * this file contains a test to check the set/get/copy/cmp APIs.
  */
 
-static void eval_sigterm(int status)
+static int eval_status(int status)
 {
+	if (WIFEXITED(status)) {
+		int rc =  WEXITSTATUS(status);
+
+		if (rc == 0)
+			printf("OK\n");
+		else
+			printf("FAIL\n");
+
+		return rc;
+	}
+
 	switch(WTERMSIG(status)) {
 	case SIGSEGV:
 		printf("received SIGSEV\n");
-		break;
-	case 0:
-		printf("OK\n");
-		break;
+		return 1;
+	case SIGABRT:
+		printf("received SIGABRT\n");
+		return 2;
 	default:
 		printf("exited with signal: %d\n", WTERMSIG(status));
-		break;
+		return 1;
 	}
 }
 
@@ -155,6 +166,7 @@ static int attr_is_readonly(int attr)
 	case ATTR_SECCTX:
 	case ATTR_TIMESTAMP_START:
 	case ATTR_TIMESTAMP_STOP:
+	case ATTR_TIMESTAMP_EVENT:
 		return 1;
 	}
 	return 0;
@@ -166,7 +178,7 @@ static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
 {
 	char data[256];
 	struct nfct_bitmask *b;
-	int bit;
+	int bit, is_set;
 
 	if (attr_is_readonly(attr))
 		return 0;
@@ -220,6 +232,7 @@ static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
 	case ATTR_SYNPROXY_TSOFF:
 
 	case ATTR_HELPER_INFO:
+	case ATTR_TIMESTAMP_EVENT:
 		return 0; /* XXX */
 
 	default:
@@ -243,8 +256,14 @@ static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
 	nfct_copy(ct2, ct1, NFCT_CP_OVERRIDE);
 	memset(data, 42, sizeof(data));
 
-	assert(nfct_attr_is_set(ct1, attr));
-	assert(nfct_attr_is_set(ct2, attr));
+	is_set = nfct_attr_is_set(ct1, attr);
+	if (!is_set)
+		fprintf(stderr, "attr %d is %d\n", attr, is_set);
+	assert(is_set);
+	is_set = nfct_attr_is_set(ct2, attr);
+	if (!is_set)
+		fprintf(stderr, "attr %d is %d\n", attr, is_set);
+	assert(is_set);
 
 	switch (attr) {
 	case ATTR_CONNLABELS:
@@ -481,7 +500,7 @@ static void test_nfexp_cmp_api(struct nf_expect *ex1, struct nf_expect *ex2)
 
 int main(void)
 {
-	int ret, i;
+	int ret, i, rc = 0;
 	struct nf_conntrack *ct, *ct2, *tmp;
 	struct nf_expect *exp, *tmp_exp;
 	char data[256];
@@ -514,7 +533,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	b = nfct_bitmask_new(rand() & 0xffff);
@@ -544,7 +563,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	printf("== validate set API ==\n");
@@ -576,16 +595,20 @@ int main(void)
 				continue;
 			}
 
+			if (!val) {
+			}
+
 			if (val[0] != data[0]) {
 				printf("ERROR: set/get operations don't match "
 				       "for attribute %d (%x != %x)\n",
 					i, val[0], data[0]);
+				ret = 1;
 			}
 		}
-		exit(0);
+		exit(ret);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	printf("== test copy API ==\n");
@@ -596,7 +619,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	ret = fork();
@@ -605,7 +628,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	exp = nfexp_new();
@@ -627,7 +650,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	for (i=0; i<ATTR_EXP_MAX; i++)
@@ -641,7 +664,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	printf("== validate expect set API ==\n");
@@ -660,7 +683,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	ret = fork();
@@ -669,7 +692,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	ct2 = nfct_new();
@@ -686,7 +709,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	for (i=0; i<ATTR_GRP_MAX; i++)
@@ -702,7 +725,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	printf("== validate set grp API ==\n");
@@ -733,7 +756,7 @@ int main(void)
 		exit(0);
 	} else {
 		wait(&status);
-		eval_sigterm(status);
+		rc |= eval_status(status);
 	}
 
 	nfct_destroy(ct2);
@@ -743,9 +766,12 @@ int main(void)
 	nfexp_destroy(exp);
 	nfexp_destroy(tmp_exp);
 
-	printf("OK\n");
-
 	test_nfct_bitmask();
 
-	return EXIT_SUCCESS;
+	if (rc == 0)
+		printf("OK\n");
+	else
+		printf("FAIL: errors found, exiting with %d\n", rc);
+
+	return rc;
 }
-- 
2.52.0

