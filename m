Return-Path: <SRS0=Qe96=UW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6073C43613
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jun 2019 16:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9481C206BA
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jun 2019 16:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfFWQZz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jun 2019 12:25:55 -0400
Received: from fnsib-smtp05.srv.cat ([46.16.61.55]:35137 "EHLO
        fnsib-smtp05.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfFWQZz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jun 2019 12:25:55 -0400
Received: from localhost.localdomain (static-187-140-230-77.ipcom.comunitel.net [77.230.140.187])
        by fnsib-smtp05.srv.cat (Postfix) with ESMTPSA id 3A9B31EF17E;
        Sun, 23 Jun 2019 18:25:51 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH 2/2] meta: hour: Fix integer overflow error
Date:   Sun, 23 Jun 2019 18:25:44 +0200
Message-Id: <20190623162544.11604-2-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190623162544.11604-1-a@juaristi.eus>
References: <20190623162544.11604-1-a@juaristi.eus>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes an overflow error that would happen when introducing edge times
whose second representation is smaller than the value of the tm_gmtoff field, such
as 00:00.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 src/meta.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 31a86b2..39e551c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -565,7 +565,7 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
 		cur_tm = localtime(&ts);
 
 		if (cur_tm)
-			seconds += cur_tm->tm_gmtoff;
+			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
 
 		__hour_type_print_r(0, 0, seconds, out);
 		nft_print(octx, "\"%s\"", out);
@@ -616,8 +616,12 @@ convert:
 		result = tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
 
 	/* Substract tm_gmtoff to get the current time */
-	if (cur_tm)
-		result -= cur_tm->tm_gmtoff;
+	if (cur_tm) {
+		if (result >= cur_tm->tm_gmtoff)
+			result -= cur_tm->tm_gmtoff;
+		else
+			result = 86400 - cur_tm->tm_gmtoff + result;
+	}
 
 success:
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
-- 
2.17.1

