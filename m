Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D133120E
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 08:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772785092; cv=none; b=RBpkXGRN6TDTY6ZL1BUZAxAKlVPSa/cmTm3BgCbddEPkqs8paxLuNQLU5RieRblnZ1aO6qYduwMYNhYqBC+Oi46+GHcSUd8Kon0toIeNWRDp1rxuF9MrUHXv4Ca12drcRtz4Lrbtq4uWYU0Ka/WqM3UP4Qs+mqQkom9EfUYSupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772785092; c=relaxed/simple;
	bh=JsHTWRN4ovn3EAiZg+g3NaunCe1djTJi+RjVYSp272Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWArOxUX+OYX+91MQdNkJvIKapsLmuWeTR15u6m+OIAsX7m85TWVhvABvN2VzoOsn5sTlgjVNLIQ4NLHCjs/esUyj4grbahD9wdQTuLU1Geaiw9zFVgXhFrJ7BotKMi1uRoNL+TFIGKK+bo20MB9zvk2SSWFyTEsQymIitEifuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B18A960516; Fri, 06 Mar 2026 09:18:08 +0100 (CET)
Date: Fri, 6 Mar 2026 09:18:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, w@1wt.eu
Subject: Re: [PATCH] netfilter: nft_set_pipapo: fix stack out-of-bounds read
 in pipapo_drop()
Message-ID: <aaqNu3eCF3f5aAvT@strlen.de>
References: <20260306080854.908476-1-qguanni@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306080854.908476-1-qguanni@gmail.com>

Jenny Guanni Qu <qguanni@gmail.com> wrote:
> pipapo_drop() passes rulemap[i + 1].n to pipapo_unmap() as the
> to_offset argument on every iteration, including the last one where
> i == m->field_count - 1. This reads one element past the end of the
> stack-allocated rulemap array (declared as rulemap[NFT_PIPAPO_MAX_FIELDS]
> with NFT_PIPAPO_MAX_FIELDS == 16).

Thanks, patch looks correct to me.

> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 7ef4b44471d3..9fb83fc05848 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1659,7 +1659,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
>  		}
>  
>  		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
> -			     rulemap[i + 1].n, i == m->field_count - 1);
> +			     i == m->field_count - 1 ? 0 : rulemap[i + 1].n,
> +			     i == m->field_count - 1);

Small nit, could you add

	bool last = i == m->field_count - 1;

and then use 'last ? 0 : ..., last) ?

This idiom is used elsewhere in the file as well and I think it makes
this sligthly more readable.

Thanks!
