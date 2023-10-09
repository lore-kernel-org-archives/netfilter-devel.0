Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19C7E95A8E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 10:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345840AbjJIKfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345716AbjJIKfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 06:35:17 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD59D
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 03:35:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d9443c01a7336-1c735473d1aso28273455ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Oct 2023 03:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696847715; x=1697452515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EN3uJE4yMvgvfD35kcer0arlZVJCs9P9fMf2LINGhU=;
        b=LLsjN3suWqlTjWp8edVDFU7j4h19A5hd2QT4o5pvL3re5EJm9MJgl2JategjUqdDr6
         p/uLmQ/pKdEYFM0xzCcWKKhFW5xunU3o90uFXuYyYWy8W354wNUyGv9qwd7FnjQ4nDOR
         r9RPjYlCD7fxZHZWDZyx48EjHzBgQqKNTLgX800MSbsxnV/xfNQP4oDo2AOmnUxPUQx4
         ceWaQgsanRfjTkkSdcDerXL9s+XlzwHJCS6yssRc/oLF9Fi+OPitP9LIfzAIlrmCQCVx
         FAEQE7YX6WgLZtVbeaTt4LlNYbnusMUjlwHN2mEPUQQcUpdN9qQOcaJeeSxYzEBsB9oX
         mADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696847715; x=1697452515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EN3uJE4yMvgvfD35kcer0arlZVJCs9P9fMf2LINGhU=;
        b=WtWqtjBejj+AAHsmxs7BSejFmpNCU1y19uGbbijyHD48QVdcczPX6MU2k//ZfnbRUr
         +D69hr2nFcm/4M1Bj/MM/gX/ZFM5BAXAhDI3pbwCwIXg6lhInm3oYa2JQYBBwlJU81la
         50fdbVkmKsNRuc73M9gOuM7P5Ft1xCerAm0v5wWHZ1dFPJl1TgSgNafwSVZrYC0V0R9h
         RVK1Vo9GIN5WVXiA1yc7N9HynSIdN9MzxLk6RERq36X3DGQiv8HL1wDp+LsPm6cd1gZw
         eNZwY9NEsFMvxV5YeSgaKK5RkJFRJz0No+/4Vw+9orY+EbCW2grMSLSQLi0xq2FzeAGg
         f1SA==
X-Gm-Message-State: AOJu0YwVs44oNh0gZkM3UvVV/9ykeRyEvIo0gp9SFH5ceEDKHSv38HEs
        808wwIfh7+4qFVvcU7qkPGQ=
X-Google-Smtp-Source: AGHT+IEcaF3+fLb7phwdSLSj8y57KPvWMtVoq1XcZlpcVBvKL07sOVIehccK3dWrmj+/lWq9OOer6Q==
X-Received: by 2002:a17:902:6941:b0:1bb:b855:db3c with SMTP id k1-20020a170902694100b001bbb855db3cmr9668958plt.41.1696847715384;
        Mon, 09 Oct 2023 03:35:15 -0700 (PDT)
Received: from localhost ([219.223.232.167])
        by smtp.gmail.com with ESMTPSA id x16-20020a170902ec9000b001c61901ed2esm9106349plg.219.2023.10.09.03.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 03:35:15 -0700 (PDT)
From:   Xingyuan Mo <hdthky0@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER)
Cc:     Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH nf 2/2] nf_tables: fix NULL pointer dereference in nft_expr_inner_parse()
Date:   Mon,  9 Oct 2023 18:34:59 +0800
Message-Id: <20231009103459.12594-2-hdthky0@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009103459.12594-1-hdthky0@gmail.com>
References: <20231009103459.12594-1-hdthky0@gmail.com>
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

