Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A22ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 12:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiIAMqy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiIAMqw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 08:46:52 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8A27CCD
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 05:46:51 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id kh8so13334453qvb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2022 05:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=4KFgvD44iUcZ5dAsfdsR1zvBHtzJns362ASyOF32TIs=;
        b=O11/pQnJty2AuZqpiQvzmQvtfDFf/bIQ6qGOl3cuXs1EltGpOxgOhZujb4pT6iKwik
         ubinGgr9h42iQFJgm7TDXayoylrAxvK/Jhh6hqcKRyXTkZ0Q/PF+VHwo5LrbNTACUiJD
         5694Lc/qqnObxnAWigHqIm8rhPv9Lweess18PNUqlOl5X2iAodAEY//rrB4ZTs82zdRN
         goWSLgs0kWduwrFT7+OoMaOlZyHFXZ/PmGsN/bbqUzlT+kFnB/sCbD/bMkd0F1mhewAT
         WXLXk9HMYiClPH/lcro9ZJ1pDGNY3s4mKubgs2SiktH2qYfkQn39w5jvIcZ9pfAFCWQM
         ma5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4KFgvD44iUcZ5dAsfdsR1zvBHtzJns362ASyOF32TIs=;
        b=LTXX/BR3EYz3D8e1P7q1QsOyWdV+PKfFpZy9GPVlWbzVjVnwQRUrolXMUuHaO89pU2
         1rsxobzambFIMLB/HH+mYebHX47VEVup/eE7zwROIN5IjYvFJWZWSoXXipWIVBkxRZYM
         jnF7wWp8ipICkepNmTKhwSOlfvFh1rqDXwfo+Tr/55t79P509wfR5/fpFFarfVJ+VDhX
         jjwKXzQgWDgiZ9xY1XZWPub7eGMSOqUO5ask/6lI3r8eI03KNYCe5KuiKrkmbRfMHnLU
         WB9hR0blZMV09tahBiOARvcE1ZcHH/y0IILqUuL+zRg3YTXBejHVufEuBvOckJ4drrD0
         gOpA==
X-Gm-Message-State: ACgBeo26qgElz6a+LDXtSWgtp5Q3NVwe+6jz+PkG/3R0iUnQufyd1PW4
        5F9Zx5o7v7LUrkuJ2mfUZ3NDf9wYMdNjfVMo47vtjw==
X-Google-Smtp-Source: AA6agR42kW34DFOoR8xdmRTEI7g0q0a5kMNnTC9zQQtI5iUIn2cBt5f1OFQUdJaWCGT39v7sLtVetmHoD21osNHv6HM=
X-Received: by 2002:a0c:f34f:0:b0:498:fe52:d14c with SMTP id
 e15-20020a0cf34f000000b00498fe52d14cmr18352425qvm.47.1662036410799; Thu, 01
 Sep 2022 05:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <17c87824-7d04-c34e-bf6a-d8b874242636@tmb.nu>
In-Reply-To: <17c87824-7d04-c34e-bf6a-d8b874242636@tmb.nu>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 1 Sep 2022 08:46:34 -0400
Message-ID: <CADVnQymRgHWoWjG2Z51+v4S1HUJ2FHCt1O8=vcO2BQTMsZrMBQ@mail.gmail.com>
Subject: Re: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn
 packets only
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Backlund <tmb@tmb.nu>, Jakub Kicinski <kuba@kernel.org>,
        stable@kernel.org, patchwork-bot+netdevbpf@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 theOn Fri, Aug 12, 2022 at 9:27 PM Thomas Backlund <tmb@tmb.nu> wrote:
>
> Den 2022-08-12 kl. 22:17, skrev Jakub Kicinski:
> > On Fri, 12 Aug 2022 09:34:14 -0400 Neal Cardwell wrote:
> >> This first commit is an important bug fix for a serious bug that cause=
s
> >> TCP connection hangs for users of TCP fast open and nf_conntrack:
> >>
> >>    c7aab4f17021b netfilter: nf_conntrack_tcp: re-init for syn packets =
only
> >>
> >> We are continuing to get reports about the bug that this commit fixes.
> >>
> >> It seems this fix was only backported to v5.17 stable release, and not=
 further,
> >> due to a cherry-pick conflict, because this fix implicitly depends on =
a
> >> slightly earlier v5.17 fix in the same spot:
> >>
> >>    82b72cb94666 netfilter: conntrack: re-init state for retransmitted =
syn-ack
> >>
> >> I manually verified that the fix c7aab4f17021b can be cleanly cherry-p=
icked
> >> into the oldest (v4.9.325) and newest (v5.15.60) longterm release kern=
els as
> >> long as we first cherry-pick that related fix that it implicitly depen=
ds on:
> >>
> >> 82b72cb94666b3dbd7152bb9f441b068af7a921b
> >> netfilter: conntrack: re-init state for retransmitted syn-ack
> >>
> >> c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
> >> netfilter: nf_conntrack_tcp: re-init for syn packets only
> >>
> >> So would it be possible to backport both of those fixes with the follo=
wing
> >> cherry-picks, to all LTS stable releases?
> >>
> >> git cherry-pick 82b72cb94666b3dbd7152bb9f441b068af7a921b
> >> git cherry-pick c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
> >
> > Thanks a lot Neal! FWIW we have recently changed our process and no
> > longer handle stable submissions ourselves, so in the future feel free
> > to talk directly to stable@ (and add CC: stable@ tags to patches).
> >
> > I'm adding stable@, let's see if Greg & team can pick things up based
> > on your instructions :)
> >
>
> besides testing that they apply,
> one should also check that the resulting code actually builds...
>
> net/netfilter/nf_conntrack_proto_tcp.c: In function 'tcp_in_window':
> net/netfilter/nf_conntrack_proto_tcp.c:560:3: error: implicit
> declaration of function 'tcp_init_sender'; did you mean 'tcp_init_cwnd'?
> [-Werror=3Dimplicit-function-declaration]
>
>
>
> So this one is also needed:
> cc4f9d62037ebcb811f4908bba2986c01df1bd50
> netfilter: conntrack: move synack init code to helper
>
> for it to actually build on 5.15

Thomas =E2=80=93 thanks for catching that!

Florian, can you please confirm that the following patch series would
be a correct and sensible set of cherry-picks to backport to stable to
fix this critical nf_conntrack_tcp bug that is black-holing TCP Fast
Open connections?

# netfilter: conntrack: move synack init code to helper
git cherry-pick cc4f9d62037ebcb811f4908bba2986c01df1bd50

# netfilter: conntrack: re-init state for retransmitted syn-ack
git cherry-pick 82b72cb94666b3dbd7152bb9f441b068af7a921b

# netfilter: nf_conntrack_tcp: re-init for syn packets only
git cherry-pick c7aab4f17021b636a0ee75bcf28e06fb7c94ab48

(When applied to v4.9.325 the first one needs a trivial conflict
resolution, but the second two apply cleanly. And the kernel
compiles.)

thanks,
neal
