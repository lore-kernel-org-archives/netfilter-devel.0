Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06733369217;
	Wed,  7 Oct 2026 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402363; cv=none; b=qpJFnxHsOOQPNCklL0e+xyYycVoERcGVpqwQ2zDCiQ/1q5+DK3TTip7+oyOLkYrz9DzjmYOEBU1CKKaqJq6cz2/w3XtYfWBOEj6ROyQcFiqNOw5kFDBzCkLNrxRQsoq+ldpNHI31hWJGg+Pj6tJXfC6VbJRTGIPuUDHP8VEj2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402363; c=relaxed/simple;
	bh=2evHQ67BtuGbu6DdodQt1gtO0n1OQMmoBHpKd9rxEEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5Ob7bI2MCp2kzftoleQwhlaD7ALpG0zciWabbCbbo45+wfUIAFAhuz4DpF1lPy2tpHSPwVzeGP4NxuZQUXuSDkX/tb8AFWCdpQ5dKlqOacqQFLGpEeNySrliYNDXfauBBVi/DjakARGGc6JB/vtctgoj6CyVV/tK7o9R1q6QhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N/SZI/jS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N/SZI/jS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791402358;
	bh=PBKzpjxFihvT/5K97DQm+tI6jz85dcbprw3TS9rl2S4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N/SZI/jSojmayG1m+Tj0/Df02BNEL2jHAlu3sHlJMYJyUUlEv5nwQFmdrmTw+qvDz
	 P71+6usSP14v2/CscRIxBPdp7z4/+oxEatgKlnikPlZRF3BDGOYXf9k88ldHHthcAc
	 ESV3SmRDF1TZm7mH8HcUPHgZ3SH+oygx/yQ9H1ZBMsOGkLYnk+Wi2vvZPTxKBl/UEL
	 vFBGULtIPM/Hi4wazHD6SpWCt8XncykPdSyADiiQ8NUiEfyeIdixe6UNA+Uv2cYj5S
	 5AGTIZi7fz91xwyfLSbwHAs6cqNvm1gHq2/rl+wGkSVI4wPmt0o27b/1yKySoWlsQk
	 HXxYN/QYhX8cA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4CAB160079;
	Wed,  7 Oct 2026 21:45:58 +0200 (CEST)
Date: Wed, 7 Oct 2026 21:45:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Bui Viet Dung <dungvn2345@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_pipapo: skip transaction elements
 during GC
Message-ID: <asahc6ypIusA4OBc@chamomile>
References: <20261007182057.332512-1-dungvn2345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261007182057.332512-1-dungvn2345@gmail.com>

On Thu, Oct 08, 2026 at 01:20:57AM +0700, Bui Viet Dung wrote:
> Since nft_set_commit_update() runs set commit callbacks before processing
> NEWSETELEM transactions, pipapo_gc_scan() can observe elements added by
> the transaction being committed.
>
> The scan evaluates elements in priv->clone without checking the element's
> transaction state. Expired elements are deactivated, dropped from
> priv->clone, and queued for GC reclaim via pipapo_gc_queue().
> 
> When the transaction loop in nf_tables_commit() subsequently processes
> NFT_MSG_NEWSETELEM, it calls nft_setelem_activate() on an element pointer
> that has already been handed off to GC reclaim, causing a
> slab-use-after-free.

You cannot add expired elements.

Elements are either in two states when GC run before the transaction
is processed:

- New (not expired, never)
- Old (expired)

I guess this is triggering because of the rbtree fix, but that is
different issue, because "end interval" has no timeout extension.

> Only consider elements that are fully active in both generations, matching
> the fix applied to nft_set_rbtree in commit 86b6471e690c ("netfilter:
> nft_set_rbtree: skip transaction elements during GC"). Advance first_rule
> by rules_f0 before continuing so the loop proceeds to the next rule.
> 
> Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
> ---
>  net/netfilter/nft_set_pipapo.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 978bb0c0110..48658c09c59 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1745,6 +1745,11 @@ static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
>  		i--;
>  		e = f->mt[rulemap[i].to].e;
>  
> +		if (!nft_set_elem_active(&e->ext, NFT_GENMASK_ANY)) {
> +			first_rule += rules_f0;
> +			continue;
> +		}
> +
>  		/* synchronous gc never fails, there is no need to set on
>  		 * NFT_SET_ELEM_DEAD_BIT.
>  		 */
> -- 
> 2.43.0
> 
