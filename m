From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 02:36:32 +0200
Message-ID: <20150410003632.GB6929@salvia>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409232106.GB13473@acer.localdomain>
 <20150409234424.GB6169@salvia>
 <20150409234843.GF13473@acer.localdomain>
 <20150410000734.GA6678@salvia>
 <20150410001151.GH13473@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbbDJAcZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 20:32:25 -0400
Content-Disposition: inline
In-Reply-To: <20150410001151.GH13473@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 10, 2015 at 01:11:52AM +0100, Patrick McHardy wrote:
> On 10.04, Pablo Neira Ayuso wrote:
[...]
> > The user will run translation and will notice than some feature is
> > missing. Bad luck, he will retry months later. It will keep repeating
> > the process until it gets the features it needs. No matter how nice
> > nftables features are, because he still don't have access to what it
> > needs.
> 
> How are things missing in the translation layer? That one already
> supports compat and that is fine.
> 
> Its nft that might be missing features for him. So if it doesn't suit
> him, he'll try a different time. What's the big deal? Or ideally, he'll
> let us know. This is exactly how iptables gained in features.

ipchains was way more simple tool, and even though we needed *more
than 10 years* to get rid of that code.

> > > And actually if you consider what the majority of users are, its people
> > > using distro provided firewalls, the translation layer will actually
> > > get us the huge majority of users.
> > >
> > > People who actively want to switch won't mind changing their ruleset,
> > > so they might as well tell us if some feature is missing and we can
> > > then discuss how to implement it in nftables.
> > 
> > They will tell us what they need, then they will sit down waiting
> > until distributors start packaging the new feature, which means
> > another wait of ~2 years. Most people rely on Linux distributions, not
> > bleeding edge kernels. You know how behind people can remain from
> > mainstream to feel -stable.
> 
> Some distributions are *a lot* faster than that. I don't buy that
> argument, this is how development has always worked, people state
> what they need, it gets done.

Even most skilled sysadmin that I know tend to stick to conservative
distributions to relieve their workload, specially when they have to
maintain hundred, thousands of systems.

Propagation timing of nftables to production will take quite some time
and will have to coexist with iptables for long time.

Fact is that we won't be able to get rid of iptables for years.
