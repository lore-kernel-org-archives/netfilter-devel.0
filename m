Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EFBC636C9
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 05:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3189613C4
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 05:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhGQFu5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Jul 2021 01:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhGQFu5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 01:50:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416ACC06175F
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 22:48:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j3so6356356plx.7
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jul 2021 22:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=otqcpFD+cSyhbEeSrTiGKCyKfKHM95Yh27FY1TqsdIc=;
        b=cUe1F/KST6lypujgn9JlklrCwPgMIL8i0CFcTKmA/0qls+CJ0yxxUiKTqN7Q5ebKRU
         +mOhKAKyuXPy8xfdo+J2GqSsqms+LeT/htJXzZB3Q2Kf64aK9bMLY1DMmE5s9lDnriNn
         osBhGnfsfYiE33UvLJ06HIzkwq1UD8E0214z53QrQMwhtNWT+vIl2AT0zB0NpWZ2KHGU
         nC2yS/Ba6MtBXAUIVG4VpkMRVugxMrA4WQS+JM9bOOUeaRFFLPVNJ1rGaJQ2jPAfzbOg
         cS6eUGqqCU4Uc06UDsANsBqiMbQ6uCc1q6F9wPL6bkFfJMyukO6K5D/R3bb4N0Kx9Sr1
         wZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=otqcpFD+cSyhbEeSrTiGKCyKfKHM95Yh27FY1TqsdIc=;
        b=tZZu/KqDA8lL+7eRER39kQH18lkp7Fnpm3vUWBJo5TalxhPBK9bT+CJNFwuK24t1Uq
         RvcK+6qtjDVX3PoNdJ4TvDtEXpvzXODRgAb1ggP6tLaVHrFvDPANJILqm5SEmyWFzIx5
         HD3eMCfN2AJW7DpqLneJQCtwTZiz1zvg5Ta42VJ/w9t1MWNMMxfb8Z780sM10KdO9kwa
         10KFmK1GDmFErmP/skyaG+44HrgMTaA+22AdlnoKJnkMIbanhZ6lP/V+E3AqTaucH8mJ
         UjEZz7O20LGPhoBtzQyp2YEvQ0dn56CUQAhJpXRUFMi/9XQOKH0yK3h0iOte4DIwgYHe
         0pdg==
X-Gm-Message-State: AOAM533k7eV8bzLobLEUTfW+qjOi7sPjzU8tINra+1+FDBfUyp7bBNU6
        jjNwa2amw+9rhe2/TbeqPIZ+E2/6Q62aXg==
X-Google-Smtp-Source: ABdhPJzMhWqpxAfIXpcSsfoTl0d+QLpP6T/jlnszF5lVQTxnLIwZ4tIj8ky5kbYD7+YwBuG9dUqpjg==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr13345063pjq.81.1626500879635;
        Fri, 16 Jul 2021 22:47:59 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id j15sm9892244pjl.15.2021.07.16.22.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 22:47:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 17 Jul 2021 15:47:54 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YPJvChCKf14duJHb@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
 <20210629093837.GA23185@salvia>
 <YPJOIYVbWCYFB2eW@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPJOIYVbWCYFB2eW@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 11:38:37AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 27, 2021 at 02:30:55PM +1000, Duncan Roe wrote:
> > On Wed, Jun 23, 2021 at 07:26:21PM +0200, Pablo Neira Ayuso wrote:
> >
> > [...]
> > >
> > > Applied, thanks.
> > >
> > > One thing that needs a fix (both libnetfilter_queue and libmnl).
> > >
> > > If doxygen is not installed...
> > >
> > > configure: WARNING: Doxygen not found - continuing without Doxygen support

Can I suggest we change this to:

> configure: WARNING: Doxygen not found - assuming --with-doxygen = no

and set the appropriate variable (not sure how easy that is: I didn't do this
stuff originally)

How about

> libmnl configuration:
> html docs:          no
> man pages:          no

if doxygen is disabled for any reason, otherwise

> libmnl configuration:
> html docs:          yes if --enable-html else no
> man pages:          yes

i.e. never mentioning doxygen?

Cheers ... Duncan.
