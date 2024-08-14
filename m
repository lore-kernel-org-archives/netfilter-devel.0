Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0631413D52A
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 11:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723634346; cv=none; b=BNrSEL0fsh9FhgpeuoZzyNf3OIispDDDfEQA9/lITwCtsBhgFZzpcz+HPqVpB+jf0dMJMv599smiWix2zosQJWKmCO08kDQC6CZ8k/v7VeD0uI+ayQlh9sANm5H95jXtdX17pkTAAp/7ZowxzvBbJglVdqFjMebnwVoNmqFfoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723634346; c=relaxed/simple;
	bh=bCPveQZF87+6d8V5/KAMD1H/GXGWkUMTEEijFtkKAVg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKzMoJmJHHqV09b+ab8OQ4SlVdxH5e/7sQwnofHo6CWJQVO8OlOwpXqqbRiBB22cz09CPPmdWMzZCUHtZn/bhSHnKudN1eAjAv6YnMtU5K6O+BQKVYe7aCcniLGC2mYdFTTOkkJP4PyVF8zp2L7PU6Uw9tTXWUCW1DCt0cb+apw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46142 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seC1r-00FXhL-Ct
	for netfilter-devel@vger.kernel.org; Wed, 14 Aug 2024 13:19:01 +0200
Date: Wed, 14 Aug 2024 13:18:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] datatype: replace strncmp() by strcmp() in unit
 parser
Message-ID: <ZrySosqAI_hD-Nok@calendula>
References: <20240814110722.274358-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814110722.274358-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Wed, Aug 14, 2024 at 01:07:21PM +0200, Pablo Neira Ayuso wrote:
> Bail out if unit cannot be parsed:
> 
>  ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
>  add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
>                                                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 

Scratch this patch. It breaks limit rate.

> improve error reporting while at this.
> 
> Fixes: 6615676d825e ("src: add per-bytes limit")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/datatype.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index d398a9c8c618..8879ff0523e8 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -1485,14 +1485,14 @@ static struct error_record *time_unit_parse(const struct location *loc,
>  struct error_record *data_unit_parse(const struct location *loc,
>  				     const char *str, uint64_t *rate)
>  {
> -	if (strncmp(str, "bytes", strlen("bytes")) == 0)
> +	if (strcmp(str, "bytes") == 0)
>  		*rate = 1ULL;
> -	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
> +	else if (strcmp(str, "kbytes") == 0)
>  		*rate = 1024;
> -	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
> +	else if (strcmp(str, "mbytes") == 0)
>  		*rate = 1024 * 1024;
>  	else
> -		return error(loc, "Wrong rate format");
> +		return error(loc, "Wrong unit format, expecting bytes or kbytes or mbytes");
>  
>  	return NULL;
>  }
> -- 
> 2.30.2
> 
> 
