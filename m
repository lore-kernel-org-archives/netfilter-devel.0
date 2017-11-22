From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: call synchronize_net only once from
 nf_register_net_hooks
Date: Wed, 22 Nov 2017 15:54:22 +0100
Message-ID: <20171122145422.GJ24866@breakpoint.cc>
References: <20171122104026.7592-1-gscrivan@redhat.com>
 <20171122110606.GF24866@breakpoint.cc>
 <87a7zea73n.fsf@redhat.com>
 <20171122115659.GH24866@breakpoint.cc>
 <8737569yi7.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Giuseppe Scrivano <gscrivan@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55234 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751371AbdKVOzW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:55:22 -0500
Content-Disposition: inline
In-Reply-To: <8737569yi7.fsf@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > However, I suggest you try to go with call_rcu to get rid of all of the
> > synchronize_net() calls. I don't even see why its still needed for
> > nfqueue case provided we invoke the nfqueue drop handler first.
> >
> > PoC example, untested:
> 
> thanks, the patch seems to work for me, at least the problem I was
> seeing before is now fixed.
> 
> Is there any reason for defining "struct nf_hook_entries_rcu_head"?

Yes, idea is to only place elements we need in packet path at the
beginning of structure.

> I've used this fixup patch and it works as well.  As someone new to the
> code, I find it a bit easier to follow:
> 
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index c08fd706d9c7..663046776def 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -77,12 +77,8 @@ struct nf_hook_entry {
>  	void				*priv;
>  };
>  
> -struct nf_hook_entries_rcu_head {
> -	struct rcu_head head;
> -	void            *allocation;
> -};
> -
>  struct nf_hook_entries {
> +	struct rcu_head                 head;

Right, this works too.
I wanted to keep the rcu head out of the fastpath part
as we only need it during destruction.
