Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B672C4320E
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E14560FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhH1DgT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhH1DgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:36:17 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2008CC061796
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3211379pjc.3
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mBb9vweGqolgGOloEEaVpVK8Jo1hYhpptbrlcwsSipk=;
        b=rSFrcvf13v86N133ZFdk9/sRkkdH9hPsEYvEMt1bgcqVOGXd0mlP0JbRMyTvhPzpRO
         emOY+KOSETZRz+NNXuRFUcaB2fY5RSJIppO5WuUyPEzLmxsfR2lj3VD5jaN+HVNiS04k
         LpVt4sYLszEcwvBBFbmV1Biuu4PhDLAlzsoxOthfVr1DDqM4tM/MJXKFyLc/rSz2F0Gl
         7o4XtmdtNTO9DO8LQ2bWBP4B9su+tPJ4gfiqCgsf3e6v6f0EvSwIV/Ryv7rkxzyaPkpq
         sbAkKsXK5AbSWWOIbhWy6KnJIxR9paK03CLzE2Uq4syjmN9Db5P6eg5joCvZA+OJFTgf
         xVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=mBb9vweGqolgGOloEEaVpVK8Jo1hYhpptbrlcwsSipk=;
        b=dPW90OUOUmtLCZ80CE4pVQd+gcSc2pJzhPA5IQ0xUnff+ngJZMNgxgvo43CKLMxbam
         ULDTdQdDm7sbTsstkcCD/I8elsUCtsKzkEQ2f5BUNz35/2fZJwEHEHIZQshDL/ZjOBh3
         lJ/CTgWVZDbFqXyTQgn8tS7oEQGng3+kmg3V0f5SzwJwZANcDIcVTKJXFosonLLgZBpe
         rgKYIJrp/L4nzUJlJWHKRLerPJG9kvLbX8NcIYYIF8zFi/WWw2WWKPrSx+f1+CeNTzyN
         fSbCiODZW796Bw49bc4Uk+Cwm06XTa1Dar/koOZPR9SJAWskV9gUctPjY+CoVp7BIYgl
         t3lg==
X-Gm-Message-State: AOAM533F2WNz0RgMxQWEKOV8JaRVOwkYeVHSam/IM+igTE2GJYrOtDRb
        Zb4DFmpcDkMnV0mab7ZUuP4=
X-Google-Smtp-Source: ABdhPJy0CL9cyid18NB1XKVTmY0b/fTU8X4lvrujSAu7mm6WkugDrJ0J8mFfYDVKWZcDsIYOLWG9Ag==
X-Received: by 2002:a17:90a:8549:: with SMTP id a9mr25861638pjw.98.1630121726742;
        Fri, 27 Aug 2021 20:35:26 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm8513021pgk.71.2021.08.27.20.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:35:26 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 6/6] build: doc: Eliminate warning from ./autogen.sh
Date:   Sat, 28 Aug 2021 13:35:08 +1000
Message-Id: <20210828033508.15618-6-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running autogen.sh gives the following output when it gets to
doxygen/Makefile.am:
  doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
  doxygen/Makefile.am:3: (probably a GNU make extension)

Since we are targetting GNU make, disable such warnings.

suggested_by: Jeremy Sowden <jeremy@azazel.net>

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a4fb629..cdd333a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 
-AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
+AM_INIT_AUTOMAKE([-Wall -Wno-portability foreign subdir-objects
 	tar-pax no-dist-gzip dist-bzip2 1.6])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
-- 
2.17.5

