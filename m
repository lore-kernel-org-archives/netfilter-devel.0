Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E0C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252ED205F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFgBa5dK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbfFRRaF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:30:05 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34783 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729337AbfFRRaF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:30:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so16102463otk.1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+jQ8R0Bz15R+8yNCB1xn6iDAFWKhy3qnwspt5QZPfw=;
        b=mFgBa5dKEpb9/vDi1rmZCYtfBa/tlXDZo3uodQoBZk6AixZjFlkUh8ZwqKY+HjLYx7
         Nz7LL0NGQNrbcDh6t2etUilGGiKytOayYv0ufi/vXEGCrOAszeLdGO9rh032kjDLoHK9
         oGj4kLP/xfqzJBQyLiB9KLCfGS0CmnYkOHHToxw1TX3jpTekghSMaXsCfqhw6Y8a7qHy
         kHplRrGjt2o+v5vXun0zoxawXdQV1HjyubKoN/pu4izkOjmOmX1zfay20TGBDuljasMA
         Napfscji5EyLVFb+Sr/xcJlNpSjfbA1PN/NUDJJSXgKwBVzZlFTC4ukRKoxqV6UZ3Z8G
         AhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+jQ8R0Bz15R+8yNCB1xn6iDAFWKhy3qnwspt5QZPfw=;
        b=cSIdNtOHtKVw+BS2ifynm5JhqKViUm6Xt4dAbg9rDlxbcUp4Hn1UhMZCCzE2XiyiuO
         iwO9EtFdWwL7WzOaNGCl289tTixUjy2I+P1NU6kbN3Pvsh4BLLAYvPbC4wb3zUnA8Z3H
         nfdtkXkB5N9EBez8cjsSE7A7X1ZMC9zZ+WGrVKud8KUO4L41KnhhUC0PTOLpX74pn0oY
         YvbRxJIV3LBGZEifVyrvXjwfazl87Ox//iOr2+ogKhTWeVvOj+Qo80QeV6Nuz/R48JHR
         YFGPKs3gQmZc9NuwjYFi6YSMbmz9075dYMheuvr+ZfpWI7hU4D8Lw2KQc5AkpzsFpEtt
         UieQ==
X-Gm-Message-State: APjAAAV+pIkCEk+ocx8ItQvXyJt9lPLDzkUYInUFzDLjj5Ue48NCMDvY
        KTD5OyFT738eRmTeO/r8nSHukNJJfDLiaO2CKjc=
X-Google-Smtp-Source: APXvYqx+Zu5NhOsl8aaj0lQ3JflFEIwgkZVNy6PMRN9irjXwVLkaVE8LWTrhCd8kl0TwC5HhUkYVCYN9BOca3pp5UlY=
X-Received: by 2002:a9d:6c0a:: with SMTP id f10mr10036720otq.49.1560879004944;
 Tue, 18 Jun 2019 10:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190614143144.10482-1-shekhar250198@gmail.com>
 <20190618143106.tgpedjytw74octms@egarver.localdomain> <20190618161607.3oewnnznnzm7tln4@salvia>
In-Reply-To: <20190618161607.3oewnnznnzm7tln4@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 18 Jun 2019 22:59:53 +0530
Message-ID: <CAN9XX2rHwLNQT3Doa121u_gTPwCrT0icszdFgJH8ZcWdYfSbVg@mail.gmail.com>
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to python3
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <eric@garver.life>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo!

On Tue, Jun 18, 2019 at 9:46 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Jun 18, 2019 at 10:31:06AM -0400, Eric Garver wrote:
> > On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> > > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> > >
> > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > ---
> > > The version hystory of this patch is:
> > > v1:conversion to py3 by changing the print statements.
> > > v2:add the '__future__' package for compatibility with py2 and py3.
> > > v3:solves the 'version' problem in argparse by adding a new argument.
> > > v4:uses .format() method to make print statements clearer.
> > > v5:updated the shebang and corrected the sequence of import statements.
> > > v6:resent the same with small changes
> > > v7:resent with small changes
>
> I apply this patch, then, from the nftables/tests/py/ folder I run:
>
> # python3 nft-test.py
>
> I get:
>
> INFO: Log will be available at /tmp/nftables-test.log
> Traceback (most recent call last):
>   File "nft-test.py", line 1454, in <module>
>     main()
>   File "nft-test.py", line 1422, in main
>     result = run_test_file(filename, force_all_family_option, specific_file)
>   File "nft-test.py", line 1290, in run_test_file
>     filename_path)
>   File "nft-test.py", line 774, in rule_add
>     payload_log = os.tmpfile()
> AttributeError: module 'os' has no attribute 'tmpfile'

I do not know why this error is occurring but may i suggest
you to try the v8 of the netns patch, (as it is a continuation of this patch),
if that works, we will know that there is some problem in this patch
specifically.

Thanks!
Shekhar
