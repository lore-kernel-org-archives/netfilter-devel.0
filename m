Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872D2C432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 03:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC23604DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 03:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhH2Dqs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 23:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbhH2Dqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 23:46:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24E1C061756
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 20:45:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w8so9941120pgf.5
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 20:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/8/PYindYJFC6BqaXGsKMbAUMlTobCMzekHefDms10=;
        b=IHva7rohs/bthegZ671vIYwGtXpG7vuhdg/FHG3iPM84Kg93D2eSWgGcy81dZ073LR
         HGMaXSWd03Wjbkpgp8c1NruIdN7i6Y+ztxFYomDqgrCv2EPORuMBlqB9Y8x3ncFrSo0C
         r1obiYCgUZHhpoq0XuTPUEmkqUBzSIJhbMwrZegz05iYywtCOvbUyffbxgbuuXNgpz66
         i8IT8psTJVe3eFtkpMuClzrVNI0Zs/iOfB3FFowrL9jm/IzCSp9sRmd4ZRzRRLk7Da1X
         n/2wUxw+2oZZnNbCz6MMCe00SzdoDgDyb/Rt87+WaaGpaa12E+f9Uhamgriv5+gOV6BC
         2upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=V/8/PYindYJFC6BqaXGsKMbAUMlTobCMzekHefDms10=;
        b=q9rvnfmbbLMC2zwcQTR0uPEoT8ZYkXRIIpc4R/slgv4AbX91Ke12q2MPxx89kaynJJ
         BCOzNH12Hd3vx1KDCEv/sRB8iHcFSUnXH5znJKxCVN19ANiOXd1/dW5o+J8LNbkcHUJx
         XbAEd9ZK/uhoouXPUM+tmw6SV+ipzpYnhTC3vgh/lf7wmsu8zQgCaujUC1kxDQBfHWRX
         BHJzfR3ZrGzm+2DLPPUey2VIQO2kPIP+gsZXxwDyMpkjp/Bsc4g384cZwatuJ2fAJsai
         +AZhFEgKiLmAdrFu9HK+AD6tBaozOq4eigUS+B56X7NfKkCBW5AZ0KIL09DbZPl3Qld4
         mJcA==
X-Gm-Message-State: AOAM533tKmcUCH142VIAkD3rPOm+6hC4BtFecfK1zwUHVmpH0RkDyWEb
        FrsaQmfhTiutqriMZOnAcLfVdP5cQHA=
X-Google-Smtp-Source: ABdhPJxIid2TDpw928EmaX/B1Tvm4tWqkteRXDXhkFRvMCnZDT47dfkrEwYlzpQiCamSPf3wkdExKw==
X-Received: by 2002:a63:1351:: with SMTP id 17mr15015833pgt.173.1630208756160;
        Sat, 28 Aug 2021 20:45:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b17sm12196655pgl.61.2021.08.28.20.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 20:45:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] build: doc: Eliminate warning from ./autogen.sh
Date:   Sun, 29 Aug 2021 13:45:51 +1000
Message-Id: <20210829034551.16865-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828033508.15618-6-duncan_roe@optusnet.com.au>
References: <20210828033508.15618-6-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace shell function call with a list of sources

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 5235f78..738ebce 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -1,6 +1,14 @@
 if HAVE_DOXYGEN
 
-doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
+doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
+           $(top_srcdir)/src/nlmsg.c\
+           $(top_srcdir)/src/extra/checksum.c\
+           $(top_srcdir)/src/extra/ipv4.c\
+           $(top_srcdir)/src/extra/pktbuff.c\
+           $(top_srcdir)/src/extra/ipv6.c\
+           $(top_srcdir)/src/extra/tcp.c\
+           $(top_srcdir)/src/extra/udp.c\
+           $(top_srcdir)/src/extra/icmp.c
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
-- 
2.17.5

