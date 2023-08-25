Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68073C3DA6F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 02:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjHYCP3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 22:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjHYCO6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 22:14:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D86B1BD4
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 19:14:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-689f9576babso445579b3a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 19:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692929695; x=1693534495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zpEMaWn2fe0znYsM8OQn1g71yNr9kO5k17BIUl/B/IQ=;
        b=GtE8LCNfBwAmaiLnTMlqZyrdjjgm+8zishLnnCZNDI1iClLMH8KegAC7GhjiGhX+U5
         78vmDhf23biKoWNgvTjSgLriKXUw6LIp4Bi1U1uz5z66g+2e3ejsaVeEEyDYoDbwQN+D
         rK0KOaAw9VYJW1EplsCa3h2FWOdOA0OJ6oj9eWJbql+caCudyfQSwqI3JWqkiimFJM/a
         Lm2UkgTZPQEDE9jcQ+eVGGdfbeVaPbA20Vt84soUazX7eaqR1xfryAotp6fX1dLkkUzi
         BS9wkF0Kb8k9YzW9v7iNxYataQ53TUsuUbdcVkLMr5Jk9MadX4wrawIErbWpY/XYBy8U
         0Yqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692929695; x=1693534495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zpEMaWn2fe0znYsM8OQn1g71yNr9kO5k17BIUl/B/IQ=;
        b=KozO0979XNIZSaBkbZyAxeZENekWvnDby/slJ26YacjoAzZTn7QI40VWLWrJ8DHGc5
         82bdxQ/km/Y8b5zeKvREDKf1oKnHL9gs26VI0aVcmKs9DOZSYUygcEpvpVV+OIErqxYS
         MzogfEq+xvEqLEZKtVYjfRX7jkNKpnJsXhuwSRJdNliU6bVlp8+o/oNOOQ9q6gw052oG
         31nIGh5qKC22XVp/qxOUfXoOQyD2RDrWsIN1ApP+Y8K90rK+uETHtRyhsDKpYcZsa6lB
         IqW7r2VzCS5pUqk9d/LCtOlbDfpdvqtkP9H2cy1UzQaTUnupinUoZhFMtdaIfvBMVhV7
         in3A==
X-Gm-Message-State: AOJu0YzA8sj9QBmcYVPraTdzgs0DG6+gAksMqBNc/KojfofN7Ox5n/7n
        nDAe1qPEDcA5WO5wYyMZTEAtmxc+z7I=
X-Google-Smtp-Source: AGHT+IGGuj6dFwienN8baBzIc7p6muC8ZV9dTlod7/0kr/cP6aG/R4fcRY4VPo3qBxzUYHYToC8raQ==
X-Received: by 2002:a05:6a00:218d:b0:68a:613e:a369 with SMTP id h13-20020a056a00218d00b0068a613ea369mr12248590pfi.3.1692929695264;
        Thu, 24 Aug 2023 19:14:55 -0700 (PDT)
Received: from nova-ws.. ([103.167.140.11])
        by smtp.gmail.com with ESMTPSA id a14-20020a62bd0e000000b006870ff20254sm396445pff.125.2023.08.24.19.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 19:14:54 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_exthdr: Fix non-linear header modification
Date:   Fri, 25 Aug 2023 10:14:27 +0800
Message-ID: <20230825021432.6053-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_tcp_header_pointer() may copy TCP header if it's not linear.
In that case, we should modify the packet rather than the buffer, after
proper skb_ensure_writable().

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 net/netfilter/nft_exthdr.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 7f856ceb3a66..2189ccc1119c 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -254,13 +254,12 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_ensure_writable(pkt->skb,
-					nft_thoff(pkt) + i + priv->len))
+					nft_thoff(pkt) + i + priv->offset +
+					priv->len))
 			goto err;
 
-		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
-					      &tcphdr_len);
-		if (!tcph)
-			goto err;
+		tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
+		opt = (u8 *)tcph;
 
 		offset = i + priv->offset;
 
@@ -325,9 +324,9 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto drop;
 
-	opt = (u8 *)nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
-	if (!opt)
-		goto err;
+	tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
+	opt = (u8 *)tcph;
+
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		unsigned int j;
 
-- 
2.42.0

