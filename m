Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1C8C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E53A2189D
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 11:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZF8cxF5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfH1LQB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:16:01 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46759 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfH1LQB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 07:16:01 -0400
Received: by mail-io1-f66.google.com with SMTP id x4so4933198iog.13
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 04:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVw0JIfShozrk62yR7speGwRRe3kyjx7sDzRbXicZ+s=;
        b=ZF8cxF5Mc4tvQOgMOprJVL5Dw6b/p2CHJFJmm8M2QFJCs/O8lbpExzbnENPUmeWXA3
         eh9MB7H2LzIGgPr9dt9gWf74I4MF9XQo51B5fDs0a0aXZRimOcL8qiBlGd3eELVOe0Cd
         gYUnzcOuX6nBvAeEkjtd8/5SJ2gCGD/q1jKn1hS2ANyKzBYEd3381hIEeElIjCAXKRoQ
         DMkhue6SX6lkKfFTl6HJRyXL/SzapN4K/DBegfAzOks/f45P1PghzY4VUGiVJWmcX8IV
         Fzmb8BgpWnSk+FDXzNkUK3CiQU92CqZBEdQvIZvEvPQjUAfxKHmBZCQSsIWBu5GFQLyk
         rMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVw0JIfShozrk62yR7speGwRRe3kyjx7sDzRbXicZ+s=;
        b=IDU9oFZf/dSSxRhwIWfJXWJgiRpWMXxtZJoLOdH1+KOJjViyewCod1CY+qhZ3/VFve
         Mo0Iq3EIEjK0sh4pi2pWrnu71y0X2Y3JmipdLw4B1aO/LZ5GOo1vxW4Na14Or+LBG4Dn
         BRWCmdnOQlCm8fhd+YGCTgMshxm8bVcV9PrshskRy9CSg/5WyTHjEnDepSOtXAsBaDoQ
         +hin1OVqM83rh96+ygCosvCLlCFEBFa16mYydNC0j6CwkQZBaEyOTfGAwXWyzsuBcvee
         RdwOp/COrX8JTASm0KfS3IB5txqvKdKFVf/ih9zvezN30m7w1FsXmObTYjughMkwnkff
         5OUA==
X-Gm-Message-State: APjAAAUiLt6JhIRTBMHK8XNup3ck8CJF8ShiQ1oTUxrTaiofeEa4shtv
        vNziDkEBpMkh61P5Wkc3i3zhoNzNWzgX/TXLYjk7Bavo
X-Google-Smtp-Source: APXvYqxWhq8VCaUVQk5oCO0GQPfjeByLNx1MaCrAT4PbO6lWwGXmtZ2ZL3Rx+G3NTIUOWtgPdvjMo2JINxcmBz9v1Uo=
X-Received: by 2002:a05:6638:17:: with SMTP id z23mr3733572jao.125.1566990960695;
 Wed, 28 Aug 2019 04:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190817111753.8756-1-a@juaristi.eus> <20190817111753.8756-2-a@juaristi.eus>
 <CAGdUbJFMCT9aXqPKVEVF-vvLzser+58R62mSZRZLRfaR5eJpSQ@mail.gmail.com>
 <18f3faaf-97f8-ef8c-b049-3a461c1c524c@juaristi.eus> <CAGdUbJE_ZF3Sa6WMfo_j9JRME9mZteKsGgws31c0i+ASPza=8Q@mail.gmail.com>
 <20190820192735.GW2588@breakpoint.cc>
In-Reply-To: <20190820192735.GW2588@breakpoint.cc>
From:   Jones Desougi <jones.desougi+netfilter@gmail.com>
Date:   Wed, 28 Aug 2019 13:15:48 +0200
Message-ID: <CAGdUbJFoQVtORoUtA4FhsawpwcnJBjuSaUf-AHYw6XbvkQUT_A@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] netfilter: nft_meta: support for time matching
To:     Florian Westphal <fw@strlen.de>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sorry, been away.

On Tue, Aug 20, 2019 at 9:27 PM Florian Westphal <fw@strlen.de> wrote:
>
> Jones Desougi <jones.desougi+netfilter@gmail.com> wrote:
> > On Sun, Aug 18, 2019 at 8:22 PM Ander Juaristi <a@juaristi.eus> wrote:
> > >
> > > On 17/8/19 15:43, Jones Desougi wrote:
> > > >> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > > >> index 82abaa183fc3..b83b62eb4b01 100644
> > > >> --- a/include/uapi/linux/netfilter/nf_tables.h
> > > >> +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > >> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
> > > >>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> > > >>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
> > > >>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> > > >> + * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
> > > >> + * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
> > > >
> > > > This would be clearer as NFT_META_TIME_WEEKDAY. Just day can mean a
> > > > lot of things.
> > > > Matches nicely with the added nft_meta_weekday function too.
> > >
> > > I agree with you here. Seems to me WEEKDAY is clearer.
> > >
> > > >
> > > >> + * @NFT_META_TIME_HOUR: hour of day (in seconds)
> > > >
> > > > This isn't really an hour, so why call it that (confuses unit at least)?
> > > > Something like NFT_META_TIME_TIMEOFDAY? Alternatively TIMEINDAY.
> > > > Presumably the added nft_meta_hour function also derives its name from
> > > > this, but otherwise has nothing to do with hours.
> > > >
> > >
> > > But not so sure on this one. TIMEOFDAY sounds to me equivalent to HOUR,
> > > though less explicit (more ambiguous).
> >
> > HOUR is a unit, much like NS, but its use is quite different with no
> > clear hint as to how. Unlike the latter it's also not the unit of the
> > value. From that perspective the name comes up empty of meaning. If
> > you already know what it means, the name can be put in context, but
> > that's not explicit at all.
>
> If the NFT_META_TIME_* names are off, then those for the
> frontend are too.

In part, but they are not that tightly bound. Or shouldn't be. See
regarding hour below.

>
> I think
> meta time <iso-date>
> meta hour <relative to this day>
> meta day <weekday>
>
> are fine, and thus so are the uapi enums.
>
> Examples:
>
> meta time < "2019-06-06 17:20:20" drop
> meta hour 11:00-17:00 accept
> meta day "Sat" drop
>
> What would you suggest as alternatives?

Using weekday here as well would be the obvious choice, e.g.
meta weekday "Sat" drop
Not being explicit seems bad to me, especially in the kernel interface.

However, for hour the context is different.
Hour is relevant in this frontend interface, since the time
specification is hour anchored.
An alternative implementation might use nautic 'five bells in morning
watch' or whatever for the user, but it would still translate to time
of day in seconds in the kernel interface.
