Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC58C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF04D60EC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhG2K67 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 06:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhG2K67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 06:58:59 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A025C061765
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:58:55 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r26so10242674lfp.5
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s73gsmJKMKpiWZmM+OS1RsXRURp75uz4G2r2WqXW2Is=;
        b=bAxcRPLCocOX5FdSP9mHzSXM4e4iz/cppEklGo7F3ZoNy9cGbpuXa5eDQ0DEX5f/Bn
         FTO6nXg8OWgJS6rAKrbCDSxpiotUOsgZswSR98Sl8BoQzaY+CsrWzywqS3Mr4cV5mPuP
         bO+AgNouRhV1S4oNiOS3wUZ/wT/F8gqSoDgyoc/q5If4zlP0joF2zFOWTLgs5iKPS80j
         /HA5xzaUt43uTIRphtlRa7dTI3wxM5WWC4GgqFNjywPPcDQGggKwD2SLt2jTFGIbCP2p
         nFJVAlxgK76afRjcwh/i2mxDqEPtlHAIT6qaeLCCjAifC6Go5gULWPx3g2/bTkcFzFyV
         M69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s73gsmJKMKpiWZmM+OS1RsXRURp75uz4G2r2WqXW2Is=;
        b=IYsXFe6vG36K5UdmCV4FdjE6Bz8FpOJl3RPkvNhWOUgm//u90dmsthPGYFSC2rIB/N
         mYFVY2OhnG0wizcDYC9J4W48nirFy9LRVZHRDaRXhrWOaiXpeU4NaY/1ghTA8xkjPYi6
         /FVkbTubiQa8uIxQrTHaRgRmP4cO0B0FIeBjSpZ6kVCXTHR6cenwAUcOBTWML1H+SVqz
         Lqgo5u9Mih2ZPlLctfPtxbK9fUajIEveiYWmsNDu0OeMCgEGyQ+yUM/TgcspVPpZ0YnG
         Fr0pr4+xWSTaj4dVVagW2Fwuui7PU2LWxLZmg9H72QfLLem7paGOPhOBao8EoO9osf6n
         AGdA==
X-Gm-Message-State: AOAM531YXVPbvzOnCsVGaUi1rpvuN/fzhAXEnX42+Qi92k6lIwDJjEQf
        y3Re9jzetMD65SqLMX52CRl3u81+6Ru/N4xi6+M=
X-Google-Smtp-Source: ABdhPJzNQuVdR9DeYu5SdpaR2BGUQyH9Wja+fTZYh07zE53xu9qSArL6suCqVvH5suVqrW3P+1vDOeF8ouHlZwy+Pho=
X-Received: by 2002:a05:6512:1145:: with SMTP id m5mr1935332lfg.37.1627556333627;
 Thu, 29 Jul 2021 03:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
 <20210727210503.GA15429@salvia> <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
 <20210729070345.GB15962@salvia> <CAGnHSEkfh57NqD2LJYKBjOXT+6kgvya67nfv0ZtaNnwsNg3diQ@mail.gmail.com>
In-Reply-To: <CAGnHSEkfh57NqD2LJYKBjOXT+6kgvya67nfv0ZtaNnwsNg3diQ@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 29 Jul 2021 18:58:42 +0800
Message-ID: <CAGnHSEnGV=uFkMLWMc8ZXJ_cQUmPFtBBoMNOAYmU+dhZkda=Yw@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow me to add one more supplement to what I just wrote, as you/some
might say something like "but allowing `ct state related,established`
to work as expected is intuitive and neat".

Consider this:

# nft --debug=netlink add rule meh tcp_flags 'ct state == new,established'
ip
  [ ct load state => reg 1 ]
  [ cmp eq reg 1 0x0000000a ]

# nft list ruleset
table ip meh {
    chain tcp_flags {
        ct state established | new
    }
}

