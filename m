Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3819C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhLQICi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLQICi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:02:38 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A24C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:02:37 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r5so1389882pgi.6
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ka3ZhETmu7MNSI+X/9uqU3jHsQz88fncZQeBg3iz3L0=;
        b=aPTGSmxYd0PAGH/3ByFr2zAjkhlNNQSANwW9DEWPk+TXKQ65tIpcvhp8qmXZJQutQD
         Amdem5lyqYUJo7uakOOttB/LeHgaGDMpP98zyQWnxR7n/shZtgiGpjJY8aPi2CE49CSE
         nEPkuvvpxZpHbmy+i63YMiQJnyU3MtP2Ifp/DRk2l2BJaCaWfLFJWD8r/a9k+Hw9WA/O
         WmNh4Zu35T8U1n0kaTk5CWNH/zLWuH4rrYIFkdXjadMsqEVeR6Y8L0O7LWMtzMgZVyoE
         TUtVaWOcj6FqFWIf8Lb0FIh4G7wBOnn9ftKwJ/F4f5jKKhFBm8pxQvNqonucCtrfGrLZ
         3G6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ka3ZhETmu7MNSI+X/9uqU3jHsQz88fncZQeBg3iz3L0=;
        b=HBbi6EE1YJYyj0OMvFJegfi0zkVHNh9lZxBNWIwjOe12kkzXFOXV6YuOWT0XxRb8Dj
         jg1bPpl7QReyJCJpSHb87Gdya9LMe/AJdAm0jR284+80scUMPKue7vLaD82J2l7Q2yOv
         08Lh+n/6fq3u8+cWY9N5+o0fHRzt5EfXfrcxBtG6v0Tz53UKmCtwdQfqxjtDhydqqsCJ
         KkCzVbsCMEJpNe0SNdERmOyfeWJDTe1WBLo6FOP0zsnXmM+phxJmDiG3kHJLHDMggDtQ
         pE4qWUEkY8O0h1dyVW3rQNm/54EmrCYF2Xv7pCnpz5S3mfw/v4DEQCod714avlrJzisO
         r52Q==
X-Gm-Message-State: AOAM530hsO1lxJ+cmbu19iaIP3lj6R6mRA8Xvfi+TXRLtEHFnj6f0uTp
        G7dz9HgRD+EgbvaWrAlbwFnsmrlLWn4=
X-Google-Smtp-Source: ABdhPJzT2QmnRsTEvijhIlaqmeqnsdGyvpzz6RBM3dYZ9kiZ3E8wQcDWb1t87RIE5kKLdcEANTNbXw==
X-Received: by 2002:a62:640c:0:b0:4a2:e5af:d2a9 with SMTP id y12-20020a62640c000000b004a2e5afd2a9mr2006314pfb.43.1639728157531;
        Fri, 17 Dec 2021 00:02:37 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id w19sm7511136pga.80.2021.12.17.00.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:02:36 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/1] graphics/graphviz: Updated for version 2.50
Date:   Fri, 17 Dec 2021 19:02:29 +1100
Message-Id: <20211217080229.23826-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20200910040431.GC15387@dimstar.local.net>
References: <20200910040431.GC15387@dimstar.local.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove patch files - no longer required.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 graphics/graphviz/ghostscript918.patch | 18 ------------------
 graphics/graphviz/graphviz.SlackBuild  | 10 ++--------
 graphics/graphviz/graphviz.info        |  4 ++--
 graphics/graphviz/php_5.4_compat.patch | 17 -----------------
 4 files changed, 4 insertions(+), 45 deletions(-)
 delete mode 100644 graphics/graphviz/ghostscript918.patch
 delete mode 100644 graphics/graphviz/php_5.4_compat.patch

