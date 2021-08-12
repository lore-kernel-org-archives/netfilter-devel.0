Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA7FC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B646101E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 14:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhHLOvX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:51:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47670 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbhHLOvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 10:51:22 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 234706006E
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 16:50:12 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: expand variable containing set into multiple mappings
Date:   Thu, 12 Aug 2021 16:50:48 +0200
Message-Id: <20210812145048.12372-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # cat x.nft
 define interfaces = { eth0, eth1 }

 table ip x {
        chain y {
		type filter hook input priority 0; policy accept;
                iifname vmap { lo : accept, $interfaces : drop }
        }
 }
 # nft -f x.nft
 # nft list ruleset
 table ip x {
        chain y {
		type filter hook input priority 0; policy accept;
                iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
supersedes: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210811103344.23073-1-pablo@netfilter.org/

 src/evaluate.c                                 | 17 +++++++++++++++++
 tests/shell/testcases/maps/0012map_0           | 17 +++++++++++++++++
 tests/shell/testcases/maps/dumps/0012map_0.nft | 12 ++++++++++++
 3 files changed, 46 insertions(+)
 create mode 100755 tests/shell/testcases/maps/0012map_0
 create mode 100644 tests/shell/testcases/maps/dumps/0012map_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 8b5f51cee01c..8ebc75617b1c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1431,6 +1431,23 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
+		if (i->etype == EXPR_MAPPING &&
+		    i->left->etype == EXPR_SET_ELEM &&
+		    i->left->key->etype == EXPR_SET) {
+			struct expr *new, *j;
+
+			list_for_each_entry(j, &i->left->key->expressions, list) {
+				new = mapping_expr_alloc(&i->location,
+							 expr_get(j),
+							 expr_clone(i->right));
+				list_add_tail(&new->list, &set->expressions);
+				set->size++;
+			}
+			list_del(&i->list);
+			expr_free(i);
+			continue;
+		}
+
 		elem = expr_set_elem(i);
 
 		if (elem->etype == EXPR_SET_ELEM &&
diff --git a/tests/shell/testcases/maps/0012map_0 b/tests/shell/testcases/maps/0012map_0
new file mode 100755
index 000000000000..dd93c482f441
--- /dev/null
+++ b/tests/shell/testcases/maps/0012map_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="define interfaces = { eth0, eth1 }
+
+table ip x {
+	map z {
+		type ifname : verdict
+		elements = { \$interfaces : drop, lo : accept }
+	}
+	chain y {
+		iifname vmap { lo : accept, \$interfaces : drop }
+	}
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
new file mode 100644
index 000000000000..e734fc1c70b9
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
@@ -0,0 +1,12 @@
+table ip x {
+	map z {
+		type ifname : verdict
+		elements = { "lo" : accept,
+			     "eth0" : drop,
+			     "eth1" : drop }
+	}
+
+	chain y {
+		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
+	}
+}
-- 
2.20.1

