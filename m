Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8C50277A
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790962749; cv=none; b=TV1MuQ+rY+lunLyKFb2Txnxx1Bihu+olz/UiI97got3bFwTP7HLTq1fdFamIlxlg9s/8hR0yz38rIeDGyHv8wUmCVeF8xPcHmXjttVki1vq1UdX7vsTpm6MWW4tivTPFe4a9/Cc1m9vI9pj1D5z7BBOeaBochjivATv1L1jwdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790962749; c=relaxed/simple;
	bh=YPcRUW+aO8c+2ANonG754rpgZzGTi6P0/NW1zPg3CZk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOp2y6dXVmS1V3lgKcyU965hCt7CHUvBzHaLI0+a6ZiCqnWhb3/m/unexZ3mlZZ2yVh0eZDi4ZVvV0tAXBYCTULkNA5Vk6ujG1a3rA2BjPFcKIKOMFfdSBoabIg25lgFih4HvZ3we1Mm3qN9yfooR2kpKCD7+jYuL9MNCrTrjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B4FCC60D1B; Fri, 02 Oct 2026 19:38:58 +0200 (CEST)
Date: Fri, 2 Oct 2026 19:38:58 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: collapse both dev log
 blocks
Message-ID: <ar_sMnP4kaqmdIeS@strlen.de>
References: <20261002124132.13387-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002124132.13387-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Looked like this:
> 
>  if (indev && skb->dev &&
>    skb_mac_header_was_set(skb) &&
>    skb_mac_header_len(skb) != 0) {
> ...
>  }
> 
>  if (indev && skb_mac_header_was_set(skb)) {
> ...
>  }
> 
> LLM (sashiko) claims there is a NULL deref in the second block, because
> it dereferences skb->dev without checking skb->dev != NULL.
> 
> Don't know if `indev && !skb->dev` is even possible:
> NF_HOOK() invocation normally passes skb->dev as the indev argument.
> 
> Instead of cargo-culting additional skb->dev check, lets just merge
> both blocks into one. This gives 2nd block the tighter guards and
> results in a small behavioral change:
> 
> When `skb_mac_header_was_set` is true but `skb_mac_header_len == 0`
> HWADDR was not emitted, but HWTYPE/HWLEN was.  But given 2nd block also
> emits NFULA_HWHEADER based off skb->dev->hard_header_len, that change
> is probably desireable.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

AI review doesn't like this, but I'm not so sure about the comment.

https://sashiko.dev/#/patchset/20261002124132.13387-1-fw%40strlen.de

NFULA_HWADDR (and related) are not univerally available even today,
their presence depends on hook/location that invoked nfnl logger.

NFULA_HWHEADER would even contain the l3 header in the LLM-presented
case. So I think this patch is fine as-is.
