Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C1CC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2E8610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhKFQUy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhKFQUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE4FC061714
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YJDSq1MJxHJnZOnSwJU9fqNASWGAwk7dqrG5WCKbr5o=; b=hiKSIeXJ98wfxZsC36PG4pVbzm
        k4OLPLDIY8UPm6VQTsS3ekP6rlu62vnCFnr0slUdoLsnERUKJIq8MwsIAeEJExSszQxTPCcIQR3Hq
        ercYX/kiF83PSncq4RXKagaoHiNb8ILTsUUFd9i5Bp3xFKk4eO86fmZw5NlG44Cu3k3TTgr/V3tP/
        Es77Unu0q8h/9Fpu0Z5TP3Ts0JX+n5GNQ7cZuZWin2SH/VMT7nPEbNrL9uRi7uXGIJjqoeCk2KutA
        i7J9p/3x1dfwV8fkkllOw5W6rw1q3n+XWd047XY+1y5vYYOEoSemz71KxHUsrgxqDXoqLYE0arF89
        0Iu7Bc1g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOQ-004loO-EM
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 01/12] gitignore: add Emacs artefacts
Date:   Sat,  6 Nov 2021 16:17:48 +0000
Message-Id: <20211106161759.128364-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106161759.128364-1-jeremy@azazel.net>
References: <20211106161759.128364-1-jeremy@azazel.net>
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
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 0ff56cfe0423..3f218218dfc9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,3 +1,6 @@
+*~
+.\#*
+\#*\#
 # global
 *.la
 *.lo
-- 
2.33.0

