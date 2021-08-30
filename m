Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D11CC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 01:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68CCD60E90
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 01:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhH3BJg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbhH3BJf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 21:09:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F9DC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Aug 2021 18:08:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso12686915pjh.5
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Aug 2021 18:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=aCPx7BsLtlHivCELKzB2pXdxXaOOKFPAbjZPDqsNoys=;
        b=i7cfPiAncGKjeh9ega6PcJR93powZHsXFWlCqs1/zvYOMUNfTLRgHJhVmAGQHMZexo
         5B6J6aeWJiqkoUsv8sOAAt3t0PQvlzDDtKCdQsebZ5J0b0X2NCq+odBshEF0J+Wln2Fp
         I2MFXpKtSezQqMVORwoUtgV1/7UKhZJn68Elt1AC9zbd3Up887uiMXUzbnwWTRaFxu1w
         2SzBVwqaGLVkN8d/awMn3tL3jbqcZl6LAPcHBPKrSASyQm6YNseQF6GW3LpqTxR02xDn
         9IuXhvRJzD5yeODjefvCg5H4t0i11qqPoLb0fF40GaQancyjkcz/vhma+GiOjnq1kXC6
         t6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=aCPx7BsLtlHivCELKzB2pXdxXaOOKFPAbjZPDqsNoys=;
        b=jKCvbNeikQ56nGawMhnKWSXiy4DvQPNLXscn5ihebN+hh4rUccYfaDlr7mC50EjfCe
         jaKX/CXqg9gUgu/EN6bltD1w+/3mNPlRDIJdEtoabGXbr+HB6ODI9Svxu79nC/J7uq6D
         xZ8W2g0uVaoXLbLK3RdfbyD/I2gNJodwlHU6BE9uCNjEqfLMMsSEeTfTGD+1P6vU/AHN
         JFh7RjGuEYONGPQCEIfTEvRSgx8hppSsUzwCKRv34oQ9CJFgrxZ1jywF2Z0xgCUGHC+i
         GWcD4FBbj33cVL5I+KPrNXbsHbxPQ+B6o4FX59rbzjyoKuXc3lfskJFefoCUtc6ArM2s
         RCiw==
X-Gm-Message-State: AOAM5305RVtldROi3XorSecO9CMakXJN2AwPsC9rbOOJDATh3ayZg/Gz
        IV5aTUDyIKhtltbiuBxbNvOe7wimA9w=
X-Google-Smtp-Source: ABdhPJwzzWKP4cjH/nwzY6mmITZVlILmxHVzIGhyDEcFwyWR0fdz+PQPt8m3pK2TTZT1uXz7OrB9Zg==
X-Received: by 2002:a17:902:aa87:b0:138:d914:15b0 with SMTP id d7-20020a170902aa8700b00138d91415b0mr3205169plr.39.1630285722383;
        Sun, 29 Aug 2021 18:08:42 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id x207sm13466674pfc.177.2021.08.29.18.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 18:08:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 30 Aug 2021 11:08:38 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 5/6] build: doc: Allow to specify
 whether to produce man pages, html, neither or both
Message-ID: <YSwvlvnQ9Ulm+kSS@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
 <20210828033508.15618-5-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828033508.15618-5-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Aug 28, 2021 at 01:35:07PM +1000, Duncan Roe wrote:
> - configure --help lists non-default documentation options.
>   Looking around the web, this seemed to me to be what most projects do.
>   Listed options are --without-doxygen, --enable-html-doc &
>   --disable-man-pages.
> - configure warns on inconsistent options e.g. --without-doxygen by itself
>   warns man pages will not be built.
> - configure.ac re-ordered so --without-doxygen overrides --enable-any-doc.
> If html is requested, `make install` installs it in htmldir.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  configure.ac           | 41 ++++++++++++++++++++++++++++++++++++-----
>  doxygen/Makefile.am    | 11 ++++++++++-
>  doxygen/doxygen.cfg.in |  3 ++-
>  3 files changed, 48 insertions(+), 7 deletions(-)
>
[...]

Just in case you missed it, this one is still to do.

Regarding warnings - I did try all the option combinations and again w/out
doxygen installed, so maybe you can satisfy yourself with a few random choices.

Cheers ... Duncan.
