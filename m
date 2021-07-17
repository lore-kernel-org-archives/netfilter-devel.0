Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC118C12002
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 02:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91103611AB
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 02:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhGQC5B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jul 2021 22:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhGQC4y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jul 2021 22:56:54 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06261C06175F
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 19:53:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u126so2742823pfb.8
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 19:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+XlF+TAiiAIAA2BfRLALWWKZehZFYCYYxEhTVfGDdA0=;
        b=UCamq8OX2i++DvgYliDwIfhF7jSBkvf9O9RUAIXiSlj7B+d/PSmNzm8Zx+hM66PqOh
         qhHFaIVtadcQWj6O4P8lzHH7FCSW0q3Hd08lZAXWvIpgMW5N/byVBHDrr4KQhoK3nqla
         BhTfNCFKgls9bFm65DwnF2Ysug1cF7707d64jOuB5+tCfISJ2S1PJIm/PKJeQoff+w3z
         lfr8MpjqQSjnOnU4oMgLnrn4BSXID9UpdWE85JgQFCMEu493V22d7B81gZQFzqS4qr+o
         vYXRH+cjYA8qShEo5mBr0egfVr82cZ9cf9/VIp2Y0XV6qcZXhq62BdLtCzpI6xOFJOvW
         bncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+XlF+TAiiAIAA2BfRLALWWKZehZFYCYYxEhTVfGDdA0=;
        b=cxSmszbyq6YCCeRkRfU3rArxYkHkkgd45lTzDIe4t62d5UN5yN2jk448YC7YldECwC
         m6CGu7ObS3RVy+7w+uH+z/WcQ4a2aFbMuWGk5jlNfjeWbyOTXLy6V386qBFj+ZHtwnOx
         KJr6tmx28mUX0c02lhl6FKNw6tllUVPz6kH7cfbdGHkM3qXZdlqPQewtc7oY/B5fz4xc
         zBsk3KHZfjJEN12Vg7/mdKNlNmShtJdkKMlfjEAy2lan5VfGKFTF/XPPbkOFFIn9Gyos
         ynPz+3esRCR7OdL63EkcZKoiBJnbmYShzMEzjSnLnKJpRluFX4uEgRLRCGBcdC+K5KhV
         pcBA==
X-Gm-Message-State: AOAM530NTmcGbccFbaDui8n411frpdXaSVelo6qqDLkC5DlT7q6jhwTc
        is0ASFtbrQU8EOjimrQsaV0=
X-Google-Smtp-Source: ABdhPJyF+ZMo+iOoWfriA16T5pfISrmkjCajm6kUq9+ISg2fG9VUcZ93eBFFfK6JZDBVY9pKMFny3g==
X-Received: by 2002:a63:d711:: with SMTP id d17mr13046194pgg.268.1626490437656;
        Fri, 16 Jul 2021 19:53:57 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id j19sm12514736pgm.44.2021.07.16.19.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 19:53:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 1/1] src: doc: supply missing SYNOPSIS in pktbuff man pages
Date:   Sat, 17 Jul 2021 12:53:50 +1000
Message-Id: <20210717025350.24040-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210629093837.GA23185@salvia>
References: <20210629093837.GA23185@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Synopsis only has required headers, since doxygen already output the function
summary. HTML only has 2 small changes for better man page readability:
the Synopsis lines are manonly (had to do that to get SYNOPSIS over to cc 1).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/pktbuff.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 9bdc6bd..8e9a8c7 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -23,8 +23,21 @@
 /**
  * \defgroup pktbuff User-space network packet buffer
  *
- * This library provides the user-space network packet buffer. This abstraction
- * is strongly inspired by Linux kernel network buffer, the so-called sk_buff.
+ * These functions provide the user-space network packet buffer.
+ * This abstraction is strongly inspired by Linux kernel network buffer,
+ * the so-called sk_buff.
+ *
+ * \manonly
+.RE
+.RS -7
+.nf
+\fBSYNOPSIS
+.RE
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/socket.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
@@ -150,8 +163,20 @@ void pktb_free(struct pkt_buff *pktb)
  * \n
  * 1. Functions to get values of members of opaque __struct pktbuff__, described
  * below
- * \n
+ *
  * 2. Internal functions, described in Module __Internal functions__
+ *
+ * \manonly
+.RE
+.RS -7
+.nf
+\fBSYNOPSIS
+.RE
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/socket.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
@@ -159,11 +184,23 @@ void pktb_free(struct pkt_buff *pktb)
 /**
  * \defgroup uselessfns Internal functions
  *
- * \warning Do not use these functions. Instead, always use the mangle
+ * Do not use these functions. Instead, always use the mangle
  * function appropriate to the level at which you are working.
  * \n
  * pktb_mangle() uses all the below functions except _pktb_pull_, which is not
  * used by anything.
+ *
+ * \manonly
+.RE
+.RS -7
+.nf
+\fBSYNOPSIS
+.RE
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/socket.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
-- 
2.17.5

