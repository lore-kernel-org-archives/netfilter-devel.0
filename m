Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6642C3F12C0
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 12:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598871; cv=none; b=n0Lsd/+bF0Gu1iBFpETP5dEeO4bieLCK4NNR4qwg7i6pL8fzL0WyLzX4NeplZwvFdmQjUsM8+aqa0mLucXf2JtVyaHCHiINHo54OSltMJ3mDVUtVfU5bpIZkvH+xcY/z1m4LGfX7LJfQ91UsLTnK+ipkctzptY0jmUQj78lw2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598871; c=relaxed/simple;
	bh=AEtaYjSyy7olDDklVZkjz3SnIdx7AKNrU+lwkyKt804=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtUYeifBrllLCUnqZixFKhx71w95ciiJMakzEmP7TQ9WWmoSY0LkkZjixMsZyhdToblLPfnZo2dafk8YCFh+kUG3t4Ag7CWkAwWClovnleNH7tJNOALrWjyz7kWbB7WcPZQibi0MB65jcmKfpO7zaKs0TSunCN709hYoRZQ7QDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jvVajiyG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jvVajiyG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8493D6017D;
	Thu,  9 Jul 2026 14:07:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783598867;
	bh=v6XenYw0+edQlMjw7w56Pa2npxuOpJniBNcAKfqN8Tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvVajiyGtjYKfLqW24gDl1z72NTIPcjyKwijlwcB+VYP1Gb97jLQBoDZbDmkUEx0V
	 tjK2mUV1XIlWsLI1WwBtCZBGfyLZJQtRSbpeEiB0lHx/UUqjBgKjfvZG8dSEPj52ac
	 QLhFSpdrfahX5vfqr4WM/l0A50M38lxg6EduRyx3jtY7+TERK+u4kDd7Ckb+aMrS66
	 vmMOsHB0kN3jQgBSc43j/Xjmuqemw8wGdTmPB83q5IrKmoYyvVUyrKomywT9ZOOPcH
	 EprMo4jhKQR8ZQ+6K4RXSRfQm3SmORx2bekWmlX0tml6kqzvGF+12+uJU3zquhIanC
	 2pSfMHM72vubw==
Date: Thu, 9 Jul 2026 14:07:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [nf-next PATCH 2/4] netfilter: nfnetlink_hook: Deref hook entry
 using READ_ONCE()
Message-ID: <ak-PECbcevqjy91_@chamomile>
References: <20260708161940.1477671-1-phil@nwl.cc>
 <20260708161940.1477671-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708161940.1477671-3-phil@nwl.cc>

Hi Phil,

On Wed, Jul 08, 2026 at 06:19:38PM +0200, Phil Sutter wrote:
> Writer (nf_remove_net_hook) assigns to the field value using
> WRITE_ONCE(), appropriately call READ_ONCE() to make sure reader
> (nfnl_hook_dump) sees either the old or new value, not both.

A bit broader question here:

Are we sure net/netfilter/core.c is safe to be walked over rcu in its
current state? Could the dummy_ops be exposed through nfnetlink_hook?

Maybe net/netfilter/core.c needs a revisited to use
rcu_assign_pointer() to assign the hook_ops to the blob, then
nfnetlink_hook uses rcu_dereference() instead of READ_ONCE.
Then the RCU semantics of the hooks would exposed in a better way?

That would made double use of RCU, one from the blob and then for the
hook_ops.

The hooks are now released using kfree_rcu(), at least in the recent
nf_nat core updates they are.

> Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nfnetlink_hook.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
> index e47a2add4d5b..efc674fc5adf 100644
> --- a/net/netfilter/nfnetlink_hook.c
> +++ b/net/netfilter/nfnetlink_hook.c
> @@ -390,10 +390,12 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
>  	ops = nf_hook_entries_get_hook_ops(e);
>  
>  	for (; i < e->num_hook_entries; i++) {
> -		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
> -			err = nfnl_hook_dump_nat(nlskb, cb, ops[i], family);
> +		struct nf_hook_ops *cur = READ_ONCE(ops[i]);
> +
> +		if (cur->hook_ops_type == NF_HOOK_OP_NAT)
> +			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
>  		else
> -			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
> +			err = nfnl_hook_dump_one(nlskb, ctx, cur,
>  						 ops[i]->priority, family,
>  						 cb->nlh->nlmsg_seq);
>  		if (err)
> -- 
> 2.54.0
> 
