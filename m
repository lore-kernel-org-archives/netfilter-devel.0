Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803B8C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 10:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6061C2088F
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 10:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfKUKle (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:41:34 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40876 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKUKle (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 05:41:34 -0500
Received: from localhost ([::1]:53964 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXju0-0000hJ-2h; Thu, 21 Nov 2019 11:41:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] segtree: Fix add and delete of element in same batch
Date:   Thu, 21 Nov 2019 11:41:24 +0100
Message-Id: <20191121104124.23345-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The commit this fixes accidentally broke a rather exotic use-case which
is but used in set-simple.t of tests/monitor:

| # nft 'add element t s { 22-25 }; delete element t s { 22-25 }'

Since ranges are now checked for existence in userspace before delete
command is submitted to kernel, the second command above was rejected
because the range in question wasn't present in cache yet. Fix this by
adding new interval set elements to cache after creating the batch job
for them.

Fixes; decc12ec2dc31 ("segtree: Check ranges when deleting elements")

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 4abc13c993b89..c7b58529a80da 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1511,6 +1511,13 @@ static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
 	if (mnl_nft_setelem_add(ctx, set, expr, flags) < 0)
 		return -1;
 
+	if (set->flags & NFT_SET_INTERVAL) {
+		interval_map_decompose(expr);
+		list_splice_tail_init(&expr->expressions, &set->init->expressions);
+		set->init->size += expr->size;
+		expr->size = 0;
+	}
+
 	return 0;
 }
 
-- 
2.24.0

