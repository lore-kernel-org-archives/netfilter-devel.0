Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9951C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 03:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A133460FE6
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 03:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhIFDlT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Sep 2021 23:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbhIFDlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Sep 2021 23:41:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CC8C061575
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Sep 2021 20:40:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso3607406pjq.4
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2021 20:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NJN9XGtobqw7/84xDTkxJG0ALHbnzv33EOHnunTaai8=;
        b=BUWYAhCkxobUYP1t78yJPsmPXN/i5iHd/o7XEMz6tJIH5UMA4Oa9fGkzwsveblQq5A
         O6JjnUbnsQL1SjdJgHgI3yXmQbBZ8qrgHx8hYBNVfs6lPLQvLZXWDmSAp9EK497An68j
         UN67zFSS8b6WqyHTXsjZzihZdn0lT2kjpJBZI1SJJaSnI03jjveB0heMDceDF/Iu41XJ
         GEzn9QQMb5MCC+KyJb9++vlnzyLGbbje73I1d9gtvfHAy/Y4js35lOWo6F+MCT+rPcSM
         d9hFELx7X6/rBC54YEfyeCS/vV5saEaChWj9v6V/fBpkTNKhm09PXybRC55L1hhpmcS9
         /euA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NJN9XGtobqw7/84xDTkxJG0ALHbnzv33EOHnunTaai8=;
        b=TdYuWR11f5869sFQ+qTFKqfgAi5kybso5EDTl2KFQSGtR78EOjxTYhdUF8naFVW0BC
         jdqrqGr9fVhkc8q3cwaECUQa33Eg4rxXChSTB7TtU0cqx+iRonFcyowR1mFejcuE/oq8
         ivSbfKJJcDs2J9z3vZZE05gwurN8et8pyQLw3GvX8puQrKn3QQtzqTYT4OHdrRREF5Ie
         yrFbY0W9BYIaSawCh2KB/sSIOt892QAyZ+LWDJ0xifE4uSfUJdK6Si6WoVPMxL7kveIG
         izZeTkenD3T+p9EcQTfNp0B3IGod/Yljb9bQR0o0yrK7nIPdVRJxtUUO1Ok3XHpYf/xG
         yx9Q==
X-Gm-Message-State: AOAM530J5tP6uaJ9NkxXoOQX2ZLeVgsWD+dwA6HjyfvwllKfWM/EUeOz
        VuvWtlGyDfonZhEjyiTlZ/hh4W3r6ww=
X-Google-Smtp-Source: ABdhPJwqdJy0SVg5a+m89gP1YjVKcw08UX+SHfxuC1XOMp+kqJMAyyk3ImVVaTEhSaricPxKalBuQQ==
X-Received: by 2002:a17:902:e0cc:b0:134:7191:f39 with SMTP id e12-20020a170902e0cc00b0013471910f39mr9084561pla.36.1630899614488;
        Sun, 05 Sep 2021 20:40:14 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id i21sm7156694pgn.93.2021.09.05.20.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 20:40:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] doc: libnflog handles `log group`, not libnfq
Date:   Mon,  6 Sep 2021 13:40:09 +1000
Message-Id: <20210906034009.28808-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/statements.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 5bb3050f..6c4ba4f7 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -96,7 +96,7 @@ In the second form of invocation (if 'nflog_group' is specified), the Linux
 kernel will pass the packet to nfnetlink_log which will multicast the packet
 through a netlink socket to the specified multicast group. One or more userspace
 processes may subscribe to the group to receive the packets, see
-libnetfilter_queue documentation for details.
+libnetfilter_log documentation for details.
 
 In the third form of invocation (if level audit is specified), the Linux
 kernel writes a message into the audit buffer suitably formatted for reading
-- 
2.17.5

