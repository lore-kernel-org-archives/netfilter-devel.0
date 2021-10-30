Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8FFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 12:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D3160EB8
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 12:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhJ3MSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 08:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhJ3MSW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 08:18:22 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56DC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 05:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JD7kPANIQ/hw7DG0rI9hDvShLiDzGLn3ZVemJbiiu0Y=; b=rr7ErnEzL5HNPX0vt2y37YYOtJ
        AhmfyCju4zOAANmTesRDfZuZGyxWIm6KQ2TvJEXd6lABCoZiHF377Cygs4O/nfb3wwffUp11pCxN6
        qhZtiuazM1gMiIaqdfGfnzYToJpIJQt4bojy0OSvmZ9r2zSwhyt6mvOR4NQFg8kF2H3HbvxoSajL/
        N9IZcWRAiKVmhkNO5/Jpaa6qsRVkGdy3BoYavJw+0D0TrYwjF1Ur5u5FlbO2g3RBLGPhV5y09k7GY
        XAIuKH54cjKbaaIU8YlF8toad0s91cfLh9QLg2mZWm9WjJ+hmKkpbwNekuDExSV9ACvLN/GTY5htL
        J61P0kLw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgnH2-00AAuB-0C
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 13:15:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH] build: fix pkg-config syntax-errors
Date:   Sat, 30 Oct 2021 13:15:46 +0100
Message-Id: <20211030121546.1072767-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pkg-config config-files require back-slashes when definitions are folded
across multiple lines.

Fixes: 3c2229da2e7f ("build: add pkg-config configuration for libipulog")
Fixes: f7da00cdc597 ("build: correct pkg-config dependency configuration")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 libnetfilter_log.pc.in           | 2 +-
 libnetfilter_log_libipulog.pc.in | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libnetfilter_log.pc.in b/libnetfilter_log.pc.in
index 9dbed7709632..14d16ed667d5 100644
--- a/libnetfilter_log.pc.in
+++ b/libnetfilter_log.pc.in
@@ -9,7 +9,7 @@ Name: libnetfilter_log
 Description: Netfilter userspace packet logging library
 URL: http://netfilter.org/projects/libnetfilter_log/
 Version: @VERSION@
-Requires.private: libnfnetlink >= @LIBNFNETLINK_MIN_VERSION@,
+Requires.private: libnfnetlink >= @LIBNFNETLINK_MIN_VERSION@, \
 		  libmnl >= @LIBMNL_MIN_VERSION@
 Conflicts:
 Libs: -L${libdir} -lnetfilter_log
diff --git a/libnetfilter_log_libipulog.pc.in b/libnetfilter_log_libipulog.pc.in
index 1b7d17a0ac62..35967902e22c 100644
--- a/libnetfilter_log_libipulog.pc.in
+++ b/libnetfilter_log_libipulog.pc.in
@@ -9,7 +9,7 @@ Name: libnetfilter_log_libipulog
 Description: Netfilter ULOG userspace compat library
 URL: http://netfilter.org/projects/libnetfilter_log/
 Version: @VERSION@
-Requires.private: libnetfilter_log >= @VERSION@,
+Requires.private: libnetfilter_log >= @VERSION@, \
                   libnfnetlink >= @LIBNFNETLINK_MIN_VERSION@
 Conflicts:
 Libs: -L${libdir} -lnetfilter_log_libipulog
-- 
2.33.0

