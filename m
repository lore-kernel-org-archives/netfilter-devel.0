Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168E2E1730
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766069050; cv=none; b=ae/QQFYx6WKEhJGeDawd6brFt+lUEMisRYNDVSKKvEnAPjDbePOqQiFgA9EctBIjxN1Uj8+BOMQptEdEJF4n70JDYqgsQyS79Z5Q+UTHst8PPNHQfAu69ajvLpgLQRVjVBZvL+2haHcdTylup0fUYyYYaUmYS5eM7XsXnQZ0bts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766069050; c=relaxed/simple;
	bh=OIia6jvL53WV4r54vcnqnYEIy1xeqfmkHUclY7VuhLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOeruUhrkvR8zxUDR/tM08oChoNLhiml7epvFPD8pBpZpwD+8alIA+oXv76fZ5nu8GXMhWAuT+Yc7ir9FuzC3rK0YIVpYnuD19Y7Ou8oiFqHABTcfnrgpcFvk/g/HbBacIQ8TyqbjErAne+NhsBlxgEhdQurLdXv4SBQ4JF5A9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y7+gcueD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y7+gcueD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j665BdJKhLjq9Q/5uw760s7rBDpAcz9zTOHNaLR0jx4=; b=Y7+gcueDSPlR9Opa54AqlNNB7Y
	LchHru4+miz9nLoy85fn1ROp+cPRQPLz6j2kwmxOezhzEKC+lO5xsYGmYbnEqFMjZvwSRNpMTfuhF
	/jjqsGFIxa58tA4XyZG0QzECa3ne+UIbdTEBwHA7lvN88y36rOLAxKzfzvk7/DJZkMbN+1jVTDZ1E
	jsw8n1sE0vRb51HzG0PAEvTaZy80Tdy7lpCJgZb4VEgSyO51ffiqbO5AnQYKjC8Go22DYh81xYrPR
	d+sHn5g/nkLDQrSQDkU3Ph2mqxPq7/caJGZOgXWcuBhLvRFNhda0XOgU7fV+cuPCSjRMDTH5oP80C
	AuQk3JPw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vWFEb-000000002cM-3N3i;
	Thu, 18 Dec 2025 15:44:05 +0100
Date: Thu, 18 Dec 2025 15:44:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Global buffer overflow in parse_ip6_mask()
Message-ID: <aUQTNcIKD-7YzYQQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>

Hi,

On Thu, Dec 18, 2025 at 04:15:05PM +0300, Ilia Kashintsev wrote:
> Hello maintainers! I have found several global buffer overflows in
> useful_functions.c
> 
> They both occur in the function parse_ip6_mask() and are caused by
> unconditionally writing to p[16].
> 
> The first overflow occurs when bits is equal to 128,
> which causes p[bits / 8] = 0xff << (8 - (bits & 7)); to write at p[16].
> 
> The second overflow occurs when bits is equal to 8,
> which causes memset(p + (bits / 8) + 1, 0, (128 - bits) / 8); to write
> 15 bytes starting at p + 2, which leads to the same issue.

Funny how broken the code is, given its age.

[...]
> diff --git a/useful_functions.c b/useful_functions.c
> index 133ae2f..a8dfcbc 100644
> --- a/useful_functions.c
> +++ b/useful_functions.c
> @@ -364,8 +364,12 @@ static struct in6_addr *parse_ip6_mask(char *mask)
>         if (bits != 0) {
>                 char *p = (char *)&maskaddr;
>                 memset(p, 0xff, bits / 8);
> -               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> -               p[bits / 8] = 0xff << (8 - (bits & 7));
> +               if (bits & 7) {
> +                       memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> +                       p[bits / 8] = 0xff << (8 - (bits & 7));
> +               } else {
> +                       memset(p + (bits / 8), 0, (128 - bits) / 8);
> +               }
>                 return &maskaddr;
>         }

The reason why the second memset() call may mis-behave is the broken
div-round-up in there: It does (bits / 8) + 1 when it should do
(bits + 7) / 8 instead. Fixed that, only the p[bits / 8] field access
needs to remain conditional:

@@ -364,8 +364,9 @@ static struct in6_addr *parse_ip6_mask(char *mask)
        if (bits != 0) {
                char *p = (char *)&maskaddr;
                memset(p, 0xff, bits / 8);
-               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
-               p[bits / 8] = 0xff << (8 - (bits & 7));
+               memset(p + (bits + 7) / 8, 0, (128 - bits) / 8);
+               if (bits & 7)
+                       p[bits / 8] = 0xff << (8 - (bits & 7));
                return &maskaddr;
        }

What do you think?

Cheers, Phil
