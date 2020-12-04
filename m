Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435A6C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05732229CA
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgLDKt4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:49:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40232 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgLDKt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 05:49:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id a3so6586444wmb.5
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Dec 2020 02:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=521JmFWSsfV4yoUsqlHThwBpbCRgFyeKoj9A74C+nFY=;
        b=DpLiaP6kcOTqXaKK40Jd0odedo05LvXA4r3IDEpNhYTfkOaAT44+GU8TsCriueZmFE
         mdnSoyntLFAxPYEJNZ3tSvLFAM9FgKLOFXIYAcn6/1aJIAw1h7rXyN82wbhjrEWLf4fK
         06CWDHC2oT+cbtOX2V305cebCdsc6WProOr3MnHN7gJ3A8MlpiDo1yLXb4MBYI+FK5lQ
         /Kz2hbYN1Hfjq0Mro+De6zVIeHtL5kJTNQ7GgtkHh3vOxMXrUJrta7f0Pf1CFh4irtzC
         NzEIgkHUyF5qxh1ptV//xAWEtFkztpXVqaFDEBtLthUuE9O+JSvGbduANsSsJAhB8v5c
         Tttg==
X-Gm-Message-State: AOAM532jw17GQaj2ekASrwIu3wvJar89DkEytCBNrrQLk6BAB9u5NFHs
        GR7QRhGSr/E4t0FIS6sZ2dt7ZI+Mq4QQhw==
X-Google-Smtp-Source: ABdhPJxkExNpvh6Jkhlao6SR/2ewp/UGmTk+JGnXlo6l4p4+bOq3KvoEWuuM3CsSG+gl8wSbTDU3rQ==
X-Received: by 2002:a05:600c:208:: with SMTP id 8mr3548714wmi.146.1607078953858;
        Fri, 04 Dec 2020 02:49:13 -0800 (PST)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id w15sm3033853wrp.52.2020.12.04.02.49.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:49:12 -0800 (PST)
Subject: [conntrack-tools PATCH v2 1/2] .gitignore: add nano swap file
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Fri, 04 Dec 2020 11:49:11 +0100
Message-ID: <160707894303.12188.18393188272117372516.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ignore the nano swap file.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
v2: no changes

 .gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index f7a5fc7..d061ad7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,3 +13,5 @@ Makefile.in
 /config.*
 /configure
 /libtool
+
+*.swp

