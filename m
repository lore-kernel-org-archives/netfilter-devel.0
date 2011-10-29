From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] ipset: fix lookup of tcp port names
Date: Sat, 29 Oct 2011 16:48:55 +0200
Message-ID: <20111029164855.28a93cb6@s6510.linuxnetplumber.net>
References: <20111028181613.6702aeb7@s6510.linuxnetplumber.net>
	<alpine.DEB.2.00.1110282224490.3090@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:41747 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273Ab1J2OtD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:49:03 -0400
In-Reply-To: <alpine.DEB.2.00.1110282224490.3090@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 28 Oct 2011 22:26:36 +0200 (CEST)
Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

> Hi Stephen,
> 
> On Fri, 28 Oct 2011, Stephen Hemminger wrote:
> 
> > The protocol argument to getservbyname() must be lowercase tcp not
> > uppercase TCP. This fixes the bug observed by:
> > 
> >  # ipset add foo http
> >  ipset v6.9.1: Syntax error: 'http' is invalid as number
> >  Syntax error: cannot parse 'http' as a TCP port
> > ---
> >  lib/parse.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/parse.c b/lib/parse.c
> > index 241d5ae..3ca702c 100644
> > --- a/lib/parse.c
> > +++ b/lib/parse.c
> > @@ -307,7 +307,7 @@ int
> >  ipset_parse_tcp_port(struct ipset_session *session,
> >  		     enum ipset_opt opt, const char *str)
> >  {
> > -	return ipset_parse_tcpudp_port(session, opt, str, "TCP");
> > +	return ipset_parse_tcpudp_port(session, opt, str, "tcp");
> >  }
> >  
> >  /**
> > @@ -330,7 +330,7 @@ ipset_parse_single_tcp_port(struct ipset_session *session,
> >  	assert(opt == IPSET_OPT_PORT || opt == IPSET_OPT_PORT_TO);
> >  	assert(str);
> >  
> > -	return ipset_parse_port(session, opt, str, "TCP");
> > +	return ipset_parse_port(session, opt, str, "tcp");
> >  }
> >  
> >  /**
> > -- 
> > 1.7.2.5
> 
> Ohh, thanks! Somehow port names haven't been tested by the testsuite....

Luckly they were by our regression testsuite.

