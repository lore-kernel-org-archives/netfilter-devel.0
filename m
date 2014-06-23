From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 2/2 libnetfilter_conntrack] conntrack: zero value handling
 of mark and zone
Date: Mon, 23 Jun 2014 19:18:10 +0900
Message-ID: <20140623101810.GC29052@gmail.com>
References: <20140617120405.GA24712@gmail.com>
 <20140619151611.GC13029@breakpoint.cc>
 <20140623101235.GA29052@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42382 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFWKSR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:18:17 -0400
Received: by mail-pb0-f49.google.com with SMTP id rr13so5642070pbb.8
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 03:18:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140623101235.GA29052@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables comparison of 0 value with mark and zone since both CTA_MARK
and CTA_ZONE are not set in case of its value is 0. This patch has just passed
qa test which Florian wrote, I guess there is more sophiscated way that settle
cmp_mark() and cmp_zone().

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 qa/test_api.c           | 20 ++++++++++----------
 src/conntrack/compare.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index 1335b23..c8faeda 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -287,15 +287,15 @@ static void test_nfct_cmp_attr(int attr)
 
 	flags = NFCT_CMP_STRICT;
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
-	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
-	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 0);
-	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
-	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
@@ -305,7 +305,7 @@ static void test_nfct_cmp_attr(int attr)
 
 	flags = NFCT_CMP_MASK;
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
-	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
@@ -313,7 +313,7 @@ static void test_nfct_cmp_attr(int attr)
 	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
-	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
@@ -323,15 +323,15 @@ static void test_nfct_cmp_attr(int attr)
 
 	flags = NFCT_CMP_STRICT|NFCT_CMP_MASK;
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	0,	flags) == 1);
-	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 0);
-	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 0);
+	assert(test_cmp_attr16(ATTR_ZONE, true,	 false,	0,	0,	flags) == 1);
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, true,	 true,	0,	0,	flags) == 1);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	0,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	1,	0,	flags) == 0);
-	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, false, true,	1,	0,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	1,	0,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	0,	1,	flags) == 1); /* verbose */
-	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 0); /* verbose */
+	assert(test_cmp_attr16(ATTR_ZONE, true,  false,	0,	1,	flags) == 1); /* verbose */
 	assert(test_cmp_attr16(ATTR_ZONE, false, true,	0,	1,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, true,  true,	0,	1,	flags) == 0);
 	assert(test_cmp_attr16(ATTR_ZONE, false, false,	1,	1,	flags) == 1); /* verbose */
diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index f4a194a..a3da81b 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -291,7 +291,25 @@ cmp_mark(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->mark == ct2->mark);
+	int a = test_bit(ATTR_MARK, ct1->head.set);
+	int b = test_bit(ATTR_MARK, ct2->head.set);
+	if (a & b) {
+		return (ct1->mark == ct2->mark);
+	} else if (!a && !b) {
+		return 1;
+	}
+
+	switch (flags & (NFCT_CMP_STRICT | NFCT_CMP_MASK)) {
+	case NFCT_CMP_MASK:
+		if (!a)
+			return 1;
+	case NFCT_CMP_STRICT | NFCT_CMP_MASK:
+	case NFCT_CMP_STRICT:
+		return nfct_get_attr_u32(ct1, ATTR_MARK)
+			== nfct_get_attr_u32(ct2, ATTR_MARK);
+	default:
+		return 1;
+	}
 }
 
 static int 
@@ -357,7 +375,25 @@ cmp_zone(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->zone == ct2->zone);
+	int a = test_bit(ATTR_ZONE, ct1->head.set);
+	int b = test_bit(ATTR_ZONE, ct2->head.set);
+	if (a & b) {
+		return (ct1->zone == ct2->zone);
+	} else if (!a && !b) {
+		return 1;
+	}
+
+	switch (flags & (NFCT_CMP_STRICT | NFCT_CMP_MASK)) {
+	case NFCT_CMP_MASK:
+		if (!a)
+			return 1;
+	case NFCT_CMP_STRICT | NFCT_CMP_MASK:
+	case NFCT_CMP_STRICT:
+		return nfct_get_attr_u16(ct1, ATTR_ZONE)
+			== nfct_get_attr_u16(ct2, ATTR_ZONE);
+	default:
+		return 1;
+	}
 }
 
 static int
@@ -421,7 +457,7 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 {
 	if (!__cmp(ATTR_ID, ct1, ct2, flags, cmp_id))
 		return 0;
-	if (!__cmp(ATTR_MARK, ct1, ct2, flags, cmp_mark))
+	if (!cmp_mark(ct1, ct2, flags))
 		return 0;
 	if (!__cmp(ATTR_TIMEOUT, ct1, ct2, flags, cmp_timeout))
 		return 0;
@@ -433,7 +469,7 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_DCCP_STATE, ct1, ct2, flags, cmp_dccp_state))
 		return 0;
-	if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
+	if (!cmp_zone(ct1, ct2, flags))
 		return 0;
 	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx))
 		return 0;
-- 
1.9.1

