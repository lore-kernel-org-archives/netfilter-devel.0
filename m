From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 7/9] netfilter: conntrack: make netns address
 part of hash
Date: Mon, 2 May 2016 23:52:54 +0200
Message-ID: <20160502215254.GA2395@breakpoint.cc>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
 <1462207174-24561-1-git-send-email-fw@strlen.de>
 <1462207885.5535.258.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47424 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166AbcEBVw6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 May 2016 17:52:58 -0400
Content-Disposition: inline
In-Reply-To: <1462207885.5535.258.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Mon, 2016-05-02 at 18:39 +0200, Florian Westphal wrote:
> > +static inline u32 nf_conntrack_netns_hash(const struct net *net)
> > +{
> > +#ifdef CONFIG_NET_NS
> > +	return hash32_ptr(net);
> > +#else
> > +	return 0;
> > +#endif
> > +}
> > +
> 
> Are you reinventing net_hash_mix() ?

Yes, will respin, thanks Eric!

> If net_hash_mix() is not good enough, please fix it ;)

No, I did not know about it, thats all.  It will do just fine, thanks
for the hint!
