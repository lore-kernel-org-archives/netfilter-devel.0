Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C212C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhKUUoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 15:44:55 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91490C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rYtJUMdSa9fSrfppjW961Q/Ptv3WFOPynYa297e9/RM=; b=V2LtlyjC5eBess5uhzMGQzQRrk
        emv0+O4jBl25dwJJqyVZHQh7GUplCVP1BqOzqjlwNakHVMOGSh8U1+5UAN6mHTB4rLp8+nLp+KFhE
        IKWobV+3+yIu5fcm41+oeJMVs+x/duE+talQD58WfDR2JYu+L7gu8MyqtURWcrW5rUkAb29U7Ru98
        IsRDrkTtNBe2+4Ewt+Q4tuzPm8eL4QlfntVBef2u0AsuEb1hNi7ZtFzNsvSCX0lrvD6dJE4zmDjl5
        5N28MHFk1mM4yD4V9jzYq8iWR9EztzIzm5GKVvC10OAYUWfRC5LZqtxHmbqYwkZpyYtJ+XoaWJPWX
        zI1+4Smg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1motel-0025lK-6V
        for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2021 20:41:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 2/5] ulogd: remove empty log-line
Date:   Sun, 21 Nov 2021 20:41:36 +0000
Message-Id: <20211121204139.2218387-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211121204139.2218387-1-jeremy@azazel.net>
References: <20211121204139.2218387-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a `strdup` at the beginning of `create_stack`.  If it fails, an
empty log-line is printed.  It's not useful, so remove it.  This is
consistent with the error-handling of the `malloc` which immediately
follows it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/ulogd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 9cd64e8e19b2..a31b35592a87 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -965,7 +965,6 @@ static int create_stack(const char *option)
 		load_all_plugins();
 
 	if (!buf) {
-		ulogd_log(ULOGD_ERROR, "");
 		ret = -ENOMEM;
 		goto out_buf;
 	}
-- 
2.33.0

