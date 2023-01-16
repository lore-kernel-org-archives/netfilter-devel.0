Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D180C54EBE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 11:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjAPL6P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 06:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjAPL6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 06:58:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 674C51CAFB
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 03:57:58 -0800 (PST)
Date:   Mon, 16 Jan 2023 12:57:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Message-ID: <Y8U7wlJxOvWK7Vpw@salvia>
References: <20230112225517.31560-1-jengelh@inai.de>
 <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 13, 2023 at 12:47:30PM +0100, Phil Sutter wrote:
> Hi Jan,
> 
> On Thu, Jan 12, 2023 at 11:55:17PM +0100, Jan Engelhardt wrote:
> > To make distcheck succeed, disting it is enough; it does not need
> > to be installed.
> 
> Instead of preventing it from being installed, how about dropping it
> altogether?
> 
> The last code using it was dropped by me three years ago, apparently
> after decision at NFWS[1]. Pablo removed the standalone 'xtables-config'
> utility back in 2015[2], yet I see a remaining xtables_config_main
> prototype in xtables-multi.h which seems to have been missed back then.

Go ahead with removing /etc/xtables.conf.

> > Fixes: v1.8.8-150-g3822a992
> > Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> > ---
> >  Makefile.am | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Makefile.am b/Makefile.am
> > index 451c3cb2..10198753 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -16,11 +16,11 @@ SUBDIRS         += extensions
> >  # Depends on extensions/libext.a:
> >  SUBDIRS         += iptables
> >  
> > -EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py
> > +EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py etc/xtables.conf
> >  
> >  if ENABLE_NFTABLES
> >  confdir		= $(sysconfdir)
> > -dist_conf_DATA	= etc/ethertypes etc/xtables.conf
> > +dist_conf_DATA	= etc/ethertypes
> >  endif
> 
> While being at it, I wonder about ethertypes: At least on the distros I
> run locally, the file is provided by other packages than iptables. Do we
> still need it? (It was added by Arturo for parity with legacy ebtables
> in [3].)

IIRC ebtables is using a custom ethertype file, because definitions
are different there.

But is this installed file used in any way these days?
