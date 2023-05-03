Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E72C77B78
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 10:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjECKut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 06:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjECKuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 06:50:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF3235B0
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 03:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sGpRu5IK3hU14czK11nw/VKzikYY8q/UNFphgCXB1yA=; b=MHXs+D+zRKCQTgTYwvJTtG8qGi
        8uz0pTsXUvZ+3XdUCDE2GOGzcamC3ktE11g/n/8zwQr7QJU2TEvAL8nNJwIu1c0cMS9nWVDaZ2x2n
        vGvaM71cDebcLFpJcJQUeY4FCFZjWWeywFmXFqht0Dos6j4BGLEM7LU7PavIr9iYJyv7AxRB6E1JY
        MMTPwwtot2qvu1ef7v+CuJEFNg9iysMW+Cq2pEW/X7kUNyAIP1AEgc4TtvOsb+mSMwSGKx7iDfXEj
        +q5t+3X9KL4RYeDoj01MHEnOe1ym2Ei3F42ah9VhPaAgyQdT0qUFc4yrYinc4fZ1QOAjHq+oojRzG
        AfnLiUxw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1puA47-0007HH-6h; Wed, 03 May 2023 12:50:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] evaluate: Reject set stmt refs to sets without dynamic flag
Date:   Wed,  3 May 2023 12:50:22 +0200
Message-Id: <20230503105022.5728-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a revert of commit 8d443adfcc8c1 ("evaluate: attempt to set_eval
flag if dynamic updates requested"), implementing the alternative
mentioned in the comment it added.

Reason is the inconsistent behaviour when applying the same ruleset
twice: In the first call, the set lacking 'dynamic' flag does not exist
and is therefore added to the cache. Consequently, both the 'add set'
command and the set statement point at the same set object. In the
second call, a set with same name exists already, so the object created
for 'add set' command is not added to cache and consequently not updated
with the missing flag. The kernel thus rejects the NEWSET request as the
existing set differs from the new one.

Fixes: 8d443adfcc8c1 ("evaluate: attempt to set_eval flag if dynamic updates requested")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
*Note*: This is the best I could come up with. If you see a better way
to fix this (i.e., fix up cmd->set from stmt_evaluate_set()), please
speak up. :)
---
 src/evaluate.c                                | 13 ++------
 .../testcases/sets/dumps/dynset_missing.nft   | 12 -------
 tests/shell/testcases/sets/dynset_missing     | 32 -------------------
 3 files changed, 3 insertions(+), 54 deletions(-)
 delete mode 100644 tests/shell/testcases/sets/dumps/dynset_missing.nft
 delete mode 100755 tests/shell/testcases/sets/dynset_missing

diff --git a/src/evaluate.c b/src/evaluate.c
index fe15d7ace5dde..9fb768cbd4c9f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4139,7 +4139,6 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct set *this_set;
 	struct stmt *this;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
@@ -4148,6 +4147,9 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 	if (stmt->set.set->etype != EXPR_SET_REF)
 		return expr_error(ctx->msgs, stmt->set.set,
 				  "Expression does not refer to a set");
+	if (!(stmt->set.set->set->flags & NFT_SET_EVAL))
+		return expr_error(ctx->msgs, stmt->set.set,
+				  "Referenced set lacks \"dynamic\" flag");
 
 	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->set.set->set->key->dtype,
@@ -4169,15 +4171,6 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 					  "statement must be stateful");
 	}
 
-	this_set = stmt->set.set->set;
-
-	/* Make sure EVAL flag is set on set definition so that kernel
-	 * picks a set that allows updates from the packet path.
-	 *
-	 * Alternatively we could error out in case 'flags dynamic' was
-	 * not given, but we can repair this here.
-	 */
-	this_set->flags |= NFT_SET_EVAL;
 	return 0;
 }
 
diff --git a/tests/shell/testcases/sets/dumps/dynset_missing.nft b/tests/shell/testcases/sets/dumps/dynset_missing.nft
deleted file mode 100644
index 6c8ed323bdc94..0000000000000
--- a/tests/shell/testcases/sets/dumps/dynset_missing.nft
+++ /dev/null
@@ -1,12 +0,0 @@
-table ip test {
-	set dlist {
-		type ipv4_addr
-		size 65535
-		flags dynamic
-	}
-
-	chain output {
-		type filter hook output priority filter; policy accept;
-		udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
-	}
-}
diff --git a/tests/shell/testcases/sets/dynset_missing b/tests/shell/testcases/sets/dynset_missing
deleted file mode 100755
index fdf5f49edb9c6..0000000000000
--- a/tests/shell/testcases/sets/dynset_missing
+++ /dev/null
@@ -1,32 +0,0 @@
-#!/bin/bash
-
-set -e
-
-$NFT -f /dev/stdin <<EOF
-table ip test {
-	chain output { type filter hook output priority 0;
-	}
-}
-EOF
-
-# misses 'flags dynamic'
-$NFT 'add set ip test dlist {type ipv4_addr; }'
-
-# picks rhash backend because 'size' was also missing.
-$NFT 'add rule ip test output udp dport 1234 update @dlist { ip daddr } counter'
-
-tmpfile=$(mktemp)
-
-trap "rm -rf $tmpfile" EXIT
-
-# kernel has forced an 64k upper size, i.e. this restore file
-# has 'size 65536' but no 'flags dynamic'.
-$NFT list ruleset > $tmpfile
-
-# this restore works, because set is still the rhash backend.
-$NFT -f $tmpfile # success
-$NFT flush ruleset
-
-# fails without commit 'attempt to set_eval flag if dynamic updates requested',
-# because set in $tmpfile has 'size x' but no 'flags dynamic'.
-$NFT -f $tmpfile
-- 
2.40.0

