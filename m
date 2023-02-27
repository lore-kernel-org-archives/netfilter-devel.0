Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17A4C64ED8
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Feb 2023 16:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjB0QHt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Feb 2023 11:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB0QHt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2023 11:07:49 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0E321940
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2023 08:07:48 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id q11-20020a056830440b00b00693c1a62101so3851826otv.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2023 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFiFg0eUnDq5Ot/RCWwl9AYZx5PlXoh8RPwTEFIL4aE=;
        b=MtjlkVKjm9Yt6HhbxOcK1QzqhEYy9WvhfIojQCeJCW8lZef15XfxyuO/Ulaf6/VY8h
         KbnYLzyOg0lqmunLA1GsmIqCxJVoA3y/8H+1En6tjUk8TT8Hs2VS78V9h4zSZKlqKo9g
         aTu5DhliLRaeBInnmUddaxbYGboAVM313ZFaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFiFg0eUnDq5Ot/RCWwl9AYZx5PlXoh8RPwTEFIL4aE=;
        b=szIiMt4ofJZQ+Kz+qlz57wmBy/a+OEYiySHfw1bNVUp6jHvYTsZdOc+S0um4czX03o
         xipf6gxE8gPWnCsYXSazM3QopCS426c9Tji60C+BT/ZNNuY0hM/pxG69NrWtSVqDU0Bn
         EKo8SKY7tctxk4c9l+xgRTWkSzz3HeAQ8UbY+lD8d+ukXghKmXoJCPhMn2SbgooAL8xq
         8nzY8u4fbTO7sLm2HAXQPiRznd11TAiNs4ItEvT8Wgm9VEDhCBLsoLTq3yPThRHeOM8j
         Za3/cbB2z9YSMOfSIISinV2cr4SstfD1u7rUy/gpq6OAp7gOY9g2+ENcMSAdSj1UVv+9
         8Zvw==
X-Gm-Message-State: AO0yUKXKtzhOr8lJ4WT9AjGNbydpfPV0hN3Ott2/2AiA0ffGqA3vVEim
        QchVMxzo9sqv3Ts7/GMES20+FmJUGKfk2zBKxF4pA5epfnOtgt+U
X-Google-Smtp-Source: AK7set9X1vTSbeJwtMbcDryCyYLG20QzEpw2YFsFL/h7Xs2UPpPsOvsWIOeNiEbjElx2jjp1p+HkAxTOx8lSSV9jJno=
X-Received: by 2002:a9d:610c:0:b0:693:bdd8:6407 with SMTP id
 i12-20020a9d610c000000b00693bdd86407mr4379086otj.0.1677514067435; Mon, 27 Feb
 2023 08:07:47 -0800 (PST)
MIME-Version: 1.0
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc> <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
 <20230216151822.GB14032@breakpoint.cc> <Y/OHJKR7eh+DhymU@salvia>
In-Reply-To: <Y/OHJKR7eh+DhymU@salvia>
From:   Bryce Kahle <bryce.kahle@datadoghq.com>
Date:   Mon, 27 Feb 2023 08:07:36 -0800
Message-ID: <CALvGib_UWuvWYx2H6pXxJnVUkoo3_txD+SNV7WhDMjMP9KKTdQ@mail.gmail.com>
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I see there was a patch applied. Is there any chance of getting this
backported to the affected versions 5.19+, since it broke existing
functionality?

On Mon, Feb 20, 2023 at 6:43=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Thu, Feb 16, 2023 at 04:18:22PM +0100, Florian Westphal wrote:
> > Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> > > I have posted the reproducer at
> > > https://github.com/brycekahle/netfilter-reproducer
> >
> > Thanks.  Resolving this in a backwards compatible way is
> > intrusive because at the time the ctnetlink subscription happens
> > nsid isn't set yet.
> >
> > We'd need a new callback in netlink_kernel_cfg so that ctnetlink
> > can be informed about activation of 'allnet' option on an existing
> > socket.
> >
> > We'd also need a new flag in netfilter/core.c for that and not in
> > ctnetlink because else we'd create an unwanted module dependency in
> > nf_conntrack.
> >
> > I can think of 3 alternative solutions:
> > 1. revert back to 'default 1'.
> >    I don't want to do that because for almost all conntrack use
> >    cases the extension allocation is unecessary.
> >
> > 2. Switch netns creation behaviour to enable the extensions if
> >    init_net has nf_conntrack_events=3D1.
> >    This would require user intervention, but probably fine.
> >    Downside is that this will be different from all the other
> >    settings.
> >
> > 3. Add a module param to conntrack to override the default
> >    setting.  We already have such params for accounting and timestamps.
> >
> > I'd go with 3).  Bryce, would that work for you?
> >
> > Pablo, whats your take on this?
> >
> > If you prefer I can work on the new netlink_kernel_cfg callback
> > to see how intrusive it really is.
> >
> > Breakage scenario is:
> >
> > 1. Parent netns opens ctnetlink event sk
> > 2. Parent netns sets ALL_NSID flag
> > 3. No events from child netns, because no ctnetlink
> >    event sockets were created in this netns and thus
> >    conntrack objects get no event extension.
> >
> > Extending the existing bind callback doesn't work because
> > ALL_NSID flag is set after event subscription.
>
> I would prefer netlink_kernel_cfg .setsockopt callback as you suggest.
