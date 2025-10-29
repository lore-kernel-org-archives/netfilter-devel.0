Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF5233722
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 20:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770582; cv=none; b=TXupOuXqRxcK25gs6487oR8euzX/kLKWPh+RF0HSmet/iyZmTAJgRpLhkctlho1FzYxxukWI+vALIkIN0J6JqmUGiAAtqZzZiprrIMv9Auv9R/PNhw1C4KFHwbUUSe4Xp91Vd/FvLE6a8cANofiOVwCzcl0NM0odBualtZrrZzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770582; c=relaxed/simple;
	bh=eOLC4/LojyjE5wdAd9C5zYPYktj9Gpk8X9BPE95Ep4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qffk8fndGF4631/Ovt4sov1CgmP3lJ4a9d+dQTTgLMQoBwbOV+Bek1bWBw3sfxcan1rsyDQebf7gvZp08VqwX+HxLCRxBzoGLAkhFBTtFcY4SBp0nMdypYEI2CbxS1W/3GCA8I/u4SZBvS3VB4ZEWKIIAFfbzXv7LWuuwuE3yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VsAnZTaO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VsAnZTaO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A741B6028E;
	Wed, 29 Oct 2025 21:42:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761770576;
	bh=bcfDHcc3w0CDKBU89s7e6s1vDCM9eiX55zKKFQFYS2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsAnZTaOxv1FILzZFVxtRVueufthewt94I8eJvZfZ8/KY+Z3vAPHsF2lK1Y6OGPxB
	 gzQl2TJbKs3cxq+JC9U+SZxPCsLYl/ZzEXDYhban+yqNRYhaA5vIZXwWiEaPpKBCCl
	 l7vjpFXvJST9Srhb48/QkB4NvB9sdmhaHbB/bdmSWTehCEp3J/S238pGyMfsyGANBf
	 7pwP00oCJUOFy3bis3fjKfcJj73skrXCo05+Gnjr7qQ65tXQiwzVHPjet+aFjyDbcV
	 Lth+3eZjgAe4MJus0h6TpmcJuKiHTA55zEGKMI3DuGN64SXsiwEIOICGCsx9BvNI9L
	 qFe7vnm0SBRLg==
Date: Wed, 29 Oct 2025 21:33:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
Subject: Re: [PATCH nf v2] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
Message-ID: <aQJ6AysjCMTHLzsP@calendula>
References: <20251029132318.5628-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251029132318.5628-1-fmancera@suse.de>

Hi Fernando,

On Wed, Oct 29, 2025 at 02:23:18PM +0100, Fernando Fernandez Mancera wrote:
> Connlimit expression can be used for all kind of packets and not only
> for packets with connection state new. See this ruleset as example:
> 
> table ip filter {
>         chain input {
>                 type filter hook input priority filter; policy accept;
>                 tcp dport 22 ct count over 4 counter
>         }
> }
> 
> Currently, if the connection count goes over the limit the counter will
> count the packets. When a connection is closed, the connection count
> won't decrement as it should because it is only updated for new
> connections due to an optimization on __nf_conncount_add() that prevents
> updating the list if the connection is duplicated.
> 
> In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
> unnecessary GC") there can be situations where a duplicated connection
> is added to the list. This is caused by two packets from the same
> connection being processed during the same jiffy.
> 
> To solve these problems, check whether this is a new connection and only
> add the connection to the list if that is the case during connlimit
> evaluation. Otherwise run a GC to update the count. This doesn't yield a
> performance degradation.

This is true is list is small, e.g. ct count over 4.

But user could much larger value, then every packet could trigger a
long list walk, because gc is bound to CONNCOUNT_GC_MAX_NODES which is
the maximum number of nodes that is _collected_.

And maybe the user selects:

  ct count over N mark set 0x1

where N is high, the gc walk can be long.

TBH, I added this expression mainly focusing on being used with
dynset, I allowed it too in rules for parity. In the dynset case,
there is a front-end datastructure (set) and this conncount list
is per element. Maybe there high ct count is also possible.

With this patch, gc is called more frequently, not only for each new
packet.

> Fixed in xt_connlimit too.
> 
> Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
> Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
> Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v2: use nf_ct_is_confirmed(), add comment about why the gc call is
> needed and fix this in xt_connlimit too.
> ---
>  net/netfilter/nft_connlimit.c | 17 ++++++++++++++---
>  net/netfilter/xt_connlimit.c  | 14 ++++++++++++--
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> index fc35a11cdca2..dedea1681e73 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c
> @@ -43,9 +43,20 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
>  		return;
>  	}
>  
> -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> -		regs->verdict.code = NF_DROP;
> -		return;
> +	if (!ct || !nf_ct_is_confirmed(ct)) {
> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}
> +	} else {
> +		/* Call gc to update the list count if any connection has been
> +		 * closed already. This is useful to softlimit connections
> +		 * like limiting bandwidth based on a number of open
> +		 * connections.
> +		 */
> +		local_bh_disable();
> +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> +		local_bh_enable();
>  	}
>  
>  	count = READ_ONCE(priv->list->count);
> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> index 0189f8b6b0bd..5c90e1929d86 100644
> --- a/net/netfilter/xt_connlimit.c
> +++ b/net/netfilter/xt_connlimit.c
> @@ -69,8 +69,18 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		key[1] = zone->id;
>  	}
>  
> -	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
> -					 zone);
> +	if (!ct || !nf_ct_is_confirmed(ct)) {
> +		connections = nf_conncount_count(net, info->data, key, tuple_ptr,
> +						 zone);
> +	} else {
> +		/* Call nf_conncount_count() with NULL tuple and zone to update
> +		 * the list if any connection has been closed already. This is
> +		 * useful to softlimit connections like limiting bandwidth based
> +		 * on a number of open connections.
> +		 */
> +		connections = nf_conncount_count(net, info->data, key, NULL, NULL);
> +	}

Maybe remove this from xt_connlimit?

> +
>  	if (connections == 0)
>  		/* kmalloc failed, drop it entirely */
>  		goto hotdrop;
> -- 
> 2.51.0
> 
