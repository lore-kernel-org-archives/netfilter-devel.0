From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct 2/2] qa: add tests for new bitmask functions
Date: Wed, 10 Sep 2014 17:53:31 +0900
Message-ID: <20140910085331.GC23549@gmail.com>
References: <20140910084525.GA23549@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56000 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaIJIxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:53:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so4224945pab.33
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2014 01:53:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140910084525.GA23549@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

for nfct_bitmask_clear() and nfct_bitmask_equal()

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 qa/test_api.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/qa/test_api.c b/qa/test_api.c
index f17db31..fe1cb78 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -80,6 +80,43 @@ static void test_nfct_bitmask(void)
 		assert(!nfct_bitmask_test_bit(b, i));
 	}
 
+	/* nfct_bitmask_clear() */
+	for (i = 0; i < maxb; i++) {
+		nfct_bitmask_set_bit(b, i);
+		assert(nfct_bitmask_test_bit(b, i));
+		nfct_bitmask_clear(b);
+		assert(!nfct_bitmask_test_bit(b, i));
+	}
+
+	for (i = 0; i < maxb; i++)
+		nfct_bitmask_set_bit(b, i);
+	nfct_bitmask_clear(b);
+	for (i = 0; i < maxb; i++)
+		assert(!nfct_bitmask_test_bit(b, i));
+
+	/* nfct_bitmask_equal() */
+	for (i = 0; i < maxb / 32 * 32; i += 32) {
+		a = nfct_bitmask_new(i);
+		assert(!nfct_bitmask_equal(a, b));
+		nfct_bitmask_destroy(a);
+	}
+
+	a = nfct_bitmask_clone(b);
+	assert(nfct_bitmask_equal(a, b));
+	for (i = 0; i < maxb; i++) {
+		if (nfct_bitmask_test_bit(a, i)) {
+			nfct_bitmask_unset_bit(a, i);
+			assert(!nfct_bitmask_equal(a, b));
+			nfct_bitmask_set_bit(a, i);
+		} else {
+			nfct_bitmask_set_bit(a, i);
+			assert(!nfct_bitmask_equal(a, b));
+			nfct_bitmask_unset_bit(a, i);
+		}
+		assert(nfct_bitmask_equal(a, b));
+	}
+
+	nfct_bitmask_destroy(a);
 	nfct_bitmask_destroy(b);
 
 	ct1 = nfct_new();
-- 
2.1.0
