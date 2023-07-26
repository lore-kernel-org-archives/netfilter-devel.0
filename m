Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB842C001B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 12:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjGZMAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjGZMAX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 08:00:23 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F92E7E;
        Wed, 26 Jul 2023 05:00:21 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-48138949fb4so2109030e0c.1;
        Wed, 26 Jul 2023 05:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690372820; x=1690977620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0C8d55qq0/+Eur6tN53Z2zDq3kG0eUZEUIloyHUkHKI=;
        b=kcbw7pIAygPKnky8yzBlO7hZ7o4GGbZuFYECKU4DLHtq4aR2iLCfYEalhkOufp6Vym
         4DqifUbZ8YqdGhktCGwd/5LysIuYXT6QuKbYtntdtyFb4jmAgKutTy0ywhhhSjIloq1d
         cUDkk5XAf7AgcYphIBKKMMPMTT4Kn38+/s6U+etPWkl7+7CEK67f85PvfPPnfFT7BwO/
         Y/++njn5+7TeS0F/szdE9/p07L2Nzwr/PpUtiaa4xBctljdoZztBBpXrMOahXQDasvf0
         sHURRNLDV31ErqYj9in+/MXlXLm79WFlrSxj9UCtjcsolXDO95hHeDwI5y2cvfuc7oJ4
         dlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690372820; x=1690977620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0C8d55qq0/+Eur6tN53Z2zDq3kG0eUZEUIloyHUkHKI=;
        b=MtpQGjh1aABYV8r+c5dlIX6Fiqph1Kp0yuToMB+jX5+Llf0qBEBKP9Smx444uE+lMq
         KgtSJ9MuuDmglZu058nuUEhqtq6DB0LCZtjrOK5nBSkIWSfC6fY/CyqF4yF7QVzhwNI/
         +YgNXbyedn31tlGIaTYC95DUW+Tjmi91XZu9sBg/Ir545vTZ8S/TzYUyPUZxkFaUXGV4
         PTv22kwHkTlDqGNoiied+RBIh5i8FAUvCUr+p6iBjZ/Dr2RLUdEPfocJGrQWY/5jkQFR
         ZbQFvKonhRh776aa93VmITs26U821pEHlpmUbt0nIDMn0c+hl9mS2F4sU7xp7LLPQweZ
         oU6A==
X-Gm-Message-State: ABy/qLaojCNuhg4v2YdfqbJ1jdiN0+EM4O11UmjdBbbVXKB6goTYIaIm
        +lg4QTVJdGeq5dGrM8+hMvvCRJ8owv29hEzKXhg2nAJU
X-Google-Smtp-Source: APBJJlGKlakVABDzsWyJWplEA7UFkKskX8Awsy1oWJ2L7EKBABUtjyMabv27vJau8UHZTbn12pdosvc6vsBNpAtl9HE=
X-Received: by 2002:a1f:4596:0:b0:485:e984:64ca with SMTP id
 s144-20020a1f4596000000b00485e98464camr1164073vka.3.1690372820196; Wed, 26
 Jul 2023 05:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsTF21va8HhwrJc_yuVgVU6+dppEd-SdQpDjqLNFtcneQ@mail.gmail.com>
 <20230724142415.03a9d133@kernel.org> <ZMDTUHlPmns/85Kk@calendula>
In-Reply-To: <ZMDTUHlPmns/85Kk@calendula>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 26 Jul 2023 14:00:08 +0200
Message-ID: <CAA85sZs4RqJc51po=W-No-DMgWQGVa=hsRdRS5e6FG-F7SnZYA@mail.gmail.com>
Subject: Re: Kernel oops with 6.4.4 - flow offloads - NULL pointer deref
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 26, 2023 at 10:03=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> Hi,
>
> On Mon, Jul 24, 2023 at 02:24:15PM -0700, Jakub Kicinski wrote:
> > Adding netfilter to CC.
> >
> > On Sun, 23 Jul 2023 16:44:50 +0200 Ian Kumlien wrote:
> > > Running vanilla 6.4.4 with cherry picked:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/comm=
it/?h=3Dv6.4.5&id=3D7a59f29961cf97b98b02acaadf5a0b1f8dde938c
> > >
> [...]
> > > [108431.305700] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> > > [108431.311107] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> > > 0000000000000001
> > > [108431.318420] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> > > ffff9ebeda71ce58
> > > [108431.325735] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> > > ffff9ebe3d7fad58
> > > [108431.333068] R10: 0000000000000000 R11: 0000000000000003 R12:
> > > ffff9ebfafab0000
> > > [108431.340415] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> > > ffff9ebd79a0f780
> > > [108431.347764] FS:  0000000000000000(0000) GS:ffff9ebfafa80000(0000)
> > > knlGS:0000000000000000
> > > [108431.356069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [108431.362012] CR2: 0000000000000081 CR3: 000000045e99e000 CR4:
> > > 00000000003526e0
> > > [108431.369361] Call Trace:
> > > [108431.371999]  <TASK>
> > > [108431.374296] ? __die (arch/x86/kernel/dumpstack.c:421
> > > arch/x86/kernel/dumpstack.c:434)
> > > [108431.377553] ? page_fault_oops (arch/x86/mm/fault.c:707)
> > > [108431.381850] ? load_balance (kernel/sched/fair.c:10926)
> > > [108431.385884] ? exc_page_fault (arch/x86/mm/fault.c:1279
> > > arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> > > [108431.390094] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry=
.h:570)
> > > [108431.394482] ? flow_offload_teardown
> > > (./arch/x86/include/asm/bitops.h:75
> > > ./include/asm-generic/bitops/instrumented-atomic.h:42
> > > net/netfilter/nf_flow_table_core.c:362)
> > > [108431.399036] nf_flow_offload_gc_step
> > > (./arch/x86/include/asm/bitops.h:207
> > > ./arch/x86/include/asm/bitops.h:239
> > > ./include/asm-generic/bitops/instrumented-non-atomic.h:142
> > > net/netfilter/nf_flow_table_core.c:436)
>
> This crash points here.
>
> static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>                                     struct flow_offload *flow, void *data=
)
> {
>         if (nf_flow_has_expired(flow) ||
>             nf_ct_is_dying(flow->ct) ||
>             nf_flow_is_outdated(flow))
>                 flow_offload_teardown(flow);
>
>         if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) { <--
>
> Is this always reproducible on your testbed?

That's a bit unknown, I don't quite know what triggers it... I only
know it's happened twice :/
(That i've noticed - the fw runs with a watchdog and it's always been
a "uhuh... uptime is less than expected" kind of thing)

> Thanks.
