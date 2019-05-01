Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DB7C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C83AE20835
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEAQfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 12:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfEAQfN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 12:35:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 559F23082E57;
        Wed,  1 May 2019 16:35:13 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97AF060856;
        Wed,  1 May 2019 16:35:12 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] evaluate: force full cache update on rule index translation
Date:   Wed,  1 May 2019 12:35:10 -0400
Message-Id: <20190501163510.29723-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 01 May 2019 16:35:13 +0000 (UTC)
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
 src/evaluate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
-- 
2.20.1

