Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE704C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 11:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbiAKLfj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 06:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiAKLfi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 06:35:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6340FC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 03:35:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n7FR9-0005uE-U0; Tue, 11 Jan 2022 12:35:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: attempt to set_eval flag if dynamic updates requested
Date:   Tue, 11 Jan 2022 12:35:31 +0100
Message-Id: <20220111113531.4849-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When passing no upper size limit, the dynset expression forces
an internal 64k upperlimit.

In some cases, this can result in 'nft -f' to restore the ruleset.
Avoid this by always setting the EVAL flag on a set definition when
we encounter packet-path update attempt in the batch.

Reported-by: Yi Chen <yiche@redhat.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 10 ++++++
 .../testcases/sets/dumps/dynset_missing.nft   | 12 +++++++
 tests/shell/testcases/sets/dynset_missing     | 32 +++++++++++++++++++
 3 files changed, 54 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/dynset_missing.nft
 create mode 100755 tests/shell/testcases/sets/dynset_missing

diff --git a/src/evaluate.c b/src/evaluate.c
index 8edefbd1be21..437eacb8209f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3621,6 +3621,7 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct set *this_set;
 	struct stmt *this;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
@@ -3650,6 +3651,15 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 					  "statement must be stateful");
 	}
 
+	this_set = stmt->set.set->set;
+
+	/* Make sure EVAL flag is set on set definition so that kernel
+	 * picks a set that allows updates from the packet path.
+	 *
+	 * Alternatively we could error out in case 'flags dynamic' was
+	 * not given, but we can repair this here.
+	 */
+	this_set->flags |= NFT_SET_EVAL;
 	return 0;
 }
 
diff --git a/tests/shell/testcases/sets/dumps/dynset_missing.nft b/tests/shell/testcases/sets/dumps/dynset_missing.nft
new file mode 100644
index 000000000000..6c8ed323bdc9
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/dynset_missing.nft
@@ -0,0 +1,12 @@
+table ip test {
+	set dlist {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+		udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/sets/dynset_missing b/tests/shell/testcases/sets/dynset_missing
new file mode 100755
index 000000000000..fdf5f49edb9c
--- /dev/null
+++ b/tests/shell/testcases/sets/dynset_missing
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f /dev/stdin <<EOF
+table ip test {
+	chain output { type filter hook output priority 0;
+	}
+}
+EOF
+
+# misses 'flags dynamic'
+$NFT 'add set ip test dlist {type ipv4_addr; }'
+
+# picks rhash backend because 'size' was also missing.
+$NFT 'add rule ip test output udp dport 1234 update @dlist { ip daddr } counter'
+
+tmpfile=$(mktemp)
+
+trap "rm -rf $tmpfile" EXIT
+
+# kernel has forced an 64k upper size, i.e. this restore file
+# has 'size 65536' but no 'flags dynamic'.
+$NFT list ruleset > $tmpfile
+
+# this restore works, because set is still the rhash backend.
+$NFT -f $tmpfile # success
+$NFT flush ruleset
+
+# fails without commit 'attempt to set_eval flag if dynamic updates requested',
+# because set in $tmpfile has 'size x' but no 'flags dynamic'.
+$NFT -f $tmpfile
-- 
2.34.1

