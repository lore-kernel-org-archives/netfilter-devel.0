Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97CDC4167B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 22:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjKLWyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 17:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjKLWyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 17:54:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C654E211D
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:53:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc30bf9e22so28748895ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699829637; x=1700434437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIBMX11eFHU/lkR232lbGCsNPtpBBpB6BIlIqAJau5Y=;
        b=HFpGE5/SBSERWnhaaxPz7V6tnO8NUXdEuHcGp2UiI58CM68uMIAh3I2ACUeYUsvEcX
         DxWk7gKhy8bLPS+T6ppp8QhZUpUmjpV54lkI2pi9o+7IxolBzsMLmGmrivhqGn0LA6Q9
         ysadSbj3ZDN8wEZy1Yya9Yn3LWL/7S0HWjAIMj6oaG0mg8dSseMOOlCmsFyOcmoRKDqa
         9jizv+L2E1XbkvKgzvju5ssdRI/W+AGn3TBXhROw23aOwj4laCrIyHgANamGe1I4+gwj
         eOFFzxRbHOSGqsJB1GYzAsMCxWmFfs47p6bm3YGCZy3LvJ5JxhVPNirjPwb7U3+s0w1x
         JD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699829637; x=1700434437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uIBMX11eFHU/lkR232lbGCsNPtpBBpB6BIlIqAJau5Y=;
        b=KYAaSIi7G1ZqbRxRnFTks6dqDuZvRXkk7JZvUUhFSqh1nXQTp/4DCfp8vzLoA+KSU9
         2ZYgZy2qylWp/anUOGWdlfUYl6hOnT7mKibbK17PwJAShKvW709eJqSKbsfpBjzSK3Uk
         kg+BN7rli4Q7wBGFKbhRMbE1ffYGh9lCXVy0/MrrfULGdqsjhl6aYF6O7iowUGQQNitC
         jUW39b4vcMn02YbSST7NsbDP8Q2QHR54Mlmgu/1m/JG06O/+hXFfPtO2KiVHv5jmt8f8
         nD0OMFnFsdiZuGtx0m8+PFqDIY+qXZUU/rBuBD/gMQv1x+y5YJTCjGYjIzNbthhRNkz8
         mIrw==
X-Gm-Message-State: AOJu0YyW0/AOnCJd+99SfNmMXu+PrODM9Vq6619IslL1qRVgzlAd/3Bw
        R3NrNRpqHBy8/v1HWmvyT0JsZXyxkpo=
X-Google-Smtp-Source: AGHT+IF5uoG0aqGARBCMZie0yQAsVT54EXH4R3GTOK03Yd4XvbyX5mc7y76tnIOlSeHZGPuImc6NxA==
X-Received: by 2002:a17:902:ecd2:b0:1bd:e258:a256 with SMTP id a18-20020a170902ecd200b001bde258a256mr7979157plh.32.1699829637223;
        Sun, 12 Nov 2023 14:53:57 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b001b8a3e2c241sm3077734plb.14.2023.11.12.14.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Nov 2023 14:53:56 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] Remove libnfnetlink from the build
Date:   Mon, 13 Nov 2023 09:53:50 +1100
Message-Id: <20231112225350.4134-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231112225350.4134-1-duncan_roe@optusnet.com.au>
References: <20231112225350.4134-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Programs using old-interface functions must build with -lnfnetlink.
Programs using libmnl-based functions no longer show libnfnetlink in ldd.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Make_global.am           | 2 +-
 configure.ac             | 1 -
 libnetfilter_queue.pc.in | 1 -
 src/Makefile.am          | 2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 91da5da..4d8a58e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 7359fba..ba7b15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,7 +42,6 @@ case "$host" in
 esac
 
 dnl Dependencies
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
diff --git a/libnetfilter_queue.pc.in b/libnetfilter_queue.pc.in
index 9c6c2c4..962c686 100644
--- a/libnetfilter_queue.pc.in
+++ b/libnetfilter_queue.pc.in
@@ -12,5 +12,4 @@ Version: @VERSION@
 Requires: libnfnetlink
 Conflicts:
 Libs: -L${libdir} -lnetfilter_queue
-Libs.private: @LIBNFNETLINK_LIBS@
 Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
index 079853e..aa0c3a9 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -38,4 +38,4 @@ libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				extra/pktbuff.c		\
 				extra/udp.c
 
-libnetfilter_queue_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_queue_la_LIBADD  = ${LIBMNL_LIBS}
-- 
2.35.8

