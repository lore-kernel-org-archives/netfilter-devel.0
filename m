Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441392EAE5
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829953; cv=none; b=jz7scd0QX4ae9nMEHQ1IYgPDVwVd1GUAq9iyiWzE1Nkn4Qi4RkDEZ3zLp6cSUg7NCGCox66R4m0c9geZPYs8Nf9TaLhA38Y1EjnTmF2njTFjn2qgT9KteU68M0mSEQ4iFTLwbsLbOpX5WA9RdnMjmY5SxX8GQbvQHZAjwv7f6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829953; c=relaxed/simple;
	bh=CH04HbebsCCfCkbhymWsQM2AVrNQu7474TTLU7Brhbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7CnPSvvJ1a5c5dXjui5PpDn+FD3nLTFde9kOgjUWJxCGBCDp2+R5xftWTqsg6NnIR5eK2wTkWuA9PJyoMIX8PRGQIwyz0LiNdTkg3Fy6tO7MiPirkCH8FfviH4kYpAi9009Opj7el8pE6BuNgBrRS3TApByv9S0yyt0MOzQgj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 12:05:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ziyang Xuan <william.xuanziyang@huawei.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 2/2] netfilter: nf_tables: Fix potential data-race in
 __nft_obj_type_get()
Message-ID: <Zhe1-4M2ObeQGEYz@calendula>
References: <cover.1712472595.git.william.xuanziyang@huawei.com>
 <ab7c6584a047d80a9c4658a4d196b555567642e4.1712472595.git.william.xuanziyang@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ab7c6584a047d80a9c4658a4d196b555567642e4.1712472595.git.william.xuanziyang@huawei.com>

On Sun, Apr 07, 2024 at 02:56:05PM +0800, Ziyang Xuan wrote:
> nft_unregister_obj() can concurrent with __nft_obj_type_get(),
> and there is not any protection when iterate over nf_tables_objects
> list in __nft_obj_type_get(). Therefore, there is pertential
> data-race of nf_tables_objects list entry.
> 
> Use list_for_each_entry_rcu() to iterate over nf_tables_objects
> list in __nft_obj_type_get(), and use rcu_read_lock() in the caller
> nft_obj_type_get() to protect the entire type query process.

Also applied, thanks

> Fixes: e50092404c1b ("netfilter: nf_tables: add stateful objects")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/netfilter/nf_tables_api.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 646d59685cfd..70fe0ca24d34 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7607,7 +7607,7 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
>  {
>  	const struct nft_object_type *type;
>  
> -	list_for_each_entry(type, &nf_tables_objects, list) {
> +	list_for_each_entry_rcu(type, &nf_tables_objects, list) {
>  		if (type->family != NFPROTO_UNSPEC &&
>  		    type->family != family)
>  			continue;
> @@ -7623,9 +7623,13 @@ nft_obj_type_get(struct net *net, u32 objtype, u8 family)
>  {
>  	const struct nft_object_type *type;
>  
> +	rcu_read_lock();
>  	type = __nft_obj_type_get(objtype, family);
> -	if (type != NULL && try_module_get(type->owner))
> +	if (type != NULL && try_module_get(type->owner)) {
> +		rcu_read_unlock();
>  		return type;
> +	}
> +	rcu_read_unlock();
>  
>  	lockdep_nfnl_nft_mutex_not_held();
>  #ifdef CONFIG_MODULES
> -- 
> 2.25.1
> 
