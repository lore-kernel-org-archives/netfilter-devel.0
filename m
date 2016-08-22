From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] ct: display bit number instead of raw value
Date: Mon, 22 Aug 2016 12:17:27 +0200
Message-ID: <1471861047-7254-2-git-send-email-fw@strlen.de>
References: <1471861047-7254-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34892 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752485AbcHVKRY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 06:17:24 -0400
In-Reply-To: <1471861047-7254-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... and add test cases for ct label.
Currently this dumped 'label 0x2', now 'label 1' would be shown.

This makes add/list behave the same.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c                  |  2 +-
 tests/py/any/ct.t         |  4 ++++
 tests/py/any/ct.t.payload | 11 +++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index 018ca0b..a682938 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -113,7 +113,7 @@ static void ct_label_type_print(const struct expr *expr)
 		return;
 	}
 	/* can happen when connlabel.conf is altered after rules were added */
-	gmp_printf("0x%Zx", expr->value);
+	printf("%ld\n", (long)mpz_scan1(expr->value, 0));
 }
 
 static struct error_record *ct_label_type_parse(const struct expr *sym,
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 4d13213..7fd4f2c 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -92,3 +92,7 @@ ct saddr 1.2.3.4;fail
 ct original mark 42;fail
 # swapped key and direction
 ct mark original;fail
+
+ct label 127;ok
+ct label set 127;ok
+ct label 128;fail
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index e64ce2f..97f292e 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -332,3 +332,14 @@ ip test-ip4 output
   [ bitwise reg 1 = (reg=1 & 0x00000020 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
+# ct label 127
+ip test-ip4 output
+  [ ct load label => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000000 0x00000000 0x00000000 0x80000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
+
+# ct label set 127
+ip test-ip4 output
+  [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x80000000 ]
+  [ ct set label with reg 1 ]
+
-- 
2.7.3

