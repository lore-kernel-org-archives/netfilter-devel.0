Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D352C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 07:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbjKOH45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 02:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOH44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 02:56:56 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E6E7
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 23:56:51 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc921a4632so58974745ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 23:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700035011; x=1700639811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=50BOdDYfJYlLjuRxm/i8F+ZVAKKZL/i6kJSVEbDIvNQ=;
        b=OYJ2fp0HkfaV0D91phhHxbioEcw2LZ3uVF0diOMC9Mhp4d+riyqgddJeyNsjX+gkgN
         Mn4gHUVLmxwhb4/KnOWP76vzfrEFcO/aPcMtMVuFmGcfJicGa6mPOdZ0vUT8aXClGMn6
         84Ft10tSoYBLeNHNDcmjp1OYDkbtVUNg4R70KCTmCOPp49Q53rB8twTltdJ4ERKocgw6
         vIs7Gol89US7QwCOumrVudURZZujbJdkbjyTEnoHjgtkNfA0ocb9IimwFDLxGRj5jtzH
         pCfWJG4UPcv6D/B9jhrYYte0tZqIV9NRpgziUEHzEf4u01vnGQOvrQe6CiDBDcvWovn/
         VNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700035011; x=1700639811;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50BOdDYfJYlLjuRxm/i8F+ZVAKKZL/i6kJSVEbDIvNQ=;
        b=Wb/plvm/eJ2pi1ZILN46bHTRRFmapf2IHgjSMLZLDN4EW/X5dKs8eg7B/ClQncFDcH
         e8H8mYX1BNVZ8Oi2Cju2UER41IuiSCGrUQp2d1IFR1tSxoxqaKx7ZEycLFsRk3jKZPlH
         Awu/cEg6WUWEvToYHKlzjov7xc7wlnjZbRYBYHNYg/edaDJDM4cpqg8yDlJENRf7P1dO
         0nIrxuRnjNO1nUTZQ1RV+I5zgsZ0pPB4JBRjow8x/f5hKyezPFxtnu2sfLsECdJq2lSq
         t4i6nH5xR2fey/7IHWl6JYJfYmRgQ2JLsS0GISGAXWZDSjn/I522sxmvrzQda0CsyxBG
         d9eQ==
X-Gm-Message-State: AOJu0YwFYTemA55H5yu/YJnhv2auoBvq6nyOP/Hantojs0ds2LQBkkTO
        Xh5bpkkv4G6N0Dw0doRP6FWdW5rIfkI=
X-Google-Smtp-Source: AGHT+IGkO5NKizJja1Y1MYdQ0gqFZhSyDt+uFHFWW/AhO4xllyJVNavtrBDSoEFO4Ot45mmwO/V7gw==
X-Received: by 2002:a17:902:d4ce:b0:1ce:15cb:630b with SMTP id o14-20020a170902d4ce00b001ce15cb630bmr6088166plg.54.1700035011187;
        Tue, 14 Nov 2023 23:56:51 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c24c00b001c7453fae33sm6811153plg.280.2023.11.14.23.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 23:56:50 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 18:56:47 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] utils: Add example of setting socket
 buffer size
Message-ID: <ZVR5v0wQXXgVn+w1@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231110041604.11564-1-duncan_roe@optusnet.com.au>
 <ZVOQsqQg9P+ymB6e@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVOQsqQg9P+ymB6e@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc'ing list this time

----- Forwarded message from Duncan Roe <dunc@slk15.local.net> -----

Date: Wed, 15 Nov 2023 10:46:34 +1100
From: Duncan Roe <dunc@slk15.local.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue] utils: Add example of setting socket buffer size

Hi Pablo,

On Tue, Nov 14, 2023 at 04:22:26PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 10, 2023 at 03:16:04PM +1100, Duncan Roe wrote:
> > The libnetfilter_queue main HTML page mentions nfnl_rcvbufsiz() so the new
> > libmnl-only libnetfilter_queue will have to support it.
> >
> > The added call acts as a demo and a test case.
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  utils/nfqnl_test.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
> > index 682f3d7..6d2305e 100644
> > --- a/utils/nfqnl_test.c
> > +++ b/utils/nfqnl_test.c
> > @@ -91,6 +91,7 @@ int main(int argc, char **argv)
> >     int fd;
> >     int rv;
> >     uint32_t queue = 0;
> > +   uint32_t ret;
> >     char buf[4096] __attribute__ ((aligned));
> >
> >     if (argc == 2) {
> > @@ -107,6 +108,10 @@ int main(int argc, char **argv)
> >             fprintf(stderr, "error during nfq_open()\n");
> >             exit(1);
> >     }
> > +   printf("setting socket buffer size to 2MB\n");
> > +   ret = nfnl_rcvbufsiz(nfq_nfnlh(h), 1024 * 1024);
>
> libnfnetlink is deprecated.

Yes I know that, obviously:)
>
> maybe call setsockopt and use nfq_fd() instead if you would like that
> this shows in the example file.
>
> > +   printf("Read buffer set to 0x%x bytes (%gMB)\n", ret,
> > +          ret / 1024.0 / 1024);
> >
> >     printf("unbinding existing nf_queue handler for AF_INET (if any)\n");
> >     if (nfq_unbind_pf(h, AF_INET) < 0) {
> > --
> > 2.35.8
> >

The point here is that nfnl_rcvbufsiz() has been advertised in the main page of
libnetfilter_queue HTML for a long time and there are likely a number of systems
out there that use it. When libnfnetlink is removed, libnetfilter_queue will
have to provide nfnl_rcvbufsiz() or those systems will start failing.

I have in mind that although libnetfilter_queue will provide nfnl_rcvbufsiz(),
there will be no documentation for it.

You will see in
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231112065922.3414-2-duncan_roe@optusnet.com.au/
I replaced the advice to use nfnl_rcvbufsiz() (in 2 places) with advice to use
setsocketopt(). I only mentioned that programs calling nfnl_rcvbufsiz() will
continue to run.

So I offered this patch as the only documentation of how to use
nfnl_rcvbufsiz(). I need it for my testing, but it's fine with me if you don't
want to take it.

I could add a setsockopt() example to nf-queue or nfqnl_test if you like.

Cheers ... Duncan.

----- End forwarded message -----
