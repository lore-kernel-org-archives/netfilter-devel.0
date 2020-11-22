Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04584C5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 11:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB57A20789
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 11:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiuTz2l6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgKVLDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 06:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgKVLC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 06:02:59 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2C5C0613CF
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 03:02:59 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v92so13196461ybi.4
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 03:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1cV13g1UgMcbrm4MibsDv7ibtxZukqjPEzOENlrkiZs=;
        b=AiuTz2l6PuzlBdDNrNig2uoPjFqM3XZoYIU6ICioYt9g1vYVNApKV8+PfJg5VjZ13i
         X8uGU+rP4/BR+BbSZ9P97VJfQQppPzgDf7ZiwK53elE+jFb2yENuUlDXZCvm0zlOHAXB
         FNtLVzXwnkFE48On1VtkkIWPOTO583fq+9lKMrD41gi/u9ux/CtKN9S9zKlK35VKceuA
         0Vd2AqW7YQK9BsJ1mmm/FLenl2IXU3HnLpnphZAh2AjI50Bqe5YBwWI6q4aMno50miW+
         06kLw2USSfMfMdMctWRG85QOJfoYT0qP7DddWGkb0xfnmf88xGXsxXoHolkJtUCqdfre
         GmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1cV13g1UgMcbrm4MibsDv7ibtxZukqjPEzOENlrkiZs=;
        b=EDQ7XscRlXzRmH7KxRreQXeum+K8XZrZkuu2WnHMTQ7b+AocbHYGhvpGopsOpLafEH
         vphdssj0mziLk0O7HYomQ7ohuQP6joD164uhKnEcrISRXjxDaD3c153DD3ArmFvQ1PtH
         ahPra44pG9qUWlOZlO+uaD/xsi14EvE6JQMI7cNznNJuWxMCDH/ODnv5Nc8IQiIlxFvc
         dEEmdNwv1V2CUwznvEcIuTIU+NXBHO3MYJX4kD7KIuLu2VOEydE000Ea+rJVmHEBDEm2
         clFYP0dZdig0Jj7bzhn0iP/Swc5PvqAogkgMQd6pYL6SiGenAztn5YAZo1IoP2dmEAmH
         BhsA==
X-Gm-Message-State: AOAM5332mDiaLwGxSVxToKrZB2Xj+VsR6ad0MjgcKdZxkFypCtgr69D7
        WL5lkla/aoh5hYSjFYd9LxpUIdF0ZHluM0XBt8dfJRHet33gKw==
X-Google-Smtp-Source: ABdhPJwKy7Cnq/p0PeP4qf1uiRgVUayWLZOPA+uiA6bmTUTcjqbOkzZBVxU4QbfxVBtukBcEs6ZDdIeLlO18feaXczw=
X-Received: by 2002:a25:d92:: with SMTP id 140mr28640410ybn.402.1606042978969;
 Sun, 22 Nov 2020 03:02:58 -0800 (PST)
MIME-Version: 1.0
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
 <alpine.DEB.2.23.453.2011020953550.16514@localhost> <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2011082203260.26301@blackhole.kfki.hu>
 <CAHOuc7P+vHrPofOg9FHAUMhuDu=ewxgBp2h8TxmveNoZEayfkQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2011191320240.19567@blackhole.kfki.hu> <alpine.DEB.2.23.453.2011192125050.19567@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.23.453.2011192125050.19567@blackhole.kfki.hu>
From:   Oskar Berggren <oskar.berggren@gmail.com>
Date:   Sun, 22 Nov 2020 12:02:47 +0100
Message-ID: <CAHOuc7P75AiSS6mmbeqVcnrf27cBoMAXeY815Mot21r+PwzAEQ@mail.gmail.com>
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Den tors 19 nov. 2020 kl 21:26 skrev Jozsef Kadlecsik <kadlec@netfilter.org>:
>
> Hi Oskar,
>
> On Thu, 19 Nov 2020, Jozsef Kadlecsik wrote:
>
> > > WITH the compat layer included (and the fix for
> > > list_for_each_entry_rcu), the same error appears slightly later:
> > >   CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set_core.o
> > > ...
> >
> > Could you post your compiler type and version? I cannot reproduce the
> > issue and even don't get how can it happen. The same compatibility layer
> > is/should be available when compiling pfxlen.c as at compiling
> > ipset_core.c.
>
> No need for it, I could reproduce the issue and fix it. New ipset release
> is on the way.

Thanks! Can confirm 7.9 builds successfully.

/Oskar
