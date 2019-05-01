Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B059C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A16520835
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 16:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfEAQex (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 12:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEAQex (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 12:34:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 666192D7F6;
        Wed,  1 May 2019 16:34:53 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D864E90BC;
        Wed,  1 May 2019 16:34:52 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] parser_json: fix crash on add rule to bad references
Date:   Wed,  1 May 2019 12:34:45 -0400
Message-Id: <20190501163445.29604-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 01 May 2019 16:34:53 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the location via the handle so the error leg in
rule_translate_index() can reference it. Applies to invalid references
to tables, chains, and indexes.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 10ce259f0241..3fbb4457ddac 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2429,7 +2429,11 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 					   enum cmd_ops op, enum cmd_obj obj)
 {
-	struct handle h = { 0 };
+	struct handle h = {
+		.table.location = *int_loc,
+		.chain.location = *int_loc,
+		.index.location = *int_loc,
+	};
 	const char *family = "", *comment = NULL;
 	struct rule *rule;
 	size_t index;
-- 
2.20.1

