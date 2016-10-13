From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Thu, 13 Oct 2016 17:04:23 +0200
Message-ID: <20161013150423.GB1301@salvia>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
 <20161013123821.GC14002@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752675AbcJMPFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 11:05:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C7BB62D2A
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:04:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DB78DA7FA
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:04:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 114C7DA817
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:04:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161013123821.GC14002@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 13, 2016 at 02:38:21PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> > index de4fa03f46f3..7040842c34f4 100644
> > --- a/net/ipv4/netfilter/ip_tables.c
> > +++ b/net/ipv4/netfilter/ip_tables.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/netfilter/x_tables.h>
> >  #include <linux/netfilter_ipv4/ip_tables.h>
> >  #include <net/netfilter/nf_log.h>
> > +#include <net/netfilter/nf_queue.h>
> >  #include "../../netfilter/xt_repldata.h"
> >  
> >  MODULE_LICENSE("GPL");
> > @@ -329,6 +330,9 @@ ipt_do_table(struct sk_buff *skb,
> >  				/* Pop from stack? */
> >  				if (v != XT_RETURN) {
> >  					verdict = (unsigned int)(-v) - 1;
> > +					if (verdict == NF_QUEUE)
> > +						verdict = nf_queue(skb, state,
> > +								   0, false);
> 
> Any reason why this is needed?
> AFAICS xt_NFQUEUE will never return NF_QUEUE after this patch.

-j QUEUE uses the standard target to return NF_QUEUE. This is very
primitive way to queue packets to userspace queue 0 via nf_queue, but
still may break. I can place this under unlikely() as these days
people should be using NFQUEUE instead.

> > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > index 2b3b2f8e39c4..9ae2febd86e3 100644
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -309,6 +309,7 @@ unsigned int nf_iterate(struct sk_buff *skb,
> >  	unsigned int verdict;
> >  
> >  	while (*entryp) {
> > +		RCU_INIT_POINTER(state->hook_entries, *entryp);
> >  repeat:
> >  		verdict = (*entryp)->ops.hook((*entryp)->ops.priv, skb, state);
> >  		if (verdict != NF_ACCEPT) {
> > @@ -331,9 +332,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
> >  	int ret;
> >  
> >  	entry = rcu_dereference(state->hook_entries);
> > -next_hook:
> >  	verdict = nf_iterate(skb, state, &entry);
> > -	switch (verdict & NF_VERDICT_MASK) {
> > +	switch (verdict) {
> 
> This looks buggy, verdict might encode errno for NF_DROP case.
> 
> What you could do is:
> 
> switch (verdict) {
> case NF_ACCEPT:
>        	/* something */
> 	break;
> case NF_STOLEN:
> 	break;
> case NF_DROP: /* fallthrough */
> default: /* drop with error? */
> 	kfree_skb(skb);
> 	errno = ...
> }

Right, will fix this, thanks. 
