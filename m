Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC15C41513
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 22:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjHHWso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjHHWsm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 18:48:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937E812C
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 15:48:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5896bdb0b18so6726817b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 15:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691534921; x=1692139721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9OF2QFsiP3MkrzN4gKJO5o0WhLZ6LzcN9E8K6dc8dQ=;
        b=Tk5sym5cRDFSry8K+vc1HytKkY3IbV6iZulQcdqzajiE0IVk3xAlVvRndUZmAf1bym
         qmBA/CUFS/PGUXiFjGhkccdVwoX3zHUdcOMoLvXMMUMjR8yufvUM3BMxdbZVUZUBohHJ
         XDd0dKfCAqHUdAGRMbnyrr4FGDyVDAC1FubuFJd7iCMUjnLDpsu9n3DTiB9Phq8Qvf0E
         q8U2keEGG0MEUAozFw72uG4Zvu2LbBhukIi5JUVz+Vr+B72eM5IBoS4QlmZ4vDb1Wq63
         DfyTE1Qq1a9iFWqR253R9wuYjfP9rEWY7oXwiicHyPCLs7WfdwbOq9mI2Yx1daOUKLxs
         Jqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691534921; x=1692139721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9OF2QFsiP3MkrzN4gKJO5o0WhLZ6LzcN9E8K6dc8dQ=;
        b=IrhPyOt4CNtH0gcLK59jm794efLDBWaAB7C7Pxl2Fc8R66Hl6jy5Q+E3RVyxfQ0fzF
         3z/RNvj2TSpz9fby1VJAREdtpMi/4hgV7cPgscvYl/GBMPpPPHQ7uStyHIppdE+PMXKK
         BT7G1oCe2eAd3vmr+M3P8i8XNqcVbYy7rADAGxsEUbK1CbDf8ACicM2qOMlHsAc4Qa8c
         YHPMMenj9nJwyRZh/bfBc78nF814WeFrTLfxs8YlGMEhmlIxg1JYI3Hm0pme26uVREDW
         v2wnieIlmZQwzgrneG5mHnSGgiQoLzJNJ5LjViR1CpqyMPs6Rl937BW+tCEvDM7wDtst
         4Spg==
X-Gm-Message-State: AOJu0Yw9eAn5e51qW61gOehvXzmoJ126lucGai3FJQFVaUW2Oew+11Ra
        Amo7oqVbkKBgAnHfpDTa2uesFFnilNskHKBiXQ==
X-Google-Smtp-Source: AGHT+IGCyJW7+H01CcBpmwMLWO4IJOM2JRZefUJenQ9SapEIQSusWKx57m2Q2rpVYsPLUriKIRjxQtAgRFf96MgkCg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a81:b61a:0:b0:586:e91a:46c2 with SMTP
 id u26-20020a81b61a000000b00586e91a46c2mr107296ywh.4.1691534920928; Tue, 08
 Aug 2023 15:48:40 -0700 (PDT)
Date:   Tue, 08 Aug 2023 22:48:12 +0000
In-Reply-To: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
Mime-Version: 1.0
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691534912; l=1134;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=Bp+w2rTLNgdzNlxLi9FLD4utZ4QUqpPxaPIds7U/AGY=; b=odK4V1dqN6Y308K04MH8d/MRrkeaDSd1rELzLfU+7SDbRdFBl0nXUSsw+H9Y12YsVkVDC43lj
 zmYSndS5Js/Dv3+IClsSCDsbs7OJ2vOQ6onFe43X7Ff2wDY/LO6DwG0
X-Mailer: b4 0.12.3
Message-ID: <20230808-net-netfilter-v1-7-efbbe4ec60af@google.com>
Subject: [PATCH 7/7] netfilter: xtables: refactor deprecated strncpy
From:   Justin Stitt <justinstitt@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prefer `strscpy` as it's a more robust interface.

There may have existed a bug here due to both `tbl->repl.name` and
`info->name` having a size of 32 as defined below:
|  #define XT_TABLE_MAXNAMELEN 32

This may lead to buffer overreads in some situations -- `strscpy` solves
this by guaranteeing NUL-termination of the dest buffer.

Signed-off-by: Justin Stitt <justinstitt@google.com>

---
Note: build tested only
---
 net/netfilter/xt_repldata.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 68ccbe50bb1e..63869fd0ec57 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -29,7 +29,7 @@
 	if (tbl == NULL) \
 		return NULL; \
 	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
-	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
+	strscpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
 	*term = (struct type##_error)typ2##_ERROR_INIT;  \
 	tbl->repl.valid_hooks = hook_mask; \
 	tbl->repl.num_entries = nhooks + 1; \

-- 
2.41.0.640.ga95def55d0-goog

