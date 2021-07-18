Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB16C636C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 05:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB2C6101A
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 05:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhGRFNe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jul 2021 01:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhGRFNb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jul 2021 01:13:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCD3C061762
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 22:10:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p17so7740441plf.12
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 22:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Jdk+HGRNJzT70K0rHY0rHFJ7kWD3VizDp/MCijSKnU=;
        b=OJbxzRVyTuLUGinyxZ02ynS3i2ArbhXAsXs6Nv1jUT8UCXGhwE3dltG19frPaylMOs
         xyb8OXYQO3XZlYe52kr4LF/julKFJ1rgnBeoGcOT5WjmvIfnhMViMeBqeHZC2jsDEU3e
         6qe6XgG5P1ZPmnDebZmq7KZqQKKeM25+DloOwV415BcHhrtaCVKQuIHf/hU9i6GcAyoW
         IwQxwIyPKYDOIaHx1aVqMR51d7BoZzZR2LvDwu71WmsM1it3l3RBbXz7ZFCqEAi034Pl
         KCjiyvZT21e42wGsVf/xPvp/4wuSfRty6Bw1MvLJVYSGku9cL1tac1gOPn+3Jr5MZrmM
         fnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=6Jdk+HGRNJzT70K0rHY0rHFJ7kWD3VizDp/MCijSKnU=;
        b=g/Op0ko+RBJUpzPdbs46RonucrOAX01t5j/Tv92Z/Edl+cKu0/HznAdj2mmllFu8K1
         1R+FneJeXEMvE7Lb7lZUAAGxUuXxxxBi5+d0pNVeI4M5ZhNfiK6/E+/l8GXMZQU+evz4
         M7OlYp28vnUC9EsZ3EoVAciT1JFiWMKKziJKpJuDilvRFks/dp6X0rqhNq/9jtjiFsIl
         I84LCLKtv9oL4cYtPRa2VzqoX+boTxvJ+6eQ+c8DFXzLCdu5Om25o0iWXoz8kW74EZe2
         8qqxv5fIvD0Eoo5sEkft+4KlPUliHpzy06NB09HdKlWybzqQLQCXY9ReTLBlwvLN7MyU
         tYuQ==
X-Gm-Message-State: AOAM532H4ol5f9mhSVqseNjAfPGWKMjk5R9Z29nxz/ReEGoeMp0LU2Q6
        9Jm9sYexMrLvB7H+T8xTPnI=
X-Google-Smtp-Source: ABdhPJwSu+PA+MNcDiqz4qk5JtutLvu5f12zYw5OlHSDBrS1pnKQ+cRJNNgJz5MDXICNr8GCovZ9gg==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr18430600pjn.212.1626585032141;
        Sat, 17 Jul 2021 22:10:32 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y8sm15638038pfe.162.2021.07.17.22.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 22:10:31 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Stop users from accidentally using legacy linux_nfnetlink_queue.h
Date:   Sun, 18 Jul 2021 15:10:27 +1000
Message-Id: <20210718051027.25484-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user coded
  #include <libnetfilter_queue/libnetfilter_queue.h>
  #include <linux/netfilter/nfnetlink_queue.h>
then instead of nfnetlink_queue.h they would get linux_nfnetlink_queue.h.
Internally, this only affects libnetfilter_queue.c

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/libnetfilter_queue.h | 2 --
 src/libnetfilter_queue.c                        | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index a19122f..42a3a45 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -16,8 +16,6 @@
 #include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
 
-#include <libnetfilter_queue/linux_nfnetlink_queue.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ef3b211..899c765 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -32,6 +32,7 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/linux_nfnetlink_queue.h>
 #include "internal.h"
 
 /**
-- 
2.17.5

