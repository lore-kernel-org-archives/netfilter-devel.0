From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libipt_NETMAP: Avoid listing 32 bit mask and fix tests
Date: Fri, 17 Jun 2016 14:24:12 +0200
Message-ID: <20160617122412.GA12935@breakpoint.cc>
References: <20160614203240.GA23145@shivani>
 <20160617115442.GA5387@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51150 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933643AbcFQMYT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 08:24:19 -0400
Content-Disposition: inline
In-Reply-To: <20160617115442.GA5387@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 15, 2016 at 02:02:40AM +0530, Shivani Bhardwaj wrote:
> > diff --git a/extensions/libipt_NETMAP.t b/extensions/libipt_NETMAP.t
> > index 31924b9..de2bf8f 100644
> > --- a/extensions/libipt_NETMAP.t
> > +++ b/extensions/libipt_NETMAP.t
> > @@ -1,4 +1,4 @@
> >  :PREROUTING,INPUT,OUTPUT,POSTROUTING
> >  *nat
> > --j NETMAP --to 1.2.3.0/24;=;OK
> > --j NETMAP --to 1.2.3.4;=;OK
> > +-j NETMAP --to 1.2.3.0/24;-j NETMAP --to  to:1.2.3.0/24;OK
> > +-j NETMAP --to 1.2.3.4;-j NETMAP --to  to:1.2.3.4;OK
>                                           ^^^
> 
> Shivani, thanks for spotting this.
> 
> It seems 90becf12bd5 broke iptables-save.

Right, sorry.
I'll submit a patch asap.
