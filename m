Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64857C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 04:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405F6600D1
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 04:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhG3Ex0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 00:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhG3Ex0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 00:53:26 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E0C061765
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 21:53:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t9so2296131lfc.6
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2021 21:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=grBYJ7erHZSlS5a5sQKuTrjoGj3z8MD835xm/8tfHaw=;
        b=Ih0wa1N41VBvKHZZNWR8NT4fTFsqFiATf4L0eE8asF2fc7kRxsuNVitVuR84qiqcuL
         wh2E35xN7zIvqe0MeqJf7mun4lLQyzqfslLa91Mq/tJww8xTFu27Oh8nsXJjJGVKWx7S
         AYXNXc7OuKdWpH/5aSK3LzhWq3RExdlwaA/7FbWF1B6+k83nTP3OE2p7vyVggUBWu9gk
         NphMwzsqFzzCMBPcPscCB+B+AtTL1EU8EPBdCi3qhvZMK08vS6l6cG0O+Sla/xYxXfbH
         85LmgN8+KJjnXOVssOMDI1USlJAbUzS5w3rTRw28gS13zIHSJGLny2v5DKDAkP2rDue/
         Lo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=grBYJ7erHZSlS5a5sQKuTrjoGj3z8MD835xm/8tfHaw=;
        b=Rat1Iop2X41aJ4rpnETjKBPkc7a0ps06bvhy9T48T1ZRI6cQkWk2EH8T+vcRr9PRuR
         O84LNqoHXlHVHdpSYPIa6OpjcuuG7WwffnWVT5L0ccJmjorLMDqb2VLYPoH5CEWjizK4
         xqDd+qo6eC1Q3R/14RJQjqyCMtiN0hXOtZ/9bcqUius9Abqrrm/OPHY3gh8m7JUZJTob
         Yee6IWR7VnCNj3TggQFFK5jvh/Mze2AK4PBnLmGIeTZZ31wjRHCTbfczSqKjXFeTkUUm
         qjvLDLDTzXYWs08nFJFAYkis8QKL+jgq/XODHZcygM0OS9pwNeNPuJdjNeNhUVONpdOK
         qf8A==
X-Gm-Message-State: AOAM530m+oOf34cvUD13qL/kFbMPfHNF+bxMsVxqfXJ3317FbJC0+5Ya
        KTGYze1MTEpXtGAGhWqEOpIr+sjge8LcAIzB9Ks=
X-Google-Smtp-Source: ABdhPJyGMweSdaTuEftrAuKv26bSvhVrlPo1IKTPCV7jxYSEwB28klr9ml07ABlf13zeNY8hlU1mZJqQvtimoRzg/Cw=
X-Received: by 2002:a05:6512:40f:: with SMTP id u15mr411315lfk.531.1627620799479;
 Thu, 29 Jul 2021 21:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
 <20210727210503.GA15429@salvia> <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
 <20210729070345.GB15962@salvia> <CAGnHSEkfh57NqD2LJYKBjOXT+6kgvya67nfv0ZtaNnwsNg3diQ@mail.gmail.com>
 <CAGnHSEnGV=uFkMLWMc8ZXJ_cQUmPFtBBoMNOAYmU+dhZkda=Yw@mail.gmail.com> <CAGnHSE=hrCJUh109-r3NipZxXj0=bWSVwrVZ68_hxWeMfx0z6w@mail.gmail.com>
In-Reply-To: <CAGnHSE=hrCJUh109-r3NipZxXj0=bWSVwrVZ68_hxWeMfx0z6w@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Fri, 30 Jul 2021 12:53:07 +0800
Message-ID: <CAGnHSE=UhEsG43WC-gA0sL50-DfUVKR69fmJNL4EqB8PD7wdeQ@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To put the point of this spec into words: what's really nasty and
wrong here is that we do not use an operator when we want to perform
an operation on the comma-separated list, but instead, we make it
imply an operation *conditionally* and *implicitly*.

If you look at the spec again, every comma-separated list refers to
only a numeric value, but not whether this value should be used as a
mask or introduce another numeric value (0) for comparison.

