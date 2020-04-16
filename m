Return-Path: <SRS0=V6Sm=6A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D569FC2BA19
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Apr 2020 01:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5F72072D
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Apr 2020 01:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rg/suD2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgDPBrP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Apr 2020 21:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730833AbgDPBrF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 21:47:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7418C061A0C
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 18:47:05 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f2so5387505ilq.7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 18:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lyZ6nRPlncyNygLMcichmqCk8TVIq0z+iPizsvm+D6Q=;
        b=rg/suD2Pu9zPWJ98WA5i7V1s2Woucyouu92WDcCI/cMzyR47SZjlcNZUdfQJuPhZPH
         vs3SQBfNgvu1MM+UPB7aMUitvMx+SFux7vyrG2xde2tVRpLDtFxtIiB7j+SFeQ/J9pd8
         wJ5jJSJl8jkd/t0R62kbUXiRg+NU847fHAPMUOBPd3Yb6HsndWDE3C3haszeXUV799Xe
         Ni+1ESSoxvXF7BPhiPbodONWh+pEgz2HRMEwR4VFJUtQvqER4/5/hgoF5oAptJqZpTvl
         OovkKpQa1GRPxdTRI+DR33e1e/2nLCzoytwYLxRIIfidz0jC2z5JU/Wx6zMVcxfElQMM
         wQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lyZ6nRPlncyNygLMcichmqCk8TVIq0z+iPizsvm+D6Q=;
        b=Hc1W9SMmtqvCShwjELrvjeK5BURaN9y9Ak3B6x3PYaablaUeVTt6OIIGEa4RaLEXTG
         vMZxN+kvL0A8hpw+yMTCuhwjfijJt7c4eCSV7VpN6fa1QdqAVUl0XV6gvKvg3iXje2Hi
         KpRzEK5BuqOsWXgsuCsFDnIluqfqi3onwW0Vq5SQYsOER6zgarcVGCQxZS+VwfEiiIhH
         UCMxg8FcGeg4RaWZf7eVHpbm9IVnYFmEbm+Z3hiehoejiQM0Q2imrWXpNC9d2vvSXiy6
         c223XgcnUDf+2fFi7RkzzSFzLIUe2d/OqwJHN65ySEq6XqaJ2r1hIlE9+zcI3Rfxn7ST
         Vjyg==
X-Gm-Message-State: AGi0PuYV+VmTJ3LDEgtd9Pt4KXzbFUlPdFQ6XQ0UyFXUsfu/Qg41MK+8
        4mfcViaFzElmtUBXWz9/+Islq5Rf8dvE+7uuhwOIUxOS
X-Google-Smtp-Source: APiQypLRRlNUr/m7c5mRvxN1xVJrG/IooKy/ThLiYGAFbt3m/9djegwyx17bXcDN+sfnsgGAd12TbzpF2zrD5l+ZyGY=
X-Received: by 2002:a92:b6c4:: with SMTP id m65mr8788313ill.232.1587001624962;
 Wed, 15 Apr 2020 18:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
 <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
In-Reply-To: <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Wed, 15 Apr 2020 20:46:53 -0500
Message-ID: <CAA0dE=VCjXEmRer4EB=5sXg6D7E9g6_RXqHLPwGgcC6ag_QBxg@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Laura Garcia <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ok, my point of view has changed. Sorry; I'm trying to reconcile the
interests of different parties.

Here's the thing:

Creating a bridge between nftables and Jool, and merging Jool into
nftables, are (from my perspective) separate tasks. The former is
simple, the latter is longterm. My current pull request attempts to
address the former, but not the latter.

The former task is [0], and the latter is [1].

According to Jool's feature survey ([2]), a majority of my opinionated
users want the nftables/Jool bridge, another majority wants me to
implement MAP-T. Unfortunately, I lack the number of users who want me
to perform a formal merge between nftables and Jool, but I presume
that it has diminished ever since Jool was packaged for different
distributions. (Since installation is no longer a daunting task.)

However, I do acknowledge that merging Jool into nftables is the right
course of action, and I would like to commit in this direction.

So I propose the following order of events:

1. Merge the bridge into nftables. This will give a temporary early
solution for those who want it.
2. Implement MAP-T.
3. Merge Jool into nftables.
4. Deprecate the bridge, and eventually remove it.

Is this an acceptable compromise?

Alberto

[0] https://github.com/NICMx/Jool/issues/285
[1] https://github.com/NICMx/Jool/issues/273
[2] https://docs.google.com/forms/d/e/1FAIpQLSe_9_wBttFGd9aJ7lKXiJvIN7wWZm_C6yy3gU0Ttepha275nQ/viewanalytics

On Wed, Apr 15, 2020 at 4:41 PM Alberto Leiva <ydahhrk@gmail.com> wrote:
>
> > Looking at the code, the pool4db is pretty much an adaptation of what
> > conntrack already does. So, why not to put the efforts in extending
> > conntrack to support NAT64/NAT46 ?
>
> Ok, please don't take this as an aggressively defensive gesture, but I
> feel like this is an unfair question.
>
> If I provide a ready and simple but effective means to bridge our
> projects I feel like it befalls on you to justify why you wish to
> commit to the far more troublesome course of action.
>
> Merging the projects seems to me like several (if not many) months
> worth of development and testing, little of which would be made in
> benefit of our users. (No real functionality would be added, and some
> functionality might be dropped--eg. atomic configuration, session
> synchronization.)
>
> I mean I get that you want to avoid some duplicate functionality, but
> is this really a more important use of my time than, say, adding MAP-T
> support? ([0])
>
> > This way, the support of this natting is likely to be included in the
> > kernel vanilla and just configure it with just one rule:
> >
> > sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96
>
> Ok, but I don't think an IP translator is *meant* to be configured in
> a single line. Particularly in the case of NAT46. How do you populate
> a large EAM table ([1]) on a line? If your translator instance is
> defined entirely in a rule matched by IPv6 packets, how do you tell
> the corresponding IPv4 rule to refer to the same instance?
>
> It is my humble opinion that some level of separation between nftables
> rules and translator instances is clean design.
>
> > One more thing, it seems that jool only supports PREROUTING, is that right?
>
> Yes, although this might presently only be because nobody has asked elsewhat.
>
> I tried adding LOCAL_OUT support some years ago and forgot to write
> down the problems that prevented me from succeeding. I can give it
> another shot if this is important for you.
>
> Cheers,
> Alberto
>
> [0] https://tools.ietf.org/html/rfc7599
> [1] https://jool.mx/en/eamt.html
>
> On Wed, Apr 8, 2020 at 2:22 PM Laura Garcia <nevola@gmail.com> wrote:
> >
> > On Tue, Apr 7, 2020 at 8:03 PM Alberto Leiva Popper <ydahhrk@gmail.com> wrote:
> > >
> > > Jool statements are used to send packets to the Jool kernel module,
> > > which is an IP/ICMP translator: www.jool.mx
> > >
> > > Sample usage:
> > >
> > >         modprobe jool
> > >         jool instance add "name" --iptables -6 64:ff9b::/96
> > >         sudo nft add rule inet table1 chain1 jool nat64 "name"
> > >
> >
> > Hi Alberto,
> >
> > Looking at the code, the pool4db is pretty much an adaptation of what
> > conntrack already does. So, why not to put the efforts in extending
> > conntrack to support NAT64/NAT46 ?
> >
> > This way, the support of this natting is likely to be included in the
> > kernel vanilla and just configure it with just one rule:
> >
> > sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96
> >
> > One more thing, it seems that jool only supports PREROUTING, is that right?
> >
> > Cheers.
