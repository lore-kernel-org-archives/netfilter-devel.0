Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18907C352A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 18:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A3E20838
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 18:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfxW90Tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBJSHP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 13:07:15 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:34075 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgBJSHO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 13:07:14 -0500
Received: by mail-io1-f52.google.com with SMTP id z193so8636912iof.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2020 10:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bB+XQresiqKD36FAcYspig/oqzw02ayNq97hEDFAqAU=;
        b=TfxW90TrZ+OgjqGfPZF1PGNJhf4+FGtxJArKyMKpDtyAssHpfYq4TyT2UPWR3xkTf+
         /E275A0dYgGcIRj9dvZvGnUdN32eStjU7db9qFwhp8yoL1jnpsP7XESGPU6cLbfHLkh5
         f9HwD+zO07ju90fATNQUpbdQHZ+aSS+vVtEloPNuSkElrkhrTnACtNWO9s3fD+uhrfiK
         5da2Lt+RH8Zyoy+nEQGnWOE2XVPGZw/O68KtY5nyZH5ydCTuGcueEUcehzXHnpRnoc/6
         ei+RMmF4NrfUTQ0su5HuS4Tep8iVjiO8HfgXIZgHluWrgfWxdzYVlJmpcvTU4u9TONgh
         9BcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bB+XQresiqKD36FAcYspig/oqzw02ayNq97hEDFAqAU=;
        b=sOeFMaZNRMcQK1pEa8Ur7/kc1zCuAxES0PpIZre9jkPSkpzsvckQnfTH/6yFss43Pi
         wVXGxJ9pYhTywauY4KhNz8mE/FM3h8gEyKd3Paw8Z5P3mWkmRHTHOTwPnDOfRWiIVsRY
         39j5IAB2nZB/n+jAXHv2Dg/ejekEBCVREuYTH0IhZWR3+tV9t6E9iCD4FWD8iaD037kn
         mI4YGdYHGtvSPVXBghDwiEoC4jXzvjPNRtsC22PedbhBycMYwoGkvofDKJdJOVr4pKCQ
         MzbK2d4q48O0DO2i2z1OxtiU99Z403XSn/dK+/ieb0yRcGR9LEMRp6bSOc5RPspGGYj3
         D6gg==
X-Gm-Message-State: APjAAAX4gAQisFSosUcJlqDjCZ6FOGc7wHmvrsxSz8s3l1eOlZXKrum+
        poElZvshhgkI9e1jKHaTEuqdDYdEVvoXjXuiWSdACuMe
X-Google-Smtp-Source: APXvYqznqX/FDcjBWHOpYtCO/T3x9aRwY02oeqSWosW13VgMcdQUL5Tet2mCtF3s8Z3oNH5QzAZOedPeCQ3jNktekx0=
X-Received: by 2002:a5e:aa0e:: with SMTP id s14mr10708552ioe.261.1581358033602;
 Mon, 10 Feb 2020 10:07:13 -0800 (PST)
MIME-Version: 1.0
References: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
 <rXj5-pS3LGR5qqyPp6xyNkKoDz7cWKa6q9fqsenNu9fsf2erlDbUoOMSB05wwuiBNeQYOwF1VkItgADSmURnjNeV0JRV7n8x_bG4gk1fR8w=@o-t.ch>
 <CAA0dE=Vs4u9ULcgJoxcf-V8eNc3Y11RQYeqC+KkKuQodqLj5Pg@mail.gmail.com>
In-Reply-To: <CAA0dE=Vs4u9ULcgJoxcf-V8eNc3Y11RQYeqC+KkKuQodqLj5Pg@mail.gmail.com>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Mon, 10 Feb 2020 12:07:02 -0600
Message-ID: <CAA0dE=WcoKYL582kLaYL9sBh+H+mxonuqBfRLiH2VOK-noX5gg@mail.gmail.com>
Subject: Re: Adding NAT64 to Netfilter
To:     Laurent Fasnacht <lf@o-t.ch>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi

I have a working prototype of a Jool wrapper for the nftables
framework. Details can be found here: [0]. Of course, it's not the
full integration you're hoping for (the rules simply send packets to a
Jool instance, in accordance to the current model), but it should keep
users happy while the transition happens.

However, I noticed that nft is not extensible (like iptables), so I
need to provide a custom nft build ([1][2]) instead of a plugin. I
don't think it's viable to expect my more casual users to build nft if
they need cooperation between Jool and nftables, thus I believe I need
to propose a merge of this early code into the nftables project.

Is this acceptable?

[0] https://github.com/NICMx/Jool/issues/285#issuecomment-575400539
[1] https://github.com/ydahhrk/nftables
[2] https://github.com/ydahhrk/libnftnl

On Tue, Jan 7, 2020 at 5:09 PM Alberto Leiva <ydahhrk@gmail.com> wrote:
>
> Hi!
>
> > In regards to the iptables approach, do you have any benchmark
> > compared to the NAT in the same stack?
>
> I think we do, but they are old to the point of pointlessness. But we
> can allocate some testing efforts in February, if you would confirm
> the desirability of this information.
>
> > In regards to the nftables approach, do you mean to integrate the RFC
> > implementations natively into the nftables infrastructure?
>
> I would say "yes," but I'm not sure we mean the same thing.
>
> Jool is currently a box of translating code that interfaces with the
> kernel by way of wrappers.
>
> ie. The Netfilter wrapper receives packets by registering itself to
> nf_register_hooks(), and the iptables wrapper receives packets by
> registering itself to xt_register_targets().
>
> What I mean by integrating Jool into nftables is to create a wrapper
> that would receive packets by means of something like
> nft_register_expr(). (I'm not entirely sure this is what I'm supposed
> to do because I haven't started analyzing this task yet. But that
> would be my starting point.)
>
> Does this answer your question?
>
> > Checking your code, it seems that you use several user space tools
> > (jool, joold) and a conntrack-like table to store the connection data.
> > As you know, in the nftables project it has been done a great effort
> > to avoid several tools for packet mangling so something natively like
> > the following would be probably required.
>
> I'm not averse to the idea of adapting code to fulfill the standards
> of the Netfilter project. Jool's core itself has naturally changed
> substantially over the years to account for emerging RFCs and feature
> requests. It wouldn't be my first major overhaul.
>
> But I admit I don't presently understand how things like the EAM table
> ([0] [1]) are meant to fit in this model.
>
> (Then again, I don't know much about nftables just yet.)
>
> [0] https://jool.mx/en/eamt.html
> [1] https://jool.mx/en/usr-flags-eamt.html
>
> > That's really great news! We (ProtonVPN) will be following the project,=
 and will be glad to help if possible.
>
> Thank you! :)
>
> On Tue, Jan 7, 2020 at 8:14 AM Laurent Fasnacht <lf@o-t.ch> wrote:
> >
> > Hello,
> >
> > =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Origina=
l Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> > On Friday, January 3, 2020 7:09 PM, Alberto Leiva <ydahhrk@gmail.com> w=
rote:
> >
> > > Hello
> > >
> >
> > > I've been working on Jool, an open source IP/ICMP translator for a
> > > while ([0]). It currently implements SIIT, NAT64 and (if everything
> > > goes according to plan) will later this year also support MAP-T. It
> > > currently works both as a Netfilter module (hooking itself to
> > > PREROUTING) or as an xtables target, and I'm soon going to start
> > > integrating it into nftables.
> >
> > That's really great news! We (ProtonVPN) will be following the project,=
 and will be glad to help if possible.
> >
> > Cheers,
> >
> > Laurent
> > ProtonVPN R&D
