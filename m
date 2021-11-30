Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B1CC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhK3LSY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhK3LSX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:23 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F9C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sn0iRpgzZvU+CpjrzxUzsqmp/WocOoxP8tBjqd38NeI=; b=evsG14O3iXQjUsRgHZSnGlevkr
        ekEZ9BRQGAUMDDtLm7D4OjDzWTWhOYhLfJculi/UXoQ5spL5vxg4e5V7csuegxAU0XxbHU54quyrI
        +/7as7CIBbMQGiYckXdNOp/f/Xn/pn7kKST0Ie2ixWfQqgcXvk2VNBDQM2uMHKiDWKJhoPXm5Vj1G
        YM2Cz02y4ANOJAoeOlbpajbUl2YZCQC+XV2bJeG2lnzF5j9wrXZAFIBXEsB1zlz4ErHhajiha/UR9
        Y/kpQgrp1DZpfswl4+kVKAuXAflLjHNDMneZgfTdgqPNWAsyGoQmVCjzidpZesXlB2CC5pzUiMi7/
        rsly5yYg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nt-00Awwr-KH
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 28/32] output: JSON: increase time-stamp buffer size
Date:   Tue, 30 Nov 2021 10:55:56 +0000
Message-Id: <20211130105600.3103609-29-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The output buffer for date-times is of sufficient size provided that we
don't get oversized integer values for any of the fields, which is a
reasonable assumption.  However, the compiler complains about possible
truncation, e.g.:

  ulogd_output_JSON.c:314:65: warning: `%06u` directive output may be truncated writing between 6 and 10 bytes into a region of size between 0 and 18
  ulogd_output_JSON.c:313:25: note: `snprintf` output between 27 and 88 bytes into a destination of size 38

Fix the warnings by increasing the buffer size.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index f5c065dd062a..d949df6bb530 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -269,7 +269,7 @@ static int json_interp_file(struct ulogd_pluginstance *upi, char *buf)
 	return ULOGD_IRET_OK;
 }
 
-#define MAX_LOCAL_TIME_STRING 38
+#define MAX_LOCAL_TIME_STRING 80
 
 static int json_interp(struct ulogd_pluginstance *upi)
 {
-- 
2.33.0

