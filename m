Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D90BC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241437AbiCRXBJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Mar 2022 19:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbiCRXBI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Mar 2022 19:01:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2AB2F24E8
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2022 15:59:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2e5b04a061cso69097567b3.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2022 15:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f9XqNuMtAJq6peRXnBYbULVZWg52SSEUatTaPuvImmA=;
        b=oAt92nlHF4fZtvodroicLi8vNNWeldPUL72a+VPigUzfvXav6C7T++brIVWU1tTYLh
         wWA3yVLiQmc4Gd//Bs/hZviFiQCCcNCUQhWLkLY9egxQjioI7GnGHEWgBrTWHSGwJUv1
         pYK1UDCjbVCD16tkvWXQmrZwhErYHOOxFh5Gl7l5wUWRXQdkbtfOKune9l9fU6+yxplr
         vdqUc/QNzWocW3zYnDNHjBaS+oJVWrKeSV4zcXb6hFQ/h2irlqrqWJG/vALITjFeZvIS
         ET4j08VP+UIt/Yy5tmkU4QeUWkcf0I6GLorwS8jt02/CNVydLpImtn0FbH6XV3kKynzp
         sPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f9XqNuMtAJq6peRXnBYbULVZWg52SSEUatTaPuvImmA=;
        b=HXIpE9weQnoj+5PA5cCfjCLRhfEj2f1eWUgzT5NJ2kvDWR5Goy1OSgmEVzxXKf1jRZ
         616n7CuUbGIrJwt1gRfGlCaVPm1pI8WPsHYf0e0QEFOKbEgHr57PR7yj/jB1PferFzq3
         FSCvvpUs+R9ElWvS3I2I/1Mh0Zmbvelv0mpgSKjfAIp5XovRmx/RfRhunPIsXqvAH4po
         dANMDPC/DwZL3u0X1oLINCRDRfh0KHDyfovmbd9QqB5nCxGkwj6i+DGi79bH9xXSstYd
         axqLPBAFW+lDjCinu2ZnEf7H+H7P4FD6YabSLAn5gRXk0PoMLgXKjX1cTsDnv+typMeL
         0QWw==
X-Gm-Message-State: AOAM533S5EQk57Hwp2lzY5wZQgIGJQ1rODkIAYPeYYLESfV+YvPEyLHg
        ATo7NW03pPx6V66FNHaMQqI+RvNVeCviZKWtKOUBxgZvNMkkuR9K3NBpm0BmmF+hWlXD6D7wM3m
        LTV8OZzgHkuVRnYLHKkNdnxEfH4jk/vy4gj01kw6k8AKcZbS6VkFJE/ZzOEQEEJAgtq7eZ99hMW
        4gWxYMkxIzWA==
X-Google-Smtp-Source: ABdhPJyk8beqs/ckanB7Cap5KNckrc6i09Tsi0iCm9tr6FJd/GHYmSoUzyYDj9+Wf2tzekEATQ1OYpacksNL99HoAA==
X-Received: from rkolchmeyer.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:7f04])
 (user=rkolchmeyer job=sendgmr) by 2002:a25:2e08:0:b0:628:b22e:1e95 with SMTP
 id u8-20020a252e08000000b00628b22e1e95mr12525708ybu.281.1647644388184; Fri,
 18 Mar 2022 15:59:48 -0700 (PDT)
Date:   Fri, 18 Mar 2022 15:58:54 -0700
Message-Id: <20220318225854.619325-1-rkolchmeyer@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] ebtables: fix the 'static' build target
From:   Robert Kolchmeyer <rkolchmeyer@google.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Kolchmeyer <rkolchmeyer@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, `make static` results in the following error:

  undefined reference to `main'

I took a guess at what 'static' is supposed to produce, and thought it
would make sense to use the main definition from ebtables-standalone.c.

Also, producing 'static' by linking against a libebtc.a results in a
non-functional program (immediate segmentation fault). This is because
the initialization functions defined in libebtc.a aren't linked into
the result program. I ran into issues trying to use the --whole-archive
linker option with libtool, so I figured linking in the libebtc object
files directly was the simplest approach.

Signed-off-by: Robert Kolchmeyer <rkolchmeyer@google.com>
---
 Makefile.am | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 6181003..b246064 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -50,9 +50,8 @@ ebtables_legacy_LDADD = libebtc.la
 ebtablesd_LDADD = libebtc.la
 ebtables_legacy_restore_SOURCES = ebtables-restore.c
 ebtables_legacy_restore_LDADD = libebtc.la
-static_SOURCES = ebtables.c
+static_SOURCES = ebtables-standalone.c $(libebtc_la_SOURCES)
 static_LDFLAGS = -static
-static_LDADD = libebtc.la
 examples_ulog_test_ulog_SOURCES = examples/ulog/test_ulog.c getethertype.c
 
 daemon: ebtablesd ebtablesu
-- 
2.35.1.894.gb6a874cedc-goog

