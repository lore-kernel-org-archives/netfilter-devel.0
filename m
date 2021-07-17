Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7877EC636CA
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 03:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41442613BB
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 03:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhGQDab (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jul 2021 23:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhGQDaa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jul 2021 23:30:30 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD6EC06175F
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 20:27:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y4so11867884pgl.10
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 20:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=TDY+2U3bZ+/XRKcTry6hgi1dOog/QuSyW2I0CLE6qPw=;
        b=eYJf6zRidBI/5CkUtxa293k5AUXHt5Ie9jJgPHneVcwA1me+RwQB80R04kP+h+A4od
         lIX6CVT7QG4UiRdc2fgo1ItBvtAAnltKIDf/2q42iItPBZ/iHs0w04V/r5QeQmnovbNl
         PS/XVC3Ae0QqjbHwjSCRZ5cRswfoM/3uYxFSobZQ5UB6TUjsWzt/WvGe0DY5eXibo448
         wCfiMj4EgYNb3vIKCS1QMECxVGKZ91M1x2ke9wBeVKVWmxAj1s/mn8HG8bCar95uUV9U
         4tHYzj2T+QfeB5mf0FpjEXdhrVHdN+tTYeX/6rGE2qWXAKTLIX5Ftn1NY81aAJWcWLtw
         zSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=TDY+2U3bZ+/XRKcTry6hgi1dOog/QuSyW2I0CLE6qPw=;
        b=XcA9+RB1zKY7fTx9a76zib0Vv+BWKMedp1BM8trw3YPQ+OGJ8yJUSsa0UFV+nDMusO
         2qyM6Q1N+sx/HOZqyaGJwRYD5Bs+CTpaEUWh82YSdQp8JqJVI1Rv4dYvAWKnkTFI58ex
         0I0fOFwjH/M/3/ghELZewkwQ7za80u5GY9K0liZJ/bo99/qdgMH/S1izGTbyQofv3w1c
         z1RHOjgbqKr5nukXN+paa89INxj8kjNesaqG2U8tPFHvg/50WPRfFF75bvWO1mpBqazT
         4y0XQkHkbuZJS9OO2h4YdWlyqx1I6v+mZ75ILEovy313O7jbYktlehpeBUWa4xJA2/jX
         BvNQ==
X-Gm-Message-State: AOAM532w0tHCNmepTGK4yOl6dteA3x9NW2wsZnz7A5ERgohY/j+lsmLm
        q6DaBqP8uillZ21wb2qPt+U=
X-Google-Smtp-Source: ABdhPJwiOkQV3z/i5euBt5Guh8H9Vt38yub/aNRlf+ZhCbj/yd8xQc4p4xdTIZFVKmBsmqOa1seg2Q==
X-Received: by 2002:a63:d511:: with SMTP id c17mr13143289pgg.219.1626492454493;
        Fri, 16 Jul 2021 20:27:34 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u33sm11762146pfg.3.2021.07.16.20.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 20:27:33 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 17 Jul 2021 13:27:29 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YPJOIYVbWCYFB2eW@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
 <20210629093837.GA23185@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629093837.GA23185@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jun 29, 2021 at 11:38:37AM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 23, 2021 at 07:26:21PM +0200, Pablo Neira Ayuso wrote:
> > >
[...]
> > > I'd prefer if documentation is not enabled by default, ie. users have
> > > to explicitly specify --with-doxygen=yes to build documentation, so
> > > users explicitly picks what they needs.
[...]
> I'd really prefer to retain the existing default that has been in
> place for many years.
>
Agreed that was a sensible default for many years.

The man pages had obscure names and were prone to clash with other man pages,
e.g. `man tcp` got you the libnfq page instead of tcp(7) and IIRC there was even
a clash between libnfq and libmnl.

At libnfq 1.0.5 there were no such clashes, and `man {any nfq function}` got you
the documentation for that function. However, having man pages on by default
broke `make distcheck`, so it was still sensible to have them off.

Now `make distcheck` passes with man pages on by default.

So I strongly suggest it is no longer sensible to have man page creation off by
default.

For the embedded guys, let's definitely keep --with-doxygen[=yes]. They can
always say no. Or not have it installed in the first place. More of that in an
email to come,

Cheers ... Duncan.
