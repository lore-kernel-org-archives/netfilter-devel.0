From: Hani Benhabiles <kroosec@gmail.com>
Subject: Re: [PATCH iptables] libxtables: Call ipaddr_to_network before
 ipaddr_to_host.
Date: Tue, 31 Dec 2013 18:50:48 +0100
Message-ID: <20131231175048.GA11575@Inspiron-3521>
References: <20131209200223.GC2970@Inspiron-3521>
 <20131230174603.GA21372@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52332 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3LaRu7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:50:59 -0500
Received: by mail-ee0-f48.google.com with SMTP id e49so5522403eek.21
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2013 09:50:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131230174603.GA21372@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Dec 30, 2013 at 06:46:03PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 09, 2013 at 09:02:23PM +0100, Hani Benhabiles wrote:
> > Call ipaddr_to_network before ipaddr_to_host.
> > 
> > This saves waiting for a reverse DNS lookup query when the entry is present in
> > /etc/networks. This also follows the same order as in rules creation.
> 
> This saves time and it makes sense to me to check local file before
> name resolution via network, but...
> 
> > Signed-off-by: Hani Benhabiles <kroosec@gmail.com>
> > ---
> >  libxtables/xtables.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > index fb60c01..bb25262 100644
> > --- a/libxtables/xtables.c
> > +++ b/libxtables/xtables.c
> > @@ -1207,8 +1207,8 @@ const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
> >  {
> >  	const char *name;
> >  
> > -	if ((name = ipaddr_to_host(addr)) != NULL ||
> > -	    (name = ipaddr_to_network(addr)) != NULL)
> > +	if ((name = ipaddr_to_network(addr)) != NULL ||
> > +	    (name = ipaddr_to_host(addr)) != NULL)
> 
> My only concern is the remote case in which you may have a network
> name that overlaps with some existing host name, in that case the
> expected output different.
> 

This is already the case in rules creation. In xtables.c:ipparse_hostnetwork()
we have network_to_ipaddr() call prior to host_to_ipaddr().

I believe that a consistent behaviour for users is important ie. either network
names or host names should come first in both resolving and reverse resolving.

Maybe be consistent, and make host names a priority in rules creation, then ?
However, I believe networks should come first, mainly due to the potential
time/bandwidth save.

Regards,

Hani.