For example, there's a reason it's fine to use `! syn` / `!
fin,rst,ack` to refer to `& syn == 0` / `& fin,rst,ack == 0`: the `!`
indicated the operation (and it's fine that it also introduces another
value, since the value never changes: it's always 0).

While I don't see a point in introducing an operator to refer to `&
list != 0`, if you insist on having a shortcut for that, with e.g. `@
syn` / `@ fin,rst,ack` at least things will be "reasonable".

Can you even document it like this with how "shortcuting" is
"beautifully" abused:

    [ == ] list: flags has the same value as list
        != list: flags has different value from list
         ! list: flags has none of the bit(s) in list set (a.k.a.
flags & list == 0)
list_a / list_b: with flags masked with list_b, flags has the same
value as list_a (a.k.a. flags & list_b == list_a)
         @ list: flags has at least one of the bits in list set
(a.k.a. flags & list != 0)

There's something you can't just "shortcut". When you do it wrong, it
does no one any good, but only makes things *seem* neat. Just `tcp
flags syn / syn` is perfectly sensical. It might look bad, but it
doesn't mean that you can do it wrong.

Regards,
Tom

On Thu, 29 Jul 2021 at 23:16, Tom Yan <tom.ty89@gmail.com> wrote:
>
> I've written sort of a specification / the grammar of how things
> should be. See if it helps you see my point and if you can find any
> problem in it:
>
> spec/grammar for comma-separated list
>
> definition: string representation of *one or more* bits, separated by comma
> example: syn fin,rst,ack
> meaning (of the comma): bitwise or
>
> When a list is matched against, the value of the list is compared
> against. Therefore the following are equivalent:
>
> tcp flags syn
> tcp flags == syn
>
> And these are equivalent:
>
> tcp flags fin,rst,ack
> tcp flags == (fin | rst | ack)
>
> The behavior of the matching / the meaning of a list *remains the
> same* when a mask is applied, hence these are also equivalent:
>
> tcp flags & syn syn
> tcp flags & syn == syn
>
> And so are these:
>
> tcp flags & (fin | rst | ack) fin,rst,ack
> tcp flags & (fin | rst | ack) == fin,rst,ack
> tcp flags & (fin | rst | ack) == (fin | rst | ack)
> tcp flags & (fin | rst | ack) (fin | rst | ack)
>
> They can be represented in an alternative "value_in_list_form /
> mask_in_list_form":
>
> tcp flags syn / syn
> tcp flags fin,rst,ack / fin,rst,ack
>
> The behavior of the matching / the meaning of a list *remains the
> same* when the operator is !=. So these are equivalent:
>
> tcp flags != syn / syn
> tcp flags & syn != syn
>
> So are these:
>
> tcp flags != fin,rst,ack / fin,rst,ack
> tcp flags & (fin | rst | ack) != (fin | rst | ack)
> tcp flags & (fin | rst | ack) != fin,rst,ack
>
> Note that != is not the same as !. What the latter means is, the
> specified list is used as the mask and the output will be compared
> with 0. So these are equivalent:
>
> tcp flags ! syn
> tcp flags & syn == 0
>
> So are these:
>
> tcp flags ! fin,rst,ack
> tcp flags & (fin | rst | ack) == 0
>
> Note that ! cannot be used on / with a mask. Therefore:
>
> tcp flags ! syn / syn
> tcp flags syn / ! syn
> tcp flags & ! syn syn
> tcp flags & syn ! syn
> ...
>
> tcp flags ! fin,rst,ack / fin,rst,ack
> tcp flags fin,rst,ack / ! fin,rst,ack
> tcp flags & ! (fin, rst, ack) fin,rst,ack
> tcp flags & (fin, rst, ack) ! fin,rst,ack
> ...
>
> are all invalid.
>
> Also, there is no simplified / shortcut form for:
>
> tcp flags & syn != 0
> tcp flags & (fin | rst | ack) != 0
>
> Although the first one is *inheritly* (i.e. by nature) equivalent to:
>
> tcp flags & syn == syn
> tcp flags & syn syn
> tcp flags syn / syn
>
> On Thu, 29 Jul 2021 at 18:58, Tom Yan <tom.ty89@gmail.com> wrote:
> >
> > Allow me to add one more supplement to what I just wrote, as you/some
> > might say something like "but allowing `ct state related,established`
> > to work as expected is intuitive and neat".
> >
> > Consider this:
> >
> > # nft --debug=netlink add rule meh tcp_flags 'ct state == new,established'
> > ip
> >   [ ct load state => reg 1 ]
> >   [ cmp eq reg 1 0x0000000a ]
> >
> > # nft list ruleset
> > table ip meh {
> >     chain tcp_flags {
> >         ct state established | new
> >     }
> > }
> >
> > If `ct state new,established` is interpreted to be the same as `ct
> > state == new,established`, at least we *will know* that we should use
> > `ct state { new, established }` instead. But when it is not, we can
> > only *suppose* it to be *practically* the same as it. (I'm quite sure
> > many people think like, "nft is just not completed/smart enough yet to
> > be able to omit the redundant curly braces"...)
> >
> > On Thu, 29 Jul 2021 at 18:41, Tom Yan <tom.ty89@gmail.com> wrote:
> > >
> > > I was quite overwhelmed by the whole thing, so I might not have made
> > > my point clear.
> > >
> > > While I find e.g. `tcp flags fin,ack,rst` being not the same as `tcp
> > > flags { fin, ack, rst }` confusing, in this case it is still
> > > "reasonable", as we can say that in the former it is a
> > > "comma-separated list" (hence no space), while in the latter it is a
> > > set (hence the spaces).
> > >
> > > The real issue here is that a comma-separated list itself can have
> > > totally different meanings. For example,
> > >
> > > 1. If (just) `fin,rst,ack`, it means "any of the bits set".
> > > 2. If `== fin,rst,ack`, it means (fin | rst | ack)
> > > 3. If `fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack). *(For
> > > both the value and the mask)*
> > > 4. If `== fin,rst,ack / fin,rst,ack`, it means (fin | rst | ack).
> > > *(For both the value and the mask)*
> > >
> > > So how could anyone have thought in the first case `fin,rst,ack` does
> > > not have the same meaning as it does in the other cases? That's what I
> > > would call "unreasonable". Also, if in any case e.g. (just) `syn` is
> > > not considered a (single-value) "comma-separated list", it's
> > > "unreasonable" as well.
> > >
> > > Or in other words, I don't find a behavior/shortcut like, "if a mask
> > > is not specified explicitly, a mask that is equal to the value is
> > > implied, yet not when we compare the value (e.g. ==)", sensible /
> > > sensical. (Would anyone?)
> > >
> > > And you know what, comparing this with the `ct state` is unfair. The
> > > fact that you did so sort of explains why we end up in this...mess.
> > > (Not trying to say it's your fault but rather, how the issue could
> > > have happened.)
> > >
> > > In the case of `ct state`, while we use the different bits for the
> > > states, the states themselves are mutually exclusive (AFAIK, e.g. a
> > > packet can't be new and established at the same time). People assume
> > > e.g. `related,established` to be *practically* equivalent to `{
> > > related, established }` not because they would think like, "generally
> > > a comma-separated list should mean any of states", but either because
> > > they know in advance a packet can only be of either, or, they assume
> > > such similar syntax should mean the same thing. (The truth is, `ct
> > > state related,established` is NOT *logically* the same as `ct state {
> > > related, established }`; the former will be true for a packet if its
> > > state can be / is related | established.)
> > >
> > > On Thu, 29 Jul 2021 at 15:03, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > On Thu, Jul 29, 2021 at 09:48:21AM +0800, Tom Yan wrote:
> > > > > I'm not sure it's just me or you that are missing something here.
> > > > >
> > > > > On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > >
> > > > > > On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > > > > > > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > > > > > > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
> > > > > >
> > > > > > Yes, those two are equivalent.
> > > > > >
> > > > > > > Does that mean `tcp flags syn` (was supposed to be and) is now
> > > > > > > equivalent to `tcp flags == syn`
> > > > > >
> > > > > > tcp flag syn
> > > > > >
> > > > > > is a shortcut to match on the syn bit regarless other bit values, it's
> > > > > > a property of the bitmask datatypes.
> > > > >
> > > > > Don't you think the syntax will be inconsistent then? As a user, it
> > > > > looks pretty irrational to me: with a mask, just `syn` checks the
> > > > > exact value of the flags (combined); without a mask, it checks and
> > > > > checks only whether the specific bit is on.
> > > > >
> > > > > At least to me I would then expect `tcp flags syn` should be
> > > > > equivalent / is a shortcut to `tcp flags & (fin | syn | rst | psh |
> > > > > ack | urg | ecn | cwr) syn` hence `tcp flags & (fin | syn | rst | psh
> > > > > | ack | urg | ecn | cwr) == syn` hence `tcp flags == syn`.
> > > >
> > > > As I said, think of a different use-case:
> > > >
> > > >         ct state new,established
> > > >
> > > > people are _not_ expecting to match on both flags to be set on (that
> > > > will actually never happen).
> > > >
> > > > Should ct state and tcp flags use the same syntax (comma-separated
> > > > values) but intepret things in a different way? I don't think so.
> > > >
> > > > You can use:
> > > >
> > > >         nft describe ct state
> > > >
> > > > to check for the real datatype behind this selector: it's a bitmask.
> > > > For this datatype the implicit operation is not ==.
> > > >
> > > > > > tcp flags == syn
> > > > > >
> > > > > > is an exact match, it checks that the syn bit is set on.
> > > > > >
> > > > > > > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
> > > > > >
> > > > > > these two above are equivalent, I just sent a patch to fix the
> > > > > > tcp flags & syn == syn case.
> > > > > >
> > > > > > > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > > > > > > syn / syn` instead, please note that while nft translates `tcp flags &
> > > > > > > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > > > > > > translation as input (when the mask is not a comma-separated list):
> > > > > > >
> > > > > > > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > > > > > > Error: syntax error, unexpected newline, expecting comma
> > > > > > > add rule meh tcp_flags tcp flags syn / syn
> > > > > > >                                           ^
> > > > > >
> > > > > > The most simple way to express this is: tcp flags == syn.
> > > > >
> > > > > That does not sound right to me at all. Doesn't `syn / syn` means
> > > > > "with the mask (the second/"denominator" `syn`) applied on the flags,
> > > > > we get the value (the first/"nominator" `syn`), which means `tcp flags
> > > > > & syn == syn` instead of `tcp flags == syn` (which in turn means all
> > > > > bits but syn are cleared).
> > > >
> > > > tcp flags syn / syn makes no sense, it's actually: tcp flags syn.
> > > >
> > > > The goal is to provide a compact syntax for most common operations, so
> > > > users do not need to be mingling with explicit binary expressions
> > > > (which is considered to be a "more advanced" operation).
