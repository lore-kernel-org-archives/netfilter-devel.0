Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C422BEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjFSUnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjFSUnX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A93F9
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLiV-0003qt-JT; Mon, 19 Jun 2023 22:43:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/6] json: dccp: remove erroneous const qualifier
Date:   Mon, 19 Jun 2023 22:43:01 +0200
Message-Id: <20230619204306.11785-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230619204306.11785-1-fw@strlen.de>
References: <20230619204306.11785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This causes a clang warning:

parser_json.c:767:6: warning: variable 'opt_type' is uninitialized when used here [-Wuninitialized]
if (opt_type < DCCPOPT_TYPE_MIN || opt_type > DCCPOPT_TYPE_MAX) {
            ^~~~~~~~
... because it deduces the object is readonly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index f1cc39505382..c1e15ee186f5 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -759,7 +759,7 @@ static struct expr *json_parse_sctp_chunk_expr(struct json_ctx *ctx,
 static struct expr *json_parse_dccp_option_expr(struct json_ctx *ctx,
 						const char *type, json_t *root)
 {
-	const int opt_type;
+	int opt_type;
 
 	if (json_unpack_err(ctx, root, "{s:i}", "type", &opt_type))
 		return NULL;
-- 
2.39.3

