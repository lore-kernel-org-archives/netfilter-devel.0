Return-Path: <SRS0=tTqd=EO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B177C55ABD
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 20:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0288206ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 20:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o+lHSzyf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgKHUh4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Nov 2020 15:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHUhz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Nov 2020 15:37:55 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C13EC0613CF
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2020 12:37:54 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id 2so2242880ybc.12
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2020 12:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/k9WXGwgenU9y8S3vc7U0IF9dT4fySKJeSG6P4Ph3CI=;
        b=o+lHSzyf9Ezcybl5RPkn+ZMlNzC7GvX0LVZkfB1WG2/SXyZBxDkpX5csWatqunamEg
         RLk1WbhLqAxAwajs56SOxuNd3ClTe0nujfe8OLmIrrxlAFx27Auae27J5tqKJPjI3yXo
         xD7pX76oXd91f+8LMkf5gDXiYbqKfkr+zi+z04lbhRH/SjZ6Cq7w6HkOJTmL8EVm6us+
         /GRBuX1e1lz/BzT8vgxpMuRTY3JGi3D/sJhmKNc2WPg8I8M17mtcoHrWeNj3jinLM7SZ
         c8000g9nuL+eO6R8H3/Ggb6wby+wLBs4wuee9nmueZJU9VnA0NwMFMzCLFHTOljGygXA
         Y9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/k9WXGwgenU9y8S3vc7U0IF9dT4fySKJeSG6P4Ph3CI=;
        b=iKw5bv2itbsXxm5M/DrfZurdfMqtN1+XcXHUiAj3ADa4EsTF/et5m71uZsIQq2vUjf
         K5heItD2RR/y/MGjn5/HLTDjXhGtuU7/tf/g1Dlea4VPEUQi25PaYSyYJRuUeJ1XSXvZ
         5t1uTUwTXorLBewX/i0fsU2wTb6j/B3+DwrPao87k1Nu7Y89l/EMLlQ2V655ef6QtKT+
         iH3xBF4YNY3lwKeuakSPIfImPnxu2R0h9/ULkHt9Z+cry/QmZ3nBDpsp55A8he5ZrPan
         dCEKdKb/518eZ/ttTDZFJwwdhcEWO7ExxAPRTjJBNles8ExkOuIGyogVrZwx4jiETf03
         cSTQ==
X-Gm-Message-State: AOAM532XxXlrOo1fD+NSqu1D6IoAJbNHfJ64jHW5YiGY9wcvgpUuNXgc
        IvANx509/ACQ52vxgv09J3aCFLb7KeWl0RuwmFinbFR96rSSg89R
X-Google-Smtp-Source: ABdhPJwn1B3dAunQCUSgWtJKpO6z6YNZH8DptZcoUm7QHsRCZzCKFkBuFdT+209BTqMTfb4HMdtpqMtdj6QDzO+S51E=
X-Received: by 2002:a5b:149:: with SMTP id c9mr1012654ybp.3.1604867873592;
 Sun, 08 Nov 2020 12:37:53 -0800 (PST)
MIME-Version: 1.0
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
 <alpine.DEB.2.23.453.2011020953550.16514@localhost>
In-Reply-To: <alpine.DEB.2.23.453.2011020953550.16514@localhost>
From:   Oskar Berggren <oskar.berggren@gmail.com>
Date:   Sun, 8 Nov 2020 21:37:42 +0100
Message-ID: <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com>
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Den m=C3=A5n 2 nov. 2020 kl 09:55 skrev Jozsef Kadlecsik <kadlec@netfilter.=
org>:
>
> Hi,
>
> On Sun, 1 Nov 2020, Oskar Berggren wrote:
>
> > I can build ipset 7.6 modules on 4.19.152 kernel (Debian buster
> > current stable), but 7.7 fails:
> >
> > $ configure; make
> > $ make modules
> > jhash.h:90:32 `fallthrough` undeclared
> > jhash.h:136:21 `fallthrough` undeclared
> >
> > ip_set_core.c:90:40 macro list_for_each_entry_rcu passed 4 arguments
> > but takes just 3
> > ip_set_core.c:89:2 list_for_each_entry_rcu undeclared
> >
> > Plus a few more but I think they are just because the compiler is
> > confused after the above problems.
> >
> > There are commits in 7.7 touching the above pieces of code.
>
> Does the patch fixes all the issues above?
>
> diff --git a/kernel/include/linux/jhash.h b/kernel/include/linux/jhash.h
> index 5e578b1..8df77ec 100644
> --- a/kernel/include/linux/jhash.h
> +++ b/kernel/include/linux/jhash.h
> @@ -1,5 +1,6 @@
>  #ifndef _LINUX_JHASH_H
>  #define _LINUX_JHASH_H
> +#include <linux/netfilter/ipset/ip_set_compat.h>
>
>  /* jhash.h: Jenkins hash support.
>   *


It fixes the problems listed for jhash.h, but unfortunately not for
ip_set_core.c.

There don't seem to be any compat layer for list_for_each_entry_rcu in
ipset sources.

The fourth parameter to list_for_each_entry_rcu seems to appear in
5.4-rc1 by this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D28875945ba98d1b47a8a706812b6494d165bb0a0


/Oskar
