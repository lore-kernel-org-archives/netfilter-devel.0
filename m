Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6052F4318
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2025 22:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682221; cv=none; b=PSPZb3G8KQD8otNLCz9lK02+Za/0IYQHOdnQWj8tkxI5CSdxLWD/c+xvgiflNYR1fU+CS90dA0P9/dhcWUOGP4kPxiH3lHPDHIx1DznYODI6aGDYp8VGURGrqVtSy4HnIk88yfjjJ0jDfLPybNd6Ogv3NQXhOoENPwwPW33P5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682221; c=relaxed/simple;
	bh=R6bYiMMKEPppCxDsc2dJrL0dsn+Wu8lhYZxFTn5TTFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYFeEt/WcOllWTk/15yH93RMF9JvaMihJJdbU4HRXjPSYIcn4+wqWCKoo/PJTegTqpANdLjst4emTnAJQYmISsNhLF2uemOrj0vvw9cg6BFuAmsE6wBp5EszxnW1pXeE4GvfgelnIohhZaTMPoOELWMB4SLUUX1ToqUnhbtTb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N72gIZD0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N72gIZD0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N72gIZD0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N72gIZD0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9C125605EC; Thu, 12 Jun 2025 00:50:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749682215;
	bh=xzMjzo8O5ZThIbA1e2JwPUiiuRsVdRV2y1HDhi9ZEKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N72gIZD0lsUVHIKUFh0qsIsVQpDW3VT8CK+/IboqDaqhq2WtUP9Cif0WH6LOELo0Z
	 khttvAkq3AKybUvd5evQ/Vu3SOhi6iNAwjB53WWmWolg34gWUNicKj75qLGkERMdUU
	 P0ibmJXYylbbh9sWg7h3rmYwR3FrRqwv/lDxvOTCusBe1psThF6Y/NtjoneqTlV9f6
	 X/2KiEbegLXksyIhw7Mv8i4wrx4luccXO+8eU7oDWXG4KEbRDWvHNQCAWxING9HBS4
	 20VIENJ+ZwRIu+Phc8bWBrHYdcKB4ukquXQSomjkE+V4i+TqX4MEj7SmpKV7+TomRc
	 kL1+2PjVQtGGA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EDBE1605E9;
	Thu, 12 Jun 2025 00:50:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749682215;
	bh=xzMjzo8O5ZThIbA1e2JwPUiiuRsVdRV2y1HDhi9ZEKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N72gIZD0lsUVHIKUFh0qsIsVQpDW3VT8CK+/IboqDaqhq2WtUP9Cif0WH6LOELo0Z
	 khttvAkq3AKybUvd5evQ/Vu3SOhi6iNAwjB53WWmWolg34gWUNicKj75qLGkERMdUU
	 P0ibmJXYylbbh9sWg7h3rmYwR3FrRqwv/lDxvOTCusBe1psThF6Y/NtjoneqTlV9f6
	 X/2KiEbegLXksyIhw7Mv8i4wrx4luccXO+8eU7oDWXG4KEbRDWvHNQCAWxING9HBS4
	 20VIENJ+ZwRIu+Phc8bWBrHYdcKB4ukquXQSomjkE+V4i+TqX4MEj7SmpKV7+TomRc
	 kL1+2PjVQtGGA==
Date: Thu, 12 Jun 2025 00:50:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft] mnl: catch bogus expressions before crashing
Message-ID: <aEoIJIGoTF4abPtd@calendula>
References: <20250605222039.31719-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250605222039.31719-1-fw@strlen.de>

On Fri, Jun 06, 2025 at 12:20:28AM +0200, Florian Westphal wrote:
> We can't recover from errors here, but we can abort with a more
> precise reason than 'segmentation fault', or stack corruptions
> that get caught way later, or not at all.
> 
> expr->value is going to be read, we can't cope with other expression
> types here.
> 
> We will copy to stack buffer of IFNAMSIZ size, abort if we would
> overflow.
> 
> Check there is a NUL byte present too.
> This is a preemptive patch, I've seen one crash in this area but
> no reproducer yet.

I don't see how this can happen yet, but I like this sanity checks.

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/mnl.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 64b1aaedb84c..6565341fa6e3 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -732,9 +732,20 @@ static void nft_dev_add(struct nft_dev *dev_array, const struct expr *expr, int
>  	unsigned int ifname_len;
>  	char ifname[IFNAMSIZ];
>  
> +	if (expr->etype != EXPR_VALUE)
> +		BUG("Must be a value, not %s\n", expr_name(expr));
> +
>  	ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
>  	memset(ifname, 0, sizeof(ifname));
> +
> +	if (ifname_len > sizeof(ifname))
> +		BUG("Interface length %u exceeds limit\n", ifname_len);
> +
>  	mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN, ifname_len);
> +
> +	if (strnlen(ifname, IFNAMSIZ) >= IFNAMSIZ)
> +		BUG("Interface length %zu exceeds limit, no NUL byte\n", strnlen(ifname, IFNAMSIZ));
> +
>  	dev_array[i].ifname = xstrdup(ifname);
>  	dev_array[i].location = &expr->location;
>  }
> -- 
> 2.49.0
> 
> 
