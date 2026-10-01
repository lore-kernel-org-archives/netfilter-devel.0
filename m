Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C90C4D4890;
	Thu,  1 Oct 2026 08:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844420; cv=none; b=dQb8ijAn4Oy5OBs8lpyZdvWYlP5uYjWwpt9LUnKZcKBnBwR/kZWPYQvej27uD0m6V4mQS9GkFNOheRnt+7suGeglg/LhSDE4cr0NFexw/SzVxVFesLjm/CGCZZDdNWqz2zxwvqqZjll6GTTPQdr30zbn17s0T5ebjEuzYsDInXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844420; c=relaxed/simple;
	bh=u4z+zKpl5MpoZUZDIi5i1L+Yt0tNb8zpb6NWbVEKlts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqI5wqeY4WpJtGLB0rvdgiVfM+/P3GUTN97sXX1vCvknz+NtU0vef7gegk0TlVJJhNZHrmuJjqCQm3haQ46uEah7v/ar+IwHxe93feJODe0/JUdQrujMbykrrXCnHRS3NoxlEzzk4wDupImLT7aNlmtjlkAcpLf8q7m3vmzHjxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vAPk79nq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vAPk79nq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790844415;
	bh=qfwqIlO/B9d/gQZcSXC89TRJ7a33VpkcIh9JA/58SYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vAPk79nqDBMD+uffHv5rZhnxSc1Zehm758wIA/3edGI7Dgs5O77iP5WeCo7phXVHr
	 Pud2de0zewRIlm3jeS1lwGdj4q4abSIV/ECiTTo86UGQlYtxt8XCuqx5Y+80xtpNc7
	 LrMhH/mNz5161UT5Ph8Y/g8dWPbcXB5wxV2ywRIUFXYZSUK7vPUnOnupdCrH3a2pYo
	 JvVl8FhV/pkVb6bsyu6MNwVSoXDz+b9L8iMnLJFcFwHrQKJzuDq9XumCcd3KwAyOMA
	 QkOgGBsdkS4lQwjMxTo+oUDM0+o60M7ukQid2zZ/6SKmSIAx7lKnLcmmO1VlkoBH+r
	 XyBexLKPM9vkg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7235160076;
	Thu,  1 Oct 2026 10:46:55 +0200 (CEST)
Date: Thu, 1 Oct 2026 10:46:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ma Xinmeng <1564938642@qq.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1] netfilter: nf_tables: fix UAF in
 nf_tables_netdev_event walker
Message-ID: <ar4d_JbuojZJuazs@chamomile>
References: <2026-09-25-daily-reply-0003-re-nf-tables-netdev-event-uaf@kernel.org>
 <tencent_CD037FFEEB8CA462C8403FB30F50EEC6DF06@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_CD037FFEEB8CA462C8403FB30F50EEC6DF06@qq.com>

On Thu, Oct 01, 2026 at 11:51:30AM +0800, Ma Xinmeng wrote:
> This is a 6.1-only fix. Mainline already fixed this bug in fc0133428e7a
> ("netfilter: nf_tables: Tolerate chains with no remaining hooks"), which
> 6.1 cannot take because it lacks 207296f1a03b ("netfilter: nf_tables:
> allow to create netdev chain without device") and b9703ed44ffb
> ("netfilter: nf_tables: support for adding new devices to an existing
> netdev chain").

Then, why not add those patches you refer to as -stable dependencies?
-stable trees will become hard to maintain if they start deviating too
much from upstream.

> So 6.1 keeps dropping the chain on the last
> NETDEV_UNREGISTER, and this patch only makes the walker safe.
> 
> nf_tables_netdev_event() walks table->chains with
> list_for_each_entry_safe(). On the last NETDEV_UNREGISTER for a base
> chain, nft_netdev_event() calls __nft_release_basechain(), which removes
> that base chain (nft_chain_del()) and destroys its rules. A JUMP/GOTO rule
> targeting an NFT_CHAIN_BINDING chain deactivates and frees that successor
> (nft_immediate_destroy() -> nf_tables_chain_destroy()), so the walker's
> saved "nr" iterator can point at freed memory, triggering a
> slab-use-after-free.
> 
> Fix it by restarting the table->chains walk whenever nft_netdev_event()
> released a chain. __nft_release_basechain() removes the base chain from
> the list before returning, so a restart cannot revisit the freed chain and
> the walk terminates.
> 
> Signed-off-by: Ma Xinmeng <1564938642@qq.com>
> ---
>  net/netfilter/nft_chain_filter.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index d170758..ca6450a 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -318,7 +318,7 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
>  	},
>  };
>  
> -static void nft_netdev_event(unsigned long event, struct net_device *dev,
> +static bool nft_netdev_event(unsigned long event, struct net_device *dev,
>  			     struct nft_ctx *ctx)
>  {
>  	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
> @@ -326,7 +326,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>  	int n = 0;
>  
>  	if (event != NETDEV_UNREGISTER)
> -		return;
> +		return false;
>  
>  	list_for_each_entry(hook, &basechain->hook_list, list) {
>  		if (hook->ops.dev == dev)
> @@ -335,7 +335,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>  		n++;
>  	}
>  	if (!found)
> -		return;
> +		return false;
>  
>  	if (n > 1) {
>  		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
> @@ -343,7 +343,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>  
>  		list_del_rcu(&found->list);
>  		kfree_rcu(found, rcu);
> -		return;
> +		return false;
>  	}
>  
>  	/* UNREGISTER events are also happening on netns exit.
> @@ -353,6 +353,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
>  	 * so we cannot skip exiting net namespaces.
>  	 */
>  	__nft_release_basechain(ctx);
> +
> +	return true;
>  }
>  
>  static int nf_tables_netdev_event(struct notifier_block *this,
> @@ -380,6 +382,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
>  
>  		ctx.family = table->family;
>  		ctx.table = table;
> +restart:
>  		list_for_each_entry_safe(chain, nr, &table->chains, list) {
>  			if (!nft_is_base_chain(chain))
>  				continue;
> @@ -390,7 +393,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
>  				continue;
>  
>  			ctx.chain = chain;
> -			nft_netdev_event(event, dev, &ctx);
> +			if (nft_netdev_event(event, dev, &ctx))
> +				goto restart;
>  		}
>  	}
>  	mutex_unlock(&nft_net->commit_mutex);
> -- 
> 2.49.0.windows.1
> 
