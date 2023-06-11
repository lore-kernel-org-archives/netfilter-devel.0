Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C757C77B7A
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Jun 2023 21:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjFKVhK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Jun 2023 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjFKVhJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Jun 2023 17:37:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C651AA9
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jun 2023 14:37:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: fix spurious errors in terse listing in json
Date:   Sun, 11 Jun 2023 23:37:04 +0200
Message-Id: <20230611213704.983-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sometimes table handle becomes 192, which makes this test fail. Check
for 192.168 instead to make sure terse listing works fine instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/listing/0021ruleset_json_terse_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/listing/0021ruleset_json_terse_0 b/tests/shell/testcases/listing/0021ruleset_json_terse_0
index c739ac3f29d0..6be41b8635ae 100755
--- a/tests/shell/testcases/listing/0021ruleset_json_terse_0
+++ b/tests/shell/testcases/listing/0021ruleset_json_terse_0
@@ -6,7 +6,7 @@ $NFT add chain ip test c
 $NFT add set ip test s { type ipv4_addr\; }
 $NFT add element ip test s { 192.168.3.4, 192.168.3.5 }
 
-if $NFT -j -t list ruleset | grep '192'
+if $NFT -j -t list ruleset | grep '192\.168'
 then
 	exit 1
 fi
-- 
2.30.2

