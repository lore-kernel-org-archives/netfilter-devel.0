Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B819C07E95
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 06:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A2E5613BA
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 06:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGDGgi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Jul 2021 02:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGDGgh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jul 2021 02:36:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89876C061762
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Jul 2021 23:34:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g24so9468134pji.4
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Jul 2021 23:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CF8TZD0EKNuMc76AceJk3YitsNRd1wfNzkQBzgT43HQ=;
        b=P2HDR/M/0P9CeYXHdXhdhZxp/uK5ni592eWy30sr6ETLha2A+8MxKT7OMXAFuoFzj+
         unq/UVczTgygkSRcyu+dtT+bzDoPnwiPYLZNY5aDJmvIMxpHSh7E7rGckgcZiEXe1G7s
         uwOP1WUAFKZk1Yw4+KrYhWR8NhmXJ7Eae7cIWa/VcnZm9UHIZu6FuJLBYCKA+GgVL4ha
         BDo2PdbbtM3a7eXmgOmRY7jqOHzYjUB7FltpWfsgYYCjKUmy+r0+bom1WxZGMKHs1GPI
         0TJ8vwMUrofRO8qcMJr4E4lU2DaUGrPJNP0vjG6cPI08xLBUTF8KwtZ6t7FD9nompbaf
         TusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=CF8TZD0EKNuMc76AceJk3YitsNRd1wfNzkQBzgT43HQ=;
        b=KuSe1WPgOqSE9KSHKCVte62lWhk3mt8rbas0wjHEWJbPt45pv1Vru2MG2Vgdod4EvC
         dVGYA2Wm80W7M0vrv9jzA13p3hB8g1Er7EhJ4L+phWwxILpvS7cLmDNLU/0F20TB5I2b
         1G0fcErh21iEXieqFwy23hpfQ1TUP51rsf714c6RCteFXwM4rn/Wk4GoeHqRIXB5tlmn
         kCZGPbp1ssa9bxwC/APavAOGAolb1tIGioG8TamRIISyYLEHZTcDeGZHfY6d5S/CFide
         9KvLo5EbG2W/xASOQk8ActMa59W/t73We3uztC/02esMQQD0sh1cfzKwg8LVEf+AJIp5
         7jXw==
X-Gm-Message-State: AOAM532i6Xsg5o2KCssfkA2dEB8lQwJ3BcqoUf/I4PjKNnCSpNEMUi6Z
        7+2c5qDNuaA8w09MJjlhBJ8=
X-Google-Smtp-Source: ABdhPJzm0Ro1UMG5aUj2l76ucb4QpZEfVKYsqwBDK6z7exOnUkUFAht1YD6NH9CcGcsamvZ8/wnZ4g==
X-Received: by 2002:a17:902:6b82:b029:120:3404:ce99 with SMTP id p2-20020a1709026b82b02901203404ce99mr6963796plk.49.1625380442000;
        Sat, 03 Jul 2021 23:34:02 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id a23sm8120267pff.43.2021.07.03.23.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 23:34:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] build: get `make distcheck` to pass again
Date:   Sun,  4 Jul 2021 16:33:57 +1000
Message-Id: <20210704063357.8588-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 4694f7230195 introduced nfnetlink_hook.h but didn't update the
automake system to take account of the new file.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/linux/netfilter/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
index 04c9ab80..22f66a7e 100644
--- a/include/linux/netfilter/Makefile.am
+++ b/include/linux/netfilter/Makefile.am
@@ -6,4 +6,5 @@ noinst_HEADERS = 	nf_conntrack_common.h		\
 			nf_tables_compat.h		\
 			nf_synproxy.h			\
 			nfnetlink_osf.h			\
+			nfnetlink_hook.h		\
 			nfnetlink.h
-- 
2.17.5

