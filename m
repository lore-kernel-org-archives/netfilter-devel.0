Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89248C432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 03:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64333604DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 03:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhH2Dw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 23:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbhH2DwE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 23:52:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F32AC0617AE
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 20:50:57 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id r13so8951396pff.7
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 20:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9qi40+dsDoiwsT+rzgY/iZ0y+F3GfHFN7hp5hIsN/kY=;
        b=DVnSktM1fLOwDCrV+H5kDTfw+Ko2/wPuK7dsQAH6XVimuMDEF91aUm/1sOPoDuHNp5
         kX6ItDk/HkkYxbHHp3mZ8clUXPxBDbpSlFZ9h7NUIg/m+VxosGad9e1vlRBLCESoQAi8
         dC1matVL+rdMuCLcajp1ojYbCR3dqAg/XUlxUnbkamV6qdwUkn6DvVPjgBvjvXdKHUDx
         k4zskY1LtTh1eay6pL7GUrEbVSeZdBqcGMT29KMBd1veARl5HYekXjgJRXOxx9q+p9dh
         ITjY2sQjdX2xnc0OLuFQS9kKgOoeNCMM+n0g+uf51k7+/SUENzCjejjxf57/3mtRTpd7
         CtWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=9qi40+dsDoiwsT+rzgY/iZ0y+F3GfHFN7hp5hIsN/kY=;
        b=iWfjY+HAVjCrgATDUnw+5iLt715yH/VkF0+kg0JEAKvj6Q+go+cYdYpfFwRzjrAAR5
         gwgw6rKG8YitNqEI7dFrb0yNM4TIfwxHzNVTXPCmdEdGKv4rHC28Xequ7cDVGngaysnU
         DlZLsZpW6RIs7Xj469PEhVPDvQP2xvRErgcwTEMxswoIaD9T6/zcIzJWpldL5//h2mEx
         IDnttlR0P5wBkF84EZjI4gksPFuoewTxTLG1RKnJnzGhtL5ZOgbXc/mq3oJaIYt9+e88
         33BbBTBuvgEdvljwgLAstDrtJamQrVCXqtFtYgOwA1EI3uMa+uudWuZYt8JrH9CWx4Gg
         SiLQ==
X-Gm-Message-State: AOAM533LTdspa85vspoOKj70bMXbPCB+Y+3JkvbH1PbYFSZat6nMbn6+
        tyEMQB8ELRUx0arkswW0GCOtEItOBNk=
X-Google-Smtp-Source: ABdhPJyM8v2SjlbFVMyBzv/i2/TyYOtG495eLsgPpoW/bq3ZyA9DuJhtlsddxbeeXasarZsWnT/kkw==
X-Received: by 2002:a65:67d6:: with SMTP id b22mr15046521pgs.430.1630209056542;
        Sat, 28 Aug 2021 20:50:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id z131sm10754250pfc.159.2021.08.28.20.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 20:50:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Be sure to rerun doxygen after ./configure
Date:   Sun, 29 Aug 2021 13:50:51 +1000
Message-Id: <20210829035051.16916-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

doxygen/Makefile was erroneously depending on Makefile.am when it should have
depended on itself.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 738ebce..c6eeed7 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -10,7 +10,7 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/extra/udp.c\
            $(top_srcdir)/src/extra/icmp.c
 
-doxyfile.stamp: $(doc_srcs) Makefile.am
+doxyfile.stamp: $(doc_srcs) Makefile
 	rm -rf html man
 	doxygen doxygen.cfg >/dev/null
 
-- 
2.17.5

