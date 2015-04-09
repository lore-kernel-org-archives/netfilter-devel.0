From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Thu, 9 Apr 2015 22:51:35 +0200
Message-ID: <20150409205135.GG20653@breakpoint.cc>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56543 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbbDIUvk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 16:51:40 -0400
Content-Disposition: inline
In-Reply-To: <20150409203616.GA27610@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 09.04, Pablo Neira Ayuso wrote:
> > At compilation time, you have to pass this option.
> > 
> >   # ./configure --with-xtables
> > 
> > And libxtables needs to be installed in your system.
> > 
> > This patch allows you to use xt extensions from nft, eg.
> > 
> >   # nft add rule filter output \
> >         tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
> > 
> > This feature requires that libxtables is installed in your system.
> > 
> > This provides access to all existing xt modules from nft. Users can
> > meanwhile use xt extension until we can provide native expressions.
> > 
> > You can build this optionally, if disabled it displays an error:
> > 
> >   # nft add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
> >   <cmdline>:1:38-77: Error: this build does not support xtables
> >   add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
> >                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > so you know your build doesn't support this.
> 
> Before review this patch, my main question is - are we sure we want to do
> this? How will this affect our plans to get rid of the iptables code
> at some point in the future? Arguably its a compatibility question, if we
> support this in nft people will use it and we can't simply remove it.

FWIW I think Patricks concerns are well-founded, if we do this we cannot
remove those extensions, ever.

And this will include several dubious modules (time match for example).

Why would I want to re-write a working nft+compat ruleset to one
that only uses native expressions?

Whats the point of providing a 'native' replacement for an existing xtables
target if we can just use the xtables version?

Thus I'm leaning towards not adding any compat support in nft.
