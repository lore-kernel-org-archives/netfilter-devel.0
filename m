From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf RFC] netfilter: fix netns dependencies with conntrack
 templates
Date: Mon, 13 Jul 2015 21:26:55 +0200
Message-ID: <20150713192655.GA25674@breakpoint.cc>
References: <1436793108-3807-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
	daniel@iogearbox.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47079 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbbGMT06 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 15:26:58 -0400
Content-Disposition: inline
In-Reply-To: <1436793108-3807-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +static struct nf_conn *get_next_tmpl(struct net *net)
> +{
> +	struct nf_conntrack_tuple_hash *h;
> +	struct hlist_nulls_node *n;
> +	struct nf_conn *ct = NULL;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
> +
> +		spin_lock_bh(&pcpu->lock);
> +		hlist_nulls_for_each_entry(h, n, &pcpu->tmpl, hnnode) {
> +			ct = nf_ct_tuplehash_to_ctrack(h);
> +			break;
> +		}
> +		spin_unlock_bh(&pcpu->lock);
> +	}
> +	return ct;
> +}
> +
> +void nf_ct_tmpl_cleanup(struct net *net)
> +{
> +	struct nf_conn *tmpl;
> +
> +i_see_dead_people:
> +	while ((tmpl = get_next_tmpl(net)) != NULL)
> +		nf_ct_put(tmpl);
> +

This seems bogus, this _puts() conntracks we don't own, leading
to refcnt underflow/use-after-free?

I'd just get rid of all of the above.  After your change we
don't depend on the kmem_cache anymore so its ok to leave freeing to
the CT target ->destroy() hook, provided we also fix up the tmpl list
handling (i'd suggest to just remove it and make each template sit
on their 'own' list -- so the hlist_nulls_unhashed() BUG_ONs don't
fire).

Other than that, this patch seems like the least ugly approach.

Thanks Pablo!
