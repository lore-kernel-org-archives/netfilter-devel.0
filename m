Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4227FC2D0EC
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 20:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CC6520748
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 20:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUnv6kXN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgDGUXn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 16:23:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39113 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGUXn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 16:23:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id g32so2262163pgb.6
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2020 13:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcmWB88u6DUQNSHUBnL+DPiBq7na3itwbE61s39wJgs=;
        b=eUnv6kXNnSdOsJ8aO92blCpEzLL+27vYbKJjuBMCMqnPww7g+wBHLjn3pXzmiUUltt
         KkR2JdNGFeIfNOOgISQOJgdoc2BRmHbuSmNOW5m8WU37gdjc2bkrIt+uWN6D9hNHLCQB
         xCtXTb96gAhNCOc4bIR9zhzuDZSbcZlDcT2XjtLrqpfgW6c1R5oczOt0XvrjKvzU/lAf
         MseAjLNksUZLl1mGKomDkjCerJ+EyHjkyeoFWtOUvpHJBgGKTexJw0lc4Tu26Iu+cV7s
         1W0DCt6I4eRuJNiY8WY6BmgX2ly7lUCbo4Gflw8UnMqJXr+Q6KbEon2zP8ZkrVnUGdLD
         urjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcmWB88u6DUQNSHUBnL+DPiBq7na3itwbE61s39wJgs=;
        b=L9IVtxatLNdfD28s/kOmDkUVuyqNiA0iJjvgkZPllCdKEnquP2wJj5JmghHMQx/SRO
         QGu6jkhiTgBY/vz0voK0dibr5C/qrz1QhqMqsqQ1YHK2Mft4ISsyPnqVBQx0w0hfy1Z3
         e+rkInG5IeVWa/8sZAFSsk2ld7/bEKViIIvopYXhZb6WX6jOn0CEJxtJneb5+Pg2OW5j
         iuFtNvgVxxU3s66jHBea1o+azX/pagFQ9fCvUfMWwOXfpca7L7Ck/ZB7vY/LFtM4Txp1
         D63gZm+Uz9z2mExg/LYpiVRWYlA8wOz6wn6gI56tGKF4XoMaZcFeM9R+1W3Y3zQnKtRl
         8oGw==
X-Gm-Message-State: AGi0PubDUzeGFwk91VKU6GVaFA2t82L8ZzlJMf0ZyqhV+ii19Gmjm67C
        biJA93rcvFnfWLzWIcym+mzERbgG
X-Google-Smtp-Source: APiQypJCkhH2XM1/ubVKAyDxWOfA3IngwHzom0h71tkIHqntDJ2mMvM8qR8AQp7vivYI0us7RPKyKg==
X-Received: by 2002:a65:6704:: with SMTP id u4mr459587pgf.263.1586291022346;
        Tue, 07 Apr 2020 13:23:42 -0700 (PDT)
Received: from localhost ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id u3sm15035874pfb.36.2020.04.07.13.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 13:23:41 -0700 (PDT)
From:   Matt Turner <mattst88@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Matt Turner <mattst88@gmail.com>
Subject: [PATCH nftables] build: Allow building from tarballs without yacc/lex
Date:   Tue,  7 Apr 2020 13:23:37 -0700
Message-Id: <20200407202337.63505-1-mattst88@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The generated files are included in the tarballs already, but
configure.ac was coded to fail if yacc/lex were not found regardless.

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index a04d94bc..3496e410 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,13 +29,13 @@ AC_PROG_SED
 AM_PROG_LEX
 AC_PROG_YACC
 
-if test -z "$ac_cv_prog_YACC"
+if test -z "$ac_cv_prog_YACC" -a ! -f "${srcdir}/src/parser_bison.c"
 then
         echo "*** Error: No suitable bison/yacc found. ***"
         echo "    Please install the 'bison' package."
         exit 1
 fi
-if test -z "$ac_cv_prog_LEX"
+if test -z "$ac_cv_prog_LEX" -a ! -f "${srcdir}/src/scanner.c"
 then
         echo "*** Error: No suitable flex/lex found. ***"
         echo "    Please install the 'flex' package."
-- 
2.24.1

