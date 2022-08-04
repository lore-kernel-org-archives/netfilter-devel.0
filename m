Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E06C00144
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 03:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiHDDpQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237166AbiHDDpP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 23:45:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE023E767
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 20:45:09 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f11so16830326pgj.7
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Aug 2022 20:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=A8k1mRGP2fqv0zRUWoCrsu8wNeC44YSM6uq8UCWnfk4=;
        b=G1EHDVz4s1gWgat7yFP/5MGCiXrGiJ7RlJsnbn6BUTVFyxDAY5ZcYNwgCOLeVTDY5u
         EaB98sE8oHt0l/EiLApyvBI1KBsNk5usjWjh6euhz8NoI90JKstDv992uZWlDHN9QLjB
         oXHu5Xd+8v+lr45+9+FdCj1VBHs4a0pnHf71o+jF1k2Xu1610sisBgTB/vImzMbHTD6V
         01SRm5fvqgKGlPBrLmAsoEnBjlxzTAx1iPN6zEEjGD/AkJVIp2kPhRgwXq2vTiq19E9t
         DwQ1o2J0xpLtzLczCcOas+Z3208Tgi2wKOrDNAe/owsKrQn95Luiau5JR3tVSEefsPo4
         20oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=A8k1mRGP2fqv0zRUWoCrsu8wNeC44YSM6uq8UCWnfk4=;
        b=T2yRwdIIE7b9dqa4S0ke/ktX7yazx+3pJF5R3PaSSeUS0lRHKS61mLoxj0Fw2NCU+O
         bUN6JyRmk/tPmFkC5ziU+1FX2xVScoufQAGTNqttnYysdnayfHfcPMekz3gYQUm0I12J
         lNAVaul02dtx3uPMKfU0crresPDPWELg+i+rZL3GPIq1n2gA//g7eM+gcKqBU47ULPw3
         WzuMdEk8B/+wSn/W62eEJI6L4LBGU28UA/eGAFlCElQ8JKgei7Ek7Jyhh39kBIddJoJ+
         /F15DqnLXqWF8lwmbvCSP7bdgZxMEFJBuyyzx5ShqprGvpKqyGEbkPA9kEwHOy5GesYU
         2VwA==
X-Gm-Message-State: ACgBeo1VkU3V6OEC8Q9YhG21zI1nKqdW88FWgmbHgYKTYOITzwsYJWWd
        wKy2aj3xwa30GuQSF5RIlSbXl6XY7Ys=
X-Google-Smtp-Source: AA6agR6QP55V5LrpN1LfgZMTB+zVqUxbZjHe69kK8tIKOYfw4f+jsejp759VpiHbo2n9k8oUWhWexw==
X-Received: by 2002:a65:6398:0:b0:415:7d00:c1de with SMTP id h24-20020a656398000000b004157d00c1demr6249pgv.610.1659584709020;
        Wed, 03 Aug 2022 20:45:09 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id 75-20020a63064e000000b0041cd2417c66sm3529pgg.18.2022.08.03.20.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:45:08 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Thu, 4 Aug 2022 13:45:04 +1000
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Mark Mentovai <mark@mentovai.com>
Subject: Re: [PATCH libmnl 0/6] Doxygen Build Improvements
Message-ID: <YutAwJJpr8tZ4MRW@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Mark Mentovai <mark@mentovai.com>
References: <20220803201247.3057365-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803201247.3057365-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Wed, Aug 03, 2022 at 09:12:41PM +0100, Jeremy Sowden wrote:
> These changes were prompted by Mark Mentovai's request to remove a hard-coded
> `/bin/bash` path from the rule that creates the man-page sym-links.  Hitherto,
> the doxygen Makefile has jumped through a number of hoops to make sure
> everything works with `make distcheck` and parallel builds.  This patch-set
> makes some doxygen config changes that obviate the need for them, fixes a bug in
> `make clean`, updates .gitignore and moves the shell-script out of the Makefile
> into a separate file for ease of maintenance.  In the process, the hard-coded
> `/bin/bash` is removed.
>
> One thing I have left is the setting of `-p` when running the shell-script.  The
> comment reads "`bash -p` prevents import of functions from the environment".
> Why is this a problem?
>
> Jeremy Sowden (6):
>   build: add `make dist` tar-balls to .gitignore
>   doc: add .gitignore for Doxygen artefacts
>   doc: change `INPUT` doxygen setting to `@top_srcdir@`
>   doc: move doxygen config file into doxygen directory
>   doc: move man-page sym-link shell-script into a separate file
>   doc: fix doxygen `clean-local` rule
>
>  .gitignore                               |  3 +-
>  configure.ac                             | 15 ++++++-
>  doxygen/.gitignore                       |  4 ++
>  doxygen/Makefile.am                      | 53 +++---------------------
>  doxygen.cfg.in => doxygen/doxygen.cfg.in |  4 +-
>  doxygen/finalize_manpages.sh             | 40 ++++++++++++++++++
>  6 files changed, 67 insertions(+), 52 deletions(-)
>  create mode 100644 doxygen/.gitignore
>  rename doxygen.cfg.in => doxygen/doxygen.cfg.in (91%)
>  create mode 100644 doxygen/finalize_manpages.sh
>
> --
> 2.35.1
Thanks for this but ... I think it would be better to use the netfilter-log
model.

That way there is no new shell script to maintain - libmnl would pick up
libnetfilter-queue's copy.

I found the time-consuming part was checking the new SYNOPSIS lines to be
sufficient. I have far less time nowadays (no Covid lockdowns, &c.) but I will
try to get it done soon-ish.

In the meantime I think Mark's 1-line patch to the existing mess is adequate.

The bin/bash thing is easily resolved: I've tested this in libnetfilter-queue:

> --- a/doxygen/build_man.sh
> +++ b/doxygen/build_man.sh
> @@ -1,4 +1,5 @@
> -#!/bin/bash -p
> +#!/bin/sh
> +[ -n "$BASH" ] || exec bash -p $0
>
>  # Script to process man pages output by doxygen.
>  # We need to use bash for its associative array facility.

Cheers ... Duncan.