diff --git a/graphics/graphviz/ghostscript918.patch b/graphics/graphviz/ghostscript918.patch
deleted file mode 100644
index 189c5134ae..0000000000
--- a/graphics/graphviz/ghostscript918.patch
+++ /dev/null
@@ -1,18 +0,0 @@
-diff -uprb graphviz-2.38.0.orig/plugin/gs/gvloadimage_gs.c graphviz-2.38.0/plugin/gs/gvloadimage_gs.c
---- graphviz-2.38.0.orig/plugin/gs/gvloadimage_gs.c	2014-04-13 23:40:25.000000000 +0300
-+++ graphviz-2.38.0/plugin/gs/gvloadimage_gs.c	2015-11-11 00:08:32.916123704 +0200
-@@ -72,11 +72,11 @@ static void gs_error(GVJ_t * job, const
- 
-     assert (err < 0);
- 
--    if (err >= e_VMerror) 
-+    if (err >= gs_error_VMerror)
- 	errsrc = "PostScript Level 1"; 
--    else if (err >= e_unregistered)
-+    else if (err >= gs_error_unregistered)
- 	errsrc = "PostScript Level 2";
--    else if (err >= e_invalidid)
-+    else if (err >= gs_error_invalidid)
- 	errsrc = "DPS error";
-     else
- 	errsrc = "Ghostscript internal error";
diff --git a/graphics/graphviz/graphviz.SlackBuild b/graphics/graphviz/graphviz.SlackBuild
index 64d99cc85c..2fbafc1441 100644
--- a/graphics/graphviz/graphviz.SlackBuild
+++ b/graphics/graphviz/graphviz.SlackBuild
@@ -27,7 +27,7 @@
 cd $(dirname $0) ; CWD=$(pwd)
 
 PRGNAM=graphviz
-VERSION=${VERSION:-2.40.1}
+VERSION=${VERSION:-2.50.0}
 BUILD=${BUILD:-1}
 TAG=${TAG:-_SBo}
 PKGTYPE=${PKGTYPE:-tgz}
@@ -72,7 +72,7 @@ rm -rf $PKG
 mkdir -p $TMP $PKG $OUTPUT
 cd $TMP
 rm -rf $PRGNAM-$VERSION
-tar xvf $CWD/$PRGNAM.tar.gz
+tar xvf $CWD/$PRGNAM-$VERSION.tar.xz
 cd $PRGNAM-$VERSION
 chown -R root:root .
 find -L . \
@@ -84,12 +84,6 @@ find -L . \
 # Install PHP bindings to proper location.
 sed -i 's|/php/modules|/php/extensions|' configure
 
-# Fix for php-5.4
-patch -p1 -i $CWD/php_5.4_compat.patch
-
-# Patch from Arch (thanks!)
-patch -p1 -i $CWD/ghostscript918.patch
-
 CFLAGS="$SLKCFLAGS" \
 CXXFLAGS="$SLKCFLAGS" \
 LDFLAGS="-L/usr/lib${LIBDIRSUFFIX}" \
diff --git a/graphics/graphviz/graphviz.info b/graphics/graphviz/graphviz.info
index 9d3fe12952..385a70af79 100644
--- a/graphics/graphviz/graphviz.info
+++ b/graphics/graphviz/graphviz.info
@@ -1,8 +1,8 @@
 PRGNAM="graphviz"
 VERSION="2.40.1"
 HOMEPAGE="https://www.graphviz.org/"
-DOWNLOAD="https://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz"
-MD5SUM="4ea6fd64603536406166600bcc296fc8"
+DOWNLOAD="https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/2.50.0/graphviz-2.50.0.tar.xz"
+MD5SUM="ccc1c011d79fcdfccc1cb4be8a81edef"
 DOWNLOAD_x86_64=""
 MD5SUM_x86_64=""
 REQUIRES=""
diff --git a/graphics/graphviz/php_5.4_compat.patch b/graphics/graphviz/php_5.4_compat.patch
deleted file mode 100644
index 58c2993b36..0000000000
--- a/graphics/graphviz/php_5.4_compat.patch
+++ /dev/null
@@ -1,17 +0,0 @@
-diff -Naur graphviz-2.28.0.orig/tclpkg/gv/gv_php_init.c graphviz-2.28.0/tclpkg/gv/gv_php_init.c
---- graphviz-2.28.0.orig/tclpkg/gv/gv_php_init.c	2011-01-25 17:30:51.000000000 +0100
-+++ graphviz-2.28.0/tclpkg/gv/gv_php_init.c	2012-05-30 04:10:40.657221055 +0200
-@@ -19,11 +19,13 @@
- 
- static size_t gv_string_writer (GVJ_t *job, const char *s, size_t len)
- {
-+    TSRMLS_FETCH();
-     return PHPWRITE(s, len);
- }
- 
- static size_t gv_channel_writer (GVJ_t *job, const char *s, size_t len)
- {
-+    TSRMLS_FETCH();
-     return PHPWRITE(s, len);
- }
- 
-- 
2.17.5

