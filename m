Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D638424D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 23:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772581856; cv=none; b=WrmLG6eGYfptkXQxoumoM0BRtSwqgx7h2Hg7bBL1PYLk7aKjrqPVe90x8aM/19wOFmFFS6YKMXB7HmfTGzHE2sLcEq2CKjcTZz4BhJ7rAnZCvRjcu6ouRCGZn+QnVsX+li8OUUpJALzMMLwWzqayUBBG5+9QyZG2DbkfNxNgc+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772581856; c=relaxed/simple;
	bh=iTa5trKzAyJGXAh8BvJym0h2GlhKubfq8rwWxSSAwdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYtU5gqJOQls/G06R6on2w0CVMAhRbO6RFaRuO0zkMKkTRWRdtMQRW1O7jZSYQVYev5Kle/BazTrw48vK07xPx0DBjgnzancxTd+WXqz50EG2v7N6z3Pv3TiLbBxYI9x8aKaHygIiQOZsd/sx6mHma1ttPrWJ+i5O/LwXmvTG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DC06C6047A; Wed, 04 Mar 2026 00:50:42 +0100 (CET)
Date: Wed, 4 Mar 2026 00:50:43 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: sbrivio@redhat.com, Yiming Qian <yimingqian591@gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_pipapo: split gc in unlink and
 reclaim phase
Message-ID: <aadz0xl4LE797LS6@strlen.de>
References: <20260303190218.19781-1-fw@strlen.de>
 <20260303190218.19781-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303190218.19781-2-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> index eaab422aa56a..4a5baebabaa5 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -156,12 +156,14 @@ struct nft_pipapo_match {
>   * @clone:	Copy where pending insertions and deletions are kept
>   * @width:	Total bytes to be matched for one packet, including padding
>   * @last_gc:	Timestamp of last garbage collection run, jiffies
> + * @to_free:	single-linked list of elements to queue up for memory reclaim
>   */
>  struct nft_pipapo {
>  	struct nft_pipapo_match __rcu *match;
>  	struct nft_pipapo_match *clone;
>  	int width;
>  	unsigned long last_gc;
> +	struct nft_pipapo_elem *to_free;
>  };
>  
>  struct nft_pipapo_elem;
> @@ -169,10 +171,12 @@ struct nft_pipapo_elem;
>  /**
>   * struct nft_pipapo_elem - API-facing representation of single set element
>   * @priv:	element placeholder
> + * @to_free:	list of elements waiting for mem reclaim
>   * @ext:	nftables API extensions
>   */
>  struct nft_pipapo_elem {
>  	struct nft_elem_priv	priv;
> +	struct nft_pipapo_elem  *to_free;
>  	struct nft_set_ext	ext;

Pablo points out that we don't need this extra member.

Instead we'll chain nft_trans_gc containers via their list_head
members and just defer posting the gc containers to the gc engine.

So overall idea remains the same.
