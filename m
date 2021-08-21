Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1C3C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEDE611C9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhHUFi7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 01:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhHUFi5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 01:38:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB817C061575
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bo18so8770460pjb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77PMbWaN9zywNNEI426+BbeTsFAi68ruGCbB7pjkJS4=;
        b=ihf6KmZjpwuq4HtZki19/fX2HSC6OteL2yrzr38M3O+4yOSxHulp4hjRXUlJsYrYA4
         ge5I70DArlChpAgfdbmiHqJTNiSkKvxw4zn4zfL6Rse8GcX5Uyq+H3KfzpB6vS3Quj8j
         Tfgs38tlJjKCzg+fIzTX7cyNPU6MkL7xoqBbOo9k+GKjfvSh+/eXCtmTVnKy3knlNCQn
         EioZt3cFdqDCY5m1KNK7hBY53filyvhR0rUcJTROhntZXwI7N2+hf1RiGz/juFKQIFt5
         NpMUTwFMWkPXaSeFuKJDsETGjvpHrtiFAUO3OoezRc8SgOLz15FYpKnU9EBlT/77kr/y
         ydBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=77PMbWaN9zywNNEI426+BbeTsFAi68ruGCbB7pjkJS4=;
        b=EiS4kOWH0Ti28QPUQtSdczYmnC34B4E2fjhzmOPjUC/yqeN0NLW0nVQ2AQAgXQFSrJ
         sg6Ag8B0DCl3yLTO9yS5kSMo9X57WYH9/7PkSnvvFZkX+W2MnFw9TxHZay1Uy4jmFJ6w
         RDvBsDgWulBB91DwEpBuBRRXMnXPHcaDgHzccnghvsS/1bgFVd4nT2R9x/Yzbq23PUo5
         G0a6IJWpv5Pe7ph/GyOC3oo0vHbSWD9pjo0iSjHZY9xygAp5wXECmdFTK+nh8Zt7SCYI
         8jSKY2Kmh1/AzgyOA9lvsqrSGVdDVLUBmReOqM3/CyQpN6Rfp8FAv4oqwb8EBIdwBfgK
         JyGw==
X-Gm-Message-State: AOAM533Skf8xgzPmjDsy9T0+XcXDZDYuON7wAWxPK74KuHZqsN2F8/au
        yPI4P6M0MeLtFSlsSJsMQTg=
X-Google-Smtp-Source: ABdhPJy/3V1Dwm/durQcgqzHnZHNsnJ6PPm3dp+NkN2r2gZgC+VsvxKzpSOaKLezu+h6O12NqHyO8A==
X-Received: by 2002:a17:90a:a791:: with SMTP id f17mr1934835pjq.225.1629524297349;
        Fri, 20 Aug 2021 22:38:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n30sm8905913pfv.87.2021.08.20.22.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 22:38:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 3/3] build: doc: VPATH builds work again
Date:   Sat, 21 Aug 2021 15:38:05 +1000
Message-Id: <20210821053805.6371-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also get make distcleancheck to pass (only applies to VPATH builds).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 37ed7aa..e788843 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -9,7 +9,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # If so, sibling src directory will be empty:
 # move it out of the way and symlink the real one while we run doxygen.
 	[ -f ../src/Makefile.in ] || \
-{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
+{ set -x; cd ..; mv src src.distcheck; ln -s $(abs_top_srcdir)/src; }
 
 	cd ..; doxygen doxygen.cfg >/dev/null
 
@@ -228,7 +228,7 @@ CLEANFILES = doxyfile.stamp
 
 all-local: doxyfile.stamp
 clean-local:
-	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+	rm -rf man html
 install-data-local:
 if BUILD_MAN
 	mkdir -p $(DESTDIR)$(mandir)/man3
-- 
2.17.5

