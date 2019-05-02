Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4338C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 16:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA4D2081C
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 16:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBQVE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 12:21:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBQVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 12:21:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 729668830A;
        Thu,  2 May 2019 16:21:02 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-125.rdu2.redhat.com [10.10.122.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C710F608A5;
        Thu,  2 May 2019 16:21:01 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] parser_json: default to unspecified l3proto for ct helper/timeout
Date:   Thu,  2 May 2019 12:20:57 -0400
Message-Id: <20190502162057.10312-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 02 May 2019 16:21:03 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As per the man page, if the user does not specify the l3proto it should
be derived from the table family.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 3fbb4457ddac..3dc3a5c5f93c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2817,7 +2817,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 					     enum cmd_obj cmd_obj)
 {
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
-	uint32_t l3proto = NFPROTO_IPV4;
+	uint32_t l3proto = NFPROTO_UNSPEC;
 	struct handle h = { 0 };
 	struct obj *obj;
 	int inv = 0;
-- 
2.20.1

