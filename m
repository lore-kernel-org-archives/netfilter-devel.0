Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CFFC47254
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 09:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48DDA20675
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 09:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEJl3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 05:41:29 -0400
Received: from smail.fem.tu-ilmenau.de ([141.24.220.41]:57524 "EHLO
        smail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgEEJl2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 05:41:28 -0400
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 1AD2720114;
        Tue,  5 May 2020 11:41:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 010496203;
        Tue,  5 May 2020 11:41:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s2BtseiP-992; Tue,  5 May 2020 11:41:20 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Tue,  5 May 2020 11:41:20 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 7C72D306A950; Tue,  5 May 2020 11:41:20 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [RFC] netlink: do not alter set element width
Date:   Tue,  5 May 2020 11:41:19 +0200
Message-Id: <20200505094119.26407-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Consider the following rulset

table bridge t {
        set nodhcpvlan {
                typeof vlan id
                elements = { 1 }
        }

        chain c1 {
                vlan id != @nodhcpvlan vlan type arp counter packets 0 bytes 0 jump c2
                vlan id != @nodhcpvlan vlan type ip counter packets 0 bytes 0 jump c2
        }

        chain c2 {
        }
}

This results for nft list ruleset in
  nft: netlink_delinearize.c:1945: binop_adjust_one: Assertion `value->len >= binop->right->len' failed.

This is due to binop_adjust_one setting value->len to left->len, which
is shorther than right->len.

Additionally, it does not seem correct to alter set elements from parsing a rule,
so remove that part all together.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 src/netlink_delinearize.c                | 18 ------------------
 tests/shell/testcases/sets/typeof_sets_1 | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 18 deletions(-)
 create mode 100755 tests/shell/testcases/sets/typeof_sets_1

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f721d15c..877c0d44 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1959,29 +1959,11 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 static void __binop_adjust(const struct expr *binop, struct expr *right,
 			   unsigned int shift)
 {
-	struct expr *i;
-
 	switch (right->etype) {
 	case EXPR_VALUE:
 		binop_adjust_one(binop, right, shift);
 		break;
 	case EXPR_SET_REF:
-		list_for_each_entry(i, &right->set->init->expressions, list) {
-			switch (i->key->etype) {
-			case EXPR_VALUE:
-				binop_adjust_one(binop, i->key, shift);
-				break;
-			case EXPR_RANGE:
-				binop_adjust_one(binop, i->key->left, shift);
-				binop_adjust_one(binop, i->key->right, shift);
-				break;
-			case EXPR_SET_ELEM:
-				__binop_adjust(binop, i->key->key, shift);
-				break;
-			default:
-				BUG("unknown expression type %s\n", expr_name(i->key));
-			}
-		}
 		break;
 	case EXPR_RANGE:
 		binop_adjust_one(binop, right->left, shift);
diff --git a/tests/shell/testcases/sets/typeof_sets_1 b/tests/shell/testcases/sets/typeof_sets_1
new file mode 100755
index 00000000..359ae109
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_1
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# regression test for corner case in netlink_delinearize
+
+EXPECTED="table bridge t {
+        set nodhcpvlan {
+                typeof vlan id
+                elements = { 1 }
+        }
+
+        chain c1 {
+                vlan id != @nodhcpvlan vlan type arp counter packets 0 bytes 0 jump c2
+                vlan id != @nodhcpvlan vlan type ip counter packets 0 bytes 0 jump c2
+        }
+
+        chain c2 {
+        }
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
-- 
2.20.1

