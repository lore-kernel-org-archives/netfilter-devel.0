Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5CEC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F1D760E97
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhKNOEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhKNOER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B175EC061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ztIbJ1M0tfTe36AkWJu3d9oYYjniHM+t9A2+7EyxCVE=; b=IKQhr3/HNSLx9XaPX7tHtQ9PQ1
        2sLtfhFuNNb3XLPpMHjsSKM8wTsmzMvuY1QnSZWShi7ycD5fd4TTSioDMI98Ki+pjkh/vvaSxZuoV
        eGhFbyXOLmKOMPHE1UO5LaCQbgq3y8OQfxG/iE3HAlogihbgsdeFT/skZbOeOlUEYqPOrYOTRV7ye
        RaQhmKK+oBryhnKI5ahHFMnOD5lLYUDu3zseDP+6++r/QSCb36MlNwFxnaN2PqpBQ/LUI88tU6Ood
        YGZKPwimqlS6efWLTTJaiv/jBf33D0qDxAJx0Ej48pRBlrd13u6ogs1HRFtJdQE2ziTaSIyh3GnmU
        Yz3p3baQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4F-00Cdsh-PD
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 07/16] build: use `dist_man_MANS` to declare man-pages
Date:   Sun, 14 Nov 2021 14:00:49 +0000
Message-Id: <20211114140058.752394-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By using `dist_man_MANS`, instead of `man_MANS`, we no longer need to
include the man-pages in `EXTRA_DIST`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0e5721472cb2..7ea5db55a2cc 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,9 +1,9 @@
 
 ACLOCAL_AMFLAGS  = -I m4
 
-man_MANS = ulogd.8
+dist_man_MANS = ulogd.8
 
-EXTRA_DIST = $(man_MANS) ulogd.conf.in doc
+EXTRA_DIST = ulogd.conf.in doc
 
 SUBDIRS = include libipulog src input filter output
 
-- 
2.33.0

