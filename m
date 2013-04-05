From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Ulogd2 PATCH 2/3] Lower libnfnetlink requirement to 1.0.0
Date: Fri, 5 Apr 2013 18:23:45 +0200
Message-ID: <20130405162345.GA3375@localhost>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
 <1365172437-15042-3-git-send-email-victor@inliniac.net>
 <20130405153940.GC32205@localhost>
 <515EF6E5.6010506@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Victor Julien <lists@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40530 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161938Ab3DEQXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:23:53 -0400
Content-Disposition: inline
In-Reply-To: <515EF6E5.6010506@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 05, 2013 at 06:08:05PM +0200, Victor Julien wrote:
> On 04/05/2013 05:39 PM, Pablo Neira Ayuso wrote:
> > On Fri, Apr 05, 2013 at 04:33:56PM +0200, Victor Julien wrote:
> >> Build and run tested against 1.0.0, worked fine for me.
> >>
> >> ---
> >>  configure.ac |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/configure.ac b/configure.ac
> >> index a439bee..5755cf5 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -48,7 +48,7 @@ regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
> >>  AC_SUBST([regular_CFLAGS])
> >>  
> >>  dnl Check for the right nfnetlink version
> >> -PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
> >> +PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
> > 
> > Same thing here. There was also a reason to bump the version
> > dependency.
> > 
> > There's a fix in libnfnetlink in the nlif interface.
> > 
> > commit 8b15e485c0d5f4a1e56b2148a34995ed1fa9e95b
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Mon Aug 13 19:49:58 2012 +0200
> > 
> >     iftable: fix incomplete list of interfaces via nlif_query
> > 
> > In systems with lots of NICs, nlif_query may fail without that patch
> > in libnfnetlink.
> > 
> > Please, don't downgrade the dependencies.
> 
> Okay, got it. Would have been nice to be able to work with the versions
> installed by recent distro's though.

Pull your vendor to upgrade, not me :-).
