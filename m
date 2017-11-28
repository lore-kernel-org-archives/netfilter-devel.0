From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 2/3] netfilter: ctnetlink: use 64-bit
 conntrack ID
Date: Tue, 28 Nov 2017 21:27:41 +0100
Message-ID: <20171128202741.GA16528@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128021309.11277-2-pablo@netfilter.org>
 <20171128121206.GG23412@breakpoint.cc>
 <20171128154509.GB1444@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        richard@nod.at
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52028 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752127AbdK1U2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 15:28:51 -0500
Content-Disposition: inline
In-Reply-To: <20171128154509.GB1444@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 28, 2017 at 01:12:06PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  static int ctnetlink_flush_conntrack(struct net *net,
> > > @@ -1174,6 +1177,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
> > >  			nf_ct_put(ct);
> > >  			return -ENOENT;
> > >  		}
> > > +	} else if (cda[CTA_ID64]) {
> > > +		u64 id = ntohl(nla_get_be64(cda[CTA_ID64]));
> > 
> > be64_to_cpu()?
> > 
> > But at this point we already uniquely identified the conntrack entry
> > so the ID check appears to be unneeded?
> > 
> > I never understood existing test either, so this remark isn't specific
> > to your patch.
> 
> When the ID was incremental, not a memory address, you could use it to
> specifically refer to a conntrack through tuple + id.
>
> If a conntrack with tuple X is gone, then created again, you refer to
> the right object.

Yes, but why was that needed?!

I understand what it does, I don't understand the use case :)
