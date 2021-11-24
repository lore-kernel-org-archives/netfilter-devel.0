Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BD6C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352020AbhKXWtJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbhKXWtJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:09 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7E3C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DfzHbviLuoDZWBXhQnVQJrVFizRiDUr9sNxbn9wsIug=; b=BNxOxQD+Hoz+vpZ5wngSDlvqHD
        3fwT+DWGBZyF6gmMe4I1ql3YGx00BgSsjzcKKLE/b0UZvb4vEUhcl0Ti49aemgbWz+Jzd3pkE/u6u
        hF/cn+NuacpJByu7hnrIVFrD+oFgegKzuZ+fchpVxNGwnzlWiReYjVHAUbHvj+BzsU1LVMaSuHZeS
        GwbkvNSFCOu64CByPbGLoCEcp6omxpNDebtp14dzv54RGDFgQoYDwABwBhorCPfzaLhJ4AuBlL9tR
        CQ+hP/uivbdPovjG3/2SeJFz/HElyreJoB+gkFyoNQlbzQLQ7uSqwi2APr15fLFGp60ZU1g1rMoe6
        U7evdHbQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-DB
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 26/30] output: JSON: increase time-stamp buffer size
Date:   Wed, 24 Nov 2021 22:24:34 +0000
Message-Id: <20211124222444.2597311-40-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The output buffer for date-times was of sufficient size provided that we
didn't get oversized integer values for any of the fields, which was a
reasonable assumption.  However, the compiler complained about possible
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

