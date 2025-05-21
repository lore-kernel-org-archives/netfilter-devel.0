Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9851313BC02
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837076; cv=none; b=Y7dLvIavTUARc5jDbyYhWMuIClh68/IhrudZONoFgg/GO4TEHOnHt5O8ytfL2/MVkEVor7zP0bQJ0k1GgHbUaVeQvvhtcqU4IpzDLS2HCAaVsIV4dn2SUb/o+Wsueu/6q+yFYBe7+xDjo+36HdiujFcqcRPoFVRhD3D/f30atTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837076; c=relaxed/simple;
	bh=gzUyElzSYr8ccu/duMixLAtb6knvM5824TJSTRTIdks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxis19nF7TieKfQZ4LE8gjWESYd3gOA4jivQF9u+QzkwXzdI78muG7+44mYEpgKTtZtDOsZbQWTB4y19Bzw7Mp8Es3QgZ+X770pWtBt5TwGsvTdnr6Db/jkye+vdGEVqMciDZ88zrI0lLoMJiEHQpt1Zzx64OCpHkvboTJ7+wHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=k0+llrew; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=k0+llrew; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="k0+llrew";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="k0+llrew"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E6F976070A; Wed, 21 May 2025 16:17:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747837072;
	bh=zRaKmToK3SdMGPtJxBzF3VsPiE0PHrDHDJTwli4g6oU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0+llrewUml6o6EVgtPs15uSvek4UJnGquj5UpspYYBR2efa8dek2K+GYUwnpREUC
	 CI789mkUTdSTwcO+aIWhcLIUI6GUYld4vKcovHO1zL+UvmGjiReyVypY3JGQ9Hrst/
	 COkc2Wn6JjNKsw1RlQpSpXf/Qfgm/vEKX7eI1a0MRWNHPaUK6AazrW5XdTJrIzudS8
	 1+xOvv7mPcccGnBcl7I1N9iDVYetQ38wIMtab1gsKUN4lbSymEzPB6Ce1ARHRRIcSs
	 6cAwpau+Ei9seFM9KMcAiRUlOES7u5OfXbM3NB7o4lpUUW/F/nl5TfoA1GvYf087XN
	 osDtVcUwfxjmA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 28FB8606E0;
	Wed, 21 May 2025 16:17:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747837072;
	bh=zRaKmToK3SdMGPtJxBzF3VsPiE0PHrDHDJTwli4g6oU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0+llrewUml6o6EVgtPs15uSvek4UJnGquj5UpspYYBR2efa8dek2K+GYUwnpREUC
	 CI789mkUTdSTwcO+aIWhcLIUI6GUYld4vKcovHO1zL+UvmGjiReyVypY3JGQ9Hrst/
	 COkc2Wn6JjNKsw1RlQpSpXf/Qfgm/vEKX7eI1a0MRWNHPaUK6AazrW5XdTJrIzudS8
	 1+xOvv7mPcccGnBcl7I1N9iDVYetQ38wIMtab1gsKUN4lbSymEzPB6Ce1ARHRRIcSs
	 6cAwpau+Ei9seFM9KMcAiRUlOES7u5OfXbM3NB7o4lpUUW/F/nl5TfoA1GvYf087XN
	 osDtVcUwfxjmA==
Date: Wed, 21 May 2025 16:17:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] netlink: Keep going after set element parsing
 failures
Message-ID: <aC3gjbdJ_z8gewqd@calendula>
References: <20250521131242.2330-1-phil@nwl.cc>
 <20250521131242.2330-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250521131242.2330-4-phil@nwl.cc>

On Wed, May 21, 2025 at 03:12:41PM +0200, Phil Sutter wrote:
> Print an error message and try to deserialize the remaining elements
> instead of calling BUG().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/netlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 1222919458bae..3221d9f8ffc93 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -1475,7 +1475,9 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
>  		key->byteorder = set->key->byteorder;
>  		key->len = set->key->len;
>  	} else {
> -		BUG("Unexpected set element with no key\n");
> +		netlink_io_error(ctx, NULL,
> +			         "Unexpected set element with no key\n");
> +		return 0;

If set element has no key, then something is very wrong. There is
already one exception that is the catch-all element (which has no
key).

This is enqueuing an error record, but 0 is returned, I am not sure if
this is ever going to be printed.

I am not sure this patch works.

>  	}
>  
>  	expr = set_elem_expr_alloc(&netlink_location, key);
> -- 
> 2.49.0
> 
