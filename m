Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC82BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 02:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9998A6101B
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 02:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhJRC4f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 22:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhJRC4e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 22:56:34 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC3BC06161C
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 19:54:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso5923281pjw.2
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Oct 2021 19:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9+pvTxPxcjp47K3tdHGmHv7L1qr+vtJFXe7ucFk0BZk=;
        b=Un89YYbzXUNAw7IBFfpN6TdsKEMlU3g+6zlX+RXe5GWT/aOpHPpAXvERpcVDAx82CK
         UgsOSMgyZygfBdJuX5OdD/7OOumKG9mBQ5AgB3tlPl2h+u8f5d6HGx0Va/uMbYxNU2Th
         hTmE1MyigFS8iSaJkcF/XP/7lpfV391qal+3m1GPAMapmd58fdb83Jc/w5XZKcVfINkX
         hcuFJq/C4+gBafOMKQim6kijKlHB7NIMW3b9jmPnmemHc9b7Qmk1ZGmx8zAnmMlQ+JXl
         +QwIyPU/CAzTAfNfVXLMVN74jVML0GaB13RepVaOcVad2pEYQUHuJaaS6r6rB35o8qxK
         8DnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=9+pvTxPxcjp47K3tdHGmHv7L1qr+vtJFXe7ucFk0BZk=;
        b=GkWgHn/3xbW65iIunf4b+plqLEbf8KasoIcSGt7E/I8vMhwifAEfP2Ioc2spISRkQD
         i/Ptwhd+mHDxb5h/6xzgYGIohoMYEqmPf2dMpiBKOYBPz58/hKm1fK0TZlr4y0b6ZMQL
         jPNK3FDHSE6BTtIcZIc0vfH0OomdrkkF2BtxKFIoVex4QiR915lEhihrTkYL36/Iaef0
         JmuLIwBRYF/sNkckYVdERTFGG7s8NkP2hR7C40oY8+JSZhYxzOH/oNiZIdGaxfbEtke+
         n9Hwfy+TvZwpxdy2y/ub/gu7Akqvb6iRZTJWa3tTWYfL7p+tPXlXIpR0kO+ZWaMV3fWl
         345w==
X-Gm-Message-State: AOAM533JSYBx8UkSgWgydYZwPJKpsAai6IEosxY4pdVmd+lo/wkfE43T
        HdbBnQLFDV6bpZWBkVgezxs6t0Rq358=
X-Google-Smtp-Source: ABdhPJx/8fO4/B7I7EoVO56AEq0sIMD0vn4KxjZ8ifaF/wzJqtKN765hbMHCb6/XkT5XIQyaqCaW+w==
X-Received: by 2002:a17:90b:1c8f:: with SMTP id oo15mr29711147pjb.169.1634525663766;
        Sun, 17 Oct 2021 19:54:23 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id f11sm10672216pgv.76.2021.10.17.19.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 19:54:23 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Ensure clean `git status` after in_tree build
Date:   Mon, 18 Oct 2021 13:54:18 +1100
Message-Id: <20211018025418.13854-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

doxygen.cfg moves to doxygen/; add generated files

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 525628e..ae3e740 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,7 +15,10 @@ Makefile.in
 /libtool
 /stamp-h1
 
-/doxygen.cfg
+/doxygen/doxygen.cfg
 /libnetfilter_queue.pc
 
 /examples/nf-queue
+/doxygen/doxyfile.stamp
+/doxygen/html/
+/doxygen/man/
-- 
2.17.5

