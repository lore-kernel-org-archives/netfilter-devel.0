Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB260C10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D49B220678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfDYM7s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:59:48 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55856 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfDYM7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 08:59:48 -0400
Received: from localhost ([::1]:40714 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdyc-0007qS-I0; Thu, 25 Apr 2019 14:59:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] parser_json: Fix parser for list maps command
Date:   Thu, 25 Apr 2019 14:59:43 +0200
Message-Id: <20190425125943.15787-5-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190425125943.15787-1-phil@nwl.cc>
References: <20190425125943.15787-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrong callback in json_parse_cmd_list() for "maps" key.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 01f340802bec9..5c00c9b003b60 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3147,7 +3147,7 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "set", CMD_OBJ_SET, json_parse_cmd_add_set },
 		{ "sets", CMD_OBJ_SETS, json_parse_cmd_list_multiple },
 		{ "map", CMD_OBJ_MAP, json_parse_cmd_add_set },
-		{ "maps", CMD_OBJ_MAPS, json_parse_cmd_add_set },
+		{ "maps", CMD_OBJ_MAPS, json_parse_cmd_list_multiple },
 		{ "counter", CMD_OBJ_COUNTER, json_parse_cmd_add_object },
 		{ "counters", CMD_OBJ_COUNTERS, json_parse_cmd_list_multiple },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
-- 
2.21.0

