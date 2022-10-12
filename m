Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC18DC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 11:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiJLLCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 07:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLLCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 07:02:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D431527FFD
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 04:02:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: do not transfer binary operation to non-anonymous sets
Date:   Wed, 12 Oct 2022 13:02:12 +0200
Message-Id: <20221012110212.438125-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michael Braun says:

This results for nft list ruleset in
  nft: netlink_delinearize.c:1945: binop_adjust_one: Assertion `value->len >= binop->right->len' failed.

This is due to binop_adjust_one setting value->len to left->len, which
is shorther than right->len.

Additionally, it does not seem correct to alter set elements from parsing a
rule, so remove that part all together.

Reported-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
To address:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200505094119.26407-1-michael-dev@fami-braun.de/

 src/netlink_delinearize.c                     |  3 +++
 .../testcases/sets/dumps/typeof_sets_1.nft    | 15 +++++++++++++
 tests/shell/testcases/sets/typeof_sets_1      | 22 +++++++++++++++++++
 3 files changed, 40 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_1.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_1

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e8b9724cbac9..828ad12d7536 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2228,6 +2228,9 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 		binop_adjust_one(binop, right, shift);
 		break;
 	case EXPR_SET_REF:
+		if (!set_is_anonymous(right->set->flags))
+			break;
+
 		list_for_each_entry(i, &right->set->init->expressions, list) {
 			switch (i->key->etype) {
 			case EXPR_VALUE:
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_1.nft b/tests/shell/testcases/sets/dumps/typeof_sets_1.nft
new file mode 100644
index 000000000000..89cbc8358831
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_1.nft
@@ -0,0 +1,15 @@
+table bridge t {
+	set nodhcpvlan {
+		typeof vlan id
+		elements = { 1 }
+	}
+
+	chain c1 {
+		vlan id != @nodhcpvlan vlan type arp counter packets 0 bytes 0 jump c2
+		vlan id != @nodhcpvlan vlan type ip counter packets 0 bytes 0 jump c2
+		vlan id != { 1, 2 } vlan type ip6 counter packets 0 bytes 0 jump c2
+	}
+
+	chain c2 {
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_1 b/tests/shell/testcases/sets/typeof_sets_1
new file mode 100755
index 000000000000..e520270c09d8
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_1
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# regression test for corner case in netlink_delinearize
+
+EXPECTED="table bridge t {
+	set nodhcpvlan {
+		typeof vlan id
+		elements = { 1 }
+	}
+
+	chain c1 {
+		vlan id != @nodhcpvlan vlan type arp counter packets 0 bytes 0 jump c2
+		vlan id != @nodhcpvlan vlan type ip counter packets 0 bytes 0 jump c2
+		vlan id != { 1, 2 } vlan type ip6 counter packets 0 bytes 0 jump c2
+	}
+
+	chain c2 {
+	}
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
-- 
2.30.2

