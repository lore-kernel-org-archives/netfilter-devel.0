Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A33CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 14:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6702A20640
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 14:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfJUOlG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 10:41:06 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51492 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfJUOlG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 10:41:06 -0400
Received: from localhost ([::1]:36348 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iMYro-0006D5-04; Mon, 21 Oct 2019 16:41:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [nft PATCH] parser_json: Fix checking of parse_policy() return code
Date:   Mon, 21 Oct 2019 16:40:55 +0200
Message-Id: <20191021144055.13567-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function was changed to return an expression or NULL but error
checking wasn't adjusted while doing so.

Fixes: dba4a9b4b5fe2 ("src: allow variable in chain policy")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 55dbc177cc98d..fe0c5df98f5d4 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2630,7 +2630,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		chain->dev = xstrdup(chain->dev);
 	if (!json_unpack(root, "{s:s}", "policy", &policy)) {
 		chain->policy = parse_policy(policy);
-		if (chain->policy < 0) {
+		if (!chain->policy) {
 			json_error(ctx, "Unknown policy '%s'.", policy);
 			chain_free(chain);
 			return NULL;
-- 
2.23.0

