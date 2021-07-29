Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678FAC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497A960C41
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhG2KmE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 06:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbhG2Kl5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 06:41:57 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69585C0617B1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:41:34 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id f12so6973044ljn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N6PWn/tTg8wvMX0aqSgmSsHFDuUkt38MCMJ/j71AuFI=;
        b=WWLnE8Dycb6a85kDkTTH/HdeFjdX631htHdSUVAPElHoTA6zCEU8rPYGZ/uvfRDBjL
         TLFtXG3Dvh04Ki/DJ3KhB+Yo3Xw2rQku8eZBIplwEnkqeS0GYklTyP9HLBau57Oz0Cnu
         /iFpN5HrdT+3zD8kz3G/95w6rIdl0Ye6enD9xB/Ww4gHHpSg9waPuwQtoozMY6t0OEC9
         5irxMlCWtfLl66h9BTrpW85jxjpXqVIUxb56PCr7wTjhCgFuv2qnnkgBpJfTpoAUGO6i
         X5Q1KSElogmiAwiZLgYPT8qHiRRrWhaSRXTmJkH66buyzQlD+5i79yiR+6niZ5eLWqnV
         M0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N6PWn/tTg8wvMX0aqSgmSsHFDuUkt38MCMJ/j71AuFI=;
        b=kL4i1iL9zhLex50+IYaKiVVNHKskFIkA/JQUBKYaxkzD7TXo7n1BF2RY4TPm9QZMtM
         WJrA8Kp+z03+LaQCkx7jzWITAe72Kg3dIcm91WASKXjrYom8G11Oh9UfnyZ2ruMD04Ia
         HBJoR/LtsRbwCiyo0eJw4SzKLMtxNDi585TSzihVfuThC7ktJjOoyVg3dLBJOKHglyfB
         zkABLScqsfSeWi6Pe2XbT8hXUB/X8rf7RTaJw7EtCwJFo4y431oT7Pxe8PP7QHC9+NO/
         aPpqVyil72+7oVoQUXFHX1gUXuRsTGuPJ+T3OJKo59wtcUoH0Q8gZ9YMuXPPoY99Q6RE
         hgqw==
X-Gm-Message-State: AOAM531fZpK7gp+RfhLVIsm8mRJKpXhpe7EqR3vjoGNlerbYiFS7afc0
        eljl0d8f2bCXH/jYHR+hKfAsHwpm031J4FBM6PQ=
X-Google-Smtp-Source: ABdhPJybV+pRyzc4Xd7jDCxqhSZWMT5dMW2cg7W4hffxm9673ZaHSz9jLpDtM5igavGmYzRoqmK/UZWdfjMPSx1rK4M=
X-Received: by 2002:a2e:9b10:: with SMTP id u16mr2477828lji.228.1627555292776;
 Thu, 29 Jul 2021 03:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
 <20210727210503.GA15429@salvia> <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
 <20210729070345.GB15962@salvia>
In-Reply-To: <20210729070345.GB15962@salvia>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 29 Jul 2021 18:41:21 +0800
Message-ID: <CAGnHSEkfh57NqD2LJYKBjOXT+6kgvya67nfv0ZtaNnwsNg3diQ@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I was quite overwhelmed by the whole thing, so I might not have made
my point clear.

While I find e.g. `tcp flags fin,ack,rst` being not the same as `tcp
flags { fin, ack, rst }` confusing, in this case it is still
"reasonable", as we can say that in the former it is a
"comma-separated list" (hence no space), while in the latter it is a
set (hence the spaces).

The real issue here is that a comma-separated list itself can have
totally different meanings. For example,

1. If (just) `fin,rst,ack`, it means "any of the bits set".
2. If `== fin,rst,ack`, it means (fin | rst | ack)
3. If `fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack). *(For
both the value and the mask)*
4. If `== fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack).
*(For both the value and the mask)*

