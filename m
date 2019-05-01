Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619DAC43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A32B20835
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfEAQZk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 12:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfEAQZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 12:25:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 53F0B36887;
        Wed,  1 May 2019 16:25:40 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 473BB749B6;
        Wed,  1 May 2019 16:25:39 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] parser_json: fix off by one index on rule add/replace
Date:   Wed,  1 May 2019 12:25:37 -0400
Message-Id: <20190501162537.29318-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 01 May 2019 16:25:40 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We need to increment the index by one just as the CLI does.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 5c00c9b003b6..10ce259f0241 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2462,7 +2462,9 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
-	json_unpack(root, "{s:i}", "index", &h.index.id);
+	if (!json_unpack(root, "{s:I}", "index", &h.index.id)) {
+		h.index.id++;
+	}
 
 	rule = rule_alloc(int_loc, NULL);
 
@@ -3040,7 +3042,9 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 			    "expr", &tmp))
 		return NULL;
 	json_unpack(root, "{s:I}", "handle", &h.handle.id);
-	json_unpack(root, "{s:I}", "index", &h.index.id);
+	if (!json_unpack(root, "{s:I}", "index", &h.index.id)) {
+		h.index.id++;
+	}
 
 	if (op == CMD_REPLACE && !h.handle.id) {
 		json_error(ctx, "Handle is required when replacing a rule.");
-- 
2.20.1

