Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FACC4320E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850C3610CD
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbhHZDos (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZDor (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720EEC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:44:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so5658760pjb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/Hvz2y/9yGlffyGt+XTnmqXlX/CDQpwKYs2JIVv1H8=;
        b=QqE1N7ykrTjR54O2GGORpFECxy/sl0HJu4YC2OrxkBoCdrSTTxpnHafyTH9fZrk3KE
         ihLJUD4zE5vfW2YazwtvrNxSLLkajtXCXjGvabBW6hSF+Bb/kScbqnvSHbjiAt2oECt7
         05nheT7rkwbbEisjAt00ManeVAl9T/iK9M5rREEm2gJMF+j9PyglIc5ItLqZSgdU4FG+
         9b6CPukVh84oiiVGzLTgSl/JxPhNkZtAkIGHnxaLLLdDG1bBM6j/QbYIsM0ajDWFTwMM
         dYGWb4tYdrt68a1bDFObR8I2gVUL5ItR63vMD3vNaM+jSBZjdajlXT1TJmXsB1yikswu
         ZXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=v/Hvz2y/9yGlffyGt+XTnmqXlX/CDQpwKYs2JIVv1H8=;
        b=YUDoqu/xWYt3StL7qpW/ExfpcbdggE1qmDmprIbvYoby1GLdUEe9duyfAQh71XMMIy
         ApzvjsBQY621OpvJIxCC9GgLCBNn3hOsR2qcRAAyNeJbTnfUIEQ43GyDcnIIvEbX8HpY
         R+62OEaQef2RWskV35Uu1meYvAdKmpxPSPrOZKACLXRv/N7rzBKBeMXVR1vd6gE/frM0
         Hh8Lg7vQmZ6IrHZLHakxJ0ica2vvUsKhSx+x5H+UEliZApaqbaC4z0hrB050MNPrkCOq
         bMpcQG9hxI5pdS7e/zr7JMgNFU5chieP3kR8Be3SNkWAHbm27S+WHHWGXH5YSuLDt5WS
         WK4A==
X-Gm-Message-State: AOAM532jWP+R3A5UPLuApoNzrjsZd/uWvcc80reN3sEMdKw1GXOcWd0o
        QrTwFD1jRG6VNxsLeHaIC9dmm5XP3j3vRA==
X-Google-Smtp-Source: ABdhPJwA2btg7joqC28mONhX/DKZxOgcAiaDmT2NOOrZMq87CbXwLBgGGNL8Uh0sfCj5lllgDw6o7g==
X-Received: by 2002:a17:902:c40d:b0:12d:97e1:e19b with SMTP id k13-20020a170902c40d00b0012d97e1e19bmr1664658plk.45.1629949440039;
        Wed, 25 Aug 2021 20:44:00 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s11sm1109193pfh.18.2021.08.25.20.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 20:43:59 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 4/5] build: doc: fix `make distcleancheck`
Date:   Thu, 26 Aug 2021 13:43:45 +1000
Message-Id: <20210826034346.13224-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
References: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
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

