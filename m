From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Ulogd2 PATCH 1/3] Remove configure check for libmnl, it is not
 used
Date: Fri, 5 Apr 2013 18:00:18 +0200
Message-ID: <20130405160018.GA28792@localhost>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
 <1365172437-15042-2-git-send-email-victor@inliniac.net>
 <20130405153428.GA32205@localhost>
 <515EF201.7030007@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Victor Julien <victor@inliniac.net>,
	netfilter-devel@vger.kernel.org
To: Victor Julien <lists@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161724Ab3DEQAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:00:23 -0400
Content-Disposition: inline
In-Reply-To: <515EF201.7030007@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 05, 2013 at 05:47:13PM +0200, Victor Julien wrote:
> On 04/05/2013 05:34 PM, Pablo Neira Ayuso wrote:
> > On Fri, Apr 05, 2013 at 04:33:55PM +0200, Victor Julien wrote:
> >> If libmnl is missing configure fails. However, the lib is not used nor
> >> linked to.
> >>
> >> ---
> >>  configure.ac |    1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/configure.ac b/configure.ac
> >> index c94704b..a439bee 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
> >>  
> >>  dnl Check for the right nfnetlink version
> >>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
> >> -PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
> > 
> > input/sum/ulogd_inpflow_NFACCT.c
> > 
> > needs this.
> 
> Shouldn't it be a conditional check then? Only if nfacct is enabled?

That's fine with me.
