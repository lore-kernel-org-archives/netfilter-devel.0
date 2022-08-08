Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79197C00140
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Aug 2022 22:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244267AbiHHWZJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiHHWZI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Aug 2022 18:25:08 -0400
X-Greylist: delayed 373 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 Aug 2022 15:25:06 PDT
Received: from mxout01.bytecamp.net (mxout01.bytecamp.net [212.204.60.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3182165B1
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2022 15:25:06 -0700 (PDT)
Received: by mxout01.bytecamp.net (Postfix, from userid 1001)
        id D6D6C4A670; Tue,  9 Aug 2022 00:18:51 +0200 (CEST)
Received: from mail.bytecamp.net (mail.bytecamp.net [212.204.60.9])
        by mxout01.bytecamp.net (Postfix) with ESMTP id 98D8B4A66E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 00:18:51 +0200 (CEST)
Received: (qmail 121 invoked from network); 9 Aug 2022 00:18:51 +0200
Received: from unknown (HELO j7.lan) (jo%wwsnet.net@77.22.166.186)
  by mail.bytecamp.net with ESMTPS (DHE-RSA-AES256-GCM-SHA384 encrypted); 9 Aug 2022 00:18:51 +0200
From:   Jo-Philipp Wich <jo@mein.io>
To:     netfilter-devel@vger.kernel.org
Cc:     Jo-Philipp Wich <jo@mein.io>
Subject: [PATCH nftables] meta: don't use non-POSIX formats in strptime()
Date:   Tue,  9 Aug 2022 00:18:42 +0200
Message-Id: <20220808221842.2468359-1-jo@mein.io>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The current strptime() invocations in meta.c use the `%F` format which
is not specified by POSIX and thus unimplemented by some libc flavors
such as musl libc.

Replace all occurrences of `%F` with an equivalent `%Y-%m-%d` format
in order to be able to properly parse user supplied dates in such
environments.

Signed-off-by: Jo-Philipp Wich <jo@mein.io>
---
 src/meta.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 80ace25b..257bbc9f 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -399,7 +399,7 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 		tstamp += cur_tm->tm_gmtoff;
 
 	if ((tm = gmtime((time_t *) &tstamp)) != NULL &&
-	     strftime(timestr, sizeof(timestr) - 1, "%F %T", tm))
+	     strftime(timestr, sizeof(timestr) - 1, "%Y-%m-%d %T", tm))
 		nft_print(octx, "\"%s\"", timestr);
 	else
 		nft_print(octx, "Error converting timestamp to printed time");
@@ -412,11 +412,11 @@ static bool parse_iso_date(uint64_t *tstamp, const char *sym)
 
 	memset(&tm, 0, sizeof(struct tm));
 
-	if (strptime(sym, "%F %T", &tm))
+	if (strptime(sym, "%Y-%m-%d %T", &tm))
 		goto success;
-	if (strptime(sym, "%F %R", &tm))
+	if (strptime(sym, "%Y-%m-%d %R", &tm))
 		goto success;
-	if (strptime(sym, "%F", &tm))
+	if (strptime(sym, "%Y-%m-%d", &tm))
 		goto success;
 
 	return false;
-- 
2.35.1

