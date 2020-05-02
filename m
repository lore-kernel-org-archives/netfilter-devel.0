Return-Path: <SRS0=X9fE=6Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0869C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 May 2020 10:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5BA208DB
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 May 2020 10:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEBKLy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 May 2020 06:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgEBKLy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 May 2020 06:11:54 -0400
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9A7C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2020 03:11:53 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id D6AAF2010C;
        Sat,  2 May 2020 12:11:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 92A7461FC;
        Sat,  2 May 2020 12:11:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rDkEmT87Rimw; Sat,  2 May 2020 12:11:47 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Sat,  2 May 2020 12:11:47 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id E1DAE56050;
        Sat,  2 May 2020 12:11:46 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id B85A1306A950; Sat,  2 May 2020 12:11:46 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] main: fix get_optstring truncating output
Date:   Sat,  2 May 2020 12:11:43 +0200
Message-Id: <20200502101143.18160-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this patch, get_optstring returns optstring = +hvVcf:insNSI:d:aejuy.
After this patch, get_optstring returns optstring = +hvVcf:insNSI:d:aejuypTt

This is due to optstring containing up to two chars per option, thus it was too
short.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 src/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index d213c601..d830c7a2 100644
--- a/src/main.c
+++ b/src/main.c
@@ -118,7 +118,7 @@ static const struct nft_opt nft_options[] = {
 
 static const char *get_optstring(void)
 {
-	static char optstring[NR_NFT_OPTIONS + 2];
+	static char optstring[2 * NR_NFT_OPTIONS + 2];
 
 	if (!optstring[0]) {
 		size_t i, j;
@@ -128,6 +128,8 @@ static const char *get_optstring(void)
 			j += snprintf(optstring + j, sizeof(optstring) - j, "%c%s",
 				      nft_options[i].val,
 				      nft_options[i].arg ? ":" : "");
+
+		assert(j < sizeof(optstring));
 	}
 	return optstring;
 }
-- 
2.20.1

