Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07375C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiEQIXG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiEQIXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:23:05 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6181AD95
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:23:04 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i15so2235989ilk.5
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=c/W0VfDzNhKjvPU5UcsKSMI3/4ht5UuzXzCD0IZjM0E=;
        b=awXr5B/w1NfXvGKuQSbn/Mfql8kuZL2FfyktFnRk8+BazaswqOPQyKqZjlw0v/4A8l
         T1bZ7oJT2iuJs/EWe+GIc77PFZxmWEIi6Stf/lV/E8N/wD/nL+KTGsVNZaXF+e3XRoQA
         vzVa6xooxwopQnmZIV/WrpmK3EgHVK26MqbaNSJYSxE0dHH9ea5OG5X3Oyv4PQ3T0Trm
         JM65urVQNJ+xtEu4KXcKRgyaEsIERZsOBRXkvik4yKrPbC5wMgdIQAw/nVPwTLrppZx1
         2n0iezQjoCg9vWc1/q3SthVYyKW+1NOwxiKMj0bxZV0r+bi5ws6ZXDSpee5MTEntBqaE
         lEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=c/W0VfDzNhKjvPU5UcsKSMI3/4ht5UuzXzCD0IZjM0E=;
        b=MLa9xHujzKO3corBXNeihefZZH77QMJCAT/oHKZAtDAPthTwPFSf1pmf5C7zmZPTme
         ZM82YdId3yfTqsI5s5pLES7SsYVDVXD9M31o2V9i9iiBujNq0dfp8o568/B9i3v+1Kia
         DZFoygUjIUv/cqCutn5iGqHVigIIKjFLiD+FS90TVTK9tYrkLZncM9okkTjcF8+VtCJf
         bDYVH33EaH6aBRFZpcXuZUbGCE7EIKMcVSyg4myoTt11H+QyY3jGFtlulDbTRZVTBqw5
         q5Jmvd0R8Rrso7/quVkTp3ThNkexKmhsxLqmHAfKkNo91F82N2qNDSaeJvuB6obvz/mJ
         IojA==
X-Gm-Message-State: AOAM5302Wdi3pbkQZYq+75+MdPV8AYutk/8AvCT1udsLlK9BTvUlQrOZ
        K2RhvdCVCIVAEFMu7a1aDC9DaAoivpC4aKz1NRJhFw==
X-Google-Smtp-Source: ABdhPJzNbierZZFbWiKU53s3wiQKRZP0m4uRnMTWa+2ZOo5zsIlxBD5FvNgvDkHxzSw49LsIly91qHXcSJPzZAylukw=
X-Received: by 2002:a05:6e02:16c7:b0:2cf:610:e217 with SMTP id
 7-20020a056e0216c700b002cf0610e217mr11540975ilx.273.1652775783312; Tue, 17
 May 2022 01:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220514163325.54266-1-vincent@systemli.org> <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc> <CANP3RGeEnEZUJtUQbjukSUC-6KBoHPF5dTD72b73Rev3hfp7MQ@mail.gmail.com>
 <YoNaMKGWLBrqIueJ@orbyte.nwl.cc>
