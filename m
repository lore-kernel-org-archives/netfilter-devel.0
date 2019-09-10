Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04ED9C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5205208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbfIJNqS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732988AbfIJNqS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:46:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 252333175566;
        Tue, 10 Sep 2019 13:46:18 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BDE16092F;
        Tue, 10 Sep 2019 13:46:17 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] parser_json: fix crash on insert rule to bad references
Date:   Tue, 10 Sep 2019 09:46:15 -0400
Message-Id: <20190910134615.11742-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 10 Sep 2019 13:46:18 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the location via the handle so the error leg in
erec_print_list() can reference it. Applies to invalid references
to tables, chains, and indexes.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 8ca07d717b13..183d9c972181 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3258,7 +3258,11 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 					  json_t *root, enum cmd_ops op)
 {
-	struct handle h = { 0 };
+	struct handle h = {
+		.table.location = *int_loc,
+		.chain.location = *int_loc,
+		.index.location = *int_loc,
+	};
 	json_t *tmp, *value;
 	const char *family;
 	struct rule *rule;
-- 
2.20.1

