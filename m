Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0620C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 11:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977C420820
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 11:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="n+14iuM3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfIVLuM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 07:50:12 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:32452 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfIVLuL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 07:50:11 -0400
X-Greylist: delayed 79364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2019 07:50:10 EDT
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id x8MBnmOm002048;
        Sun, 22 Sep 2019 20:49:48 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com x8MBnmOm002048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569152989;
        bh=e0LO2NCdAWPfrCQ7zpdpWdqIiGjNOGEohifdGVmgHQI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n+14iuM3gHo2Dc92TivlL2YTV9BnAhvuH4ZaY9kTQPEdMIOag80OltBAxp6wQNE0q
         UQk4miG3Jh3+SzpgBSNT3TyfVBLtzQ3nIX6hAnGUPir0e1loBVaJp8vrtSxxkkffH4
         b8BO+UhuzarrQoDisau939CfX9/OBa3G3UCJmPzdyhdrVQ1dgWqulYe3IJqtoMxWTd
         /eIbPu1rRKloHbesceTPbs5c5wlF+vzuGJcVzrtLyH2RoxNGqtbCGmAd90KtUdPjfU
         IbhiXcjr42S99W2m6oE4Hv5nH/RH49jepmxWrLF2ZYzpQbf67LJ0EW5eDe1Osb11Ga
         98+MkqduzxuSQ==
X-Nifty-SrcIP: [209.85.217.44]
Received: by mail-vs1-f44.google.com with SMTP id w195so7591995vsw.11;
        Sun, 22 Sep 2019 04:49:48 -0700 (PDT)
X-Gm-Message-State: APjAAAU1XxbxXL1c3w1ZQFPqWfLWmvmYn9nwFm9zilHO5zKO6z6fzMeF
        ROsL4099qf6AsakXwbx7RCOKc/VuFzO0tX5e3Wc=
X-Google-Smtp-Source: APXvYqwy69RHF4oJbH42DeM+6B2sx/v6WqbVGud7je70F1t49ct60LYDwHZluqQaI+ANjgC783WlTsMZ7CbS1Ao+LJ0=
X-Received: by 2002:a67:88c9:: with SMTP id k192mr7622437vsd.181.1569152987650;
 Sun, 22 Sep 2019 04:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190921134648.1259-1-yamada.masahiro@socionext.com>
 <20190922071111.3gflycy6t4jnjpd4@salvia> <20190922071315.iig2lbey5ophuipu@salvia>
In-Reply-To: <20190922071315.iig2lbey5ophuipu@salvia>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sun, 22 Sep 2019 20:49:11 +0900
X-Gmail-Original-Message-ID: <CAK7LNASAcHCJOsjrE5O8s_8WYUtbvz_4acmxQhsEZJSsoo7U5A@mail.gmail.com>
Message-ID: <CAK7LNASAcHCJOsjrE5O8s_8WYUtbvz_4acmxQhsEZJSsoo7U5A@mail.gmail.com>
Subject: Re: [PATCH] netfilter: use __u8 instead of uint8_t in uapi header
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Sep 22, 2019 at 4:13 PM Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> On Sun, Sep 22, 2019 at 09:11:11AM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Sep 21, 2019 at 10:46:48PM +0900, Masahiro Yamada wrote:
> > > When CONFIG_UAPI_HEADER_TEST=3Dy, exported headers are compile-tested=
 to
> > > make sure they can be included from user-space.
> > >
> > > Currently, linux/netfilter_bridge/ebtables.h is excluded from the tes=
t
> > > coverage. To make it join the compile-test, we need to fix the build
> > > errors attached below.
> > >
> > > For a case like this, we decided to use __u{8,16,32,64} variable type=
s
> > > in this discussion:
> > >
> > >   https://lkml.org/lkml/2019/6/5/18
> > >
> > > Build log:
> > >
> > >   CC      usr/include/linux/netfilter_bridge/ebtables.h.s
> > > In file included from <command-line>:32:0:
> > > ./usr/include/linux/netfilter_bridge/ebtables.h:126:4: error: unknown=
 type name =E2=80=98uint8_t=E2=80=99
> > >     uint8_t revision;
> > >     ^~~~~~~
> > > ./usr/include/linux/netfilter_bridge/ebtables.h:139:4: error: unknown=
 type name =E2=80=98uint8_t=E2=80=99
> > >     uint8_t revision;
> > >     ^~~~~~~
> > > ./usr/include/linux/netfilter_bridge/ebtables.h:152:4: error: unknown=
 type name =E2=80=98uint8_t=E2=80=99
> > >     uint8_t revision;
> > >     ^~~~~~~
> >
> > Applied.
>
> Patch does not apply cleanly to nf.git, I have to keep it back, sorry

Perhaps, reducing the context (git am -C<N>) might help.

Shall I rebase and resend it?

Thanks.

> $ git am /tmp/yamada.masahiro.txt -s
> Applying: netfilter: use __u8 instead of uint8_t in uapi header
> error: patch failed: usr/include/Makefile:37
> error: usr/include/Makefile: patch does not apply
> Patch failed at 0001 netfilter: use __u8 instead of uint8_t in uapi heade=
r
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".



--=20
Best Regards
Masahiro Yamada
