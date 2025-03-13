Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E822AE68
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741863619; cv=none; b=umKbemBccqfY8KfbN6W2wuG+UmPbB0U7sf7U67lF6heikrg9VTNvpIXfkU2uZYcXIPkHcIF/uN/gXysKXP5ijyYJk6RbBZ0iM1ldY4EIkfGnvFze9paO7FdUN4YS28/z6PId/fyqaEQOvCB3uCTmHob6I8/uIwjQzkmL/UnReOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741863619; c=relaxed/simple;
	bh=zZTnjt3GszuWguJ0Bp+7FbABqLaDaiHj8iQVTGnTBnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYwQbv9f4Zg/aduiTqV5hLm0+9W0SxEsD8DxNViCH0LDnBy1zoCsueVj3FD/7s2Q6KpHpCq6qR5xIcyt8Rv+BA0l2byTYsH+5DPjwx64tRiGptxsA5cFD7qYTfxiVqbVXSfhCChaRru9gCI+W6twmB12SS/eRFWwl6t10lqmtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eUn+Jy9G; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eUn+Jy9G; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eUn+Jy9G";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eUn+Jy9G"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8EEFA602A0; Thu, 13 Mar 2025 12:00:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741863613;
	bh=B7vqpw5vpOl0SpLHCGUQ3YTSBC8lxOSOBV8lOiyYdaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eUn+Jy9GPAdatJI9lOZewROPmKdJIsA//TT9s1lqZg1BKY4MtuzveyL50AvbMauOF
	 RLDyQeG2hOtx05keCR3HfAqVdh8sTY0BsklpytSnv5Ero+5sXSaCbqA0zP1aPKvJ+T
	 54wYgRhMTPo+MplqWZSBzlclgFLHsWKTiN5hkc1M0o7XvZ27s2zpCKUGzMK8i1+Z+d
	 Y3XAFxUszuKb3nSxkAMwwPafBq36JqHw4Ng6UJlqDFaZxPqTfVJNc8PJzfJGGdHgD1
	 Mmu4JuvNJCnAn8k9I5C/WzLa0VWpBCP33Ri5fbC+W5m4hlFd5ZxTa+Fzos2EI2eT8Y
	 AWv+a1lbyGXjw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CA5B6602A0;
	Thu, 13 Mar 2025 12:00:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741863613;
	bh=B7vqpw5vpOl0SpLHCGUQ3YTSBC8lxOSOBV8lOiyYdaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eUn+Jy9GPAdatJI9lOZewROPmKdJIsA//TT9s1lqZg1BKY4MtuzveyL50AvbMauOF
	 RLDyQeG2hOtx05keCR3HfAqVdh8sTY0BsklpytSnv5Ero+5sXSaCbqA0zP1aPKvJ+T
	 54wYgRhMTPo+MplqWZSBzlclgFLHsWKTiN5hkc1M0o7XvZ27s2zpCKUGzMK8i1+Z+d
	 Y3XAFxUszuKb3nSxkAMwwPafBq36JqHw4Ng6UJlqDFaZxPqTfVJNc8PJzfJGGdHgD1
	 Mmu4JuvNJCnAn8k9I5C/WzLa0VWpBCP33Ri5fbC+W5m4hlFd5ZxTa+Fzos2EI2eT8Y
	 AWv+a1lbyGXjw==
Date: Thu, 13 Mar 2025 12:00:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: don't allow merging interval set/map with
 non-interval one
Message-ID: <Z9K6uj8Q51om7NwR@calendula>
References: <20250313093828.736-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250313093828.736-1-fw@strlen.de>

On Thu, Mar 13, 2025 at 10:38:25AM +0100, Florian Westphal wrote:
> Included bogon asserts with:
> BUG: invalid data expression type range_value
> 
> Pablo says: "Reject because flags interval is lacking".
> Make it so.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

thanks

> ---
>  src/evaluate.c                                 | 18 +++++++++++-------
>  .../invalid_data_expr_type_range_value_assert  | 12 ++++++++++++
>  2 files changed, 23 insertions(+), 7 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 7fc210fd3b12..d59993dcdd4e 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5080,15 +5080,19 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  			return table_not_found(ctx);
>  
>  		existing_set = set_cache_find(table, set->handle.set.name);
> -		if (!existing_set)
> -			set_cache_add(set_get(set), table);
> +		if (existing_set) {
> +			if (existing_set->flags & NFT_SET_EVAL) {
> +				uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
> +				uint32_t new_flags = set->flags & ~NFT_SET_EVAL;
>  
> -		if (existing_set && existing_set->flags & NFT_SET_EVAL) {
> -			uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
> -			uint32_t new_flags = set->flags & ~NFT_SET_EVAL;
> +				if (existing_flags == new_flags)
> +					set->flags |= NFT_SET_EVAL;
> +			}
>  
> -			if (existing_flags == new_flags)
> -				set->flags |= NFT_SET_EVAL;
> +			if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
> +				return set_error(ctx, set, "existing %s lacks interval flag", type);
> +		} else {
> +			set_cache_add(set_get(set), table);
>  		}
>  	}
>  
> diff --git a/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert
> new file mode 100644
> index 000000000000..4637a4f9b9df
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_assert
> @@ -0,0 +1,12 @@
> +table ip x {
> +	map y {
> +		type ipv4_addr : ipv4_addr
> +		elements = { 1.168.0.4 }
> +	}
> +
> +        map y {
> +		type ipv4_addr : ipv4_addr
> +		flags interval
> +		elements = { 10.141.3.0/24 : 192.8.0.3 }
> +	}
> +}
> -- 
> 2.45.3
> 
> 
