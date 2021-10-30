Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA1DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645E4603E8
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJ3RN3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhJ3RN3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:29 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7B5C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Evo1lJOvyGT8ovCo1QYIajPDG0GQwr81uNTdqbdtaQM=; b=f/4f/pXzRrqOfVcDoRCOtpGWe8
        VCq69ZzXqt+XL4AsI2VS95o+HwHVywrS4U3xww/CPL3sctPU962mfkqc1Yjl/wDPAX29uBLqFK5M8
        1q8xMLemjiV1BVKHuR8duMllIwivXzEKvUFizFt7KKZm9vJBJdWPamJb/Eqv/P+kbOzNPbzWc8Oaj
        AkcHPb0GVfFDfOGJAglom2wYSGzmA0KV5YzigsKrYyAOkJbRW9aIWGkkBctvrNyOegHXiMmEFY7U/
        1qZ6yzP6GQkHaCZiwQBXQskee8Xi0LgDPhAgbeX1J4b1swxeZHZP7XAHgYUdWHewvlE88c1WOlpFS
        V+6cVR1A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTB-00AFgT-6N
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 24/26] output: JSON: fix printf truncation warnings.
Date:   Sat, 30 Oct 2021 17:44:30 +0100
Message-Id: <20211030164432.1140896-25-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mod gmt offset by 86400 to give the compiler a hint.

Make date-time buffer big enough to fit all integer values.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 621333261733..6c61eb144135 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -269,7 +269,7 @@ static int json_interp_file(struct ulogd_pluginstance *upi, char *buf)
 	return ULOGD_IRET_OK;
 }
 
-#define MAX_LOCAL_TIME_STRING 38
+#define MAX_LOCAL_TIME_STRING 80
 
 static int json_interp(struct ulogd_pluginstance *upi)
 {
@@ -305,8 +305,8 @@ static int json_interp(struct ulogd_pluginstance *upi)
 			snprintf(opi->cached_tz, sizeof(opi->cached_tz),
 				 "%c%02ld%02ld",
 				 t->tm_gmtoff > 0 ? '+' : '-',
-				 labs(t->tm_gmtoff) / 60 / 60,
-				 labs(t->tm_gmtoff) / 60 % 60);
+				 labs(t->tm_gmtoff) % 86400 / 60 / 60,
+				 labs(t->tm_gmtoff) % 86400 / 60 % 60);
 		}
 
 		if (pp_is_valid(inp, opi->usec_idx)) {
-- 
2.33.0

