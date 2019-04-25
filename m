Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFDC10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 13:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DBC820678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfDYM77 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:59:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55868 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfDYM77 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 08:59:59 -0400
Received: from localhost ([::1]:40726 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdyn-0007rR-6p; Thu, 25 Apr 2019 14:59:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] parser_json: Fix typo in ct timeout policy parser
Date:   Thu, 25 Apr 2019 14:59:42 +0200
Message-Id: <20190425125943.15787-4-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190425125943.15787-1-phil@nwl.cc>
References: <20190425125943.15787-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parser expects an object in policy property and json_is_object() returns
true if given parameter is an object. The check was inverse by accident.

Fixes: c82a26ebf7e9f ("json: Add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 53017935eba53..01f340802bec9 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2782,7 +2782,7 @@ static int json_parse_ct_timeout_policy(struct json_ctx *ctx,
 	if (!json_unpack(root, "{s:o}", "policy", &tmp))
 		return 0;
 
-	if (json_is_object(tmp)) {
+	if (!json_is_object(tmp)) {
 		json_error(ctx, "Invalid ct timeout policy.");
 		return 1;
 	}
-- 
2.21.0

