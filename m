From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 01:36:13 +0100
Message-ID: <20150410003612.GJ13473@acer.localdomain>
References: <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409232106.GB13473@acer.localdomain>
 <20150409234424.GB6169@salvia>
 <20150409234843.GF13473@acer.localdomain>
 <20150410000734.GA6678@salvia>
 <20150410001151.GH13473@acer.localdomain>
 <20150410003632.GB6929@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35074 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbbDJAgS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 20:36:18 -0400
Content-Disposition: inline
In-Reply-To: <20150410003632.GB6929@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 01:11:52AM +0100, Patrick McHardy wrote:
> > On 10.04, Pablo Neira Ayuso wrote:
> > > > And actually if you consider what the majority of users are, its people
> > > > using distro provided firewalls, the translation layer will actually
> > > > get us the huge majority of users.
> > > >
> > > > People who actively want to switch won't mind changing their ruleset,
> > > > so they might as well tell us if some feature is missing and we can
> > > > then discuss how to implement it in nftables.
> > > 
> > > They will tell us what they need, then they will sit down waiting
> > > until distributors start packaging the new feature, which means
> > > another wait of ~2 years. Most people rely on Linux distributions, not
> > > bleeding edge kernels. You know how behind people can remain from
> > > mainstream to feel -stable.
> > 
> > Some distributions are *a lot* faster than that. I don't buy that
> > argument, this is how development has always worked, people state
> > what they need, it gets done.
> 
> Even most skilled sysadmin that I know tend to stick to conservative
> distributions to relieve their workload, specially when they have to
> maintain hundred, thousands of systems.
> 
> Propagation timing of nftables to production will take quite some time
> and will have to coexist with iptables for long time.
> 
> Fact is that we won't be able to get rid of iptables for years.

Nobody doubts that. You still have to consider the consequences, and
they are not pretty. Lets stick to the other thread to avoid repeating
ourselves.
