Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFAFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 18:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbhLOSou (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 13:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhLOSou (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 13:44:50 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C747EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 10:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YSAoMuD4pPAcOi/bi9cD2E7bXqNbBqu5jb4/6X5tyK4=; b=oGKMtjRj3TQzNDX281cf5d7N/Q
        rLL8kMptmimkBWHc7YrS4bGY6hogCdhZgsz0wbN5cWp9MBp30knChJNS6qUpfJU6Chz6CK156blxm
        IesyUwUrJYMMS1yFhi54v9paAN4Mj5TBuLVEFtFi1ONwK09LpVjcS/xAqOXEScftQD+n9et8Farmj
        bns0j5TiGK8S6k9Bo2JI2E1i6aGmRjjZQEi7Mya+B1HEOl3dbVDY2FD7+a1umASteZHL9fmOn88E5
        3EX1Q4qzyTZ3FwxBlVjhXrBas5SAGpVaNoSjoPL4SHuPCGh8LNQ3T4FtHL1rFTDu8pIddV9bKkeG3
        /G7gmOAw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxZGh-008YbR-BC
        for netfilter-devel@vger.kernel.org; Wed, 15 Dec 2021 18:44:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] build: fix autoconf warnings
Date:   Wed, 15 Dec 2021 18:44:40 +0000
Message-Id: <20211215184440.39507-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

autoconf complains about three obsolete macros.

`AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`, so
replace it.

`AM_PROG_LEX` calls `AC_PROG_LEX` with no arguments, but this usage is
deprecated.  The only difference between `AM_PROG_LEX` and `AC_PROG_LEX`
is that the former defines `$LEX` as "./build-aux/missing lex" if no lex
is found to ensure a useful error is reported when make is run.  How-
ever, the configure script checks that we have a working lex and exits
with an error if none is available, so `$LEX` will never be called and
we can replace `AM_PROG_LEX` with `AC_PROG_LEX`.

`AM_PROG_LIBTOOL` has been superseded by `LT_INIT`, which is already in
configure.ac, so remove it.

We can also replace `AC_DISABLE_STATIC` with an argument to `LT_INIT`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index bb65f749691c..503883f28c66 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,7 +9,7 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-AC_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 
 AC_ARG_ENABLE([debug],
 	      AS_HELP_STRING([--disable-debug], [Disable debugging symbols]),
@@ -26,7 +26,7 @@ AC_PROG_CC
 AC_PROG_MKDIR_P
 AC_PROG_INSTALL
 AC_PROG_SED
-AM_PROG_LEX
+AC_PROG_LEX([noyywrap])
 AC_PROG_YACC
 
 if test -z "$ac_cv_prog_YACC" -a ! -f "${srcdir}/src/parser_bison.c"
@@ -43,11 +43,9 @@ then
 fi
 
 AM_PROG_AR
-AM_PROG_LIBTOOL
-LT_INIT
+LT_INIT([disable-static])
 AM_PROG_CC_C_O
 AC_EXEEXT
-AC_DISABLE_STATIC
 CHECK_GCC_FVISIBILITY
 
 AS_IF([test "x$enable_man_doc" = "xyes"], [
-- 
2.34.1

