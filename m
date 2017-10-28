From: Anatole Denis <natolumin@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_set_hash: fix fast_ops for 2-len
 keys
Date: Sat, 28 Oct 2017 11:40:02 +0100
Message-ID: <1509187202.2986.0@smtp.gmail.com>
References: <20171025105730.27746-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43218 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdJ1KkH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Oct 2017 06:40:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id m72so5163864wmc.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Oct 2017 03:40:06 -0700 (PDT)
In-Reply-To: <20171025105730.27746-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On mer., oct. 25, 2017 at 11:57 , Florian Westphal <fw@strlen.de> wrote:
> Anatole Denis reported following bug:
>   jhash_1word of a u16 is a different value from jhash of the same 
> u16 with
>   length 2.
> 
>   Since elements are always inserted in sets using jhash over the 
> actual
>   klen, this would lead to incorrect lookups on fixed-size sets with 
> a key
>   length of 2, as they would be inserted with hash value jhash(key, 
> 2) and
>   looked up with hash value jhash_1word(key), which is different.
> 
> For -next, lets re-enable support for 2 byte keys, using a differnt
> insertion function.
> 
> Suggested-by: Anatole Denis <anatole@rezel.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is a followup for
>  https://patchwork.ozlabs.org/patch/821080/
>  which is not in nf-next, i.e. this will later need conflict 
> resolution
>  to make sure 'fast ops' is used for 2 byte keys too.
> 
>  net/netfilter/nft_set_hash.c | 37 
> +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_hash.c 
> b/net/netfilter/nft_set_hash.c
> index 0fa01d772c5e..86c9bd35e50e 100644
> --- a/net/netfilter/nft_set_hash.c
> +++ b/net/netfilter/nft_set_hash.c
> @@ -441,16 +441,15 @@ static bool nft_hash_lookup_fast(const struct 
> net *net,
>  	return false;
>  }
> 
> -static int nft_hash_insert(const struct net *net, const struct 
> nft_set *set,
> -			   const struct nft_set_elem *elem,
> -			   struct nft_set_ext **ext)
> +static int __nft_hash_insert(const struct net *net, const struct 
> nft_set *set,
> +			     const struct nft_set_elem *elem,
> +			     struct nft_set_ext **ext,
> +			     u32 hash)
>  {
>  	struct nft_hash_elem *this = elem->priv, *he;
>  	struct nft_hash *priv = nft_set_priv(set);
>  	u8 genmask = nft_genmask_next(net);
> -	u32 hash;
> 
> -	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
>  	hash = reciprocal_scale(hash, priv->buckets);
>  	hlist_for_each_entry(he, &priv->table[hash], node) {
>  		if (!memcmp(nft_set_ext_key(&this->ext),
> @@ -464,6 +463,32 @@ static int nft_hash_insert(const struct net 
> *net, const struct nft_set *set,
>  	return 0;
>  }
> 
> +static int nft_hash_insert(const struct net *net, const struct 
> nft_set *set,
> +			   const struct nft_set_elem *elem,
> +			   struct nft_set_ext **ext)
> +{
> +	const struct nft_hash *priv = nft_set_priv(set);
> +	const struct nft_hash_elem *this = elem->priv;
> +	u32 hash;
> +
> +	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
> +	return __nft_hash_insert(net, set, elem, ext, hash);
> +}
> +
> +static int nft_hash_insert_fast(const struct net *net,
> +				const struct nft_set *set,
> +				const struct nft_set_elem *elem,
> +				struct nft_set_ext **ext)
> +{
> +	const struct nft_hash *priv = nft_set_priv(set);
> +	const struct nft_hash_elem *this = elem->priv;
> +	u32 hash, k1;
> +
> +	k1 = nft_hash_key((const u32 *)nft_set_ext_key(&this->ext), 
> set->klen);
> +	hash = jhash_1word(k1, priv->seed);
> +	return __nft_hash_insert(net, set, elem, ext, hash);
> +}
> +
>  static void nft_hash_activate(const struct net *net, const struct 
> nft_set *set,
>  			      const struct nft_set_elem *elem)
>  {
> @@ -627,7 +652,7 @@ static struct nft_set_ops nft_hash_fast_ops 
> __read_mostly = {
>  	.estimate	= nft_hash_estimate,
>  	.init		= nft_hash_init,
>  	.destroy	= nft_hash_destroy,
> -	.insert		= nft_hash_insert,
> +	.insert		= nft_hash_insert_fast,
>  	.activate	= nft_hash_activate,
>  	.deactivate	= nft_hash_deactivate,
>  	.flush		= nft_hash_flush,
> --
> 2.13.6

Hi Florian,

I'm not very familiar with this part of the code, so it's very possible 
I don't know what I'm talking about, but there is also 
nft_hash_deactivate which is doing a jhash over the key and will still 
incorrectly hash 2-byte keys. I don't know if it's relevant for 
fixed-size hashes, so I just wanted to make sure it's not an oversight 
and that it doesn't need to be changed as well.

Thanks for fixing this,
Anatole

