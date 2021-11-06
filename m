Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E8FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02986120D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhKFQxC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbhKFQwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C854CC06120E
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oD2NMzC/TusRMueCCKNhJKRFOF2Jc/p5hl6u22uJUIU=; b=YC4iLJ1JnX7e4HCTvKz44JfxBX
        4QNe5cyUees9VbPzkUDIyg5LMKuQ5G68yZSKob+rqvXHtqwZDrLfdoNP7LYdKi0kZrMmCwsi4vcfH
        ar/VEwWI/gJpmU5/vQoR21ZNMZucOHDFAjGA3qum5dQGu3Ar0bEmi5S/laMprxYFjNnjHsjFGJAKc
        C1oE4gtiJL+rRCIRCDqTaHVoiqXp51I1nNb58WCRIAvdjeYttneoVWnZonlQJbeKHgzzw8+NxibC4
        JgFI/VpN7aFBs5gWc5TuMnOqr+X/1d9yWPCJAHmFCuKXczgq2vY+NW6RCaewcLXxjyB5Dy2p1YCRQ
        HQmGBaaA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-1A
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 01/27] include: add format attribute to __ulogd_log declaration
Date:   Sat,  6 Nov 2021 16:49:27 +0000
Message-Id: <20211106164953.130024-2-jeremy@azazel.net>
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
 include/ulogd/ulogd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 1636a8caa854..09f4a09cc56e 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -299,7 +299,8 @@ void ulogd_register_plugin(struct ulogd_plugin *me);
 /* allocate a new ulogd_key */
 struct ulogd_key *alloc_ret(const uint16_t type, const char*);
 
-/* write a message to the daemons' logfile */
+/* write a message to the daemon's logfile */
+__attribute__ ((format (printf, 4, 5)))
 void __ulogd_log(int level, char *file, int line, const char *message, ...);
 /* macro for logging including filename and line number */
 #define ulogd_log(level, format, args...) \
-- 
2.33.0

