Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E6AC11F68
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 04:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CFC6141D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 04:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhGBESy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 00:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGBESx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 00:18:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C56C061762
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jul 2021 21:16:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cx9-20020a17090afd89b0290170a3e085edso5369249pjb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Jul 2021 21:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=rDJhOBzh7jw+UHCQzmqSygxvnRwUDXvIkYNRbnlJtD4=;
        b=qz8soVicovENQsRibNne7GzFQMkT5kvpz2fy+PpRGlU3cQUrdsRz3cbHu08UCUihsS
         QoSjSuhtV234rCBvgRxa6pU4pDllzp7ODXqiUqyJlUlSqUS/eCtai/BwhVA9AJLG9KJY
         cwao9x2AHBV3uA1R7J7121QPeISepJlZouRQsnqwU3nkp9GYKHUd424mD4mfheJ963J/
         CBZnfp9JKuTuTmQkMl09OsWc26fvF7dBGmQ5wvmsYVWPhJ6bj4ZTz7/26tZX2E0voqry
         deFVCUL958/Z01p8wIE+OErRuAhtS+ZSO612C5tWCEvNMZndi01/sF/iB213QHinU9j7
         EFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=rDJhOBzh7jw+UHCQzmqSygxvnRwUDXvIkYNRbnlJtD4=;
        b=g3E8l+zFF1jn4D+y0OhE5t33HmFPF46PzssGLJvCGUG/xaqGBJ8Ldndb6kPGy6zhV+
         onA64StN66e/d+fkSVzu99FiH9fejm3CIY0X2dhPzOQTzOjZ0Aci1AKtDpj7Hig+1coZ
         2DL1GzzfR2U5+0wuVd/+5fMiQQaSYxbwkjBfWUXfxx5OfGyC0vw4X8Nyu6kDuEm9XLhS
         xykV2QAyQ4fL15oqAWziiwlJhHKimIf/1Pc4WsXj2FFdi1fc2hjfukSEbqtfQ1jMsyf7
         xe8CyxCzKdy3N9/lVdw34Tdf9+D73sedDwl9dcRydO11s5WHT6UIrx3glX/q4FpYmtVF
         J7qA==
X-Gm-Message-State: AOAM532qfjjMzAPFQbldVQE6py1W42iT08Vs52s7mT7QRKhiJuU1tpSR
        MoC2/cGygpRZGxmCRGCKyaVeNxn7VQQ=
X-Google-Smtp-Source: ABdhPJxgmmFLPLP0vPUpwMPlxQpGm5h7p0v9Gzdr7pS35772ylkzJ2JlhLiQefW+SWJNMdn1mL8Trg==
X-Received: by 2002:a17:902:c3c6:b029:128:f061:889d with SMTP id j6-20020a170902c3c6b0290128f061889dmr2703265plj.50.1625199378195;
        Thu, 01 Jul 2021 21:16:18 -0700 (PDT)
Received: from slk1.local.net (n49-192-153-80.sun4.vic.optusnet.com.au. [49.192.153.80])
        by smtp.gmail.com with ESMTPSA id d3sm1089360pjo.31.2021.07.01.21.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 21:16:17 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 2 Jul 2021 14:16:13 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <YN6TDYS6qL0ddmcF@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
 <20210629093837.GA23185@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629093837.GA23185@salvia>
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
> > >
> > > it warns that it is missing...
> > >
> > > checking that generated files are newer than configure... done
> > > configure: creating ./config.status
> > > config.status: creating Makefile
> > > config.status: creating src/Makefile
> > > config.status: creating include/Makefile
> > > config.status: creating include/libmnl/Makefile
> > > config.status: creating include/linux/Makefile
> > > config.status: creating include/linux/netfilter/Makefile
> > > config.status: creating examples/Makefile
> > > config.status: creating examples/genl/Makefile
> > > config.status: creating examples/kobject/Makefile
> > > config.status: creating examples/netfilter/Makefile
> > > config.status: creating examples/rtnl/Makefile
> > > config.status: creating libmnl.pc
> > > config.status: creating doxygen.cfg
> > > config.status: creating doxygen/Makefile
> > > config.status: creating config.h
> > > config.status: config.h is unchanged
> > > config.status: executing depfiles commands
> > > config.status: executing libtool commands
> > >
> > > libmnl configuration:
> > >   doxygen:          yes
> > >
> > > but it says yes here.
> > >
> > >
> > > I'd prefer if documentation is not enabled by default, ie. users have
> > > to explicitly specify --with-doxygen=yes to build documentation, so
> > > users explicitly picks what they needs.
> >
> > I'm fine with *html* being optional:
> >
> >   --enable-html      build HTML documentation [default=no]
> >
> > ATM `make install` doesn't do anything with the html dir. With --enable-html, I
> > guess it should install html/ where --htmldir points [DOCDIR].
> >
> > But I think not having man pages in the past was a serious deficiency which we
> > can now address.
> >
> > Think of it from a (Linux) Distributor's point of view. Man pages take up very
> > little space in the distribution medium: symlinks are removed and the remaining
> > pages compressed. Man pages stay compressed on installation and the symlinks are
> > re-created by the postinstall script (and now as .gz or whatever files).
>
> We are not Linux distributors, it's up to them to decide what they are
> shipping in their packages, this debate is out of our scope. Assuming
> that enabling this by default will not make them include this.

Not sure about that. It seems to me, most distros build the default
configuration and remove stuff. F.I. if there is a "-devel" package variant then
the base package will have neither man pages nor header files. Yet we always
distribute header files. Man pages are a little bigger, but less than twice the
size of headers for libmnl & libnfq (i.e. compressed pages with symlinks).
>
> Most users rely on libmnl because they use some utility that pulls in
> this dependency, most of them are not developers.

So they won't install the -devel package.

[...]

Will address your other points in a future email,

Cheers ... Duncan.
