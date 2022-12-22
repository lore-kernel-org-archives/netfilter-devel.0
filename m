Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D93C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 12:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiLVMNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 07:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbiLVMMv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 07:12:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43EC82EFA6
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 04:06:29 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 1/2,v2] evaluate: fix shift exponent underflow in concatenation evaluation
Date:   Thu, 22 Dec 2022 13:06:22 +0100
Message-Id: <20221222120623.115538-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is an underflow of the index that iterates over the concatenation:

../include/datatype.h:292:15: runtime error: shift exponent 4294967290 is too large for 32-bit type 'unsigned int'

set the datatype to invalid which is fine to evaluate a concatenation
in a set/map statement.

Update b8e1940aa190 ("tests: add a test case for map update from packet
path with concat") so it does not need a workaround to work.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: complete commit description (incomplete / broken sentence in previous patch)

 src/evaluate.c                                                | 2 +-
 .../testcases/maps/dumps/typeof_maps_concat_update_0.nft      | 2 +-
 tests/shell/testcases/maps/typeof_maps_concat_update_0        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c04cb91d3919..70adb847d475 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1357,7 +1357,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			dsize = key->len;
 			bo = key->byteorder;
 			off--;
-		} else if (dtype == NULL) {
+		} else if (dtype == NULL || off == 0) {
 			tmp = datatype_lookup(TYPE_INVALID);
 		} else {
 			tmp = concat_subtype_lookup(type, --off);
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
index d91b795fa000..a2c3c139936b 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
@@ -1,6 +1,6 @@
 table ip foo {
 	map pinned {
-		typeof ip daddr . tcp dport : ip daddr . tcp dport
+		typeof ip saddr . ct original proto-dst : ip daddr . tcp dport
 		size 65535
 		flags dynamic,timeout
 		timeout 6m
diff --git a/tests/shell/testcases/maps/typeof_maps_concat_update_0 b/tests/shell/testcases/maps/typeof_maps_concat_update_0
index 645ae142a5af..e996f14e1830 100755
--- a/tests/shell/testcases/maps/typeof_maps_concat_update_0
+++ b/tests/shell/testcases/maps/typeof_maps_concat_update_0
@@ -4,13 +4,13 @@
 
 EXPECTED="table ip foo {
  map pinned {
-	typeof ip daddr . tcp dport : ip daddr . tcp dport
+	typeof ip saddr . ct original proto-dst : ip daddr . tcp dport
 	size 65535
 	flags dynamic,timeout
         timeout 6m
   }
   chain pr {
-     meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
+     update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
   }
 }"
 
-- 
2.30.2

