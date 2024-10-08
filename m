Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B881DDC15
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 11:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728387293; cv=none; b=qyOJicU4GjmRS4/LrCfTwPyRTmocAKiDzSbiEOreg1j9eIHn21//3hHUbtGJxv15mXCtvg0Val4ojtqn0bJahsr32qV24qDl9e0QVycV8sFxBfcrvskQHIPwuVHbqzuvKlDyxPfEzitBxoEgc5N4oiAFHSMtbpRBoduM5ViiH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728387293; c=relaxed/simple;
	bh=sE7iluNS0nCJsB/X+A8WJbwChuhDiTvtCEB8E4MRf9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZCQZxPX9hMg+6eLQCQV7+LAXfNuPNumIO6RoE6NRQxASe1xpJx6U9JN8a2C9EOB9leufN5wPhKxDzWCm3nTNtreJ4XjGfF0zJ/oZlWj2rCgtY3jiIv/n+9+1KwgfU3cygZevNw8PclI7ZN914V5VAIHUksbwAHwg+1Da8wwTR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44176 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sy89l-008HMl-TM; Tue, 08 Oct 2024 13:13:36 +0200
Date: Tue, 8 Oct 2024 13:13:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 1/5] expr: add and use incomplete tag
Message-ID: <ZwUT3LGOMW_PPXFr@calendula>
References: <20241007094943.7544-1-fw@strlen.de>
 <20241007094943.7544-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241007094943.7544-2-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Mon, Oct 07, 2024 at 11:49:34AM +0200, Florian Westphal wrote:
> Extend netlink dump decoder functions to set
> expr->incomplete marker if there are unrecognized attributes
> set in the kernel dump.
>
> This can be used by frontend tools to provide a warning to the user
> that the rule dump might be incomplete.

This is to handle old binary and new kernel scenario, correct?

I think it is hard to know if this attribute is fundamental to rise a
warning from libnftnl. It could be just an new attribute that can be
ignored by userspace or not? I think libnftables (higher layer) knows
better what to do in this case, if such new attribute is required or
not.

Or maybe this is a different issue?

> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index e99131a090ed..46346712e462 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -97,9 +97,6 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
>  	const struct nlattr **tb = data;
>  	int type = mnl_attr_get_type(attr);

Why not simplify with:

	if (mnl_attr_type_valid(attr, NFTA_BITWISE_MAX) < 0) {
		tb[NFTA_BITWISE_UNSPEC] = attr;
		return MNL_CB_OK;
        }

I think it is intentional you are doing this at a later stage.

> -	if (mnl_attr_type_valid(attr, NFTA_BITWISE_MAX) < 0)
> -		return MNL_CB_OK;
> -
>  	switch(type) {
>  	case NFTA_BITWISE_SREG:
>  	case NFTA_BITWISE_DREG:
