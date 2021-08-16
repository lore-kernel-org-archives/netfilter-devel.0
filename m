Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D81C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 04:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF5661458
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 04:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhHPEXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 00:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhHPEXc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 00:23:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB00C061764
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 21:23:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n5so4003826pjt.4
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 21:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=VNIDj601VTlBJwq6+pF4tl+a8FETLXi67ZjOKR+UkOI=;
        b=a+E2qSTKpY59np/iBvUH6/3unCA4rc7vpBczT8ntVVEmCNRkGsLSbaLEWnc6KpcnyS
         FdLL9MXF0kPvuOuQH4JC5EPrCmMevnll0lHDvwnFBumXdXufXIupb+DljcjjBzddvtQ6
         lerdCLca1/nbnzJTjLXrukp0rMrTyqDMVZc0+rrS0/dCCRkOD+YPNaESErUV1Rygd1XD
         Gyk7+sIXtZa4T0+YsE2pr0Y5qxpughwnDu821H9Yl49b2ULWV1py+OIFACx6ZTdHHejg
         OmiUgHz7wYUfWcl1+3EsJOQkAn4B5TUevQeeWrRJo1BRZl7ATn/UZcOCamv4WfO9fznr
         B5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=VNIDj601VTlBJwq6+pF4tl+a8FETLXi67ZjOKR+UkOI=;
        b=fcA46j09dbCVDA9hi41OHvrCB+QjI9UYlpwb/IZNR4ZKRd7hWPo/OfqzKU2CapAV5X
         N7IRg51IMVwqBoiFDR/MZbRu6lFHd1/tq6dmlwpLUn3dyEU7UzhDvReXwJfaGo4JJTpt
         iKnQ4CEOc+2knhI4tlqfXl32VCq5XNT4AmMYA1Vsqk8grbWQoCi8PvieJvNFHHuWrsH4
         wMdobqujbcsc/oSHCAeoB827LEBWSjrcnHkDToEFQeK20fDlwKLjpLq9Z+qVSVq7Jyg/
         pC3srJrzh56QF63p+cALpm/bpJ0IBkLh9hp8SCzvhIPVnQXhIri0q64n/QYTtOtWC+/b
         kLig==
X-Gm-Message-State: AOAM533vzPj9Tu+QA14q12YaHW+UwVUnP0HAKPdt+cBJrmSeo351fznI
        i6ykF1XXI08qEpxTjNN2yWIi14v9GhJcsQ==
X-Google-Smtp-Source: ABdhPJyqDl5Jet0N+DKTwMpQpUdkNJjqLcP4cxeqOlY8/bHZhxFLVWHnryc8ZrqEerCiNZSGJBYHDg==
X-Received: by 2002:a17:90a:4e8c:: with SMTP id o12mr10028603pjh.118.1629087781429;
        Sun, 15 Aug 2021 21:23:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id x7sm9442968pfn.70.2021.08.15.21.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:23:00 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 16 Aug 2021 14:22:55 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <YRnoH6nkSh8HI5lT@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
 <20210815121509.GA9606@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815121509.GA9606@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 15, 2021 at 02:15:09PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 10, 2021 at 12:40:01PM +1000, Duncan Roe wrote:
> > Make the NAME line list the functions defined, like other man pages do.
> > Also:
> > - If there is a "Modules" section, delete it
> > - If "Detailed Description" is empty, delete "Detailed Description" line
> > - Reposition SYNOPSIS (with headers that we inserted) to start of page,
> >   integrating with defined functions to look like other man pages
> > - Delete all "Definition at line nnn" lines
> > - Delete lines that make older versions of man o/p an unwanted blank line
> > - Insert spacers and comments so Makefile.am is more readable
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: Delete lines that make older versions of man o/p an unwanted blank line
> >  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
>
> Time to add this to an independent fixup shell script for
> doxygen-based manpages that Makefile.am could call instead?
>
> This script could be imported by other libraries too, so it only needs to
> be downloaded from somewhere to be refreshed to keep it in sync with
> latest.
>
> The git tree could cache a copy of this script.
>
> Could you have a look into this?
>
> Thanks.

At the moment, libmnl and libnetfilter_queue share an identical
doxygen/Makefile.am.

So, you could declare libnetfilter_queue to be the master and copy from there.

The files' staying identical will depend at least on configure.ac in other libs
tracking libnfq. Currently configure.ac supplies HAVE_DOXYGEN but I am working
on a patch where there will also be BUILD_HTML and BUILD_MAN.

I had to move fixmanpages.sh inside Makefile.am to get `make distcheck` to
pass. So I'll need to be careful about introducing new files (e.g. to include).

Will keep investigating,

Cheers ... Duncan.
