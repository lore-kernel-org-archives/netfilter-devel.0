Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD6BC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02D160FD9
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhJ3QrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64051C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oD2NMzC/TusRMueCCKNhJKRFOF2Jc/p5hl6u22uJUIU=; b=Jkw71HT1Z+X0E0M6Fr7wgAA273
        ujAEwHUKGo1sQMMGkQe3ETFVzYT41PvR0mi8W0KsHCmibH8g2FqMSXFXlQEls/e9nlejcmq//CNvt
        35FnSlDKRaFQWfgmNFxbvIIurwDzGVivZfAOJfxzL5sW3AU2oPogFCKPzZ8HSPhFH8oV8q9GWp1/0
        JI+F/q+GjuHm9ngQJtFJsvuF2GmJ9s+qS/ly6svx4V/nII0TtElCq9hezuREcbOuH+A3ReC6Bsx2b
        tPv0cXiu7O/w9fOaNUcfzfeCm6h3K+Bkb1yeN/5ClrOU5M2e1kFVfElRjpmMLjeJ89G9pSIA612gt
        V5Af9O/A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-1g
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 01/26] include: add format attribute to __ulogd_log declaration
Date:   Sat, 30 Oct 2021 17:44:07 +0100
Message-Id: <20211030164432.1140896-2-jeremy@azazel.net>
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

