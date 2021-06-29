Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18721C11F66
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 09:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F014761D6E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 09:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhF2JlI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 05:41:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33574 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhF2JlI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 05:41:08 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DBF6161655
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jun 2021 11:38:35 +0200 (CEST)
Date:   Tue, 29 Jun 2021 11:38:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 1/1] build: doc: "make" builds & installs a full
 set of man pages
Message-ID: <20210629093837.GA23185@salvia>
References: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
 <20210622041933.25654-2-duncan_roe@optusnet.com.au>
 <20210623172621.GA25266@salvia>
 <YNf+/1rOavTjxvQ7@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YNf+/1rOavTjxvQ7@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 27, 2021 at 02:30:55PM +1000, Duncan Roe wrote:
> On Wed, Jun 23, 2021 at 07:26:21PM +0200, Pablo Neira Ayuso wrote:
> 
> [...]
> >
> > Applied, thanks.
> >
> > One thing that needs a fix (both libnetfilter_queue and libmnl).
> >
> > If doxygen is not installed...
> >
> > configure: WARNING: Doxygen not found - continuing without Doxygen support
> >
> > it warns that it is missing...
> >
> > checking that generated files are newer than configure... done
> > configure: creating ./config.status
> > config.status: creating Makefile
> > config.status: creating src/Makefile
> > config.status: creating include/Makefile
> > config.status: creating include/libmnl/Makefile
> > config.status: creating include/linux/Makefile
> > config.status: creating include/linux/netfilter/Makefile
> > config.status: creating examples/Makefile
> > config.status: creating examples/genl/Makefile
> > config.status: creating examples/kobject/Makefile
> > config.status: creating examples/netfilter/Makefile
> > config.status: creating examples/rtnl/Makefile
> > config.status: creating libmnl.pc
> > config.status: creating doxygen.cfg
> > config.status: creating doxygen/Makefile
> > config.status: creating config.h
> > config.status: config.h is unchanged
> > config.status: executing depfiles commands
> > config.status: executing libtool commands
> >
> > libmnl configuration:
> >   doxygen:          yes
> >
> > but it says yes here.
> >
> >
> > I'd prefer if documentation is not enabled by default, ie. users have
> > to explicitly specify --with-doxygen=yes to build documentation, so
> > users explicitly picks what they needs.
> 
> I'm fine with *html* being optional:
> 
>   --enable-html      build HTML documentation [default=no]
> 
> ATM `make install` doesn't do anything with the html dir. With --enable-html, I
> guess it should install html/ where --htmldir points [DOCDIR].
> 
> But I think not having man pages in the past was a serious deficiency which we
> can now address.
> 
> Think of it from a (Linux) Distributor's point of view. Man pages take up very
> little space in the distribution medium: symlinks are removed and the remaining
> pages compressed. Man pages stay compressed on installation and the symlinks are
> re-created by the postinstall script (and now as .gz or whatever files).

We are not Linux distributors, it's up to them to decide what they are
shipping in their packages, this debate is out of our scope. Assuming
that enabling this by default will not make them include this.

Most users rely on libmnl because they use some utility that pulls in
this dependency, most of them are not developers.

> Typical end-users of the distribution won't have source, so the *need*
> documentation.
> 
> Personally I'm happy if the build depends on doxygen and fails if it's not
> installed.

That's probably fine for you, but embedded developer will not be happy
with this dependency.

> If you inmsist on only printing a warning when doxygen is not installed then in
> that event .configure could output:
> 
> > libmnl configuration:
> >   doxygen:          no
> > man pages:          no
> 
> with no "man pages" line when doxygen is installed.

I'd really prefer to retain the existing default that has been in
place for many years.

> What do you think?

It's also possible to provide up to date snapshots in the Netfilter
website to give it more visibility.

BTW, the autogenerated manpage differs quite a bit from standard
manpages in other existing packages? Do you know of any other software
following this approach of converting doxygen to manpage?

Thanks.
