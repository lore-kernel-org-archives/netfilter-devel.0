Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D5B46B8
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 21:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733780194; cv=none; b=oPkJ2gn0136AdmUy+ukP97+nPaNp/giT+8HeNR///tzB5Ywb6FhdnJEJNV1fBm7u2tHW8A6rjelPMoQvo7hyxl1Rz5WHn/u9nAv8tWF7/B1PESGi+Zv/pvbmStp61ArEotBW1qCxN4OR1O5JysK8ZPhatM6ml4JzbhjIRFlEQ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733780194; c=relaxed/simple;
	bh=PNiXulPw/4rsnMtUXmJz8Fk8s4wbvCnqvsclns3lITs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDhMz8ugtNnh85qHt4MErpLxn5AtLcZ0qDoJ6tqMCt2Q+kNeqlc8exeO7r1xIb5RM3hDW3LZOirizurTzHPHiCPnzRKmSi5xpDp4ArCfvmBmHjYcqmWPe5zwqXAn24K0PeLvNCInp0r0M/8kGENl1/gMzLDAcXG9Ru4q0UQcs0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=34972 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tKlHj-00GAFh-30; Mon, 09 Dec 2024 22:27:21 +0100
Date: Mon, 9 Dec 2024 22:27:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	syzkaller-bugs@googlegroups.com,
	syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: do not defer rule destruction
 via call_rcu
Message-ID: <Z1dgtm5IhoJW5vGL@calendula>
References: <67478d92.050a0220.253251.0062.GAE@google.com>
 <20241207111459.7191-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241207111459.7191-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

Hi Florian,

Thanks a lot for your quick fix.

On Sat, Dec 07, 2024 at 12:14:48PM +0100, Florian Westphal wrote:
> nf_tables_chain_destroy can sleep, it can't be used from call_rcu
> callbacks.
> 
> Moreover, nf_tables_rule_release() is only safe for error unwinding,
> while transaction mutex is held and the to-be-desroyed rule was not
> exposed to either dataplane or dumps, as it deactives+frees without
> the required synchronize_rcu() in-between.
> 
> nft_rule_expr_deactivate() callbacks will change ->use counters
> of other chains/sets, see e.g. nft_lookup .deactivate callback, these
> must be serialized via transaction mutex.
> 
> Also add a few lockdep asserts to make this more explicit.
> 
> Calling synchronize_rcu() isn't ideal, but fixing this without is hard
> and way more intrusive.  As-is, we can get:
> 
> WARNING: .. net/netfilter/nf_tables_api.c:5515 nft_set_destroy+0x..

Right, rhash needs this, that is why there is a workqueue to release
objects from nftables commit path.

> Workqueue: events nf_tables_trans_destroy_work
> RIP: 0010:nft_set_destroy+0x3fe/0x5c0
> Call Trace:
>  <TASK>
>  nf_tables_trans_destroy_work+0x6b7/0xad0
>  process_one_work+0x64a/0xce0
>  worker_thread+0x613/0x10d0
> 
> In case the synchronize_rcu becomes an issue, we can explore alternatives.
> 
> One way would be to allocate nft_trans_rule objects + one nft_trans_chain
> object, deactivate the rules + the chain and then defer the freeing to the
> nft destroy workqueue.  We'd still need to keep the synchronize_rcu path as
> a fallback to handle -ENOMEM corner cases though.

I think it can be done _without_ nft_trans objects.

Since the commit mutex is held in this netdev event path: Remove this
basechain, deactivate rules and add basechain to global list protected
with spinlock, it invokes worker. Then, worker zaps this list
basechains, it calls synchronize_rcu() and it destroys rules and then
basechain. No memory allocations needed in this case?

Thanks.

> Reported-by: syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67478d92.050a0220.253251.0062.GAE@google.com/T/
> Fixes: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 21b6f7410a1f..a3b6b6b32f72 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3987,8 +3987,11 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
>  	kfree(rule);
>  }
>  
> +/* can only be used if rule is no longer visible to dumps */
>  static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
>  {
> +	lockdep_commit_lock_is_held(ctx->net);
> +
>  	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
>  	nf_tables_rule_destroy(ctx, rule);
>  }
> @@ -5757,6 +5760,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  			      struct nft_set_binding *binding,
>  			      enum nft_trans_phase phase)
>  {
> +	lockdep_commit_lock_is_held(ctx->net);
> +
>  	switch (phase) {
>  	case NFT_TRANS_PREPARE_ERROR:
>  		nft_set_trans_unbind(ctx, set);
> @@ -11695,19 +11700,6 @@ static void __nft_release_basechain_now(struct nft_ctx *ctx)
>  	nf_tables_chain_destroy(ctx->chain);
>  }
>  
> -static void nft_release_basechain_rcu(struct rcu_head *head)
> -{
> -	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
> -	struct nft_ctx ctx = {
> -		.family	= chain->table->family,
> -		.chain	= chain,
> -		.net	= read_pnet(&chain->table->net),
> -	};
> -
> -	__nft_release_basechain_now(&ctx);
> -	put_net(ctx.net);
> -}
> -
>  int __nft_release_basechain(struct nft_ctx *ctx)
>  {
>  	struct nft_rule *rule;
> @@ -11722,11 +11714,18 @@ int __nft_release_basechain(struct nft_ctx *ctx)
>  	nft_chain_del(ctx->chain);
>  	nft_use_dec(&ctx->table->use);
>  
> -	if (maybe_get_net(ctx->net))
> -		call_rcu(&ctx->chain->rcu_head, nft_release_basechain_rcu);
> -	else
> +	if (!maybe_get_net(ctx->net)) {
>  		__nft_release_basechain_now(ctx);
> +		return 0;
> +	}
> +
> +	/* wait for ruleset dumps to complete.  Owning chain is no longer in
> +	 * lists, so new dumps can't find any of these rules anymore.
> +	 */
> +	synchronize_rcu();
>  
> +	__nft_release_basechain_now(ctx);
> +	put_net(ctx->net);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__nft_release_basechain);
> -- 
> 2.47.1
> 
> 
