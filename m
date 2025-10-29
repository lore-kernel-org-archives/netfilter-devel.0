Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196D135580A
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762478; cv=none; b=A/12q7gNazccjbvZHxd6NVObzMhP+UIz21e9ST1U/qogfAjNedJyYKDUeJeXKoYNrL2Oc+T7M/Vmr64hFBLZutAoRS40Rm2/R7nIisOCx8cnpIPQO8PKRCsx3ygn7hpu3oe22HbX/AHIXCtQjsgvTid3ZKcCUmQR1lJOGZfi5Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762478; c=relaxed/simple;
	bh=UQyrIf/AG3FTIaVHML3MtrzJFbvhExVr0XaLG5Dg3/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPtNXmHfOHoOBPiRPGuFma3HzUlyvZys6OSXnXdIBKJTnB1jfPP8CZWpyM81MNMrFeilQUhN1dJDJW7txGdZFRa1jNhhsIb9eURxsZmImL9/mYlNij0bBKJu1DmR0GI3HDq+6xT9KfoK3M7ceSrnzs5lBfWXao6xOZ0jUeZOGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T1CTFmYY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T1CTFmYY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0936E6029D;
	Wed, 29 Oct 2025 19:27:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761762474;
	bh=/Q/qzuCP/RHykNVhBJZVY/wgTpRsgcNankQboQHo8J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1CTFmYYCbkXkabtmswyBDoNTi5BiGCHTpo16U60lc0doJeGHIOyPWkImCHIMKSWg
	 17xxYGbaePckDXxyYeYUpCI3rwqxXrrQFhdUf/uz47+ubitIgwnjdNg6XSRVCgB4hP
	 VPZUZWE817VklZ00fV/h7hULIRD23jLCnrFrJy4eeOVY2T6/1zn2gZGU/Hrzxwjttp
	 v9nmkdlTbn5Kuwy6ED+WBoDvpR9AgfgAgBDcNGq3KTeXG5BSSS88f4bFBvATp834xW
	 6PQK4wWjPlCya0c/CTr/IqtWA8bhQa5SqYC6v9SmwIHAtNNEY550Npt87/kfeFaeub
	 xqRpTuqZkiJAg==
Date: Wed, 29 Oct 2025 19:27:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 22/28] mergesort: Linearize concatentations in
 network byte order
Message-ID: <aQJcp6mTvWz2uWMx@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-23-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-23-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:14:11PM +0200, Phil Sutter wrote:
> Results are more stable this way.

Why? Sorry, but maybe this series is oversplit? It is a bit complicate
to follow the rationale where all this small patches are taking us.

I find that a single patch with a oneliner explaination.

Question: Does tests/shell and tests/py work if I stop at any random
patch in this series?

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/mergesort.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/mergesort.c b/src/mergesort.c
> index bd1c21877b21d..95037e5be8608 100644
> --- a/src/mergesort.c
> +++ b/src/mergesort.c
> @@ -20,11 +20,11 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
>  
>  	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
>  		ilen = div_round_up(i->len, BITS_PER_BYTE);
> -		mpz_export_data(data + len, i->value, i->byteorder, ilen);
> +		mpz_export_data(data + len, i->value, BYTEORDER_BIG_ENDIAN, ilen);
>  		len += ilen;
>  	}
>  
> -	mpz_import_data(value, data, BYTEORDER_HOST_ENDIAN, len);
> +	mpz_import_data(value, data, BYTEORDER_BIG_ENDIAN, len);
>  }
>  
>  static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
> -- 
> 2.51.0
> 
