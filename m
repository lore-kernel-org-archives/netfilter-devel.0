Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66948C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 05:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4426124D
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 05:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbhIXFeX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 01:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244134AbhIXFeU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 01:34:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59227C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 22:32:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w8so8844592pgf.5
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 22:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCzJKWmntQ3ebtf200GC4XWA2v2bTEjO1HhQqYjzvYM=;
        b=R1SZLwQMgUlUK9msj1v4fm+nuexyMi2P+pJEhkR8dfyTESIX12Y1R87KtXyL8DHN9b
         ZlhbWCR82KbI0cIzMseFLv3wgFpzOnOztP2wpAlp3RzDhP5PEj0ooRr8K907Zuhnz7nd
         f8smZ0ClH2IHpE9wSh06iiKFolIUA3MqQo5pykSnQd9q3gt8/1r1oYdUsTYVIpDwt1gT
         k1LC9pBSW9Dj9O59gl+Ox+q/Rqsj3bVHZsrLwFKqu3laVHp5atmQfYnDzU/g/7XbHMDw
         fv0YjEP5HXIHW9/XEfyQM0z/KlgNZxtUa/fPflLGRWWMAxarfTPjGVQYj/4e6WDNksvk
         D67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=pCzJKWmntQ3ebtf200GC4XWA2v2bTEjO1HhQqYjzvYM=;
        b=UzfPdLZpw28Mubgd1cz9u8lCCbzQgUsHnOxrrRKq2aMxXa0iz02D2kjP9BNAdZXxUk
         9aco0oba7Qi9IUjJpEC7Gq3oyC5dPT5dl8z6yOS9VwGavZOi19PElixW4Z4bo7Br+Mfo
         bvUAhHayaLni0QCPw2C+NLnrfobmEcqDu+M/5V+rLCAcF3Vb9nXQk6ZIhthEBW39mpHo
         WxPp1dX8iXa2uXP7qIftjaN/4YYvwQsc3L3g8Thefxb4OzDhS1MaTDgA+JrA5p5SQZn6
         /CEEHS3ZiQRK5SptfOfM5CfrzLIQx/Jzal3BhwMx1Ua4eerSTEGWpwA1uR+UYzEAuPfg
         ewkA==
X-Gm-Message-State: AOAM532/u/vL2l1SWGGhSr6K/BJE/5S80Wdp+7m/ycrIrKZAF70DXfsV
        7kI5HLO6Iaojrwy/nRWIinU475JDDpM=
X-Google-Smtp-Source: ABdhPJyz/xWByqY5mfoNfUhKpmffGEkYmhYoUgpw4YL88xV+xBjI8Iumus+gx95LLNs/HR0CJdaPbQ==
X-Received: by 2002:a63:6f42:: with SMTP id k63mr2268353pgc.358.1632461567763;
        Thu, 23 Sep 2021 22:32:47 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e18sm7484433pfj.159.2021.09.23.22.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 22:32:47 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4 0/1] build: doc: Allow to specify whether to produce man pages, html, neither or both
Date:   Fri, 24 Sep 2021 15:32:41 +1000
Message-Id: <20210924053242.7846-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This version simplifies the configure.ac patch by removing --with-doxygen
altogether.
./configure will not even look for doxygen if no documentation is requested,

Cheers ... Duncan.

Duncan Roe (1):
  build: doc: Allow to specify whether to produce man pages, html,
    neither or both

 configure.ac           | 28 ++++++++++++++++++++++------
 doxygen/Makefile.am    | 11 ++++++++++-
 doxygen/doxygen.cfg.in |  3 ++-
 3 files changed, 34 insertions(+), 8 deletions(-)

-- 
2.17.5

