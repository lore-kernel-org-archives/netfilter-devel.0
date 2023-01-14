Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87B9C3DA78
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 00:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjANA56 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 19:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjANA5w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 19:57:52 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650676084B
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 16:57:50 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e10so16061087pgc.9
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 16:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=iq8u7hNq1eub9oFYpXqU/qmRgTG/cmgXT5UqoK9/dns=;
        b=NhqEgUbbkdEUReFSn3aKIElqgfa0w1+Hkf8t4VxHLN/p/UvX8a3pn+CVT3+TlW21bJ
         /pD0Um+1sM2YQymiPU0sFWbc94+q8Lsr71wf2pLl7uhHsDcb3JMBLpK6Dklugbu26Xok
         J7W3IXd2V9vbgbpXFdG62lTKUOX9yGFVxmMPqGhnKiyXWdKOyarqtbAvf5cxkTDAd+bf
         6qm6XwXscDpXR09lDFo86duA/BCyM52Y1cIsu8IyvDJ5Mh6ZxG0teVM4yBzHxYmyoqNQ
         wzrog2so/pxCA27xpMT255EoH5xM/+evgxun5kXlE7ZrbydGppq3rQFRs/WjI7iA5pwe
         Eeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iq8u7hNq1eub9oFYpXqU/qmRgTG/cmgXT5UqoK9/dns=;
        b=mydz5AHTp94pZTFRMWQqOOHTRSzyes7Xlu/6rDrageT7cZOqRlRAY1X6PXYnTAAVqu
         2e3ddJyLH+jdsWyy3nYnYwIo+K40DO5YI2Rkv9hFnG40MBeLteOD9aq7mldoI/60dIcr
         9MbH4Uo12fmWtqGwu28z6+K6K7x67nykz2V8FU5+8mZfFSQy3mKWOapho2uQTRQQTeQB
         XKDtuvEoC2yEMds8tR+I2vO43beS+yNAbDXLHt+GmN1wChg7Z/qTOVdLOemr9nyrIP/a
         zKiw10m4M3dUCD01/xDP6THvXifrgtTiZkW1jiNGQAX2qqwC/nSfYpfU0iamde35Wklz
         1XyQ==
X-Gm-Message-State: AFqh2kqpGj4eFSAoatWqthKX/H5a360+uWZgK+fJ2ObfSgj7jhpu2qTp
        GCKR6VBHSbSeQ/ypvmu7AMyI6FE8Wxg=
X-Google-Smtp-Source: AMrXdXsKvAG7isNxXbtmSk16WswIi5U2KxEQzvBe0KPOQvL29IlvmkptLcY576WrVH+9aquCnFKEWQ==
X-Received: by 2002:a05:6a00:3247:b0:576:65f5:c60a with SMTP id bn7-20020a056a00324700b0057665f5c60amr70697992pfb.27.1673657869851;
        Fri, 13 Jan 2023 16:57:49 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id f13-20020aa7968d000000b0056b4c5dde61sm2307145pfk.98.2023.01.13.16.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 16:57:49 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] build: doc: Fix doxygen obsolete option warning
Date:   Sat, 14 Jan 2023 11:57:44 +1100
Message-Id: <20230114005744.16463-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

doxygen 1.9.5 complains about DOT_TRANSPARENT, removed.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/doxygen.cfg.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index b6c27dc..ff67c36 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -21,5 +21,4 @@ GENERATE_MAN           = @GEN_MAN@
 GENERATE_HTML          = @GEN_HTML@
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
-DOT_TRANSPARENT        = YES
 SEARCHENGINE           = NO
-- 
2.35.1

