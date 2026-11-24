Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531180;
	b=EYWEuNy8hPSgaPHuuOOTdSH41qsHv7fhvOm9xBkOCubD3XjtTnOxnRggRQYKhQS3vvGX
	 CgDfJJuEzRBAwm+SpdPt/8gQUhvhrt1IZ7+fXGMzD8BKZTRTE3bWdmaqzjSpBQ96lJWEh
	 UUUiv/uh5IiVWCWENRiX0EdJh31Il8I0rBbIhAO2nj7Tr39D+VWA68Spzf4XFsp+F2KI9
	 sblDKNIIQU5076aC+HubH1cXONOazSK1G5M+EAmpVxb9/QTE8gxXy1llUj6F+ZvlGTQMk
	 tljhj/whyLuYKh9pB/CgTXTEQNQpeZbcjN9aqD/hcxf7kalhtV8GXItJbX1wpSLvZnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531180;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ssdteKdpnLw+8yfvKCIYIIv1Lym9PUjNxVQxWZ5Vlrk=;
	b=pZupSmlFTj4CrPz/oH6s2M5ID6uEF6EOpp7kd7S929YMXx+eaTe/Xxrt0HRL254zGhmN
	 2q8Gl/FYjUhjss63mZ1J3NrlgK2PV1kCO/oW2qTsWiu9wP2aoxeb1ZOiZgsyRpttiCQUe
	 xdp00Yhuli5BBa8cljCPUUK2DYHBvZLFDdVEOFeF+pqkrWuMXkMb2GYdMoaaIIlcO/9nv
	 aeDruVJh2yqIN9YeOg42kX8o42+Koyl8Ls4vE+nxA2e6Z6/jj6biVjhfxBZDuu6ambb7P
	 U8h89VwxDzuI4FXw7CHgfPip9qxM1BGymSHprqh/iziASIn74cAGodHN0PjNe7XWuCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITWGgMtr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF325606A336;
	Tue, 24 Nov 2026 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITWGgMtr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052BA1F000C4;
	Tue, 24 Nov 2026 14:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531179;
	bh=ssdteKdpnLw+8yfvKCIYIIv1Lym9PUjNxVQxWZ5Vlrk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ITWGgMtro0OLaKIxeZTB34NMngFuxkah/3xUlbIVCsU7rAZgbeB24FtZRB2nyMtQd
	 EEAXsLEk+TpPjqmKJf3jrwo+Im53D01EsWAInulr2EEIw+vJQ4D2/IyA654fzt8uiL
	 BLtQhcgRD3dJtZXO1h0wX0XIOzuSGBPzL7QwNnC0m8jU598DuxZEUKBIlVO6WN0irl
	 ni2SiZkQSRd4Dmn6QIhfYwXgFfw+Io89u6HTMAiH76bQqJaLfuSP2YFQQVTeDFGE2y
	 KHVQYZjbCexzlP9g6ageR6IB7P/zAc8zEpbzy7GDXLMiWuMVfkZ+a/ndiFo8iIE5q2
	 h0JRaYyMWRUOw==
Subject: Re: [PATCH net-next 09/15] netfilter: nft_ct: validate hook and
 priority for ct zone set
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:38 +0000
Message-ID: <179553117857.3135.6445016477100747044@kernel.org>
In-Reply-To: <20261123135726.3940688-10-pablo@netfilter.org>
References: <20261123135726.3940688-10-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message describes a failure that cannot happen, and
  the core hunk it adds can never run.
- [Medium] nft_ct_set_zone_validate() now rejects 'ct zone set' in inet-
  family chains on the ingress hook (NF_INET_INGRESS).
- [Low] The commit message does not mention the required change to the
  generic nf_tables chain-validation cache.

--

netfilter: nft_ct: validate hook and priority for ct zone set

This patch adds a .validate callback to the ct zone set expression. The
callback limits the expression to prerouting/output base chains that are
not NAT chains and run before conntrack, in the ip, ip6, inet and bridge
families. The patch also makes the nf_tables chain validation cache take
the chain priority into account, and adds a template check to
__nf_conntrack_confirm().

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index d2cd9b31507e6..707a9006537de 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1198,6 +1198,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
>  		return NF_ACCEPT;
>  
> +	if (unlikely(nf_ct_is_template(ct))) {
> +		DEBUG_NET_WARN_ON_ONCE(1);
> +		return NF_ACCEPT;
> +	}
> +

[Severity: Medium]

Can an nft_ct template ever reach this check? The commit message says:

  "on paths where no conntrack hook runs for the skb afterwards, the
  unconfirmed per-cpu template can reach the conntrack confirm hook and
  get inserted into the global hash table as if it were a genuine
  connection."

Both templates that nft_ct attaches are created with the confirmed bit
already set. In nft_ct_tmpl_alloc_pcpu():

		__set_bit(IPS_CONFIRMED_BIT, &tmp->status);
		per_cpu(nft_ct_pcpu_template, cpu) = tmp;

And in the GFP_ATOMIC fallback of nft_ct_set_zone_eval():

		__set_bit(IPS_CONFIRMED_BIT, &ct->status);

