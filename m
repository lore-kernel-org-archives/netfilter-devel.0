Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C67C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 14:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A9776142C
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 14:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhEMOM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 May 2021 10:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhEMOMT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 May 2021 10:12:19 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE29C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 07:11:08 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso1022620wmh.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 07:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QhmB5tujCIE8+xe35BVQRQgoq5LgaJWfiYBvUENWTcc=;
        b=Ft2l+649GtG29zHW/mZJqh7+tDNY04Bnh6i9u+wqJ0xsItj8j72p3EqhpNcY4QPuwa
         TdfunsuYE2+kSPYB0tV1iccZNMEWzuoRX5J6PAz1SWE2wjHbTRX+goO1PDih70yukoa4
         9njCrzD47/wkRZM6FWpbmJRXCtRS32sPzpjQhgq/2/IdZot93SeJyWiqPnZ7c2BYRnNF
         QyBJEWlXpzEgkU+MrTFJHqOCL51LElZbz1AWv+k7RaOQusVSNlmIblbIKfgGypiTpC8d
         Z8aABN2ZX8P7WiSnd70a/rqV+/9Y2pVdzDPlBRQtgYNw0ywqENf5CNdvElA9WiKn3hu6
         NEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QhmB5tujCIE8+xe35BVQRQgoq5LgaJWfiYBvUENWTcc=;
        b=mXsXRWU2Hi2njFtCq5L+D22mkR0mxJJpsaFLVXdByB1BAI/KFpYopNWsZ72uyeFzmF
         1oUdu9rEhj9zZDRFChdt0QzyX58rslY1lIFcwYjC7zYzTL3RF/7TrSEalsTeI/uGL4QC
         dsbeK+m6Y6cls9C6vBj7wJrOkUzWB/mG7jB1p/20fjJSR/y/Gn8jQxUT2QDNM/FKQhBb
         +xwph6FDYH9UqyBrSuCHlymNZhou93xeHcRe+w0EDhMuPGLX8N/h5Ni1VID9GxgruVnn
         U7UiO6wJ2YjvvW19f6HrLdLaplqPKgjlKUYJzb15nTm7y9TB7bYAGyNG7wt3iLRUwU9I
         u0gQ==
X-Gm-Message-State: AOAM5317Tn59bvk2UBtRXk0lYPYNtt0utnmzii9mT9wD7WGrpMkp1Z6f
        c1LzC0bXdhwJ/2cs1NfxpIO42xUoK/IoxA==
X-Google-Smtp-Source: ABdhPJzwuqchwTvKLKk+Tftmi8mHk19VBj1V1FtHpLddVvmJi/h69gZqRcBNuWjLTuReI1EMrCxLEg==
X-Received: by 2002:a1c:7e45:: with SMTP id z66mr43886559wmc.126.1620915067685;
        Thu, 13 May 2021 07:11:07 -0700 (PDT)
Received: from sancho.localdomain ([37.160.154.27])
        by smtp.gmail.com with ESMTPSA id g131sm2877044wme.31.2021.05.13.07.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 07:11:07 -0700 (PDT)
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Marco Oliverio <marco.oliverio@tanaza.com>
Subject: [nftables PATCH] cache: check errno before invoking cache_release()
Date:   Thu, 13 May 2021 16:10:32 +0200
Message-Id: <20210513141031.213490-1-marco.oliverio@tanaza.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

if genid changes during cache_init(), check_genid() sets errno to EINTR to force
a re-init of the cache.

cache_release() may inadvertly change errno by calling free().  Indeed free()
may invoke madvise() that changes errno to ENOSYS on system where kernel is
configured without support for this syscall.

Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
---
 src/cache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index f59bba03..ff63e59e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -747,10 +747,12 @@ replay:
 
 	ret = nft_cache_init(&ctx, flags);
 	if (ret < 0) {
-		nft_cache_release(cache);
-		if (errno == EINTR)
+		if (errno == EINTR) {
+			nft_cache_release(cache);
 			goto replay;
+		}
 
+		nft_cache_release(cache);
 		return -1;
 	}
 
-- 
2.31.1

