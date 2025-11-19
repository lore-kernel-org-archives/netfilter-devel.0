Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDA59475
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510958; cv=none; b=OEW/byeqmGQl3T0d7RWeJkF2vizr1uA1dDiwV6UTg1plnXYgTEM3lP4xU4yPY5weK5fjSmMr0N3rZT2NgHtMKHBwF/RrUF7II+KDfMEz1hW+h+VgQ3j8lHH8yGtv9x6opVeHGFDKcx9nRP+bQ0KzfnLlZKuWiIBH73MQHhYZAog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510958; c=relaxed/simple;
	bh=SArMB8zLRB47drvp6fvpCoIzaOiWqGDPa8bZ9C2kUtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OE7sysjnkw83IYDysf13LR3uAPyoorXhs9hUiCcVrag/E4JZsDeAnYqpTl5bZanbmWkgX0kh/7re3xRGTcJfIOZmvhlcC1WjmcfxYAW/Ly5sOwJiyBuwgs9j4u196hCb6wABeZWBdDFrKRy9TUH+UGlaUsQdAzHmUHimCP8xQlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0A5D8604EF; Wed, 19 Nov 2025 01:09:14 +0100 (CET)
Date: Wed, 19 Nov 2025 01:09:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink: bail out batch
 processing with EMLINK
Message-ID: <aR0Kq9G-MD-Cvvdk@strlen.de>
References: <20251118235009.149562-1-pablo@netfilter.org>
 <20251118235009.149562-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118235009.149562-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Stop batch evaluation on the first EMLINK error, ruleset validation is
> expensive and it could take a while before user recovers control after
> sending a batch with too many jump/goto chain.

ok, but...

> Fixes: 0628b123c96d ("netfilter: nfnetlink: add batch support and use it from nf_tables")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nfnetlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 811d02b4c4f7..315240b2368e 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -558,6 +558,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			 */
>  			if (err)
>  				status |= NFNL_BATCH_FAILURE;
> +
> +			/* EMLINK is fatal, stop processing batch. */
> +			if (err == -EMLINK)
> +				goto done;

... but -EINVAL, -ERANGE or any other validation error is also
fatal, so why do we make an exception for -EMLINK?

Is it because -EMLINK indicates we already spent lots of time
hogging cpu in chain validation and continuing will burn more cycles?

But even if thats the case, I'm not sure its the right choice,
we could also spend lots of time without hitting -EMLINK.

Maybe count errors instead and stop after n fatal errors?
Would also help with rcv buffer overflow on too many
netlink errors.
