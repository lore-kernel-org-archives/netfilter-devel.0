Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C644C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D2A61177
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhKNOSO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhKNOSN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:18:13 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC84AC061767
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bYIQTA4SMrV3RiFmqhU7m2VxDYgQ3RMfnoe4g1RHe+4=; b=Qvu5rQew8vLn9Rj8iT2quePxNb
        bR3VgnHjL8q2u/3ONkypgrqeJ18b6+JAMh76f+km8EUAiimFEjJJfm54UeET6XfWTvemU0MZ7u+P5
        hoeGMX6AR+DrS9nHD7E7gEFJMxvSBFTZ0p9tBYlyxC9BqOR2CWYZJS8k0uqRwd8zRabn2y+wskXQ6
        kgqDM8MsS3V4doPNLF7VkTcSPTgKFatX0FkDyYQQa6HhHVDbopyvpPX7mA5aLs5FimhlKdSZEjA7K
        7k6mj+2bbQL2gAevFmGvDfsatyBR8mibuXvmsY5GuErVclZu7UVLTY4gko2tvFFkSV/xP3oMHydAu
        jKB3cEYQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4G-00Cdsh-Mj
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 12/16] build: update obsolete autoconf macros
Date:   Sun, 14 Nov 2021 14:00:54 +0000
Message-Id: <20211114140058.752394-13-jeremy@azazel.net>
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

