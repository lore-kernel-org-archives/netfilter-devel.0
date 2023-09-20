Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A1BC05024
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjITU5m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjITU5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:57:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A617C2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b2zNxHrH+z/TvVcaGNx2kzdny7YeiOmkhO2aySM/Kgo=; b=kLYc4RNcnrq1oUPSegHSdFYqF4
        lxleGf7iC3yyiL4qjA7KT8ro00tNB8pqp5gR25pbjGuRnZVfeHwJRl9X4cKvrdGZ5RTxH9qRsCzTC
        1cmmzVfOV8U1MKRtAI77ewGesP8uj6VUePUy9Y2biR4oFQYX0aAAJPQ1Pe4jKRlg5DJQASvUFpHIq
        QRNvxTAuzNQwaL4AzUMRRGAI1fz97KLRqORsj8ig09VOJ9KgeiWFF4TL0pZta1z8Jw1LlPXvATKOx
        MzWtWVPrFh+ymr32wp4Mcrx7ijYsn9OKtqCJuxwS6qGSPRdsIZeqJFeM2NNxSSmpEsdcDa15zP6cF
        2ly704Gg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qj4GJ-0007q5-QJ; Wed, 20 Sep 2023 22:57:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/9] parser_json: Catch wrong "reset" payload
Date:   Wed, 20 Sep 2023 22:57:19 +0200
Message-ID: <20230920205727.22103-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230920205727.22103-1-phil@nwl.cc>
References: <20230920205727.22103-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The statement happily accepted any valid expression as payload and
assumed it to be a tcpopt expression (actually, a special case of
exthdr). Add a check to make sure this is the case.

Standard syntax does not provide this flexibility, so no need to have
the check there as well.

Fixes: 5d837d270d5a8 ("src: add tcp option reset support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 4ea5b4326a900..242f05eece58c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2797,7 +2797,14 @@ static struct stmt *json_parse_optstrip_stmt(struct json_ctx *ctx,
 {
 	struct expr *expr = json_parse_expr(ctx, value);
 
-	return expr ? optstrip_stmt_alloc(int_loc, expr) : NULL;
+	if (!expr ||
+	    expr->etype != EXPR_EXTHDR ||
+	    expr->exthdr.op != NFT_EXTHDR_OP_TCPOPT) {
+		json_error(ctx, "Illegal TCP optstrip argument");
+		return NULL;
+	}
+
+	return optstrip_stmt_alloc(int_loc, expr);
 }
 
 static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
-- 
2.41.0

