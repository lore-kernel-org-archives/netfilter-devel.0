Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE35C432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 04:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62F660F23
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Aug 2021 04:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhH2ECy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 00:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhH2ECx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 00:02:53 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7673C061756
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 21:02:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t1so9970515pgv.3
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 21:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=oanxLOt6NGCD/BY7qZ5joWxbWP+E4akw6nkZqFU23rY=;
        b=tcaLrxV0LLEHeYMqihqOdil09ULlmZ1aI7R0apCKSzd4FN/vccwRMTJrodxiLVqYhR
         KuuttNTY0oUVthIop9CDNz0a0M8eQzRPNBPyfGft7Mm+4LzHgSprIBHS0ri1sihKLmF4
         6/RY6i3VYqEShzJ0uJcWS63ZarMct0UWakk7WCWwtuCOdDYNcYU4oGxgyxFsay7W8xN1
         x5jMJXPT3NLIpI3HJ1eGJFJDoNoFKYPGLNKzi/7CiiR7suJUE5PMj4ehype7FItmL7FL
         h0QXYmibdx116KtATCL6yBf5SY/uk+vPUbNA3OpkFPNLvAhT9x7YNdS4Ns4r44nJwJVF
         JPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=oanxLOt6NGCD/BY7qZ5joWxbWP+E4akw6nkZqFU23rY=;
        b=o7mKRIJRchUcEDWQo+IIjZzWFsWApHxhs1p3sdRHidXugcbMY0TTm+FrCKPmbRX7Or
         Rm6EAo8ycyaHhYLn1cbTSVdQvYVqRvN4a312DRlZ8y2oVSQOLApEXTUOitWiL9iqFysA
         sE4lG+cBJLXSYS4HoMJn4ffsImd4IqUqfNguLXM6zTK4eIIDVmd2JskoIwXFUpOupRfs
         rSve8rDeYpG0SXI+vOiIQYplyfCSnidW2G6KVBeO+9zmvz7Yd5PsTAEAcDVT6eH7h6fL
         GnWSnBhwI/jMyukoxMmb8IEqsvwhbt1mPfwKlSCtWsnWZvhdNbXPR60BcbDm94PkjVe4
         uMNQ==
X-Gm-Message-State: AOAM53290oWLMc4qreY2fTGCWIndN2zXLRsdTpFliJnoF0H3PZzpYbOw
        YMYkkoBb/9IyZCYAlPRdaCxzOhlmjkw=
X-Google-Smtp-Source: ABdhPJzgwD8rCBhCZ9abYCvYBrYuGl8WmJPbWOi+mp/VOxmJdt2wSti6gGO3b+nLcCsj/kxH3u4lwg==
X-Received: by 2002:a63:70b:: with SMTP id 11mr15297580pgh.75.1630209722100;
        Sat, 28 Aug 2021 21:02:02 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id m13sm8004720pjv.20.2021.08.28.21.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 21:02:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 29 Aug 2021 14:01:57 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: Re: libnetfilter_queue: automake portability warning
Message-ID: <YSsGtc/xAU8nHygD@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>, Jeremy Sowden <jeremy@azazel.net>
References: <YSlUpg5zfcwNiS50@azazel.net>
 <7n261qsp-or96-6559-5orp-srp285p4p6q@vanv.qr>
 <YSqSWaXwzRhhwCk9@slk1.local.net>
 <20210828202752.GA15388@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828202752.GA15388@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 10:27:52PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 29, 2021 at 05:45:29AM +1000, Duncan Roe wrote:
> > On Sat, Aug 28, 2021 at 03:39:38PM +0200, Jan Engelhardt wrote:
> > >
> > > On Friday 2021-08-27 23:09, Jeremy Sowden wrote:
> > >
> > > >Running autogen.sh gives the following output when it gets to
> > > >doxygen/Makefile.am:
> > > >
> > > >  doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
> > > >  doxygen/Makefile.am:3: (probably a GNU make extension)
> > > >
> > > >Automake doesn't understand the GNU make $(shell ...) [...]
> > >
> > > Or, third option, ditch the wildcarding and just name the sources. If going for
> > > a single Makefile (ditching recursive make), that will also be beneficial for
> > > parallel building, and the repo is not too large for such undertaking to be
> > > infeasible.
> > >
> > Certainly naming the sources would work.
> >
> > But, with wildcarding, Makefile.am works unmodified in other projects, such as
> > libmnl. Indeed I was planning to have libmnl/autogen.sh fetch both
> > doxygen/Makefile.am and doxygen/build_man.sh
> >
> > If the project ends up with a single Makefile, it could `include` nearly all of
> > the existing doxygen/Makefile.am, and autogen.sh could fetch that in other
> > projects.
>
> doxygen's Makefile.am is relatively small now.
>
> autogen.sh can be used to keep build_man.sh in sync, that should be
> good enough, my main concern is that addressed with shell script split
> off.
>
> So I'd suggest remove the wildcarding from Makefile.am too.

I pushed a v2 which does that.

Cheers ... Duncan.
