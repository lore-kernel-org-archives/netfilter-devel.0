Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652A0C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DB860F56
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbhHaIDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 04:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbhHaIDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 04:03:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CF0C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so1791387pjz.2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YYIPBxwuCp6mlU8oSuhoq6AB1LnXyJsvwVtzID2oZM=;
        b=bGTF0nHwzKkSSOoaYMWnY+xaHEf7LizF9HaCRQiIifviDUVtgA2FC9TJjRMjSPjNdL
         b0S1yz0sSqiLUMbNWrtHNpv80jvbq1aIH9h/7GewTWZP6RrNlhF+wqoWHlkJ0/DYZl9H
         efAc/WVrem1hgxlNsIYVtvDB83hUWdC45jlNqD3fhVv+vHKSB1nzMdXzjot50ql2MQyJ
         HXd1YmoG8u0RN49lOgL3GJTPs0utIVW7AScfsbDxETrtLJHkgMX5FAL6QpkJ1LbagMIy
         Fv3H7i9toj0J5OqvDG+/hHbzcXgwh1iHRVw9QbizM/P5e27xD4Cs0c5k7vLzg66RWtZ+
         CaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=+YYIPBxwuCp6mlU8oSuhoq6AB1LnXyJsvwVtzID2oZM=;
        b=pXQoUdJ+nJaWDY8fUSTk3aSmker1vHZuFS+5wu6cJnUxmDzcPI5jhzbhH9U2YsFIxk
         7aILwKwuG81JlGQwE09Zaoq/NJStW6CVjk0PdyP0QA41srfLlA9xwL2fJFxvR0tGSnBv
         EmXxDki5EhZAZRNpVzeKuWyl4MMiqU8yGD8ySd7/S04BXeIjKeNV2XmpszoN0WCv1WCV
         p4n4gjq0gf0Y5fUSEOXv5BXlaXfEGwMmPch2k40fgIL2sO83SWgUdZlkBR6EPS6FQsKO
         8+9Lr1+hhbZQY6zGZGWb8zq9rvx7b564AA7id6INJHCxQjnxNEjOxW8Pn4q7jx+dhbMR
         yfDQ==
X-Gm-Message-State: AOAM530B2R7aWqG17JrtUjs6jHuT68kPepEqE4QuHhWX3CYSLVBk2tib
        fyu45ZV8EyK4AGubv876RsRCTITzaMs=
X-Google-Smtp-Source: ABdhPJyn1JnrlV2WpArdffX60o4A2cPZbLH+olnQrq0Mk+WItEeEoWrJzHKUK+CDcV70h01FJZqtBw==
X-Received: by 2002:a17:90a:c89:: with SMTP id v9mr3994703pja.175.1630396926220;
        Tue, 31 Aug 2021 01:02:06 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r2sm1459047pgn.8.2021.08.31.01.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 01:02:05 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 0/3] Miscellaneous cleanups
Date:   Tue, 31 Aug 2021 18:01:57 +1000
Message-Id: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are similar to what we did for libnfq.
Doxygen is still emitting 9 warnings which should be addressed before any move
to generate man pages.

Duncan Roe (3):
  src: whitespace: Remove trailing whitespace and fix inconsistent indents
  build: doc: reduce doxygen.cfg.in to non-default entries only
  build: doc: remove trailing whitespace from doxygen.cfg.in

 doxygen.cfg.in                              | 174 +-------------------
 include/libnetfilter_log/libipulog.h        |   4 +-
 include/libnetfilter_log/libnetfilter_log.h |   2 +-
 src/libipulog_compat.c                      |   8 +-
 src/libnetfilter_log.c                      |  24 +--
 utils/nfulnl_test.c                         |   4 +-
 utils/ulog_test.c                           |   8 +-
 7 files changed, 32 insertions(+), 192 deletions(-)

-- 
2.17.5

