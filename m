Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9F53AAF54;
	Mon, 31 Aug 2026 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214537; cv=none; b=l/O38lzApTXhGhMMJym2h++zzTG1N3qW5PwabEFoSf6XzqcRePLwZYsbYQf4BxU9vxCukV3QQ1C8WDsB1Oh669cDwQspoG/z2JfnHRyWgvCOZjfi4MXcymZZ7h7gvdziNxAd1pyvrtlEChFANgIHLRoj6EbYQyqH6tWU++urkts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214537; c=relaxed/simple;
	bh=4yKnuwdJTs/MCj8545ryyc60qDLh2x3b913oTnd3rS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtZWd70hQShnbn3hTl3jQ/V/in6W+0wecxF8KG/gUTzgTJIAXPOLh8x1orPD9QiO3RqBuDRMwkwuLqCvPwyMoL7RzmloAr3u4ZZxCUyb2qRFsf9y1Co6KNYq3ugoJavxyiZergeRyf6m4yNgUbrzyAb07Bptc2wqPyagWR3iypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YI8jhpql; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YI8jhpql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788214532;
	bh=GsPYj8syF9cXFIOMiBnw0dzRxeZ391I8EKIeN74tGG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YI8jhpql3750ckYzT2dPJ1KrVdimmCMg5ujBrIlMJZwud9kAUy9tWgg/Y5tkP9bQL
	 QqOo4R0q5NMTHvqDFKdWR4xwNTHBN1VkLVW+rXdYd2Kf86c5asve9/L6gbGc855L4G
	 9+VlQcIztBCEk1AcwFZGtsnBSHWXGkFgimENMh+O9ie7DvBpj8RKEuVmC0pw6qzmTT
	 FMPAE/evoVRVfqlnRCeNmluyQg1k0ix3VREb2PttpnHdfBAUNM+auY6BpliWOv2Xty
	 T/szbyxUo95kanrZi/PNxZrim0E+mTb2s3pFZrSuUKFC6dcLrGOUzTD01yHLBKBYD4
	 oBZGXBWJVXcFA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C563A60244;
	Tue,  1 Sep 2026 00:15:31 +0200 (CEST)
Date: Tue, 1 Sep 2026 00:15:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Bin Lan <lanbincn@139.com>, XiaoHua Wang <561399680@139.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: restore cloned
 mapping table memcg accounting
Message-ID: <apX9AZoNkpVrBMIE@chamomile>
References: <20260831194905.45045-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260831194905.45045-1-kmehltretter@gmail.com>

On Mon, Aug 31, 2026 at 09:49:05PM +0200, Karl Mehltretter wrote:
> The 6.1.y and 6.6.y backports of commit 69e687cea79f
> ("netfilter: nf_tables: missing objects with no memcg accounting")
> changed the pipapo_clone() mapping-table allocation to
> GFP_KERNEL_ACCOUNT.
> 
> Later stable backports of commit 07ace0bbe03b ("netfilter:
> nft_set_pipapo: do not rely on ZERO_SIZE_PTR") rewrote this allocation
> and changed the flag back to GFP_KERNEL. Upstream applied the
> ZERO_SIZE_PTR change before the memcg accounting change and retains
> GFP_KERNEL_ACCOUNT after both.
> 
> nft_pipapo_deactivate() clones a populated set before looking up an
> element to delete. If the element is absent, priv->dirty remains false
> and the clone is retained. Its mapping tables therefore remain allocated
> without being charged to the requesting memory cgroup.
> 
> Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.
> 
> For a 32,768-element two-field concatenation set, A/B tests on 6.1.186
> and 6.6.155 measured exactly 524,288 additional bytes charged to the
> memory cgroup after restoring the flag. An unmodified 6.12.107 control
> already accounted the corresponding allocation and showed the same
> accounting behavior.
> 
> Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> Fixes: 32bad10de347 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")

This two Fixes: tag do not make any sense to me.

> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  net/netfilter/nft_set_pipapo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 7c8d28a031ad..4c3bb5d61a3b 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1465,7 +1465,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  				goto out_mt;
>  
>  			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
> -						 GFP_KERNEL);
> +						 GFP_KERNEL_ACCOUNT);
>  			if (!dst->mt)
>  				goto out_mt;
>  
> -- 
> 2.39.5 (Apple Git-154)
> 
