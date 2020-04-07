Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD264C2D0EC
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A484020748
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 19:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n6YkqXyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgDGTFU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 15:05:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38979 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTFU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 15:05:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id k18so1587279pll.6
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2020 12:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dEADKeQYoG+ZLp0YCqwwisDDcPPaUFr8FtVizwD2pkM=;
        b=n6YkqXyOI8Pl1TIaRLGJTpX/OJCQhLf4XnBuzhK/MMwx0S6AU1rI9oxvgkM6lzOxbk
         Th8v9o193zJNxrIGc0AlhmX90wxaxnSKLd/wkw6XzqgINJu5KA07stswW4lnWyFvECCT
         r8/84Lvf7TMf8qDSoly4zbhDYm4XFOe8mA0OkZcrkPdXC5Q+jNDoEVtLBet7onFaemCi
         nKF9j0CAkaE1Urfr1bV2Ble/gjqIxOZjkqZgQNmrhXoWO/YxMeBYwATDPDwwZX15ummH
         TvS5miviOkPgeoMeZgav6/5ANRnexABfjaDDMbxbqMtNmwOXfs81Iv2QIkuoHByOhfuC
         8I/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dEADKeQYoG+ZLp0YCqwwisDDcPPaUFr8FtVizwD2pkM=;
        b=GGHq5CJTz9GB1AgFZAA16/5jUZ6NBZKVoT+cYiU8MFecQnOq4l6Unt3mAvVxpRJclx
         yXGVNvGZNAJYfYsL/9IDKga29q3WfVFLL5o1iFVhjUMUs4vlLHJ3HP6/fSTOPEG6jlq8
         ZdziH/Xmc4cWAQMj7b+yxNG3IVpzOnD1b2JOoYY47Wi5BPLq1+wBBjFXn+0mnVnDoPQ7
         TEpw9y2liilMAdJN2q5pOJm8E8R/bT5RrMSXtrrTt+FD1n0UFnaE5FY5nu9gAzre0mm+
         t0x8OGJpBtz/3GHGnx/4QgP/wHKKOq0KWdIl/robGl5dg+e/6ds9KUGLBMNf7BM+jZaO
         DfnA==
X-Gm-Message-State: AGi0PuaCC310TGeevS8pDB9gDPpOINIVofe1kaVagBqHoSdEDn+Qv73i
        G23E9zIJp+khQ+OF0Ldr6DaHOA4i
X-Google-Smtp-Source: APiQypJlKwVhhxV0HA3xlQWnkf52W+fkkiXZoPq6QIJB6dzN74KsE3syhpJngjQk1p7EsQ80U7wkKQ==
X-Received: by 2002:a17:902:690b:: with SMTP id j11mr3905472plk.236.1586286318678;
        Tue, 07 Apr 2020 12:05:18 -0700 (PDT)
Received: from localhost ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id t186sm13791128pgd.43.2020.04.07.12.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 12:05:17 -0700 (PDT)
From:   Matt Turner <mattst88@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Matt Turner <mattst88@gmail.com>
Subject: [PATCH nftables] doc: Include generated man pages in dist tarball
Date:   Tue,  7 Apr 2020 12:05:08 -0700
Message-Id: <20200407190508.21496-1-mattst88@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most projects ship pre-generated man pages in the distribution tarball
so that builders don't need the documentation tools installed, similar
to how bison-generated sources are included.

To do this, we conditionalize the presence check of a2x on whether nft.8
already exists in the source directory, as it would exist if included in
the distribution tarball.

Secondly, we move the 'if BUILD_MAN' conditional to around the man page
generation rules. This ensures that the man pages are unconditionally
installed. Also only add the man pages to CLEANFILES if their generation
is enabled.

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 configure.ac    |  2 +-
 doc/Makefile.am | 17 ++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6a25eeb3..a04d94bc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,7 +50,7 @@ AC_EXEEXT
 AC_DISABLE_STATIC
 CHECK_GCC_FVISIBILITY
 
-AS_IF([test "x$enable_man_doc" = "xyes"], [
+AS_IF([test "x$enable_man_doc" = "xyes" -a ! -f "${srcdir}/doc/nft.8"], [
        AC_CHECK_PROG(A2X, [a2x], [a2x], [no])
        AS_IF([test "$A2X" = "no"],
 	     [AC_MSG_ERROR([a2x not found, please install asciidoc])])
diff --git a/doc/Makefile.am b/doc/Makefile.am
index f0958b33..6bd90aa6 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -1,6 +1,4 @@
-if BUILD_MAN
 man_MANS = nft.8 libnftables-json.5 libnftables.3
-endif
 
 A2X_OPTS_MANPAGE = -L --doctype manpage --format manpage -D ${builddir}
 
@@ -13,6 +11,12 @@ ASCIIDOC_INCLUDES = \
        statements.txt
 ASCIIDOCS = ${ASCIIDOC_MAIN} ${ASCIIDOC_INCLUDES}
 
+EXTRA_DIST = ${ASCIIDOCS} ${man_MANS} libnftables-json.adoc libnftables.adoc
+
+CLEANFILES = \
+	*~
+
+if BUILD_MAN
 nft.8: ${ASCIIDOCS}
 	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
 
@@ -22,10 +26,5 @@ nft.8: ${ASCIIDOCS}
 .adoc.5:
 	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
 
-EXTRA_DIST = ${ASCIIDOCS} libnftables-json.adoc libnftables.adoc
-
-CLEANFILES = \
-	nft.8 \
-	libnftables-json.5 \
-	libnftables.3 \
-	*~
+CLEANFILES += ${man_MANS}
+endif
-- 
2.24.1

