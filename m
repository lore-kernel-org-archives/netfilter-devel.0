Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87940C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 12:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6012C61215
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 12:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhJDMIw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhJDMIv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 08:08:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26597C061745
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Oct 2021 05:07:03 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id h2so36951752ybi.13
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Oct 2021 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f7MfsZry4/OrjJunVKeZLYWlePs3653mYSa9loi0D5k=;
        b=dFAXSb2jCBEqelKUhVfTkFoUag3VpnVpz/Vyz+spVBsVZn41Z32vidzXxEkVBnJ5yw
         bjU959bhe92eszqG2ENYCjfHsFpzWp9NFFQTjzhXzaolPmZzftfR7tcIlcjz0YZs5QNZ
         c6L+3n0QUYb79cFE0ucMpVu0MkYiF/TTPhi5Z/w8Wp9W2bWF0LtXkuDumJRNOLX1JfOL
         vzjh7qDKcUfoN+mp77i4GyraM2MJOHBtOl76/+Ax12f+mIP01pVSJWBc3BgZ6Jh+Mv4N
         c4Hgawlt2AB6NSw2VFNN9qHFCIJHQGr6yFHgX3TFGzdgvzVHxRQWtgtTYWdvLdrkITe5
         SXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f7MfsZry4/OrjJunVKeZLYWlePs3653mYSa9loi0D5k=;
        b=X7cwVf0Ods2Ay6CTITBqsam/La3lhsx+m99hs/Mo/tr8O3MrSWazxPDe2qAAmOEEMy
         OHVFfcc/+MbShq3nDmj7C64gv80sVJG4fFpZr8VKl6eJ7LG+JgifY3cb2dHh7Yi883Im
         3tsTVRhYUhwKbyOfYFK4iHqhenLUL6WdFwm/STEM2/RioTL4+ydeUBKzrapFu32okK7m
         sLG8Sfq1UpJ0j2uOKiR+jr/dYkXzMzkJxifoSQgGUIdUA9g3V74AdOQrHlXoD9fc2VM9
         sJ25ANF4CjnwR3coRBzf8qhLCjjTQGE2OODg20yNuTBq95DTfDH9jNN3K9MAMZ1wjr0G
         CqVg==
X-Gm-Message-State: AOAM533gd9qVpkOB8EShj2y/mQnyIR6WqC9Z0ErZzoZnjtFnUw+Qw4ZF
        z40m7wFKaJGhmfsIvZG/qEidFWLzhZA7NTHSC8tPaQScmezKr3v7
X-Google-Smtp-Source: ABdhPJxq9iOjxQm3uZKwSxTQ/3V/Rzt7mVqYm0pzG7pPIqOAdqwX89ISTTq+6hwFzca1aOecZlEWiZx+egOuL8aeI2c=
X-Received: by 2002:a25:51c2:: with SMTP id f185mr13930909ybb.479.1633349222220;
 Mon, 04 Oct 2021 05:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211004115101.1579-1-claudiajkang@gmail.com> <20211004120115.GL2935@breakpoint.cc>
In-Reply-To: <20211004120115.GL2935@breakpoint.cc>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Mon, 4 Oct 2021 21:06:26 +0900
Message-ID: <CAK+SQuTcC7GUwYjMSdGFAokq=ngPX9dSiZ3oHrP_hM=+Hgd_fA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: xt_IDLETIMER: fix panic that occurs when
 timer_type has garbage value
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, luciano.coelho@nokia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 4=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 9:01, F=
lorian Westphal <fw@strlen.de>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Juhee Kang <claudiajkang@gmail.com> wrote:
> > Currently, when the rule related to IDLETIMER is added, idletimer_tg ti=
mer
> > structure is initialized by kmalloc on executing idletimer_tg_create
> > function. However, in this process timer->timer_type is not defined to
> > a specific value. Thus, timer->timer_type has garbage value and it occu=
rs
> > kernel panic. So, this commit fixes the panic by initializing
> > timer->timer_type using kzalloc instead of kmalloc.
> >
> > Test commands:
> >     # iptables -A OUTPUT -j IDLETIMER --timeout 1 --label test
> >     $ cat /sys/class/xt_idletimer/timers/test
> >       Killed
> >
> > Splat looks like:
> >     BUG: KASAN: user-memory-access in alarm_expires_remaining+0x49/0x70
> >     Read of size 8 at addr 0000002e8c7bc4c8 by task cat/917
> >     CPU: 12 PID: 917 Comm: cat Not tainted 5.14.0+ #3 79940a339f71eb14f=
c81aee1757a20d5bf13eb0e
> >     Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ub=
untu1.1 04/01/2014
> >     Call Trace:
> >      dump_stack_lvl+0x6e/0x9c
> >      kasan_report.cold+0x112/0x117
> >      ? alarm_expires_remaining+0x49/0x70
> >      __asan_load8+0x86/0xb0
> >      alarm_expires_remaining+0x49/0x70
> >      idletimer_tg_show+0xe5/0x19b [xt_IDLETIMER 11219304af9316a21bee5ba=
9d58f76a6b9bccc6d]
>
> > Fixes: 0902b469bd250 ("netfilter: xtables: idletimer target implementat=
ion")
>
> Hmm, I don't think so.
>
> Probably:
> Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer t=
arget")
>
> ?

I will fix it and send v2 soon.
Thank you.

--=20

Best regards,
Juhee Kang
