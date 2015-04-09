From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:33:56 +0200
Message-ID: <20150409223356.GA3108@salvia>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59254 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbbDIW3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 18:29:47 -0400
Content-Disposition: inline
In-Reply-To: <20150409203616.GA27610@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 09, 2015 at 09:36:17PM +0100, Patrick McHardy wrote:
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

Good question.

I think we'll have to live with both codebases for quite a while
anyway, unfortunately we cannot skip that.

I think this code provides a way for users to easily migrate from
iptables to nftables.

They will only need to:

        iptables-compat-restore < ipt-ruleset.file

then, switch to nft and type:

        nft list ruleset > nft-ruleset.file

and start to replacing to native expressions progressively.

We also have a prototype translation layer (see xlate in the iptables
tree), that will provide an automatic translation whenever possible.

The idea is that they will periodically run something like:

        nft --migrate nft-ruleset.file

that will detect xt statements and will translate them to native
expressions whenever possible.

I think we have to ease adoption through these facilities, and new
nice features, of course.
