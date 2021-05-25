Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80836C2B9F8
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 11:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A5661260
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 11:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhEYLyJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 07:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhEYLyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 07:54:08 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79255C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2021 04:52:39 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v9so4739474ion.11
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2021 04:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LQidLYelJ4Qj7JrUfOhDqD59Re7OdQcgGrvmzk7jv6g=;
        b=iZ5bNLouicYbGmOH1QXjzj7nKUtcJjOm+T0a+UsH7bSnbBtZDfbo55115sODMaQ4+I
         OnGDfbaxBGGP/W87Sshbt1PStkoaPDBbjyuMzNX9ipUSG3wDCiIhyZw//AyL3DpXzdBN
         TytLmho0H9RbZxuuvASNfCV8o7No8klIRLwpm08EekvgEn9cBocIaxuRzFCFCrx+pw5Q
         SNl1l46L2ZMHFPVpcpb9e5g3nilIEk8r1efFJ8hXXyPg0uaCkRNzd8LAMGGqsUIO7d/g
         BcKDPkRnctE7QwZzGORJ7yUYxWzkGKL1VMYuWDc3Ohvk8yANnwnf8DkwbfHFo/OAGOJQ
         ZHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LQidLYelJ4Qj7JrUfOhDqD59Re7OdQcgGrvmzk7jv6g=;
        b=i3y8sb+N4JeFRN0ChlNdeHdOEUvgmy7eU6ksnaenGd5IMFGZY5u55+neFIxMR3GKX+
         SrjUpmPOx+RatRoeGlJglO60rkDIiL2+wbvF0rUCMk2s9GYZVXMpUr7Jc8Ik4C/UF7dT
         3GlIjwf8rS95L9Ktxa5rOTGsMXWvTKir4U1vxa5FMd1HdRWwvfE8sC31OfRVeIvK+Jdk
         pJrnHg24u8Lvz+hdQPIUup54NKyzmMEOhhfu+0Lu6lwxCaidtBHGuVohhu49i2o2y5eA
         dsXLLX5LghXmnzVY8LiGQcw5tonmicuY6vuRhwRZAdfU33vruFU/EBvqscqCwkmd2Quw
         3t/w==
X-Gm-Message-State: AOAM5311Ka9aoAZrN4Vao2ujSp0ZOc0XP2kj7/siezhAr/K9zzTCenMJ
        4MyHFL44jOg3/XaIhQ5BFEC6T7qqTX8u7t1yQBLiiMmN+sJu7Q==
X-Google-Smtp-Source: ABdhPJyokAUxXtjCCaFSQQl+a9Jvpac8bvpcXhwRCJ8Z6kA6oVSEv/p5h4tkN3CpwvbpS/cg+PC7+8wLbKbB3vkUN+8=
X-Received: by 2002:a02:aa97:: with SMTP id u23mr29755866jai.13.1621943558781;
 Tue, 25 May 2021 04:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
 <20210518181730.13436-2-patrickdepinguin@gmail.com> <20210524152621.GA21404@salvia>
In-Reply-To: <20210524152621.GA21404@salvia>
From:   Thomas De Schampheleire <patrickdepinguin@gmail.com>
Date:   Tue, 25 May 2021 13:52:27 +0200
Message-ID: <CAAXf6LUhuPYksianL75_7n_OrkAhKXGojd2NGg8zNWnJrtEQJQ@mail.gmail.com>
Subject: Re: [ebtables PATCH 2/2] configure.ac: add option --enable-kernel-64-userland-32
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, thomas.de_schampheleire@nokia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

El lun, 24 may 2021 a las 17:26, Pablo Neira Ayuso
(<pablo@netfilter.org>) escribi=C3=B3:
>
> On Tue, May 18, 2021 at 08:17:30PM +0200, Thomas De Schampheleire wrote:
> > From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
> >
> > The ebtables build system seems to assume that 'sparc64' is the
> > only case where KERNEL_64_USERSPACE_32 is relevant, but this is not tru=
e.
> > This situation can happen on many architectures, especially in embedded
> > systems. For example, an Aarch64 processor with kernel in 64-bit but
> > userland built for 32-bit Arm. Or a 64-bit MIPS Octeon III processor, w=
ith
> > userland running in the 'n32' ABI.
> >
> > While it is possible to set CFLAGS in the environment when calling the
> > configure script, the caller would need to know to not only specify
> > KERNEL_64_USERSPACE_32 but also the EBT_MIN_ALIGN value.
> >
> > Instead, add a configure option. All internal details can then be handl=
ed by
> > the configure script.
>
> Are you enabling
>
> CONFIG_NETFILTER_XTABLES_COMPAT
>
> in your kernel build?
>
> KERNEL_64_USERSPACE_32 was deprecated long time ago in favour of
> CONFIG_NETFILTER_XTABLES_COMPAT.

The option you refer to (CONFIG_NETFILTER_XTABLES_COMPAT) was
introduced with commit 47a6959fa331fe892a4fc3b48ca08e92045c6bda
(5.13-rc1). Before that point, it seems CONFIG_COMPAT was the relevant
flag. The checks on CONFIG_COMPAT were already introduced with commit
81e675c227ec60a0bdcbb547dc530ebee23ff931 in 2.6.34.x.

I have seen this problem on Linux 4.1 and 4.9, on an Aarch64 CPU with
64-bit kernel and userspace compiled as 32-bit ARM. In both kernels,
CONFIG_COMPAT was set.

So I am a bit surprised that I bump into this issue after upgrading
ebtables from 2.0.10-4 to 2.0.11 where the padding was removed.
According to your mail and the commits mentioned, it is supposed to
work without ebtables making specific provisions for the 32/64 bit
type difference.

When I apply the patches I submitted to this list, I get correct
behavior. Without them, the kernel complains and ebtables fails.

Best regards,
Thomas
