Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78841A6817;
	Mon, 17 Aug 2026 22:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787007019; cv=none; b=oZInIuHFXubqLhqoywDdKXcHazC4yHVFuvJ/FAns2ha5LPIQ1RjZWromjYtpTp/JO3fGikPvNba9tQb3s2fcLIC+Ww6GbfOM3ym2dbDV+LiImOWFJYLtefYEciEYv/NjiD5wo/m0Vw6dExBDbNljU9LHW+x3XVpu5X22Lag93iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787007019; c=relaxed/simple;
	bh=t0pk0+fmJdzm9Wt+n02HLENNPBq8SIjl7PSpGjP6Ohw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2gkEiVQGkj5dN9gVfUZz64YLCtHlz6qxBw1bd6ztpP8Tsa2KFOW2tW36QQHAVIvtLqWSRPbl+lAQQyXNI08lWvmYCOx/16/UPlxiyoMEzHo4obBj5Fa1bRqExEq4YBvsT0FhsnvHnuGfRAxpKXuD0jkGHJq+Adqw6QR7dEkO9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KhWVi2NZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KhWVi2NZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787007009;
	bh=O1VYgOdaO2FRsc7g0ZskhfvwJGf7V2fH33Rwk+qAu9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KhWVi2NZxDoHXqBRCTsDDKSJ23Iv8ZNrbyrIwm5Y2KyEE1qym+VHIeJuRIT+8s69u
	 YBbF25fzjT9AVeoBdo5hyK/GI4DFCxe3PQ2YYaWUagRPaNqSVyio29QYSlv6RgAmR3
	 y5AVnKRsfR8O6qebZflxWOs2OR2BHsOUhgWH6tt7tH0xrm5MzBnjAYKrYDFW7QZxUf
	 FwVmcu2EOdU4a5+UcGd4UT7XojtI61EzOeW836xnEYgruol7XZul6+l2Sb+5Y54HuP
	 UnIODGyqdd8TlVXyd2KEknWE+giBwTwk7w96D1c8MV8sMs0At5gJNrAlvolyWtrcbp
	 RpU+wOZAcSQrQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4315860077;
	Tue, 18 Aug 2026 00:50:09 +0200 (CEST)
Date: Tue, 18 Aug 2026 00:50:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sangho Lee <kudo3228@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_h323: fix get_bitmap()
 overread
Message-ID: <aoOQHtBE1GNDaPou@chamomile>
References: <20260722125714.1389705-1-kudo3228@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260722125714.1389705-1-kudo3228@gmail.com>

On Wed, Jul 22, 2026 at 09:57:14PM +0900, Sangho Lee wrote:
> get_bitmap() first consumes the complete bytes covered by the current bit
> offset and the requested bitmap length.  For totals below 32 bits, it then
> unconditionally reads one more byte for the partial-byte remainder.
> 
> When the total is already byte aligned, there is no remainder.  The
> caller's boundary check correctly permits only the complete bytes, so the
> extra load reads one byte past the supplied PER buffer.  A crafted Q.931
> User-User IE reaches this with a 17-bit sequence extension bitmap starting
> at bit offset 7.  An AddressSanitizer build of the decoder reports:
> 
>   heap-buffer-overflow in get_bitmap
>   decode_seq
>   decode_seq
>   DecodeH323_UserInformation
>   DecodeQ931
> 
> The same condition also excludes a total of exactly 32 bits from the
> alignment shift, producing an incorrect bitmap for unaligned inputs.
> 
> Read a trailing byte only when there is a partial-byte remainder.  Include
> the 32-bit total in the alignment branch.  This makes all start offsets
> and bitmap lengths from 1 through 32 agree with a bit-by-bit reference
> decoder.
> 
> The same input reaches q931_help(), DecodeQ931(), and decode_seq() through
> an nftables Q.931 conntrack helper on current nf.git.  The helper's static
> scratch buffer has tailroom, so in-kernel KASAN does not report this logical
> packet-boundary overread.  A diagnostic check immediately before the load
> does observe bs->cur == bs->end.  No crash, disclosure, or corruption has
> been demonstrated.
> 
> Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sangho Lee <kudo3228@gmail.com>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3..482860d2c 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -228,8 +228,9 @@ static unsigned int get_bitmap(struct bitstr *bs, unsigned int b)
>  		     bytes--, shift -= 8)
>  			v |= (unsigned int)(*bs->cur++) << shift;
>  
> -		if (l < 32) {
> -			v |= (unsigned int)(*bs->cur) << shift;
> +		if (l <= 32) {
> +			if (l & 7)
> +				v |= (unsigned int)(*bs->cur) << shift;
>  			v <<= bs->bit;
>  		} else if (l > 32) {

This branch is now dead code after your update.

>  			v <<= bs->bit;
> -- 
> 2.43.0
