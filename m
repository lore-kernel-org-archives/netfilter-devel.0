Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78649C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBA461027
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbhKNQRz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 11:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbhKNQRw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 11:17:52 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEC4C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 08:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bYIQTA4SMrV3RiFmqhU7m2VxDYgQ3RMfnoe4g1RHe+4=; b=ONQ6R6u+VSoOLGGOUIRO7HmIsc
        Iw6Bj9P/rnHIQBYEmOjKMfaGpx6BBHPnc939RBvap5nKH7IV0fSqIP5HwKg7qGL7mr5HKsg6wr/mA
        EhEPvlUcCy/qY/vUT/7tycT6yO7bpVljejr0CnziSHFKppJdwActunJrjbV+Km5a98TefURUJS2rd
        MTRW2k6ZF8q0kdQSpdUggEAVIToB7YWz8ZslN1NZUGqLre7xKjcCmmO5ueNoUF990a5fJtUqyO5/v
        I9cNnAAo+dYqlUn8ef+pAUXQyKN1BBqazeuisovfUYUqbdywYitvjcNpl1OGtjSFWGe6IsQjAS6Yr
        yrwh44Iw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-LG
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 12/15] build: update obsolete autoconf macros
Date:   Sun, 14 Nov 2021 15:52:28 +0000
Message-Id: <20211114155231.793594-13-jeremy@azazel.net>
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

`AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`.

`AC_PROG_LIBTOOL` has been superseded by `LT_INIT`.

`AC_DISABLE_STATIC` can be replaced by an argument to `LT_INIT`.

`AC_HEADER_STDC` is obsolete.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index f7d6b50c47f5..b88c7a6d7708 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT([ulogd], [2.0.7])
 AC_PREREQ([2.50])
 AC_CONFIG_AUX_DIR([build-aux])
 AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b subdir-objects])
-AC_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
@@ -14,8 +14,7 @@ dnl Checks for programs.
 AC_PROG_MAKE_SET
 AC_PROG_CC
 AC_PROG_INSTALL
-AC_DISABLE_STATIC
-AC_PROG_LIBTOOL
+LT_INIT([disable-static])
 
 dnl Checks for libraries.
 AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
@@ -23,7 +22,6 @@ AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_HEADER_STDC
 AC_CHECK_HEADERS(fcntl.h unistd.h)
 
 dnl Checks for typedefs, structures, and compiler characteristics.
-- 
2.33.0

