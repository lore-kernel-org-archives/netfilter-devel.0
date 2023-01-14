Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56278C3DA78
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjANDUa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjANDU2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 22:20:28 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455B588DEA
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 19:20:26 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s67so16195785pgs.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 19:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Iaq/aDT4Hq5B9c/FVD5MC0/6oJUqIYA9ppmw1YiQsKg=;
        b=DkiAfyKaN0b2S+wxquR11XpnbLuFCdF6g4cb0/CAkgbW2nQFOI1o3xW3dT4lcbNLID
         VI4wFUXuiVvMDsT7ev7pMiP8RCReaMqZ57RBlH5mY3lUIZhhJNN7JjxHiC4lKQZpHCmI
         R3jo7xS9KwFE67/yu9WawvLg/rcT3N3eI11MQQXLaiWzdiXm5P6vF9ADnvR5zERrSEt3
         pmXflYW19mAX0U13/ONcKXoiSIou8kwObfluzKqwGOPbz2OF4VM8OQ2arSjlNDjQy29w
         4hRX6mAOmEgBdGGJqz0Bazbg+tDfxpvMK+6i14G/qMs84tmOClttDM8L5c+e3NHaKnsG
         0fyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iaq/aDT4Hq5B9c/FVD5MC0/6oJUqIYA9ppmw1YiQsKg=;
        b=6XDzBFdbPwm8tJRTW3F16kNCwmj5yItV/vPW3k8SdeaO94bNWcVeSlCDNkwKfMjA1d
         M6Za90MQZG5KJoGxSlWowqaJSnQtkMWPNe84QG1RaSgGHKiDw4qRJZet3ctaDBDHfrZp
         97mV90H1VT8IkKUwzhdTgUlnWmd+trvMM6THqhNbWwlWND961RoVzbP5IlRf0FIlSNDl
         JbhgYIx8bLv1JygwkbUgoiWU/Ssy/5WtctPoWrwKSoebOm/dVo7LUSzp+XFEzfm17CUh
         tO1GhoIcRY+UIRdHm2A7xRC8gWYqbt3JNvZCOtMaISBrrVW6LZXF+h6bYL7f6suw7Jg1
         YHDw==
X-Gm-Message-State: AFqh2kr/8PyiQVo23m//GOEwYpxyE5XdcUWe9WMwKW7wTWkZBezP549R
        8GI+s3nCvD8R6wU6fk7hPq+P87CAguI=
X-Google-Smtp-Source: AMrXdXtFFI8eD+Tgd8B5wo34Kfd7mMuGnLPBUJzkS6eI2HI+b0NZDdF8sG50GHuzQRnoRuV13Uf6Rg==
X-Received: by 2002:aa7:850e:0:b0:583:39ca:82f3 with SMTP id v14-20020aa7850e000000b0058339ca82f3mr30550254pfn.18.1673666425677;
        Fri, 13 Jan 2023 19:20:25 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z67-20020a626546000000b005833f0e58b7sm14297270pfb.130.2023.01.13.19.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:20:25 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix doxygen obsolete option warning
Date:   Sat, 14 Jan 2023 14:20:21 +1100
Message-Id: <20230114032021.16582-1-duncan_roe@optusnet.com.au>
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
index 8f05a1d..7d7ed0a 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -26,4 +26,3 @@ GENERATE_MAN           = @GEN_MAN@
 GENERATE_HTML          = @GEN_HTML@
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
-DOT_TRANSPARENT        = YES
-- 
2.35.1

