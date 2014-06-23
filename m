From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 1/2 libnetfilter_conntrack] qa: update cmp ATTR_ZONE size
 mark and zone
Date: Mon, 23 Jun 2014 19:15:19 +0900
Message-ID: <20140623101519.GB29052@gmail.com>
References: <20140617120405.GA24712@gmail.com>
 <20140619151611.GC13029@breakpoint.cc>
 <20140623101235.GA29052@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41459 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaFWKPZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:15:25 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so5470418pbc.30
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 03:15:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140623101235.GA29052@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 qa/test_api.c | 102 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 24 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index 91b3dbf..1335b23 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -243,17 +243,17 @@ static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
 	return 0;
 }
 
-static int test_cmp_attr32(int attr, bool at1, bool at2,
-			   uint32_t v1, uint32_t v2, unsigned int flags)
+static int test_cmp_attr16(int attr, bool at1, bool at2,
+			   uint16_t v1, uint16_t v2, unsigned int flags)
 {
 	struct nf_conntrack *ct1 = nfct_new();
 	struct nf_conntrack *ct2 = nfct_new();
 	int ret;
 
 	if (at1)
-		nfct_set_attr_u32(ct1, attr, v1);
+		nfct_set_attr_u16(ct1, attr, v1);
 	if (at2)
-		nfct_set_attr_u32(ct2, attr, v2);
+		nfct_set_attr_u16(ct2, attr, v2);
 
 	ret = nfct_cmp(ct1, ct2, NFCT_CMP_ALL | flags);
 
@@ -264,26 +264,80 @@ static int test_cmp_attr32(int attr, bool at1, bool at2,
 }
 static void test_nfct_cmp_attr(int attr)
 {
-	assert(test_cmp_attr32(ATTR_ZONE, false, false, 0, 0, 0) == 1);
-	assert(test_cmp_attr32(ATTR_ZONE, true, true, 0, 0, 0) == 1);
-	assert(test_cmp_attr32(ATTR_ZONE, true, true, 1, 1, 0) == 1);
-
-	/* This compare should be true */
-	assert(test_cmp_attr32(ATTR_ZONE, false, true, 0, 1, 0) == 1);
-
-	assert(test_cmp_attr32(ATTR_ZONE, true, true, 1, 1, NFCT_CMP_STRICT) == 1);
-
-	assert(test_cmp_attr32(ATTR_ZONE, true, false, 0, 0, NFCT_CMP_STRICT) == 1);
-	assert(test_cmp_attr32(ATTR_ZONE, false, true, 0, 0, NFCT_CMP_STRICT) == 1);
-
-	assert(test_cmp_attr32(ATTR_ZONE, false, true, 0, 1, NFCT_CMP_STRICT) == 0);
-
-	assert(test_cmp_attr32(ATTR_ZONE, false, true, 0, 1, NFCT_CMP_MASK) == 1);
-	assert(test_cmp_attr32(ATTR_ZONE, true, true, 0, 1, NFCT_CMP_MASK) == 0);
-
-	assert(test_cmp_attr32(ATTR_ZONE, true, false, 0, 0, NFCT_CMP_MASK) == 1);
-
-	assert(test_cmp_attr32(ATTR_ZONE, true, false, 1, 0, NFCT_CMP_MASK) == 0);
+	unsigned int flags = 0;
+
+	/* 0000, 1000, 1100, 0010, 1010... */
+	/*		       attr       at1    at2    v1	v2 */
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	1,	flags) == 1);
+
+	flags = NFCT_CMP_STRICT;
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	1,	flags) == 1);
+
+	flags = NFCT_CMP_MASK;
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	1,	flags) == 1);
+
+	flags = NFCT_CMP_STRICT|NFCT_CMP_MASK;
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	1,	flags) == 1);
 }
 
 static void test_nfct_cmp_api(struct nf_conntrack *ct1, struct nf_conntrack *ct2)
-- 
1.9.1

