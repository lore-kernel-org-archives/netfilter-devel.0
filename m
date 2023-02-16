Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C82AC636CC
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 01:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBPBF0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Feb 2023 20:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPBFZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2023 20:05:25 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3616B2CFCE
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2023 17:05:25 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id bd6so283963oib.6
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2023 17:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MxBzyhVZMw3maMPzqSqfWpH05VTU0oOIiqaSLzTukrg=;
        b=BhgYtbAl32/0SYuuFIAxSfUXWHePdh9dHlry3GYPm86UD3zzgikrHHr4fmtwD9Xkx8
         XjBoZCszt9DzZi3NKRWZKJpMA8pGqPAdzzEzfWHE4bWSy/eVrgGfCewu1y9ubh9PQt1W
         AV33B+dvKb+wa6Ons6eUWCdYz13fCKjNqGSeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MxBzyhVZMw3maMPzqSqfWpH05VTU0oOIiqaSLzTukrg=;
        b=G5sSSzx/Sz6ISPlGfq6k8czO24hI/epUSfOBLAC+Gd4Ozdsv3pLhzlxQTOw96wh8Ko
         27/4p3i3am8cK0ExjsmIbT9v3khBZ/hyBqJLkwyszCbRSIr+N7ztfTXxnWwyf/8hK9ys
         6jOWfFncUZgXuw2/Uf4Pwh8lGOq4+pk3erV+xQdNXucw8ksMImeB7eZxp9TTAIcNG6lT
         QmmPcC4rJIIGONgOpW6C6sjVd78QxrB+84E9gXbmLg/HRWaeobUToTNMROKJXRrwHEgs
         Y0jll0C+DWZZTQ0pHEalPLAt/vLEt0xCma5pGLf5ChuzOU/4x3pur7qDGvy6Lr+2lXZs
         uP1A==
X-Gm-Message-State: AO0yUKXtcorZ/n6If3NbR7Kdd7vIAXVuKrB/IC9MxSz0JtO0qf4vzagA
        mt9+we4ecOjsvat+iw58Y3DMZMtkaUIBoTW29Ru4W1xvjyXJ60X/iEE=
X-Google-Smtp-Source: AK7set+D7lw5IMcSsHb30pcgTo5eCVO7zIpXrzHHYptvgtAHrc8DCYUV+ajAVx+O6BWkyKqoKsDMHNqooIbsA7zALFg=
X-Received: by 2002:a05:6808:3185:b0:37d:867b:4266 with SMTP id
 cd5-20020a056808318500b0037d867b4266mr36788oib.59.1676509524423; Wed, 15 Feb
 2023 17:05:24 -0800 (PST)
MIME-Version: 1.0
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc>
In-Reply-To: <20230215100236.GC9908@breakpoint.cc>
From:   Bryce Kahle <bryce.kahle@datadoghq.com>
Date:   Wed, 15 Feb 2023 17:05:13 -0800
Message-ID: <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have posted the reproducer at
https://github.com/brycekahle/netfilter-reproducer

On Wed, Feb 15, 2023 at 2:02 AM Florian Westphal <fw@strlen.de> wrote:
>
> Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> > This affects kernels 5.19+. I have git bisected the kernel with a
> > reproducer to identify the commit above. I can publish the reproducer
> > on request.
>
> Reproducer would help, thanks.
