Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DAEC77B75
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 12:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDUMxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 08:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDUMxF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 08:53:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65DCA10276
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 05:52:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: bail out if new flowtable does not specify hook and priority
Date:   Fri, 21 Apr 2023 14:52:38 +0200
Message-Id: <20230421125238.404348-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user forgets to specify the hook and priority and the flowtable does
not exist, then bail out:

 # cat flowtable-incomplete.nft
 table t {
  flowtable f {
   devices = { lo }
  }
 }
 # nft -f /tmp/k
 flowtable-incomplete.nft:2:12-12: Error: missing hook and priority in flowtable declaration
 flowtable f {
           ^

Update one existing tests/shell to specify a hook and priority.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                 | 6 +++++-
 tests/shell/testcases/owner/0001-flowtable-uaf | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 35910b03ba7c..a1c3895cfb02 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4732,8 +4732,12 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	if (!ft_cache_find(table, ft->handle.flowtable.name))
+	if (!ft_cache_find(table, ft->handle.flowtable.name)) {
+		if (!ft->hook.name)
+			return chain_error(ctx, ft, "missing hook and priority in flowtable declaration");
+
 		ft_cache_add(flowtable_get(ft), table);
+	}
 
 	if (ft->hook.name) {
 		ft->hook.num = str2hooknum(NFPROTO_NETDEV, ft->hook.name);
diff --git a/tests/shell/testcases/owner/0001-flowtable-uaf b/tests/shell/testcases/owner/0001-flowtable-uaf
index 4efbe75c390f..8b7a551cc69e 100755
--- a/tests/shell/testcases/owner/0001-flowtable-uaf
+++ b/tests/shell/testcases/owner/0001-flowtable-uaf
@@ -6,6 +6,7 @@ $NFT -f - <<EOF
 table t {
  flags owner
  flowtable f {
+  hook ingress priority 0
   devices = { lo }
  }
 }
@@ -16,6 +17,7 @@ $NFT -f - <<EOF
 table t {
  flags owner
  flowtable f {
+  hook ingress priority 0
   devices = { lo }
  }
 }
-- 
2.30.2

