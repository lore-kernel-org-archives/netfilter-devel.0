Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4D3C48BC2
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 04:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34091619BF
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Jun 2021 04:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhF0EdZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Jun 2021 00:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhF0EdY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Jun 2021 00:33:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7ABC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Jun 2021 21:31:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so8098176pjo.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Jun 2021 21:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=kLjZazpcFpPCanMjNs+/6Ao5hZbMvkOG62Qy5ymr6nA=;
        b=o4AXriQv/QgMDDISUDBtYo3bPNh0ByfiiR9RI9E9DhqmAv6SvlAS0RzARTiYvRVVCB
         AVAa46+K0cfXeyU5WA5Uu2eVXC6NFSeDwWuYhMfwFkEiiuyo1wljZGmCh33ekUmXhrnN
         P1oBI3yS0imeCy36bfp4KY9XUAedkieYp27NCvozyJsOOXYCEpdFwUqkxI7aNQSL0qgt
         T+yefp8AJgUsF2aCtYMqezvUWSWtXYgFNCrdTFkPCMSIYEO3ZA3kIPSnqtMd1ElRtTsJ
         wdRPSn0g580mr+vgevoYJJFlLqzclw3irPRkiQtt5Sg92MYHmJDm0ZftA+pghKmRKsTd
         1B7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=kLjZazpcFpPCanMjNs+/6Ao5hZbMvkOG62Qy5ymr6nA=;
        b=oCaGYDVf9ZPj/6udkPdfQILT+NkHCROoLry4dUURDzihq7re/T8tZeoMbcATWeU7X/
         6e7Whsw6MDj59F0PDEGmPSVsrYoXwgIoNI6W35f+Vw+d01AzLa6+k6cjHgj17ZdhkIMd
         C5ztMoAcar9D+kyRvS7udGDKj8mXuPJkKwe73Dnz0Vb3jSZSTClexMxOJ8gGgNJuAbAY
         QczGIwaXyKXGaRX/13mRKe37phQ+hzepFD7m7zJXMKcACX8T0VGcQtoE2DKKsNl0BmwV
         +2C8iznCAaz18JbRMSi/86AAxOMNBd82vyOaV0mM8QjiEpf1Bh/KBFTXpUpHOiTuoqZ0
         O0QA==
X-Gm-Message-State: AOAM533u5DDN09DUuM1eyXP/wkTwgcaEAlSUIJ0eQaABms5NU0nlzs35
        FaygyRa0TbG6QgYQua21wHkSCtoUOIk=
X-Google-Smtp-Source: ABdhPJyOdDicc5bd6mjm3pWK+IaQ0O9DvQsa9nUginnGVQ3W1gGpeijxqattLucef47+sBCtLidYVw==
X-Received: by 2002:a17:902:bd03:b029:11c:d504:c1ce with SMTP id p3-20020a170902bd03b029011cd504c1cemr16405495pls.7.1624768259628;
        Sat, 26 Jun 2021 21:30:59 -0700 (PDT)
Received: from slk1.local.net (n49-192-153-80.sun4.vic.optusnet.com.au. [49.192.153.80])
        by smtp.gmail.com with ESMTPSA id w20sm11519773pff.90.2021.06.26.21.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 21:30:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 27 Jun 2021 14:30:55 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YNf+/1rOavTjxvQ7@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623172621.GA25266@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 23, 2021 at 07:26:21PM +0200, Pablo Neira Ayuso wrote:

[...]
>
> Applied, thanks.
>
> One thing that needs a fix (both libnetfilter_queue and libmnl).
>
> If doxygen is not installed...
>
> configure: WARNING: Doxygen not found - continuing without Doxygen support
>
> it warns that it is missing...
>
> checking that generated files are newer than configure... done
> configure: creating ./config.status
> config.status: creating Makefile
> config.status: creating src/Makefile
> config.status: creating include/Makefile
> config.status: creating include/libmnl/Makefile
> config.status: creating include/linux/Makefile
> config.status: creating include/linux/netfilter/Makefile
> config.status: creating examples/Makefile
> config.status: creating examples/genl/Makefile
> config.status: creating examples/kobject/Makefile
> config.status: creating examples/netfilter/Makefile
> config.status: creating examples/rtnl/Makefile
> config.status: creating libmnl.pc
> config.status: creating doxygen.cfg
> config.status: creating doxygen/Makefile
> config.status: creating config.h
> config.status: config.h is unchanged
> config.status: executing depfiles commands
> config.status: executing libtool commands
>
> libmnl configuration:
>   doxygen:          yes
>
> but it says yes here.
>
>
> I'd prefer if documentation is not enabled by default, ie. users have
> to explicitly specify --with-doxygen=yes to build documentation, so
> users explicitly picks what they needs.

I'm fine with *html* being optional:

  --enable-html      build HTML documentation [default=no]

ATM `make install` doesn't do anything with the html dir. With --enable-html, I
guess it should install html/ where --htmldir points [DOCDIR].

But I think not having man pages in the past was a serious deficiency which we
can now address.

Think of it from a (Linux) Distributor's point of view. Man pages take up very
little space in the distribution medium: symlinks are removed and the remaining
pages compressed. Man pages stay compressed on installation and the symlinks are
re-created by the postinstall script (and now as .gz or whatever files).

Typical end-users of the distribution won't have source, so the *need*
documentation.

Personally I'm happy if the build depends on doxygen and fails if it's not
installed.

If you inmsist on only printing a warning when doxygen is not installed then in
that event .configure could output:

> libmnl configuration:
>   doxygen:          no
> man pages:          no

with no "man pages" line when doxygen is installed.

What do you think?

Cheers ... Duncan.
