Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF67DC432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83AA60F5B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhH1DgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1DgM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:36:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCDC0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:22 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m4so5265707pll.0
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/Hvz2y/9yGlffyGt+XTnmqXlX/CDQpwKYs2JIVv1H8=;
        b=R2AkFG7IWV3v2SN2WuteQxlIPC/zQD85rnqEMG3fzPFK21PDbyhCQrqtNS/bwQrbmb
         izq9BE9Dnoa7xbEeCZM//+r94dXQigv4Vjp2CZJE4Dk0zrbmRqGJ8sUUcNXEueu5a8BN
         CG0VBFV/UPqlmV/aX64IXjE+EYMtLJiCXq5d3Pi4ERV5BK+/gRiAWatDK0kcXcOc7ujY
         amonRdnbRK2DoSDfS5LFkTKoVabuzomaL9sUfBRs1wLYEPEvXgl4l68MJY9uYWdcNu5q
         4TAqu8XhC0y+wy3TeDzD+0oAX/FVAru+38BIrHFir4EGgdHeDexpnLlZcfnaZ6ek7QjW
         SjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=v/Hvz2y/9yGlffyGt+XTnmqXlX/CDQpwKYs2JIVv1H8=;
        b=gbt4Ky5vyYqPT7vY9g7L2PWt1q6Ts/BY3fSLnNXveurwWb+erpnfRlJh5LeaTcsFUo
         ez/t4bPzX5F6qX7sSigM6erzlBcZTLOYYMEfjncR75viNPAtMCvOHckg/xsbIuJeM15W
         zeagqFKDCvxH9hsqkeAX6HbIqUamFVS45D3tba6qq4MdiYFgUOczb+jS6LLRlYDXDPth
         QGMrinxfYnmjlYUGJ5gOmxr6LJO96kddHAF9YDmKE46hi14xioHSHb6pQNeIBz9X1gYY
         0bbxVtx1L910ppwIaVK0x7QNYtjImKoQn5MZ8968F6yv7gPIqu0J9aYEs9r6RiAcJZ6i
         OFjg==
X-Gm-Message-State: AOAM531FxKuHGBmOZkC5RusVPYKqGew0F9AJNEIEMYDHt+wNwgKs3Nf7
        3c+7RUd6kQ+cARFjdSNTgBQ=
X-Google-Smtp-Source: ABdhPJzYm9CAaFeos4paHLnIEBJjzP0N6lFBhWeD29y08M2eZ2RJuv+vTS9dSOfm4bCzt3gMw/m9kg==
X-Received: by 2002:a17:902:ec92:b0:135:772b:89b3 with SMTP id x18-20020a170902ec9200b00135772b89b3mr11669981plg.74.1630121721972;
        Fri, 27 Aug 2021 20:35:21 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q21sm8513021pgk.71.2021.08.27.20.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:35:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 4/6] build: doc: fix `make distcleancheck`
Date:   Sat, 28 Aug 2021 13:35:06 +1000
Message-Id: <20210828033508.15618-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`make distcleancheck` was not passing before this patchset. Now fixed.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index f38009b..bab34bf 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -14,7 +14,7 @@ CLEANFILES = doxyfile.stamp
 
 all-local: doxyfile.stamp
 clean-local:
-	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+	rm -rf man html
 install-data-local:
 	mkdir -p $(DESTDIR)$(mandir)/man3
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
-- 
2.17.5

