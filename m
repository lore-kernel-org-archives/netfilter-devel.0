Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805A2C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C5C4619F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355123AbhJARrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355161AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94483C0613E3
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lQPAy9dL+C7E5ele8IjmeZ3sVL1dn+jn6e1mc9tWNc8=; b=UkkMxWpGCMLtpxPdO0ldE3nNFb
        076VvVdHEjjmaeuq3brCLygFFLosRqftgJeEM8zWADVxVQqVbukrx2E3xeA7SZ8gh+2FKceQPLEtt
        f15gs3DZCqW6OkhNPAtvfX6MM3JzrW0SwYE66ZcmjaPoIKfAWeZgPvSguhsbdevZBvBeff2Q6Q8Qr
        JrHFtL32kKTDKPPgDXyKPz5x1AIRWGYMpmpBxXvz6RoA+jMA/CTDluuiK3xzW5r4c9ufDuoVm5b5K
        rWeiqGI0JPQoe6SU04MbAQpxc8BZ1YCIvcqW5oG7LnmWQdT3SwKV6vJEcHQuSx1pE/TUdZZdz/H5e
        UcJO4nqA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbH-002RLP-2w; Fri, 01 Oct 2021 18:45:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 5/8] extensions: libxt_NFLOG: fix `--nflog-prefix` Python test-cases
Date:   Fri,  1 Oct 2021 18:41:39 +0100
Message-Id: <20211001174142.1267726-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `iptables-save` includes an extra space between `--nflog-prefix` and
the prefix.

The maximum length of prefixes includes the trailing NUL character.

NFLOG silently truncates prefixes which exceed the maximum length.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index eefb058be30e..13bbf2bfc5a5 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -14,10 +14,8 @@
 -j NFLOG --nflog-size 4294967295;=;OK
 -j NFLOG --nflog-size 4294967296;;FAIL
 -j NFLOG --nflog-size -1;;FAIL
-# ERROR: cannot find: iptables -I INPUT -j NFLOG --nflog-prefix  xxxxxx [...]
-# -j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;=;OK
-# ERROR: should fail: iptables -A INPUT -j NFLOG --nflog-prefix  xxxxxxx [...]
-#  -j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;;FAIL
+-j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;=;OK
+-j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;-j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;OK
 -j NFLOG --nflog-threshold 1;=;OK
 # ERROR: line 13 (should fail: iptables -A INPUT -j NFLOG --nflog-threshold 0
 # -j NFLOG --nflog-threshold 0;;FAIL
-- 
2.33.0

