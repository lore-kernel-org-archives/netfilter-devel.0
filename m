Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EFEC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA522610CB
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhHZDop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZDoo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1CFC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e7so1936384pgk.2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7JSeVcstpv4YiH7xcHTuZOX1UO+JywwOv2W9h51WD0=;
        b=Z0vos1WOML3TROo+oY5W4V1VYZwQbpIF/OD7SB81PXgAzWduhUHwyMhV+oH78m9Zr2
         +NXOQFDhrK0rH+uSEpplKmhCP0bgCaQN166wD7KUwwzTPhhU6zOtJpgCHdCdjX+cMvCZ
         TwBcz4l2uSYEmobRvdbqDA/vNQP4FxAB36Iim9jpE2UapqSW3dS2hnFnW72ZkNkPqKb7
         Alffy/W8yik8hVun6YlB7L1jVkhYL7X0YnjrdatPCit7KQZpZ1NQu6CoQRYNhpIviB+v
         eWZgkYHAn9pu6+CtTlxHzgCUaxfQqfyyHTTHMnTtIg8hOiIOJUDTezqHLS7spLN28go6
         ZF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=h7JSeVcstpv4YiH7xcHTuZOX1UO+JywwOv2W9h51WD0=;
        b=AmGBUHjT9P+BHN1W5MMQ2V2dxHGWLIazwEICunGuRsGveHnWBIO5+lTRNyKovuCdws
         YbjuLSnSJVoFg46qmWHJzqFTqEWX4pP3LCMmbW488T7mS+QZ6T9exnfcmPE0vGXNsMDL
         xQHHkz46lQGZqTfg365vXOxO3p79K2Y5bx1zTNSaDmlcdWkLWQ9QoZzKKqQnlKYsXMQE
         iwsx9sefeWw/1QLtmYTKZ7/gmermfw8MIkVhTA/TZyP6yEh/tPnUyoqbbWhmVm/yueA3
         ZEv4MCnhOkEZoJulc56BYq81aroFy/DAKYDO3tWkQcJAw+cvGnBjgbXO55Uuw8OWPx7D
         mNjA==
X-Gm-Message-State: AOAM530LOfJSeBgl67/MfiqQ2gxlBxoOeIqbLxSwLW/XgirFQx9hAnCt
        rgxH3qV0SXk8/CYF/o+MAl8nvrUZ+rojwA==
X-Google-Smtp-Source: ABdhPJwRy+zC16y94BZCb2WuBCjtEKsv2EDJbDcM/8m1bxOksNJWTgUZxPCa3TTi7fgAmOWhbPJAMw==
X-Received: by 2002:a05:6a00:1989:b0:3e2:a387:e1d9 with SMTP id d9-20020a056a00198900b003e2a387e1d9mr1596102pfl.64.1629949437638;
        Wed, 25 Aug 2021 20:43:57 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s11sm1109193pfh.18.2021.08.25.20.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 20:43:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 3/5] build: doc: Avoid having to special-case `make distcheck`
Date:   Thu, 26 Aug 2021 13:43:44 +1000
Message-Id: <20210826034346.13224-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
References: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
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

