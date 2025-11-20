Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA31F2E6CC6;
	Thu, 20 Nov 2025 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763671118; cv=none; b=Z6XR3R8/SAQHNS9Z1uq2ufQ8AhQnpp6TU2XSx+XtMy70D+uHZN8Wh3X1VPMRC+7fdsszaWxrWL1C1lmzooEGJZ4N6fWUDZfahUTouSTCEJ++KgUSN1uDuxCbBZbxF9j9aFg6bfzk2VsvHucejXSYs7WuXPGUmjtj/gKhuCK+BtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763671118; c=relaxed/simple;
	bh=AM15vMMbBrK2Su4pZFSF4FX0SkNCaQOuxzhnivFQh8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqwPwuShXvUPCT+hZxljWHsSHKHh6l2xX4US/dNFTSGrEXn2CAzSAo1d/ggrqZuxpp5DmfJhllCghQmo056rTLVLL+XFFOVHX87S2ApdhTGAdlqyR/HANElPCoy/bifzAo1Rryoxp54hOZ57e4So6kyd8/iIxEbXZ73o7yWwFSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=DOZJZQt2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DOZJZQt2"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 3F5D32120393; Thu, 20 Nov 2025 12:38:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F5D32120393
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1763671116;
	bh=DQeEn6nJMilM6nEwOrXH2FiQ00lSHvwbMoM0IUWRAwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DOZJZQt20r0zZwujhjFOfaV4K3F7zIiikAfTBpGRq91atbxnbXRi+iB3XHda34AJ6
	 b0uzQhBYereWbOelWJCRfimE9ftGzmx7WPYQLb0N0WytSE89K2p5C0VRqJDD1NLi1P
	 Bm5yeZ6QU59veoeZdXFMd50PxgsLl9wnanWJB2as=
Date: Thu, 20 Nov 2025 12:38:36 -0800
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
 <aR5ObjGO4SaD3GkX@calendula>
 <aR7grVC-kLg76kvE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR7grVC-kLg76kvE@strlen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Nov 20, 2025 at 10:34:46AM +0100, Florian Westphal wrote:
> netfilter: nf_tables: avoid chain re-validation if possible
> 
> Consider:
> 
>       input -> j2 -> j3
>       input -> j2 -> j3
>       input -> j1 -> j2 -> j3
> 
> Then the second rule does not need to revalidate j2, and, by extension j3.
> 
> We need to validate it only for rule 3.
> 
> This is needed because chain loop detection also ensures we do not
> exceed the jump stack: Just because we know that j2 is cycle free, its
> last jump might now exceed the allowed stack.  We also need to update
> the new largest call depth for all the reachable nodes.
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1109,6 +1109,7 @@ struct nft_rule_blob {
>   *	@udlen: user data length
>   *	@udata: user data in the chain
>   *	@blob_next: rule blob pointer to the next in the chain
> + *	@depth: chain was validated for call level <= depth
>   */
>  struct nft_chain {
>  	struct nft_rule_blob		__rcu *blob_gen_0;
> @@ -1128,9 +1129,10 @@ struct nft_chain {
>  
>  	/* Only used during control plane commit phase: */
>  	struct nft_rule_blob		*blob_next;
> +	u8				depth;
>  };
>  
> -int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
> +int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
>  int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
>  			 const struct nft_set_iter *iter,
>  			 struct nft_elem_priv *elem_priv);
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4088,15 +4088,26 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
>   * and set lookups until either the jump limit is hit or all reachable
>   * chains have been validated.
>   */
> -int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
> +int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
>  {
>  	struct nft_expr *expr, *last;
>  	struct nft_rule *rule;
>  	int err;
>  
> +	BUILD_BUG_ON(NFT_JUMP_STACK_SIZE > 255);
>  	if (ctx->level == NFT_JUMP_STACK_SIZE)
>  		return -EMLINK;
>  
> +	/* jumps to base chains are not allowed, this is already
> +	 * validated by nft_verdict_init().
> +	 *
> +	 * Chain must be re-validated if we are entering for first
> +	 * time or if the current jumpstack usage is higher than on
> +	 * previous check.
> +	 */
> +	if (ctx->level && chain->depth >= ctx->level)
> +		return 0;
> +
>  	list_for_each_entry(rule, &chain->rules, list) {
>  		if (fatal_signal_pending(current))
>  			return -EINTR;
> @@ -4117,6 +4128,10 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
>  		}
>  	}
>  
> +	/* Chain needs no re-validation if called again
> +	 * from a path that doesn't exceed level.
> +	 */
> +	chain->depth = ctx->level;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nft_chain_validate);
> @@ -4128,7 +4143,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
>  		.net	= net,
>  		.family	= table->family,
>  	};
> -	int err;
> +	int err = 0;
>  
>  	list_for_each_entry(chain, &table->chains, list) {
>  		if (!nft_is_base_chain(chain))
> @@ -4137,12 +4152,16 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
>  		ctx.chain = chain;
>  		err = nft_chain_validate(&ctx, chain);
>  		if (err < 0)
> -			return err;
> +			goto err;
>  
>  		cond_resched();
>  	}
>  
> -	return 0;
> +err:
> +	list_for_each_entry(chain, &table->chains, list)
> +		chain->depth = 0;
> +
> +	return err;
>  }
>  
>  int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,

FWIW This patch seems to resolve the issue, assuming you intended to
include the following:

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..e5f7a3b1d946 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1130,7 +1130,7 @@ struct nft_chain {
	struct nft_rule_blob		*blob_next;
 };
 
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			  const struct nft_set_iter *iter,
 			  struct nft_elem_priv *elem_priv);
