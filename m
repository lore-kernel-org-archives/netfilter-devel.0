Return-Path: <SRS0=PEYv=TG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BEAC04A6B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 18:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCD220675
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 18:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEFSkn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 May 2019 14:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfEFSkn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 May 2019 14:40:43 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 091C55D61E;
        Mon,  6 May 2019 18:40:42 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-121-204.rdu2.redhat.com [10.10.121.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE6F460A98;
        Mon,  6 May 2019 18:40:40 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2] evaluate: force full cache update on rule index translation
Date:   Mon,  6 May 2019 14:40:38 -0400
Message-Id: <20190506184038.17675-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 06 May 2019 18:40:42 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If we've done a partial fetch of the cache and the genid is the same the
cache update will be skipped without fetching the rules. This causes the
index to handle lookup to fail. To remedy the situation we flush the
cache and force a full update.

Fixes: 816d8c7659c1 ("Support 'add/insert rule index <IDX>'")
Signed-off-by: Eric Garver <eric@garver.life>
---
# NFT=/usr/sbin/nft ./run-tests.sh ./testcases/cache/0003_cache_update_0 
I: using nft binary /usr/sbin/nft

W: [FAILED]	./testcases/cache/0003_cache_update_0: got 1
Error: Could not process rule: No such file or directory
add table ip t2; add chain ip t2 c
                              ^^
/dev/stdin:1:18-24: Error: Could not process rule: No such file or directory
add rule ip t4 c index 0 drop
                 ^^^^^^^

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
---
# ./run-tests.sh ./testcases/cache/0003_cache_update_0 
I: using nft binary ./../../src/nft

I: [OK]		./testcases/cache/0003_cache_update_0
Error: No such file or directory; did you mean table 't' in family ip?
add table ip t2; add chain ip t2 c
                              ^^

I: results: [OK] 1 [FAILED] 0 [TOTAL] 1
---
 src/evaluate.c                                  |  6 +++++-
 tests/shell/testcases/cache/0003_cache_update_0 | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3593eb80a6a6..a2585291e7c4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3182,7 +3182,11 @@ static int rule_translate_index(struct eval_ctx *ctx, struct rule *rule)
 	struct rule *r;
 	int ret;
 
-	/* update cache with CMD_LIST so that rules are fetched, too */
+	/* Update cache with CMD_LIST so that rules are fetched, too. The explicit
+	 * release is necessary because the genid may be the same, in which case
+	 * the update would be a no-op.
+	 */
+	cache_release(&ctx->nft->cache);
 	ret = cache_update(ctx->nft, CMD_LIST, ctx->msgs);
 	if (ret < 0)
 		return ret;
diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
index deb45db2c43b..fa9b5df380a4 100755
--- a/tests/shell/testcases/cache/0003_cache_update_0
+++ b/tests/shell/testcases/cache/0003_cache_update_0
@@ -27,3 +27,17 @@ EOF
 $NFT -i >/dev/null <<EOF
 add table ip t3; add chain ip t c
 EOF
+
+# The following test exposes a problem with incremental cache update when
+# reading commands from a file that add a rule using the "index" keyword.
+#
+# add rule ip t4 c meta l4proto icmp accept -> rule to reference in next step
+# add rule ip t4 c index 0 drop -> index 0 is not found due to rule cache not
+#                                  being updated
+$NFT -i >/dev/null <<EOF
+add table ip t4; add chain ip t4 c
+add rule ip t4 c meta l4proto icmp accept
+EOF
+$NFT -f - >/dev/null <<EOF
+add rule ip t4 c index 0 drop
+EOF
-- 
2.20.1