The two in-tree callers of __nf_conntrack_confirm() both skip confirmed
entries. In nf_conntrack_confirm():

	if (ct) {
		if (!nf_ct_is_confirmed(ct)) {
			ret = __nf_conntrack_confirm(skb);

And in br_nf_local_in():

	if (likely(nf_ct_is_confirmed(ct)))
		return NF_ACCEPT;

nf_confirm() calls nf_ct_call_helper() before the confirm step. For a
zone template that call returns NF_ACCEPT right away, because the
template has no helper extension and IPS_SEQ_ADJUST is not set.

The act_ct and openvswitch templates can be unconfirmed. However,
nf_conntrack_in() clears skb->_nfct before any confirm hook sees them.

If so, the new nf_ct_is_template() check in __nf_conntrack_confirm()
can't be reached, and the commit message doesn't mention it as a
separate change.

Could the commit message describe the user-visible problem behind the
Fixes: tag? Or is there another path where an unconfirmed template
reaches the confirm hook?

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8b94b5e7dbdbd..a13b970ee1bd8 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c

[ ... ]

> @@ -137,9 +143,10 @@ static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
>  	hooknum = base_chain->ops.hooknum;
>  	type = base_chain->type->type;
>  
> -	/* chain is already validated for this call depth */
> +	/* chain is already validated for this call depth and priority */
>  	if (chain->vstate.depth >= ctx->level &&
> -	    chain->vstate.hook_mask[type] & BIT(hooknum))
> +	    chain->vstate.hook_mask[type] & BIT(hooknum) &&
> +	    nft_chain_vstate_valid_prio(&chain->vstate, base_chain->ops.priority))
>  		return true;
>  
>  	return false;
> @@ -2782,6 +2789,25 @@ int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
>  
>  static u64 chain_id;
>  
> +static void nft_chain_vstate_init(struct nft_chain_validate_state *v)
> +{
> +	memset(v, 0, sizeof(*v));
> +
> +	/* Inverted.  A chain at priority P can skip valiation
> +	 * if min <= P <= max.
> +	 *
> +	 * The inverted start fails the test for all values of P.
> +	 * nft_chain_vstate_update() will shrink prio_min to P
> +	 * and grow prio_max to P, so that after first run:
> +	 * prio_min == prio_max == P.  A subsequent validation
> +	 * request will only skip if P1 == P2 amd revalidate
> +	 * otherwise, including an update of either prio_min or
> +	 * prio_max.
> +	 */
> +	v->prio_min = INT_MAX;
> +	v->prio_max = INT_MIN;
> +}

[Severity: Low]

This isn't a bug, but the commit message doesn't mention the change to
the generic chain validation cache. The patch:

- adds prio_min and prio_max to struct nft_chain_validate_state
- adds nft_chain_vstate_init() and nft_chain_vstate_reinit()
- makes the skip test in nft_chain_vstate_valid() depend on the calling
  base chain's priority

The fix seems to need this. Without it, a regular chain first validated
from a prerouting chain at priority -300 would be skipped when reached
from a prerouting chain at priority 0, which bypasses the priority check
in nft_ct_set_zone_validate().

The change also affects the skip logic for every expression's .validate
callback, but the message only says "Add a validate callback".

The range tracking in nft_chain_vstate_update() only works for
validators whose accepted priorities form one contiguous range that
doesn't depend on hook or chain type. That holds for ct zone set and for
the nft_compat NF_IP_PRI_RAW check. Could this assumption be documented?

The Fixes: tag points at a 2017 commit, so trees without the vstate
cache would need a different backport. The message could note that too.

The new comment has two typos: "valiation" and "amd".

The commit message also says nearly the same thing twice:

  "Also, mirror what classic xtables CT target is doing: CT target is
  restricted to the 'raw' table ..."

  "This mirrors why the classic xtables CT target is restricted to the
  raw table (PREROUTING/OUTPUT, ahead of conntrack)."

[ ... ]

> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index a19a839a0fc0b..9ed9cad090e4c 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c

[ ... ]

> @@ -755,6 +756,46 @@ static const struct nft_expr_ops nft_ct_set_ops = {
>  };
>  
>  #ifdef CONFIG_NF_CONNTRACK_ZONES
> +static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
> +				    const struct nft_expr *expr)
> +{
> +	unsigned int hooks;
> +	int err;
> +

[ ... ]

> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +	case NFPROTO_INET:
> +		hooks = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT);
> +		break;

[Severity: Medium]

Is ct zone set now rejected in inet family chains on the ingress hook?
For NFPROTO_INET this mask doesn't include NF_INET_INGRESS, so
nft_chain_validate_hooks() returns -EOPNOTSUPP for a ruleset like this:

  table inet t {
    chain c {
      type filter hook ingress device eth0 priority 0;
      ct zone set 1
    }
  }

The ingress hook runs from __netif_receive_skb_core(), before IP
prerouting defrag and nf_conntrack_in(). That meets the commit's own
"before conntrack" condition.

Before this patch, such a rule loaded and worked:

- nft_ct_set_init() succeeds with nf_ct_netns_get(net, NFPROTO_INET).
- nft_ct_set_zone_eval() attaches the template.
- At prerouting, nf_ct_defrag_user() and nf_conntrack_in() pick up the
  zone from skb_nfct().

With this patch the whole nft transaction is aborted, so a ruleset that
used to load no longer does. Because of the Fixes: tag, this would
probably reach stable kernels.

Should NF_INET_INGRESS be allowed for inet? If so, the
NF_IP_PRI_CONNTRACK priority check would need to be skipped for ingress,
since ingress priorities are not ordered against the conntrack hook.

The netdev family isn't affected: nf_ct_netns_do_get() already returns
-EPROTO for NFPROTO_NETDEV.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
