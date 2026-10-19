Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC433B97D;
	Mon, 19 Oct 2026 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372890; cv=none; b=rNQqSUZ6rLRBFWcjyW8OYS6G376bqvqRlom+/F1RyQU5YrkT6uo/ExW4Gx4Aej8qQNtF/sIPwRHPrw1oLdYW7zdV+Zaim2ddL+YZ+eCe0vabVi04y9q+xPREItk5bEyY9pcV4iYZdPB6jJNjLX07i52tOoD9dA9kLvg6LRZcGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372890; c=relaxed/simple;
	bh=DWDLuhUd3dL1+RP7CK2kD37Ju5Yo8afFksUUaEZGjDo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MzEWo6fy06MCGl8AeANOFAWusESSEfu3+0aMm3/xX1ZZDa7NqV9emBJufyqNEWQT7mOq7pBGc/IJuY1/R0WvhmdoZktRCo6M/GroPWTPalOaBBI+9IUx+n0P5dV+YwDW24gSxkW8uvPyJIL4wKwDo9Lsbi+/t+tBy088EyeMAd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyIr7X+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyIr7X+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8696C1F000C5;
	Mon, 19 Oct 2026 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372888;
	bh=SckjzOby05zG37Rs+iZd5jpvtjxUQtaYPC7EXHq3V8Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SyIr7X+72rflchTA3vpHNE53eMFmNKHNhooVPUsFUliIirOCrECwgM4GLZfnM53HO
	 3C50bnyOB645yXgi09jAOb4KSgS/LYD98zzl6MF9YPcmsumTpVhNUIUTqgRx+iGk8F
	 CDd4mfI7Hqre00pjYtYlqwcLkV7jnIp8oF8lli00AfQNQ3uI3EsuKIUgFevNqK0kTb
	 ffZx9lkrR/cxDRhOOq5SINWP9Dn9lj51rtEPtSxr35D4RfES8BcYxG0kbfUz5RJatk
	 knwY7cdfSpr69/szG7rjsnG4lNHy6MXhmg0uOhBPV2YplmR4Qymbugznn0GGbvS0LW
	 5n/erdkDyDAwA==
Subject: Re: [PATCH net-next 11/15] netfilter: nft_compat: restrict raw table
 targets/matches
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:27 +0000
Message-ID: <179237288707.3135.2279601200660444288@kernel.org>
In-Reply-To: <20261018005638.1776148-12-pablo@netfilter.org>
References: <20261018005638.1776148-12-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new 'raw' check in nft_compat_chain_validate_dependency()
  (net/netfilter/nft_compat.c:61) depends on basechain->ops.priority.
- [Low] The new comment in nft_compat_chain_validate_dependency() says
  the legacy raw table 'only ever has prerouting/output chains at this…

--

netfilter: nft_compat: restrict raw table targets/matches

This patch extends nft_compat_chain_validate_dependency() so that xt
targets and matches that declare .table = "raw" (CT, NOTRACK) are only
accepted in ip/ip6 base chains hooked at prerouting or output with
priority NF_IP_PRI_RAW. The goal is to stop the CT target from being
loaded at a hook or priority where it would run after conntrack.

> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 63864b9282590..88ddaf47f5879 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c

[ ... ]

> @@ -45,6 +46,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
>  			type = NFT_CHAIN_T_NAT;
>  		if (basechain->type->type != type)
>  			return -EINVAL;
> +	} else if (strcmp(tablename, "raw") == 0) {
> +		/* iptables-nft emulates the legacy raw table, which only
> +		 * ever has prerouting/output chains at this exact priority.
> +		 */

[Severity: Low]
Is this comment accurate? The legacy raw table can also be registered at a
second priority. In net/ipv4/netfilter/iptable_raw.c:

static const struct xt_table packet_raw_before_defrag = {
	.name = "raw",
	.valid_hooks =  RAW_VALID_HOOKS,
	.me = THIS_MODULE,
	.af = NFPROTO_IPV4,
	.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG,
};

The table is selected when the raw_before_defrag module parameter is set.
ip6table_raw.c does the same with NF_IP6_PRI_RAW_BEFORE_DEFRAG.

A CT/NOTRACK target at -450 still runs ahead of conntrack. The new check
below accepts only NF_IP_PRI_RAW, though, so it rejects that priority with
-EINVAL. That makes it stricter than "what xtables enforces", as the
commit message puts it.

Should the comment say that iptables-nft always uses -300? Alternatively,
the check could also accept the before-defrag priority, or any priority
below NF_IP_PRI_CONNTRACK.

> +		if (ctx->family != NFPROTO_IPV4 &&
> +		    ctx->family != NFPROTO_IPV6)
> +			return -EINVAL;
> +
> +		if (basechain->ops.hooknum != NF_INET_PRE_ROUTING &&
> +		    basechain->ops.hooknum != NF_INET_LOCAL_OUT)
> +			return -EINVAL;
> +
> +		if (basechain->ops.priority != NF_IP_PRI_RAW)
> +			return -EINVAL;

[Severity: High]
Can the nf_tables chain validation cache let a jumped-to chain skip this
priority check?

nft_chain_vstate_valid() treats a regular chain as already validated using
only the calling base chain's type, hooknum and the depth:

net/netfilter/nf_tables_api.c:nft_chain_vstate_valid() {
    ...
	if (chain->vstate.depth >= ctx->level &&
	    chain->vstate.hook_mask[type] & BIT(hooknum))
		return true;
    ...
}

nft_chain_vstate_update() records only hook_mask[type] and depth, never the
base chain priority. nft_table_validate() clears vstate only after it has
walked every base chain, so cached results carry over from one base chain
to the next.

Take an ip table named "raw" with:

  base chain A: type filter, hook prerouting, priority -300, rule "jump X"
  base chain B: type filter, hook prerouting, priority 0, rule "jump X"
  regular chain X: an nft_compat rule using the CT target

Chain A is created first. Validating A goes like this:

nft_table_validate()
  nft_chain_validate(A)
    nft_immediate_validate()            /* level 1 */
      nft_chain_validate(X)
        nft_target_validate()
          nft_compat_chain_validate_dependency()  /* passes, A is -300 */
        nft_chain_vstate_update()       /* FILTER/PRE_ROUTING, depth 1 */

Then for B:

  nft_chain_validate(B)
    nft_immediate_validate()            /* level 1 */
      nft_chain_validate(X)
        nft_chain_vstate_valid()        /* true */
        return 0;

So the new check never runs with B as ctx->chain, and the ruleset is
accepted.

At runtime, nf_conntrack_in() can leave skb->_nfct == 0 for an invalid
packet. It also clears any raw-table template before tracking, so an
unconditional jump in A doesn't help. B then jumps to X after conntrack,
and xt_ct_target() attaches the template:

	if (skb->_nfct != 0)
		return XT_CONTINUE;

	if (ct) {
		refcount_inc(&ct->ct_general.use);
		nf_ct_set(skb, ct, IP_CT_NEW);

Isn't this the same "after the real conntrack hook has already run" case
that the commit message says this patch closes? It can be reached with
CAP_NET_ADMIN in an unprivileged user namespace.

Could the vstate key be made priority-aware (or carry a pre-conntrack
bit)? Other options would be to skip the cache for chains that hold compat
expressions with a table dependency, or to run this check for every base
chain that can reach the rule.

>  	}
>  
>  	return 0;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
