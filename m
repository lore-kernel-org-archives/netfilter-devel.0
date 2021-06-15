Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCF4C48BDF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 22:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A798610A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 22:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhFOXAb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOXAb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 19:00:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A0C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 15:58:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2576418pjx.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 15:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=superloop.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1UU0uvEaQFYKmO5JVMuikjND63UC5/p1Ua2b/vQtlU=;
        b=tbmE0d1JhzQ2SkabGqQZZUrPDjlKQ2H4jquAF/cO4yl80pTL9gyy6Nnnt6q2tUem7o
         H8J4jbvdVk7sDzmKmSCj5NAEcZsyyd7jz7j/ky07fKWZ/HhA/vm5VjRwrKdQJbCMs0t3
         dG7uI0HigrPiAfiFAzu//7O+WJcGgo7VpQ29o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1UU0uvEaQFYKmO5JVMuikjND63UC5/p1Ua2b/vQtlU=;
        b=ZeI5WMdFlyRX/3KFrYqf6NZy8VEXK3SyglcSwajC14QBb4d7jkN+6nTaVrXQvc6hTO
         TpoNOO41KvKpSBmvyFHCdwQR4nBsrXRxCmMx7fpPGpYtNJT4Tr2q6/1HzvzlSPn+Iisp
         +RcbLUpYF7d2ryAQhLUWKbjATXBsD+wpd56MHWPO33G2BYSnPPgLQAb52XlrndhnucAL
         Rg0akmCMzOXMveuGbMWQRxNAw7kILj6tGdd7EKtt1ZvAJCn3i5WynbLp+B0txw8ftUMD
         A5P8RJ0SUe3HVwCi0XZtzUEd9J9ohpUKZatioYAdFgA4VX3bY1/S8VevkxrLVgcLqzQ5
         Z5CA==
X-Gm-Message-State: AOAM531M1QGrINW+DR5VSSDidixYxsTGWFNDqWwgMIwWo0R1R2yGp5L+
        gwEi3lk1vJeMKNLsOQIR8jhs3Wi2MvjJllqieNJO0xQPdgickw==
X-Google-Smtp-Source: ABdhPJxeEy0qFVJhI8IEuCBJXA56Ceno26GsKssI2L/valVyfTtHMU7TPftxzyQ3O6RPYigX8z0uGoExiAO8vir6T94=
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr7460354pjh.215.1623797905686;
 Tue, 15 Jun 2021 15:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAD353mmiYns6u5tb3XQz3Rfh_23EMES-4FX1d4pJrQwBd3NvGQ@mail.gmail.com>
 <20210615130631.GC1425@breakpoint.cc>
In-Reply-To: <20210615130631.GC1425@breakpoint.cc>
From:   Jake Owen <jake.owen@superloop.com>
Date:   Wed, 16 Jun 2021 08:58:15 +1000
Message-ID: <CAD353m=rR1zoFVSo+tF6YqCHEjuMW3UGcCZ2FLJWN5x1xAWcFg@mail.gmail.com>
Subject: Re: nfqueue hashing on TCP/UDP port
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thank you Florian. I appreciate your thoughtful reply.

> To keep host-to-host comunication on the same queue, for ftp, sip and
> other highlevel protocols where a logical connection consists of
> multiple tcp/udp flows.

That does make a lot of sense.

> I will add arbitrary hash keying to nft, its currently
> only missing from the frontend.
>
> Will put you in CC when its done.

Thank you!

> With nft this will soon be possible:
>
> queue num jhash ip daddr . tcp sport . tcp dport mod 16
>
> ... which will queue to 0-15.
>
> I don't think we need code changes to the xtables backend.

That amount of flexibility looks wonderful.
