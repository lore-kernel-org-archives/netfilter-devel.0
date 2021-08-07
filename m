Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5453C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 06:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD01B6101C
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 06:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhHGGfX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Aug 2021 02:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhHGGfX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Aug 2021 02:35:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4881BC0613CF
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Aug 2021 23:35:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b1-20020a17090a8001b029017700de3903so14237546pjn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Aug 2021 23:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ndnLNgTiG4SF4yBFFA9zXphxFlz1tsOntcLe0/MAyk0=;
        b=gf4n/JkMZPSg8ZzkVFrql7Yu+3XY3wgjCTMKLFZNS0oOuz27eBtu606FDvWOxaFARa
         qb4/GQq5GI7aoAJjwKROIwIz52gXeoLZUzowNgvXUerfYj8A6Xmy7iQ3bmjspNfTjnLx
         cbDdAR2pI79sNvsTVVzJB2sRxyAch7s6m+B3FqaCu8iBX72MMIm7FWnsn5JTFLy6cyo+
         Rjm7qgObL3PB4Av4aIOzwpsLMrL4HbyEqaCh3P3mEkVB20x+fWSwuX+4xCLSSK5qQyXo
         71JsCcYGsprtJ4j+/JG91MGo+9J/DWEAJDz0hMbFjzFrAkwkHt0j4bPLx/Ei1FG+VVIV
         p4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ndnLNgTiG4SF4yBFFA9zXphxFlz1tsOntcLe0/MAyk0=;
        b=VvGnaU+5rJvQgsYWhcmybr30IqlO4nX2oYT0sqEad0eRDtSl+7t4xXKjLIKCNH4xpd
         r+92h8p8y1N+Sc3NUuAX6BZMP+hYXIaDL+mCiRnOeapyY1GhYuHPSS+n6BN/9X8VFuBM
         W6AeJXdKDmDOR7vcXYcs8WSDhNYeHllzqchCN163gFI8PWWbx5OCsk5AYnPzyvmrdV3Q
         tEFsbndhO1WXqnio78ffyle8YJh7/8e6+Mtr0+ENiZR4xDLCs+nJbgvDVFo5705qtZIq
         IAUdSEHlAoVrjKyUzZG/JXOr8fkqHcwdKgjWnH5cYB+gkfKKESs3UCo+6SFgfFidUvQv
         cZwQ==
X-Gm-Message-State: AOAM532851acORoyo24ZP3buSoqq7kJ2/92oeoM7qdop3OBluG1MIfjf
        7qXvxdDHfzdOU+kb9yvzM2Z4hZfw+N8FNg==
X-Google-Smtp-Source: ABdhPJzi/8QsC8UbNHkEG1at6yhIONfaHLLvoXOzvUZT3tSGHzfLv6iA5nhlsyV3qx29ElxhuuAadg==
X-Received: by 2002:a17:90a:2942:: with SMTP id x2mr23888661pjf.95.1628318105897;
        Fri, 06 Aug 2021 23:35:05 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e7sm12779810pfe.124.2021.08.06.23.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 23:35:05 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] build: If doxygen is not available, be sure to report "doxygen: no" to ./configure
Date:   Sat,  7 Aug 2021 16:35:01 +1000
Message-Id: <20210807063501.1692-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also fix bogus "Doxygen not found ..." warning if --without-doxygen given

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Also fix bogus "Doxygen not found ..." warning if --without-doxygen given
 configure.ac | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index bdbee98..0fe754c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,8 +50,11 @@ AS_IF([test "x$with_doxygen" != xno], [
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
-	dnl Only run doxygen Makefile if doxygen installed
-	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+	AS_IF([test "x$with_doxygen" != xno], [
+		dnl Only run doxygen Makefile if doxygen installed
+		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+		with_doxygen=no
+	])
 ])
 AC_OUTPUT
 
-- 
2.17.5

