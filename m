Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E36C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB24220989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEILgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:36:33 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35074 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEILgd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:36:33 -0400
Received: from localhost ([::1]:48164 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hOhLk-0000ee-B1; Thu, 09 May 2019 13:36:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/9] parser_json: Fix ct timeout object support
Date:   Thu,  9 May 2019 13:35:42 +0200
Message-Id: <20190509113545.4017-7-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509113545.4017-1-phil@nwl.cc>
References: <20190509113545.4017-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Seems like it wasn't possible to add or list ct timeout objects.

Fixes: c82a26ebf7e9f ("json: Add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 8707d2c74d0a7..d154babbfd6bc 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3002,6 +3002,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "counter", CMD_OBJ_COUNTER, json_parse_cmd_add_object },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
+		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object }
 	};
@@ -3168,6 +3169,7 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "quotas", CMD_OBJ_QUOTAS, json_parse_cmd_list_multiple },
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct helpers", CMD_OBJ_CT_HELPERS, json_parse_cmd_list_multiple },
+		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "limits", CMD_OBJ_LIMIT, json_parse_cmd_list_multiple },
 		{ "ruleset", CMD_OBJ_RULESET, json_parse_cmd_list_multiple },
-- 
2.21.0

