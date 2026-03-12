Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5302388E74
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 10:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773312751; cv=none; b=IMDRW2VJKmuTOBHUL5qCxN6dGG3yky04I5/czhiVGqT/0hYFF9MWTo+E1uW+ektKZfp0eZPkUN8I0YTNOzpgA+xFn3JxUFYDR4sdRUCTGrzjGakH6VK+DwtoUn2+5cMfybWRRlXrRiMvun3bBKkFS0CPMFKa9EgHrwGeJWb9Pko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773312751; c=relaxed/simple;
	bh=X1Us7bk99aFOJ6FHYu9wpgQhj46G04WurKIWm7He0FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Op+E8LGbHrbb57EnBpYc3CqNhQCxY/ofwMLdgIXJzxpVJvKyomzmV/u7ke1yJcjayHaTAMHOE5/vaZDnYPq3hr6nNNJ0TdGaKN5qy9i2SX8Rxe4yMVGJvUziaJtQ374HRjokDr75TD4kB8i/3gwEy/qaerOB+sNfStJ9SqSQcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7C07460470; Thu, 12 Mar 2026 11:52:27 +0100 (CET)
Date: Thu, 12 Mar 2026 11:52:23 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?6ZKx5LiA6ZOt?= <yimingqian591@gmail.com>
Cc: security@kernel.org, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY][netfilter][nf_tables] stack out-of-bounds read in
 nft_set_pipapo pipapo_drop()
Message-ID: <abKa5xR6V9D9BhjM@strlen.de>
References: <CAL_bE8LMSUQ+Ls8bP4D32kOiJH=-UqgVKgjSAk7nA0G=+XzveA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_bE8LMSUQ+Ls8bP4D32kOiJH=-UqgVKgjSAk7nA0G=+XzveA@mail.gmail.com>

钱一铭 <yimingqian591@gmail.com> wrote:
> 2) Root cause explanation
> rulemap is a fixed-size stack array:
> union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
> When m->field_count == NFT_PIPAPO_MAX_FIELDS (16), the last iteration has i
> == 15. pipapo_drop() still evaluates:
> rulemap[i + 1].n
> which becomes rulemap[16].n, i.e. out-of-bounds read from stack.
> Important detail: although is_last == true and pipapo_unmap() immediately
> returns, the function argument rulemap[i + 1].n is already evaluated before
> the callee runs. So the OOB read is unconditional in that final iteration.
> ------------------------------
> 3) Reproducer summary
> Userspace netlink PoC sequence:
> 
>    1. NFT_MSG_NEWTABLE
>    2. NFT_MSG_NEWSET with flags NFT_SET_INTERVAL | NFT_SET_CONCAT
>    3. set key length 64
>    4. set concat descriptor with 16 fields, each field length 4
>    5. NFT_MSG_NEWSETELEM add one element
>    6. NFT_MSG_DELSETELEM delete same element
> 
> This reaches:
> nf_tables_delsetelem -> nft_setelem_remove -> nft_pipapo_remove ->
> pipapo_drop

Could you confirm this is fixed by this patch?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260306191238.937530-1-qguanni@gmail.com/

Thanks!