So how could anyone have thought in the first case `fin,rst,ack` does
not have the same meaning as it does in the other cases? That's what I
would call "unreasonable". Also, if in any case e.g. (just) `syn` is
not considered a (single-value) "comma-separated list", it's
"unreasonable" as well.

Or in other words, I don't find a behavior/shortcut like, "if a mask
is not specified explicitly, a mask that is equal to the value is
implied, yet not when we compare the value (e.g. ==)", sensible /
sensical. (Would anyone?)

And you know what, comparing this with the `ct state` is unfair. The
fact that you did so sort of explains why we end up in this...mess.
(Not trying to say it's your fault but rather, how the issue could
have happened.)

In the case of `ct state`, while we use the different bits for the
states, the states themselves are mutually exclusive (AFAIK, e.g. a
packet can't be new and established at the same time). People assume
e.g. `related,established` to be *practically* equivalent to `{
related, established }` not because they would think like, "generally
a comma-separated list should mean any of states", but either because
they know in advance a packet can only be of either, or, they assume
such similar syntax should mean the same thing. (The truth is, `ct
state related,established` is NOT *logically* the same as `ct state {
related, established }`; the former will be true for a packet if its
state can be / is related | established.)

On Thu, 29 Jul 2021 at 15:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Jul 29, 2021 at 09:48:21AM +0800, Tom Yan wrote:
> > I'm not sure it's just me or you that are missing something here.
> >
> > On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > > > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > > > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
> > >
> > > Yes, those two are equivalent.
> > >
> > > > Does that mean `tcp flags syn` (was supposed to be and) is now
> > > > equivalent to `tcp flags == syn`
> > >
> > > tcp flag syn
> > >
> > > is a shortcut to match on the syn bit regarless other bit values, it's
> > > a property of the bitmask datatypes.
> >
> > Don't you think the syntax will be inconsistent then? As a user, it
> > looks pretty irrational to me: with a mask, just `syn` checks the
> > exact value of the flags (combined); without a mask, it checks and
> > checks only whether the specific bit is on.
> >
> > At least to me I would then expect `tcp flags syn` should be
> > equivalent / is a shortcut to `tcp flags & (fin | syn | rst | psh |
> > ack | urg | ecn | cwr) syn` hence `tcp flags & (fin | syn | rst | psh
> > | ack | urg | ecn | cwr) == syn` hence `tcp flags == syn`.
>
> As I said, think of a different use-case:
>
>         ct state new,established
>
> people are _not_ expecting to match on both flags to be set on (that
> will actually never happen).
>
> Should ct state and tcp flags use the same syntax (comma-separated
> values) but intepret things in a different way? I don't think so.
>
> You can use:
>
>         nft describe ct state
>
> to check for the real datatype behind this selector: it's a bitmask.
> For this datatype the implicit operation is not ==.
>
> > > tcp flags == syn
> > >
> > > is an exact match, it checks that the syn bit is set on.
> > >
> > > > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
> > >
> > > these two above are equivalent, I just sent a patch to fix the
> > > tcp flags & syn == syn case.
> > >
> > > > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > > > syn / syn` instead, please note that while nft translates `tcp flags &
> > > > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > > > translation as input (when the mask is not a comma-separated list):
> > > >
> > > > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > > > Error: syntax error, unexpected newline, expecting comma
> > > > add rule meh tcp_flags tcp flags syn / syn
> > > >                                           ^
> > >
> > > The most simple way to express this is: tcp flags == syn.
> >
> > That does not sound right to me at all. Doesn't `syn / syn` means
> > "with the mask (the second/"denominator" `syn`) applied on the flags,
> > we get the value (the first/"nominator" `syn`), which means `tcp flags
> > & syn == syn` instead of `tcp flags == syn` (which in turn means all
> > bits but syn are cleared).
>
> tcp flags syn / syn makes no sense, it's actually: tcp flags syn.
>
> The goal is to provide a compact syntax for most common operations, so
> users do not need to be mingling with explicit binary expressions
> (which is considered to be a "more advanced" operation).
