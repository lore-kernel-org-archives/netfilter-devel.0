Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3220DC072A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 08:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjKVI7Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 03:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjKVI7Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 03:59:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 699129E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 00:59:18 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     martin.gignac@gmail.com
Subject: [PATCH nft] evaluate: bogus error when adding devices to flowtable
Date:   Wed, 22 Nov 2023 09:59:12 +0100
Message-Id: <20231122085912.3098-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if flowtable declaration is missing and no devices are
specified.

Otherwise, this reports a bogus error when adding new devices to an
existing flowtable.

 # nft -v
 nftables v1.0.9 (Old Doc Yak #3)
 # ip link add dummy1 type dummy
 # ip link set dummy1 up
 # nft 'create flowtable inet filter f1 { hook ingress priority 0; counter }'
 # nft 'add flowtable inet filter f1 { devices = { dummy1 } ; }'
 Error: missing hook and priority in flowtable declaration
 add flowtable inet filter f1 { devices = { dummy1 } ; }
                           ^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 5ad475fce5a1 ("evaluate: bail out if new flowtable does not specify hook and priority")
Reported-by: Martin Gignac <martin.gignac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 2 +-
 tests/shell/testcases/flowtable/0015destroy_0 | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 13b6a603de22..bcf83d804f32 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4867,7 +4867,7 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 		return table_not_found(ctx);
 
 	if (!ft_cache_find(table, ft->handle.flowtable.name)) {
-		if (!ft->hook.name)
+		if (!ft->hook.name && !ft->dev_expr)
 			return chain_error(ctx, ft, "missing hook and priority in flowtable declaration");
 
 		ft_cache_add(flowtable_get(ft), table);
diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
index d2a87da080fb..cea33524831f 100755
--- a/tests/shell/testcases/flowtable/0015destroy_0
+++ b/tests/shell/testcases/flowtable/0015destroy_0
@@ -2,6 +2,11 @@
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
+trap "ip link del dummy1" EXIT
+
+ip link add dummy1 type dummy
+ip link set dummy1 up
+
 $NFT add table t
 
 # pass for non-existent flowtable
@@ -9,4 +14,7 @@ $NFT destroy flowtable t f
 
 # successfully delete existing flowtable
 $NFT add flowtable t f '{ hook ingress priority 10; devices = { lo }; }'
+
+$NFT 'add flowtable t f { devices = { dummy1 } ; }'
+
 $NFT destroy flowtable t f
-- 
2.30.2

