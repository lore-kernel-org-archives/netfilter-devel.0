Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BF4C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F23611C4
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhKFQrY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhKFQrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1270DC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bYIQTA4SMrV3RiFmqhU7m2VxDYgQ3RMfnoe4g1RHe+4=; b=qwm6I5xj44RN4P8NcMnab9rDF/
        q1oH5OjGZkOnyAX63LIvgxsr1mL1xtDS7Fc+zr0wXfjf/EQipX9519JuCXHvVyZ7cnIHbtuNFzqnw
        tCqWqqNETzA90/i/iUv0y2XRjBtGUVr5r3mZgTBV6sjN/Yx5FhDgQ1I4XXhfYEC2tEXdYxaoZYvvW
        M8rtRnwIbyqrJ+kQqhBXjvhtlDR5cU0iSzhGXiYWzSyL/dOYuKoPTma2Y4qlOkk0QN4fAYfXdt98D
        M4Ote8Vui5REod0W3xUpJ2/VnkLwbByvX6O24MmavVuMjkbkCvezKKl/dtb2fdbpGnfVMTzHcQQbu
        dyTJU9jQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOR-004loO-7f
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 10/12] build: update obsolete autoconf macros
Date:   Sat,  6 Nov 2021 16:17:57 +0000
Message-Id: <20211106161759.128364-11-jeremy@azazel.net>
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