If `ct state new,established` is interpreted to be the same as `ct
state == new,established`, at least we *will know* that we should use
`ct state { new, established }` instead. But when it is not, we can
only *suppose* it to be *practically* the same as it. (I'm quite sure
many people think like, "nft is just not completed/smart enough yet to
be able to omit the redundant curly braces"...)

On Thu, 29 Jul 2021 at 18:41, Tom Yan <tom.ty89@gmail.com> wrote:
>
> I was quite overwhelmed by the whole thing, so I might not have made
> my point clear.
>
> While I find e.g. `tcp flags fin,ack,rst` being not the same as `tcp
> flags { fin, ack, rst }` confusing, in this case it is still
> "reasonable", as we can say that in the former it is a
> "comma-separated list" (hence no space), while in the latter it is a
> set (hence the spaces).
>
> The real issue here is that a comma-separated list itself can have
> totally different meanings. For example,
>
> 1. If (just) `fin,rst,ack`, it means "any of the bits set".
> 2. If `== fin,rst,ack`, it means (fin | rst | ack)
> 3. If `fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack). *(For
> both the value and the mask)*
> 4. If `== fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack).
> *(For both the value and the mask)*
>
> So how could anyone have thought in the first case `fin,rst,ack` does
> not have the same meaning as it does in the other cases? That's what I
> would call "unreasonable". Also, if in any case e.g. (just) `syn` is
> not considered a (single-value) "comma-separated list", it's
> "unreasonable" as well.
>
> Or in other words, I don't find a behavior/shortcut like, "if a mask
> is not specified explicitly, a mask that is equal to the value is
> implied, yet not when we compare the value (e.g. ==)", sensible /
> sensical. (Would anyone?)
>
> And you know what, comparing this with the `ct state` is unfair. The
> fact that you did so sort of explains why we end up in this...mess.
> (Not trying to say it's your fault but rather, how the issue could
> have happened.)
>
> In the case of `ct state`, while we use the different bits for the
> states, the states themselves are mutually exclusive (AFAIK, e.g. a
> packet can't be new and established at the same time). People assume
> e.g. `related,established` to be *practically* equivalent to `{
> related, established }` not because they would think like, "generally
> a comma-separated list should mean any of states", but either because
> they know in advance a packet can only be of either, or, they assume
> such similar syntax should mean the same thing. (The truth is, `ct
> state related,established` is NOT *logically* the same as `ct state {
> related, established }`; the former will be true for a packet if its
> state can be / is related | established.)
>
> On Thu, 29 Jul 2021 at 15:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Thu, Jul 29, 2021 at 09:48:21AM +0800, Tom Yan wrote:
> > > I'm not sure it's just me or you that are missing something here.
> > >
> > > On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > > > > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > > > > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
> > > >
> > > > Yes, those two are equivalent.
> > > >
> > > > > Does that mean `tcp flags syn` (was supposed to be and) is now
> > > > > equivalent to `tcp flags == syn`
> > > >
> > > > tcp flag syn
> > > >
> > > > is a shortcut to match on the syn bit regarless other bit values, it's
> > > > a property of the bitmask datatypes.
> > >
> > > Don't you think the syntax will be inconsistent then? As a user, it
> > > looks pretty irrational to me: with a mask, just `syn` checks the
> > > exact value of the flags (combined); without a mask, it checks and
> > > checks only whether the specific bit is on.
> > >
> > > At least to me I would then expect `tcp flags syn` should be
> > > equivalent / is a shortcut to `tcp flags & (fin | syn | rst | psh |
> > > ack | urg | ecn | cwr) syn` hence `tcp flags & (fin | syn | rst | psh
> > > | ack | urg | ecn | cwr) == syn` hence `tcp flags == syn`.
> >
> > As I said, think of a different use-case:
> >
> >         ct state new,established
> >
> > people are _not_ expecting to match on both flags to be set on (that
> > will actually never happen).
> >
> > Should ct state and tcp flags use the same syntax (comma-separated
> > values) but intepret things in a different way? I don't think so.
> >
> > You can use:
> >
> >         nft describe ct state
> >
> > to check for the real datatype behind this selector: it's a bitmask.
> > For this datatype the implicit operation is not ==.
> >
> > > > tcp flags == syn
> > > >
> > > > is an exact match, it checks that the syn bit is set on.
> > > >
> > > > > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
> > > >
> > > > these two above are equivalent, I just sent a patch to fix the
> > > > tcp flags & syn == syn case.
> > > >
> > > > > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > > > > syn / syn` instead, please note that while nft translates `tcp flags &
> > > > > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > > > > translation as input (when the mask is not a comma-separated list):
> > > > >
> > > > > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > > > > Error: syntax error, unexpected newline, expecting comma
> > > > > add rule meh tcp_flags tcp flags syn / syn
> > > > >                                           ^
> > > >
> > > > The most simple way to express this is: tcp flags == syn.
> > >
> > > That does not sound right to me at all. Doesn't `syn / syn` means
> > > "with the mask (the second/"denominator" `syn`) applied on the flags,
> > > we get the value (the first/"nominator" `syn`), which means `tcp flags
> > > & syn == syn` instead of `tcp flags == syn` (which in turn means all
> > > bits but syn are cleared).
> >
> > tcp flags syn / syn makes no sense, it's actually: tcp flags syn.
> >
> > The goal is to provide a compact syntax for most common operations, so
> > users do not need to be mingling with explicit binary expressions
> > (which is considered to be a "more advanced" operation).
