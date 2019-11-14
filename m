Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE003C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 14:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9244020706
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 14:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKNOV1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:21:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52822 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfKNOV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 09:21:27 -0500
Received: from localhost ([::1]:37680 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVFzx-0004KW-LN; Thu, 14 Nov 2019 15:21:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] segtree: Fix get element for little endian ranges
Date:   Thu, 14 Nov 2019 15:21:22 +0100
Message-Id: <20191114142122.13931-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fixes get element command for interval sets with host byte order
data type, like e.g. mark. During serializing of the range (or element)
to query, data was exported in wrong byteorder and consequently not
found in kernel.

The mystery part is that code seemed correct: When calling
constant_expr_alloc() from set_elem_add(), the set key's byteorder was
passed with correct value of BYTEORDER_HOST_ENDIAN.

Comparison with delete/add element code paths though turned out that in
those use-cases, constant_expr_alloc() is called with BYTEORDER_INVALID:

- seg_tree_init() takes byteorder field value of first element in
  init->expressions (i.e., the elements requested on command line) and
  assigns that to tree->byteorder
- tree->byteorder is passed to constant_expr_alloc() in
  set_insert_interval()
- the elements' byteorder happens to be the default value

This patch may not fix the right side, but at least it aligns get with
add/delete element codes.

Fixes: a43cc8d53096d ("src: support for get element command")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c                                 | 12 +++---
 .../sets/0040get_host_endian_elements_0       | 43 +++++++++++++++++++
 2 files changed, 50 insertions(+), 5 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0040get_host_endian_elements_0

diff --git a/src/segtree.c b/src/segtree.c
index 10c82eed5378f..9f1eecc0ae7e1 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -622,12 +622,12 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 }
 
 static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
-			 uint32_t flags)
+			 uint32_t flags, enum byteorder byteorder)
 {
 	struct expr *expr;
 
 	expr = constant_expr_alloc(&internal_location, set->key->dtype,
-				   set->key->byteorder, set->key->len, NULL);
+				   byteorder, set->key->len, NULL);
 	mpz_set(expr->value, value);
 	expr = set_elem_expr_alloc(&internal_location, expr);
 	expr->flags = flags;
@@ -649,14 +649,16 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	list_for_each_entry(i, &init->expressions, list) {
 		switch (i->key->etype) {
 		case EXPR_VALUE:
-			set_elem_add(set, new_init, i->key->value, i->flags);
+			set_elem_add(set, new_init, i->key->value,
+				     i->flags, i->byteorder);
 			break;
 		default:
 			range_expr_value_low(low, i);
-			set_elem_add(set, new_init, low, 0);
+			set_elem_add(set, new_init, low, 0, i->byteorder);
 			range_expr_value_high(high, i);
 			mpz_add_ui(high, high, 1);
-			set_elem_add(set, new_init, high, EXPR_F_INTERVAL_END);
+			set_elem_add(set, new_init, high,
+				     EXPR_F_INTERVAL_END, i->byteorder);
 			break;
 		}
 	}
diff --git a/tests/shell/testcases/sets/0040get_host_endian_elements_0 b/tests/shell/testcases/sets/0040get_host_endian_elements_0
new file mode 100755
index 0000000000000..caf6a4af326a2
--- /dev/null
+++ b/tests/shell/testcases/sets/0040get_host_endian_elements_0
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+RULESET="table ip t {
+	set s {
+		type mark
+		flags interval
+		elements = {
+			0x23-0x42, 0x1337
+		}
+	}
+}"
+
+$NFT -f - <<< "$RULESET" || { echo "can't apply basic ruleset"; exit 1; }
+
+$NFT get element ip t s '{ 0x23-0x42 }' || {
+	echo "can't find existing range 0x23-0x42"
+	exit 1
+}
+
+$NFT get element ip t s '{ 0x26-0x28 }' || {
+	echo "can't find existing sub-range 0x26-0x28"
+	exit 1
+}
+
+$NFT get element ip t s '{ 0x26-0x99 }' && {
+	echo "found non-existing range 0x26-0x99"
+	exit 1
+}
+
+$NFT get element ip t s '{ 0x55-0x99 }' && {
+	echo "found non-existing range 0x55-0x99"
+	exit 1
+}
+
+$NFT get element ip t s '{ 0x55 }' && {
+	echo "found non-existing element 0x55"
+	exit 1
+}
+
+$NFT get element ip t s '{ 0x1337 }' || {
+	echo "can't find existing element 0x1337"
+	exit 1
+}
-- 
2.24.0

