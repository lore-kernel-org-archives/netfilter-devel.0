From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] conntrack, expect: fix _cmp api with STRICT checking
Date: Sat,  1 Jun 2013 14:59:30 +0200
Message-ID: <1370091571-23140-2-git-send-email-fw@strlen.de>
References: <1370091571-23140-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55760 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab3FANAv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Jun 2013 09:00:51 -0400
In-Reply-To: <1370091571-23140-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Normal comparision succeeds when the _common_ attribute subset
have same values.

When STRICT matching is specified, the comparision should succeed only when
both objects have same attribute subset and attribute values match.

However, STRICT comparision often fails as an attribute missing in both
objects is erronously considered an error.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack/compare.c | 6 +++++-
 src/expect/compare.c    | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index e282a24..97c25cb 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -17,8 +17,12 @@ static int __cmp(int attr,
 		 	    const struct nf_conntrack *ct2,
 			    unsigned int flags))
 {
-	if (test_bit(attr, ct1->head.set) && test_bit(attr, ct2->head.set)) {
+	int a = test_bit(attr, ct1->head.set);
+	int b = test_bit(attr, ct2->head.set);
+	if (a && b) {
 		return cmp(ct1, ct2, flags);
+	} else if (!a && !b) {
+		return 1;
 	} else if (flags & NFCT_CMP_MASK &&
 		   test_bit(attr, ct1->head.set)) {
 		return 0;
diff --git a/src/expect/compare.c b/src/expect/compare.c
index a524f4c..484d7b1 100644
--- a/src/expect/compare.c
+++ b/src/expect/compare.c
@@ -18,8 +18,13 @@ static int exp_cmp(int attr,
 			      const struct nf_expect *exp2,
 			      unsigned int flags))
 {
-	if (test_bit(attr, exp1->set) && test_bit(attr, exp2->set)) {
+	int a = test_bit(attr, exp1->set);
+	int b = test_bit(attr, exp2->set);
+
+	if (a && b) {
 		return cmp(exp1, exp2, flags);
+	} else if (!a && !b) {
+		return 1;
 	} else if (flags & NFCT_CMP_MASK &&
 		   test_bit(attr, exp1->set)) {
 		return 0;
-- 
1.8.1.5

