Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5189BC83001
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 00:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE2B2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 00:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iH5JPI4s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgD1A3Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 20:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726337AbgD1A3Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 20:29:16 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796D5C0610D5
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 17:29:16 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i16so18601251ils.12
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2020 17:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qr2EYIL2uM9KyUHO7uzr/y71J5Bb3GGf1zkBLHdB+0s=;
        b=iH5JPI4st4Z/uICRl/JqFhoUrDK4xCxsli9CEVFe5OejdLWPp61s0/P7GrSnkV2MOc
         eEHh50g4iscDlZpKicaT1yNc8yUpYyEbIyDGy01ESQEqCZVDXvvNiqJoEsUEWsdHExOU
         kR1fKtSWWsb2sEYCJLaP4g0z2l3/g2W1ujRGTHtlRpah5A/VVxCOmgaXo4BCn+yEd8mU
         zl96r8Z8VZVdt5P0Xa8Z8hUUbMIgBT0bnxlf8lT3Qr9sIm90t/FxgGId7rieWxOTLY+6
         zEjud9VUz6u9Gmxq4HwttqUxmTWqvaFg71N0YkWlYPhSZ3fXkVCh5fIqXbzgZozWc8nN
         wa0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qr2EYIL2uM9KyUHO7uzr/y71J5Bb3GGf1zkBLHdB+0s=;
        b=tMXUrEbdjeCM3IzpUpMu+2pLKLcaOSZbyJdUt42sEl3IhroVwcGiek9fdvtAFOE0PO
         mA4wAafYSIf0uPpKm1fTxYpQ+bF26FWD0rWj1LviDVHV9yS4IrSi1XTgr8uk4g2ri7XL
         84OVeVZ6Q4+AaDCLzZkh8yuFWwB1nfeltTm1vbk+uuW1sFSSL6ole2omX9uUMTpVW3gR
         srwckfIyCy8c+bsBatPolVGejM5gDkg5Ypkb3frbNlFXW5BWfx1qILNfaoxrLkX2yrF7
         m0/dFT2qPX41+5HCinqRoUa1yYq9nTEqhAX7SwZu2u5Rp+k6hsrIP8kI6Eu3maxp/VHt
         JPGg==
X-Gm-Message-State: AGi0PubfNVvl2bhMnvPW9mlRLBCX5875FXHUGYqCV0KecZWr8KXkg6XQ
        hxOUb+ZYuQ5M6fubHSKAKyhMoWxuji2oIikXUbfADkBC
X-Google-Smtp-Source: APiQypIT0jEQ/i2Ps0YZWBpNmVMou3iXKPSg30BAx8qp/IlGGjizM2N3mHAW6MomUWkhIQGfqJguMdyzJAlmaLeVPbE=
X-Received: by 2002:a05:6e02:5c5:: with SMTP id l5mr15720330ils.170.1588033755815;
 Mon, 27 Apr 2020 17:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
 <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com> <CAF90-WhkRhsY6D+NgUCjVxaT2G+hzfgaP_UP4_MUusADUPA1xQ@mail.gmail.com>
In-Reply-To: <CAF90-WhkRhsY6D+NgUCjVxaT2G+hzfgaP_UP4_MUusADUPA1xQ@mail.gmail.com>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Mon, 27 Apr 2020 19:29:04 -0500
Message-ID: <CAA0dE=VK=YusbgKS3O_h2N2YQ-edCdPFHtmDn_y4h57A64StmQ@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Laura Garcia <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ok. This looks doable. I expect to run into trouble along the way, but
I don't have any more objections for now.

Did you receive my second mail from that day?
(https://marc.info/?l=netfilter-devel&m=158700165716521&w=2)
I won't hold it against you if you refuse the bridge, I just need
something to tell my users.

On Sat, Apr 18, 2020 at 1:25 PM Laura Garcia <nevola@gmail.com> wrote:
>
> On Wed, Apr 15, 2020 at 11:41 PM Alberto Leiva <ydahhrk@gmail.com> wrote:
> >
> > > Looking at the code, the pool4db is pretty much an adaptation of what
> > > conntrack already does. So, why not to put the efforts in extending
> > > conntrack to support NAT64/NAT46 ?
> >
> > Ok, please don't take this as an aggressively defensive gesture, but I
> > feel like this is an unfair question.
> >
>
> Sorry, but I don't get your point. What I meant is that both pool4db
> and conntrack are natting machines, so extending conntrack (which is
> already integrated in the kernel) with what pool4db does could be a
> good way to go.
>
> Anyway, please let me come back to the technical discussion.
>
> > If I provide a ready and simple but effective means to bridge our
> > projects I feel like it befalls on you to justify why you wish to
> > commit to the far more troublesome course of action.
> >
> > Merging the projects seems to me like several (if not many) months
> > worth of development and testing, little of which would be made in
> > benefit of our users. (No real functionality would be added, and some
> > functionality might be dropped--eg. atomic configuration, session
> > synchronization.)
> >
>
> Atomic configuration is already supported in nftables and extending
> conntrack all the security functionalities and session replication
> with conntrackd will be also available.
>
> > I mean I get that you want to avoid some duplicate functionality, but
> > is this really a more important use of my time than, say, adding MAP-T
> > support? ([0])
> >
> > > This way, the support of this natting is likely to be included in the
> > > kernel vanilla and just configure it with just one rule:
> > >
> > > sudo nft add rule inet table1 chain1 dnat 64 64:ff9b::/96
> >
> > Ok, but I don't think an IP translator is *meant* to be configured in
> > a single line. Particularly in the case of NAT46. How do you populate
> > a large EAM table ([1]) on a line? If your translator instance is
> > defined entirely in a rule matched by IPv6 packets, how do you tell
> > the corresponding IPv4 rule to refer to the same instance?
> >
>
> nft supports maps generation from user space, so something like this
> could be configured:
>
> table inet my_table {
>     map my_eamt {
>         type ipv4_addr : ipv6_addr;
>         flags interval;
>         elements = { 192.0.2.1/32 : 2001:db8:aaaa::5/128,
>                      198.51.100.0/24 : 2001:db8:bbbb::/120,
>                      203.0.113.8/29 : 2001:db8:cccc::/125 }
>     }
> }
>
> And then, use this map to perform the nat rule:
>
> nft add rule inet my_table my_chain snat ip saddr to @my_eamt
>
> Currently, the map structure doesn't work cause the second item should
> be a singleton, but probably it can be fixed easily.
>
> > It is my humble opinion that some level of separation between nftables
> > rules and translator instances is clean design.
> >
>
> My humble opinion is that this model will be hard to accept after the
> great efforts done with nftables that joins different commands that
> were used in the age of iptables.
>
> > > One more thing, it seems that jool only supports PREROUTING, is that right?
> >
> > Yes, although this might presently only be because nobody has asked elsewhat.
> >
> > I tried adding LOCAL_OUT support some years ago and forgot to write
> > down the problems that prevented me from succeeding. I can give it
> > another shot if this is important for you.
> >
>
> My concern is that this can break the normalization of having source
> nat in the postrouting instead of in the prerouting phase. Note that
> integrating a new feature must ensure not breaking other subsystems.
>
> Cheers.
