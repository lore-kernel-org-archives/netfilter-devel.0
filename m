Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049A6C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 04:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB6561002
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 04:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhDTEZM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 00:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTEZM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 00:25:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577B2C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 21:24:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h20so18972454plr.4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 21:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9FAJDM9jVRp9pD8GhSCXqTehBo9jRZ8w9KRa7k5c5Gs=;
        b=ncSIQYFaG7Bc017LSWUGfdNSiHMfdoJMobQWgvBOtifL4y3O4XxI4Vz5G9Z6NrrgRF
         p69Br6D9+XiAajcBeICbJvPoPi7AwDzUyC9K1Sicoxw/wvDtW1LdjK2JThErVWutqSmi
         /KeW2iJy0Ij2KlktUDdYjQimo94f8zvVynsNzHX2DpM09POCzpKN3W9GbmS5H8LrK2Pc
         Pb4N9sHdnu0FimdCrdgD4hFRvfnD3reWknfLs0P6RKXdTldXX7For5bc+q0nEHmm1WJX
         pvdcZ30uSD5khGG1r5IKU6CfEeYpCukSamK3yc2hZ6C1L/FNR6LPYuv9s74DcoRuRbC3
         OGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9FAJDM9jVRp9pD8GhSCXqTehBo9jRZ8w9KRa7k5c5Gs=;
        b=CIf2XuxjVbOASz95BZiv5HZN/b4N/d+wZ5kG4upD3+hwSnnDjonNHNEp9oc/rc1v0+
         o+aYz3034bY4x74761BsThDjO6ljf0QWroa/HJEtC2PbuZniBDrDh5cMCybnWvFsyk/f
         y/vr7fur7YwAOx0+q3mDgXTDwO4dnDSD2A7+HVb/gh0lpjwyPut1hLqXR4SYalvhFoa6
         L7VZ7nkNVmsSxKWltDRMnJ9Oxa3HBVWxJS6AJ8a59uWIXT6QudXkZYwygHIifS24/htH
         TWVb+8IuE1B2EwC7oq6p4R//rQ83BZIYeoD03hxEROvXWb/gMKBwlpB+fKufsmJOfQIg
         UhGg==
X-Gm-Message-State: AOAM531ZG7GAuydBiRllojC2iU80HE+jObm/UhZ7hxwgqy1F88Z9icma
        LSsteKY7MOQ8KZBgKUSkeoBJEtLbyVXtLg==
X-Google-Smtp-Source: ABdhPJz7RRlSPQxRmxJSTX9YWwvz+BrFroHzgpKLaQaC5C22v5/VI3AHXlxCXh/74QdbafFGVuM1jg==
X-Received: by 2002:a17:90b:1bc1:: with SMTP id oa1mr2667213pjb.46.1618892679623;
        Mon, 19 Apr 2021 21:24:39 -0700 (PDT)
Received: from slk1.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id 71sm8557510pfu.19.2021.04.19.21.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 21:24:39 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: Now have make distcheck passing with doxygen enabled
Date:   Tue, 20 Apr 2021 14:23:57 +1000
Message-Id: <20210420042358.2829-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

We had to let the last release out w/out man pages but that really bugged me so
I had another go at it, with success this time.

There is awareness of running inside `make distcheck` but only so Makefile can
still work properly.

Cheers ... Duncan.

Duncan Roe (1):
  build: doc: `make distcheck` passes with doxygen enabled

 Makefile.am         |  1 -
 configure.ac        | 11 +++++--
 doxygen/Makefile.am | 76 +++++++++++++++++++++++++++++++++++++++++++--
 fixmanpages.sh      | 66 ---------------------------------------
 4 files changed, 82 insertions(+), 72 deletions(-)
 delete mode 100755 fixmanpages.sh

-- 
2.17.5

