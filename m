Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC7CC07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D009861CBD
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGGCBJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGCBI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 22:01:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B2C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 18:58:28 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v7so649334pgl.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 18:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=vujzIV2u4S3lxIyG/UnRfDo3tGZuFH2ualPJuQoDHGg=;
        b=fxU1xXiINheabWwyvwZZ5JB+m8S7PzpjO/51aqc1rNWf1tRYBUJbdFSQlOaBloV3nA
         P7P6kdGMC77sKajTgnorc/wIbegfh5x3RCQ6Hak42282R2PzRIk70iCR8a/2Ga+eRfh9
         Q4cHZ4nXtp6j+OWxGxSCKaBDx9CweHbA6kHcntDFRkvSB9jGHxYWFM86/8k5Pc/xxLb5
         ryUlG2awMtR7qoXMIi7TvOXfduXDvwVWFFz/oWjN29PAz5ExVOaCA1gBeXIowlcc4kIU
         f8kNQI00ARkpzkSUbgCpvqBdpVtn6LPctskgN6qkjJRLa6kfqfwjUbFZObmn2uE31F5I
         2k9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=vujzIV2u4S3lxIyG/UnRfDo3tGZuFH2ualPJuQoDHGg=;
        b=NaW7yYKJIw66I+YwaUZ6cSe2iYJEhjj02fZGPnOSjHVFeR/moF+GgtQdsxF7SoQywS
         04ybmuivD95KZgXFXQxdc8BJl/YUEKo70N1sEAms/rC6C6b70W5Qil8cmSCtSTDEiCo+
         vib/07QB1VMJEsbdCwmKioLRHydC1IpyUCyfJMvW7Tc6Qfi5i/2ygk5LFZU9UWGCI0iz
         sx8Z0VlOQ9O7x6lUl6Ap2imjkIQlpwj+RST4dIKIcswV6T+KmjWMT5i4ABjaOuIQUScD
         47LqHZ8ietBkBYusqHvRc8QwOyJtc3HIb//8nPIH1WFj575xqjcYXFVMDmO5VOoRv5vC
         vJyA==
X-Gm-Message-State: AOAM532KVV43iWDdbY05/LndiAHC0J+FVcUvPvxzmFcsBupRPgXTKQO+
        l+G7mKqT4W/ZOp/jiS4MHcedtRJDv14=
X-Google-Smtp-Source: ABdhPJywzdJgj+veo/P0WY09WzG3Usxb74E9KOUx6wq+l9Q2bNgrFOKKJ915i1Rm2CT/f60W5B69pQ==
X-Received: by 2002:a65:6a4c:: with SMTP id o12mr23810025pgu.446.1625623107864;
        Tue, 06 Jul 2021 18:58:27 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id 11sm19589393pge.7.2021.07.06.18.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 18:58:27 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 7 Jul 2021 11:58:23 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: examples: Use
 libnetfilter_queue cached linux headers throughout
Message-ID: <YOUKPzcHr534edLs@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
 <20210706053648.11109-1-duncan_roe@optusnet.com.au>
 <20210706225231.GB12859@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706225231.GB12859@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 07, 2021 at 12:52:31AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 06, 2021 at 03:36:48PM +1000, Duncan Roe wrote:
> > A user will typically copy nf-queue.c, make changes and compile: picking up
> > /usr/include/linux/nfnetlink_queue.h rather than
> > /usr/include/libnetfilter_queue/linux_nfnetlink_queue.h as is recommended.
> >
> > libnetfilter_queue.h already includes linux_nfnetlink_queue.h so we only need
> > to delete the errant line.
> >
> > (Running `make nf-queue` from within libnetfilter_queue/examples will get
> > the private cached version of nfnetlink_queue.h which is not distributed).
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: Don't insert a new #include
> >     Doesn't clash with other nearby patch
> >  examples/nf-queue.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > index 3da2c24..e4b33b5 100644
> > --- a/examples/nf-queue.c
> > +++ b/examples/nf-queue.c
> > @@ -11,7 +11,6 @@
> >  #include <linux/netfilter/nfnetlink.h>
> >
> >  #include <linux/types.h>
> > -#include <linux/netfilter/nfnetlink_queue.h>
>
> I remember now what the intention was.
>
> This include is fine as is: new applications should cache a copy of
> nfnetlink_queue.h in their own tree, that's the recommended way to go.
> This is the approach that we follow in other existing userspace
> netfilter codebase (ie. the userspace program caches the kernel UAPI
> header in the tree). The linux_nfnetlink_queue.h header is a legacy
> file only for backward compatibility, it should not be used for new
> software. This is not documented, the use of this include in
> examples/nf-queue.c was intentional.
>
> This approach also allows to fall back to the UAPI kernel headers that
> are installed in your system.
>
> Thanks.

Thanks for explaining. But I do see a glitch: if you put
> #include <libnetfilter_queue/libnetfilter_queue.h>
before
> #include <linux/netfilter/nfnetlink_queue.h>
then you will get libnetfilter_queue/linux_nfnetlink_queue.h because
libnetfilter_queue.h includes it.

IMHO it's highly undesirable for the order of #include stmts to make a
difference and we should do something about it.

If you like, I can submit a patch to remove the linux_nfnetlink_queue.h include
from libnetfilter_queue.h and add nfnetlink_queue.h to any sources which then
fail to compile.

Should I?

Cheers ... Duncan.
