Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC601922FD;
	Sat, 29 Nov 2025 04:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764389731; cv=none; b=YzZs/kttzhlkrOlOcDJXgSNNG/SS/evUeL0/oVzSZMt2aHh2UOH4cJYTmNtgQo5gm39XhL05ksmpIeg70Nfk6Rxrw0ilNPcg0jxXsdaRJUGZAChieTksBIp/NamFnsyCZ2sWY1HFrAVuD+kEJhoM75SDRBId337dPWaHh/C/xrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764389731; c=relaxed/simple;
	bh=8WexRr1xKoDFh0h6dwKD2VYjaGgi8tX/eVJj97/fOGY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nM0ztH1RvMky7kL+DiKIlN902F2r9TcrtKGfEqNy2IxJGkCLJ9IOvGVWn6yjygW/SWOzGZgtcoaGQiRMdB+Cyiqf6d2c63W5i5gRoI3iA7GWgCFEMX6Esr77hG4pyzuotaL+PVpNY9jJav99/pa69Tf7t9Q0brrYszI8YtvQIVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgtTFEct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgtTFEct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D0FC4CEF7;
	Sat, 29 Nov 2025 04:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764389731;
	bh=8WexRr1xKoDFh0h6dwKD2VYjaGgi8tX/eVJj97/fOGY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OgtTFEctARdVOawgLjHO5RGFxmT3IKYXA4HCj5WnCeoyn1Kdg2XIiT3/C5qJxPQWA
	 BvbaGzh1USIt+f8jGv77JjW9oi3RgqZooQOZCk4tdOQ2ff/4vMZAE4eVdXNyeF/pAo
	 bGLjJ5twNPf5JMO6kAI+wOTfK1pAchA5t4Baz4KMBX0s8VtjIV5A3J1okp8CKiYJUs
	 YZ1clarns9/IrIaE1bt7VTXtr/rJjG/2RRjcNWd88rjjdHbuiRN2hNQsvXj6bjeShM
	 uOlW4tRWOeN6pCfOKesxqEpRV/G0LlbxjmlCUURf9TqM9NrvppNXe0sTTz26M1wslD
	 6bsT5q1ykp7NQ==
Date: Fri, 28 Nov 2025 20:15:30 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 11/17] netfilter: nf_conncount: rework API to
 use sk_buff directly
Message-ID: <20251128201530.10e5c3c2@kernel.org>
In-Reply-To: <20251128002345.29378-12-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
	<20251128002345.29378-12-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Nov 2025 00:23:38 +0000 Pablo Neira Ayuso wrote:
>  static int __nf_conncount_add(struct net *net,
> -			      struct nf_conncount_list *list,
> -			      const struct nf_conntrack_tuple *tuple,
> -			      const struct nf_conntrack_zone *zone)
> +			      const struct sk_buff *skb,
> +			      u16 l3num,
> +			      struct nf_conncount_list *list)
>  {
> +	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
>  	const struct nf_conntrack_tuple_hash *found;
>  	struct nf_conncount_tuple *conn, *conn_n;
> +	struct nf_conntrack_tuple tuple;
> +	struct nf_conn *ct = NULL;
>  	struct nf_conn *found_ct;
>  	unsigned int collect = 0;
> +	bool refcounted = false;
> +
> +	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted))
> +		return -ENOENT;
> +
> +	if (ct && nf_ct_is_confirmed(ct)) {
> +		if (refcounted)
> +			nf_ct_put(ct);
> +		return 0;
> +	}
>  	if ((u32)jiffies == list->last_gc)
>  		goto add_new_node;
> @@ -144,10 +194,10 @@ static int __nf_conncount_add(struct net *net,
>  		if (IS_ERR(found)) {
>  			/* Not found, but might be about to be confirmed */
>  			if (PTR_ERR(found) == -EAGAIN) {
> -				if (nf_ct_tuple_equal(&conn->tuple, tuple) &&
> +				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
>  				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
>  				    nf_ct_zone_id(zone, zone->dir))
> -					return 0; /* already exists */
> +					goto out_put; /* already exists */
>  			} else {
>  				collect++;
>  			}
> @@ -156,7 +206,7 @@ static int __nf_conncount_add(struct net *net,
>  
>  		found_ct = nf_ct_tuplehash_to_ctrack(found);
>  
> -		if (nf_ct_tuple_equal(&conn->tuple, tuple) &&
> +		if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
>  		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
>  			/*
>  			 * We should not see tuples twice unless someone hooks
> @@ -165,7 +215,7 @@ static int __nf_conncount_add(struct net *net,
>  			 * Attempt to avoid a re-add in this case.
>  			 */
>  			nf_ct_put(found_ct);
> -			return 0;
> +			goto out_put;
>  		} else if (already_closed(found_ct)) {
>  			/*
>  			 * we do not care about connections which are
> @@ -188,31 +238,35 @@ static int __nf_conncount_add(struct net *net,
>  	if (conn == NULL)
>  		return -ENOMEM;


The AI review tool points out this an another direct return missing a put(ct).

Similar issue in count_tree(). Please take a look and follow up where
appropriate:
https://netdev-ai.bots.linux.dev/ai-review.html?id=348ddc42-0343-4832-9047-0c62767f074f

> -	conn->tuple = *tuple;
> +	conn->tuple = tuple;
>  	conn->zone = *zone;
>  	conn->cpu = raw_smp_processor_id();
>  	conn->jiffies32 = (u32)jiffies;
>  	list_add_tail(&conn->node, &list->head);
>  	list->count++;
>  	list->last_gc = (u32)jiffies;
> +
> +out_put:
> +	if (refcounted)
> +		nf_ct_put(ct);
>  	return 0;
>  }
