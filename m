Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB11C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 06:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F6761058
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 06:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhHGGa5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Aug 2021 02:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhHGGa4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Aug 2021 02:30:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380BEC0613CF
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Aug 2021 23:30:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b1-20020a17090a8001b029017700de3903so14230485pjn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Aug 2021 23:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+DadaYlZOjSA+i7kHRkHktRK2JjsWsi7C82o2Ydi0w=;
        b=KpStY3EF70HwW3GJLe6B8m/EJtKg6sOqteyn+/QzU6CkWe+jY15NPUcpbTGHmA+Noh
         lDXrchg10Ry5Xe6HHmRKC2EsF6fF5amwzH9zH9tYmSZiRNOhS4vzNFg1KuZVSlvuUSzV
         338qUrLrwZaugLiuM8eTgftupLgaoNCk+UUyivICA1Hu8Olp65psoi3Rf2m16cSICgdb
         tip9UcH/QyqeQoDw85Am+e3fqu/bqkGXeRneBOHVzRtUabMGBGXqzrs6v2U7uhCl4cin
         cVc3+NbTG0qV4uLEL11u+9pWnr9oBJMmE72D9sH52xMiG/XtTGcGP4yMj/UWa82tbACN
         mIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=s+DadaYlZOjSA+i7kHRkHktRK2JjsWsi7C82o2Ydi0w=;
        b=l7/pRXNgQv1HxALotZ19vP4izRc8PSh0uEyktzpYplGPfPmMpR4HNMzjdKX8cCbUUg
         yIQj18NDBi2wz1erawHyXCAiJr7IWlE5DlFharzpFEndDDX/cVScZSW8ChMgo9qVZXkY
         MBG9p1agISkI/M6waVd9JfadOF+TTA3WySRg0g2azLZfe7APVLPwHtJsYNTaqYMuS7YL
         4lKEReASTLCnIUERqrJEF8VCzUhoNC06jSsvU7XQLOqeaoBrwE6vA66qnC19YX9xMRcR
         EB3hSH+H4Wnlpfi18aPsTDWrY40R7DeyOr+3KEVTsm/QuDAIj2nhFnehFhqeFyxOkdIG
         KYbw==
X-Gm-Message-State: AOAM53032pUBWaDmnX2uPrHVW4OwcesvQzUSHVA4q84Z+cFXbhETVgiD
        rezMzrAUG3JWGjmdZfdXm+g=
X-Google-Smtp-Source: ABdhPJw2eytbIbcitPDIi6LPy1zicAVhkFY+4rFJZQIE5OZmXyinQgMl0rHLa3D2K+RxlBgxxYtp6w==
X-Received: by 2002:a63:5509:: with SMTP id j9mr104783pgb.329.1628317838836;
        Fri, 06 Aug 2021 23:30:38 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id t1sm14800768pgr.65.2021.08.06.23.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 23:30:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] build: If doxygen is not available, be sure to report "doxygen: no" to ./configure
Date:   Sat,  7 Aug 2021 16:30:34 +1000
Message-Id: <20210807063034.1624-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also fix bogus "Doxygen not found ..." warning if --without-doxygen given

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index a06ae6a..3d1b821 100644
--- a/configure.ac
+++ b/configure.ac
@@ -43,8 +43,11 @@ AS_IF([test "x$with_doxygen" != xno], [
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
-	dnl Only run doxygen Makefile if doxygen installed
-	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+	AS_IF([test "x$with_doxygen" != xno], [
+		dnl Only run doxygen Makefile if doxygen installed
+		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+		with_doxygen=no
+	])
 ])
 AC_OUTPUT
 
-- 
2.17.5

