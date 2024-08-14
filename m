Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8F61B86FF
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 16:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723652369; cv=none; b=e1Hh1QPNWpQ8U5UDhuNsak/ho7UGV1fCUsu+8PJX1wxf+Tc8fXd/ljA2XUXemZUv3JFBpFTfQn/fzcwF4DO/R0/sTPM2QoSfvTwo0x6GqV6ntdxJIIuXo8l0zQVC/pHSU85l3BSeYtV5CGf9raLRfCyUwAt1Qi+hOlx8UmHgwCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723652369; c=relaxed/simple;
	bh=RMYmvBGMs+/88qlWhmwnsPxj7kizN0kpg2AsCC+fkow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJrdXIYcozlzoy9QJ41BF/ZCy3KIrmmXgxWRPj+qGjSo0+IJqrBKesj9DEU+fSvLE95JjrKYGrPN6WqMAUZRchr+YaPO4Y8u3guvpSqIQHwwnEC6wiFBr6h+PCL5IKSgKOOD0wW0iCwS4Z0tugNLXuOyytxajnT8qfWUfYvzlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iH2PwnEG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iH2PwnEG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wPsUYoC85q37+J65w9xo6G8SCevCZPH4KN5iq4H4/qQ=; b=iH2PwnEGtbIkyuqq4Wr/U+eNWI
	vP1uLBHhSCEkx+XgY1JFPwkt7qzA3YzSuWdP6VWrLUhg/trWQhnq1+JcdaswmxBNUmXcyFEUOnz7A
	WuwEG5dGhEEWGY7TPWRTyCoykFzT97aPHwyCYl/nEZVfwad4gBzyrjPsrCzZ9dqr+/wUZJF/vONwQ
	8tmTmfDqs4AXDr6heJvCQnlC7TDnLEmntLaKxH2GqGzL2tv83vYmv3NjUKgdi41uIyF1afsKOVi+h
	aFGcCmMyBGmKBWgYdY4aHxqzujpRuGO1gheFl19uXr9fbUiw4vofdh8rwTIfbrbHRtSHIqeLNkKCS
	YlO+QXkQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seGQh-000000004I7-2jV1;
	Wed, 14 Aug 2024 18:00:55 +0200
Date: Wed, 14 Aug 2024 18:00:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240814115122.279041-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814115122.279041-1-pablo@netfilter.org>

On Wed, Aug 14, 2024 at 01:51:21PM +0200, Pablo Neira Ayuso wrote:
> Bail out if rate are used:
> 
>  ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
>  add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
>                                                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> improve error reporting while at this.
> 
> Fixes: 6615676d825e ("src: add per-bytes limit")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: - change patch subject
>     - use strndup() to fetch units in rate_parse() so limit rate does not break.
> 
>  src/datatype.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index d398a9c8c618..297c5d0409d5 100644
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
> +		return error(loc, "Wrong unit format, expecting bytes, kbytes or mbytes");
>  
>  	return NULL;
>  }

I have local commits which introduce KBYTES and MBYTES keywords and
thereby kill the need for quota_unit and limit_bytes cases in
parser_bison.y. It still needs testing and is surely not solving all
issues there are, but I find it nicer than the partially redundant code
we have right now.

My motivation for this was to maybe improve parser's ability to handle
lack of spaces in input. I still see the scanner fall into the generic
"string" token case which requires manual dissection in the parser.

What is your motivation for the above changes? Maybe we could collect
parser limitations around these units and see what helps "the most"?

Cheers, Phil
