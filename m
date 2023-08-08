Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D67AC04A94
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 22:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjHHWsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjHHWsk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 18:48:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F02119E
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 15:48:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d5fc5043ae2so282757276.2
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 15:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691534918; x=1692139718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjrWn1fSMygYDZZgckHhk0mXRfqs5Nidx65ICO3A52I=;
        b=gV4k4AQmJbNKxgLMYapJVIyO+9QcRPAfIhEdNQg0adenoyHWaTerujLmngfOXKcDvE
         DH3nTqA0kwzcCzLf6rxttNAOaJi/l5pr5ZiQFaLGXpuby+Az24eT0gxFj9TXFKS/4OX5
         VfWhqmlOIrgsoLOGFKr5LcIyQkoqKUdV2n+sWwqJ2G1B99tL7e3HTacu1x99c9fvCSZM
         BJXaYkIwuqE+r7BOIKKIVjI8XEkaZbNeH2eYr148VmffSGU8/uWx9fjbing1ZRjq3vss
         hg76ITGXmsQEVRX3T+Y1ADizkXb6H36uNS1m4cqUy9bQgz/myepQzF5SKC77aMhxtNaY
         izGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691534918; x=1692139718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjrWn1fSMygYDZZgckHhk0mXRfqs5Nidx65ICO3A52I=;
        b=cQMk4qrjJzQtxLXoTYlZE00VP6jsJcN1OUtuubTh7PhO9nSCuKaiFVxtYnk673ons8
         HNs9XkTtMdg+KRk24DOusWAiFGDnfDf3J17YfQ4DGGEzk84JDlfnntOKL1uGxtDaeB01
         zBGnkOo6d7ZpCqT9bqHYgwPppVBQYEZpeQSvhav1+gJzYfDXYlBVBvQYR33QuFyJgLP/
         l6xPqxY/YyG7M6ECBaEFiF3GLa+dPMxAylAZEAmsKJNWvoGJyiTl9kfPOvDpbeudLZYv
         CuAhpnVFDmmZKs8LEE5xG3z9aTOWxpKMN9vKqBa+lRhH5JvK9cbapIt53U1BFbmtbKdE
         qxpw==
X-Gm-Message-State: AOJu0YwMVroiCknGlJUd3lqssQ3ban/WjlNYPJngrBAfiYxZ4aWRBt6r
        BtsXNXZkHLHfJvU0JY5MmwXRJPPNxN0z8rzd1Q==
X-Google-Smtp-Source: AGHT+IGmyferwFNnbxw0iCzx/r3zkBXWgrh+IPzWVl1hamVpmOKPWK2mKFogqArbcsqyWhuzHoHX0ySiHTOwsP9CQg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:690:b0:d46:45a1:b775 with
 SMTP id i16-20020a056902069000b00d4645a1b775mr21159ybt.3.1691534918649; Tue,
 08 Aug 2023 15:48:38 -0700 (PDT)
Date:   Tue, 08 Aug 2023 22:48:10 +0000
In-Reply-To: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
Mime-Version: 1.0
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691534912; l=1584;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=TYjOW+AvMsSrKx/9aDmBZSW/vTLjOkdZMrUIxM50vSU=; b=RGO1nAXLC7fjnapekTUAeCHeVncKTCYqVtHP5+QOVJP9VkBsqI4ExgD47xSB2HnII22YwkXMP
 Jzqi8qIzqKQBStS0NzWem8DN0iJX/MUqERbE9rWZLT517qZ1WczKGid
X-Mailer: b4 0.12.3
Message-ID: <20230808-net-netfilter-v1-5-efbbe4ec60af@google.com>
Subject: [PATCH 5/7] netfilter: nft_osf: refactor deprecated strncpy to strscpy
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

Use `strscpy` over `strncpy` for NUL-terminated strings.

We can also drop the + 1 from `NFT_OSF_MAXGENRELEN + 1` since `strscpy`
will guarantee NUL-termination.

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 net/netfilter/nft_osf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 70820c66b591..4844e0109a58 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -23,7 +23,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nft_osf *priv = nft_expr_priv(expr);
 	u32 *dest = &regs->data[priv->dreg];
 	struct sk_buff *skb = pkt->skb;
-	char os_match[NFT_OSF_MAXGENRELEN + 1];
+	char os_match[NFT_OSF_MAXGENRELEN];
 	const struct tcphdr *tcp;
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
@@ -45,7 +45,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	}
 
 	if (!nf_osf_find(skb, nf_osf_fingers, priv->ttl, &data)) {
-		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
+		strscpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
 	} else {
 		if (priv->flags & NFT_OSF_F_VERSION)
 			snprintf(os_match, NFT_OSF_MAXGENRELEN, "%s:%s",
@@ -53,7 +53,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		else
 			strscpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
 
-		strncpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
+		strscpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
 	}
 }
 

-- 
2.41.0.640.ga95def55d0-goog

