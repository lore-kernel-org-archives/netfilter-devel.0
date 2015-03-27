From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's
 NF_INET_LOCAL_IN sk lookups
Date: Fri, 27 Mar 2015 03:10:14 +0100
Message-ID: <20150327021014.GA3142@salvia>
References: <cover.1427394874.git.daniel@iogearbox.net>
 <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net>
 <20150327001408.GD3545@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54110 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbbC0CGQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 22:06:16 -0400
Content-Disposition: inline
In-Reply-To: <20150327001408.GD3545@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 01:14:08AM +0100, Pablo Neira Ayuso wrote:
> > diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> > index 971cd75..044bd22 100644
> > --- a/net/netfilter/Kconfig
> > +++ b/net/netfilter/Kconfig
> > @@ -960,8 +960,13 @@ config NETFILTER_XT_MATCH_BPF
> >  
> >  config NETFILTER_XT_MATCH_CGROUP
> >  	tristate '"control group" match support'
> > +	depends on NETFILTER_XTABLES
> 
> why this? I think NETFILTER_ADVANCED is sufficient.
> 
> >  	depends on NETFILTER_ADVANCED
> > +	depends on !NF_CONNTRACK || NF_CONNTRACK
> 
> why conntrack?
> 
> > +	depends on (IPV6 || IPV6=n)
> 
> Do we depend on any ipv6 symbol?
> 
> >  	depends on CGROUPS
> > +	select NF_DEFRAG_IPV4
> > +	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
> 
> No need for defrag either.

Wait, now I see why you need this.

What started a simple cgroup match extension is turning into a more
complicated thing. And you want to do firewalling with this, which
doesn't work for other socket families than TCP and UDP.
