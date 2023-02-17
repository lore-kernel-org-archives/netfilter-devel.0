Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7A0C636CC
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 01:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBQBHa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 20:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQBH3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 20:07:29 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E3254D2C
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 17:07:28 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-16dcb07b805so4840945fac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 17:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x/fPBMlx5DtVPheRVp81IECJwxXx2Mnz0JsPoFom1VI=;
        b=TngCKolj4pdn4uLnHhupO4cuYCKv5pOmA87mnqIf1OzR9f1bmBtxrc8IUg/u905npT
         MT6Aq0c2mT3uFz0gDWVg0hpNv+S+w0KIznWXP5LXYGI+ZAFY+VduTl0vzxu6LTsLMpUj
         syujKgNHrHx/MIMDZ8FTvA8Jzlj2UbMtUanBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/fPBMlx5DtVPheRVp81IECJwxXx2Mnz0JsPoFom1VI=;
        b=q2bqCD9hSbfeOI3KE3XJBU3fDpX6LdO1Qn2hDuYI4AC3I4JDTHW/tUGVWzNKGkmH5s
         sZ56NpGP43RTgeCu9ZrbV7lNkYA6aD4MNDz6LrRSIc1ubNRWTHdGAv4dcZpPngiSC5VZ
         KIhPHH/T0kDkbHe7XB0fWvgUULf6gTaOcSBxkfCZhw8UQgOaF5Wks7WKmQvocRC1RXvX
         ZGEjqq4hbPGXXCGznGBFS1mnynwP/mAkQ+KSlzcoCsgeIHbrFBD7dZEI+GYzDmF5fAMc
         TWAYb5On9u8vSVWqa1Ytl3wwzldONlUD9CUGR0cp3dEQjARdIztJtwUp174Rrph8v2JL
         4KOw==
X-Gm-Message-State: AO0yUKV1iq/hS28221oQejjDMxneqZdaMJkCFUsp8rHNq+YtSwW+D+iI
        oPjvfFhKc+fN8YkwpbNZvCSfWxP/OuhteMqsTskpwig5ebJ3fv3G
X-Google-Smtp-Source: AK7set9Uq29xwrxxkU9Usq5vwKFNS8GS8CVModKLQKnAePeIEllpJPtwsT2Kha54lhp6aGBLjTDbtBx7dYoHYwCj/d4=
X-Received: by 2002:a05:6870:828c:b0:16e:39d2:4c8a with SMTP id
 q12-20020a056870828c00b0016e39d24c8amr313212oae.59.1676596047235; Thu, 16 Feb
 2023 17:07:27 -0800 (PST)
MIME-Version: 1.0
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc> <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
 <20230216151822.GB14032@breakpoint.cc>
In-Reply-To: <20230216151822.GB14032@breakpoint.cc>
From:   Bryce Kahle <bryce.kahle@datadoghq.com>
Date:   Thu, 16 Feb 2023 17:07:16 -0800
Message-ID: <CALvGib_Ua9bboMeDesvVqH_yiqVKxMTxFKZeg14DvONaTiOZRA@mail.gmail.com>
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'd prefer whichever option doesn't require changes on our end. I'm
not familiar with the ins/outs of a kernel module param, but we are
running on customer hosts so we often start far later than when the
kernel module was loaded.

On Thu, Feb 16, 2023 at 7:18 AM Florian Westphal <fw@strlen.de> wrote:
>
> Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> > I have posted the reproducer at
> > https://github.com/brycekahle/netfilter-reproducer
>
> Thanks.  Resolving this in a backwards compatible way is
> intrusive because at the time the ctnetlink subscription happens
> nsid isn't set yet.
>
> We'd need a new callback in netlink_kernel_cfg so that ctnetlink
> can be informed about activation of 'allnet' option on an existing
> socket.
>
> We'd also need a new flag in netfilter/core.c for that and not in
> ctnetlink because else we'd create an unwanted module dependency in
> nf_conntrack.
>
> I can think of 3 alternative solutions:
> 1. revert back to 'default 1'.
>    I don't want to do that because for almost all conntrack use
>    cases the extension allocation is unecessary.
>
> 2. Switch netns creation behaviour to enable the extensions if
>    init_net has nf_conntrack_events=1.
>    This would require user intervention, but probably fine.
>    Downside is that this will be different from all the other
>    settings.
>
> 3. Add a module param to conntrack to override the default
>    setting.  We already have such params for accounting and timestamps.
>
> I'd go with 3).  Bryce, would that work for you?
>
> Pablo, whats your take on this?
> If you prefer I can work on the new netlink_kernel_cfg callback
> to see how intrusive it really is.
>
> Breakage scenario is:
>
> 1. Parent netns opens ctnetlink event sk
> 2. Parent netns sets ALL_NSID flag
> 3. No events from child netns, because no ctnetlink
>    event sockets were created in this netns and thus
>    conntrack objects get no event extension.
>
> Extending the existing bind callback doesn't work because
> ALL_NSID flag is set after event subscription.
