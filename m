Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846ECC4320E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BA46126A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhHVEPe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 00:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhHVEPe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 00:15:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E851FC061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o10so8287006plg.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77PMbWaN9zywNNEI426+BbeTsFAi68ruGCbB7pjkJS4=;
        b=XbKH0r9Z902c12MymX/zE2Mns7icUi4ymI2ksLNFRkqp0v2PNDCOPk3etpqcRtEd7+
         linm3ZLt30RHZaJfmeToKPW79jYHsAAasUNMj1K0PjtFsyp7A2aSNeHwdtKcQimA3gOa
         jP5a7ZazZ4pjBWsfSt2lUuGFkjOlIh46cNO6WFgcgKW7kqFmHk2LjwVfBEV04cGuxwKO
         T0JZUoP58ynDdw7c74ePbZPRzDyzem4eKUYY4ugFQENSE5w7uSS2QTheRcHYR7qU6H7B
         Gjh7pvjmzWh3w18bg7gcc8lmrrZZmVHjuFbMrmvyeTSWtgvEhextki5pvp6wDkmniJjp
         1KHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=77PMbWaN9zywNNEI426+BbeTsFAi68ruGCbB7pjkJS4=;
        b=rCRjjo6B4oLmM3vtwBOSNElAuojN4Q1vMMWsBlvlb36VpkkANMLceWi8mPgchYnIPQ
         qQf1SCKDgI8jjHCHvkmN9dE3m8CV7JSgJPYYwYPUpLg9nAdmkb8r+4l4xYNUj5nZyATX
         AsIt1QwWHIEzW4rO14qAsQXCvX3HhFqSWVyCTPfVswNbVqqAvwqludIB6taAFolel+kE
         dU/Jmndquot01WmKQLAVQ2mTnB4uoQHF4itPmD6UoMj70TVvNMi8uKHKme7Hnty9ly/Z
         hkfjtRGYiqwLedfYtIz1xriL3mg9arKzk+jll47f4hrl8CnTbqMSQwP6H6EFHI/Hdjo5
         M5cw==
X-Gm-Message-State: AOAM530PbziqAfmXMVOCc4flZVGdPjldqWyQ9IVodAw4thWLT5Y9lgzE
        U1hSOLkJdX/NxTjm4bhyy/M=
X-Google-Smtp-Source: ABdhPJwz8VsPTDyakexgkQFVT+Ostr/wy3VE6UVRwaTy6Q7CMf7GQIG/XYmDm+NEbazkbIQ6KTABpw==
X-Received: by 2002:a17:902:8c90:b0:12f:699b:27 with SMTP id t16-20020a1709028c9000b0012f699b0027mr16557851plo.28.1629605693562;
        Sat, 21 Aug 2021 21:14:53 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id lk17sm5777271pjb.44.2021.08.21.21.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 21:14:53 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4 3/4] build: doc: VPATH builds work again
Date:   Sun, 22 Aug 2021 14:14:41 +1000
Message-Id: <20210822041442.8394-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
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

