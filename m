Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11317238179
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741770946; cv=none; b=GFZLQploNLN2JSDbf7BQhFz276Wl661Nubs520ptnq6Nr6IXAQummKUwGDHtLHhamYYsO/Iydtm/UHLitthJecpEW1v7VVsX46q977sQwaDUM+4CpAJJFlJkW84ju4+d3Y1Cw97rAcp5sts1eU+SnqF4osvtwPPJz7ZBQ7NBeCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741770946; c=relaxed/simple;
	bh=d2rv7MVv5WOhyuCePOVqr5wAZQiRC4mnGFAn/k8iHJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgkrqCB9komQZXbOyTpZy4JtuumrIWTMTWgtaHm+XSC+eff/zRnsrA6Ep3/iAgEeIviDSvy88vU/f/F7BqU/RaKd35XyFTveI+inrfoBssOQyAzTy/IRbzUFYqoPUKGHoXkeskT07FgkIITDLv/vs1xqXZ+m+CLiZxSBCkuBP6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsIBh-00048d-0S; Wed, 12 Mar 2025 10:15:41 +0100
Date: Wed, 12 Mar 2025 10:15:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexey Kashavkin <akashavkin@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Message-ID: <20250312091540.GA15366@breakpoint.cc>
References: <20250301211436.2207-1-akashavkin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250301211436.2207-1-akashavkin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Alexey Kashavkin <akashavkin@gmail.com> wrote:
> There is an incorrect calculation in the offset variable which causes the nft_skb_copy_to_reg() function to always return -EFAULT. Adding the start variable is redundant. In the __ip_options_compile() function the correct offset is specified when finding the function. There is no need to add the size of the iphdr structure to the offset.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")

But there are more bugs remaining, see below.

> @@ -85,7 +85,6 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
>  	unsigned char optbuf[sizeof(struct ip_options) + 40];
>  	struct ip_options *opt = (struct ip_options *)optbuf;

This is wrong, the array should be aligned to fit struct
requirements, so u32 is needed, or __aligned annotation is needed
for optbuf.

> -	if (skb_copy_bits(skb, start, opt->__data, optlen))
> +	if (skb_copy_bits(skb, sizeof(struct iphdr), opt->__data, optlen))
>  		return -EBADMSG;

This copies to local on stack buffer.

>  		if (found)
> -			*offset = opt->srr + start;
> +			*offset = opt->srr;

This returns a pointer to local on stack buffer.
But that buffer isn't valid anymore when the function
returns.

It might work in case compiler inlines, but better
not rely on this.

Can you make a second patch that places optbuf in the
stack frame of the calling function instead?
