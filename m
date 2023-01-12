Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D3DC63797
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbjALSFI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240273AbjALSDn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC37321B5
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WoRycyQQB2DfXF1CAX3NmL8k/neprOoQdF/VauuLx90=; b=PcFrlm14ugy7u178m5hhgqWGKf
        rvOMVs7jXL5S+/vGLUTc2oVYB9WS/R0cbh45jCpcBeUDuXkdRwjFnYDwfr1oUT+tpMSgrLABAz3jz
        oQunAVXHQaBB4C941Y2FSt+4kz5Lc7u8gYIU+QuoCUseHQp3nT1f6ym0GMNywxmFNC2uZPv334xyY
        4etGjpSoyS7i3ZYACeVqAklNrHlLSAwNcMFeJqvHagINev0MhzpOEx4Rf1NMT5V1fx+ywL0aro2CB
        5CfFtVyCVja2TDgdnN6vAPBYXC725I9YbnlD3bY1CbTIRESxWDh5M7ViwY7Lky4juRX1ZCNmiUEa9
        RXWxu8Lw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1NK-0000D0-V4; Thu, 12 Jan 2023 18:28:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/5] optimize: Clarify chain_optimize() array allocations
Date:   Thu, 12 Jan 2023 18:28:19 +0100
Message-Id: <20230112172823.7298-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arguments passed to sizeof() where deemed suspicious by covscan due to
the different type. Consistently specify size of an array 'a' using
'sizeof(*a) * nmemb'.

For the statement arrays in stmt_matrix, even use xzalloc_array() since
the item count is fixed and therefore can't be zero.

Fixes: fb298877ece27 ("src: add ruleset optimization infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/optimize.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 32aed866eb49f..12cae00da4ab4 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1113,10 +1113,11 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 		ctx->num_rules++;
 	}
 
-	ctx->rule = xzalloc(sizeof(ctx->rule) * ctx->num_rules);
-	ctx->stmt_matrix = xzalloc(sizeof(struct stmt *) * ctx->num_rules);
+	ctx->rule = xzalloc(sizeof(*ctx->rule) * ctx->num_rules);
+	ctx->stmt_matrix = xzalloc(sizeof(*ctx->stmt_matrix) * ctx->num_rules);
 	for (i = 0; i < ctx->num_rules; i++)
-		ctx->stmt_matrix[i] = xzalloc(sizeof(struct stmt *) * MAX_STMTS);
+		ctx->stmt_matrix[i] = xzalloc_array(MAX_STMTS,
+						    sizeof(**ctx->stmt_matrix));
 
 	merge = xzalloc(sizeof(*merge) * ctx->num_rules);
 
-- 
2.38.0

