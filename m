From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: call synchronize_net only once from
 nf_register_net_hooks
Date: Wed, 22 Nov 2017 12:10:27 +0100
Message-ID: <20171122111027.GG24866@breakpoint.cc>
References: <20171122104026.7592-1-gscrivan@redhat.com>
 <20171122110606.GF24866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Scrivano <gscrivan@redhat.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54664 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751656AbdKVLL1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 06:11:27 -0500
Content-Disposition: inline
In-Reply-To: <20171122110606.GF24866@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > SELinux, if enabled, registers for each new network namespace 6
> > netfilter hooks.  Avoid to use synchronize_net for each new hook, but do
> > it once after all the hooks are added.  The net benefit on an SMP
> > machine with two cores is that creating a new network namespace takes
> > -40% of the original time.
> 
> but this needs more work.
> 
> > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > ---
> >  net/netfilter/core.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > index 52cd2901a097..beeb0b36f429 100644
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -252,7 +252,7 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
> >  	return NULL;
> >  }
> >  
> > -int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> > +static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> 
> Change this to return struct nf_hook_entries *
> 
> >  {
> >  	struct nf_hook_entries *p, *new_hooks;
> >  	struct nf_hook_entries __rcu **pp;
> > @@ -291,11 +291,19 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> >  #ifdef HAVE_JUMP_LABEL
> >  	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
> >  #endif
> > -	synchronize_net();
> >  	BUG_ON(p == new_hooks);
> >  	kvfree(p);
> 
> remove kvfree()
> 
> >  	return 0;
> 
> return p;
> 
> > +int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
> > +{
> > +	int ret = __nf_register_net_hook(net, reg);
> > +	if (ret < 0)
> > +		return ret;
> > +	synchronize_net();
> 
> then free p here.

Yet another alternative is to place an rcu_head at the end of
struct nf_hook_entries.

This is a bit tricky because the location is not fixed due to
dynamically sized array members.

But if you do this you can use call_rcu to do the freeing which removes
need for all but the nfqueue related synchronize_net() calls.
