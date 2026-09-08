Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06137526AAE;
	Tue,  8 Sep 2026 23:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788909734; cv=none; b=nbzfWuwbnDNvBC2KudIhINMfnfAEv9lZVZ7N/GnWiKSHMtGxn6Ye7/EIE6sL8yuvy4MIOqQ9pddAh16ir8ckRk+4MtqzKsHFQ71B5Tnc+lJrrn5yjl0xEGmKexIdnmdcrXogkwXMj4uDDc8SLFj0mDOMTGMpGLQsMo9fP3p49mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788909734; c=relaxed/simple;
	bh=U3Ewt1HxqFgezcCs3pkzTUqGDN7qsfm2PWFoGP4/ewI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mR1voU94CVxKfz2Pf2IeQ4HS9uIaRl48Ko3aMVqumk6KtF+twpMT+Nur6dVV9G4WJU8QMHHkwVRj6HmZoXU3D7fA5yh519We6iA6JIN/Gj3kzI0EZjqvv17IPJcFyEfs9vgmbU6IHsZGT5WgbkxLlZ86g4k+jDOdBMvu2cbTkAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qSiCTatc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qSiCTatc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788909723;
	bh=zi9rHuLTECil4aj5OuLg83poLLbvzzRAfIDR4BoBSa4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSiCTatcX7lLiJsgCbIHXX3NyPeB/IGasBMyedNbbR/kzUbHkF6Vm8eq3bd2aHD99
	 VLcg4rMlKQN9w6Lorj4YKivumyPDgov/xHYVVQzyCXD5epYVOua7diDM0ix7ddBWJ0
	 sPUVskX1hajmg4FSpzwSmio2qaCpO6S8irZ6IlVHB63IRd5fxSkPhPH2jm/5UpSP9y
	 F/S2pF7Pb1SQ3+lTqr38YV2+nJ3+9hVEz9XhG2SBr4Nr/7ZItlwLtLuBQ4B+CnTDet
	 IxnpYvE+1PCRIretE12DDJ5wHhQA6Z3/WAtVt4oLM+c/PuVTb0g8jipVLMUH8HIR5R
	 X9EaIrnzRsemA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7B6BD6008E;
	Wed,  9 Sep 2026 01:22:03 +0200 (CEST)
Date: Wed, 9 Sep 2026 01:22:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: skip expired catchall elements
 in dedup walk
Message-ID: <aqCYmZ6_Kc0OqRcR@chamomile>
References: <20260908123252.1162896-1-ljp1205831794@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908123252.1162896-1-ljp1205831794@gmail.com>

On Tue, Sep 08, 2026 at 08:32:47PM +0800, Aohan Mei wrote:
> From: Aohan Mei <henrymei@tencent.com>
> 
> nft_setelem_catchall_insert() looks up duplicates with
> nft_set_elem_active() only, while nft_set_catchall_lookup() and the
> dump path additionally skip expired and dead elements.
> 
> Once a catchall element with a timeout expires, this predicate drift
> makes it invisible to userspace dumps, yet it still blocks
> re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
> without it the request reports success but silently inserts nothing.
> The stale entry only goes away when the (user-tunable) gc interval
> elapses, so the catchall rule may silently stop matching for an
> arbitrarily long time after its first expiration.
> 
> Align the dedup walk with the lookup and dump predicates: only an
> element that is active, not expired and not dead counts as a
> duplicate.
> 
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 765a92fa90d6..6458ee26dcd9 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6995,7 +6995,9 @@ static int nft_setelem_catchall_insert(const struct net *net,
>  
>  	list_for_each_entry(catchall, &set->catchall_list, list) {
>  		ext = nft_set_elem_ext(set, catchall->elem);
> -		if (nft_set_elem_active(ext, genmask)) {
> +		if (nft_set_elem_active(ext, genmask) &&
> +		    !nft_set_elem_expired(ext) &&

This should be:
                    __nft_set_elem_expired(ext, tstamp) 

> +		    !nft_set_elem_is_dead(ext)) {

I don't think dead flag is set on for catchall elements?

>  			*priv = catchall->elem;
>  			return -EEXIST;
>  		}
> -- 
> 2.43.7
> 
> 
