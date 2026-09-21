Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971F488D82
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023717; cv=none; b=H9sM0D9zrTRcDAlOCA5oIJ8lRbH1qg6+GvZwJz8pthTAr20eubV6N8cS5Syl2FIuPCMLdOU04DV/hOu8WRnhYZjosmxgOAUcJOoimEab5c9/36Dn27RpncaV7n3yUDOwyqNvxCR2LMAcmkmlIzMFwXjbhQJrNMaMH8R/ucsUg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023717; c=relaxed/simple;
	bh=T21IlLmrKkSCO1nfuUoDmajpP8Ksp9ofl7IFTSs8r3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+hNXhw8PFy6G+2FOVJcInwD8/8WGRwPzCL7MLE6RDPNf8IWdlpi+swI6rLaKs8f5jo2wCerCRBJSvTFFIhXC+is/PsRvAW6mDTWFN8W+JzYFhTie6HCjFrSp5Wu2TUIQfydRBJOMJeCrgIyu3XpDz5KRFUoz+MeezEWPx3YBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bg7dAAHJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bg7dAAHJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790023711;
	bh=iK7uxrEkgb0ZT/qkSG8qr95JaMLANNm42mSHqZ/IVs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bg7dAAHJPEAjevtRQzpkLbBsGsch7T8BC+YmmY7yHYsc0pVA1b4Aszyzb3sDegfSd
	 7g2zainqrM20bs8MPgIQGxyK2TD0rREDQEXsrcVwADg/ZhIP/1lodChfjs2aWQiUwH
	 rQc/8iVtpf6LGALf9BwKtItK7cq27tOJo726NX+yYRoNF86tHdgAG7sob9R1T8aPUA
	 RYUO8Xummkwqkob+ZIH155crmikmWcuwvsant0rkElpfvjDSaOuuzhAVDhdaLfBuKK
	 84T3nSpLu/DbsK6R5MKFk5VDju3/UhPIkHkeirF31KfXQ8PU5a/jZeo8NwppvwUjzL
	 ADtEuctX5mBQw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E7DA860191;
	Mon, 21 Sep 2026 22:48:30 +0200 (CEST)
Date: Mon, 21 Sep 2026 22:48:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: bestswngs@gmail.com
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc, xmei5@asu.edu, co+ee5e50ef2670e5f4@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: skip transaction elements
 during GC
Message-ID: <arGYHBPN3HDAI8ov@chamomile>
References: <20260921020821.2587086-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260921020821.2587086-2-bestswngs@gmail.com>

On Mon, Sep 21, 2026 at 10:08:22AM +0800, bestswngs@gmail.com wrote:
> From: Weiming Shi <bestswngs@gmail.com>
> 
> Since nft_set_commit_update() runs set commit callbacks before processing
> NEWSETELEM transactions, nft_rbtree_gc_scan() can observe elements added by
> the transaction being committed.
> 
> The scan records an interval end in rbe_end without checking the element's
> transaction state. A later, unrelated expired start then moves both
> elements to the expired list. The synchronous GC queue can free the new end
> element before the transaction subsequently activates it, causing a
> use-after-free.
> 
> Only consider elements that are fully active in both generations. This
> keeps transaction-state elements out of the GC scan and preserves interval
> pairing across skipped elements.
> 
> KASAN reports:
> 
>   BUG: KASAN: slab-use-after-free in nft_setelem_activate
>   nft_setelem_activate net/netfilter/nf_tables_api.c:7047
>   nf_tables_commit net/netfilter/nf_tables_api.c:11137
> 
>   Allocated by task 130:
>   nft_set_elem_init net/netfilter/nf_tables_api.c:6794
>   nft_add_set_elem net/netfilter/nf_tables_api.c:7523
> 
>   Freed by task 130:
>   nft_trans_gc_trans_free net/netfilter/nf_tables_api.c:10506
>   rcu_core kernel/rcu/tree.c:2919
> 
> Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
> Reported-by: <co+ee5e50ef2670e5f4@bugs.sh>
> Assisted-by: LLM
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

Patch is fine. It is not possible to add or delete an expired element,
expired elements should not ever be in a transaction then.

> ---
>  net/netfilter/nft_set_rbtree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 9894832281c4b..12431b55752fb 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
>  		next = rb_next(node);
>  
>  		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
> +			continue;
>  
>  		/* elements are reversed in the rbtree for historical reasons,
>  		 * from highest to lowest value, that is why end element is
> -- 
> 2.55.0
> 
