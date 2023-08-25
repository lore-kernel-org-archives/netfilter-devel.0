Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CACC71133
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjHYDYl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjHYDYP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 23:24:15 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A499D3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 20:24:14 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-48d05fdb8bfso225341e0c.3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 20:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692933853; x=1693538653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3UMw3ek7mW2+XAmhzePXEjcYXd3JnYarNLQT4aY0Tk=;
        b=Kvj/WBR9d3QuOkvudl676f/63v7gbq/XvGZ/HnyMJZFpC3EpA0YX0+hXf3XQqdWIC0
         hA3lfiezsZIgAYoDqzKTGbrmM+ElfCvfZDTu5pM102+mud4N2MWUB7RkYIDHmQMmT82z
         qgqwxnGQxxdbGcb7Hi+rl62NFs1zE4HgvBdTmPRQUgErF60ozv74XhP6droLphx0SuDy
         +HNY0Tr9euum2aXaQIUYMAmtZgzxmwH8hKrUG6XZLuVxoTGNzGd8eK5lNEvLq6eLtt2c
         +2AkLLCEmI0SyJEjEK9QE7SOT52MeV7gj4OOw1u2guXTdR933NjPeikKWr1yyPkOuwGR
         hmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692933853; x=1693538653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s3UMw3ek7mW2+XAmhzePXEjcYXd3JnYarNLQT4aY0Tk=;
        b=CxKShPS9HB7DxCN9d9TdLgQFt715MGNRkbFG1hSkSkqeKY6NDefyVpGhpjtWFJ/300
         G2AUIyeBlGmJFltCYzmUdJQKBBpBwDzbNHvASsXVxJGEtGGGXDUn46f4pkgURXLAPQke
         OApc2jiEt84QUd3Bqv/hY+aXHCCvwDbH2tIuyVjVwfVMmFRjVKpHAWEgCVEXxrCyW3LO
         g+Q2/vhiXqq7MjCclhfzbRkpQRSvoPFL1GhqOG6OJOS21bMGqticK8Wjc1VrHMOEcFSB
         Xr3pwuo5aBjNtfU8p9vyd9uDbh00Smhs9ie4O7fLajBfQBnek+LRaPysdjxerDTmItTT
         epFg==
X-Gm-Message-State: AOJu0YxCQMtyd+vbFpXznQtuDSZxaIJr5ePnE9CyRiPMQz9kKXbfDxCy
        I07vUcysVfrg6E6B5VM/gW39gtsh+SPo4A3DTkDEiri5sSyj5g==
X-Google-Smtp-Source: AGHT+IEpqb+L5exV97ClnsNN3L7Ul2NNeB+LdKRekeEHCVIwGFxJ/B9p9vOcDSat9idUieoxtSUyXMGhzE1zJDid+Ls=
X-Received: by 2002:a1f:c9c5:0:b0:487:d56f:fc82 with SMTP id
 z188-20020a1fc9c5000000b00487d56ffc82mr14057578vkf.6.1692933852969; Thu, 24
 Aug 2023 20:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230825021432.6053-1-shaw.leon@gmail.com> <20230825031110.GA9265@breakpoint.cc>
In-Reply-To: <20230825031110.GA9265@breakpoint.cc>
From:   Xiao Liang <shaw.leon@gmail.com>
Date:   Fri, 25 Aug 2023 11:23:36 +0800
Message-ID: <CABAhCOTHyEvrGFcKxpO0uD1mwRKFds6HmP0eC8hHVT8wxOMj0g@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_exthdr: Fix non-linear header modification
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 11:11=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
>
> > @@ -325,9 +324,9 @@ static void nft_exthdr_tcp_strip_eval(const struct =
nft_expr *expr,
> >       if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
>
> Just use the above in nft_exthdr_tcp_set_eval and place it before the loo=
p?

Sure. Need to pull the entire TCP header with skb_ensure_writable() then.
