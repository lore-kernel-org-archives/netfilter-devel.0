Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C61AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 02:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D87860EBC
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 02:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhJJCji (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 22:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhJJCjh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 22:39:37 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3316C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 19:37:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so12114324pjw.0
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Oct 2021 19:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFIDQg3VrdS3Z+fudv5dwMXgcd7gN/ETO56nV1kHkWQ=;
        b=T3rAn1CkzsMLzDMphbo67onOvotbXgmQCtINooopb9QtKLjqEG4m98VeJfdVFSPXKh
         2s7a9ejJX0qWRRhFVgt+s4mNRUc2UU43AGlP4l+WCIerjnaMq8tPN9+UD8wtjbqxbmDl
         MWZfbLBbGOkHQtf+b979Tq/AVQK9D7KvQuBkwMR0izhqGHOUbfRZVUttCyxnSJJL+aCk
         TmULwv0uRGOZTKtJ0Af118xE2PeLcYwGK1wT9EiMUWaKzFK7DxCX4o9nZs7zLbrrFlB/
         oJz4tcCiYsmrJ/TO8gBbP6WELVTW+gRBtOhXT6D+BR5D/vO1vQ1l3I7p3Yly66bAjbuA
         IpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hFIDQg3VrdS3Z+fudv5dwMXgcd7gN/ETO56nV1kHkWQ=;
        b=AaKXRnLCNpS+Lsd3SpHCGUcJO9hMrlWCds+HNKy6xGut9tngx0QAjFRut3AhFtG4ws
         6Lm2sBfFAgF1LFOCZd8kcfCP9rAJUoGCDRlK76d8E2NXgBYnpn2SF6NIfsBQo4Bx/AAY
         DoKUYK1W+TFps1rdbyAhbGutZfB/PrVg7OSLazt2PmgGTpLerAsbb18i78uECUps3Dex
         gbikV5f6PiICTfIUnhZMt1gt3fgikz7+3HkGxUl2q/E8ikBJOllAmybVcWbuaTsk5LjX
         A5ja3/tviioBzWnhShf4PsgH7hGjXV0t+kpUqvPAgEa6YPC9iBFHbjV8u1z7DqSmJi7Y
         +taw==
X-Gm-Message-State: AOAM531Q/GfbNMoWi/nSjN2X0TUNkmP+BmYtm9NW+i8DX2H9pGpoeI/i
        jNF9nWRDvp6NHQQckgXzTbH0HeNpuJM=
X-Google-Smtp-Source: ABdhPJx0zGYYjsbCRrhHdSFtzbegrWu5vhIY88ycbnHHPJSLm5iZk/9AV27brL/fi0AF7w6eRcEzVw==
X-Received: by 2002:a17:90b:1d04:: with SMTP id on4mr21320783pjb.68.1633833459479;
        Sat, 09 Oct 2021 19:37:39 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b23sm3889749pgn.83.2021.10.09.19.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 19:37:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v5 0/1] build: doc: `make` generates requested documentation
Date:   Sun, 10 Oct 2021 13:37:33 +1100
Message-Id: <20211010023734.26923-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,
 
v5 is a rebase of v4 onto Jeremy's "Build fixes" patch series.
So please apply "Build fixes" first, then this patch.

Cheers ... Duncan.

Duncan Roe (1):
  build: doc: `make` generates requested documentation

 .gitignore                               |  7 ++--
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 +++++
 configure.ac                             | 46 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 ++++++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
 6 files changed, 103 insertions(+), 8 deletions(-)
 create mode 100644 doxygen/Makefile.am
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)

-- 
2.17.5

