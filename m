Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0492EC47082
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 12:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D97A760233
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 12:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhEaMNH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 May 2021 08:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhEaMNG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 May 2021 08:13:06 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1F3C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 31 May 2021 05:11:26 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d25so11730127ioe.1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 May 2021 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uGosNB7hXH2WWthghSXAvWuRpfaY/8soKoeLeu6pnLI=;
        b=B+HSWdd6jcoN3nTZE3EmJjeAna5mj8G/9aTLMjMzIi9rMWCwNAv9/uTCmmO93a0vOX
         Im+m7VwfGAa1Tm25fND40demrHNFf5ik48DF32qkw5JN9aRxCfdVkDLWw56OZxl5NXEm
         4DDUPLDloN3M/nRn5Hx68w/tMZOmyP4qmZBEiQenHEUKwOV54JaEfDrPGmd6mqq/Chcb
         BlS5cvhWgf1zfnq59nuPbH1gQihc8mT+oIg7yoCnS7TVAQWoZDDQMc6cOZOOus41SVgD
         JVthRNowpAanZG9xwgND7VttdQmfut2IHW+AAzQwh9/Mf8Qi0Yb7lf61R9QoYxV678Bs
         Bfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uGosNB7hXH2WWthghSXAvWuRpfaY/8soKoeLeu6pnLI=;
        b=gA7RyJzYj0RtzfWy/R1dQ5u7xLvuLk1ulnKZBOQ2+MTcb2PHuoPo3o58ihikM3uAiE
         e11ehU1z/W9jGf0GBa6kvI4NxcnbjjqYDPaKiP/PF5/M7p0wMJ3Ai8e9KbJJQ62Bay4k
         zKpi3OWEEWbTiahVNFOQJmLYQ0bVy8jhI/qHeaeTbQbpw1CyzluEgnWnfbRjhwB88m/r
         8ifGALr3nrKTiiJH6he3HCMzAhemAtS0fBh/8De1SFH2/a5ZlMBDZbrDsKkV8TSG0+hR
         N2Z6pwcPVhI+67zLdC9+WhOQBjxx5oIJc92LFxR9Rkmgw0Uvkx6rJCSm6YaAEguqT/0z
         fSXQ==
X-Gm-Message-State: AOAM531UcIpUNkDrjL/GlJBQEJYD8SvYp+rhzA3J5z4h9UjrNAGSNfdW
        SZst/zzRqEAUaP4nzlOmDmsV+pcsYyev/BPE5ht2HV6Y0437XrrY
X-Google-Smtp-Source: ABdhPJzkrf4hBFXpNTfujQwQp6Ug3WUlz8RVVWoTf580gS1xudrYBIonmShr74d7WnmxhCKmBBZyqseV6AFNYHotGyw=
X-Received: by 2002:a05:6602:242b:: with SMTP id g11mr16494371iob.105.1622463085567;
 Mon, 31 May 2021 05:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
 <20210518181730.13436-2-patrickdepinguin@gmail.com> <20210524152621.GA21404@salvia>
 <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
 <20210527193030.GA6314@salvia> <20210528171040.GB30879@breakpoint.cc>
In-Reply-To: <20210528171040.GB30879@breakpoint.cc>
From:   Thomas De Schampheleire <patrickdepinguin@gmail.com>
Date:   Mon, 31 May 2021 14:11:14 +0200
Message-ID: <CAAXf6LXNjUpE8_f2t8a+18ovWM67JXxt=JAxskkERoRaX+664g@mail.gmail.com>
Subject: Re: [ebtables PATCH 2/2] configure.ac: add option --enable-kernel-64-userland-32
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, thomas.de_schampheleire@nokia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

El vie, 28 may 2021 a las 19:10, Florian Westphal (<fw@strlen.de>) escribi=
=C3=B3:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > introduced with commit 47a6959fa331fe892a4fc3b48ca08e92045c6bda
> > > (5.13-rc1). Before that point, it seems CONFIG_COMPAT was the relevan=
t
> > > flag.
> >
> > Sorry, I got confused by this recent commit, it's indeed CONFIG_COMPAT
> > the right toggle in old kernels.
> >
> > > The checks on CONFIG_COMPAT were already introduced with commit
> > > 81e675c227ec60a0bdcbb547dc530ebee23ff931 in 2.6.34.x.
> > >
> > > I have seen this problem on Linux 4.1 and 4.9, on an Aarch64 CPU with
> > > 64-bit kernel and userspace compiled as 32-bit ARM. In both kernels,
> > > CONFIG_COMPAT was set.
> >
> > Hm, then ebtables compat is buggy.
>
> It was only ever tested with i686 binary on amd64 arch.

I have verified now again with the same procedure, i.e. build ebtables
2.0.11 without proposed patches or special flags, on following
platforms:

1.  x86_64 kernel 5.4.x + i686 userspace: ebtables works correctly

2.  aarch64 kernel 4.1.x + 32-bit ARM userspace: ebtables fails as describe=
d

As mentioned before, in both cases CONFIG_COMPAT=3Dy .


>
> Thomas, does unmodified 32bit iptables work on those arch/kernel
> combinations?

Yes, iptables 1.8.6 is used successfully without special provisioning
for bitness. We are using Buildroot 2021.02 to compile.

>
> > > So I am a bit surprised that I bump into this issue after upgrading
> > > ebtables from 2.0.10-4 to 2.0.11 where the padding was removed.
> > > According to your mail and the commits mentioned, it is supposed to
> > > work without ebtables making specific provisions for the 32/64 bit
> > > type difference.
>
> ebtables-userspace compat fixups predate the ebtables kernel side
> support, it was autoenabled on sparc64 in the old makefile:
>
> ifeq ($(shell uname -m),sparc64)
> CFLAGS+=3D-DEBT_MIN_ALIGN=3D8 -DKERNEL_64_USERSPACE_32
> endif

Yes, in the proposed changes to ebtables userspace, this kind of logic
is restored, but not based on the machine type but with an autoconf
flag.

>
> I don't even know if the ebtables compat support is compiled in on
> non-amd64.


Can you be more specific what you are referring to here?

For the kernel part, a long time ago you already created commit
81e675c227ec60a0bdcbb547dc530ebee23ff931 which is supposed to add
compatibility when CONFIG_COMPAT=3Dy. This code is still present in the
4.1.x I tested above.

So at this moment it seems to me that the kernel compat support is
effectively compiled in, and supports x86(_64) but does not support
the Aarch64/ARM combination (and perhaps others).

How to proceed now?

Thanks,
Thomas
