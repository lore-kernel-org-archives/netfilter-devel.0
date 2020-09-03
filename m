Return-Path: <SRS0=Qpa8=CM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83ECC433E2
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7AA2065F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 12:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgICMZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Sep 2020 08:25:36 -0400
Received: from correo.us.es ([193.147.175.20]:41264 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgICMYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 08:24:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4EB37EB46A
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 14:17:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36FEDDA793
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 14:17:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22A62DA730; Thu,  3 Sep 2020 14:17:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFFE9DA730
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 14:17:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Sep 2020 14:17:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CC3FE42EF4E5
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 14:17:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3] mergesort: find base value expression type via recursion
Date:   Thu,  3 Sep 2020 14:17:31 +0200
Message-Id: <20200903121731.11234-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sets that store flags might contain a mixture of values and binary
operations. Find the base value type via recursion to compare the
expressions.

Fixes: 14ee0a979b62 ("src: sort set elements in netlink_get_setelems()")
Fixes: 3926a3369bb5 ("mergesort: unbreak listing with binops")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: simplify concatenation, take first component of the tuple as key for sorting

 src/mergesort.c                               | 49 ++++++++-----------
 tests/shell/testcases/sets/0055tcpflags_0     | 27 ++++++++++
 .../testcases/sets/dumps/0055tcpflags_0.nft   | 10 ++++
 3 files changed, 57 insertions(+), 29 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0055tcpflags_0
 create mode 100644 tests/shell/testcases/sets/dumps/0055tcpflags_0.nft

diff --git a/src/mergesort.c b/src/mergesort.c
index 02094b486aeb..f938a11d7c40 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -13,43 +13,34 @@
 
 static int expr_msort_cmp(const struct expr *e1, const struct expr *e2);
 
-static int concat_expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+static const struct expr *expr_msort_value(const struct expr *expr)
 {
-	struct list_head *l = (&e2->expressions)->next;
-	const struct expr *i1, *i2;
-	int ret;
-
-	list_for_each_entry(i1, &e1->expressions, list) {
-		i2 = list_entry(l, typeof(struct expr), list);
-
-		ret = expr_msort_cmp(i1, i2);
-		if (ret)
-			return ret;
-
-		l = l->next;
-	}
-
-	return false;
-}
-
-static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
-{
-	switch (e1->etype) {
+	switch (expr->etype) {
 	case EXPR_SET_ELEM:
-		return expr_msort_cmp(e1->key, e2->key);
+		return expr_msort_value(expr->key);
+	case EXPR_BINOP:
+	case EXPR_MAPPING:
+		return expr_msort_value(expr->left);
 	case EXPR_VALUE:
-		return mpz_cmp(e1->value, e2->value);
+		return expr;
 	case EXPR_CONCAT:
-		return concat_expr_msort_cmp(e1, e2);
-	case EXPR_MAPPING:
-		return expr_msort_cmp(e1->left, e2->left);
-	case EXPR_BINOP:
-		return expr_msort_cmp(e1->left, e2->left);
+		expr = list_first_entry(&expr->expressions, struct expr, list);
+		return expr_msort_value(expr);
 	default:
-		BUG("Unknown expression %s\n", expr_name(e1));
+		BUG("Unknown expression %s\n", expr_name(expr));
 	}
 }
 
+static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+{
+	e1 = expr_msort_value(e1);
+	e2 = expr_msort_value(e2);
+
+	assert(e1->etype == e2->etype && e1->etype == EXPR_VALUE);
+
+	return mpz_cmp(e1->value, e2->value);
+}
+
 static void list_splice_sorted(struct list_head *list, struct list_head *head)
 {
 	struct list_head *h = head->next;
diff --git a/tests/shell/testcases/sets/0055tcpflags_0 b/tests/shell/testcases/sets/0055tcpflags_0
new file mode 100755
index 000000000000..a2b24eb2981b
--- /dev/null
+++ b/tests/shell/testcases/sets/0055tcpflags_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+EXPECTED="add table ip test
+
+add set ip test tcp_good_flags { type tcp_flag ; flags constant ; elements = {
+  ( 0 | 0 | 0 |ack| 0 | 0 ),  \
+  ( 0 | 0 | 0 |ack| 0 |urg),  \
+  ( 0 | 0 | 0 |ack|psh| 0 ),  \
+  ( 0 | 0 | 0 |ack|psh|urg),  \
+  ( 0 | 0 |rst| 0 | 0 | 0 ),  \
+  ( 0 | 0 |rst|ack| 0 | 0 ),  \
+  ( 0 | 0 |rst|ack| 0 |urg),  \
+  ( 0 | 0 |rst|ack|psh| 0 ),  \
+  ( 0 | 0 |rst|ack|psh|urg),  \
+  ( 0 |syn| 0 | 0 | 0 | 0 ),  \
+  ( 0 |syn| 0 |ack| 0 | 0 ),  \
+  ( 0 |syn| 0 |ack| 0 |urg),  \
+  ( 0 |syn| 0 |ack|psh| 0 ),  \
+  ( 0 |syn| 0 |ack|psh|urg),  \
+  (fin| 0 | 0 |ack| 0 | 0 ),  \
+  (fin| 0 | 0 |ack| 0 |urg),  \
+  (fin| 0 | 0 |ack|psh| 0 ),  \
+  (fin| 0 | 0 |ack|psh|urg)   \
+} ; }"
+
+set -e
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft
new file mode 100644
index 000000000000..ffed5426577e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft
@@ -0,0 +1,10 @@
+table ip test {
+	set tcp_good_flags {
+		type tcp_flag
+		flags constant
+		elements = { fin | psh | ack | urg, fin | psh | ack, fin | ack | urg, fin | ack, syn | psh | ack | urg,
+			     syn | psh | ack, syn | ack | urg, syn | ack, syn, rst | psh | ack | urg,
+			     rst | psh | ack, rst | ack | urg, rst | ack, rst, psh | ack | urg,
+			     psh | ack, ack | urg, ack }
+	}
+}
-- 
2.20.1

