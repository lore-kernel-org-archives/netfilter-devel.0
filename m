From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [pablo@netfilter.org: Re: [netfilter-core] Patch for ULOGD]
Date: Wed, 19 Sep 2012 10:23:52 +0200
Message-ID: <20120919082352.GA21533@1984>
References: <20120918193708.GA2498@1984>
 <alpine.LNX.2.01.1209190429410.13470@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: anders@anduras.de, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47753 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2ISIXz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:23:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209190429410.13470@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 19, 2012 at 04:31:17AM +0200, Jan Engelhardt wrote:
> 
> On Tuesday 2012-09-18 21:37, Pablo Neira Ayuso wrote:
> >
> >This contribution reached netfilter-core mailing list.
> >
> > --- ulogd-2.0.0.orig/configure.ac	2012-06-17 13:01:58.000000000 +0200
> > +++ ulogd-2.0.0/configure.ac	2012-08-29 13:11:01.000000000 +0200
> > @@ -2,7 +2,7 @@
> >  AC_PREREQ([2.50])
> >  AC_INIT([ulogd], [2.0.0])
> >  AC_CONFIG_AUX_DIR([build-aux])
> > -AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
> > +AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10])
> >  AC_CONFIG_HEADER([config.h])
> >  AC_CONFIG_MACRO_DIR([m4])
> 
> This should be a separate commit, and explain why this was done.
> 
> Now that I already looked it up: pkglibexecdir was introduced in automake
> 1.10b, however, we are no longer using the pkglibexecdir variable
> since commit ulogd-2.0.0~6, so the requirement is relaxed.

Thanks for detailing the reason why that contributor made that change.
