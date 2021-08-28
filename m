Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35278C4320A
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1593C60F25
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhH1DgK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1DgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:36:10 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC87C0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j2so5239022pll.1
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7JSeVcstpv4YiH7xcHTuZOX1UO+JywwOv2W9h51WD0=;
        b=mQzI8h8u+A5k18s9q3BB0Ot4VozzgGPkrIvUjYraO3ChBWv/iHoqbErmJ2bZSFqvhg
         uPE7H3akKuaKfQ8aIcKaVSyJgu/WZer9c23bpIbQ3GHCeccUsczbOGG1xqsPR1OQJu1Q
         fJb9klKk1Gcdy9NdjNlWSGWH4Tr+Y2TBNeBMpsGKubJ8RbNj6Z9qg6cd35j7MeJ1tUNT
         v/80Zvzt5kfMd7YvY9F6NiCklP5xG3ldvgVtbU9YYNO6TArq20XYTscyjLwafzYajt5W
         Sfex0aN9yPwiV8O6cZw9BxNjfkbJUtZ0OunvZFReZX4Way3Qx2fCW5rx75p1SEht4Wku
         GYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=h7JSeVcstpv4YiH7xcHTuZOX1UO+JywwOv2W9h51WD0=;
        b=mf9CW9sYFEXe8FHFfV4eFdh6S8NzbXTUoG4J6KdYCvz1JHx+kBOixOBIeYdYu1pu4L
         yVGp0vL/v4oyCHO6XwjS4wli+W0jaeJlua/Kf18muT1spk+cW8fY9vG9eqEXjgYJO/H9
         jNXCL+X5iEvZSsz+jQ5rU9dXF4GaoaD68IoAOYKn81eksTyBIaf1MRCg4yjpFQRxnZiu
         ZY5VpNdY4xYusZcojCcmDTRKrZBRTEqmbEHQXS+7bPIStTvEhh9WWCSh28wHKUMUT/rt
         m/9RGFh+GvhipA4D2IRvM/miKbt5bXIZW9arVguS6emqCJZeyfszAIWstkose30k7HGn
         /ifA==
X-Gm-Message-State: AOAM531Df4V1ZWDkESJ+qaO849W9t5WL/PAtxT1us78TDiflDpTgzwAu
        n1/qzoUUnvTZ5/GWhVfp+WYLLjx7hao=
X-Google-Smtp-Source: ABdhPJziOR12NhwIeTtjzSAIzo+SZG7zoGIXMSiPWkUJnf0cCRZGXwMF1NbF7yiweI0de3ZlUUcATA==
X-Received: by 2002:a17:902:6b09:b029:129:c61e:e31a with SMTP id o9-20020a1709026b09b0290129c61ee31amr11448750plk.57.1630121719460;
        Fri, 27 Aug 2021 20:35:19 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm8513021pgk.71.2021.08.27.20.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:35:19 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 3/6] build: doc: Avoid having to special-case `make distcheck`
Date:   Sat, 28 Aug 2021 13:35:05 +1000
Message-Id: <20210828033508.15618-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Move doxygen.cfg.in to doxygen/
- Tell doxygen.cfg.in where the sources are
- Let doxygen.cfg.in default its output to CWD
- In Makefile, `doxygen doxygen.cfg` "just works"

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac                             |  4 ++--
 doxygen/Makefile.am                      | 12 +-----------
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  3 +--
 3 files changed, 4 insertions(+), 15 deletions(-)
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (93%)

diff --git a/configure.ac b/configure.ac
index 0fe754c..4721eeb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,9 +31,9 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 dnl Output the makefiles
 AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
-        libnetfilter_queue.pc doxygen.cfg
+	libnetfilter_queue.pc
 	include/Makefile include/libnetfilter_queue/Makefile
-	doxygen/Makefile
+	doxygen/Makefile doxygen/doxygen.cfg
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
 AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 5068544..f38009b 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -4,17 +4,7 @@ doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
-
-# Test for running under make distcheck.
-# If so, sibling src directory will be empty:
-# move it out of the way and symlink the real one while we run doxygen.
-	[ -f ../src/Makefile.in ] || \
-{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
-
-	cd ..; doxygen doxygen.cfg >/dev/null
-
-	[ ! -d ../src.distcheck ] || \
-{ set -x; cd ..; rm src; mv src.distcheck src; }
+	doxygen doxygen.cfg >/dev/null
 
 	$(abs_top_srcdir)/doxygen/build_man.sh
 
diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
similarity index 93%
rename from doxygen.cfg.in
rename to doxygen/doxygen.cfg.in
index 266782e..99b5c90 100644
--- a/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -1,12 +1,11 @@
 # Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
-OUTPUT_DIRECTORY       = doxygen
 ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = .
+INPUT                  = @abs_top_srcdir@/src
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
-- 
2.17.5