In-Reply-To: <YoNaMKGWLBrqIueJ@orbyte.nwl.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 17 May 2022 01:22:50 -0700
Message-ID: <CANP3RGct_j9r450-7LjMK=8=A8JzPGMnmNeH7=2WVFZm8CF+-A@mail.gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
To:     Phil Sutter <phil@nwl.cc>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 1:17 AM Phil Sutter <phil@nwl.cc> wrote:
>
> On Sun, May 15, 2022 at 06:40:51AM -0700, Maciej =C5=BBenczykowski wrote:
> > On Sun, May 15, 2022 at 5:05 AM Phil Sutter <phil@nwl.cc> wrote:
> > >
> > > Hi Maciej,
> > >
> > > On Sat, May 14, 2022 at 12:14:27PM -0700, Maciej =C5=BBenczykowski wr=
ote:
> > > > On Sat, May 14, 2022 at 10:04 AM Phil Sutter <phil@nwl.cc> wrote:
> > > > > On Sat, May 14, 2022 at 06:33:24PM +0200, Nick Hainke wrote:
> > > > > > Only include <linux/if_ether.h> if glibc is used.
> > > > >
> > > > > This looks like a bug in musl? OTOH explicit include of linux/if_=
ether.h
> > > > > was added in commit c5d9a723b5159 ("fix build for missing ETH_ALE=
N
> > > > > definition"), despite netinet/ether.h being included in line 2248=
 of
> > > > > libxtables/xtables.c. So maybe *also* a bug in bionic?!
> > > >
> > > > You stripped the email you're replying to, and while I'm on lkml an=
d
> > > > netdev - with my personal account - I'm not (apparently) subscribed=
 to
> > > > netfilter-devel (or I'm not subscribed from work account).
> > >
> > > Oh, sorry for the caused inconvenience.
> > >
> > > > Either way, if my search-fu is correct you're replying to
> > > > https://marc.info/?l=3Dnetfilter-devel&m=3D165254651011397&w=3D2
> > > >
> > > > +#if defined(__GLIBC__)
> > > >  #include <linux/if_ether.h> /* ETH_ALEN */
> > > > +#endif
> > > >
> > > > and you're presumably CC'ing me due to
> > > >
> > > > https://git.netfilter.org/iptables/commit/libxtables/xtables.c?id=
=3Dc5d9a723b5159a28f547b577711787295a14fd84
> > > >
> > > > which added the include in the first place...:
> > >
> > > That's correct. I assumed that you added the include for a reason and
> > > it's breaking Nick's use-case, the two of you want to have a word wit=
h
> > > each other. :)
> > >
> > > > fix build for missing ETH_ALEN definition
> > > > (this is needed at least with bionic)
> > > >
> > > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > > >
> > > > Based on the above, clearly adding an 'if defined GLIBC' wrapper wi=
ll
> > > > break bionic...
> > > > and presumably glibc doesn't care whether the #include is done one =
way
> > > > or the other?
> > >
> > > With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> > > includes linux/if_ether.h where finally ETH_ALEN is defined.
> > >
> > > In xtables.c we definitely need netinet/ether.h for ether_aton()
> > > declaration.
> > >
> > > > Obviously it could be '#if !defined MUSL' instead...
> > >
> > > Could ...
> > >
> > > > As for the fix?  And whether glibc or musl or bionic are wrong or n=
ot...
> > > > Utterly uncertain...
> > > >
> > > > Though, I will point out #include's 2000 lines into a .c file are k=
ind of funky.
> > >
> > > ACK!
> > >
> > > > Ultimately I find
> > > > https://android.git.corp.google.com/platform/external/iptables/+/76=
08e136bd495fe734ad18a6897dd4425e1a633b%5E%21/
> > > >
> > > > +#ifdef __BIONIC__
> > > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > > > +#endif
> > >
> > > While I think musl not catching the "double" include is a bug, I'd
> > > prefer the ifdef __BIONIC__ solution since it started the "but my lib=
c
> > > needs this" game.
> > >
> > > Nick, if the above change fixes musl builds for you, would you mind
> > > submitting it formally along with a move of the netinet/ether.h inclu=
de
> > > from mid-file to top?
> > >
> > > Thanks, Phil
> >
> > Any thoughts about the rest of my email - wrt. #define __USE_BSD
> > - do you know how that is supposed to work?
>
> No, but isn't this a detail of bionic header layout?
>
> Cheers, Phil

No idea... is there actually a standard's document somewhere that
actually describes which header file should declare what (and under
what #define conditions)?

Without it, I have absolutely no idea...
glibc also has tons of headers that require #define SOMETHING before
including them in order to get them to declare certain things.

I have no idea why the #ifdef BSD guard is there in bionic... maybe
it's wrong, maybe it's compatible with some other libc header files...
It doesn't really feel like the sort of thing that would be added by
mistake (ie. it feels very intentional)...

But changing bionic (for example to remove the #ifdef), feels scarier,
because it affects all things using bionic (including android app
native code I think), as opposed to just a single file in iptables...
