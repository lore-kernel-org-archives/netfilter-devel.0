Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1CFC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 21:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiAKVSH convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:18:07 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47686 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiAKVSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 16:18:06 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 33A42605C6;
        Tue, 11 Jan 2022 22:15:13 +0100 (CET)
Date:   Tue, 11 Jan 2022 22:18:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 00/10] Add pkg-config support
Message-ID: <Yd30CGy8AAzLG0CI@salvia>
References: <20220109115753.1787915-1-jeremy@azazel.net>
 <YdykZPrWzek+3P71@salvia>
 <Yd17rvBCXyAUSVvw@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Yd17rvBCXyAUSVvw@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 12:44:30PM +0000, Jeremy Sowden wrote:
> On 2022-01-10, at 22:25:56 +0100, Pablo Neira Ayuso wrote:
> > On Sun, Jan 09, 2022 at 11:57:43AM +0000, Jeremy Sowden wrote:
> > > A number of third-party libraries have added pkg-config support over
> > > the years.  This patch-set updates configure to make use of it where
> > > it is available.  It also fixes some conflicting option definitions
> > > and adds checks that cause configure to fail if a plugin has been
> > > explicitly requested, but the related third-party library is not
> > > available.
> > >
> > > Patch 1:      switch from `--with-XXX` to `--enable-XXX` for output
> > >               plugins.
> > > Patches 2-5:  use pkg-config for libdbi, libmysqlclient, libpcap and
> > >               libpq if available.
> > > Patches 6-10: abort configure when an output plugin has been
> > >               explicitly enabled, but the related library is not
> > >               available.
> > >
> > > Changes since v1
> > >
> > >   * Better commit messages.
> > >   * Simpler mysql patch: remove the upstream m4 macro calls, and
> > >     look for `mysql_config` the same way we do `pg_config` and
> > >     `pcap-config`.  * `AM_CPPFLAGS` fixes for mysql, pcap, and
> > >     postgresql.
> > >   * `LIBADD` fix for mysql.
> > >
> > > Jeremy Sowden (10):
> > >   build: use `--enable-XXX` options for output plugins
> >
> > I hesitate about this change from --with-XYZ to --enable-XYZ, it will
> > force package maintainers to update their scripts.
> 
> True.  However, it is a one-off change, and ulogd2 doesn't change often
> -- the last release was in 2018 -- so I would argue that the maintenance
> burden isn't very great.

Right. The input plugins also are enabled by default if the netfilter
library dependencies are present.

Applied, thanks for explaining.
