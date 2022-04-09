Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BE0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 12:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiDIM7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 08:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiDIM7M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 08:59:12 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D782455BC
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 05:57:04 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id z19so12735968qtw.2
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 05:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=7RPIHz2qKOuF67JDJ952LKg2Ge2u0RlRY9USX0iB12w=;
        b=JZIbQ+vnRoQQPmcRfpUGFkiDhou9VCU9m8C7aVc+PhMXO0PFvprC6d1fuofaEG4tcY
         bkiuu+IH59t711ulLNEkvBGX3bR2S/6kmz4O43GrWc1Yc+mXNqY96zGfVvjZ4G3g+QdY
         ie7pFvAPTaGZ+Fxz2T8eULaOP39EwluSsofV7Vbfy4Vw2ux7W9d+t6dCYz6mWxXtI1+l
         BAqW8BlxI9OaNVMlvRCZUdXYggRIL7w3WlJ98yvMV2oAaFjuaEyqKKKXVHDrL/YCSZyJ
         W+/kCMcsBe7eL+u8ZbZyfpAWrp+ohvH/3frE27zIr97oZKGtkJrkKUtIEUEoiQDHxjAy
         TjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=7RPIHz2qKOuF67JDJ952LKg2Ge2u0RlRY9USX0iB12w=;
        b=q7gyRHDHlG7zvvjwIrhnnF9G//CL7MeGMRRl+kciSfDBeoDbMQ49S35sFw05xrLoPR
         MLBsTw1VngSSPNcO9FjnA7+v1N1BK+Ic49UiYlfsiwC9VaUFyGuVG5DpOipe+SMbLr8W
         2qWVmD2dFHjyyTXMGQt2EDkBjyWfQkJMKrvBAAmNdFB0Nh893sEMlGwmCWet/wTI040X
         hVUtkzBLCw8K4o8x4Yl9C3VAwZuFVxqNyMwSA4A4mjtBPXCbfI7dkgPjUobAqDmvGZiN
         qYk726uzguHXe/y36tbxEGqEkmQ1v0irEA5L5rr4klQoqezzvl8lkaEz0cRdrBT6pJYy
         wWwQ==
X-Gm-Message-State: AOAM533i3WPnhNRNb5CG6uF/+k+6Lf3Ro/odrqs4KWWpO2z71YSBoCGb
        lZUzs3+KbW8OTxggJQzktOVQqblvetl3jw==
X-Google-Smtp-Source: ABdhPJyZb3BGHiGWv/4DsmOHZCYoCMbMPQyft2z7FirHeuRXzOgj4dKqvs2T/5ZDgS3ED8lY699AVw==
X-Received: by 2002:a05:622a:1a97:b0:2e0:62b2:4507 with SMTP id s23-20020a05622a1a9700b002e062b24507mr19903815qtc.328.1649509023788;
        Sat, 09 Apr 2022 05:57:03 -0700 (PDT)
Received: from fedora (bras-base-cmbypq1103w-grc-23-184-144-170-53.dsl.bell.ca. [184.144.170.53])
        by smtp.gmail.com with ESMTPSA id v7-20020a379307000000b0069c0a2afc55sm169749qkd.123.2022.04.09.05.57.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 05:57:03 -0700 (PDT)
Date:   Sat, 09 Apr 2022 08:57:02 -0400
From:   Martin Gignac <martin.gignac@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: Add meta time tests without 'meta' keyword
Message-ID: <6251829e.xNu4VrF13GQsRBbt%martin.gignac@gmail.com>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v1.0.2 of 'nft' fails on 'time < "2022-07-01 11:00:00"' but succeeds
when 'meta' is specified ('meta time < "2022-07-01 11:00:00"'). This
extends coverage by testing 'time' without 'meta'.

Signed-off-by: Martin Gignac <martin.gignac@gmail.com>
---
 tests/py/any/meta.t         |  2 ++
 tests/py/any/meta.t.payload | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index e3beea2e..12fabb79 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -218,6 +218,8 @@ meta hour "17:00:00" drop;ok;meta hour "17:00" drop
 meta hour "17:00:01" drop;ok
 meta hour "00:00" drop;ok
 meta hour "00:01" drop;ok
+time < "2022-07-01 11:00:00" accept;ok;meta time < "2022-07-01 11:00:00" accept
+time > "2022-07-01 11:00:00" accept;ok;meta time > "2022-07-01 11:00:00" accept
 
 meta time "meh";fail
 meta hour "24:00" drop;fail
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 15439062..16dc1211 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1058,3 +1058,17 @@ ip meta-test input
   [ meta load hour => reg 1 ]
   [ cmp eq reg 1 0x0001359c ]
   [ immediate reg 0 drop ]
+
+# time < "2022-07-01 11:00:00" accept
+ip test-ip4 input
+  [ meta load time => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp lt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ immediate reg 0 accept ]
+
+# time > "2022-07-01 11:00:00" accept
+ip test-ip4 input
+  [ meta load time => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ immediate reg 0 accept ]
-- 
2.35.1

