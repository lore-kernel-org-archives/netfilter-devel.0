Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0B8C636C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 05:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A899610C7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 05:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhGRFbB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jul 2021 01:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhGRFbA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jul 2021 01:31:00 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0F0C061762
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 22:28:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 37so15313751pgq.0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 22:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=6CLArUy9WIdRHu23XIJZbH9eIcsccflHEl8HeQY0El8=;
        b=Epy4wlX6aVzaVSARd9DcJ3jQh/5Ooi3QCN6hJ3QTWPB0BeM+bcubniRmi4ulamw7gh
         T4rtf2AgsTQNQ/Rf5LmyDV8Oquh9XW9nb45fF681ArMk3ikFhri0n2w1k8/O4u4KzKIJ
         kD117wbRjOZ4E2bssnQkLG8buspQQPPDX611xjTQaWf/6JO+Vxd+3R7SBGRy4h7xR53q
         P/BDEoemTafhCqIWgFCb+KtFgi2VsI8tLzm0Sk4RuwouYg2PLygI6s1Gwfzc9icPBfnM
         ScvUZ66tpaAivuRkV33EluT93D7kyPu7YNb1v1M9r7IJMbVGvCvmSCk+fpMxNB3WmCVQ
         ORmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6CLArUy9WIdRHu23XIJZbH9eIcsccflHEl8HeQY0El8=;
        b=AXWWA4arHLosnBcBY89TL7skHUfv1y0k8W44PTnnd+fMwr5m3lW6ljmrnVy56oF8Pz
         n67oPu3sm/P28KXG7ZIv7lKYXeBkH2X5FvYl0yqD8bXwKKBMslAx6u51LueIgaTqrpDK
         ZMaK7FqUOiHHoa0qLxKPzQEooTvtxHyUz3u9kilLMV3kREV/QZBafzOZVbKiwrSaTqnG
         PlCQF3bGl6ZMnuqe0y6UFhvIvxe/5zuTe/KfF5+ClZvjilfURtUek2hDXyOkieRKnc/O
         CCYCNM5WjltHbkpXOFwq5/R/BgEY1pv/rQeM3Vy2OswRrfPkz8mhtWTNzf+/Lbn/C+W0
         5wYQ==
X-Gm-Message-State: AOAM531vbDm7/BgaXcoGytkKbRhp0mRoHg3y9fLtuXXdqdHTUP8yj9Zt
        RfadfXWcAYWzorr7zKc8Fvw=
X-Google-Smtp-Source: ABdhPJwAT2/3ZYfAiVM6AbIgfjZtDow3XssnYHEVkVb32Yj8ja6Tv6hViYCFMZhUV3rZPbQEjolBaQ==
X-Received: by 2002:a63:4e5d:: with SMTP id o29mr11696905pgl.379.1626586081762;
        Sat, 17 Jul 2021 22:28:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id h24sm12497597pjv.47.2021.07.17.22.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 22:28:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 18 Jul 2021 15:27:57 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: examples: Use
 libnetfilter_queue cached linux headers throughout
Message-ID: <YPO73XvAEFpGfmHW@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
 <20210706053648.11109-1-duncan_roe@optusnet.com.au>
 <20210706225231.GB12859@salvia>
 <YOUKPzcHr534edLs@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOUKPzcHr534edLs@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 07, 2021 at 11:58:23AM +1000, Duncan Roe wrote:
> On Wed, Jul 07, 2021 at 12:52:31AM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 06, 2021 at 03:36:48PM +1000, Duncan Roe wrote:
> > > A user will typically copy nf-queue.c, make changes and compile: picking up
> > > /usr/include/linux/nfnetlink_queue.h rather than
> > > /usr/include/libnetfilter_queue/linux_nfnetlink_queue.h as is recommended.
> > >
> > > libnetfilter_queue.h already includes linux_nfnetlink_queue.h so we only need
> > > to delete the errant line.
> > >
> > > (Running `make nf-queue` from within libnetfilter_queue/examples will get
> > > the private cached version of nfnetlink_queue.h which is not distributed).
> > >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > > v2: Don't insert a new #include
> > >     Doesn't clash with other nearby patch
> > >  examples/nf-queue.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > > index 3da2c24..e4b33b5 100644
> > > --- a/examples/nf-queue.c
> > > +++ b/examples/nf-queue.c
> > > @@ -11,7 +11,6 @@
> > >  #include <linux/netfilter/nfnetlink.h>
> > >
> > >  #include <linux/types.h>
> > > -#include <linux/netfilter/nfnetlink_queue.h>
> >
> > I remember now what the intention was.
> >
> > This include is fine as is: new applications should cache a copy of
> > nfnetlink_queue.h in their own tree, that's the recommended way to go.
> > This is the approach that we follow in other existing userspace
> > netfilter codebase (ie. the userspace program caches the kernel UAPI
> > header in the tree). The linux_nfnetlink_queue.h header is a legacy
> > file only for backward compatibility, it should not be used for new
> > software. This is not documented, the use of this include in
> > examples/nf-queue.c was intentional.
> >
> > This approach also allows to fall back to the UAPI kernel headers that
> > are installed in your system.
> >
> > Thanks.
>
> Thanks for explaining. But I do see a glitch: if you put
> > #include <libnetfilter_queue/libnetfilter_queue.h>
> before
> > #include <linux/netfilter/nfnetlink_queue.h>
> then you will get libnetfilter_queue/linux_nfnetlink_queue.h because
> libnetfilter_queue.h includes it.
>
> IMHO it's highly undesirable for the order of #include stmts to make a
> difference and we should do something about it.
>
> If you like, I can submit a patch to remove the linux_nfnetlink_queue.h include
> from libnetfilter_queue.h and add nfnetlink_queue.h to any sources which then
> fail to compile.
>
> Should I?
>
> Cheers ... Duncan.

Sent patch but forgot in-reply-to.

Cheers ... Duncan.
