Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419B4CCA47C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 19:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiFWTEK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiFWTD6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 15:03:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9112BC247
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 11:09:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] intervals: check for EXPR_F_REMOVE in case of element mismatch
Date:   Thu, 23 Jun 2022 20:09:51 +0200
Message-Id: <20220623180951.86277-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220623180951.86277-1-pablo@netfilter.org>
References: <20220623180951.86277-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If auto-merge is disable and element to be deleted finds no exact
matching, then bail out.

Fixes: 3e8d934e4f72 ("intervals: support to partial deletion with automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c                     |  4 ++++
 tests/shell/testcases/sets/errors_0 | 20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index c21b3ee0ad60..13009ca1b888 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -421,6 +421,10 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
+		} else if (i->flags & EXPR_F_REMOVE) {
+			expr_error(msgs, i, "element does not exist");
+			err = -1;
+			goto err;
 		}
 		prev = NULL;
 	}
diff --git a/tests/shell/testcases/sets/errors_0 b/tests/shell/testcases/sets/errors_0
index 2960b694c67c..a676ac7331c8 100755
--- a/tests/shell/testcases/sets/errors_0
+++ b/tests/shell/testcases/sets/errors_0
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-set -e
-
 RULESET="table ip x {
 	set y {
 		type ipv4_addr
@@ -11,4 +9,22 @@ RULESET="table ip x {
 
 delete element ip x y { 2.3.4.5 }"
 
+$NFT -f - <<< $RULESET
+if [ $? -eq 0 ]
+then
+	exit 1
+fi
+
+RULESET="table ip x {
+        set y {
+                type ipv4_addr
+                flags interval
+        }
+}
+
+add element x y { 1.1.1.1/24 }
+delete element x y { 1.1.1.1/24 }
+add element x y { 1.1.1.1/24 }
+delete element x y { 2.2.2.2/24 }"
+
 $NFT -f - <<< $RULESET || exit 0
-- 
2.30.2

