Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5645FFD2;
	Mon, 19 Oct 2026 05:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792387069; cv=none; b=qhZ4ZlMAKPdbXK8rbPFn8TarL2CXNLwT/3uYXb5qL9+FMJE9iU1zWcZeYzoXBEwhAJxsY+NVZNcNCvHI4Lzos/WEmWwxTWwByyt3dzkwGzqzp5ZP4fIweWMi7Ai+OG1CVdBhB1o6oei2Gq4ULygbztFlZHINcslaLu16c2FQmuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792387069; c=relaxed/simple;
	bh=B08RXXpyme/BYmvMMvdfmYleZPfMrfAFRNC0fARIDU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtDUGQ05NQOKXh3Yx9cjzQnQ+vMhABslAUgVuuIf3rmvy9bP4c/EAgnivGSozuQfHQRjjK2y3xbhZo9Hwbq7Gf6k8F8a3lMw88qls4d/0dtGozVHIyx/oMzVb3euFkTPRgHC9zTHpCdtXQUgEgdHcVm4FN2QZg0X+HVjXu/zVbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EEC2260272; Mon, 19 Oct 2026 07:17:43 +0200 (CEST)
Date: Mon, 19 Oct 2026 07:17:43 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 11/15] netfilter: nft_compat: restrict raw table
 targets/matches
Message-ID: <atWn90Ft79wpakPa@strlen.de>
References: <20261018005638.1776148-12-pablo@netfilter.org>
 <179237288707.3135.2279601200660444288@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288707.3135.2279601200660444288@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:

TL;DR, this patch is fine as-is, but a complementary patch to
validate nft_ct.c and handle vstate cache is missing from this PR.  This
does not cause any breakage, though.

> - [High] The new 'raw' check in nft_compat_chain_validate_dependency()
>   (net/netfilter/nft_compat.c:61) depends on basechain->ops.priority.
> - [Low] The new comment in nft_compat_chain_validate_dependency() says
>   the legacy raw table 'only ever has prerouting/output chains at this…
> > @@ -45,6 +46,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
> >  			type = NFT_CHAIN_T_NAT;
> >  		if (basechain->type->type != type)
> >  			return -EINVAL;
> > +	} else if (strcmp(tablename, "raw") == 0) {
> > +		/* iptables-nft emulates the legacy raw table, which only
> > +		 * ever has prerouting/output chains at this exact priority.
> > +		 */
> 
> [Severity: Low]
> Is this comment accurate?

Is this a trick question?

> The legacy raw table can also be registered at a
> second priority. In net/ipv4/netfilter/iptable_raw.c:

[..]

> The table is selected when the raw_before_defrag module parameter is set.
> ip6table_raw.c does the same with NF_IP6_PRI_RAW_BEFORE_DEFRAG.

iptables-nft doesn't use iptable_raw.c nor does it emulate this
module param.

> A CT/NOTRACK target at -450 still runs ahead of conntrack. The new check
> below accepts only NF_IP_PRI_RAW, though, so it rejects that priority with
> -EINVAL. That makes it stricter than "what xtables enforces", as the
> commit message puts it.

Why should I support -450 ? iptables-nft doesn't use/support that.

> Should the comment say that iptables-nft always uses -300?

*shrug*, thats what I intended to convey: iptables-nft only uses
-300, hence hard refusal.

> Alternatively,
> the check could also accept the before-defrag priority, or any priority
> below NF_IP_PRI_CONNTRACK.

"Yes" (but I don't see why it should)

> [Severity: High]
> Can the nf_tables chain validation cache let a jumped-to chain skip this
> priority check?

Yes, this patch only works with this applied as well:

[PATCH nf-next] netfilter: nft_ct: validate hook and priority for ct zone set
https://lore.kernel.org/netfilter-devel/atDHof0kFWIWIf6-@strlen.de/T/#t

> nft_chain_vstate_valid() treats a regular chain as already validated using
> only the calling base chain's type, hooknum and the depth:
> 
> net/netfilter/nf_tables_api.c:nft_chain_vstate_valid() {
>     ...
> 	if (chain->vstate.depth >= ctx->level &&
> 	    chain->vstate.hook_mask[type] & BIT(hooknum))
> 		return true;
>     ...
> }
> 
> nft_chain_vstate_update() records only hook_mask[type] and depth, never the
> base chain priority. nft_table_validate() clears vstate only after it has
> walked every base chain, so cached results carry over from one base chain
> to the next.

Yes, the above linked patch did add two prio fields to the vstate for this.

>   base chain A: type filter, hook prerouting, priority -300, rule "jump X"
>   base chain B: type filter, hook prerouting, priority 0, rule "jump X"
>   regular chain X: an nft_compat rule using the CT target
> 
> Chain A is created first. Validating A goes like this:
> 
> nft_table_validate()
>   nft_chain_validate(A)
>     nft_immediate_validate()            /* level 1 */
>       nft_chain_validate(X)
>         nft_target_validate()
>           nft_compat_chain_validate_dependency()  /* passes, A is -300 */
>         nft_chain_vstate_update()       /* FILTER/PRE_ROUTING, depth 1 */

With the vstate patch, this should now have vstate change set to -300
for min and max priorities.

> Then for B:
> 
>   nft_chain_validate(B)
>     nft_immediate_validate()            /* level 1 */
>       nft_chain_validate(X)
>         nft_chain_vstate_valid()        /* true */
>         return 0;
> 
> So the new check never runs with B as ctx->chain, and the ruleset is
> accepted.

With vstate patch, this would fail the vstate_valid test because prio 0
is larger than previous prio_max validation (-300).

> At runtime, nf_conntrack_in() can leave skb->_nfct == 0 for an invalid
> packet. It also clears any raw-table template before tracking, so an
> unconditional jump in A doesn't help. B then jumps to X after conntrack,
> and xt_ct_target() attaches the template:
> 
> 	if (skb->_nfct != 0)
> 		return XT_CONTINUE;
> 
> 	if (ct) {
> 		refcount_inc(&ct->ct_general.use);
> 		nf_ct_set(skb, ct, IP_CT_NEW);
> 
> Isn't this the same "after the real conntrack hook has already run" case
> that the commit message says this patch closes? It can be reached with
> CAP_NET_ADMIN in an unprivileged user namespace.

Yes.

> Could the vstate key be made priority-aware (or carry a pre-conntrack
> bit)?

Yes, patch is on ML.  But even if I had placed the vstate patch in this
one, its still incomplete because nft_ct allows template attachmnent as
well.

Both patches are needed.

> Other options would be to skip the cache for chains that hold compat
> expressions with a table dependency, or to run this check for every base
> chain that can reach the rule.

Would work if nft_ct.c would not exist.
