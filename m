Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FA3C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 18:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B81B2081C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 18:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRq/dp85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfECStP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 14:49:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34788 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfECStO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 14:49:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id b3so3317989pfd.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2019 11:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=xiT0+Ea8hsNB4aP6B/c1OzyBb44ZXhCttPJa06QdkmM=;
        b=YRq/dp85TSSV84Yvigi5qxQYDElMWVTwxsU5zyzhZwVN3M9MVNnCIMsuBegS/+3wb5
         ImbVbY0P7mkL4Ii3nYMZDpJWWLUKNDE4PMvXw04S/nkcEHw4iWZoZWZlVIhklUBzsPOI
         +Fi78uarGj0mA4wJ8G8+2tA3zDYMcAIrHXTx7XinKOMkmSPCLtGuJOc2/YtMNBvSf883
         GO392qAGhjCHbExd7DwBZj3jxw/XJVCGlO0qtyxlhY/mzQLg6GN7865b70cxIkDx2Eaz
         MS9d24n6Jfp9Fbdn94HFjBE4y3648cq0+BR49zoEIh4DafdKliYAEo21bSU3N0cLW90Y
         8hZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=xiT0+Ea8hsNB4aP6B/c1OzyBb44ZXhCttPJa06QdkmM=;
        b=H4XYar8Ep3Ye0hnE0/8MFmWKYSfy866KIgU2OAsmAeyjzYyFRulRrbDyh8OQPTFKwf
         /yoyo1C4A2hOs9SFPyY7mrsCUM5tTq/z1TQH+LbpT1yHM76FbQYJAeZ3vj7YHz3LLh1I
         VRoLZXA7DF9xDerDM2OqXGUg3Rr4shxoJr+PDQPPCiG0+1jtzLqqZs+qmTOSp/M+kBsL
         +9DmS9SkacaUOTAKLc/RhAvTscFZZaULxIbNTUTAE30nLg6Uc1zAVxZ0ROIUKUkrXQ4L
         hYd70AD4HqGURgp82BfLA6qBrZukg6HkjipXN5aaf8AaP0OUnThOeAseELkE0gqBfg97
         Cy8A==
X-Gm-Message-State: APjAAAWO/CktgxwjZQVKaR5XpnAbBOfXHPZeLPBkMkV9DSWdTix3sh4E
        +JhxpDFyc+k2PJw2iG8WTz4b9zvv5R8=
X-Google-Smtp-Source: APXvYqykAAW+NkCY1dA8oXWl7AVaTBIlI4ee0pQEG+crcIYqOK38U72M8Je7dktYr4pCwWeclLI0DA==
X-Received: by 2002:a62:5ec4:: with SMTP id s187mr9178112pfb.185.1556909353236;
        Fri, 03 May 2019 11:49:13 -0700 (PDT)
Received: from mangix-pc.lan (76-14-106-140.rk.wavecable.com. [76.14.106.140])
        by smtp.gmail.com with ESMTPSA id 132sm3837980pfw.87.2019.05.03.11.49.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 11:49:12 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] gmputil.h: Add missing header for va_list
Date:   Fri,  3 May 2019 11:49:11 -0700
Message-Id: <20190503184911.8394-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise it errors with unknown type name when using uClibc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 include/gmputil.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/gmputil.h b/include/gmputil.h
index 73959c1..ad63d67 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -7,6 +7,7 @@
 #include <gmp.h>
 #else
 #include <mini-gmp.h>
+#include <stdarg.h>
 #include <stdio.h>
 /* mini-gmp doesn't come with gmp_vfprintf, so we use our own minimal variant */
 extern int mpz_vfprintf(FILE *fp, const char *format, va_list args);
-- 
2.17.1

