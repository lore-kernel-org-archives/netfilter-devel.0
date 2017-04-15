From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Sat, 15 Apr 2017 11:50:37 +0200
Message-ID: <20170415095037.GA14728@salvia>
References: <20170415084505.26176-1-fw@strlen.de>
 <20170415084505.26176-2-fw@strlen.de>
 <20170415090945.GA4023@salvia>
 <20170415094439.GB1707@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753226AbdDOJur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:50:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84417E04CA
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7423EDA725
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0E6ADA86C
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:50:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415094439.GB1707@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 11:44:39AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I wonder if this should go in a oneliner, given this is fixing the
> > fact that we may end up using the template. So someone has a chance to
> > pass it to -stable. I'll be fine either way, no problem.
> 
> Ok. will do.

Thanks Florian.

> > > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > > +	case NFT_CT_EVENTMASK: {
> > > +		struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> > > +		u16 ctmask = (u16)regs->data[priv->sreg];
> > 
> > Liping added helpers to fetch data from registers, I think it
> > applies to this case too.
> 
> Right, I forgot about this, thanks for noticing.
> Having such huge backlog is crap, I won't do this again, ever :(

I tend to repeat this to myself... but sometimes it doesn't seem to
work ;)
