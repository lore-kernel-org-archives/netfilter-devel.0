Return-Path: <SRS0=Qpa8=CM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5958AC43461
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 14:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4F820716
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 14:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgICOtr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:49:47 -0400
Received: from correo.us.es ([193.147.175.20]:41638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbgICOtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 10:49:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 776B7DA72D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 16:49:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67BA3DA704
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 16:49:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67294DA8F3; Thu,  3 Sep 2020 16:49:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B891DA704
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 16:49:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Sep 2020 16:49:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id ED79F42EF4E2
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2020 16:49:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4] mergesort: find base value expression type via recursion
Date:   Thu,  3 Sep 2020 16:49:37 +0200
Message-Id: <20200903144937.22500-1-pablo@netfilter.org>
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
v4: Make sure concatenations are listed in a deterministic way via
    concat_expr_msort_value.
    Adjust a few tests after this update since listing differs.

 src/mergesort.c                               | 61 ++++++++++++-------
 .../nft-f/dumps/0012different_defines_0.nft   |  2 +-
 tests/shell/testcases/sets/0055tcpflags_0     | 27 ++++++++
 .../dumps/0037_set_with_inet_service_0.nft    |  8 +--
 .../testcases/sets/dumps/0055tcpflags_0.nft   | 10 +++
 5 files changed, 81 insertions(+), 27 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0055tcpflags_0
 create mode 100644 tests/shell/testcases/sets/dumps/0055tcpflags_0.nft

diff --git a/src/mergesort.c b/src/mergesort.c
index 02094b486aeb..61128f977f04 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -12,44 +12,61 @@
 #include <list.h>
 
 static int expr_msort_cmp(const struct expr *e1, const struct expr *e2);
+static void expr_msort_value(const struct expr *expr, mpz_t value);
 
-static int concat_expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 {
-	struct list_head *l = (&e2->expressions)->next;
-	const struct expr *i1, *i2;
-	int ret;
-
-	list_for_each_entry(i1, &e1->expressions, list) {
-		i2 = list_entry(l, typeof(struct expr), list);
+	const struct expr *i;
+	unsigned int len = 0;
+	char data[512];
 
-		ret = expr_msort_cmp(i1, i2);
-		if (ret)
-			return ret;
+	mpz_init(value);
 
-		l = l->next;
+	list_for_each_entry(i, &expr->expressions, list) {
+		mpz_export_data(data + len, i->value, i->byteorder, i->len);
+		len += i->len;
 	}
 
-	return false;
+	mpz_import_data(value, data, BYTEORDER_HOST_ENDIAN, len);
 }
 
-static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+static void expr_msort_value(const struct expr *expr, mpz_t value)
 {
-	switch (e1->etype) {
+	switch (expr->etype) {
 	case EXPR_SET_ELEM:
-		return expr_msort_cmp(e1->key, e2->key);
+		expr_msort_value(expr->key, value);
+		break;
+	case EXPR_BINOP:
+	case EXPR_MAPPING:
+		expr_msort_value(expr->left, value);
+		break;
 	case EXPR_VALUE:
-		return mpz_cmp(e1->value, e2->value);
+		mpz_set(value, expr->value);
+		break;
 	case EXPR_CONCAT:
-		return concat_expr_msort_cmp(e1, e2);
-	case EXPR_MAPPING:
-		return expr_msort_cmp(e1->left, e2->left);
-	case EXPR_BINOP:
-		return expr_msort_cmp(e1->left, e2->left);
+		concat_expr_msort_value(expr, value);
+		break;
 	default:
-		BUG("Unknown expression %s\n", expr_name(e1));
+		BUG("Unknown expression %s\n", expr_name(expr));
 	}
 }
 
+static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+{
+	mpz_t value1, value2;
+	int ret;
+
+	mpz_init(value1);
+	mpz_init(value2);
+	expr_msort_value(e1, value1);
+	expr_msort_value(e2, value2);
+	ret = mpz_cmp(value1, value2);
+	mpz_clear(value1);
+	mpz_clear(value2);
+
+	return ret;
+}
+
 static void list_splice_sorted(struct list_head *list, struct list_head *head)
 {
 	struct list_head *h = head->next;
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
index 7abced868601..28094387ebed 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
@@ -8,7 +8,7 @@ table inet t {
 		ip6 daddr fe0::1 ip6 saddr fe0::2
 		ip saddr vmap { 10.0.0.0 : drop, 10.0.0.2 : accept }
 		ip6 daddr vmap { fe0::1 : drop, fe0::2 : accept }
-		ip6 saddr . ip6 nexthdr { fe0::1 . udp, fe0::2 . tcp }
+		ip6 saddr . ip6 nexthdr { fe0::2 . tcp, fe0::1 . udp }
 		ip daddr . iif vmap { 10.0.0.0 . "lo" : accept }
 		tcp dport 100-222
 		udp dport vmap { 100-222 : accept }
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
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
index 0e85f7c20eba..68b1f7bec4d8 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
@@ -1,11 +1,11 @@
 table inet filter {
 	set myset {
 		type ipv4_addr . inet_proto . inet_service
-		elements = { 192.168.0.12 . tcp . 53,
-			     192.168.0.12 . tcp . 80,
+		elements = { 192.168.0.113 . tcp . 22,
+			     192.168.0.12 . tcp . 53,
 			     192.168.0.12 . udp . 53,
-			     192.168.0.13 . tcp . 80,
-			     192.168.0.113 . tcp . 22 }
+			     192.168.0.12 . tcp . 80,
+			     192.168.0.13 . tcp . 80 }
 	}
 
 	chain forward {
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

