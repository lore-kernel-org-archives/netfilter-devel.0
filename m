Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16232C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 May 2022 13:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiEONlT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 May 2022 09:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbiEONlK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 May 2022 09:41:10 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB5F2BEF
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 06:41:03 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id f4so13491812iov.2
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 06:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=F3JXdHD2dHhfx3/BDlJmlDBG6cDsMkvko5tTJzDUSeo=;
        b=Jmne2gcUrYun7dMdVkarqiCYgpv1ETKkiON0wA6trSZ/zuh9c1EZsn6MiMunrmW38Q
         Ve/z6tTaukg3Fr9DufNwvSmTIx2cJ5WiY5tH/QdOKRGmYay4AHxCF8M8yGOY0E/pakw8
         9hqyKJWLAMxnDNaU4latulUApZhAkEPuNUyVc21lmvczn1Ph79w4mlf/ymOB9qhB+ged
         FsnDBcC3AN69aVDb0SXJoP7Q9LsW9u+W1BP6OXzooMSkqrutJ9Be5lwaWjQ+lCqKSLTb
         JN78CUOxVY6V2gDJPtg/1tTM9QiRWxt+wza9ByJ0eSwncZMjsEr+85XvFyS+zk/tUB2+
         6n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=F3JXdHD2dHhfx3/BDlJmlDBG6cDsMkvko5tTJzDUSeo=;
        b=KwNQDEpfslYE2QPZx+IWeZhlXYfTFSb9YKQqIz/Yp0kt+JVd2OwwCXFrd0Hv1H9lPj
         Fsh+uyCq1rbIGA+C5hur9ktDZ9OUTU/Bel9obYJY+SuhgDv5GEhqDyaT0yOx7X0pmhXn
         aczXXtqg5C2T5TEM4qPZiaK7i4+kl1QuiuqB4fQzaCnse6iOCG2rp40/7H/LNwYasmyW
         KNW1atpjNiQYn/ii5S6vSAbnoOHLWmHS93+zDfjvVYbGl3Fltt0v42am/Wx3zNLgI8sf
         pCehrrZO5jS3dvD9NrnTtcqhZ2eTRwY+M9sifOAzb9jWO9IjOU/MuiY5b0dhXwjuv3EL
         9TYQ==
X-Gm-Message-State: AOAM532qF6x9H1P1QfgqCPPai353JaDS+3DRoNLk9xkY2MvBwH7fmFQV
        GF69yG6AlkOasPQsv660tWbFwiH3oYKIGTFC3Yr4cA==
X-Google-Smtp-Source: ABdhPJygcaCVfkno8sR+fJD1oFCrjODxSdnGs2sXO9tl9C6BJ/rYxDXF0Y/H2nA80nChugVO9NOfuAxFp3C8czthS8M=
X-Received: by 2002:a05:6638:24d5:b0:32b:983a:bfc4 with SMTP id
 y21-20020a05663824d500b0032b983abfc4mr7314622jat.85.1652622063160; Sun, 15
 May 2022 06:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220514163325.54266-1-vincent@systemli.org> <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com> <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
In-Reply-To: <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sun, 15 May 2022 06:40:51 -0700
Message-ID: <CANP3RGeEnEZUJtUQbjukSUC-6KBoHPF5dTD72b73Rev3hfp7MQ@mail.gmail.com>
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

On Sun, May 15, 2022 at 5:05 AM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Maciej,
>
> On Sat, May 14, 2022 at 12:14:27PM -0700, Maciej =C5=BBenczykowski wrote:
> > On Sat, May 14, 2022 at 10:04 AM Phil Sutter <phil@nwl.cc> wrote:
> > > On Sat, May 14, 2022 at 06:33:24PM +0200, Nick Hainke wrote:
> > > > Only include <linux/if_ether.h> if glibc is used.
> > >
> > > This looks like a bug in musl? OTOH explicit include of linux/if_ethe=
r.h
> > > was added in commit c5d9a723b5159 ("fix build for missing ETH_ALEN
> > > definition"), despite netinet/ether.h being included in line 2248 of
> > > libxtables/xtables.c. So maybe *also* a bug in bionic?!
> >
> > You stripped the email you're replying to, and while I'm on lkml and
> > netdev - with my personal account - I'm not (apparently) subscribed to
> > netfilter-devel (or I'm not subscribed from work account).
>
> Oh, sorry for the caused inconvenience.
>
> > Either way, if my search-fu is correct you're replying to
> > https://marc.info/?l=3Dnetfilter-devel&m=3D165254651011397&w=3D2
> >
> > +#if defined(__GLIBC__)
> >  #include <linux/if_ether.h> /* ETH_ALEN */
> > +#endif
> >
> > and you're presumably CC'ing me due to
> >
> > https://git.netfilter.org/iptables/commit/libxtables/xtables.c?id=3Dc5d=
9a723b5159a28f547b577711787295a14fd84
> >
> > which added the include in the first place...:
>
> That's correct. I assumed that you added the include for a reason and
> it's breaking Nick's use-case, the two of you want to have a word with
> each other. :)
>
> > fix build for missing ETH_ALEN definition
> > (this is needed at least with bionic)
> >
> > +#include <linux/if_ether.h> /* ETH_ALEN */
> >
> > Based on the above, clearly adding an 'if defined GLIBC' wrapper will
> > break bionic...
> > and presumably glibc doesn't care whether the #include is done one way
> > or the other?
>
> With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> includes linux/if_ether.h where finally ETH_ALEN is defined.
>
> In xtables.c we definitely need netinet/ether.h for ether_aton()
> declaration.
>
> > Obviously it could be '#if !defined MUSL' instead...
>
> Could ...
>
> > As for the fix?  And whether glibc or musl or bionic are wrong or not..=
.
> > Utterly uncertain...
> >
> > Though, I will point out #include's 2000 lines into a .c file are kind =
of funky.
>
> ACK!
>
> > Ultimately I find
> > https://android.git.corp.google.com/platform/external/iptables/+/7608e1=
36bd495fe734ad18a6897dd4425e1a633b%5E%21/
> >
> > +#ifdef __BIONIC__
> > +#include <linux/if_ether.h> /* ETH_ALEN */
> > +#endif
>
> While I think musl not catching the "double" include is a bug, I'd
> prefer the ifdef __BIONIC__ solution since it started the "but my libc
> needs this" game.
>
> Nick, if the above change fixes musl builds for you, would you mind
> submitting it formally along with a move of the netinet/ether.h include
> from mid-file to top?
>
> Thanks, Phil

Any thoughts about the rest of my email - wrt. #define __USE_BSD
- do you know how that is supposed to work?
