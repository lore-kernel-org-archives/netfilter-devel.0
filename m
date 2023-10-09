Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5FEE95A8E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 10:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbjJIKgz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346140AbjJIKgr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 06:36:47 -0400
Received: from mail-oa1-x43.google.com (mail-oa1-x43.google.com [IPv6:2001:4860:4864:20::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE25123
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 03:36:42 -0700 (PDT)
Received: by mail-oa1-x43.google.com with SMTP id 586e51a60fabf-1e0ee4e777bso3054799fac.3
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Oct 2023 03:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696847802; x=1697452602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EN3uJE4yMvgvfD35kcer0arlZVJCs9P9fMf2LINGhU=;
        b=KX9POGnlmzUJpZUiuBcz+LocgNWbcWj5LNQhxjNgtTTVfi1DNhn9XQtQHUUHhk8DdP
         8hL9moEi/weGInj5sQb7CB2IswlY0k70l1qLFIcuy0AQ9P7FEle0MQzsi3HYGejj2Cgy
         NahAaz0USJ+kq01XrqLWOkB/388H0ymsWxw/Nsa6RHT/gTNeWVxZE1W235UO+ECU1ijL
         6WEC1L2KX3LYPhhWOr76ci8MyktdwSGvwjCNFyTjzm2mbx0C2cqJo9tJcRjItREugl0s
         d3vFHJtWEIXEB+nGKsUtsLXJw4tjILPT7xckXjq7ey8XUQQvpo+DORH6ui9YljKX0vsg
         gYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696847802; x=1697452602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EN3uJE4yMvgvfD35kcer0arlZVJCs9P9fMf2LINGhU=;
        b=r7Y5bwbOAjnqB57tJFzD7ESFkfRx9Ss2Tx5BAgjeN8wcg1NwZ/zriBKy2NUlemMcAx
         LB3sCIOecoEMV7Gj0qe17+a67coeNxOVDFFqUpKV+BKMnR2i/2ajPCga6wSkP40JL2kg
         5TjA1uQbEW6Sy9raZu7HgC0MKsoqZpl7u+9KKBYg/kBomte6YKe9D4KhGRDvHUKYPNOE
         Gu5YhrTEsPr0bEyWPLfZAexP35B0cVCIcE92J0eb4U/Q4iSRfoNHLasjhFYRDX30zLLS
         sNXR7oDg+h7FnBxPtse5bkE2xkkVx8VIQPSkpHG+M0v2oxLsIxYDepwmnJCE/TdB1z3q
         WgHw==
X-Gm-Message-State: AOJu0YyXPUYB7Cb9HvtCSc2G5bdV1G8P39csS5gg5ZgMGjRvBGk+d2Vj
        7sYomDElJrbuwNlA4Yvxlxk=
X-Google-Smtp-Source: AGHT+IHGiYHxzhepdDHvDFWzBqSvDAQ7Ve2DPCAs313ul6zT9Tu7l2f2StwaQxHG8O1A/YhxNuR8eQ==
X-Received: by 2002:a05:6870:808b:b0:1c8:c37d:5e65 with SMTP id q11-20020a056870808b00b001c8c37d5e65mr16876439oab.11.1696847801636;
        Mon, 09 Oct 2023 03:36:41 -0700 (PDT)
Received: from localhost ([219.223.232.18])
        by smtp.gmail.com with ESMTPSA id v3-20020aa78503000000b0068fe39e6a46sm6032920pfn.112.2023.10.09.03.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 03:36:41 -0700 (PDT)
From:   Xingyuan Mo <hdthky0@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Cc:     Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH nf 2/2] nf_tables: fix NULL pointer dereference in nft_expr_inner_parse()
Date:   Mon,  9 Oct 2023 18:36:15 +0800
Message-Id: <20231009103615.12882-2-hdthky0@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009103615.12882-1-hdthky0@gmail.com>
References: <20231009103615.12882-1-hdthky0@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We should check whether the NFTA_EXPR_NAME netlink attribute is present
before accessing it, otherwise a null pointer deference error will occur.

Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x90
 print_report+0x3f0/0x620
 kasan_report+0xcd/0x110
 __asan_load2+0x7d/0xa0
 nla_strcmp+0x2f/0x90
 __nft_expr_type_get+0x41/0xb0
 nft_expr_inner_parse+0xe3/0x200
 nft_inner_init+0x1be/0x2e0
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
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a72b6aeefb1b..f7fb15fb3e2a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3166,7 +3166,7 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 	if (err < 0)
 		return err;
 
-	if (!tb[NFTA_EXPR_DATA])
+	if (!tb[NFTA_EXPR_DATA] || !tb[NFTA_EXPR_NAME])
 		return -EINVAL;
 
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-- 
2.25.1

