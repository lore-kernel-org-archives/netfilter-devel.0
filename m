Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D39C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 01:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6E866101C
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 01:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhG2Bsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 21:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhG2Bsh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 21:48:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D642C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 18:48:34 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id m9so5365872ljp.7
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 18:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iUoGRCCyi0U8HJh2759/G/1hC+LnOPKn5hEVMZ2ZYUQ=;
        b=X0AbJSKItyPFxtD/cNZjHT8Zknp0FxYk2clx/ChIYIEsqwHXxcK2wGjYn9fHdqg+c+
         pL7PHVwKEyLMRwpV4ttRQYt5Zna2xNCebvvy9GXJMeQbI/T1djPKKARXE510Txl/2f+f
         SK+Hm1fZNyVmgzdXnyZlo5OJ7+Ot8rc/Ohep9oakf8o0pnRH8tU9/Xzq2mOhkHM+XEgj
         XpenVjuhiBIXJTkXky3hPAxLikwbxlXeIuW9lbZ21PLNQJnKyoLQ0jRISIUvL7ZJ83Yl
         Q9G6m6tltm0tm4K1bBd50LuSi8mFoaLZ1oC1Bn3j6AuL4Qi7I4SRzrIWwA37aoVFjEsg
         327Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUoGRCCyi0U8HJh2759/G/1hC+LnOPKn5hEVMZ2ZYUQ=;
        b=HVcJ3vEQuCTBdXVJLOFO6qlCq2y93KYlPswY8n9F4Uyqv7yawrS6hN2LD6msbLFT0d
         nTH6idRpPYF0oR+sX/nkkLs8WtOzUsxbLRW7wdh/tZfwGNTgCx3FbD7aYNFCjPxa3gln
         93h7SCNvxxhhdPsBqHYdhvvByh56rcJ7P1jC80V3CA3AetnA9CfnLJhTBVm9urZpcS51
         zh+2JSd4mOrCF6CBgn6Lhh3A4ELw75gkiA9UPW/ckfmW3cGr+v3IB+e7ytljpv/rXA12
         8rkkNSWXMydoqJxmw3yUOW1nJ/x8nyJ97fauK9tptfhhLr9tzXShffJ5Lo3wo+o/H7++
         xM7w==
X-Gm-Message-State: AOAM5310lgbrOTWY1BI/polo8wWrWDmSkYsSdOBZbVbU8B1onqf4j62g
        MnWsZNYCwXPr+OXfgt7oA06jaWWQ/Wb+9tUiv3k=
X-Google-Smtp-Source: ABdhPJz1LcvSbG7DsGlCeZl3MtDVLnYgYTskpZZPhEaVOftMnYYE0izZZjDaDTGRnAmEBKTe6KL1xSASbh8QE0Wm7WY=
X-Received: by 2002:a2e:b0cb:: with SMTP id g11mr1461709ljl.227.1627523312798;
 Wed, 28 Jul 2021 18:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com> <20210727210503.GA15429@salvia>
In-Reply-To: <20210727210503.GA15429@salvia>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 29 Jul 2021 09:48:21 +0800
Message-ID: <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'm not sure it's just me or you that are missing something here.

On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
>
> Yes, those two are equivalent.
>
> > Does that mean `tcp flags syn` (was supposed to be and) is now
> > equivalent to `tcp flags == syn`
>
> tcp flag syn
>
> is a shortcut to match on the syn bit regarless other bit values, it's
> a property of the bitmask datatypes.

Don't you think the syntax will be inconsistent then? As a user, it
looks pretty irrational to me: with a mask, just `syn` checks the
exact value of the flags (combined); without a mask, it checks and
checks only whether the specific bit is on.

At least to me I would then expect `tcp flags syn` should be
equivalent / is a shortcut to `tcp flags & (fin | syn | rst | psh |
ack | urg | ecn | cwr) syn` hence `tcp flags & (fin | syn | rst | psh
| ack | urg | ecn | cwr) == syn` hence `tcp flags == syn`.

>
> tcp flags == syn
>
> is an exact match, it checks that the syn bit is set on.
>
> > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
>
> these two above are equivalent, I just sent a patch to fix the
> tcp flags & syn == syn case.
>
> > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > syn / syn` instead, please note that while nft translates `tcp flags &
> > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > translation as input (when the mask is not a comma-separated list):
> >
> > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > Error: syntax error, unexpected newline, expecting comma
> > add rule meh tcp_flags tcp flags syn / syn
> >                                           ^
>
> The most simple way to express this is: tcp flags == syn.

That does not sound right to me at all. Doesn't `syn / syn` means
"with the mask (the second/"denominator" `syn`) applied on the flags,
we get the value (the first/"nominator" `syn`), which means `tcp flags
& syn == syn` instead of `tcp flags == syn` (which in turn means all
bits but syn are cleared).

>
> > Also, does that mean `tcp flags & (fin | syn | rst | ack) fin,syn,ack`
> > will now be equivalent to `tcp flags & (fin | syn | rst | ack) = (fin
> > | syn | ack)`
>
> Yes, those two are equivalent. This is the same example as the one you
> have used at the beginning of this email.
>
> > instead of (ultimately) `tcp flags & (fin | syn | ack)  != 0`?
>
> That's equivalent to:
>
> tcp flags fin,syn,ack
>
> A quick summary:
>
> - If you want an exact match:
>
> tcp flags == fin,syn,ack
>
> - If you want to check that those three bits are set on (regardless
>   the remaining bits):
>
> tcp flags fin,syn,ack / fin,syn,ack
>
> - If you want to check that any of these three bits is set on:
>
> tcp flags fin,syn,ack
>
> > Which means `tcp flags & (fin | syn | ack) != 0` should not be
> > translated to `tcp flags fin,syn,ack`?
>
> tcp flags & (fin | syn | ack) != 0 is checking for any of these three
> bits to be set on, this translation is correct.
