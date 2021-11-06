Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87ADC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F16D60F9D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhKFQwx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhKFQwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:49 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91DEC061714
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oE0/xAUXUuNf1rPDQv9lkhHluFN/a3gRjJvvF+caPks=; b=TmAFHrFkZfu+rkMFxfHGD7svM9
        /WByFai6M6/xGXt1NkNcMiT+unKO1gBg0UtJCLpefy5OC6HKHHuNwkH+UzaO4MQZZvKXWmNJhRzTI
        OfnAGgAW/VFivsu+hz8CLK+3V2K2DGEdeKTWt58mj0ULoF28CwY6SCHJW1mddBuxPlWX7Mr9aM3I/
        O57i1C69LebeJo+NQZW9+E8KkOPieoNLFOTgxNWv9atJHA6n4PuDVt0Tf8IkN1dEvCss5P+qJ26EA
        jH96b2r+hD/XDZUDWUVsyn1jFi6aNdCX6cBiEk7UBjVZODG+IOpL8xISFBKXuYH8Fk6Nd/EBwR1Wz
        o2oDjlLQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-4x
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 02/27] ulog: remove empty log-line
Date:   Sat,  6 Nov 2021 16:49:28 +0000
Message-Id: <20211106164953.130024-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

