Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B1BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 21:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F7661073
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 21:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhJYVxH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 17:53:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43560 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhJYVxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 17:53:03 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 38D6463F50
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Oct 2021 23:48:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] cache: honor table in set filtering
Date:   Mon, 25 Oct 2021 23:50:32 +0200
Message-Id: <20211025215032.1073625-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025215032.1073625-1-pablo@netfilter.org>
References: <20211025215032.1073625-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if table mismatch, in case the same set name is used in different
tables.

Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 691e8131c494..f62c9b96f528 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -377,7 +377,8 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 		return -1;
 
 	if (ctx->filter && ctx->filter->set &&
-	    (strcmp(ctx->filter->set, set->handle.set.name))) {
+	    (strcmp(ctx->filter->table, set->handle.table.name) ||
+	     strcmp(ctx->filter->set, set->handle.set.name))) {
 		set_free(set);
 		return 0;
 	}
-- 
2.30.2

