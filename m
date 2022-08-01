Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A62C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 14:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiHAORx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiHAORx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 10:17:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 792AE22BF6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 07:17:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_json: fix device parsing in netdev family
Date:   Mon,  1 Aug 2022 16:17:47 +0200
Message-Id: <20220801141747.107519-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

json_unpack() function is not designed to take a pre-allocated buffer.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1612
Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index fb401009a499..e136cb2b43b0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2781,7 +2781,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		.table.location = *int_loc,
 	};
 	const char *family = "", *policy = "", *type, *hookstr;
-	const char name[IFNAMSIZ];
+	const char *name = "";
 	struct chain *chain;
 	int prio;
 
-- 
2.30.2

