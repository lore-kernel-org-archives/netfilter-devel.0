Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176B2C07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 05:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8BA661977
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 05:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhGFFjd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 01:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhGFFjc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 01:39:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4EC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 22:36:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso355511pjb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 22:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=npwmtuAPaZjPAtSaHHA8gAAOqsWGz2Ho0Ppm4ioZ4VE=;
        b=GjYiHQIQQGqRBz7mhG/+VwIqZHp0Yf5jhvSKdNCwCfR0+HKtXddVIncdg1oEOnEjdE
         I0IILrj1v8lj0Ffy1VZlS0nXTDpDALvvABlIqGplmdt8sNOrrroRe1cj5OOGFbyVeDGv
         wEUDI8MgvyO0SmRkZQr0Dk82A3iIM6Ya7Alip0gEGjiaYXV4yPGZgb/ijC9X5zbUshNd
         2TE7TYagF+kE5IlWgXxT4kddhPE/0uDrvN5qmTFqW4aHQ962kg8TEK/QEVJPm4mohEms
         ELZSBzG46qXrvtg+wHbsJeWrXWJoP0K2AgTtFocpRw5cyebh9Eop48b8+SM1iThhqbXm
         eB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=npwmtuAPaZjPAtSaHHA8gAAOqsWGz2Ho0Ppm4ioZ4VE=;
        b=EjhxzhvibVDEzapcQttjVxAygttJEhGofNdewkOV8iobSt4M1vQOKRAVaXbWL+B9pp
         9UARJODIp/wKNGRfV9iwXh2W/OM9ETqxAW0Z0V7ZBEOBVSZygF4ZX38Z89c8+tO+MP4y
         yFyisCGJZxcZX2XZNe3QXE6ySh/3SwFV4q8BZSWqgjVi+iow0aTy+ktMa0SHI/KCuH0v
         P1qGlRmqHNpetN5OyWJ3X5o5fyyF+yk0YGr26vH/qA+Y7WiVGEEo7EUpy/T8XIvA2m1E
         wreJVOmA4Z/ngawBZTRTGqNaMsgiR0J9AKmdZcE9WvPNHViOE3dvXHFOkmXR2gSAXtzg
         PgEw==
X-Gm-Message-State: AOAM530sDK56jxX7QeaGjuW+o1nINf4a4u+ZXGqg38uRjov68g6pANux
        CY7VEZeyW8KqchXVMRGbQj0=
X-Google-Smtp-Source: ABdhPJzxz6yVNvOBcftJ1DERzpWdIRpZAyPNSiVvDo5NlpFcoVtMPft6BuKEpj+oSz9N6c5oCNsCmA==
X-Received: by 2002:a17:90a:66ca:: with SMTP id z10mr18655606pjl.78.1625549813622;
        Mon, 05 Jul 2021 22:36:53 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id g11sm18467313pgj.3.2021.07.05.22.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 22:36:53 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: examples: Use libnetfilter_queue cached linux headers throughout
Date:   Tue,  6 Jul 2021 15:36:48 +1000
Message-Id: <20210706053648.11109-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
References: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A user will typically copy nf-queue.c, make changes and compile: picking up
/usr/include/linux/nfnetlink_queue.h rather than
/usr/include/libnetfilter_queue/linux_nfnetlink_queue.h as is recommended.

libnetfilter_queue.h already includes linux_nfnetlink_queue.h so we only need
to delete the errant line.

(Running `make nf-queue` from within libnetfilter_queue/examples will get
the private cached version of nfnetlink_queue.h which is not distributed).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Don't insert a new #include
    Doesn't clash with other nearby patch
 examples/nf-queue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..e4b33b5 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -11,7 +11,6 @@
 #include <linux/netfilter/nfnetlink.h>
 
 #include <linux/types.h>
-#include <linux/netfilter/nfnetlink_queue.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
-- 
2.17.5

