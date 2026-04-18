Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE00337699;
	Sat, 18 Apr 2026 07:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498569; cv=none; b=a6PxHFgRXjCeLgGbMHDVM+Wvg2NDNd7ThD/mncDBd2uGoB2Y68X5U+1IWXj/PF4zyOk8na0XpOkDsKqS1ZsEuXCGwybA45W4UKIjEVXjtJUAG3ftdOEG7yPZyIuHO9tf1wG5mm3e3wkkzmbn0DEdw+aGYIQIxZk3y4eVC8k5+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498569; c=relaxed/simple;
	bh=7/3SwV8PPQTTy1DPdLQfl/SoOcXOH2LbW4rlA0GSEz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJ8sw9C2z8+8Q5ogqD6KbTcVTSWAfYior1zRfKc500DpDhwTI7fAzNaIzHXFRG6mYYAkWYB0LbRt53tT+0tcSSzN6yYdN6KKjmqkjUoxbSBDa6nM06kkiakBQnICdd+UF/M6sFBh8KipxV3b04pddgUg+NNATMZiUzK6+zfdkI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CvcSpCxX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CvcSpCxX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3C68C60178;
	Sat, 18 Apr 2026 09:49:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776498565;
	bh=F6gZM1mZTcHdDdZO4R/IUMKvlIJ5EzGGT6JFj7rGDxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvcSpCxX/woDIPkDKzHw7o6PW+0cg5deu9zIMlRFX1DwTdD9oSGEmtrNM4GtfoUDt
	 NY7nZi2oUpV+F/y6tmKyMDQ37fh2rs9Xre10wx/hmL94qJAGU/xWbZ7egUbyI83O2R
	 rn3+//iw9SZ+ko41IjZjEyeYXReANr5beFfZIlQGPOX0hJa2GVSfcwv4/mQOgfSthi
	 lQlfeY99iSqPzD6wvReuz8NPeR3N9Bn/dSxvfJ0LtuCVdS93vOOpZzRIDWVJvJ28tj
	 KOusMfb7Vp7IL4Z4X9tbXNUaTSW90wgSydNe8LzmDa14qFQ+0uVgDP/9RRF/vdzfo3
	 MvF3//m9VQbLA==
Date: Sat, 18 Apr 2026 09:49:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH 1/4 nf] netfilter: nft_exthdr: skip SCTP chunk evaluation
 for non-first fragments
Message-ID: <aeM3gmXM43beA3ot@chamomile>
References: <20260417183433.4739-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260417183433.4739-1-fmancera@suse.de>

Hi Fernando,

On Fri, Apr 17, 2026 at 08:34:30PM +0200, Fernando Fernandez Mancera wrote:
> The SCTP chunk matching logic in nft_exthdr relies on SCTP common header
> being present at the transport header offset. For fragmented packets at
> IP level, only the first fragment would match this condition.
> 
> The nft_exthdr could be used in a PREROUTING chain with a priority lower
> than -400. This would bypass defragmentation. In addition, it can be use
> in stateless environments so it should work on a environment where
> defragmentation is not being performed at all.

Yes, and stateless filtering is still a valid configuration, ie.
nf_conntrack is not loaded.

> Add a check for pkt->fragoff to ensure exthdr SCTP only evaluates
> unfragmented packets or the first fragment in the stream.

I would suggest to squash the three small patches to check for
pkt->fragoff in one patch. The three expressions have been already
around for a while (backporting the combo patch that makes the same
logical change should be easy) and it is basically the same logical
change.

Thanks!

> Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/nft_exthdr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 7eedf4e3ae9c..8eb708bb8cff 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -376,7 +376,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
>  	const struct sctp_chunkhdr *sch;
>  	struct sctp_chunkhdr _sch;
>  
> -	if (pkt->tprot != IPPROTO_SCTP)
> +	if (pkt->tprot != IPPROTO_SCTP || pkt->fragoff)
>  		goto err;
>  
>  	do {
> -- 
> 2.53.0
> 
