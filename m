From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_conntrack: fix endless loop on netns
 deletion
Date: Wed, 1 Jul 2015 18:57:55 +0200
Message-ID: <20150701165755.GB30866@breakpoint.cc>
References: <b41741db7ecfaabe74fbcacac9a628375217ee35.1435765328.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52147 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbbGAQ57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2015 12:57:59 -0400
Content-Disposition: inline
In-Reply-To: <b41741db7ecfaabe74fbcacac9a628375217ee35.1435765328.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Borkmann <daniel@iogearbox.net> wrote:
> When adding connection tracking template rules to a netns, f.e. to
> configure netfilter zones, the kernel will endlessly busy-loop as soon
> as we try to delete the given netns in case there's at least one
> template present. Minimal example:
> 
>   ip netns add foo
>   ip netns exec foo iptables -t raw -A PREROUTING -d 1.2.3.4 -j CT --zone 1
>   ip netns del foo

[..]

> +static struct nf_conn *get_next_tmpl(struct ct_pcpu *pcpu)
> +{
> +	struct nf_conntrack_tuple_hash *h;
> +	struct hlist_nulls_node *n;
> +	struct nf_conn *ct = NULL;
> +
> +	spin_lock_bh(&pcpu->lock);
> +	hlist_nulls_for_each_entry(h, n, &pcpu->tmpl, hnnode) {
> +		ct = nf_ct_tuplehash_to_ctrack(h);
> +		break;
> +	}
> +	spin_unlock_bh(&pcpu->lock);
> +
> +	return ct;
> +}
> +
> +static void nf_ct_tmpls_cleanup(struct net *net)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
> +		struct nf_conn *ct;
> +
> +		while ((ct = get_next_tmpl(pcpu)) != NULL)
> +			nf_ct_put(ct);
> +	}
> +}

I was worried next call to nf_ct_tmpls_cleanup() might see same ct
again, thus putting it more than once.

But it seems safe as it runs after a synchronize_net, i.e.  ct refcnt
should always be 1, and thus the nf_ct_put should result in invocation of
destructor & removal from tmplate list.

Thanks Daniel!

Acked-by: Florian Westpha <fw@strlen.de>
