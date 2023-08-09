Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F5FC04FE0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 01:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjHIBHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 21:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjHIBHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 21:07:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D8319BC
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 18:07:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4ca2881833so4077117276.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 18:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691543261; x=1692148061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8kynZ2eY0/O6E/bQJdWZNL+mmpUwUSkdwurja4abucs=;
        b=Ol0O7ydBLmDGDB+SZ9v11BQgV4K8njIy76TSgXpaauJtbgStqpW/RYu/DWTxMxv5ZB
         +9MacsQSpkAhtOY9LVIFSQQtbwXVuIBhhpzOiV/EdBvEkZB/SRk8+/hM3Av3riZbSVSG
         QtCWUqHY7ASjZgsslXjvn1A8l6P037btB4PjAGygJPGdrTpttKYWlOta5a139Ww0nVw2
         4wZvofllE9KdG42dhpE4GXt+mC+sxQs7bOpHb0LRCj1twgqrLPVTJYEBe17+KyMG8QjB
         UtPRDLE2isjgjcvvsvJSfiJwpN73phog9iVfBbXoVUO8z8mhgWMyyQoeNpXAgTDKPl0/
         qpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691543261; x=1692148061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8kynZ2eY0/O6E/bQJdWZNL+mmpUwUSkdwurja4abucs=;
        b=P7Vmm2P7U51Iu1IyKn1nFVIH2Btujm3EokaUkYCIF0IJq520+QJ/gSTN+yedf9y92p
         83ksXuKjyxB7gEuWvDYpfzfynAo2xkl+9b8ciCdWNKwi+f7NvS3eVc3cRif+kHVschrg
         aORpJNrQsHS4hcp3eCfrkhvNSvhudnI0AGA7/1VlACq5i8LKEoGnFFu36pURyBQcpugv
         jWJd84QUNcSu0/IbKb+rxZK0GIGoWZuNwZosjjEslfj1ZZPIqpaVhoET7rv2T3R2SC6P
         sr96fx4OV0Jh+j6XSf6S+ppCuKgR9ME6UgZJb1q+VRFjbKeZujDLNFcBeH6xWDbHfFxF
         82kg==
X-Gm-Message-State: AOJu0YxXGGEVwi9VuGS1TOQjGD8GfW9tawse+qB38yORECVAd+K8KUiv
        78+Um4oRkbnbZQX42HxzxUPJasjLIilq+MIKbg==
X-Google-Smtp-Source: AGHT+IGWrBqKRyMPFFB9tEV4Q4dgsTSTg2iWnoP8DD7tIMTceBZqZZlfU6ptL0dqjEgU1ZHHFa6n34AN1ZEUPEROSA==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a5b:181:0:b0:d4f:d7a5:ba3b with SMTP
 id r1-20020a5b0181000000b00d4fd7a5ba3bmr30722ybl.8.1691543260881; Tue, 08 Aug
 2023 18:07:40 -0700 (PDT)
Date:   Wed, 09 Aug 2023 01:06:05 +0000
In-Reply-To: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
Mime-Version: 1.0
References: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691543258; l=903;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=GfuXN5T5xhe6k6w3cRknlOVNIOtegqmz8uQBUV4/tcw=; b=GYSS0ZoTuERfJ/SVnofWzjum44puD5h0s+zSjx2gITL2EhREYqCQpVB9N07nRO0v9d+gxkHdQ
 SOb7icKznTnC9EnhPquUOW6p8PVJ2Ep9ughhPfdNGQsR/NcIvz+Wupm
X-Mailer: b4 0.12.3
Message-ID: <20230809-net-netfilter-v2-2-5847d707ec0a@google.com>
Subject: [PATCH v2 2/7] netfilter: nf_tables: refactor deprecated strncpy
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

Prefer `strscpy_pad` over `strncpy`.

Signed-off-by: Justin Stitt <justinstitt@google.com>

---
Note: Opt for `strscpy_pad` over `strscpy` since padding is wanted [1]

Link: https://lore.kernel.org/all/20230808234001.GJ9741@breakpoint.cc/ [1]
---
 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 38958e067aa8..bbf11c4871b2 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -108,7 +108,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		helper = rcu_dereference(help->helper);
 		if (helper == NULL)
 			goto err;
-		strncpy((char *)dest, helper->name, NF_CT_HELPER_NAME_LEN);
+		strscpy_pad((char *)dest, helper->name, NF_CT_HELPER_NAME_LEN);
 		return;
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	case NFT_CT_LABELS: {

-- 
2.41.0.640.ga95def55d0-goog

