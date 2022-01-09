Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A858C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiAIDRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiAIDRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:17:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179B2C06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:17:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso16611559pjm.4
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZ54CKW5/dEoDinWY4lB+MBmE8rkWxnulvl4Q8K01N4=;
        b=J08ZbUuPdivIayic5Ddj8cRlZD2EqAKsoTQCnEPZvF1o7VOf2dAWW8EL1Yqx1mrGLX
         a082m2gA95exvU2lb+7bSopfJFi0nWFUBKme/YC9LWa17HoP3earzDRf6jlxrBoWFBQq
         BoxlzVP5fJzVhsYd01iRsQdJIuKhuPT9u/ead3wJSic3wniFI4Cf5AcFpW5gn7z8alBr
         sw98QxtIotstH0ps7IEuZq/SfrjT3AsqTwLoRVBWUfoQCDIsMxGWFqiPPsiAMmEi7KXB
         bylY5ZHebLogR9h4pHl51qSDKlyQqbNmNNeTaIJeH4DVejL4eL613NWEqKvi14LqwA86
         AlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=pZ54CKW5/dEoDinWY4lB+MBmE8rkWxnulvl4Q8K01N4=;
        b=t89xk1Z4ARCFqyE0SsFrf/VThFgOO0wPHJZ0t6dJwIZFxl9wzaT3GZq6xmrxNYmwA9
         BbH32Z951F5mpzO7Lgq+LmNB/CDwaD+CukMiTReWm5WHYHcrcD9ourje2FZMTKTbjPen
         pRkqdC8tIdK8UYr1xYngHpykMIxj2eff8ieKOUV002zHbs8UsYgYrfEid8EDLbhM/YNo
         /g3FgPcKZjcgCO2OmlZV0sal5i54PoujUdINcE5HucE39m5WhGHEMB38KvAorn7iaiaC
         576zshfMNy+bwiIGWccKtNnxIAxLhpX8I+3OgahYwOnLlimSYq0ix5XSPDVl89tp4NaQ
         O5ew==
X-Gm-Message-State: AOAM530N33TU5DdAo9zuPA3nhtnoB6c24E2kO6mkT3mP8nMK/V0cuDGB
        0TIMeRPjVHgdUrVNdxHrxGx2EhuSV8g=
X-Google-Smtp-Source: ABdhPJwzfHuFzvB3aoabKiih0c8sVgFQl7mobXUYrgjgvX85X6sFBpgI6B+moU4PRV+ek3+9C9E+og==
X-Received: by 2002:a17:902:b094:b0:14a:654:8c82 with SMTP id p20-20020a170902b09400b0014a06548c82mr9656645plr.15.1641698222641;
        Sat, 08 Jan 2022 19:17:02 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:17:02 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 2/5] src: Avoid compiler warning
Date:   Sun,  9 Jan 2022 14:16:50 +1100
Message-Id: <20220109031653.23835-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The warning said to add '#include <linux/netfilter/nfnetlink_queue.h>' before
'#include <libnetfilter_queue/libnetfilter_queue.h>' but it turns out we don't
need libnetfilter_queue.h

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v3: New patch
 src/extra/callback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/extra/callback.c b/src/extra/callback.c
index 2d67848..057d55a 100644
--- a/src/extra/callback.c
+++ b/src/extra/callback.c
@@ -12,7 +12,6 @@
 #include <libmnl/libmnl.h>
 #include <linux/netlink.h>
 #include <libnetfilter_queue/callback.h>
-#include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
 
 /* ---------------------------------------------------------------------- */
-- 
2.17.5

