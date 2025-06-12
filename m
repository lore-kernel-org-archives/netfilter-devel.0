Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6053E522F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749768153; cv=none; b=edCVsTwhofmKFfwogbHz4n97efw8hsFCUrWzIiQ9NqG6MiJynTuOOD7SEu2hg9mBh3O2BIC1s/ybJvPvQLoshSarAcSc62nbEj09AVz3bIurU6njrUyzTQ4X2+fWgS7jQPW0UqDsJngetzZCvPFd3xS/HN8Bp7yGXZpRnuKBhyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749768153; c=relaxed/simple;
	bh=BSJnpu+VdKbKtnpO9c0sfcLESMQKKCwuz24nkT59uDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZfqxCofmLEUwaSk4fU7ca93WFqoEq2rdiFuuKxxAEvkJRM93y9R+mclfJc/abA9WFfWDVm9NUYacsvGGZc+gjnlF6ZKGqPmVZaTBBampL6YQYiSzvQPn88sxjBKSVhrZUmkMIdzJfH/m7FXdwV8WPYp+9c6uRVWiGiKzg0KC40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bKYEpbrR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LxkpSxKy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bKYEpbrR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LxkpSxKy"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 56E5E6056C; Fri, 13 Jun 2025 00:42:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749768142;
	bh=u8Vw5hqPqCj8dOg8vz0e6HyKpqpJziAfRkN5P4vkRy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKYEpbrRTEfZOGPv4OTrVouf7JuahCrBUxYOvoXAFzD8k0Clf4km47ImTxvWJRVtR
	 QIht37XDL+Rv7QCQRNsUqQ4kVXFZIzq2AkB4b0QyLuLjH3HLuSKKBXmvhKmkyUEOZX
	 uRG/2cC0L9PjnEE3dq1G1iu2+4dHLDnttVJRsYTMrOBEAaNYAHf3dpIDIC3zzUZps3
	 VPVpxD6LSq+DTWybOpVVh6Y6HOp1s1BV3fCsnaJd7lUlNqgsIDuP0vdo6R0mW+etlZ
	 xlkQaXo4wQsbfrY5ab1SOMwa88X5aKNn62biJYlxY/u/K3BudtyWMEo4t24gPVcEtg
	 3gTdAKBpL3u6g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 855BC6056C;
	Fri, 13 Jun 2025 00:42:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749768141;
	bh=u8Vw5hqPqCj8dOg8vz0e6HyKpqpJziAfRkN5P4vkRy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LxkpSxKyzHNjo+15LwbeYnx/x7aeYvZ5X8jIrx8sg071yP2sfrr6pCIGhFM0bdr+W
	 ynMxx43J4QXDOcckt09bxi0CrHrxhRCeKEX48foGsz9qU11xmzwlWdVs3xR17R+8+d
	 Iw3PgmFK3U5GJKQTR5GKlOaJ/0RzvrXFgJFr+Lho44oqXVjs7Ql0t5bTnzoBLAtx6q
	 YdAhxCXtJdf1fgIgVFw0sHTKr1gNHmE3+A7syoy3XMeLvjfYL02f0Ws7gOnjBn0oRu
	 lf2dwcFi0nPfGmuaDa58QG1sk2srFg8NBfB8flVk8Yqfofv7vz8Kuu/OgUaa5uEB2V
	 nHLFbiaaVg2Xw==
Date: Fri, 13 Jun 2025 00:42:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Fix for extra data in
 delete notifications
Message-ID: <aEtXyu1FD6cxDeRf@calendula>
References: <20250612183024.1867-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612183024.1867-1-phil@nwl.cc>

On Thu, Jun 12, 2025 at 08:30:24PM +0200, Phil Sutter wrote:
> All routines modified in this patch conditionally return early depending
> on event value (and other criteria, i.e., chain/flowtable updates).
> These checks were defeated by an upfront modification of that variable
> for use in nfnl_msg_put(). Restore functionality by avoiding the
> modification.

Thanks for fixing this.

> This change is particularly important for user space to distinguish
> between a chain/flowtable update removing a hook and full deletion.
> 
> Fixes: 28339b21a365 ("netfilter: nf_tables: do not send complete notification of deletions")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Channeling this through -next despite it being a fix since unpatched
> nft monitor chokes on the shortened delete flowtable notifications.

I am afraid this patch will end up in -stable, breaking userspace, how
bad is the choking? Maybe 28339b21a365 needs to be reverted, then fix
userspace to prepare for it and re-add it in nf-next?

Not sure what path to follow with this.

> Changes since v1:
> - User space depends on NFTA_OBJ_TYPE for proper deserialization, do not
>   skip that attribute.
> ---
>  net/netfilter/nf_tables_api.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8952b50b0224..9bf003797355 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1153,9 +1153,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
>  {
>  	struct nlmsghdr *nlh;
>  
> -	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> -	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
> -			   NFNETLINK_V0, nft_base_seq(net));
> +	nlh = nfnl_msg_put(skb, portid, seq,
> +			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
> +			   flags, family, NFNETLINK_V0, nft_base_seq(net));
>  	if (!nlh)
>  		goto nla_put_failure;
>  
> @@ -2020,9 +2020,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
>  {
>  	struct nlmsghdr *nlh;
>  
> -	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> -	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
> -			   NFNETLINK_V0, nft_base_seq(net));
> +	nlh = nfnl_msg_put(skb, portid, seq,
> +			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
> +			   flags, family, NFNETLINK_V0, nft_base_seq(net));
>  	if (!nlh)
>  		goto nla_put_failure;
>  
> @@ -4851,9 +4851,10 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
>  	u32 seq = ctx->seq;
>  	int i;
>  
> -	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> -	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
> -			   NFNETLINK_V0, nft_base_seq(ctx->net));
> +	nlh = nfnl_msg_put(skb, portid, seq,
> +			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
> +			   flags, ctx->family, NFNETLINK_V0,
> +			   nft_base_seq(ctx->net));
>  	if (!nlh)
>  		goto nla_put_failure;
>  
> @@ -8346,14 +8347,15 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
>  {
>  	struct nlmsghdr *nlh;
>  
> -	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> -	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
> -			   NFNETLINK_V0, nft_base_seq(net));
> +	nlh = nfnl_msg_put(skb, portid, seq,
> +			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
> +			   flags, family, NFNETLINK_V0, nft_base_seq(net));
>  	if (!nlh)
>  		goto nla_put_failure;
>  
>  	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
>  	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
> +	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
>  	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
>  			 NFTA_OBJ_PAD))
>  		goto nla_put_failure;
> @@ -8363,8 +8365,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
>  		return 0;
>  	}
>  
> -	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
> -	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
> +	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
>  	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
>  		goto nla_put_failure;
>  
> @@ -9391,9 +9392,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
>  	struct nft_hook *hook;
>  	struct nlmsghdr *nlh;
>  
> -	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> -	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
> -			   NFNETLINK_V0, nft_base_seq(net));
> +	nlh = nfnl_msg_put(skb, portid, seq,
> +			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
> +			   flags, family, NFNETLINK_V0, nft_base_seq(net));
>  	if (!nlh)
>  		goto nla_put_failure;
>  
> -- 
> 2.49.0
> 
