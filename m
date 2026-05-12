Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9013839B1
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 23:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778628341; cv=none; b=DB+MUfFpOdRiR3w/AgVvSEfqlaaPS36KtCy203WkJkh8+a8rYy5+jVl6bb5DUvjYEssZItJzSHvSYlTL1nx2FdQN9fXlY5S7xCz4kH3sv7EOsRCvbTe3KUUNew1iMU8GfJyA9CL1g1av7MJU5v736pC6IdAc5XWsP3enu7f4y20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778628341; c=relaxed/simple;
	bh=EYheQIsDtWtVaZlyZvuu9XfTYFj76GYYDSvOkyOwlnY=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBBmCG+noCzTl2G6ULL326OZbYjOSlPAWp4de+Kj16liWgfgqN4C+uQG4Vwyyc4PBjbjh+LEXa1IorW9BO7sGN5x6LzwNQ1nCWcFek0C9tA5jdimy7OxRkmuk56q2gk9M7maYOQlKLqMi4+L9vdozyaU2w6yQE69TtgJdxU8pUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B320560D66; Wed, 13 May 2026 01:25:36 +0200 (CEST)
Date: Wed, 13 May 2026 01:25:32 +0200
From: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_queue: hold reference on skb->dev
Message-ID: <agO27EBuW7aLbdqu@strlen.de>
References: <20260512224417.812214-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512224417.812214-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Before NF_BR_LOCAL_IN, skb->dev is mangled in a way that results in
> state->in != skb->dev, which can result in UaF when accessing the bridge
> device if removed while in the queue.
> 
> Reported-by: Ren Wei <n05ec@lzu.edu.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_queue.c        | 6 ++++++
>  net/netfilter/nfnetlink_queue.c | 3 +++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index a6c81c04b3a5..9c6741673842 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -59,8 +59,11 @@ static void nf_queue_sock_put(struct sock *sk)
>  static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>  {
>  	struct nf_hook_state *state = &entry->state;
> +	struct sk_buff *skb = entry->skb;
>  
>  	/* Release those devices we held, or Alexey will kill me. */
> +	if (skb->dev)
> +		dev_put(skb->dev);

dev_hold/put(NULL) is safe, no need for NULL guard (and no need
to resend).

Thanks for making a patch.  I'll make a patch for the pptp/gre bug in
case reporter remains silent.
