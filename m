Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B79BE49
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738024223; cv=none; b=kD51nebLQr1i1qqkSQKMWbzZ/GuqdGU1gsyjZZ0y+Z2bqg9BXgXzI6kXeymRpZLnR716w0YfzDshv+U9LlJ4NKlnwUbjp0QDyMNaPBjgKWrMIvkGnoUOwcVkQLPlk4KADGXJ9+/iY8WIIBqIwPzaSU5aeqWlGvumuXSVNdsFw+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738024223; c=relaxed/simple;
	bh=1ju4xK2aBXRogWf+o0SxJxQSZ7cI+VzhXdYTAUSLKH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYT/oXzA18hOVMu5e42iWMdVr/9E4Gr59eddDV/BwQvynB6jEiyM+H+bNxasymhRKDI7ODmCBOprfjiMeOtcjSlk/3afl17pf3IvlUsy2vaC+bGq6pgjVcN0HjF0a8E2eXdOyMY8xy1SxXvt8lixc3qPe1UvpUUR1aoqJg8hP+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tcZUa-0007ov-6g; Tue, 28 Jan 2025 01:30:12 +0100
Date: Tue, 28 Jan 2025 01:30:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: reject mismatched sum of
 field_len with key length
Message-ID: <20250128003012.GA29891@breakpoint.cc>
References: <20250127234904.407398-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127234904.407398-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The field length description provides the length of each separated key
> fields in the concatenation. The set key length provides the total size
> of the key aligned to 32-bits for the pipapo set backend. Reject with
> EINVAL if the field length description and set key length provided by
> userspace are inconsistent.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_set_pipapo.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 7be342b495f5..3b1a53e68989 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -2235,6 +2235,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  	struct nft_pipapo_match *m;
>  	struct nft_pipapo_field *f;
>  	int err, i, field_count;
> +	unsigned int len = 0;
>  
>  	BUILD_BUG_ON(offsetof(struct nft_pipapo_elem, priv) != 0);
>  
> @@ -2246,6 +2247,12 @@ static int nft_pipapo_init(const struct nft_set *set,
>  	if (field_count > NFT_PIPAPO_MAX_FIELDS)
>  		return -EINVAL;
>  
> +	for (i = 0; i < field_count; i++)
> +		len += round_up(desc->field_len[i], sizeof(u32));
> +
> +	if (len != set->klen)
> +		return -EINVAL;
> +

I fail to grasp why nft_set_desc_concat() doesn't catch it:

        for (i = 0; i < desc->field_count; i++)
                num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));

        key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
        if (key_num_regs != num_regs);	----> here....
                return -EINVAL;

