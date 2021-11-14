Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7A2C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F56D60EE2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhKNPzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhKNPzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:55:37 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CA1C061767
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2cG2kbJoxCdqgMLOiGDaI7VMPqLqlgie6AEtJKwSrYE=; b=sMJvSOBL8ojWvkTa1LNvchCl39
        itMpfEGz+jY9G4vd0IU2cVnvP+Y+871BqTLwcxT5xVIgirHZSaYO/IqdAXHZPpV9ZUSgt1+sOcA3m
        gV5oU3Z1xLNt6yKbrmJfcuvztuZv/bsnYkPs2QkWJ0dt/wVp1EyL5cLmGwynUAiedzRnYtwhoVDqG
        lEKL8Whc26ivf5+6cwTTIsiwIzQWcld5hjaTiab5Qo0OOsntzTuJ6s8Iey8ZrEyLq2PPWtce0kMgj
        3yKL9aVHLbl/DoLPchvXQxbS0P8E1NDZAx3QifWcbXdFTWCUQROCgl1gxpFALDI0o9Z3TmECSzCdA
        edQpZYMg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo8-00CfJ1-LL
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 02/15] gitignore: ignore .dirstamp
Date:   Sun, 14 Nov 2021 15:52:18 +0000
Message-Id: <20211114155231.793594-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's created by automake while making sure that build directories (utils/
and utils/.deps/, in this case) exist if the `subdir-objects` option is
enabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 3f218218dfc9..3eb592245c0d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,6 +6,7 @@
 *.lo
 *.o
 .deps/
+.dirstamp
 .libs/
 Makefile
 Makefile.in
-- 
2.33.0

