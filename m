Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FBEC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 13:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF1E60FC0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 13:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhICNYy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbhICNYy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 09:24:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58744C061575
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 06:23:54 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i21so12087081ejd.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Sep 2021 06:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=mPfTESljYIejLY5313FsLIxh4RImmg1MO9moA8YDXEw=;
        b=U8qWzSxx2G42OwesoJIwTtFJPdPRM3goAZ3Zxt4HcxW1LXTfTRvthahC2JLBwMbwrq
         a+J6B/SuutnJ/3GgV85JBWKGv8TcsCALp/NKK6cWnMZ848662TgyRh3bVCYmW7Nyk+en
         ROgi5zEOSJ+bN/S51hEatdbkW7eiURj9aHks4M/HJqY+dS59baAaHU+5ms6as1DIGbui
         XbZvfsSxiGwbiYGotbdX1HVBmoq7iilDEjgDtPsEEXSRbE//zOL1c/fG4uhG/F6pQ+5P
         LuSmYMZ8f55jVgRzpDy+s+O27CTCCKbh8IOJqOIvPeUvVYnMTi6Ry2mQoKFp63Vh34Jm
         k26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mPfTESljYIejLY5313FsLIxh4RImmg1MO9moA8YDXEw=;
        b=Y+KR6zRI3MQbHBsIuF4R12P/UTujMPylcyOnEKlycvuFxyMG+n37RYdx++73PrpTw5
         E/A2PXnNeb+20gX47/Ncjs8ZV1JWq60qwDDawNGPB6WP+AWmvAs9oY82bQ1Lx2rjzuq0
         v/Iq7ysG517JH704JS8qBgTPgR33I7YnymuJn/zjcG0AmkOZOllKg5hkyqJlEom7eiSq
         HmnpwAcPJmZuzFbmIlcii4RXs6+EuoRZw3rD+iCL6Uq/+GPT3fyAIAS3riyMdrNI9GHN
         6ll0y826ouqAEeBF/VBA0xZexu9++Tx4ASfLPLwkOZekQJxN00LHHZI0viZnufyKd7fp
         cu6Q==
X-Gm-Message-State: AOAM533eBLLoOaCMFI7zrhBuOOPyof+/YFeqvy2pujB3TYojXcq0VcE7
        1b8Jhi5nUtbxOSi2M+NsRvkPViGf7IW3OXof
X-Google-Smtp-Source: ABdhPJzPAgyzrlM2J8JR4ZqbuPWYMdg1GWYwVcyT6wtC4JHGkBpzGMUB8FjrAkZrFCYJWoe2cZJDQA==
X-Received: by 2002:a17:906:d0cd:: with SMTP id bq13mr4263781ejb.66.1630675432420;
        Fri, 03 Sep 2021 06:23:52 -0700 (PDT)
Received: from bhesmans-Precision-7520.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id j24sm2927802edj.56.2021.09.03.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 06:23:51 -0700 (PDT)
From:   Benjamin Hesmans <benjamin.hesmans@tessares.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>
Subject: [PATCH nf] netfilter: socket: icmp6: fix use-after-scope
Date:   Fri,  3 Sep 2021 15:23:35 +0200
Message-Id: <20210903132335.25355-1-benjamin.hesmans@tessares.net>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bug reported by KASAN:

BUG: KASAN: use-after-scope in inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
Call Trace:
(...)
inet6_ehashfn (net/ipv6/inet6_hashtables.c:40)
(...)
nf_sk_lookup_slow_v6 (net/ipv6/netfilter/nf_socket_ipv6.c:91
net/ipv6/netfilter/nf_socket_ipv6.c:146)

It seems that this bug has already been fixed by Eric Dumazet in the
past in:
commit 78296c97ca1f ("netfilter: xt_socket: fix a stack corruption bug")

But a variant of the same issue has been introduced in
commit d64d80a2cde9 ("netfilter: x_tables: don't extract flow keys on early demuxed sks in socket match")

`daddr` and `saddr` potentially hold a reference to ipv6_var that is no
longer in scope when the call to `nf_socket_get_sock_v6` is made.

Fixes: d64d80a2cde9 ("netfilter: x_tables: don't extract flow keys on early demuxed sks in socket match")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
---
 net/ipv6/netfilter/nf_socket_ipv6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index 6fd54744cbc3..aa5bb8789ba0 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -99,7 +99,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 {
 	__be16 dport, sport;
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
+	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
@@ -129,8 +129,6 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 			thoff + sizeof(*hp);
 
 	} else if (tproto == IPPROTO_ICMPV6) {
-		struct ipv6hdr ipv6_var;
-
 		if (extract_icmp6_fields(skb, thoff, &tproto, &saddr, &daddr,
 					 &sport, &dport, &ipv6_var))
 			return NULL;
-- 
2.17.0

