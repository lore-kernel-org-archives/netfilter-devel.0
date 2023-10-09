Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28DAE95A8E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 10:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346050AbjJIKgq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346048AbjJIKgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 06:36:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFC7F0
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 03:36:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1c723f1c80fso25538045ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Oct 2023 03:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696847795; x=1697452595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qywk7MQlzijgGkjhjBs5R3JKd5Xqn4FHnYfi31GCSls=;
        b=mwSqd1rIvu5xbGLbBj8Fw+LqVj0k18EEkptuF0vVQp0776kHOHwlgkt7kJadT+i5vu
         YnTw9eWkd/3EStrkw6aaDLgG5dIC4EADgScuM2PtSX/Ns2RzdYHziv9LWsYXN+GEE1HL
         VGpy+3EkDEDsyorfLiaEZAY73CtGgtAvGeZ5N8FCw6WcVyzjtf1OLhI9v531sCFaUH43
         wa1RXxZHdSxfOfi7+CTOyHiKJ+oknk+jE7Iv9RUsCsYT9/Dk+HNvbuYtsN2eRlkJBI3D
         qxK1NLUvHwhILUYN06th20ZXF2ijGp81lLnoO9oFNH5ZcLQE2pc8YBgZVye/7wYAbInT
         SFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696847795; x=1697452595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qywk7MQlzijgGkjhjBs5R3JKd5Xqn4FHnYfi31GCSls=;
        b=rky0TKVe0pdHcsLnadJkfN9sQ02x0q/2j59R1QcaebOlwykiVNik3OhtT7AjPEAU7X
         XrqlyEdskPilPqLvuAaRSRWH79WWfpR/TnrYa51VJsbBJon9fmyDa4rndh4t7d7XWpcB
         1SuCWuCDyRMdMsMWggwziUSPCd8BDazHl6iorGFeSdGbOd+sSpaYkc0X7Xcex0E6HURY
         ca7jXZ7odNA8B49/BGTpmG2t6hy34j5UcM176Jo1Ry9DrbOHYQ0AD1YZSklvaVqvA2AV
         hu6GPfuUWAyuZAf5+qRa03fGUE+wOcUMkcLde0e5NjMrXXD3n88QkgR9eJzcaFmj6LI0
         uj0g==
X-Gm-Message-State: AOJu0YxBZQ03JHsAzFdhwK5/NdrDz0Jca4KJRFYgxOIkgtjh8ozFrc1A
        OsUU3S0RUBZ8lh+dA5Ju6kU=
X-Google-Smtp-Source: AGHT+IEMx2/F3P2T8gqMLvhmwIzXNq/aKImfYGU07GqCHj25ZvEF4dLR3cxXfvnsAtBtx/AiusMUPA==
X-Received: by 2002:a17:903:2309:b0:1c3:6e38:3940 with SMTP id d9-20020a170903230900b001c36e383940mr15456711plh.7.1696847795502;
        Mon, 09 Oct 2023 03:36:35 -0700 (PDT)
Received: from localhost ([219.223.232.18])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b001c61df93afdsm9203333plg.59.2023.10.09.03.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 03:36:35 -0700 (PDT)
From:   Xingyuan Mo <hdthky0@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Cc:     Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH nf 1/2] nf_tables: fix NULL pointer dereference in nft_inner_init()
Date:   Mon,  9 Oct 2023 18:36:14 +0800
Message-Id: <20231009103615.12882-1-hdthky0@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We should check whether the NFTA_INNER_NUM netlink attribute is present
before accessing it, otherwise a null pointer deference error will occur.

Call Trace:
 dump_stack_lvl+0x4f/0x90
 print_report+0x3f0/0x620
 kasan_report+0xcd/0x110
 __asan_load4+0x84/0xa0
 nft_inner_init+0x128/0x2e0
 nf_tables_newrule+0x813/0x1230
 nfnetlink_rcv_batch+0xec3/0x1170
 nfnetlink_rcv+0x1e4/0x220
 netlink_unicast+0x34e/0x4b0
 netlink_sendmsg+0x45c/0x7e0
 __sys_sendto+0x355/0x370
 __x64_sys_sendto+0x84/0xa0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 net/netfilter/nft_inner.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 28e2873ba24e..928312d01eb1 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -298,6 +298,7 @@ static int nft_inner_init(const struct nft_ctx *ctx,
 	int err;
 
 	if (!tb[NFTA_INNER_FLAGS] ||
+	    !tb[NFTA_INNER_NUM] ||
 	    !tb[NFTA_INNER_HDRSIZE] ||
 	    !tb[NFTA_INNER_TYPE] ||
 	    !tb[NFTA_INNER_EXPR])
-- 
2.25.1

