Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3D0C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjKVKcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjKVKc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:32:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A38D393
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:32:25 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/8] tests: shell: connlimit tests requires set expression support
Date:   Wed, 22 Nov 2023 11:32:14 +0100
Message-Id: <20231122103221.90160-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0062set_connlimit_0 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/testcases/sets/0062set_connlimit_0 b/tests/shell/testcases/sets/0062set_connlimit_0
index dab1da061795..48aa6fce5c31 100755
--- a/tests/shell/testcases/sets/0062set_connlimit_0
+++ b/tests/shell/testcases/sets/0062set_connlimit_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 set -e
 
 RULESET="table ip x {
-- 
2.30.2

