From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:18:29 +0100
Message-ID: <20150409231828.GA13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409223356.GA3108@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34586 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbbDIXSd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:18:33 -0400
Content-Disposition: inline
In-Reply-To: <20150409223356.GA3108@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Thu, Apr 09, 2015 at 09:36:17PM +0100, Patrick McHardy wrote:
> > > At compilation time, you have to pass this option.
> > > 
> > >   # ./configure --with-xtables
> > > 
> > > And libxtables needs to be installed in your system.
> > > 
> > > This patch allows you to use xt extensions from nft, eg.
> > > 
> > >   # nft add rule filter output \
> > >         tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
> > 
> > Before review this patch, my main question is - are we sure we want to do
> > this? How will this affect our plans to get rid of the iptables code
> > at some point in the future? Arguably its a compatibility question, if we
> > support this in nft people will use it and we can't simply remove it.
> 
> Good question.
> 
> I think we'll have to live with both codebases for quite a while
> anyway, unfortunately we cannot skip that.

Absolutely. I just want to make sure we don't prolong it unnecessarily,
or even for ever.
 
> I think this code provides a way for users to easily migrate from
> iptables to nftables.
> 
> They will only need to:
> 
>         iptables-compat-restore < ipt-ruleset.file
> 
> then, switch to nft and type:
> 
>         nft list ruleset > nft-ruleset.file
> 
> and start to replacing to native expressions progressively.
> 
> We also have a prototype translation layer (see xlate in the iptables
> tree), that will provide an automatic translation whenever possible.

Yes, that's a very good thing to have.

> The idea is that they will periodically run something like:
> 
>         nft --migrate nft-ruleset.file
> 
> that will detect xt statements and will translate them to native
> expressions whenever possible.
> 
> I think we have to ease adoption through these facilities, and new
> nice features, of course.

I agree, my concern is just putting this into nft where we can't remove
it easily again. Having the translation to native is great. Supporting
xt natively is an entirely different story since chances are very high
that people will just leave the xt compat expressions in the ruleset.

We can tell them to periodically update their rulesets. They still won't
do it, and there are legitimate reasons not to since the nft ruleset
might have been changed.
