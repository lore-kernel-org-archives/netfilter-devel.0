Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728CC19C554
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 19:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750707562; cv=none; b=GhERT+UJp27gk/WIWx76BKUrm3FZYrijD4ZpU8cw2FOmlc/kiz9xN+E4CA1vxb6pexPz9WUpswZXMYUnvDA3M+oopLFvcFaolr37Cue8LNL8Rrb0oz9A/q8woM/B8ml9diCNRg9M2Ysph4oX3NbjcEXsC5SFV9LS6BvmenqSMxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750707562; c=relaxed/simple;
	bh=21e054bPDvDMG3uSIjba3JTxpYRxrq7bZZ+FWdi1psg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CiFrxvkKMAU52SR7gkBcRGwy0GQYoqP0BCSiamZ6pciXT2nsnvGXfkzR8x+iC3t3V9M3ltcP3eoVeMz9sgPXqeY4xbkF49XIbn8jz0x7au0b0Y7PXWJxVJ37i1LpIZZRMgqRH4Zg377ledsESdVbtXYOhu59SAA3bWyKbpEa8pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 652A9602AA; Mon, 23 Jun 2025 21:39:17 +0200 (CEST)
Date: Mon, 23 Jun 2025 21:39:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: refuse to merge set and map
Message-ID: <aFmtZfDQeObDuZ-q@strlen.de>
References: <20250623132225.21115-1-fw@strlen.de>
 <aFl_HmQG7vJZ1u9O@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFl_HmQG7vJZ1u9O@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> static inline bool set_is_map(uint32_t set_flags)
> {
>         return set_is_datamap(set_flags) || set_is_objmap(set_flags);
> }
> 
> then, I'd suggest
> 
> 		if (set_is_datamap(existing_set->flags) != set_is_datamap(set->flags))
>                         ...
> 		if (set_is_objmap(existing_set->flags) != set_is_objmap(set->flags))
>                         ...
> 
> Thanks.

Right, I sent a v2 that checks both map flavours.
