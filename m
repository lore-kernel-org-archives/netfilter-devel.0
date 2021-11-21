Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D455C4321E
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhKUUo5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 15:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4F3C06174A
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0UtzhUaOBtyrnyy3mKZVtkzz0ztQvQhzn5O/MkDmSI0=; b=DTAcE2dzciu52eMIwz6D5giTCL
        VtbfYDoVZ6V3Z4AwS14GCOZyKzbIJiyQ5Y00ZAI9M09osVFst+pQN3h5VSnGslDzLfYtb0zgnKvBL
        1N8vxrzVmow5+FaW7XmgaA9JhmURXc6gbsEFvg4em/4Bi1pTnaGmJnF9aCpgfnA13wEx+pUZKlJ7z
        Rlqh93+9y9fiF04rlA6WZkjhiHrwuMq6z9GUay/1A5DQBBigRriqnn5cCKMgZVovRpJ99E9Rn8GLQ
        /gtgmeXbfLOtSTkfg05WVuzVoNZ6YoITePD/dwdOFcc8Hh40e029E+wHGo5AwZh8eKmiaEWpfBOTz
        M8YakBNA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1motel-0025lK-4A
        for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2021 20:41:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 1/5] include: add `format` attribute to `__ulogd_log` declaration
Date:   Sun, 21 Nov 2021 20:41:35 +0000
Message-Id: <20211121204139.2218387-2-jeremy@azazel.net>
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

`__ulogd_log` takes a printf-style format string and matching arguments.
Add the gcc `format` attribute to its declaration in order to allow the
compiler to type-check the function arguments against the specifiers in
the format string.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/ulogd.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 1636a8caa854..a487c8e70e37 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -299,8 +299,9 @@ void ulogd_register_plugin(struct ulogd_plugin *me);
 /* allocate a new ulogd_key */
 struct ulogd_key *alloc_ret(const uint16_t type, const char*);
 
-/* write a message to the daemons' logfile */
-void __ulogd_log(int level, char *file, int line, const char *message, ...);
+/* write a message to the daemon's logfile */
+void __ulogd_log(int level, char *file, int line, const char *message, ...)
+	__attribute__((format(printf, 4, 5)));
 /* macro for logging including filename and line number */
 #define ulogd_log(level, format, args...) \
 	__ulogd_log(level, __FILE__, __LINE__, format, ## args)
-- 
2.33.0

